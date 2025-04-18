// test/services/gas_regulation_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../lib/models/gas_regulation.dart';
import '../../lib/services/gas_regulation_service.dart';

void main() {
  late GasRegulationService service;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    service = GasRegulationService();
  });

  test('Sauvegarde et récupération d\'une réglementation', () async {
    final regulation = GasRegulation(
      id: '1',
      clientName: 'Test Client',
      address: 'Test Address',
      technicianName: 'Test Technician',
      date: DateTime.now(),
      observations: 'Test Observations',
      conclusion: 'Test Conclusion',
      isVentilationOk: true,
      isCombustionOk: true,
      isInstallationOk: true,
      isPressureOk: true,
      isLeakageOk: true,
      co2Value: 10.0,
      o2Value: 20.0,
      coValue: 30.0,
      temperatureValue: 40.0,
      pressureValue: 50.0,
    );

    await service.saveGasRegulation(regulation);
    final regulations = await service.getRegulations();

    expect(regulations.length, 1);
    expect(regulations[0].clientName, 'Test Client');
    expect(regulations[0].address, 'Test Address');
    expect(regulations[0].technicianName, 'Test Technician');
  });

  test('Récupération par ID', () async {
    final regulation = GasRegulation(
      id: '2',
      clientName: 'Test Client 2',
      address: 'Test Address 2',
      technicianName: 'Test Technician 2',
      date: DateTime.now(),
      observations: 'Test Observations 2',
      conclusion: 'Test Conclusion 2',
      isVentilationOk: false,
      isCombustionOk: false,
      isInstallationOk: false,
      isPressureOk: false,
      isLeakageOk: false,
      co2Value: 15.0,
      o2Value: 25.0,
      coValue: 35.0,
      temperatureValue: 45.0,
      pressureValue: 55.0,
    );

    await service.saveGasRegulation(regulation);
    final retrieved = await service.getRegulationById('2');

    expect(retrieved, isNotNull);
    expect(retrieved!.clientName, 'Test Client 2');
    expect(retrieved.isVentilationOk, false);
  });

  test('Mise à jour d\'une réglementation', () async {
    final regulation = GasRegulation(
      id: '3',
      clientName: 'Test Client 3',
      address: 'Test Address 3',
      technicianName: 'Test Technician 3',
      date: DateTime.now(),
      observations: 'Test Observations 3',
      conclusion: 'Test Conclusion 3',
      isVentilationOk: true,
      isCombustionOk: true,
      isInstallationOk: true,
      isPressureOk: true,
      isLeakageOk: true,
      co2Value: 20.0,
      o2Value: 30.0,
      coValue: 40.0,
      temperatureValue: 50.0,
      pressureValue: 60.0,
    );

    await service.saveGasRegulation(regulation);

    final updated = GasRegulation(
      id: '3',
      clientName: 'Updated Client',
      address: regulation.address,
      technicianName: regulation.technicianName,
      date: regulation.date,
      observations: regulation.observations,
      conclusion: regulation.conclusion,
      isVentilationOk: regulation.isVentilationOk,
      isCombustionOk: regulation.isCombustionOk,
      isInstallationOk: regulation.isInstallationOk,
      isPressureOk: regulation.isPressureOk,
      isLeakageOk: regulation.isLeakageOk,
      co2Value: regulation.co2Value,
      o2Value: regulation.o2Value,
      coValue: regulation.coValue,
      temperatureValue: regulation.temperatureValue,
      pressureValue: regulation.pressureValue,
    );

    await service.updateRegulation('3', updated);
    final retrieved = await service.getRegulationById('3');

    expect(retrieved!.clientName, 'Updated Client');
  });

  test('Suppression d\'une réglementation', () async {
    final regulation = GasRegulation(
      id: '4',
      clientName: 'Test Client 4',
      address: 'Test Address 4',
      technicianName: 'Test Technician 4',
      date: DateTime.now(),
      observations: 'Test Observations 4',
      conclusion: 'Test Conclusion 4',
      isVentilationOk: true,
      isCombustionOk: true,
      isInstallationOk: true,
      isPressureOk: true,
      isLeakageOk: true,
      co2Value: 25.0,
      o2Value: 35.0,
      coValue: 45.0,
      temperatureValue: 55.0,
      pressureValue: 65.0,
    );

    await service.saveGasRegulation(regulation);
    await service.deleteRegulation('4');
    final retrieved = await service.getRegulationById('4');

    expect(retrieved, isNull);
  });
}
