# Używamy oficjalnego obrazu Superset 5.0
FROM apache/superset:5.0.0

# Przechodzimy na roota, by zainstalować potrzebne narzędzia
USER root

# Instalacja narzędzi systemowych i bibliotek do pyodbc/nzpy oraz debugowania
RUN apt-get update && apt-get install -y \
    build-essential gcc g++ \
    unixodbc unixodbc-dev \
    libsasl2-dev libldap2-dev libssl-dev \
    curl wget net-tools iputils-ping dnsutils \
    tar gzip vim nano less procps lsof \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Kopiujemy plik z dodatkowymi zależnościami Pythona
COPY requirements-extra.txt /app/requirements-extra.txt

# Instalujemy dodatkowe biblioteki Pythonowe (JDBC)
RUN pip install --no-cache-dir -r /app/requirements-extra.txt

# (Opcjonalnie) Kopiujemy plik konfiguracyjny Superset
COPY superset_config.py /app/pythonpath/superset_config.py

# Zapewniamy dostęp do plików i zgodność z OpenShift
RUN mkdir -p /app/pythonpath && \
    chmod -R g+w /app /app/pythonpath && \
    chgrp -R 0 /app /app/pythonpath

# Wracamy do użytkownika nieuprzywilejowanego (OpenShift compliant)
USER 1001
