#!/bin/bash

# Configuration
LOG_FILE="monitoring.log"
ERROR_THRESHOLD=5
PERFORMANCE_THRESHOLD=2000 # ms
BACKUP_DIR="backups"
DATE=$(date +%Y%m%d_%H%M%S)

# Fonction de logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

# Fonction de backup
create_backup() {
    log "Création du backup..."
    mkdir -p $BACKUP_DIR
    # TODO: Adapter le contenu de la sauvegarde aux besoins réels (ex: base de données, configurations)
    tar -czf "$BACKUP_DIR/backup_$DATE.tar.gz" build/web/ # Sauvegarde actuelle limitée
    log "Backup créé: $BACKUP_DIR/backup_$DATE.tar.gz"
}

# Fonction de vérification des performances
check_performance() {
    log "Vérification des performances..."
    RESPONSE_TIME=$(curl -s -w "%{time_total}" -o /dev/null "https://$DOMAIN")
    RESPONSE_TIME_MS=$(echo "$RESPONSE_TIME * 1000" | bc | awk '{print int($1+0.5)}')
    
    log "Temps de réponse: ${RESPONSE_TIME_MS}ms"
    
    if (( $(echo "$RESPONSE_TIME_MS > $PERFORMANCE_THRESHOLD" | bc -l) )); then
        log "ALERTE: Temps de réponse élevé: ${RESPONSE_TIME_MS}ms"
        return 1
    fi
    return 0
}

# Fonction de vérification des erreurs
check_errors() {
    log "Vérification des erreurs..."
    # NOTE: Cette méthode est basique et peut générer des faux positifs.
    # Envisager une méthode plus robuste (ex: vérifier les logs, un endpoint de statut dédié).
    ERROR_COUNT=$(curl -s https://$DOMAIN | grep -ci "error") # Utilisation de grep -c pour compter les lignes contenant "error" (insensible à la casse)

    if [ $ERROR_COUNT -gt $ERROR_THRESHOLD ]; then
        log "ALERTE: Nombre d'erreurs potentiel élevé: $ERROR_COUNT"
        return 1
    fi
    return 0
}

# Fonction de test de déploiement
test_deployment() {
    log "Test du déploiement..."
    
    # Test de disponibilité
    if ! curl -s -f https://$DOMAIN > /dev/null; then
        log "ERREUR: L'application n'est pas disponible"
        return 1
    fi
    
    # Test des fonctionnalités principales
    TESTS=(
        "calcul/chauffage"
        "calcul/hydraulique"
        "calcul/vmc"
        "pdf/generation"
    )
    
    for test in "${TESTS[@]}"; do
        if ! curl -s -f "https://$DOMAIN/api/$test" > /dev/null; then
            log "ERREUR: La fonctionnalité $test ne répond pas"
            return 1
        fi
    done
    
    return 0
}

# Fonction principale
main() {
    # Gestion des arguments
    case "$1" in
        create_backup)
            create_backup
            exit $?
            ;;
        test_deployment)
            test_deployment
            exit $?
            ;;
        check_performance)
            check_performance
            exit $?
            ;;
        check_errors)
            check_errors
            exit $?
            ;;
        "")
            # Comportement par défaut: exécuter toutes les vérifications
            log "Démarrage du monitoring complet..."

            # Création du backup avant les tests (optionnel, peut être fait séparément)
            # create_backup

            # Vérifications
            perf_ok=true
            check_performance || perf_ok=false

            errors_ok=true
            check_errors || errors_ok=false

            deploy_ok=true
            test_deployment || deploy_ok=false

            if $perf_ok && $errors_ok && $deploy_ok; then
                log "Monitoring terminé avec succès"
                exit 0
            else
                log "Monitoring terminé avec des problèmes détectés"
                exit 1
            fi
            ;;
        *)
            log "Argument non reconnu: $1"
            exit 1
            ;;
    esac
}

# Exécution avec le premier argument
main "$1"