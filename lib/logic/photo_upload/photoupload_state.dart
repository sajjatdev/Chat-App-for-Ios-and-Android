part of 'photoupload_cubit.dart';

abstract class PhotouploadState extends Equatable {
  const PhotouploadState();

  @override
  List<Object> get props => [];
}

class PhotouploadInitial extends PhotouploadState {}

class photouploadss extends PhotouploadState {
  final String ImageURL;

  photouploadss({this.ImageURL});

  @override
  // TODO: implement props
  List<Object> get props => [ImageURL];
}

class loadingimage extends PhotouploadState {}
