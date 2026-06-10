FROM ubuntu:24.04

ENV PYTHONUNBUFFERED=1
ENV NODE_ENV=production
ENV HOME=/opt/data

# Install Python 3.12 + Node.js 20
RUN apt-get update && apt-get install -y \
    python3.12 python3.12-venv python3-pip \
    curl ca-certificates gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python dependencies first (cached layer)
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Install Node dependencies
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Copy source
COPY . .

# Create data directory
RUN mkdir -p /opt/data

EXPOSE 8080

CMD ["node", "node_modules/.bin/hermes", "gateway", "start"]
