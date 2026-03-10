import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/gig.dart';

class GigProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  
  List<Gig> _gigs = [];
  Gig? _currentGig;
  bool _isLoading = false;
  String? _errorMessage;

  List<Gig> get gigs => _gigs;
  Gig? get currentGig => _currentGig;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchGigs({String? role}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final endpoint = role != null ? '/gigs?role=$role' : '/gigs';
      final response = await _api.get(endpoint);
      
      _gigs = (response['data']['gigs'] as List)
          .map((json) => Gig.fromJson(json))
          .toList();
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createGig(Map<String, dynamic> gigData) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _api.post('/gigs', gigData);
      await fetchGigs();
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchGigById(String gigId) async {
    try {
      final response = await _api.get('/gigs/$gigId');
      _currentGig = Gig.fromJson(response['data']['gig']);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
