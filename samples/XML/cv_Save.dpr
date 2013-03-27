// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_Save;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Core.types_c in '..\..\include\�ore\Core.types_c.pas',
  core_c in '..\..\include\�ore\core_c.pas',
  highgui_c in '..\..\include\highgui\highgui_c.pas',
  LibName in '..\..\include\LibName.pas';

Var
  kernel: array [0 .. 8] of Single;
  kernel_matrix: TCvMat;
  i: Integer;
  j: Integer;
  matrix: pCvMat;

begin
  try
    // ������, ���������� ������ �������
    kernel[0] := 1;
    kernel[1] := 0;
    kernel[2] := 0;
    kernel[3] := 0;
    kernel[4] := 2;
    kernel[5] := 0;
    kernel[6] := 0;
    kernel[7] := 0;
    kernel[8] := 3;
    // ������ �������
    kernel_matrix := cvMat(3, 3, CV_32FC1, @kernel);
    // ��������� ������� � XML-����
    cvSave('kernel.xml', @kernel_matrix);
    // � ������ �������� ������ �� XML-�����
    matrix := pCvMat(cvLoad('kernel.xml'));
    // ������� ���������� �������
    // 1 �������: � �������������� ������� CV_MAT_ELEM
    for i := 0 to matrix^.rows - 1 do
    begin
      for j := 0 to matrix^.cols - 1 do
        Write(Format('%.0f ', [Single(CV_MAT_ELEM(matrix^, CV_32FC1, i, j)^)]));
      Writeln;
    end;
    Writeln;

//    // 2 �������: � �������������� cvGet2D(), cvGetReal2D()
//    for (i = 0; i < matrix - > rows; i + +) {
//      for(j=0; j<matrix->cols; j++){
//      printf("%.0f ", cvGet2D(matrix, i, j));//cvGetReal2D(matrix, i, j));
//    }
//      printf(" \ n ");
//      } printf(" - - - - - \ n ");
//
//    // 3 �������: ������ ������ � ���������
//    for (i = 0; i < matrix - > rows; i + +) {
//      float* ptr = (float*)(matrix->data.ptr + i*matrix->step);
//      for(j=0; j<matrix->cols; j++){
//      printf("%.0f ", ptr[j]);
//    }
//      printf(" \ n ");
//      }

      // ����������� �������
        cvReleaseMat(matrix);


//������ XML
//printf("Example 3_19 Reading in cfg.xml\n");
//
//	// ��������� ���� ��� ������
//	CvFileStorage* fs = cvOpenFileStorage(
//		"cfg.xml",
//		0,
//		CV_STORAGE_READ
//		);
//
//	//
//	// ��������� ��������
//	//
//	int frame_count = cvReadIntByName(
//		fs,
//		0,
//		"frame_count",
//		5 // �������� ��-���������
//		);
//
//	CvSeq* s = cvGetFileNodeByName(fs,0,"frame_size")->data.seq;
//
//	int frame_width = cvReadInt(
//		(CvFileNode*)cvGetSeqElem(s,0)
//		);
//
//	int frame_height = cvReadInt(
//		(CvFileNode*)cvGetSeqElem(s,1)
//		);
//
//	CvMat* color_cvt_matrix = (CvMat*) cvRead(
//		fs,
//		0
//		);
//
//	// ����������
//	printf("frame_count=%d, frame_width=%d, frame_height=%d\n",frame_count,frame_width,frame_height);
//
//	cvReleaseFileStorage( &fs );



  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
