program HoughLines;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  core_c in '..\..\include\�ore\core_c.pas',
  Core.types_c in '..\..\include\�ore\Core.types_c.pas',
  highgui_c in '..\..\include\highgui\highgui_c.pas',
  imgproc.types_c in '..\..\include\imgproc\imgproc.types_c.pas',
  imgproc_c in '..\..\include\imgproc\imgproc_c.pas';

const
  filename = 'opencv_logo_with_text_sm.png';

Var
   src      :pIplImage= Nil;
	 dst      :pIplImage=Nil;
	 color_dst:pIplImage=Nil;
   storage:pCvMemStorage;
   i:Integer;
   lines:pCvSeq;
   line:pCvPointArray;

begin

	// �������� �������� (� ��������� ������)
	src := cvLoadImage(filename, CV_LOAD_IMAGE_GRAYSCALE);
  WriteLn(Format('[i] image: %s', [filename]));

	// ��������� ������ ��� �������� ��������� �����
	storage := cvCreateMemStorage(0);
	lines := nil;
	i := 0;

	dst := cvCreateImage( cvGetSize(src), 8, 1 );
	color_dst := cvCreateImage( cvGetSize(src), 8, 3 );

	// �������������� ������
	cvCanny( src, dst, 50, 200, 3 );

	// ������������ � ������� �����������
	cvCvtColor( dst, color_dst, CV_GRAY2BGR );

	// ���������� �����
	lines := cvHoughLines2( dst, storage, CV_HOUGH_PROBABILISTIC, 1, CV_PI/180, 50, 50, 10 );

	// �������� ��������� �����
	for i := 0 to lines^.total-1 do
  begin
		line := pCvPointArray(cvGetSeqElem(lines,i));
		cvLine(color_dst, line^[0], line^[1], CV_RGB(255,0,0), 3, CV_AA, 0 );
	end;

	// ����������
	cvNamedWindow( 'Source', 1 );
	cvShowImage( 'Source', src );

	cvNamedWindow( 'Hough', 1 );
	cvShowImage( 'Hough', color_dst );

	// ��� ������� �������
	cvWaitKey(0);

	// ����������� �������
	cvReleaseMemStorage(storage);
	cvReleaseImage(src);
	cvReleaseImage(dst);
	cvReleaseImage(color_dst);
	cvDestroyAllWindows();
end.
