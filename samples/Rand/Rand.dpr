program Rand;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Core.types_c in '..\..\include\�ore\Core.types_c.pas',
  core_c in '..\..\include\�ore\core_c.pas',
  highgui_c in '..\..\include\highgui\highgui_c.pas';

Const
  // ��� ��������
  filename = 'opencv_logo_with_text.png';

Type
  TArrayOfByte = array [0 .. 0] of Byte;
  pArrayOfByte = ^TArrayOfByte;

Var
  // ��������
  image: PIplImage = nil;
  dst: PIplImage = nil;
  count, x, y: Integer;
  rng: TCvRNG;
  ptr: pArrayOfByte;

begin
  try
    // �������� ��������
    image := cvLoadImage(filename, 1);
    Writeln('[i] image: ', filename);
    if not Assigned(image) then
      Halt;
    // ��������� ��������
    dst := cvCloneImage(image);
    count := 0;
    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('noise', CV_WINDOW_AUTOSIZE);

    // ������������� ��������� ����
    rng := TCvRNG($7FFFFFFF);

    // ����������� �� ���� �������� �����������
    for y := 0 to dst^.height - 1 do
    begin
      ptr := pArrayOfByte(dst^.imageData + y * dst^.widthStep);
      for x := 0 to dst^.width - 1 do
      begin
        if (cvRandInt(rng) mod 100) >= 97 then
        begin
          // 3 ������
          ptr[3 * x] := cvRandInt(rng) mod 255; // B
          ptr[3 * x + 1] := cvRandInt(rng) mod 255; // G
          ptr[3 * x + 2] := cvRandInt(rng) mod 255; // R
          Inc(count);

          // ������� �������
          ptr[3 * x] := 0;
          ptr[3 * x + 1] := 0;
          ptr[3 * x + 2] := 255;
        end;
      end;
    end;

    Writeln(Format('[i] noise: %d(%.2f %%)', [count, count / (dst^.height * dst^.width) * 100]));

    // ���������� ��������
    cvShowImage('original', image);
    cvShowImage('noise', dst);

    // ��� ������� �������
    cvWaitKey(0);

    // ����������� �������
    cvReleaseImage(image);
    cvReleaseImage(dst);
    // ������� ����
    cvDestroyWindow('original');
    cvDestroyWindow('noise');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
