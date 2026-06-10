FROM ubuntu:24.04

ENV PYTHONUNBUFFERED=1
ENV NODE_ENV=production
ENV HOME=/opt/data

# Install Python 3.12 + Node.js 20 + dependencies
RUN apt-get update && apt-get install -y \
    python3.12 python3.12-venv python3-pip \
    curl ca-certificates gnupg git \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Create virtual environment for Python
RUN python3.12 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Node dependencies
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Copy source
COPY . .

# Create data directory
RUN mkdir -p /opt/data

EXPOSE 8080

CMD ["npx", "hermes", "gateway", "start"]
