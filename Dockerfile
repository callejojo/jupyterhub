FROM jupyterhub/jupyterhub:latest

# Installa JupyterLab
RUN pip install jupyterlab

# Crea utenti sistema
RUN useradd -m admin && echo "admin:password123" | chpasswd

# Copia configurazione
COPY jupyterhub_config.py /srv/jupyterhub/

EXPOSE 8000

CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]
