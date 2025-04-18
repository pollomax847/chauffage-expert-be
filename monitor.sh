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
    tar -czf "$BACKUP_DIR/backup_$DATE.tar.gz" build/web/
    log "Backup créé: $BACKUP_DIR/backup_$DATE.tar.gz"
}

# Fonction de vérification des performances
check_performance() {
    log "Vérification des performances..."
    RESPONSE_TIME=$(curl -s -w "%{time_total}" -o /dev/null https://$DOMAIN)
    RESPONSE_TIME_MS=$(echo "$RESPONSE_TIME * 1000" | bc)
    
    if (( $(echo "$RESPONSE_TIME_MS > $PERFORMANCE_THRESHOLD" | bc -l) )); then
        log "ALERTE: Temps de réponse élevé: ${RESPONSE_TIME_MS}ms"
        return 1
    fi
    return 0
}

# Fonction de vérification des erreurs
check_errors() {
    log "Vérification des erreurs..."
    ERROR_COUNT=$(curl -s https://$DOMAIN | grep -o "error" | wc -l)
    
    if [ $ERROR_COUNT -gt $ERROR_THRESHOLD ]; then
        log "ALERTE: Nombre d'erreurs élevé: $ERROR_COUNT"
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
    log "Démarrage du monitoring..."
    
    # Création du backup avant les tests
    create_backup
    
    # Vérifications
    if ! check_performance; then
        log "Problème de performance détecté"
    fi
    
    if ! check_errors; then
        log "Erreurs détectées"
    fi
    
    if ! test_deployment; then
        log "Problème de déploiement détecté"
        exit 1
    fi
    
    log "Monitoring terminé avec succès"
}

# Exécution
main 