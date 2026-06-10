FROM ubuntu:24.04

ENV PYTHONUNBUFFERED=1
ENV NODE_ENV=production
ENV HOME=/opt/data

RUN apt-get update && apt-get install -y \
    python3.12 python3.12-venv python3-pip \
    curl ca-certificates gnupg git \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN python3.12 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY . .
RUN mkdir -p /opt/data

# Copy startup script
COPY start.sh /opt/start.sh
RUN chmod +x /opt/start.sh

EXPOSE 8080

CMD ["/opt/start.sh"]
