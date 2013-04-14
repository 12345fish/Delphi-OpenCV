(* /*****************************************************************
  //                       Delphi-OpenCV Demo
  //               Copyright (C) 2013 Project Delphi-OpenCV
  // ****************************************************************
  // Contributor:
  // laentir Valetov
  // email:laex@bk.ru
  // ****************************************************************
  // You may retrieve the latest version of this file at the GitHub,
  // located at git://github.com/Laex/Delphi-OpenCV.git
  // ****************************************************************
  // The contents of this file are used with permission, subject to
  // the Mozilla Public License Version 1.1 (the "License"); you may
  // not use this file except in compliance with the License. You may
  // obtain a copy of the License at
  // http://www.mozilla.org/MPL/MPL-1_1Final.html
  //
  // Software distributed under the License is distributed on an
  // "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
  // implied. See the License for the specific language governing
  // rights and limitations under the License.
  //  ***************************************************************
  //  Original file:
  //  http://blog.vidikon.com/?p=213
  //  *************************************************************** *)

// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_ExtractSURF;

{$APPTYPE CONSOLE}
{$POINTERMATH ON}
{$R *.res}

uses
  System.SysUtils,
  Windows,
  System.Generics.Collections,
  uLibName in '..\..\..\include\uLibName.pas',
  highgui_c in '..\..\..\include\highgui\highgui_c.pas',
  core_c in '..\..\..\include\�ore\core_c.pas',
  Core.types_c in '..\..\..\include\�ore\Core.types_c.pas',
  imgproc.types_c in '..\..\..\include\imgproc\imgproc.types_c.pas',
  imgproc_c in '..\..\..\include\imgproc\imgproc_c.pas',
  legacy in '..\..\..\include\legacy\legacy.pas',
  calib3d in '..\..\..\include\calib3d\calib3d.pas',
  imgproc in '..\..\..\include\imgproc\imgproc.pas',
  haar in '..\..\..\include\objdetect\haar.pas',
  objdetect in '..\..\..\include\objdetect\objdetect.pas',
  tracking in '..\..\..\include\video\tracking.pas',
  Core in '..\..\..\include\�ore\core.pas',
  compat in '..\..\..\include\legacy\compat.pas',
  nonfree in '..\..\..\include\nonfree\nonfree.pas';

// ��������� ���� ������������
function compareSURFDescriptors(const d1: PSingle; const d2: PSingle; best: Double; length: Integer): Double;
Var
  total_cost: Double;
  i: Integer;
  t0, t1, t2, t3: Double;
begin
  total_cost := 0;
  assert(length mod 4 = 0);
  i := 0;
  While i < length - 1 do
  begin
    t0 := d1[i] - d2[i];
    t1 := d1[i + 1] - d2[i + 1];
    t2 := d1[i + 2] - d2[i + 2];
    t3 := d1[i + 3] - d2[i + 3];
    total_cost := total_cost + t0 * t0 + t1 * t1 + t2 * t2 + t3 * t3;
    if (total_cost > best) then
      break;
    i := i + 4;
  end;
  result := total_cost;
end;

// ���������� ���� ����������� ������� �� ����� ������������� �����
function naiveNearestNeighbor(const vec: PSingle; laplacian: Integer; const model_keypoints: pCvSeq;
  const model_descriptors: pCvSeq): Integer;
Var
  length, i, neighbor: Integer;
  d, dist1, dist2: Double;
  reader, kreader: TCvSeqReader;
  kp: pCvSURFPoint;
  mvec: PSingle;
begin
  length := model_descriptors.elem_size div sizeof(single);
  neighbor := -1;
  dist1 := 1E6;
  dist2 := 1E6;;
  // ��������� ����������� �����
  cvStartReadSeq(model_keypoints, @kreader, 0);
  cvStartReadSeq(model_descriptors, @reader, 0);
  // ������� ���� ������������ �����
  for i := 0 to model_descriptors.total - 1 do
  begin
    kp := pCvSURFPoint(kreader.ptr);
    mvec := PSingle(reader.ptr);
    CV_NEXT_SEQ_ELEM(kreader.seq.elem_size, kreader);
    CV_NEXT_SEQ_ELEM(reader.seq.elem_size, reader);
    // ��� ��������� ������� ������������ ��������� ������������
    if (laplacian <> kp.laplacian) then
      continue;
    // ��������� ������������
    d := compareSURFDescriptors(vec, mvec, dist2, length);
    if (d < dist1) then
    begin
      // ������� ������ ���������� ������������
      dist2 := dist1;
      dist1 := d;
      neighbor := i;
    end

    else if (d < dist2) then
      dist2 := d;
  end;
  if (dist1 < 0.6 * dist2) then
    Exit(neighbor);
  result := -1;
end;

// ������� ���� ����������� ����
procedure findPairs(const objectKeypoints: pCvSeq; const objectDescriptors: pCvSeq; const imageKeypoints: pCvSeq;
  const imageDescriptors: pCvSeq; Var ptpairs: TArray<Integer>);
var
  i: Integer;
  reader, kreader: TCvSeqReader;
  kp: pCvSURFPoint;
  descriptor: PSingle;
  nearest_neighbor: Integer;
begin
  // ��������� ��������� ����������� ������� �������������
  cvStartReadSeq(objectKeypoints, @kreader);
  cvStartReadSeq(objectDescriptors, @reader);
  SetLength(ptpairs, 0);
  // ������� ���� �������������� �������
  for i := 0 to objectDescriptors.total - 1 do
  begin
    kp := pCvSURFPoint(kreader.ptr);
    descriptor := PSingle(reader.ptr);
    CV_NEXT_SEQ_ELEM(kreader.seq.elem_size, kreader);
    CV_NEXT_SEQ_ELEM(reader.seq.elem_size, reader);
    // ��������� ������� ����������� �� ����� ������������� �� �����
    nearest_neighbor := naiveNearestNeighbor(descriptor, kp.laplacian, imageKeypoints, imageDescriptors);
    if (nearest_neighbor >= 0) then
    begin
      // ������� ���������� ������������
      SetLength(ptpairs, length(ptpairs) + 2);
      ptpairs[High(ptpairs) - 1] := i;
      ptpairs[High(ptpairs)] := nearest_neighbor;
    end;
  end;
end;

// * ������ ���������� �������������� ������� * /
function locatePlanarObject(const objectKeypoints: pCvSeq; const objectDescriptors: pCvSeq;
  const imageKeypoints: pCvSeq; const imageDescriptors: pCvSeq; const src_corners: TArray<TCvPoint>;
  dst_corners: TArray<TCvPoint>): Integer;

var
  h: array [0 .. 8] of Double;
  _h: TCvMat;
  ptpairs: TArray<Integer>;
  pt1, pt2: TArray<TCvPoint2D32f>;
  _pt1, _pt2: TCvMat;
  i, n: Integer;
  x, y, _Z, _X, _Y: Double;

begin
  _h := cvMat(3, 3, CV_64F, @h);
  // ���� ���� ������������ �� ����� ���������, ������� �������������
  // ���� �����
  findPairs(objectKeypoints, objectDescriptors, imageKeypoints, imageDescriptors, ptpairs);
  n := length(ptpairs) div 2;
  // ���� ��� ����, ������ ���� �������� � ������ �� ������
  if (n < 4) then
    Exit(0);
  // �������� ������
  SetLength(pt1, n);
  SetLength(pt2, n);
  // ��������� ���������� �������������
  for i := 0 to n - 1 do
  begin
    pt1[i] := pCvSURFPoint(cvGetSeqElem(objectKeypoints, ptpairs[i * 2])).pt;
    pt2[i] := pCvSURFPoint(cvGetSeqElem(imageKeypoints, ptpairs[i * 2 + 1])).pt;
  end;

  // �� ���������� �������� ������ ������
  _pt1 := cvMat(1, n, CV_32FC2, @pt1[0]);
  _pt2 := cvMat(1, n, CV_32FC2, @pt2[0]);
  // ������� ������������� ����� �������� ������������ � � ���, �������
  // ����
  if (cvFindHomography(@_pt1, @_pt2, @_h, CV_RANSAC, 5) = 0) then
    Exit(0);
  // �� ����������� �������� ������������� (� ������� _h) �������
  // ���������� ���������������, ���������������� ������
  for i := 0 to 3 do
  begin
    x := src_corners[i].x;
    y := src_corners[i].y;
    _Z := 1. / (h[6] * x + h[7] * y + h[8]);
    _X := (h[0] * x + h[1] * y + h[2]) * _Z;
    _Y := (h[3] * x + h[4] * y + h[5]) * _Z;
    dst_corners[i] := cvPoint(cvRound(_X), cvRound(_Y));
  end;
  Exit(1);
end;

Var
  object_filename, scene_filename: AnsiString;
  storage: pCvMemStorage;
  colors: array [0 .. 8] of TCvScalar = (
    (
      val:
      (
        0,
        0,
        255,
        0
      )
    ),
    (
      val:
      (
        0,
        128,
        255,
        0
      )
    ),
    (
      val:
      (
        0,
        255,
        255,
        0
      )
    ),
    (
      val:
      (
        0,
        255,
        0,
        0
      )
    ),
    (
      val:
      (
        255,
        128,
        0,
        0
      )
    ),
    (
      val:
      (
        255,
        255,
        0,
        0
      )
    ),
    (
      val:
      (
        255,
        0,
        0,
        0
      )
    ),
    (
      val:
      (
        255,
        0,
        255,
        0
      )
    ),
    (
      val:
      (
        255,
        255,
        255,
        0
      )
    )
  );

  _object, image, object_color: pIplImage;
  objectKeypoints, objectDescriptors, imageKeypoints, imageDescriptors: pCvSeq;
  i: Integer;
  params: TCvSURFParams;
  tt: Double;
  src_corners, dst_corners: TArray<TCvPoint>;
  correspond: pIplImage;
  r1, r2: TCvPoint;
  ptpairs: TArray<Integer>;
  _r1, _r2: pCvSURFPoint;
  r: pCvSURFPoint;
  center: TCvPoint;
  radius: Integer;

begin
  try
    initModule_nonfree;
    // ������������� ����������
    object_filename := iif(ParamCount = 2, ParamStr(1), 'resource\box.png');
    scene_filename := iif(ParamCount = 2, ParamStr(2), 'resource\box_in_scene.png');
    storage := cvCreateMemStorage(0);
    cvNamedWindow('Object', 1);
    cvNamedWindow('Object Correspond', 1);
    // �������� �����������
    _object := cvLoadImage(pcvChar(@object_filename[1]), CV_LOAD_IMAGE_GRAYSCALE);
    image := cvLoadImage(pcvChar(@scene_filename[1]), CV_LOAD_IMAGE_GRAYSCALE);

    if (not Assigned(_object)) or (not Assigned(image)) then
    begin
      WriteLn(Format('Can not load %s and/or %s', [object_filename, scene_filename]));
      WriteLn('Usage: find_obj [<object_filename> <scene_filename>]');
      Halt;
    end;
    // ������� � �������� ������
    object_color := cvCreateImage(cvGetSize(_object), 8, 3);
    cvCvtColor(_object, object_color, CV_GRAY2BGR);
    // ������������� ��������� CvSURFParams � �������� ������������ � 128
    // ���������
    params := CvSURFParams(500, 1);
    // �������� �����
    tt := cvGetTickCount();
    // ���� ����������� ������� �������������
    cvExtractSURF(_object, nil, @objectKeypoints, @objectDescriptors, storage, params);
    WriteLn(Format('Object Descriptors: %d', [objectDescriptors.total]));
    // ���� ����������� �����
    cvExtractSURF(image, nil, @imageKeypoints, @imageDescriptors, storage, params);
    WriteLn(Format('Image Descriptors: %d', [imageDescriptors.total]));
    // ������� ������������� ������� (� ���� 167 ����� ������)
    tt := cvGetTickCount() - tt;
    WriteLn(Format('Extraction time = %gms', [tt / (cvGetTickFrequency() * 1000)]));
    // ������������� ������� �����������, ������ ������� ����� ������������
    // �����������
    SetLength(src_corners, 4);
    src_corners[0] := cvPoint(0, 0);
    src_corners[1] := cvPoint(_object.width, 0);
    src_corners[2] := cvPoint(_object.width, _object.height);
    src_corners[3] := cvPoint(0, _object.height);
    SetLength(dst_corners, 4);
    // �������� ��������������� ����������� (� �� ����� ����� � ������)
    // ��������� ������ � ������ � ��� ����
    correspond := cvCreateImage(cvSize(image.width, _object.height + image.height), 8, 1);
    cvSetImageROI(correspond, cvRect(0, 0, _object.width, _object.height));
    cvCopy(_object, correspond);
    cvSetImageROI(correspond, cvRect(0, _object.height, correspond.width, correspond.height));
    cvCopy(image, correspond);
    cvResetImageROI(correspond);
    // �������� �������, ��������� ������ �� ������
    if (locatePlanarObject(objectKeypoints, objectDescriptors, imageKeypoints, imageDescriptors, src_corners,
      dst_corners) <> 0) then
    begin
      // ������� ������ ��������������
      for i := 0 to 3 do
      begin
        r1 := dst_corners[i mod 4];
        r2 := dst_corners[(i + 1) mod 4];
        cvLine(correspond, cvPoint(r1.x, r1.y + _object.height), cvPoint(r2.x, r2.y + _object.height), colors[8]);
      end;
    end;
    // ���� � ���� ����� ������� ��������� �� �����, �� ���������� ��, ���
    // �������� �� ������� 23.3.
    // ����� ������ ��� ����������� ���� ������������ � ����� ���������
    findPairs(objectKeypoints, objectDescriptors, imageKeypoints, imageDescriptors, ptpairs);
    // ����� ������ ������������ �� ������� ���������� ������

    i := 0;
    While i < length(ptpairs) do
    begin
      _r1 := pCvSURFPoint(cvGetSeqElem(objectKeypoints, ptpairs[i]));
      _r2 := pCvSURFPoint(cvGetSeqElem(imageKeypoints, ptpairs[i + 1]));
      cvLine(correspond, cvPointFrom32f(_r1.pt), cvPoint(cvRound(_r2.pt.x), cvRound(_r2.pt.y + _object.height)),
        colors[8]);
      i := i + 2;
    end;
    // ��������� ����� ���������� �� ������� 23.4.
    cvShowImage('Object Correspond', correspond);
    // �������� ������������ ������������ (���. 23.5)
    for i := 0 to objectKeypoints.total - 1 do
    begin
      r := pCvSURFPoint(cvGetSeqElem(objectKeypoints, i));
      center.x := cvRound(r.pt.x);
      center.y := cvRound(r.pt.y);
      radius := cvRound(r.size * 1.2 / 9 * 2);
      cvCircle(object_color, center, radius, colors[0], 1, 8, 0);
    end;
    cvShowImage('Object', object_color);
    cvWaitKey(0);
    cvDestroyAllWindows;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
