# @title Varsayılan başlık metni
import nest_asyncio
import pandas as pd
import numpy as np
import requests
from fastapi import FastAPI
import uvicorn
from pyngrok import ngrok
from statsmodels.tsa.statespace.sarimax import SARIMAX
from sklearn.ensemble import RandomForestRegressor
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, LSTM
import random
import tensorflow as tf
import json
from sklearn.metrics import mean_absolute_error, mean_squared_error
import itertools


# Asenkron işlemi yönetebilmek için nest_asyncio kullanılıyor.
nest_asyncio.apply()

# FastAPI uygulaması oluşturuluyor
app = FastAPI()

# Rastgelelikği sabitleme
np.random.seed(42)
random.seed(42)
tf.random.set_seed(42)

# Veri çekme fonksiyonu
def get_bitcoin_data():
    url = "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart"
    params = {"vs_currency": "usd", "days": "365", "interval": "daily"}
    response = requests.get(url, params=params)
    response.raise_for_status()
    data = response.json()
    prices = data["prices"]
    df = pd.DataFrame(prices, columns=["timestamp", "price"])
    df["timestamp"] = pd.to_datetime(df["timestamp"], unit="ms")
    df.set_index("timestamp", inplace=True)
    return df

# Veri çekiliyor
bitcoin_data = get_bitcoin_data()

# 2024 Ocak - 27 Aralık arası veriyi kullanma
train_data = bitcoin_data["2024-01-01":"2025-01-14"]
test_steps = 30  # 1 Ay (30 Gün) tahmin yapılacak

# SARIMAX Modeli
def sarimax_forecast(train, steps):
    best_aic = np.inf
    best_order = None
    best_seasonal_order = None
    best_model = None


    p = d = q = range(0, 2)
    seasonal_pdq = [(x[0], x[1], x[2], 7) for x in list(itertools.product(p, d, q))]

    for param in itertools.product(p, d, q):
        for seasonal_param in seasonal_pdq:
            try:
                model = SARIMAX(train, order=param, seasonal_order=seasonal_param)
                result = model.fit(disp=False)
                if result.aic < best_aic:
                    best_aic = result.aic
                    best_order = param
                    best_seasonal_order = seasonal_param
                    best_model = result
            except:
                continue

    print(f"En iyi SARIMAX modeli: Order={best_order},Seasonal Order={best_seasonal_order},AIC={best_aic}")

    forecast = best_model.forecast(steps=steps)
    return forecast

sarimax_predictions = sarimax_forecast(train_data["price"], test_steps)

# LSTM Modeli
def lstm_forecast(train, steps):
    train_values = train.values.reshape(-1, 1)
    X, y = [], []
    for i in range(len(train_values) - 30):
        X.append(train_values[i:i+30])
        y.append(train_values[i+30])

    X = np.array(X)
    y = np.array(y)

    # Modeli oluşturma
    model = Sequential()
    model.add(LSTM(50, activation='relu', input_shape=(X.shape[1], X.shape[2])))
    model.add(Dense(1))
    model.compile(optimizer='adam', loss='mse')

    # Modeli eğitme
    model.fit(X, y, epochs=50, batch_size=32, verbose=0, shuffle=False)

    # Test verisi için tahminler yapma
    test_values = train_values[-30:].reshape(1, 30, 1)
    predictions = []
    for _ in range(steps):
        prediction = model.predict(test_values)
        predictions.append(prediction[0][0])
        test_values = np.append(test_values[:, 1:, :], prediction.reshape(1, 1, 1), axis=1)

    return np.array(predictions)

lstm_predictions = lstm_forecast(train_data["price"], test_steps)

# Random Forest Modeli
def random_forest_forecast(train, steps):
    train_values = train.values.reshape(-1, 1)
    X, y = [], []
    for i in range(len(train_values) - 30):
        X.append(train_values[i:i+30])
        y.append(train_values[i+30])

    X = np.array(X)
    y = np.array(y)

    # Modeli oluşturma
    model = RandomForestRegressor(n_estimators=200, max_depth=20, max_features="sqrt", random_state=42)
    model.fit(X.reshape(X.shape[0], -1), y)

    # Test verisi için tahminler yapma
    test_values = train_values[-30:].reshape(1, 30, 1)
    predictions = []
    for _ in range(steps):
        prediction = model.predict(test_values.reshape(1, -1))
        predictions.append(prediction[0])
        test_values = np.append(test_values[:, 1:, :], prediction.reshape(1, 1, 1), axis=1)

    return np.array(predictions)

rf_predictions = random_forest_forecast(train_data["price"], test_steps)


weighted_average = (0.5 * sarimax_predictions) + (0.1 * lstm_predictions) + (0.4 * rf_predictions)


prediction_dates = pd.date_range(start="2025-01-14", periods=test_steps, freq="D")


@app.get("/get_bitcoin_data")
def get_bitcoin_data_endpoint():
    # Tahminleri ve tarihleri JSON formatında döndürüyoruz
    predictions = weighted_average.tolist()
    dates = prediction_dates.strftime('%Y-%m-%d').tolist()


    return {
        "ortalama_tahmin": predictions,
        "tahmin_tarihleri": dates
    }

# Ngrok ile erişim URL'si alma
ngrok.set_auth_token('2qZgbopATWqogK3V6Dax7h6uTt5_3xvzavjMWHNPxNiDZpUYL')
public_url = ngrok.connect(8000)
print("FastAPI uygulamanıza şu URL üzerinden erişebilirsiniz:", public_url)

# Uygulamayı başlat
uvicorn.run(app, host="0.0.0.0", port=8000)
