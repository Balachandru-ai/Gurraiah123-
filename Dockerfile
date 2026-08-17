# =========================
# STAGE 1: FRONTEND
# =========================

FROM node:22-alpine AS frontend-builder

WORKDIR /frontend

COPY frontend/package*.json ./

RUN npm ci

COPY frontend/ .

RUN npm run build


# =========================
# STAGE 2: BACKEND
# =========================

FROM python:3.11-slim AS backend-builder

WORKDIR /backend

RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY backend/requirements.txt .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


# =========================
# STAGE 3: FINAL
# =========================

FROM python:3.11-slim

WORKDIR /app

# Install Nginx
RUN apt-get update && \
    apt-get install -y --no-install-recommends nginx && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/nginx/sites-enabled/default

# Python virtual environment
COPY --from=backend-builder /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

# Backend
COPY backend/ ./backend/

# Frontend
COPY --from=frontend-builder /frontend/dist /usr/share/nginx/html

# Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
EXPOSE 3000

CMD ["sh", "-c", "uvicorn backend.main:app --host 0.0.0.0 --port 3000 & nginx -g 'daemon off;'"]
