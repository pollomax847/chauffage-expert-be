import '../models/radiateur.dart';

final List<Radiateur> radiateursTest = [
  Radiateur(
    reference: 'RAD001',
    identification: 'SDB',
    modele: 'Delta 600x1000',
    dimensions: '600x1000',
    puissance: 1200.0,
    materiauTuyauterie: 'Cuivre',
    besoinThermique: 1000.0,
  ),
  Radiateur(
    reference: 'RAD002',
    identification: 'Chambre 1',
    modele: 'Delta 500x800',
    dimensions: '500x800',
    puissance: 800.0,
    materiauTuyauterie: 'Multicouche',
    besoinThermique: 850.0,
  ),
  Radiateur(
    reference: 'RAD003',
    identification: 'Salon',
    modele: 'Delta 800x1200',
    dimensions: '800x1200',
    puissance: 2000.0,
    materiauTuyauterie: 'PVC-P',
    besoinThermique: 1800.0,
  ),
  Radiateur(
    reference: 'RAD004',
    identification: 'Cuisine',
    modele: 'Delta 400x600',
    dimensions: '400x600',
    puissance: 600.0,
    materiauTuyauterie: 'Acier',
    besoinThermique: 700.0,
  ),
];
