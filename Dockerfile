# Usa l’immagine base di Jupyter DataScience

FROM jupyter/datascience-notebook:latest

# Cambia all’utente root per installazioni

USER root

# Installa curl se non presente

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Crea la directory di lavoro per i notebook

RUN mkdir -p /home/jovyan/work

# Crea il file di configurazione Jupyter

RUN mkdir -p /home/jovyan/.jupyter

# Crea il file di configurazione

COPY <<EOF /home/jovyan/.jupyter/jupyter_server_config.py
import os
from jupyter_server.auth import passwd

# Configurazione server

c.ServerApp.ip = ‘0.0.0.0’
c.ServerApp.port = 8888
c.ServerApp.open_browser = False
c.ServerApp.allow_origin = ‘*’
c.ServerApp.allow_remote_access = True
c.ServerApp.allow_root = True

# Configura password da variabile d’ambiente

password = os.environ.get(‘JUPYTER_PASSWORD’, ‘password’)
if password:
c.ServerApp.password = passwd(password)

# Disabilita token se c’è una password

if password:
c.ServerApp.token = ‘’

# Directory di lavoro

c.ServerApp.notebook_dir = ‘/home/jovyan/work’
EOF

# Crea script keep-alive che simula navigazione reale

COPY <<EOF /usr/local/bin/keep-alive.sh
#!/bin/bash

# Funzione per simulare navigazione reale

simulate_user_activity() {
# Aspetta che Jupyter si avvii
sleep 60

```
# Ottieni l'URL pubblico di Render (se disponibile)
if [ ! -z "\$RENDER_EXTERNAL_URL" ]; then
    BASE_URL="\$RENDER_EXTERNAL_URL"
else
    # Fallback a localhost se non disponibile
    BASE_URL="https://aimasterclass-jupyter.onrender.com"
fi

echo "Keep-alive attivo per: \$BASE_URL"

while true; do
    # Ogni 8 minuti (prima dei 15 minuti di timeout)
    sleep 480
    
    # Simula sequenza di navigazione reale
    echo "$(date): Simulando attività utente..."
    
    # 1. Richiesta alla homepage
    curl -s -L "\$BASE_URL/" \
         -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
         -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
         -H "Accept-Language: en-US,en;q=0.5" \
         -H "Connection: keep-alive" \
         -H "Upgrade-Insecure-Requests: 1" \
         > /dev/null 2>&1 || true
    
    sleep 2
    
    # 2. Richiesta API per simulare check del kernel
    curl -s -L "\$BASE_URL/api/kernels" \
         -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
         > /dev/null 2>&1 || true
    
    sleep 3
    
    # 3. Richiesta alla directory di lavoro
    curl -s -L "\$BASE_URL/api/contents" \
         -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
         > /dev/null 2>&1 || true
    
    sleep 2
    
    # 4. Richiesta status generale
    curl -s -L "\$BASE_URL/api/status" \
         -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
         > /dev/null 2>&1 || true
    
    echo "$(date): Sequenza keep-alive completata"
done
```

}

# Avvia simulazione in background

simulate_user_activity &

# Avvia Jupyter

exec start-notebook.sh –ServerApp.password_required=True –ServerApp.token=’’
EOF

RUN chmod +x /usr/local/bin/keep-alive.sh

# Assicurati che i file appartengano all’utente jovyan

RUN chown -R jovyan:users /home/jovyan/.jupyter
RUN chown -R jovyan:users /home/jovyan/work

# Torna all’utente jovyan

USER jovyan

# Imposta la directory di lavoro

WORKDIR /home/jovyan/work

# Esponi la porta 8888

EXPOSE 8888

# Imposta le variabili d’ambiente di default

ENV JUPYTER_PASSWORD=password
ENV JUPYTER_ENABLE_LAB=yes

# Comando di avvio con keep-alive

CMD [”/usr/local/bin/keep-alive.sh”]