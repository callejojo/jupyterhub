FROM jupyterhub/jupyterhub:latest

# Copia configurazione
COPY jupyterhub_config.py /srv/jupyterhub/

# Crea utente admin nel sistema
RUN useradd -m admin && echo "admin:daicheandiamoavincerla1990" | chpasswd

EXPOSE 8000

CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]
