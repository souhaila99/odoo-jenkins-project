# Utilisez l'image officielle Odoo 18 comme base
FROM odoo:18.0

# Copiez votre fichier de configuration Odoo et vos modules personnalisés
USER root
COPY ./odoo.conf /etc/odoo/

# Copiez les modules personnalisés si vous en avez
COPY ./addons /mnt/extra-addons

# Changez les permissions pour l'utilisateur Odoo
RUN chown odoo /etc/odoo/odoo.conf
RUN chown -R odoo /mnt/extra-addons

# Revenir à l'utilisateur Odoo pour exécuter le processus
USER odoo

# Exposez le port utilisé par Odoo
EXPOSE 8069

# Démarrez le service Odoo
CMD ["odoo"]
