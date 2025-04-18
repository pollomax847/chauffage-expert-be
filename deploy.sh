#!/bin/bash

# Fonction pour afficher l'aide
show_help() {
    echo "Usage: ./deploy.sh [OPTIONS]"
    echo "Options:"
    echo "  -e, --environment ENV   Environnement de déploiement (staging/production)"
    echo "  -d, --domain DOMAIN    Domaine personnalisé"
    echo "  -t, --test             Exécuter les tests après le déploiement"
    echo "  -m, --monitor          Activer le monitoring continu"
    echo "  -h, --help             Afficher cette aide"
    exit 0
}

# Variables par défaut
ENVIRONMENT="staging"
DOMAIN=""
RUN_TESTS=false
MONITOR=false

# Traitement des arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -d|--domain)
            DOMAIN="$2"
            shift 2
            ;;
        -t|--test)
            RUN_TESTS=true
            shift
            ;;
        -m|--monitor)
            MONITOR=true
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Option inconnue: $1"
            show_help
            ;;
    esac
done

# Vérification de l'environnement
if [[ "$ENVIRONMENT" != "staging" && "$ENVIRONMENT" != "production" ]]; then
    echo "Erreur: L'environnement doit être 'staging' ou 'production'"
    exit 1
fi

# Construction de l'application
echo "Construction de l'application pour l'environnement $ENVIRONMENT..."
./build.sh

if [ $? -ne 0 ]; then
    echo "Erreur lors de la construction"
    exit 1
fi

# Déploiement sur Vercel
echo "Déploiement sur Vercel..."
if [ -n "$DOMAIN" ]; then
    vercel deploy --prod --env $ENVIRONMENT --domain $DOMAIN
else
    if [ "$ENVIRONMENT" == "production" ]; then
        vercel deploy --prod --env production
    else
        vercel deploy --env staging
    fi
fi

# Vérification du déploiement
if [ $? -ne 0 ]; then
    echo "Erreur lors du déploiement"
    exit 1
fi

# Exécution des tests si demandé
if [ "$RUN_TESTS" = true ]; then
    echo "Exécution des tests..."
    ./monitor.sh
    if [ $? -ne 0 ]; then
        echo "Les tests ont échoué"
        exit 1
    fi
fi

# Démarrage du monitoring si demandé
if [ "$MONITOR" = true ]; then
    echo "Démarrage du monitoring..."
    nohup ./monitor.sh > monitoring.log 2>&1 &
    echo "Monitoring démarré (PID: $!)"
fi

echo "Déploiement réussi !"
echo "Environnement: $ENVIRONMENT"
if [ -n "$DOMAIN" ]; then
    echo "Domaine: $DOMAIN"
fi
if [ "$RUN_TESTS" = true ]; then
    echo "Tests: OK"
fi
if [ "$MONITOR" = true ]; then
    echo "Monitoring: Actif"
fi 