FROM python:3.11-slim

WORKDIR /workspace

# System deps (important for pyarrow, duckdb performance)
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy shared Python deps
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["bash"]