import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';
import 'package:nfc_manager/ndef_record.dart';

class NfcService {
  Future<bool> isNfcAvailable() async {
    NfcAvailability availability = await NfcManager.instance.checkAvailability();
    return availability == NfcAvailability.enabled;
  }

  Future<void> startNfcScan({
    required Function(String payload) onSuccess,
    required Function(String error) onError,
  }) async {
    bool available = await isNfcAvailable();
    if (!available) {
      onError("NFC-ul nu este disponibil sau activat pe acest telefon.");
      return;
    }

    NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
        NfcPollingOption.iso18092,
      },
      onDiscovered: (NfcTag tag) async {
        try {
          Ndef? ndef = Ndef.from(tag);
          
          if (ndef == null) {
            onError("Dispozitivul scanat nu este compatibil NDEF.");
            NfcManager.instance.stopSession();
            return;
          }

          NdefMessage? ndefMessage = ndef.cachedMessage;

          
          if (ndefMessage == null) {
            try {
              ndefMessage = await ndef.read();
            } catch (e) {
              onError("Telefonul a citit prea repede. Mai încearcă o dată, ținând telefonul pe loc!");
              NfcManager.instance.stopSession();
              return;
            }
          }

          if (ndefMessage!.records.isEmpty) {
            onError("Eticheta este goală.");
            NfcManager.instance.stopSession();
            return;
          }

          final record = ndefMessage.records.first;
          String payload = String.fromCharCodes(record.payload);
          
          NfcManager.instance.stopSession();
          onSuccess(payload);
          
        } catch (e) {
          onError("Eroare la procesarea tag-ului: $e");
          NfcManager.instance.stopSession();
        }
      },
    );
  }

  void stopNfcSession() {
    NfcManager.instance.stopSession();
  }
}