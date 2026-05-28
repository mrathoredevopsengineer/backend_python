FROM python:3.11-slim

WORKDIR /app

# Install required packages

RUN apt-get update && apt-get install -y 
curl 
gnupg 
unixodbc 
unixodbc-dev

# Add Microsoft signing key

RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg

# Add Microsoft SQL Server repository

RUN curl -sSL https://packages.microsoft.com/config/debian/12/prod.list 
> /etc/apt/sources.list.d/mssql-release.list

# Configure signed repository

RUN sed -i 's#deb #deb [signed-by=/usr/share/keyrings/microsoft-prod.gpg] #g' 
/etc/apt/sources.list.d/mssql-release.list

# Install ODBC Driver 18

RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Copy requirements

COPY requirements.txt .

# Install Python dependencies

RUN pip install --no-cache-dir -r requirements.txt

# Copy app files

COPY . .

# Expose FastAPI port

EXPOSE 8000

# Start application

CMD ["python", "app.py"]
