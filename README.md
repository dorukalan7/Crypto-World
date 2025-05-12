# 💹 Crypto World

**Crypto World** is a powerful, AI-driven crypto market analysis platform. It provides real-time data, technical indicators, anomaly detection, and deep learning-based price prediction. The project is designed to support both casual users and experienced traders by delivering clear insights and interactive tools.

---

## 🎥 Demo Video

[![Watch the Demo](assets/screenshots/preview.jpeg)](https://www.youtube.com/shorts/9b4NrTnpcw4)

> Click the image above to watch a short demo of Crypto World in action.

---

## 🖼️ Screenshots

| Home Page | Fullscreen Chart |
|-----------|------------------|
| ![](assets/screenshots/portfolio.png) | ![](assets/screenshots/indicators.png) |

| RSI & Bollinger Bands | Anomaly Detection |
|------------------------|------------------|
| ![](assets/screenshots/indicators3.png) | ![](assets/screenshots/indicators2.png) |


---

## 🧠 Key Features

- 📈 **Real-time Coin Data**: Live updates using external APIs.
- 🧮 **Technical Indicators**: RSI, Bollinger Bands, and Moving Averages.
- 📊 **Fullscreen Charts**: Interactive and expandable charting for better visualization.
- ⚠️ **Anomaly Detection**: Detects sudden drops or spikes in coin values in real-time.
- 🤖 **AI Price Prediction**: Predicts future prices for the next 30 days using a TensorFlow-based deep learning model.
- 🔗 **Backend Integration**: Python FastAPI via Ngrok is used to serve the trained AI model.
- 📉 **Detailed Coin View**: With key metrics and analysis.

---

🧠 Backend – AI-Powered Bitcoin Price Forecasting API
The Crypto World backend is a FastAPI-powered service that delivers 30-day Bitcoin price forecasts using a combination of statistical and machine learning models. It runs independently and communicates with the frontend via a public Ngrok tunnel.

- ⚙️ Technologies Used
🐍 FastAPI – Fast, asynchronous Python web framework

- 📦 Statsmodels – For SARIMAX time series modeling

- 🔢 Scikit-learn – For Random Forest regression

- 🧠 TensorFlow/Keras – For LSTM neural network

- 📊 Pandas & NumPy – Data processing and numerical computation

- 🌐 Ngrok – Exposes the local API to the internet securely


| AI Price Prediction | Coin Details |
|---------------------|--------------|
| ![](assets/screenshots/prediction.png) | ![](assets/screenshots/prediction2.png) |


final_prediction = 0.5 * SARIMAX + 0.4 * RandomForest + 0.1 * LSTM

