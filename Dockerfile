FROM python:3.12-slim

# Optional: faster, smaller installs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install deps first to leverage Docker layer cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app code
COPY . .

# Run as non-root (good hygiene)
RUN useradd -m appuser && chown -R appuser /app
USER appuser

# Match this to your actual server port
EXPOSE 8000

# If using Flask/FastAPI, prefer a proper server (uncomment one)
# CMD ["gunicorn", "-w", "2", "-k", "uvicorn.workers.UvicornWorker", "app:app", "--bind", "0.0.0.0:8000"]
# CMD ["gunicorn", "-w", "2", "wsgi:app", "--bind", "0.0.0.0:8000"]

# Fallback: plain python entrypoint
CMD ["python", "app.py"]
