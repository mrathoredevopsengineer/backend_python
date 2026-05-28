FROM python:3.11-slim

WORKDIR /app

# Install required packages

RUN apt-get update && apt-get install -y \
curl \
gnupg \
unixodbc \ 
unixodbc-dev 

# Add Microsoft signing key

RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg

# Add Microsoft SQL repository

RUN echo "deb [signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/mssql-release.list

# Install ODBC Driver

RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Copy requirements

COPY requirements.txt .

# Install Python packages

RUN pip install --no-cache-dir -r requirements.txt

# Copy app files

COPY . .

# Expose port

EXPOSE 8000

# Start app

CMD ["python", "app.py"]
