# Используем официальный Python 3.10 образ
FROM python:3.10-slim

# Обновляем pip
RUN pip install --upgrade pip

# Системные зависимости (для компиляции numpy, torch и т.д.)
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*
# RUN apt-get update && apt-get install -y \
#     build-essential \
#     git \
#     libomp-dev \
#     libopenblas-dev \
#     && rm -rf /var/lib/apt/lists/*

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем только requirements сначала (чтобы кэшировать)
COPY requirements.txt .

# Устанавливаем зависимости (CPU-версия torch)
RUN pip install --no-cache-dir -r requirements.txt

# Предзагрузка модели (чтобы не грузилась при запуске)
RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2')"

# Копируем весь код проекта
COPY . .

# Указываем порт
EXPOSE 8000

# Запуск
CMD ["uvicorn", "fastApiSentenceService:app", "--host", "0.0.0.0", "--port", "8000"]
