# Inception

Projet **42** d’Administration Système axé sur **Docker** et la virtualisation de services.  
L’objectif : configurer une mini-infrastructure contenant **NGINX**, **WordPress + php-fpm**, **MariaDB**, ainsi que des volumes dédiés, le tout orchestré via **docker-compose**.

## Principe

- **Machine Virtuelle** : le projet s’effectue dans une VM.
- **Conteneurs Séparés** : chaque service s’exécute dans un conteneur Docker distinct.
- **Images Personnalisées** : chaque conteneur se build depuis un Dockerfile Alpine/Debian (version stable -1).
- **Docker-Compose** : coordonne le lancement de tous les services avec un unique `docker-compose.yml`.
- **Volumes** :  
  - Un volume pour la base de données (MariaDB).  
  - Un volume pour les fichiers WordPress.
- **Réseau** : un réseau Docker unique relie tous les conteneurs.
- **Nom de domaine** : le site est accessible via `login.42.fr` pointant vers l’IP locale.
- **Sécurisation** :  
  - NGINX doit être accessible uniquement en **HTTPS** (TLSv1.2 ou v1.3).  
  - Pas de mots de passe en clair dans les Dockerfiles (utilisation de variables d’environnement ou Docker secrets).  
  - Conteneurs configurés pour redémarrer en cas de crash.

## Architecture

1. **NGINX**  
   - Seul point d’entrée sur le port **443** (HTTPS).  
   - Certificat TLS (v1.2 ou 1.3).
2. **WordPress + php-fpm**  
   - Gère le contenu et l’affichage du site.  
   - Communique avec NGINX et MariaDB.
3. **MariaDB**  
   - Héberge la base de données WordPress.  
   - Les identifiants sont stockés en variables d’environnement/secrets.

