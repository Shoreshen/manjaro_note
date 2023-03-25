import numpy as np
import pandas as pd
from keras.models import Sequential
from keras.layers import LSTM, Dense

# 读取股票数据
df = pd.read_csv('stock_data.csv')

# 数据预处理
df['Date'] = pd.to_datetime(df['Date'])
df.set_index('Date', inplace=True)
df = df[['Open', 'High', 'Low', 'Close', 'Volume']]
df = df.dropna()
df = df.astype(float)

# 归一化处理
data = df.values
mean = np.mean(data, axis=0)
std = np.std(data, axis=0)
data = (data - mean) / std

# 构建数据集
def create_dataset(data, look_back=1):
    X, Y = [], []
    for i in range(len(data)-look_back):
        X.append(data[i:(i+look_back), :])
        Y.append(data[i+look_back, :])
    return np.array(X), np.array(Y)

look_back = 60
X, Y = create_dataset(data, look_back)

# 划分训练集和测试集
train_size = int(len(X) * 0.7)
X_train, X_test = X[:train_size], X[train_size:]
Y_train, Y_test = Y[:train_size], Y[train_size:]

# 定义模型
model = Sequential()
model.add(LSTM(32, input_shape=(look_back, 5)))
model.add(Dense(5))
model.compile(loss='mse', optimizer='adam')

# 训练模型
model.fit(X_train, Y_train, epochs=50, batch_size=32)

# 预测
train_predict = model.predict(X_train)
test_predict = model.predict(X_test)

# 反归一化处理
train_predict = train_predict * std + mean
Y_train = Y_train * std + mean
test_predict = test_predict * std + mean
Y_test = Y_test * std + mean

# 输出预测结果
print('训练集中前五个样本的预测值和实际值：')
print(train_predict[:5])
print(Y_train[:5])
print('测试集中前五个样本的预测值和实际值：')
print(test_predict[:5])
print(Y_test[:5])