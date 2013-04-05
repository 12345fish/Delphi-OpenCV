// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_WarpPerspective;

{$APPTYPE CONSOLE}
{$POINTERMATH ON}
{$R *.res}

uses
  System.SysUtils,
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
Core in '..\..\..\include\�ore\core.pas'
  ;

const
  filename = 'resource\opencv_logo_with_text.png';

Var
  src: pIplImage = nil;
  dst: pIplImage = nil;
  srcQuad, dstQuad: pCvPoint2D32f;
  warp_matrix: pCvMat;

begin
  try
    // �������� �������� (� ��������� ������)
    src := cvLoadImage(filename, CV_LOAD_IMAGE_GRAYSCALE);
    WriteLn(Format('[i] image: %s', [filename]));

    cvNamedWindow('Original', CV_WINDOW_AUTOSIZE);
    cvShowImage('Original', src);

    // ������� ��������������
    warp_matrix := cvCreateMat(3, 3, CV_32FC1);

    // ��������� ��������
    dst := cvCloneImage(src);

    // ����� �����
    srcQuad := AllocMem(SizeOf(TCvPoint2D32f) * 4);
    dstQuad := AllocMem(SizeOf(TCvPoint2D32f) * 4);
    srcQuad[0].x := 0; // src Top left
    srcQuad[0].y := 0;
    srcQuad[1].x := src.width - 1; // src Top right
    srcQuad[1].y := 0;
    srcQuad[2].x := 0; // src Bottom left
    srcQuad[2].y := src.height - 1;
    srcQuad[3].x := src.width - 1; // src Bot right
    srcQuad[3].y := src.height - 1;
    // - - - - - - - - - - - - - -//
    dstQuad[0].x := src.width * 0.05; // dst Top left
    dstQuad[0].y := src.height * 0.33;
    dstQuad[1].x := src.width * 0.9; // dst Top right
    dstQuad[1].y := src.height * 0.25;
    dstQuad[2].x := src.width * 0.2; // dst Bottom left
    dstQuad[2].y := src.height * 0.7;
    dstQuad[3].x := src.width * 0.8; // dst Bot right
    dstQuad[3].y := src.height * 0.9;

    // �������� ������� ��������������
    cvGetPerspectiveTransform(srcQuad, dstQuad, warp_matrix);
    // �������������� �����������
    // CV_WARP_INVERSE_MAP � ������������ �������� ������������� �� dst � src
    // CV_WARP_FILL_OUTLIERS � ��������� ��� ������� �������� ����������� (���� ������� ����������� �� �������� ���������� ������������ fillval)
    // fillval � �������� ��� ���������� �������� ��� ��������� �����������
    cvWarpPerspective(src, dst, warp_matrix, CV_INTER_LINEAR or CV_WARP_FILL_OUTLIERS, cvScalarAll(0));

    // ����������
    cvNamedWindow('WarpPerspective', CV_LOAD_IMAGE_GRAYSCALE);
    cvShowImage('WarpPerspective', dst);

    // ��� ������� �������
    cvWaitKey(0);

    // ����������� �������
    FreeMem(srcQuad);
    FreeMem(dstQuad);
    cvReleaseImage(src);
    cvReleaseImage(dst);
    cvReleaseMat(warp_matrix);
    cvDestroyAllWindows();
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
