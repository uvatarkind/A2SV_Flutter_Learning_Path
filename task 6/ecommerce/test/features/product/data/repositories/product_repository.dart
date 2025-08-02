void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late MockNetworkInfo mockNetwork;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    mockNetwork = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  final tProductList = [Product(id: 1, name: 'Shirt', price: 100)];

  test('should check network connectivity', () async {
    when(mockNetwork.isConnected).thenAnswer((_) async => true);
    when(mockRemote.getAllProducts()).thenAnswer((_) async => tProductList);

    await repository.getAllProducts();

    verify(mockNetwork.isConnected);
  });

  group('Device is online', () {
    setUp(() {
      when(mockNetwork.isConnected).thenAnswer((_) async => true);
    });

    test('should return remote data and cache it', () async {
      when(mockRemote.getAllProducts()).thenAnswer((_) async => tProductList);

      final result = await repository.getAllProducts();

      verify(mockRemote.getAllProducts());
      verify(mockLocal.cacheProducts(tProductList));
      expect(result, Right(tProductList));
    });

    test('should return server failure on exception', () async {
      when(mockRemote.getAllProducts()).thenThrow(Exception());

      final result = await repository.getAllProducts();

      expect(result, Left(ServerFailure()));
    });
  });

  group('Device is offline', () {
    setUp(() {
      when(mockNetwork.isConnected).thenAnswer((_) async => false);
    });

    test('should return cached data', () async {
      when(mockLocal.getCachedProducts()).thenAnswer((_) async => tProductList);

      final result = await repository.getAllProducts();

      verify(mockLocal.getCachedProducts());
      expect(result, Right(tProductList));
    });

    test('should return cache failure when no cached data', () async {
      when(mockLocal.getCachedProducts()).thenThrow(Exception());

      final result = await repository.getAllProducts();

      expect(result, Left(CacheFailure()));
    });
  });
}
