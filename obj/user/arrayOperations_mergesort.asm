
obj/user/arrayOperations_mergesort:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 93 1c 00 00       	call   801cd6 <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  800046:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int *sharedArray = NULL;
  80004d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	68 20 35 80 00       	push   $0x803520
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 43 17 00 00       	call   8017a7 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 24 35 80 00       	push   $0x803524
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 2d 17 00 00       	call   8017a7 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 2c 35 80 00       	push   $0x80352c
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 10 17 00 00       	call   8017a7 <sget>
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  80009d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a0:	8b 00                	mov    (%eax),%eax
  8000a2:	c1 e0 02             	shl    $0x2,%eax
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	50                   	push   %eax
  8000ab:	68 3a 35 80 00       	push   $0x80353a
  8000b0:	e8 49 16 00 00       	call   8016fe <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000c2:	eb 25                	jmp    8000e9 <_main+0xb1>
	{
		sortedArray[i] = sharedArray[i];
  8000c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	01 c2                	add    %eax,%edx
  8000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e0:	01 c8                	add    %ecx,%eax
  8000e2:	8b 00                	mov    (%eax),%eax
  8000e4:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ec:	8b 00                	mov    (%eax),%eax
  8000ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f1:	7f d1                	jg     8000c4 <_main+0x8c>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  8000f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f6:	8b 00                	mov    (%eax),%eax
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	50                   	push   %eax
  8000fc:	6a 01                	push   $0x1
  8000fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800101:	e8 fc 00 00 00       	call   800202 <MSort>
  800106:	83 c4 10             	add    $0x10,%esp
	cprintf("Merge sort is Finished!!!!\n") ;
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 49 35 80 00       	push   $0x803549
  800111:	e8 6d 05 00 00       	call   800683 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	8d 50 01             	lea    0x1(%eax),%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	89 10                	mov    %edx,(%eax)

}
  800126:	90                   	nop
  800127:	c9                   	leave  
  800128:	c3                   	ret    

00800129 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80012f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800132:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800139:	8b 45 08             	mov    0x8(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8b 00                	mov    (%eax),%eax
  800140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800143:	8b 45 0c             	mov    0xc(%ebp),%eax
  800146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80014d:	8b 45 08             	mov    0x8(%ebp),%eax
  800150:	01 c2                	add    %eax,%edx
  800152:	8b 45 10             	mov    0x10(%ebp),%eax
  800155:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	01 c8                	add    %ecx,%eax
  800161:	8b 00                	mov    (%eax),%eax
  800163:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800165:	8b 45 10             	mov    0x10(%ebp),%eax
  800168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016f:	8b 45 08             	mov    0x8(%ebp),%eax
  800172:	01 c2                	add    %eax,%edx
  800174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800177:	89 02                	mov    %eax,(%edx)
}
  800179:	90                   	nop
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800182:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800190:	eb 42                	jmp    8001d4 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800195:	99                   	cltd   
  800196:	f7 7d f0             	idivl  -0x10(%ebp)
  800199:	89 d0                	mov    %edx,%eax
  80019b:	85 c0                	test   %eax,%eax
  80019d:	75 10                	jne    8001af <PrintElements+0x33>
			cprintf("\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 65 35 80 00       	push   $0x803565
  8001a7:	e8 d7 04 00 00       	call   800683 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 67 35 80 00       	push   $0x803567
  8001c9:	e8 b5 04 00 00       	call   800683 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8001d1:	ff 45 f4             	incl   -0xc(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	48                   	dec    %eax
  8001d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8001db:	7f b5                	jg     800192 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8001dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ea:	01 d0                	add    %edx,%eax
  8001ec:	8b 00                	mov    (%eax),%eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	50                   	push   %eax
  8001f2:	68 6c 35 80 00       	push   $0x80356c
  8001f7:	e8 87 04 00 00       	call   800683 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp

}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <MSort>:


void MSort(int* A, int p, int r)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80020e:	7d 54                	jge    800264 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	8b 45 10             	mov    0x10(%ebp),%eax
  800216:	01 d0                	add    %edx,%eax
  800218:	89 c2                	mov    %eax,%edx
  80021a:	c1 ea 1f             	shr    $0x1f,%edx
  80021d:	01 d0                	add    %edx,%eax
  80021f:	d1 f8                	sar    %eax
  800221:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	ff 75 f4             	pushl  -0xc(%ebp)
  80022a:	ff 75 0c             	pushl  0xc(%ebp)
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 cd ff ff ff       	call   800202 <MSort>
  800235:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  800238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023b:	40                   	inc    %eax
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	50                   	push   %eax
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 b7 ff ff ff       	call   800202 <MSort>
  80024b:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	ff 75 f4             	pushl  -0xc(%ebp)
  800254:	ff 75 0c             	pushl  0xc(%ebp)
  800257:	ff 75 08             	pushl  0x8(%ebp)
  80025a:	e8 08 00 00 00       	call   800267 <Merge>
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	eb 01                	jmp    800265 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800264:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80026d:	8b 45 10             	mov    0x10(%ebp),%eax
  800270:	2b 45 0c             	sub    0xc(%ebp),%eax
  800273:	40                   	inc    %eax
  800274:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800277:	8b 45 14             	mov    0x14(%ebp),%eax
  80027a:	2b 45 10             	sub    0x10(%ebp),%eax
  80027d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800287:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80028e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800291:	c1 e0 02             	shl    $0x2,%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 12 13 00 00       	call   8015af <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8002a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a6:	c1 e0 02             	shl    $0x2,%eax
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	e8 fd 12 00 00       	call   8015af <malloc>
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002bf:	eb 2f                	jmp    8002f0 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8002c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ce:	01 c2                	add    %eax,%edx
  8002d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8002dd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 c8                	add    %ecx,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002ed:	ff 45 ec             	incl   -0x14(%ebp)
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002f6:	7c c9                	jl     8002c1 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8002f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ff:	eb 2a                	jmp    80032b <Merge+0xc4>
	{
		Right[j] = A[q + j];
  800301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80030e:	01 c2                	add    %eax,%edx
  800310:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800316:	01 c8                	add    %ecx,%eax
  800318:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031f:	8b 45 08             	mov    0x8(%ebp),%eax
  800322:	01 c8                	add    %ecx,%eax
  800324:	8b 00                	mov    (%eax),%eax
  800326:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800328:	ff 45 e8             	incl   -0x18(%ebp)
  80032b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	7c ce                	jl     800301 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800339:	e9 0a 01 00 00       	jmp    800448 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  80033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800341:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800344:	0f 8d 95 00 00 00    	jge    8003df <Merge+0x178>
  80034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	0f 8d 89 00 00 00    	jge    8003df <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 10                	mov    (%eax),%edx
  800367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8b 00                	mov    (%eax),%eax
  800378:	39 c2                	cmp    %eax,%edx
  80037a:	7d 33                	jge    8003af <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80037c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037f:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800394:	8d 50 01             	lea    0x1(%eax),%edx
  800397:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003aa:	e9 96 00 00 00       	jmp    800445 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  8003af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8003cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d7:	01 d0                	add    %edx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003dd:	eb 66                	jmp    800445 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003e5:	7d 30                	jge    800417 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8003e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ea:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ff:	8d 50 01             	lea    0x1(%eax),%edx
  800402:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	89 01                	mov    %eax,(%ecx)
  800415:	eb 2e                	jmp    800445 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80041f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 50 01             	lea    0x1(%eax),%edx
  800432:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800445:	ff 45 e4             	incl   -0x1c(%ebp)
  800448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80044b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80044e:	0f 8e ea fe ff ff    	jle    80033e <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	ff 75 d8             	pushl  -0x28(%ebp)
  80045a:	e8 cb 11 00 00       	call   80162a <free>
  80045f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 d4             	pushl  -0x2c(%ebp)
  800468:	e8 bd 11 00 00       	call   80162a <free>
  80046d:	83 c4 10             	add    $0x10,%esp

}
  800470:	90                   	nop
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 3f 18 00 00       	call   801cbd <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 e1 15 00 00       	call   801aca <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 88 35 80 00       	push   $0x803588
  8004f1:	e8 8d 01 00 00       	call   800683 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 40 80 00       	mov    0x804020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 b0 35 80 00       	push   $0x8035b0
  800519:	e8 65 01 00 00       	call   800683 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 40 80 00       	mov    0x804020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 40 80 00       	mov    0x804020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 40 80 00       	mov    0x804020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 d8 35 80 00       	push   $0x8035d8
  80054a:	e8 34 01 00 00       	call   800683 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 40 80 00       	mov    0x804020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 30 36 80 00       	push   $0x803630
  800566:	e8 18 01 00 00       	call   800683 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 88 35 80 00       	push   $0x803588
  800576:	e8 08 01 00 00       	call   800683 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 61 15 00 00       	call   801ae4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 ee 16 00 00       	call   801c89 <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 43 17 00 00       	call   801cef <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8005bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c0:	89 0a                	mov    %ecx,(%edx)
  8005c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c5:	88 d1                	mov    %dl,%cl
  8005c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005d8:	75 2c                	jne    800606 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005da:	a0 24 40 80 00       	mov    0x804024,%al
  8005df:	0f b6 c0             	movzbl %al,%eax
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	8b 12                	mov    (%edx),%edx
  8005e7:	89 d1                	mov    %edx,%ecx
  8005e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ec:	83 c2 08             	add    $0x8,%edx
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	50                   	push   %eax
  8005f3:	51                   	push   %ecx
  8005f4:	52                   	push   %edx
  8005f5:	e8 22 13 00 00       	call   80191c <sys_cputs>
  8005fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800600:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	8b 40 04             	mov    0x4(%eax),%eax
  80060c:	8d 50 01             	lea    0x1(%eax),%edx
  80060f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800612:	89 50 04             	mov    %edx,0x4(%eax)
}
  800615:	90                   	nop
  800616:	c9                   	leave  
  800617:	c3                   	ret    

00800618 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800621:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800628:	00 00 00 
	b.cnt = 0;
  80062b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800632:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 08             	pushl  0x8(%ebp)
  80063b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800641:	50                   	push   %eax
  800642:	68 af 05 80 00       	push   $0x8005af
  800647:	e8 11 02 00 00       	call   80085d <vprintfmt>
  80064c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80064f:	a0 24 40 80 00       	mov    0x804024,%al
  800654:	0f b6 c0             	movzbl %al,%eax
  800657:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	50                   	push   %eax
  800661:	52                   	push   %edx
  800662:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800668:	83 c0 08             	add    $0x8,%eax
  80066b:	50                   	push   %eax
  80066c:	e8 ab 12 00 00       	call   80191c <sys_cputs>
  800671:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800674:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80067b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800681:	c9                   	leave  
  800682:	c3                   	ret    

00800683 <cprintf>:

int cprintf(const char *fmt, ...) {
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800689:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800690:	8d 45 0c             	lea    0xc(%ebp),%eax
  800693:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	ff 75 f4             	pushl  -0xc(%ebp)
  80069f:	50                   	push   %eax
  8006a0:	e8 73 ff ff ff       	call   800618 <vcprintf>
  8006a5:	83 c4 10             	add    $0x10,%esp
  8006a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006b6:	e8 0f 14 00 00       	call   801aca <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ca:	50                   	push   %eax
  8006cb:	e8 48 ff ff ff       	call   800618 <vcprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006d6:	e8 09 14 00 00       	call   801ae4 <sys_enable_interrupt>
	return cnt;
  8006db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	53                   	push   %ebx
  8006e4:	83 ec 14             	sub    $0x14,%esp
  8006e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006fe:	77 55                	ja     800755 <printnum+0x75>
  800700:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800703:	72 05                	jb     80070a <printnum+0x2a>
  800705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800708:	77 4b                	ja     800755 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80070a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80070d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800710:	8b 45 18             	mov    0x18(%ebp),%eax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	52                   	push   %edx
  800719:	50                   	push   %eax
  80071a:	ff 75 f4             	pushl  -0xc(%ebp)
  80071d:	ff 75 f0             	pushl  -0x10(%ebp)
  800720:	e8 93 2b 00 00       	call   8032b8 <__udivdi3>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	83 ec 04             	sub    $0x4,%esp
  80072b:	ff 75 20             	pushl  0x20(%ebp)
  80072e:	53                   	push   %ebx
  80072f:	ff 75 18             	pushl  0x18(%ebp)
  800732:	52                   	push   %edx
  800733:	50                   	push   %eax
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	ff 75 08             	pushl  0x8(%ebp)
  80073a:	e8 a1 ff ff ff       	call   8006e0 <printnum>
  80073f:	83 c4 20             	add    $0x20,%esp
  800742:	eb 1a                	jmp    80075e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 20             	pushl  0x20(%ebp)
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	ff d0                	call   *%eax
  800752:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800755:	ff 4d 1c             	decl   0x1c(%ebp)
  800758:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80075c:	7f e6                	jg     800744 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80075e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800761:	bb 00 00 00 00       	mov    $0x0,%ebx
  800766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076c:	53                   	push   %ebx
  80076d:	51                   	push   %ecx
  80076e:	52                   	push   %edx
  80076f:	50                   	push   %eax
  800770:	e8 53 2c 00 00       	call   8033c8 <__umoddi3>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	05 74 38 80 00       	add    $0x803874,%eax
  80077d:	8a 00                	mov    (%eax),%al
  80077f:	0f be c0             	movsbl %al,%eax
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 0c             	pushl  0xc(%ebp)
  800788:	50                   	push   %eax
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	ff d0                	call   *%eax
  80078e:	83 c4 10             	add    $0x10,%esp
}
  800791:	90                   	nop
  800792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800795:	c9                   	leave  
  800796:	c3                   	ret    

00800797 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079e:	7e 1c                	jle    8007bc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	8d 50 08             	lea    0x8(%eax),%edx
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	89 10                	mov    %edx,(%eax)
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 e8 08             	sub    $0x8,%eax
  8007b5:	8b 50 04             	mov    0x4(%eax),%edx
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	eb 40                	jmp    8007fc <getuint+0x65>
	else if (lflag)
  8007bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c0:	74 1e                	je     8007e0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	89 10                	mov    %edx,(%eax)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	83 e8 04             	sub    $0x4,%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007de:	eb 1c                	jmp    8007fc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	8d 50 04             	lea    0x4(%eax),%edx
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	89 10                	mov    %edx,(%eax)
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	83 e8 04             	sub    $0x4,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800801:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800805:	7e 1c                	jle    800823 <getint+0x25>
		return va_arg(*ap, long long);
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	8d 50 08             	lea    0x8(%eax),%edx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	89 10                	mov    %edx,(%eax)
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	83 e8 08             	sub    $0x8,%eax
  80081c:	8b 50 04             	mov    0x4(%eax),%edx
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	eb 38                	jmp    80085b <getint+0x5d>
	else if (lflag)
  800823:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800827:	74 1a                	je     800843 <getint+0x45>
		return va_arg(*ap, long);
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	8d 50 04             	lea    0x4(%eax),%edx
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	89 10                	mov    %edx,(%eax)
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	83 e8 04             	sub    $0x4,%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	99                   	cltd   
  800841:	eb 18                	jmp    80085b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	8d 50 04             	lea    0x4(%eax),%edx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 10                	mov    %edx,(%eax)
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	83 e8 04             	sub    $0x4,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	99                   	cltd   
}
  80085b:	5d                   	pop    %ebp
  80085c:	c3                   	ret    

0080085d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	56                   	push   %esi
  800861:	53                   	push   %ebx
  800862:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800865:	eb 17                	jmp    80087e <vprintfmt+0x21>
			if (ch == '\0')
  800867:	85 db                	test   %ebx,%ebx
  800869:	0f 84 af 03 00 00    	je     800c1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	53                   	push   %ebx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087e:	8b 45 10             	mov    0x10(%ebp),%eax
  800881:	8d 50 01             	lea    0x1(%eax),%edx
  800884:	89 55 10             	mov    %edx,0x10(%ebp)
  800887:	8a 00                	mov    (%eax),%al
  800889:	0f b6 d8             	movzbl %al,%ebx
  80088c:	83 fb 25             	cmp    $0x25,%ebx
  80088f:	75 d6                	jne    800867 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800891:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800895:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80089c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b4:	8d 50 01             	lea    0x1(%eax),%edx
  8008b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ba:	8a 00                	mov    (%eax),%al
  8008bc:	0f b6 d8             	movzbl %al,%ebx
  8008bf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008c2:	83 f8 55             	cmp    $0x55,%eax
  8008c5:	0f 87 2b 03 00 00    	ja     800bf6 <vprintfmt+0x399>
  8008cb:	8b 04 85 98 38 80 00 	mov    0x803898(,%eax,4),%eax
  8008d2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008d4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008d8:	eb d7                	jmp    8008b1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008da:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008de:	eb d1                	jmp    8008b1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ea:	89 d0                	mov    %edx,%eax
  8008ec:	c1 e0 02             	shl    $0x2,%eax
  8008ef:	01 d0                	add    %edx,%eax
  8008f1:	01 c0                	add    %eax,%eax
  8008f3:	01 d8                	add    %ebx,%eax
  8008f5:	83 e8 30             	sub    $0x30,%eax
  8008f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fe:	8a 00                	mov    (%eax),%al
  800900:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800903:	83 fb 2f             	cmp    $0x2f,%ebx
  800906:	7e 3e                	jle    800946 <vprintfmt+0xe9>
  800908:	83 fb 39             	cmp    $0x39,%ebx
  80090b:	7f 39                	jg     800946 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800910:	eb d5                	jmp    8008e7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800926:	eb 1f                	jmp    800947 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	79 83                	jns    8008b1 <vprintfmt+0x54>
				width = 0;
  80092e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800935:	e9 77 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80093a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800941:	e9 6b ff ff ff       	jmp    8008b1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800946:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800947:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094b:	0f 89 60 ff ff ff    	jns    8008b1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800957:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80095e:	e9 4e ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800963:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800966:	e9 46 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 c0 04             	add    $0x4,%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	83 e8 04             	sub    $0x4,%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	50                   	push   %eax
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
			break;
  80098b:	e9 89 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009a1:	85 db                	test   %ebx,%ebx
  8009a3:	79 02                	jns    8009a7 <vprintfmt+0x14a>
				err = -err;
  8009a5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009a7:	83 fb 64             	cmp    $0x64,%ebx
  8009aa:	7f 0b                	jg     8009b7 <vprintfmt+0x15a>
  8009ac:	8b 34 9d e0 36 80 00 	mov    0x8036e0(,%ebx,4),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 19                	jne    8009d0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b7:	53                   	push   %ebx
  8009b8:	68 85 38 80 00       	push   $0x803885
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 5e 02 00 00       	call   800c26 <printfmt>
  8009c8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009cb:	e9 49 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009d0:	56                   	push   %esi
  8009d1:	68 8e 38 80 00       	push   $0x80388e
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 45 02 00 00       	call   800c26 <printfmt>
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 30 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	83 c0 04             	add    $0x4,%eax
  8009ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	83 e8 04             	sub    $0x4,%eax
  8009f8:	8b 30                	mov    (%eax),%esi
  8009fa:	85 f6                	test   %esi,%esi
  8009fc:	75 05                	jne    800a03 <vprintfmt+0x1a6>
				p = "(null)";
  8009fe:	be 91 38 80 00       	mov    $0x803891,%esi
			if (width > 0 && padc != '-')
  800a03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a07:	7e 6d                	jle    800a76 <vprintfmt+0x219>
  800a09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a0d:	74 67                	je     800a76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	50                   	push   %eax
  800a16:	56                   	push   %esi
  800a17:	e8 0c 03 00 00       	call   800d28 <strnlen>
  800a1c:	83 c4 10             	add    $0x10,%esp
  800a1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a22:	eb 16                	jmp    800a3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	50                   	push   %eax
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a37:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3e:	7f e4                	jg     800a24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a40:	eb 34                	jmp    800a76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a46:	74 1c                	je     800a64 <vprintfmt+0x207>
  800a48:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4b:	7e 05                	jle    800a52 <vprintfmt+0x1f5>
  800a4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800a50:	7e 12                	jle    800a64 <vprintfmt+0x207>
					putch('?', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 3f                	push   $0x3f
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	eb 0f                	jmp    800a73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	53                   	push   %ebx
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	89 f0                	mov    %esi,%eax
  800a78:	8d 70 01             	lea    0x1(%eax),%esi
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	0f be d8             	movsbl %al,%ebx
  800a80:	85 db                	test   %ebx,%ebx
  800a82:	74 24                	je     800aa8 <vprintfmt+0x24b>
  800a84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a88:	78 b8                	js     800a42 <vprintfmt+0x1e5>
  800a8a:	ff 4d e0             	decl   -0x20(%ebp)
  800a8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a91:	79 af                	jns    800a42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a93:	eb 13                	jmp    800aa8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	6a 20                	push   $0x20
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	ff d0                	call   *%eax
  800aa2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aac:	7f e7                	jg     800a95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aae:	e9 66 01 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 3c fd ff ff       	call   8007fe <getint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad1:	85 d2                	test   %edx,%edx
  800ad3:	79 23                	jns    800af8 <vprintfmt+0x29b>
				putch('-', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 2d                	push   $0x2d
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aeb:	f7 d8                	neg    %eax
  800aed:	83 d2 00             	adc    $0x0,%edx
  800af0:	f7 da                	neg    %edx
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800af8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aff:	e9 bc 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0d:	50                   	push   %eax
  800b0e:	e8 84 fc ff ff       	call   800797 <getuint>
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b23:	e9 98 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	6a 58                	push   $0x58
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	ff d0                	call   *%eax
  800b35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	6a 58                	push   $0x58
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	ff d0                	call   *%eax
  800b45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	6a 58                	push   $0x58
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			break;
  800b58:	e9 bc 00 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 30                	push   $0x30
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 78                	push   $0x78
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b80:	83 c0 04             	add    $0x4,%eax
  800b83:	89 45 14             	mov    %eax,0x14(%ebp)
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	83 e8 04             	sub    $0x4,%eax
  800b8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b9f:	eb 1f                	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba7:	8d 45 14             	lea    0x14(%ebp),%eax
  800baa:	50                   	push   %eax
  800bab:	e8 e7 fb ff ff       	call   800797 <getuint>
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bc0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc7:	83 ec 04             	sub    $0x4,%esp
  800bca:	52                   	push   %edx
  800bcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bce:	50                   	push   %eax
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	ff 75 08             	pushl  0x8(%ebp)
  800bdb:	e8 00 fb ff ff       	call   8006e0 <printnum>
  800be0:	83 c4 20             	add    $0x20,%esp
			break;
  800be3:	eb 34                	jmp    800c19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	53                   	push   %ebx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	ff d0                	call   *%eax
  800bf1:	83 c4 10             	add    $0x10,%esp
			break;
  800bf4:	eb 23                	jmp    800c19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 25                	push   $0x25
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c06:	ff 4d 10             	decl   0x10(%ebp)
  800c09:	eb 03                	jmp    800c0e <vprintfmt+0x3b1>
  800c0b:	ff 4d 10             	decl   0x10(%ebp)
  800c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c11:	48                   	dec    %eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	3c 25                	cmp    $0x25,%al
  800c16:	75 f3                	jne    800c0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c18:	90                   	nop
		}
	}
  800c19:	e9 47 fc ff ff       	jmp    800865 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2f:	83 c0 04             	add    $0x4,%eax
  800c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c35:	8b 45 10             	mov    0x10(%ebp),%eax
  800c38:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 16 fc ff ff       	call   80085d <vprintfmt>
  800c47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c4a:	90                   	nop
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8b 40 08             	mov    0x8(%eax),%eax
  800c56:	8d 50 01             	lea    0x1(%eax),%edx
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	8b 10                	mov    (%eax),%edx
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	8b 40 04             	mov    0x4(%eax),%eax
  800c6a:	39 c2                	cmp    %eax,%edx
  800c6c:	73 12                	jae    800c80 <sprintputch+0x33>
		*b->buf++ = ch;
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 48 01             	lea    0x1(%eax),%ecx
  800c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c79:	89 0a                	mov    %ecx,(%edx)
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	88 10                	mov    %dl,(%eax)
}
  800c80:	90                   	nop
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	01 d0                	add    %edx,%eax
  800c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ca4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ca8:	74 06                	je     800cb0 <vsnprintf+0x2d>
  800caa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cae:	7f 07                	jg     800cb7 <vsnprintf+0x34>
		return -E_INVAL;
  800cb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb5:	eb 20                	jmp    800cd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cb7:	ff 75 14             	pushl  0x14(%ebp)
  800cba:	ff 75 10             	pushl  0x10(%ebp)
  800cbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc0:	50                   	push   %eax
  800cc1:	68 4d 0c 80 00       	push   $0x800c4d
  800cc6:	e8 92 fb ff ff       	call   80085d <vprintfmt>
  800ccb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cee:	50                   	push   %eax
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	ff 75 08             	pushl  0x8(%ebp)
  800cf5:	e8 89 ff ff ff       	call   800c83 <vsnprintf>
  800cfa:	83 c4 10             	add    $0x10,%esp
  800cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d12:	eb 06                	jmp    800d1a <strlen+0x15>
		n++;
  800d14:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	84 c0                	test   %al,%al
  800d21:	75 f1                	jne    800d14 <strlen+0xf>
		n++;
	return n;
  800d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d35:	eb 09                	jmp    800d40 <strnlen+0x18>
		n++;
  800d37:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d3a:	ff 45 08             	incl   0x8(%ebp)
  800d3d:	ff 4d 0c             	decl   0xc(%ebp)
  800d40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d44:	74 09                	je     800d4f <strnlen+0x27>
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	75 e8                	jne    800d37 <strnlen+0xf>
		n++;
	return n;
  800d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d60:	90                   	nop
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d73:	8a 12                	mov    (%edx),%dl
  800d75:	88 10                	mov    %dl,(%eax)
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	84 c0                	test   %al,%al
  800d7b:	75 e4                	jne    800d61 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d95:	eb 1f                	jmp    800db6 <strncpy+0x34>
		*dst++ = *src;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8d 50 01             	lea    0x1(%eax),%edx
  800d9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da3:	8a 12                	mov    (%edx),%dl
  800da5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	84 c0                	test   %al,%al
  800dae:	74 03                	je     800db3 <strncpy+0x31>
			src++;
  800db0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db3:	ff 45 fc             	incl   -0x4(%ebp)
  800db6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dbc:	72 d9                	jb     800d97 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc1:	c9                   	leave  
  800dc2:	c3                   	ret    

00800dc3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd3:	74 30                	je     800e05 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dd5:	eb 16                	jmp    800ded <strlcpy+0x2a>
			*dst++ = *src++;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8d 50 01             	lea    0x1(%eax),%edx
  800ddd:	89 55 08             	mov    %edx,0x8(%ebp)
  800de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de9:	8a 12                	mov    (%edx),%dl
  800deb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	74 09                	je     800dff <strlcpy+0x3c>
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	84 c0                	test   %al,%al
  800dfd:	75 d8                	jne    800dd7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0b:	29 c2                	sub    %eax,%edx
  800e0d:	89 d0                	mov    %edx,%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e14:	eb 06                	jmp    800e1c <strcmp+0xb>
		p++, q++;
  800e16:	ff 45 08             	incl   0x8(%ebp)
  800e19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	84 c0                	test   %al,%al
  800e23:	74 0e                	je     800e33 <strcmp+0x22>
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 10                	mov    (%eax),%dl
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	38 c2                	cmp    %al,%dl
  800e31:	74 e3                	je     800e16 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 d0             	movzbl %al,%edx
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f b6 c0             	movzbl %al,%eax
  800e43:	29 c2                	sub    %eax,%edx
  800e45:	89 d0                	mov    %edx,%eax
}
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e4c:	eb 09                	jmp    800e57 <strncmp+0xe>
		n--, p++, q++;
  800e4e:	ff 4d 10             	decl   0x10(%ebp)
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	74 17                	je     800e74 <strncmp+0x2b>
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	84 c0                	test   %al,%al
  800e64:	74 0e                	je     800e74 <strncmp+0x2b>
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 10                	mov    (%eax),%dl
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	38 c2                	cmp    %al,%dl
  800e72:	74 da                	je     800e4e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e78:	75 07                	jne    800e81 <strncmp+0x38>
		return 0;
  800e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7f:	eb 14                	jmp    800e95 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f b6 d0             	movzbl %al,%edx
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 c0             	movzbl %al,%eax
  800e91:	29 c2                	sub    %eax,%edx
  800e93:	89 d0                	mov    %edx,%eax
}
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea3:	eb 12                	jmp    800eb7 <strchr+0x20>
		if (*s == c)
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ead:	75 05                	jne    800eb4 <strchr+0x1d>
			return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	eb 11                	jmp    800ec5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eb4:	ff 45 08             	incl   0x8(%ebp)
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	84 c0                	test   %al,%al
  800ebe:	75 e5                	jne    800ea5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed3:	eb 0d                	jmp    800ee2 <strfind+0x1b>
		if (*s == c)
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800edd:	74 0e                	je     800eed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800edf:	ff 45 08             	incl   0x8(%ebp)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 ea                	jne    800ed5 <strfind+0xe>
  800eeb:	eb 01                	jmp    800eee <strfind+0x27>
		if (*s == c)
			break;
  800eed:	90                   	nop
	return (char *) s;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f05:	eb 0e                	jmp    800f15 <memset+0x22>
		*p++ = c;
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	8d 50 01             	lea    0x1(%eax),%edx
  800f0d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f13:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f15:	ff 4d f8             	decl   -0x8(%ebp)
  800f18:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f1c:	79 e9                	jns    800f07 <memset+0x14>
		*p++ = c;

	return v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f35:	eb 16                	jmp    800f4d <memcpy+0x2a>
		*d++ = *s++;
  800f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f46:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f49:	8a 12                	mov    (%edx),%dl
  800f4b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f53:	89 55 10             	mov    %edx,0x10(%ebp)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	75 dd                	jne    800f37 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f77:	73 50                	jae    800fc9 <memmove+0x6a>
  800f79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f84:	76 43                	jbe    800fc9 <memmove+0x6a>
		s += n;
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f92:	eb 10                	jmp    800fa4 <memmove+0x45>
			*--d = *--s;
  800f94:	ff 4d f8             	decl   -0x8(%ebp)
  800f97:	ff 4d fc             	decl   -0x4(%ebp)
  800f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9d:	8a 10                	mov    (%eax),%dl
  800f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800faa:	89 55 10             	mov    %edx,0x10(%ebp)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 e3                	jne    800f94 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb1:	eb 23                	jmp    800fd6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb6:	8d 50 01             	lea    0x1(%eax),%edx
  800fb9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc5:	8a 12                	mov    (%edx),%dl
  800fc7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 dd                	jne    800fb3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    

00800fdb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fed:	eb 2a                	jmp    801019 <memcmp+0x3e>
		if (*s1 != *s2)
  800fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff2:	8a 10                	mov    (%eax),%dl
  800ff4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	38 c2                	cmp    %al,%dl
  800ffb:	74 16                	je     801013 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f b6 d0             	movzbl %al,%edx
  801005:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f b6 c0             	movzbl %al,%eax
  80100d:	29 c2                	sub    %eax,%edx
  80100f:	89 d0                	mov    %edx,%eax
  801011:	eb 18                	jmp    80102b <memcmp+0x50>
		s1++, s2++;
  801013:	ff 45 fc             	incl   -0x4(%ebp)
  801016:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801019:	8b 45 10             	mov    0x10(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	89 55 10             	mov    %edx,0x10(%ebp)
  801022:	85 c0                	test   %eax,%eax
  801024:	75 c9                	jne    800fef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103e:	eb 15                	jmp    801055 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	0f b6 c0             	movzbl %al,%eax
  80104e:	39 c2                	cmp    %eax,%edx
  801050:	74 0d                	je     80105f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80105b:	72 e3                	jb     801040 <memfind+0x13>
  80105d:	eb 01                	jmp    801060 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105f:	90                   	nop
	return (void *) s;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80106b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801072:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801079:	eb 03                	jmp    80107e <strtol+0x19>
		s++;
  80107b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 20                	cmp    $0x20,%al
  801085:	74 f4                	je     80107b <strtol+0x16>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 09                	cmp    $0x9,%al
  80108e:	74 eb                	je     80107b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	3c 2b                	cmp    $0x2b,%al
  801097:	75 05                	jne    80109e <strtol+0x39>
		s++;
  801099:	ff 45 08             	incl   0x8(%ebp)
  80109c:	eb 13                	jmp    8010b1 <strtol+0x4c>
	else if (*s == '-')
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 2d                	cmp    $0x2d,%al
  8010a5:	75 0a                	jne    8010b1 <strtol+0x4c>
		s++, neg = 1;
  8010a7:	ff 45 08             	incl   0x8(%ebp)
  8010aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b5:	74 06                	je     8010bd <strtol+0x58>
  8010b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010bb:	75 20                	jne    8010dd <strtol+0x78>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 30                	cmp    $0x30,%al
  8010c4:	75 17                	jne    8010dd <strtol+0x78>
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	40                   	inc    %eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	3c 78                	cmp    $0x78,%al
  8010ce:	75 0d                	jne    8010dd <strtol+0x78>
		s += 2, base = 16;
  8010d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010db:	eb 28                	jmp    801105 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e1:	75 15                	jne    8010f8 <strtol+0x93>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 30                	cmp    $0x30,%al
  8010ea:	75 0c                	jne    8010f8 <strtol+0x93>
		s++, base = 8;
  8010ec:	ff 45 08             	incl   0x8(%ebp)
  8010ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f6:	eb 0d                	jmp    801105 <strtol+0xa0>
	else if (base == 0)
  8010f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fc:	75 07                	jne    801105 <strtol+0xa0>
		base = 10;
  8010fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 2f                	cmp    $0x2f,%al
  80110c:	7e 19                	jle    801127 <strtol+0xc2>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 39                	cmp    $0x39,%al
  801115:	7f 10                	jg     801127 <strtol+0xc2>
			dig = *s - '0';
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f be c0             	movsbl %al,%eax
  80111f:	83 e8 30             	sub    $0x30,%eax
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801125:	eb 42                	jmp    801169 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 60                	cmp    $0x60,%al
  80112e:	7e 19                	jle    801149 <strtol+0xe4>
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 7a                	cmp    $0x7a,%al
  801137:	7f 10                	jg     801149 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	0f be c0             	movsbl %al,%eax
  801141:	83 e8 57             	sub    $0x57,%eax
  801144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801147:	eb 20                	jmp    801169 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 40                	cmp    $0x40,%al
  801150:	7e 39                	jle    80118b <strtol+0x126>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 5a                	cmp    $0x5a,%al
  801159:	7f 30                	jg     80118b <strtol+0x126>
			dig = *s - 'A' + 10;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	0f be c0             	movsbl %al,%eax
  801163:	83 e8 37             	sub    $0x37,%eax
  801166:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116f:	7d 19                	jge    80118a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801177:	0f af 45 10          	imul   0x10(%ebp),%eax
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801185:	e9 7b ff ff ff       	jmp    801105 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80118a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80118b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118f:	74 08                	je     801199 <strtol+0x134>
		*endptr = (char *) s;
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 55 08             	mov    0x8(%ebp),%edx
  801197:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801199:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119d:	74 07                	je     8011a6 <strtol+0x141>
  80119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a2:	f7 d8                	neg    %eax
  8011a4:	eb 03                	jmp    8011a9 <strtol+0x144>
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <ltostr>:

void
ltostr(long value, char *str)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	79 13                	jns    8011d8 <ltostr+0x2d>
	{
		neg = 1;
  8011c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011e0:	99                   	cltd   
  8011e1:	f7 f9                	idiv   %ecx
  8011e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f9:	83 c2 30             	add    $0x30,%edx
  8011fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801201:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801206:	f7 e9                	imul   %ecx
  801208:	c1 fa 02             	sar    $0x2,%edx
  80120b:	89 c8                	mov    %ecx,%eax
  80120d:	c1 f8 1f             	sar    $0x1f,%eax
  801210:	29 c2                	sub    %eax,%edx
  801212:	89 d0                	mov    %edx,%eax
  801214:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801217:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80121f:	f7 e9                	imul   %ecx
  801221:	c1 fa 02             	sar    $0x2,%edx
  801224:	89 c8                	mov    %ecx,%eax
  801226:	c1 f8 1f             	sar    $0x1f,%eax
  801229:	29 c2                	sub    %eax,%edx
  80122b:	89 d0                	mov    %edx,%eax
  80122d:	c1 e0 02             	shl    $0x2,%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	01 c0                	add    %eax,%eax
  801234:	29 c1                	sub    %eax,%ecx
  801236:	89 ca                	mov    %ecx,%edx
  801238:	85 d2                	test   %edx,%edx
  80123a:	75 9c                	jne    8011d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80123c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801243:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801246:	48                   	dec    %eax
  801247:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80124a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80124e:	74 3d                	je     80128d <ltostr+0xe2>
		start = 1 ;
  801250:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801257:	eb 34                	jmp    80128d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	01 d0                	add    %edx,%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 c8                	add    %ecx,%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80127a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c2                	add    %eax,%edx
  801282:	8a 45 eb             	mov    -0x15(%ebp),%al
  801285:	88 02                	mov    %al,(%edx)
		start++ ;
  801287:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80128a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801290:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801293:	7c c4                	jl     801259 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801295:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 d0                	add    %edx,%eax
  80129d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a0:	90                   	nop
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	e8 54 fa ff ff       	call   800d05 <strlen>
  8012b1:	83 c4 04             	add    $0x4,%esp
  8012b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012b7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ba:	e8 46 fa ff ff       	call   800d05 <strlen>
  8012bf:	83 c4 04             	add    $0x4,%esp
  8012c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d3:	eb 17                	jmp    8012ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8012d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 c2                	add    %eax,%edx
  8012dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	01 c8                	add    %ecx,%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012e9:	ff 45 fc             	incl   -0x4(%ebp)
  8012ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f2:	7c e1                	jl     8012d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801302:	eb 1f                	jmp    801323 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801304:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801307:	8d 50 01             	lea    0x1(%eax),%edx
  80130a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	01 c2                	add    %eax,%edx
  801314:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	01 c8                	add    %ecx,%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801320:	ff 45 f8             	incl   -0x8(%ebp)
  801323:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801326:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801329:	7c d9                	jl     801304 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80132b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	c6 00 00             	movb   $0x0,(%eax)
}
  801336:	90                   	nop
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80133c:	8b 45 14             	mov    0x14(%ebp),%eax
  80133f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801345:	8b 45 14             	mov    0x14(%ebp),%eax
  801348:	8b 00                	mov    (%eax),%eax
  80134a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
  801354:	01 d0                	add    %edx,%eax
  801356:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135c:	eb 0c                	jmp    80136a <strsplit+0x31>
			*string++ = 0;
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8d 50 01             	lea    0x1(%eax),%edx
  801364:	89 55 08             	mov    %edx,0x8(%ebp)
  801367:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	84 c0                	test   %al,%al
  801371:	74 18                	je     80138b <strsplit+0x52>
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	0f be c0             	movsbl %al,%eax
  80137b:	50                   	push   %eax
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	e8 13 fb ff ff       	call   800e97 <strchr>
  801384:	83 c4 08             	add    $0x8,%esp
  801387:	85 c0                	test   %eax,%eax
  801389:	75 d3                	jne    80135e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8a 00                	mov    (%eax),%al
  801390:	84 c0                	test   %al,%al
  801392:	74 5a                	je     8013ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801394:	8b 45 14             	mov    0x14(%ebp),%eax
  801397:	8b 00                	mov    (%eax),%eax
  801399:	83 f8 0f             	cmp    $0xf,%eax
  80139c:	75 07                	jne    8013a5 <strsplit+0x6c>
		{
			return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 66                	jmp    80140b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b0:	89 0a                	mov    %ecx,(%edx)
  8013b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	01 c2                	add    %eax,%edx
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c3:	eb 03                	jmp    8013c8 <strsplit+0x8f>
			string++;
  8013c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	84 c0                	test   %al,%al
  8013cf:	74 8b                	je     80135c <strsplit+0x23>
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be c0             	movsbl %al,%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 b5 fa ff ff       	call   800e97 <strchr>
  8013e2:	83 c4 08             	add    $0x8,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	74 dc                	je     8013c5 <strsplit+0x8c>
			string++;
	}
  8013e9:	e9 6e ff ff ff       	jmp    80135c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f2:	8b 00                	mov    (%eax),%eax
  8013f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 d0                	add    %edx,%eax
  801400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801406:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801413:	a1 04 40 80 00       	mov    0x804004,%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 1f                	je     80143b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80141c:	e8 1d 00 00 00       	call   80143e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801421:	83 ec 0c             	sub    $0xc,%esp
  801424:	68 f0 39 80 00       	push   $0x8039f0
  801429:	e8 55 f2 ff ff       	call   800683 <cprintf>
  80142e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801431:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801438:	00 00 00 
	}
}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801444:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80144b:	00 00 00 
  80144e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801455:	00 00 00 
  801458:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80145f:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801462:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801469:	00 00 00 
  80146c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801473:	00 00 00 
  801476:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80147d:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801480:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801487:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80148a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801494:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801499:	2d 00 10 00 00       	sub    $0x1000,%eax
  80149e:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8014a3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014aa:	a1 20 41 80 00       	mov    0x804120,%eax
  8014af:	c1 e0 04             	shl    $0x4,%eax
  8014b2:	89 c2                	mov    %eax,%edx
  8014b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b7:	01 d0                	add    %edx,%eax
  8014b9:	48                   	dec    %eax
  8014ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c5:	f7 75 f0             	divl   -0x10(%ebp)
  8014c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014cb:	29 d0                	sub    %edx,%eax
  8014cd:	89 c2                	mov    %eax,%edx
  8014cf:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8014d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	6a 06                	push   $0x6
  8014e8:	52                   	push   %edx
  8014e9:	50                   	push   %eax
  8014ea:	e8 71 05 00 00       	call   801a60 <sys_allocate_chunk>
  8014ef:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014f2:	a1 20 41 80 00       	mov    0x804120,%eax
  8014f7:	83 ec 0c             	sub    $0xc,%esp
  8014fa:	50                   	push   %eax
  8014fb:	e8 e6 0b 00 00       	call   8020e6 <initialize_MemBlocksList>
  801500:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801503:	a1 48 41 80 00       	mov    0x804148,%eax
  801508:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  80150b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80150f:	75 14                	jne    801525 <initialize_dyn_block_system+0xe7>
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	68 15 3a 80 00       	push   $0x803a15
  801519:	6a 2b                	push   $0x2b
  80151b:	68 33 3a 80 00       	push   $0x803a33
  801520:	e8 b2 1b 00 00       	call   8030d7 <_panic>
  801525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801528:	8b 00                	mov    (%eax),%eax
  80152a:	85 c0                	test   %eax,%eax
  80152c:	74 10                	je     80153e <initialize_dyn_block_system+0x100>
  80152e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801531:	8b 00                	mov    (%eax),%eax
  801533:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801536:	8b 52 04             	mov    0x4(%edx),%edx
  801539:	89 50 04             	mov    %edx,0x4(%eax)
  80153c:	eb 0b                	jmp    801549 <initialize_dyn_block_system+0x10b>
  80153e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801541:	8b 40 04             	mov    0x4(%eax),%eax
  801544:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80154c:	8b 40 04             	mov    0x4(%eax),%eax
  80154f:	85 c0                	test   %eax,%eax
  801551:	74 0f                	je     801562 <initialize_dyn_block_system+0x124>
  801553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801556:	8b 40 04             	mov    0x4(%eax),%eax
  801559:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80155c:	8b 12                	mov    (%edx),%edx
  80155e:	89 10                	mov    %edx,(%eax)
  801560:	eb 0a                	jmp    80156c <initialize_dyn_block_system+0x12e>
  801562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801565:	8b 00                	mov    (%eax),%eax
  801567:	a3 48 41 80 00       	mov    %eax,0x804148
  80156c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80156f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801578:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80157f:	a1 54 41 80 00       	mov    0x804154,%eax
  801584:	48                   	dec    %eax
  801585:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  80158a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801597:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015a4:	e8 d2 13 00 00       	call   80297b <insert_sorted_with_merge_freeList>
  8015a9:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8015ac:	90                   	nop
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b5:	e8 53 fe ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  8015ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015be:	75 07                	jne    8015c7 <malloc+0x18>
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c5:	eb 61                	jmp    801628 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8015c7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d4:	01 d0                	add    %edx,%eax
  8015d6:	48                   	dec    %eax
  8015d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e2:	f7 75 f4             	divl   -0xc(%ebp)
  8015e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e8:	29 d0                	sub    %edx,%eax
  8015ea:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015ed:	e8 3c 08 00 00       	call   801e2e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	74 2d                	je     801623 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8015f6:	83 ec 0c             	sub    $0xc,%esp
  8015f9:	ff 75 08             	pushl  0x8(%ebp)
  8015fc:	e8 3e 0f 00 00       	call   80253f <alloc_block_FF>
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801607:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80160b:	74 16                	je     801623 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  80160d:	83 ec 0c             	sub    $0xc,%esp
  801610:	ff 75 ec             	pushl  -0x14(%ebp)
  801613:	e8 48 0c 00 00       	call   802260 <insert_sorted_allocList>
  801618:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  80161b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161e:	8b 40 08             	mov    0x8(%eax),%eax
  801621:	eb 05                	jmp    801628 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801623:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801639:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80163e:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	50                   	push   %eax
  801648:	68 40 40 80 00       	push   $0x804040
  80164d:	e8 71 0b 00 00       	call   8021c3 <find_block>
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165b:	8b 50 0c             	mov    0xc(%eax),%edx
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	83 ec 08             	sub    $0x8,%esp
  801664:	52                   	push   %edx
  801665:	50                   	push   %eax
  801666:	e8 bd 03 00 00       	call   801a28 <sys_free_user_mem>
  80166b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80166e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801672:	75 14                	jne    801688 <free+0x5e>
  801674:	83 ec 04             	sub    $0x4,%esp
  801677:	68 15 3a 80 00       	push   $0x803a15
  80167c:	6a 71                	push   $0x71
  80167e:	68 33 3a 80 00       	push   $0x803a33
  801683:	e8 4f 1a 00 00       	call   8030d7 <_panic>
  801688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	85 c0                	test   %eax,%eax
  80168f:	74 10                	je     8016a1 <free+0x77>
  801691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801694:	8b 00                	mov    (%eax),%eax
  801696:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801699:	8b 52 04             	mov    0x4(%edx),%edx
  80169c:	89 50 04             	mov    %edx,0x4(%eax)
  80169f:	eb 0b                	jmp    8016ac <free+0x82>
  8016a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a4:	8b 40 04             	mov    0x4(%eax),%eax
  8016a7:	a3 44 40 80 00       	mov    %eax,0x804044
  8016ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016af:	8b 40 04             	mov    0x4(%eax),%eax
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	74 0f                	je     8016c5 <free+0x9b>
  8016b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b9:	8b 40 04             	mov    0x4(%eax),%eax
  8016bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016bf:	8b 12                	mov    (%edx),%edx
  8016c1:	89 10                	mov    %edx,(%eax)
  8016c3:	eb 0a                	jmp    8016cf <free+0xa5>
  8016c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c8:	8b 00                	mov    (%eax),%eax
  8016ca:	a3 40 40 80 00       	mov    %eax,0x804040
  8016cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016e2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016e7:	48                   	dec    %eax
  8016e8:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8016ed:	83 ec 0c             	sub    $0xc,%esp
  8016f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8016f3:	e8 83 12 00 00       	call   80297b <insert_sorted_with_merge_freeList>
  8016f8:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016fb:	90                   	nop
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 28             	sub    $0x28,%esp
  801704:	8b 45 10             	mov    0x10(%ebp),%eax
  801707:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80170a:	e8 fe fc ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  80170f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801713:	75 0a                	jne    80171f <smalloc+0x21>
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
  80171a:	e9 86 00 00 00       	jmp    8017a5 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  80171f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801726:	8b 55 0c             	mov    0xc(%ebp),%edx
  801729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172c:	01 d0                	add    %edx,%eax
  80172e:	48                   	dec    %eax
  80172f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801735:	ba 00 00 00 00       	mov    $0x0,%edx
  80173a:	f7 75 f4             	divl   -0xc(%ebp)
  80173d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801740:	29 d0                	sub    %edx,%eax
  801742:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801745:	e8 e4 06 00 00       	call   801e2e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80174a:	85 c0                	test   %eax,%eax
  80174c:	74 52                	je     8017a0 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  80174e:	83 ec 0c             	sub    $0xc,%esp
  801751:	ff 75 0c             	pushl  0xc(%ebp)
  801754:	e8 e6 0d 00 00       	call   80253f <alloc_block_FF>
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  80175f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801763:	75 07                	jne    80176c <smalloc+0x6e>
			return NULL ;
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
  80176a:	eb 39                	jmp    8017a5 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80176c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176f:	8b 40 08             	mov    0x8(%eax),%eax
  801772:	89 c2                	mov    %eax,%edx
  801774:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801778:	52                   	push   %edx
  801779:	50                   	push   %eax
  80177a:	ff 75 0c             	pushl  0xc(%ebp)
  80177d:	ff 75 08             	pushl  0x8(%ebp)
  801780:	e8 2e 04 00 00       	call   801bb3 <sys_createSharedObject>
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80178b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80178f:	79 07                	jns    801798 <smalloc+0x9a>
			return (void*)NULL ;
  801791:	b8 00 00 00 00       	mov    $0x0,%eax
  801796:	eb 0d                	jmp    8017a5 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801798:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179b:	8b 40 08             	mov    0x8(%eax),%eax
  80179e:	eb 05                	jmp    8017a5 <smalloc+0xa7>
		}
		return (void*)NULL ;
  8017a0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ad:	e8 5b fc ff ff       	call   80140d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017b2:	83 ec 08             	sub    $0x8,%esp
  8017b5:	ff 75 0c             	pushl  0xc(%ebp)
  8017b8:	ff 75 08             	pushl  0x8(%ebp)
  8017bb:	e8 1d 04 00 00       	call   801bdd <sys_getSizeOfSharedObject>
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8017c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017ca:	75 0a                	jne    8017d6 <sget+0x2f>
			return NULL ;
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d1:	e9 83 00 00 00       	jmp    801859 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8017d6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e3:	01 d0                	add    %edx,%eax
  8017e5:	48                   	dec    %eax
  8017e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f1:	f7 75 f0             	divl   -0x10(%ebp)
  8017f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f7:	29 d0                	sub    %edx,%eax
  8017f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017fc:	e8 2d 06 00 00       	call   801e2e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801801:	85 c0                	test   %eax,%eax
  801803:	74 4f                	je     801854 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801808:	83 ec 0c             	sub    $0xc,%esp
  80180b:	50                   	push   %eax
  80180c:	e8 2e 0d 00 00       	call   80253f <alloc_block_FF>
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801817:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80181b:	75 07                	jne    801824 <sget+0x7d>
					return (void*)NULL ;
  80181d:	b8 00 00 00 00       	mov    $0x0,%eax
  801822:	eb 35                	jmp    801859 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801824:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801827:	8b 40 08             	mov    0x8(%eax),%eax
  80182a:	83 ec 04             	sub    $0x4,%esp
  80182d:	50                   	push   %eax
  80182e:	ff 75 0c             	pushl  0xc(%ebp)
  801831:	ff 75 08             	pushl  0x8(%ebp)
  801834:	e8 c1 03 00 00       	call   801bfa <sys_getSharedObject>
  801839:	83 c4 10             	add    $0x10,%esp
  80183c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  80183f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801843:	79 07                	jns    80184c <sget+0xa5>
				return (void*)NULL ;
  801845:	b8 00 00 00 00       	mov    $0x0,%eax
  80184a:	eb 0d                	jmp    801859 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  80184c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80184f:	8b 40 08             	mov    0x8(%eax),%eax
  801852:	eb 05                	jmp    801859 <sget+0xb2>


		}
	return (void*)NULL ;
  801854:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801861:	e8 a7 fb ff ff       	call   80140d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801866:	83 ec 04             	sub    $0x4,%esp
  801869:	68 40 3a 80 00       	push   $0x803a40
  80186e:	68 f9 00 00 00       	push   $0xf9
  801873:	68 33 3a 80 00       	push   $0x803a33
  801878:	e8 5a 18 00 00       	call   8030d7 <_panic>

0080187d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801883:	83 ec 04             	sub    $0x4,%esp
  801886:	68 68 3a 80 00       	push   $0x803a68
  80188b:	68 0d 01 00 00       	push   $0x10d
  801890:	68 33 3a 80 00       	push   $0x803a33
  801895:	e8 3d 18 00 00       	call   8030d7 <_panic>

0080189a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a0:	83 ec 04             	sub    $0x4,%esp
  8018a3:	68 8c 3a 80 00       	push   $0x803a8c
  8018a8:	68 18 01 00 00       	push   $0x118
  8018ad:	68 33 3a 80 00       	push   $0x803a33
  8018b2:	e8 20 18 00 00       	call   8030d7 <_panic>

008018b7 <shrink>:

}
void shrink(uint32 newSize)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018bd:	83 ec 04             	sub    $0x4,%esp
  8018c0:	68 8c 3a 80 00       	push   $0x803a8c
  8018c5:	68 1d 01 00 00       	push   $0x11d
  8018ca:	68 33 3a 80 00       	push   $0x803a33
  8018cf:	e8 03 18 00 00       	call   8030d7 <_panic>

008018d4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018da:	83 ec 04             	sub    $0x4,%esp
  8018dd:	68 8c 3a 80 00       	push   $0x803a8c
  8018e2:	68 22 01 00 00       	push   $0x122
  8018e7:	68 33 3a 80 00       	push   $0x803a33
  8018ec:	e8 e6 17 00 00       	call   8030d7 <_panic>

008018f1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	57                   	push   %edi
  8018f5:	56                   	push   %esi
  8018f6:	53                   	push   %ebx
  8018f7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801900:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801903:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801906:	8b 7d 18             	mov    0x18(%ebp),%edi
  801909:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80190c:	cd 30                	int    $0x30
  80190e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801911:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	5b                   	pop    %ebx
  801918:	5e                   	pop    %esi
  801919:	5f                   	pop    %edi
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    

0080191c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 04             	sub    $0x4,%esp
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801928:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	52                   	push   %edx
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	50                   	push   %eax
  801938:	6a 00                	push   $0x0
  80193a:	e8 b2 ff ff ff       	call   8018f1 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	90                   	nop
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_cgetc>:

int
sys_cgetc(void)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 01                	push   $0x1
  801954:	e8 98 ff ff ff       	call   8018f1 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801961:	8b 55 0c             	mov    0xc(%ebp),%edx
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	52                   	push   %edx
  80196e:	50                   	push   %eax
  80196f:	6a 05                	push   $0x5
  801971:	e8 7b ff ff ff       	call   8018f1 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	56                   	push   %esi
  80197f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801980:	8b 75 18             	mov    0x18(%ebp),%esi
  801983:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801986:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	56                   	push   %esi
  801990:	53                   	push   %ebx
  801991:	51                   	push   %ecx
  801992:	52                   	push   %edx
  801993:	50                   	push   %eax
  801994:	6a 06                	push   $0x6
  801996:	e8 56 ff ff ff       	call   8018f1 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a1:	5b                   	pop    %ebx
  8019a2:	5e                   	pop    %esi
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    

008019a5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	52                   	push   %edx
  8019b5:	50                   	push   %eax
  8019b6:	6a 07                	push   $0x7
  8019b8:	e8 34 ff ff ff       	call   8018f1 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ce:	ff 75 08             	pushl  0x8(%ebp)
  8019d1:	6a 08                	push   $0x8
  8019d3:	e8 19 ff ff ff       	call   8018f1 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 09                	push   $0x9
  8019ec:	e8 00 ff ff ff       	call   8018f1 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 0a                	push   $0xa
  801a05:	e8 e7 fe ff ff       	call   8018f1 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 0b                	push   $0xb
  801a1e:	e8 ce fe ff ff       	call   8018f1 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	ff 75 08             	pushl  0x8(%ebp)
  801a37:	6a 0f                	push   $0xf
  801a39:	e8 b3 fe ff ff       	call   8018f1 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
	return;
  801a41:	90                   	nop
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	ff 75 08             	pushl  0x8(%ebp)
  801a53:	6a 10                	push   $0x10
  801a55:	e8 97 fe ff ff       	call   8018f1 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5d:	90                   	nop
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	ff 75 10             	pushl  0x10(%ebp)
  801a6a:	ff 75 0c             	pushl  0xc(%ebp)
  801a6d:	ff 75 08             	pushl  0x8(%ebp)
  801a70:	6a 11                	push   $0x11
  801a72:	e8 7a fe ff ff       	call   8018f1 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7a:	90                   	nop
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 0c                	push   $0xc
  801a8c:	e8 60 fe ff ff       	call   8018f1 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	ff 75 08             	pushl  0x8(%ebp)
  801aa4:	6a 0d                	push   $0xd
  801aa6:	e8 46 fe ff ff       	call   8018f1 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 0e                	push   $0xe
  801abf:	e8 2d fe ff ff       	call   8018f1 <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	90                   	nop
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 13                	push   $0x13
  801ad9:	e8 13 fe ff ff       	call   8018f1 <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	90                   	nop
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 14                	push   $0x14
  801af3:	e8 f9 fd ff ff       	call   8018f1 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	90                   	nop
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_cputc>:


void
sys_cputc(const char c)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 04             	sub    $0x4,%esp
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b0a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	50                   	push   %eax
  801b17:	6a 15                	push   $0x15
  801b19:	e8 d3 fd ff ff       	call   8018f1 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 16                	push   $0x16
  801b33:	e8 b9 fd ff ff       	call   8018f1 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	90                   	nop
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	ff 75 0c             	pushl  0xc(%ebp)
  801b4d:	50                   	push   %eax
  801b4e:	6a 17                	push   $0x17
  801b50:	e8 9c fd ff ff       	call   8018f1 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	52                   	push   %edx
  801b6a:	50                   	push   %eax
  801b6b:	6a 1a                	push   $0x1a
  801b6d:	e8 7f fd ff ff       	call   8018f1 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	52                   	push   %edx
  801b87:	50                   	push   %eax
  801b88:	6a 18                	push   $0x18
  801b8a:	e8 62 fd ff ff       	call   8018f1 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	90                   	nop
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	52                   	push   %edx
  801ba5:	50                   	push   %eax
  801ba6:	6a 19                	push   $0x19
  801ba8:	e8 44 fd ff ff       	call   8018f1 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
}
  801bb0:	90                   	nop
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 04             	sub    $0x4,%esp
  801bb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bbf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bc2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	6a 00                	push   $0x0
  801bcb:	51                   	push   %ecx
  801bcc:	52                   	push   %edx
  801bcd:	ff 75 0c             	pushl  0xc(%ebp)
  801bd0:	50                   	push   %eax
  801bd1:	6a 1b                	push   $0x1b
  801bd3:	e8 19 fd ff ff       	call   8018f1 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801be0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	52                   	push   %edx
  801bed:	50                   	push   %eax
  801bee:	6a 1c                	push   $0x1c
  801bf0:	e8 fc fc ff ff       	call   8018f1 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bfd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c03:	8b 45 08             	mov    0x8(%ebp),%eax
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	51                   	push   %ecx
  801c0b:	52                   	push   %edx
  801c0c:	50                   	push   %eax
  801c0d:	6a 1d                	push   $0x1d
  801c0f:	e8 dd fc ff ff       	call   8018f1 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	52                   	push   %edx
  801c29:	50                   	push   %eax
  801c2a:	6a 1e                	push   $0x1e
  801c2c:	e8 c0 fc ff ff       	call   8018f1 <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 1f                	push   $0x1f
  801c45:	e8 a7 fc ff ff       	call   8018f1 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	ff 75 14             	pushl  0x14(%ebp)
  801c5a:	ff 75 10             	pushl  0x10(%ebp)
  801c5d:	ff 75 0c             	pushl  0xc(%ebp)
  801c60:	50                   	push   %eax
  801c61:	6a 20                	push   $0x20
  801c63:	e8 89 fc ff ff       	call   8018f1 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	50                   	push   %eax
  801c7c:	6a 21                	push   $0x21
  801c7e:	e8 6e fc ff ff       	call   8018f1 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	90                   	nop
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	50                   	push   %eax
  801c98:	6a 22                	push   $0x22
  801c9a:	e8 52 fc ff ff       	call   8018f1 <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 02                	push   $0x2
  801cb3:	e8 39 fc ff ff       	call   8018f1 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 03                	push   $0x3
  801ccc:	e8 20 fc ff ff       	call   8018f1 <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 04                	push   $0x4
  801ce5:	e8 07 fc ff ff       	call   8018f1 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_exit_env>:


void sys_exit_env(void)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 23                	push   $0x23
  801cfe:	e8 ee fb ff ff       	call   8018f1 <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
}
  801d06:	90                   	nop
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d0f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d12:	8d 50 04             	lea    0x4(%eax),%edx
  801d15:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	52                   	push   %edx
  801d1f:	50                   	push   %eax
  801d20:	6a 24                	push   $0x24
  801d22:	e8 ca fb ff ff       	call   8018f1 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
	return result;
  801d2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d33:	89 01                	mov    %eax,(%ecx)
  801d35:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	c9                   	leave  
  801d3c:	c2 04 00             	ret    $0x4

00801d3f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	ff 75 10             	pushl  0x10(%ebp)
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	ff 75 08             	pushl  0x8(%ebp)
  801d4f:	6a 12                	push   $0x12
  801d51:	e8 9b fb ff ff       	call   8018f1 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
	return ;
  801d59:	90                   	nop
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sys_rcr2>:
uint32 sys_rcr2()
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 25                	push   $0x25
  801d6b:	e8 81 fb ff ff       	call   8018f1 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 04             	sub    $0x4,%esp
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d81:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	50                   	push   %eax
  801d8e:	6a 26                	push   $0x26
  801d90:	e8 5c fb ff ff       	call   8018f1 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
	return ;
  801d98:	90                   	nop
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <rsttst>:
void rsttst()
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 28                	push   $0x28
  801daa:	e8 42 fb ff ff       	call   8018f1 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
	return ;
  801db2:	90                   	nop
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 04             	sub    $0x4,%esp
  801dbb:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dc1:	8b 55 18             	mov    0x18(%ebp),%edx
  801dc4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dc8:	52                   	push   %edx
  801dc9:	50                   	push   %eax
  801dca:	ff 75 10             	pushl  0x10(%ebp)
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	ff 75 08             	pushl  0x8(%ebp)
  801dd3:	6a 27                	push   $0x27
  801dd5:	e8 17 fb ff ff       	call   8018f1 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddd:	90                   	nop
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <chktst>:
void chktst(uint32 n)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	ff 75 08             	pushl  0x8(%ebp)
  801dee:	6a 29                	push   $0x29
  801df0:	e8 fc fa ff ff       	call   8018f1 <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
	return ;
  801df8:	90                   	nop
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <inctst>:

void inctst()
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 2a                	push   $0x2a
  801e0a:	e8 e2 fa ff ff       	call   8018f1 <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e12:	90                   	nop
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <gettst>:
uint32 gettst()
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 2b                	push   $0x2b
  801e24:	e8 c8 fa ff ff       	call   8018f1 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 2c                	push   $0x2c
  801e40:	e8 ac fa ff ff       	call   8018f1 <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
  801e48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e4b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e4f:	75 07                	jne    801e58 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e51:	b8 01 00 00 00       	mov    $0x1,%eax
  801e56:	eb 05                	jmp    801e5d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 2c                	push   $0x2c
  801e71:	e8 7b fa ff ff       	call   8018f1 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
  801e79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e7c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e80:	75 07                	jne    801e89 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e82:	b8 01 00 00 00       	mov    $0x1,%eax
  801e87:	eb 05                	jmp    801e8e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 2c                	push   $0x2c
  801ea2:	e8 4a fa ff ff       	call   8018f1 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
  801eaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ead:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eb1:	75 07                	jne    801eba <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eb3:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb8:	eb 05                	jmp    801ebf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 2c                	push   $0x2c
  801ed3:	e8 19 fa ff ff       	call   8018f1 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
  801edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ede:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ee2:	75 07                	jne    801eeb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ee4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee9:	eb 05                	jmp    801ef0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	ff 75 08             	pushl  0x8(%ebp)
  801f00:	6a 2d                	push   $0x2d
  801f02:	e8 ea f9 ff ff       	call   8018f1 <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0a:	90                   	nop
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	53                   	push   %ebx
  801f20:	51                   	push   %ecx
  801f21:	52                   	push   %edx
  801f22:	50                   	push   %eax
  801f23:	6a 2e                	push   $0x2e
  801f25:	e8 c7 f9 ff ff       	call   8018f1 <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
}
  801f2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	52                   	push   %edx
  801f42:	50                   	push   %eax
  801f43:	6a 2f                	push   $0x2f
  801f45:	e8 a7 f9 ff ff       	call   8018f1 <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	68 9c 3a 80 00       	push   $0x803a9c
  801f5d:	e8 21 e7 ff ff       	call   800683 <cprintf>
  801f62:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f65:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f6c:	83 ec 0c             	sub    $0xc,%esp
  801f6f:	68 c8 3a 80 00       	push   $0x803ac8
  801f74:	e8 0a e7 ff ff       	call   800683 <cprintf>
  801f79:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f7c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f80:	a1 38 41 80 00       	mov    0x804138,%eax
  801f85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f88:	eb 56                	jmp    801fe0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8e:	74 1c                	je     801fac <print_mem_block_lists+0x5d>
  801f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f93:	8b 50 08             	mov    0x8(%eax),%edx
  801f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f99:	8b 48 08             	mov    0x8(%eax),%ecx
  801f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa2:	01 c8                	add    %ecx,%eax
  801fa4:	39 c2                	cmp    %eax,%edx
  801fa6:	73 04                	jae    801fac <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fa8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faf:	8b 50 08             	mov    0x8(%eax),%edx
  801fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb8:	01 c2                	add    %eax,%edx
  801fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbd:	8b 40 08             	mov    0x8(%eax),%eax
  801fc0:	83 ec 04             	sub    $0x4,%esp
  801fc3:	52                   	push   %edx
  801fc4:	50                   	push   %eax
  801fc5:	68 dd 3a 80 00       	push   $0x803add
  801fca:	e8 b4 e6 ff ff       	call   800683 <cprintf>
  801fcf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fd8:	a1 40 41 80 00       	mov    0x804140,%eax
  801fdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe4:	74 07                	je     801fed <print_mem_block_lists+0x9e>
  801fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe9:	8b 00                	mov    (%eax),%eax
  801feb:	eb 05                	jmp    801ff2 <print_mem_block_lists+0xa3>
  801fed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff2:	a3 40 41 80 00       	mov    %eax,0x804140
  801ff7:	a1 40 41 80 00       	mov    0x804140,%eax
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	75 8a                	jne    801f8a <print_mem_block_lists+0x3b>
  802000:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802004:	75 84                	jne    801f8a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802006:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80200a:	75 10                	jne    80201c <print_mem_block_lists+0xcd>
  80200c:	83 ec 0c             	sub    $0xc,%esp
  80200f:	68 ec 3a 80 00       	push   $0x803aec
  802014:	e8 6a e6 ff ff       	call   800683 <cprintf>
  802019:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80201c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802023:	83 ec 0c             	sub    $0xc,%esp
  802026:	68 10 3b 80 00       	push   $0x803b10
  80202b:	e8 53 e6 ff ff       	call   800683 <cprintf>
  802030:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802033:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802037:	a1 40 40 80 00       	mov    0x804040,%eax
  80203c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203f:	eb 56                	jmp    802097 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802041:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802045:	74 1c                	je     802063 <print_mem_block_lists+0x114>
  802047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204a:	8b 50 08             	mov    0x8(%eax),%edx
  80204d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802050:	8b 48 08             	mov    0x8(%eax),%ecx
  802053:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802056:	8b 40 0c             	mov    0xc(%eax),%eax
  802059:	01 c8                	add    %ecx,%eax
  80205b:	39 c2                	cmp    %eax,%edx
  80205d:	73 04                	jae    802063 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80205f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	8b 50 08             	mov    0x8(%eax),%edx
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	8b 40 0c             	mov    0xc(%eax),%eax
  80206f:	01 c2                	add    %eax,%edx
  802071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802074:	8b 40 08             	mov    0x8(%eax),%eax
  802077:	83 ec 04             	sub    $0x4,%esp
  80207a:	52                   	push   %edx
  80207b:	50                   	push   %eax
  80207c:	68 dd 3a 80 00       	push   $0x803add
  802081:	e8 fd e5 ff ff       	call   800683 <cprintf>
  802086:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80208f:	a1 48 40 80 00       	mov    0x804048,%eax
  802094:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802097:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209b:	74 07                	je     8020a4 <print_mem_block_lists+0x155>
  80209d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a0:	8b 00                	mov    (%eax),%eax
  8020a2:	eb 05                	jmp    8020a9 <print_mem_block_lists+0x15a>
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a9:	a3 48 40 80 00       	mov    %eax,0x804048
  8020ae:	a1 48 40 80 00       	mov    0x804048,%eax
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	75 8a                	jne    802041 <print_mem_block_lists+0xf2>
  8020b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020bb:	75 84                	jne    802041 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020bd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020c1:	75 10                	jne    8020d3 <print_mem_block_lists+0x184>
  8020c3:	83 ec 0c             	sub    $0xc,%esp
  8020c6:	68 28 3b 80 00       	push   $0x803b28
  8020cb:	e8 b3 e5 ff ff       	call   800683 <cprintf>
  8020d0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020d3:	83 ec 0c             	sub    $0xc,%esp
  8020d6:	68 9c 3a 80 00       	push   $0x803a9c
  8020db:	e8 a3 e5 ff ff       	call   800683 <cprintf>
  8020e0:	83 c4 10             	add    $0x10,%esp

}
  8020e3:	90                   	nop
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020ec:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020f3:	00 00 00 
  8020f6:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020fd:	00 00 00 
  802100:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802107:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80210a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802111:	e9 9e 00 00 00       	jmp    8021b4 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802116:	a1 50 40 80 00       	mov    0x804050,%eax
  80211b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211e:	c1 e2 04             	shl    $0x4,%edx
  802121:	01 d0                	add    %edx,%eax
  802123:	85 c0                	test   %eax,%eax
  802125:	75 14                	jne    80213b <initialize_MemBlocksList+0x55>
  802127:	83 ec 04             	sub    $0x4,%esp
  80212a:	68 50 3b 80 00       	push   $0x803b50
  80212f:	6a 43                	push   $0x43
  802131:	68 73 3b 80 00       	push   $0x803b73
  802136:	e8 9c 0f 00 00       	call   8030d7 <_panic>
  80213b:	a1 50 40 80 00       	mov    0x804050,%eax
  802140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802143:	c1 e2 04             	shl    $0x4,%edx
  802146:	01 d0                	add    %edx,%eax
  802148:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80214e:	89 10                	mov    %edx,(%eax)
  802150:	8b 00                	mov    (%eax),%eax
  802152:	85 c0                	test   %eax,%eax
  802154:	74 18                	je     80216e <initialize_MemBlocksList+0x88>
  802156:	a1 48 41 80 00       	mov    0x804148,%eax
  80215b:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802161:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802164:	c1 e1 04             	shl    $0x4,%ecx
  802167:	01 ca                	add    %ecx,%edx
  802169:	89 50 04             	mov    %edx,0x4(%eax)
  80216c:	eb 12                	jmp    802180 <initialize_MemBlocksList+0x9a>
  80216e:	a1 50 40 80 00       	mov    0x804050,%eax
  802173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802176:	c1 e2 04             	shl    $0x4,%edx
  802179:	01 d0                	add    %edx,%eax
  80217b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802180:	a1 50 40 80 00       	mov    0x804050,%eax
  802185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802188:	c1 e2 04             	shl    $0x4,%edx
  80218b:	01 d0                	add    %edx,%eax
  80218d:	a3 48 41 80 00       	mov    %eax,0x804148
  802192:	a1 50 40 80 00       	mov    0x804050,%eax
  802197:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219a:	c1 e2 04             	shl    $0x4,%edx
  80219d:	01 d0                	add    %edx,%eax
  80219f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a6:	a1 54 41 80 00       	mov    0x804154,%eax
  8021ab:	40                   	inc    %eax
  8021ac:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8021b1:	ff 45 f4             	incl   -0xc(%ebp)
  8021b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ba:	0f 82 56 ff ff ff    	jb     802116 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8021c0:	90                   	nop
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8021c9:	a1 38 41 80 00       	mov    0x804138,%eax
  8021ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021d1:	eb 18                	jmp    8021eb <find_block+0x28>
	{
		if (ele->sva==va)
  8021d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d6:	8b 40 08             	mov    0x8(%eax),%eax
  8021d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021dc:	75 05                	jne    8021e3 <find_block+0x20>
			return ele;
  8021de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e1:	eb 7b                	jmp    80225e <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8021e3:	a1 40 41 80 00       	mov    0x804140,%eax
  8021e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ef:	74 07                	je     8021f8 <find_block+0x35>
  8021f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f4:	8b 00                	mov    (%eax),%eax
  8021f6:	eb 05                	jmp    8021fd <find_block+0x3a>
  8021f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fd:	a3 40 41 80 00       	mov    %eax,0x804140
  802202:	a1 40 41 80 00       	mov    0x804140,%eax
  802207:	85 c0                	test   %eax,%eax
  802209:	75 c8                	jne    8021d3 <find_block+0x10>
  80220b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80220f:	75 c2                	jne    8021d3 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802211:	a1 40 40 80 00       	mov    0x804040,%eax
  802216:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802219:	eb 18                	jmp    802233 <find_block+0x70>
	{
		if (ele->sva==va)
  80221b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80221e:	8b 40 08             	mov    0x8(%eax),%eax
  802221:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802224:	75 05                	jne    80222b <find_block+0x68>
					return ele;
  802226:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802229:	eb 33                	jmp    80225e <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80222b:	a1 48 40 80 00       	mov    0x804048,%eax
  802230:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802233:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802237:	74 07                	je     802240 <find_block+0x7d>
  802239:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80223c:	8b 00                	mov    (%eax),%eax
  80223e:	eb 05                	jmp    802245 <find_block+0x82>
  802240:	b8 00 00 00 00       	mov    $0x0,%eax
  802245:	a3 48 40 80 00       	mov    %eax,0x804048
  80224a:	a1 48 40 80 00       	mov    0x804048,%eax
  80224f:	85 c0                	test   %eax,%eax
  802251:	75 c8                	jne    80221b <find_block+0x58>
  802253:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802257:	75 c2                	jne    80221b <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802259:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802266:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80226b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80226e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802272:	75 62                	jne    8022d6 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802274:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802278:	75 14                	jne    80228e <insert_sorted_allocList+0x2e>
  80227a:	83 ec 04             	sub    $0x4,%esp
  80227d:	68 50 3b 80 00       	push   $0x803b50
  802282:	6a 69                	push   $0x69
  802284:	68 73 3b 80 00       	push   $0x803b73
  802289:	e8 49 0e 00 00       	call   8030d7 <_panic>
  80228e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	89 10                	mov    %edx,(%eax)
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	8b 00                	mov    (%eax),%eax
  80229e:	85 c0                	test   %eax,%eax
  8022a0:	74 0d                	je     8022af <insert_sorted_allocList+0x4f>
  8022a2:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022aa:	89 50 04             	mov    %edx,0x4(%eax)
  8022ad:	eb 08                	jmp    8022b7 <insert_sorted_allocList+0x57>
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	a3 44 40 80 00       	mov    %eax,0x804044
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	a3 40 40 80 00       	mov    %eax,0x804040
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022ce:	40                   	inc    %eax
  8022cf:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022d4:	eb 72                	jmp    802348 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8022d6:	a1 40 40 80 00       	mov    0x804040,%eax
  8022db:	8b 50 08             	mov    0x8(%eax),%edx
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	8b 40 08             	mov    0x8(%eax),%eax
  8022e4:	39 c2                	cmp    %eax,%edx
  8022e6:	76 60                	jbe    802348 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8022e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ec:	75 14                	jne    802302 <insert_sorted_allocList+0xa2>
  8022ee:	83 ec 04             	sub    $0x4,%esp
  8022f1:	68 50 3b 80 00       	push   $0x803b50
  8022f6:	6a 6d                	push   $0x6d
  8022f8:	68 73 3b 80 00       	push   $0x803b73
  8022fd:	e8 d5 0d 00 00       	call   8030d7 <_panic>
  802302:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	89 10                	mov    %edx,(%eax)
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	8b 00                	mov    (%eax),%eax
  802312:	85 c0                	test   %eax,%eax
  802314:	74 0d                	je     802323 <insert_sorted_allocList+0xc3>
  802316:	a1 40 40 80 00       	mov    0x804040,%eax
  80231b:	8b 55 08             	mov    0x8(%ebp),%edx
  80231e:	89 50 04             	mov    %edx,0x4(%eax)
  802321:	eb 08                	jmp    80232b <insert_sorted_allocList+0xcb>
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	a3 44 40 80 00       	mov    %eax,0x804044
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	a3 40 40 80 00       	mov    %eax,0x804040
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80233d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802342:	40                   	inc    %eax
  802343:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802348:	a1 40 40 80 00       	mov    0x804040,%eax
  80234d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802350:	e9 b9 01 00 00       	jmp    80250e <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	8b 50 08             	mov    0x8(%eax),%edx
  80235b:	a1 40 40 80 00       	mov    0x804040,%eax
  802360:	8b 40 08             	mov    0x8(%eax),%eax
  802363:	39 c2                	cmp    %eax,%edx
  802365:	76 7c                	jbe    8023e3 <insert_sorted_allocList+0x183>
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	8b 50 08             	mov    0x8(%eax),%edx
  80236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802370:	8b 40 08             	mov    0x8(%eax),%eax
  802373:	39 c2                	cmp    %eax,%edx
  802375:	73 6c                	jae    8023e3 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237b:	74 06                	je     802383 <insert_sorted_allocList+0x123>
  80237d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802381:	75 14                	jne    802397 <insert_sorted_allocList+0x137>
  802383:	83 ec 04             	sub    $0x4,%esp
  802386:	68 8c 3b 80 00       	push   $0x803b8c
  80238b:	6a 75                	push   $0x75
  80238d:	68 73 3b 80 00       	push   $0x803b73
  802392:	e8 40 0d 00 00       	call   8030d7 <_panic>
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 50 04             	mov    0x4(%eax),%edx
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	89 50 04             	mov    %edx,0x4(%eax)
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a9:	89 10                	mov    %edx,(%eax)
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	8b 40 04             	mov    0x4(%eax),%eax
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	74 0d                	je     8023c2 <insert_sorted_allocList+0x162>
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	8b 40 04             	mov    0x4(%eax),%eax
  8023bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8023be:	89 10                	mov    %edx,(%eax)
  8023c0:	eb 08                	jmp    8023ca <insert_sorted_allocList+0x16a>
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	a3 40 40 80 00       	mov    %eax,0x804040
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d0:	89 50 04             	mov    %edx,0x4(%eax)
  8023d3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023d8:	40                   	inc    %eax
  8023d9:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8023de:	e9 59 01 00 00       	jmp    80253c <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8b 50 08             	mov    0x8(%eax),%edx
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 40 08             	mov    0x8(%eax),%eax
  8023ef:	39 c2                	cmp    %eax,%edx
  8023f1:	0f 86 98 00 00 00    	jbe    80248f <insert_sorted_allocList+0x22f>
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	8b 50 08             	mov    0x8(%eax),%edx
  8023fd:	a1 44 40 80 00       	mov    0x804044,%eax
  802402:	8b 40 08             	mov    0x8(%eax),%eax
  802405:	39 c2                	cmp    %eax,%edx
  802407:	0f 83 82 00 00 00    	jae    80248f <insert_sorted_allocList+0x22f>
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	8b 50 08             	mov    0x8(%eax),%edx
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 00                	mov    (%eax),%eax
  802418:	8b 40 08             	mov    0x8(%eax),%eax
  80241b:	39 c2                	cmp    %eax,%edx
  80241d:	73 70                	jae    80248f <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80241f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802423:	74 06                	je     80242b <insert_sorted_allocList+0x1cb>
  802425:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802429:	75 14                	jne    80243f <insert_sorted_allocList+0x1df>
  80242b:	83 ec 04             	sub    $0x4,%esp
  80242e:	68 c4 3b 80 00       	push   $0x803bc4
  802433:	6a 7c                	push   $0x7c
  802435:	68 73 3b 80 00       	push   $0x803b73
  80243a:	e8 98 0c 00 00       	call   8030d7 <_panic>
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 10                	mov    (%eax),%edx
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	89 10                	mov    %edx,(%eax)
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	85 c0                	test   %eax,%eax
  802450:	74 0b                	je     80245d <insert_sorted_allocList+0x1fd>
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	8b 55 08             	mov    0x8(%ebp),%edx
  80245a:	89 50 04             	mov    %edx,0x4(%eax)
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	8b 55 08             	mov    0x8(%ebp),%edx
  802463:	89 10                	mov    %edx,(%eax)
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246b:	89 50 04             	mov    %edx,0x4(%eax)
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	8b 00                	mov    (%eax),%eax
  802473:	85 c0                	test   %eax,%eax
  802475:	75 08                	jne    80247f <insert_sorted_allocList+0x21f>
  802477:	8b 45 08             	mov    0x8(%ebp),%eax
  80247a:	a3 44 40 80 00       	mov    %eax,0x804044
  80247f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802484:	40                   	inc    %eax
  802485:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80248a:	e9 ad 00 00 00       	jmp    80253c <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	8b 50 08             	mov    0x8(%eax),%edx
  802495:	a1 44 40 80 00       	mov    0x804044,%eax
  80249a:	8b 40 08             	mov    0x8(%eax),%eax
  80249d:	39 c2                	cmp    %eax,%edx
  80249f:	76 65                	jbe    802506 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8024a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024a5:	75 17                	jne    8024be <insert_sorted_allocList+0x25e>
  8024a7:	83 ec 04             	sub    $0x4,%esp
  8024aa:	68 f8 3b 80 00       	push   $0x803bf8
  8024af:	68 80 00 00 00       	push   $0x80
  8024b4:	68 73 3b 80 00       	push   $0x803b73
  8024b9:	e8 19 0c 00 00       	call   8030d7 <_panic>
  8024be:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	8b 40 04             	mov    0x4(%eax),%eax
  8024d0:	85 c0                	test   %eax,%eax
  8024d2:	74 0c                	je     8024e0 <insert_sorted_allocList+0x280>
  8024d4:	a1 44 40 80 00       	mov    0x804044,%eax
  8024d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024dc:	89 10                	mov    %edx,(%eax)
  8024de:	eb 08                	jmp    8024e8 <insert_sorted_allocList+0x288>
  8024e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e3:	a3 40 40 80 00       	mov    %eax,0x804040
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	a3 44 40 80 00       	mov    %eax,0x804044
  8024f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024fe:	40                   	inc    %eax
  8024ff:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802504:	eb 36                	jmp    80253c <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802506:	a1 48 40 80 00       	mov    0x804048,%eax
  80250b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802512:	74 07                	je     80251b <insert_sorted_allocList+0x2bb>
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 00                	mov    (%eax),%eax
  802519:	eb 05                	jmp    802520 <insert_sorted_allocList+0x2c0>
  80251b:	b8 00 00 00 00       	mov    $0x0,%eax
  802520:	a3 48 40 80 00       	mov    %eax,0x804048
  802525:	a1 48 40 80 00       	mov    0x804048,%eax
  80252a:	85 c0                	test   %eax,%eax
  80252c:	0f 85 23 fe ff ff    	jne    802355 <insert_sorted_allocList+0xf5>
  802532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802536:	0f 85 19 fe ff ff    	jne    802355 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  80253c:	90                   	nop
  80253d:	c9                   	leave  
  80253e:	c3                   	ret    

0080253f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80253f:	55                   	push   %ebp
  802540:	89 e5                	mov    %esp,%ebp
  802542:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802545:	a1 38 41 80 00       	mov    0x804138,%eax
  80254a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254d:	e9 7c 01 00 00       	jmp    8026ce <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 40 0c             	mov    0xc(%eax),%eax
  802558:	3b 45 08             	cmp    0x8(%ebp),%eax
  80255b:	0f 85 90 00 00 00    	jne    8025f1 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256b:	75 17                	jne    802584 <alloc_block_FF+0x45>
  80256d:	83 ec 04             	sub    $0x4,%esp
  802570:	68 1b 3c 80 00       	push   $0x803c1b
  802575:	68 ba 00 00 00       	push   $0xba
  80257a:	68 73 3b 80 00       	push   $0x803b73
  80257f:	e8 53 0b 00 00       	call   8030d7 <_panic>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 00                	mov    (%eax),%eax
  802589:	85 c0                	test   %eax,%eax
  80258b:	74 10                	je     80259d <alloc_block_FF+0x5e>
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 00                	mov    (%eax),%eax
  802592:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802595:	8b 52 04             	mov    0x4(%edx),%edx
  802598:	89 50 04             	mov    %edx,0x4(%eax)
  80259b:	eb 0b                	jmp    8025a8 <alloc_block_FF+0x69>
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 40 04             	mov    0x4(%eax),%eax
  8025a3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	8b 40 04             	mov    0x4(%eax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	74 0f                	je     8025c1 <alloc_block_FF+0x82>
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 40 04             	mov    0x4(%eax),%eax
  8025b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bb:	8b 12                	mov    (%edx),%edx
  8025bd:	89 10                	mov    %edx,(%eax)
  8025bf:	eb 0a                	jmp    8025cb <alloc_block_FF+0x8c>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025de:	a1 44 41 80 00       	mov    0x804144,%eax
  8025e3:	48                   	dec    %eax
  8025e4:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8025e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ec:	e9 10 01 00 00       	jmp    802701 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025fa:	0f 86 c6 00 00 00    	jbe    8026c6 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802600:	a1 48 41 80 00       	mov    0x804148,%eax
  802605:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802608:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80260c:	75 17                	jne    802625 <alloc_block_FF+0xe6>
  80260e:	83 ec 04             	sub    $0x4,%esp
  802611:	68 1b 3c 80 00       	push   $0x803c1b
  802616:	68 c2 00 00 00       	push   $0xc2
  80261b:	68 73 3b 80 00       	push   $0x803b73
  802620:	e8 b2 0a 00 00       	call   8030d7 <_panic>
  802625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	85 c0                	test   %eax,%eax
  80262c:	74 10                	je     80263e <alloc_block_FF+0xff>
  80262e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802636:	8b 52 04             	mov    0x4(%edx),%edx
  802639:	89 50 04             	mov    %edx,0x4(%eax)
  80263c:	eb 0b                	jmp    802649 <alloc_block_FF+0x10a>
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	8b 40 04             	mov    0x4(%eax),%eax
  802644:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264c:	8b 40 04             	mov    0x4(%eax),%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	74 0f                	je     802662 <alloc_block_FF+0x123>
  802653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802656:	8b 40 04             	mov    0x4(%eax),%eax
  802659:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80265c:	8b 12                	mov    (%edx),%edx
  80265e:	89 10                	mov    %edx,(%eax)
  802660:	eb 0a                	jmp    80266c <alloc_block_FF+0x12d>
  802662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802665:	8b 00                	mov    (%eax),%eax
  802667:	a3 48 41 80 00       	mov    %eax,0x804148
  80266c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802678:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267f:	a1 54 41 80 00       	mov    0x804154,%eax
  802684:	48                   	dec    %eax
  802685:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 50 08             	mov    0x8(%eax),%edx
  802690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802693:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802696:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802699:	8b 55 08             	mov    0x8(%ebp),%edx
  80269c:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a5:	2b 45 08             	sub    0x8(%ebp),%eax
  8026a8:	89 c2                	mov    %eax,%edx
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 50 08             	mov    0x8(%eax),%edx
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	01 c2                	add    %eax,%edx
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8026c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c4:	eb 3b                	jmp    802701 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026c6:	a1 40 41 80 00       	mov    0x804140,%eax
  8026cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d2:	74 07                	je     8026db <alloc_block_FF+0x19c>
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 00                	mov    (%eax),%eax
  8026d9:	eb 05                	jmp    8026e0 <alloc_block_FF+0x1a1>
  8026db:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e0:	a3 40 41 80 00       	mov    %eax,0x804140
  8026e5:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	0f 85 60 fe ff ff    	jne    802552 <alloc_block_FF+0x13>
  8026f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f6:	0f 85 56 fe ff ff    	jne    802552 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802701:	c9                   	leave  
  802702:	c3                   	ret    

00802703 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802703:	55                   	push   %ebp
  802704:	89 e5                	mov    %esp,%ebp
  802706:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802709:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802710:	a1 38 41 80 00       	mov    0x804138,%eax
  802715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802718:	eb 3a                	jmp    802754 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 40 0c             	mov    0xc(%eax),%eax
  802720:	3b 45 08             	cmp    0x8(%ebp),%eax
  802723:	72 27                	jb     80274c <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802725:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802729:	75 0b                	jne    802736 <alloc_block_BF+0x33>
					best_size= element->size;
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 40 0c             	mov    0xc(%eax),%eax
  802731:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802734:	eb 16                	jmp    80274c <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 50 0c             	mov    0xc(%eax),%edx
  80273c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273f:	39 c2                	cmp    %eax,%edx
  802741:	77 09                	ja     80274c <alloc_block_BF+0x49>
					best_size=element->size;
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 0c             	mov    0xc(%eax),%eax
  802749:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80274c:	a1 40 41 80 00       	mov    0x804140,%eax
  802751:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802758:	74 07                	je     802761 <alloc_block_BF+0x5e>
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	eb 05                	jmp    802766 <alloc_block_BF+0x63>
  802761:	b8 00 00 00 00       	mov    $0x0,%eax
  802766:	a3 40 41 80 00       	mov    %eax,0x804140
  80276b:	a1 40 41 80 00       	mov    0x804140,%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	75 a6                	jne    80271a <alloc_block_BF+0x17>
  802774:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802778:	75 a0                	jne    80271a <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80277a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80277e:	0f 84 d3 01 00 00    	je     802957 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802784:	a1 38 41 80 00       	mov    0x804138,%eax
  802789:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278c:	e9 98 01 00 00       	jmp    802929 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802794:	3b 45 08             	cmp    0x8(%ebp),%eax
  802797:	0f 86 da 00 00 00    	jbe    802877 <alloc_block_BF+0x174>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 50 0c             	mov    0xc(%eax),%edx
  8027a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a6:	39 c2                	cmp    %eax,%edx
  8027a8:	0f 85 c9 00 00 00    	jne    802877 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8027ae:	a1 48 41 80 00       	mov    0x804148,%eax
  8027b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8027b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ba:	75 17                	jne    8027d3 <alloc_block_BF+0xd0>
  8027bc:	83 ec 04             	sub    $0x4,%esp
  8027bf:	68 1b 3c 80 00       	push   $0x803c1b
  8027c4:	68 ea 00 00 00       	push   $0xea
  8027c9:	68 73 3b 80 00       	push   $0x803b73
  8027ce:	e8 04 09 00 00       	call   8030d7 <_panic>
  8027d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d6:	8b 00                	mov    (%eax),%eax
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	74 10                	je     8027ec <alloc_block_BF+0xe9>
  8027dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027e4:	8b 52 04             	mov    0x4(%edx),%edx
  8027e7:	89 50 04             	mov    %edx,0x4(%eax)
  8027ea:	eb 0b                	jmp    8027f7 <alloc_block_BF+0xf4>
  8027ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ef:	8b 40 04             	mov    0x4(%eax),%eax
  8027f2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fa:	8b 40 04             	mov    0x4(%eax),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	74 0f                	je     802810 <alloc_block_BF+0x10d>
  802801:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802804:	8b 40 04             	mov    0x4(%eax),%eax
  802807:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80280a:	8b 12                	mov    (%edx),%edx
  80280c:	89 10                	mov    %edx,(%eax)
  80280e:	eb 0a                	jmp    80281a <alloc_block_BF+0x117>
  802810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802813:	8b 00                	mov    (%eax),%eax
  802815:	a3 48 41 80 00       	mov    %eax,0x804148
  80281a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802823:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802826:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282d:	a1 54 41 80 00       	mov    0x804154,%eax
  802832:	48                   	dec    %eax
  802833:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 50 08             	mov    0x8(%eax),%edx
  80283e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802841:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802847:	8b 55 08             	mov    0x8(%ebp),%edx
  80284a:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	8b 40 0c             	mov    0xc(%eax),%eax
  802853:	2b 45 08             	sub    0x8(%ebp),%eax
  802856:	89 c2                	mov    %eax,%edx
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 50 08             	mov    0x8(%eax),%edx
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	01 c2                	add    %eax,%edx
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  80286f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802872:	e9 e5 00 00 00       	jmp    80295c <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 50 0c             	mov    0xc(%eax),%edx
  80287d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802880:	39 c2                	cmp    %eax,%edx
  802882:	0f 85 99 00 00 00    	jne    802921 <alloc_block_BF+0x21e>
  802888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288e:	0f 85 8d 00 00 00    	jne    802921 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  80289a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289e:	75 17                	jne    8028b7 <alloc_block_BF+0x1b4>
  8028a0:	83 ec 04             	sub    $0x4,%esp
  8028a3:	68 1b 3c 80 00       	push   $0x803c1b
  8028a8:	68 f7 00 00 00       	push   $0xf7
  8028ad:	68 73 3b 80 00       	push   $0x803b73
  8028b2:	e8 20 08 00 00       	call   8030d7 <_panic>
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 00                	mov    (%eax),%eax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	74 10                	je     8028d0 <alloc_block_BF+0x1cd>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c8:	8b 52 04             	mov    0x4(%edx),%edx
  8028cb:	89 50 04             	mov    %edx,0x4(%eax)
  8028ce:	eb 0b                	jmp    8028db <alloc_block_BF+0x1d8>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 40 04             	mov    0x4(%eax),%eax
  8028d6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 40 04             	mov    0x4(%eax),%eax
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	74 0f                	je     8028f4 <alloc_block_BF+0x1f1>
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 40 04             	mov    0x4(%eax),%eax
  8028eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ee:	8b 12                	mov    (%edx),%edx
  8028f0:	89 10                	mov    %edx,(%eax)
  8028f2:	eb 0a                	jmp    8028fe <alloc_block_BF+0x1fb>
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	a3 38 41 80 00       	mov    %eax,0x804138
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802911:	a1 44 41 80 00       	mov    0x804144,%eax
  802916:	48                   	dec    %eax
  802917:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  80291c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291f:	eb 3b                	jmp    80295c <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802921:	a1 40 41 80 00       	mov    0x804140,%eax
  802926:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802929:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292d:	74 07                	je     802936 <alloc_block_BF+0x233>
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	8b 00                	mov    (%eax),%eax
  802934:	eb 05                	jmp    80293b <alloc_block_BF+0x238>
  802936:	b8 00 00 00 00       	mov    $0x0,%eax
  80293b:	a3 40 41 80 00       	mov    %eax,0x804140
  802940:	a1 40 41 80 00       	mov    0x804140,%eax
  802945:	85 c0                	test   %eax,%eax
  802947:	0f 85 44 fe ff ff    	jne    802791 <alloc_block_BF+0x8e>
  80294d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802951:	0f 85 3a fe ff ff    	jne    802791 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802957:	b8 00 00 00 00       	mov    $0x0,%eax
  80295c:	c9                   	leave  
  80295d:	c3                   	ret    

0080295e <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80295e:	55                   	push   %ebp
  80295f:	89 e5                	mov    %esp,%ebp
  802961:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802964:	83 ec 04             	sub    $0x4,%esp
  802967:	68 3c 3c 80 00       	push   $0x803c3c
  80296c:	68 04 01 00 00       	push   $0x104
  802971:	68 73 3b 80 00       	push   $0x803b73
  802976:	e8 5c 07 00 00       	call   8030d7 <_panic>

0080297b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80297b:	55                   	push   %ebp
  80297c:	89 e5                	mov    %esp,%ebp
  80297e:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802981:	a1 38 41 80 00       	mov    0x804138,%eax
  802986:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802989:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80298e:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802991:	a1 38 41 80 00       	mov    0x804138,%eax
  802996:	85 c0                	test   %eax,%eax
  802998:	75 68                	jne    802a02 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80299a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80299e:	75 17                	jne    8029b7 <insert_sorted_with_merge_freeList+0x3c>
  8029a0:	83 ec 04             	sub    $0x4,%esp
  8029a3:	68 50 3b 80 00       	push   $0x803b50
  8029a8:	68 14 01 00 00       	push   $0x114
  8029ad:	68 73 3b 80 00       	push   $0x803b73
  8029b2:	e8 20 07 00 00       	call   8030d7 <_panic>
  8029b7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	89 10                	mov    %edx,(%eax)
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	8b 00                	mov    (%eax),%eax
  8029c7:	85 c0                	test   %eax,%eax
  8029c9:	74 0d                	je     8029d8 <insert_sorted_with_merge_freeList+0x5d>
  8029cb:	a1 38 41 80 00       	mov    0x804138,%eax
  8029d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d3:	89 50 04             	mov    %edx,0x4(%eax)
  8029d6:	eb 08                	jmp    8029e0 <insert_sorted_with_merge_freeList+0x65>
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	a3 38 41 80 00       	mov    %eax,0x804138
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f2:	a1 44 41 80 00       	mov    0x804144,%eax
  8029f7:	40                   	inc    %eax
  8029f8:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8029fd:	e9 d2 06 00 00       	jmp    8030d4 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	8b 50 08             	mov    0x8(%eax),%edx
  802a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0b:	8b 40 08             	mov    0x8(%eax),%eax
  802a0e:	39 c2                	cmp    %eax,%edx
  802a10:	0f 83 22 01 00 00    	jae    802b38 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	8b 50 08             	mov    0x8(%eax),%edx
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a22:	01 c2                	add    %eax,%edx
  802a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a27:	8b 40 08             	mov    0x8(%eax),%eax
  802a2a:	39 c2                	cmp    %eax,%edx
  802a2c:	0f 85 9e 00 00 00    	jne    802ad0 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	8b 50 08             	mov    0x8(%eax),%edx
  802a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3b:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a41:	8b 50 0c             	mov    0xc(%eax),%edx
  802a44:	8b 45 08             	mov    0x8(%ebp),%eax
  802a47:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4a:	01 c2                	add    %eax,%edx
  802a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4f:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802a52:	8b 45 08             	mov    0x8(%ebp),%eax
  802a55:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	8b 50 08             	mov    0x8(%eax),%edx
  802a62:	8b 45 08             	mov    0x8(%ebp),%eax
  802a65:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a6c:	75 17                	jne    802a85 <insert_sorted_with_merge_freeList+0x10a>
  802a6e:	83 ec 04             	sub    $0x4,%esp
  802a71:	68 50 3b 80 00       	push   $0x803b50
  802a76:	68 21 01 00 00       	push   $0x121
  802a7b:	68 73 3b 80 00       	push   $0x803b73
  802a80:	e8 52 06 00 00       	call   8030d7 <_panic>
  802a85:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8e:	89 10                	mov    %edx,(%eax)
  802a90:	8b 45 08             	mov    0x8(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	85 c0                	test   %eax,%eax
  802a97:	74 0d                	je     802aa6 <insert_sorted_with_merge_freeList+0x12b>
  802a99:	a1 48 41 80 00       	mov    0x804148,%eax
  802a9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa1:	89 50 04             	mov    %edx,0x4(%eax)
  802aa4:	eb 08                	jmp    802aae <insert_sorted_with_merge_freeList+0x133>
  802aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aae:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab1:	a3 48 41 80 00       	mov    %eax,0x804148
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac0:	a1 54 41 80 00       	mov    0x804154,%eax
  802ac5:	40                   	inc    %eax
  802ac6:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802acb:	e9 04 06 00 00       	jmp    8030d4 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802ad0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad4:	75 17                	jne    802aed <insert_sorted_with_merge_freeList+0x172>
  802ad6:	83 ec 04             	sub    $0x4,%esp
  802ad9:	68 50 3b 80 00       	push   $0x803b50
  802ade:	68 26 01 00 00       	push   $0x126
  802ae3:	68 73 3b 80 00       	push   $0x803b73
  802ae8:	e8 ea 05 00 00       	call   8030d7 <_panic>
  802aed:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	89 10                	mov    %edx,(%eax)
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 0d                	je     802b0e <insert_sorted_with_merge_freeList+0x193>
  802b01:	a1 38 41 80 00       	mov    0x804138,%eax
  802b06:	8b 55 08             	mov    0x8(%ebp),%edx
  802b09:	89 50 04             	mov    %edx,0x4(%eax)
  802b0c:	eb 08                	jmp    802b16 <insert_sorted_with_merge_freeList+0x19b>
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	a3 38 41 80 00       	mov    %eax,0x804138
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b28:	a1 44 41 80 00       	mov    0x804144,%eax
  802b2d:	40                   	inc    %eax
  802b2e:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b33:	e9 9c 05 00 00       	jmp    8030d4 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	8b 50 08             	mov    0x8(%eax),%edx
  802b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b41:	8b 40 08             	mov    0x8(%eax),%eax
  802b44:	39 c2                	cmp    %eax,%edx
  802b46:	0f 86 16 01 00 00    	jbe    802c62 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4f:	8b 50 08             	mov    0x8(%eax),%edx
  802b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b55:	8b 40 0c             	mov    0xc(%eax),%eax
  802b58:	01 c2                	add    %eax,%edx
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	8b 40 08             	mov    0x8(%eax),%eax
  802b60:	39 c2                	cmp    %eax,%edx
  802b62:	0f 85 92 00 00 00    	jne    802bfa <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6b:	8b 50 0c             	mov    0xc(%eax),%edx
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	8b 40 0c             	mov    0xc(%eax),%eax
  802b74:	01 c2                	add    %eax,%edx
  802b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b79:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	8b 50 08             	mov    0x8(%eax),%edx
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b96:	75 17                	jne    802baf <insert_sorted_with_merge_freeList+0x234>
  802b98:	83 ec 04             	sub    $0x4,%esp
  802b9b:	68 50 3b 80 00       	push   $0x803b50
  802ba0:	68 31 01 00 00       	push   $0x131
  802ba5:	68 73 3b 80 00       	push   $0x803b73
  802baa:	e8 28 05 00 00       	call   8030d7 <_panic>
  802baf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	89 10                	mov    %edx,(%eax)
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	8b 00                	mov    (%eax),%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	74 0d                	je     802bd0 <insert_sorted_with_merge_freeList+0x255>
  802bc3:	a1 48 41 80 00       	mov    0x804148,%eax
  802bc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bcb:	89 50 04             	mov    %edx,0x4(%eax)
  802bce:	eb 08                	jmp    802bd8 <insert_sorted_with_merge_freeList+0x25d>
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	a3 48 41 80 00       	mov    %eax,0x804148
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bea:	a1 54 41 80 00       	mov    0x804154,%eax
  802bef:	40                   	inc    %eax
  802bf0:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802bf5:	e9 da 04 00 00       	jmp    8030d4 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802bfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bfe:	75 17                	jne    802c17 <insert_sorted_with_merge_freeList+0x29c>
  802c00:	83 ec 04             	sub    $0x4,%esp
  802c03:	68 f8 3b 80 00       	push   $0x803bf8
  802c08:	68 37 01 00 00       	push   $0x137
  802c0d:	68 73 3b 80 00       	push   $0x803b73
  802c12:	e8 c0 04 00 00       	call   8030d7 <_panic>
  802c17:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	89 50 04             	mov    %edx,0x4(%eax)
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	8b 40 04             	mov    0x4(%eax),%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	74 0c                	je     802c39 <insert_sorted_with_merge_freeList+0x2be>
  802c2d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c32:	8b 55 08             	mov    0x8(%ebp),%edx
  802c35:	89 10                	mov    %edx,(%eax)
  802c37:	eb 08                	jmp    802c41 <insert_sorted_with_merge_freeList+0x2c6>
  802c39:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c49:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c52:	a1 44 41 80 00       	mov    0x804144,%eax
  802c57:	40                   	inc    %eax
  802c58:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802c5d:	e9 72 04 00 00       	jmp    8030d4 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802c62:	a1 38 41 80 00       	mov    0x804138,%eax
  802c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6a:	e9 35 04 00 00       	jmp    8030a4 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 00                	mov    (%eax),%eax
  802c74:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	8b 50 08             	mov    0x8(%eax),%edx
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 40 08             	mov    0x8(%eax),%eax
  802c83:	39 c2                	cmp    %eax,%edx
  802c85:	0f 86 11 04 00 00    	jbe    80309c <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 50 08             	mov    0x8(%eax),%edx
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 40 0c             	mov    0xc(%eax),%eax
  802c97:	01 c2                	add    %eax,%edx
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	8b 40 08             	mov    0x8(%eax),%eax
  802c9f:	39 c2                	cmp    %eax,%edx
  802ca1:	0f 83 8b 00 00 00    	jae    802d32 <insert_sorted_with_merge_freeList+0x3b7>
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	8b 50 08             	mov    0x8(%eax),%edx
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb3:	01 c2                	add    %eax,%edx
  802cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb8:	8b 40 08             	mov    0x8(%eax),%eax
  802cbb:	39 c2                	cmp    %eax,%edx
  802cbd:	73 73                	jae    802d32 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802cbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc3:	74 06                	je     802ccb <insert_sorted_with_merge_freeList+0x350>
  802cc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc9:	75 17                	jne    802ce2 <insert_sorted_with_merge_freeList+0x367>
  802ccb:	83 ec 04             	sub    $0x4,%esp
  802cce:	68 c4 3b 80 00       	push   $0x803bc4
  802cd3:	68 48 01 00 00       	push   $0x148
  802cd8:	68 73 3b 80 00       	push   $0x803b73
  802cdd:	e8 f5 03 00 00       	call   8030d7 <_panic>
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 10                	mov    (%eax),%edx
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	89 10                	mov    %edx,(%eax)
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	74 0b                	je     802d00 <insert_sorted_with_merge_freeList+0x385>
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfd:	89 50 04             	mov    %edx,0x4(%eax)
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d03:	8b 55 08             	mov    0x8(%ebp),%edx
  802d06:	89 10                	mov    %edx,(%eax)
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0e:	89 50 04             	mov    %edx,0x4(%eax)
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	75 08                	jne    802d22 <insert_sorted_with_merge_freeList+0x3a7>
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d22:	a1 44 41 80 00       	mov    0x804144,%eax
  802d27:	40                   	inc    %eax
  802d28:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802d2d:	e9 a2 03 00 00       	jmp    8030d4 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	8b 50 08             	mov    0x8(%eax),%edx
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3e:	01 c2                	add    %eax,%edx
  802d40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d43:	8b 40 08             	mov    0x8(%eax),%eax
  802d46:	39 c2                	cmp    %eax,%edx
  802d48:	0f 83 ae 00 00 00    	jae    802dfc <insert_sorted_with_merge_freeList+0x481>
  802d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d51:	8b 50 08             	mov    0x8(%eax),%edx
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 48 08             	mov    0x8(%eax),%ecx
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d60:	01 c8                	add    %ecx,%eax
  802d62:	39 c2                	cmp    %eax,%edx
  802d64:	0f 85 92 00 00 00    	jne    802dfc <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	8b 40 0c             	mov    0xc(%eax),%eax
  802d76:	01 c2                	add    %eax,%edx
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	8b 50 08             	mov    0x8(%eax),%edx
  802d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d91:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d98:	75 17                	jne    802db1 <insert_sorted_with_merge_freeList+0x436>
  802d9a:	83 ec 04             	sub    $0x4,%esp
  802d9d:	68 50 3b 80 00       	push   $0x803b50
  802da2:	68 51 01 00 00       	push   $0x151
  802da7:	68 73 3b 80 00       	push   $0x803b73
  802dac:	e8 26 03 00 00       	call   8030d7 <_panic>
  802db1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	89 10                	mov    %edx,(%eax)
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	8b 00                	mov    (%eax),%eax
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	74 0d                	je     802dd2 <insert_sorted_with_merge_freeList+0x457>
  802dc5:	a1 48 41 80 00       	mov    0x804148,%eax
  802dca:	8b 55 08             	mov    0x8(%ebp),%edx
  802dcd:	89 50 04             	mov    %edx,0x4(%eax)
  802dd0:	eb 08                	jmp    802dda <insert_sorted_with_merge_freeList+0x45f>
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	a3 48 41 80 00       	mov    %eax,0x804148
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dec:	a1 54 41 80 00       	mov    0x804154,%eax
  802df1:	40                   	inc    %eax
  802df2:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802df7:	e9 d8 02 00 00       	jmp    8030d4 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	8b 50 08             	mov    0x8(%eax),%edx
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	8b 40 0c             	mov    0xc(%eax),%eax
  802e08:	01 c2                	add    %eax,%edx
  802e0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0d:	8b 40 08             	mov    0x8(%eax),%eax
  802e10:	39 c2                	cmp    %eax,%edx
  802e12:	0f 85 ba 00 00 00    	jne    802ed2 <insert_sorted_with_merge_freeList+0x557>
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	8b 50 08             	mov    0x8(%eax),%edx
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 48 08             	mov    0x8(%eax),%ecx
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2a:	01 c8                	add    %ecx,%eax
  802e2c:	39 c2                	cmp    %eax,%edx
  802e2e:	0f 86 9e 00 00 00    	jbe    802ed2 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802e34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e37:	8b 50 0c             	mov    0xc(%eax),%edx
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e40:	01 c2                	add    %eax,%edx
  802e42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e45:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	8b 50 08             	mov    0x8(%eax),%edx
  802e4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e51:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	8b 50 08             	mov    0x8(%eax),%edx
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6e:	75 17                	jne    802e87 <insert_sorted_with_merge_freeList+0x50c>
  802e70:	83 ec 04             	sub    $0x4,%esp
  802e73:	68 50 3b 80 00       	push   $0x803b50
  802e78:	68 5b 01 00 00       	push   $0x15b
  802e7d:	68 73 3b 80 00       	push   $0x803b73
  802e82:	e8 50 02 00 00       	call   8030d7 <_panic>
  802e87:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	89 10                	mov    %edx,(%eax)
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	8b 00                	mov    (%eax),%eax
  802e97:	85 c0                	test   %eax,%eax
  802e99:	74 0d                	je     802ea8 <insert_sorted_with_merge_freeList+0x52d>
  802e9b:	a1 48 41 80 00       	mov    0x804148,%eax
  802ea0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea3:	89 50 04             	mov    %edx,0x4(%eax)
  802ea6:	eb 08                	jmp    802eb0 <insert_sorted_with_merge_freeList+0x535>
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	a3 48 41 80 00       	mov    %eax,0x804148
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec2:	a1 54 41 80 00       	mov    0x804154,%eax
  802ec7:	40                   	inc    %eax
  802ec8:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802ecd:	e9 02 02 00 00       	jmp    8030d4 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	8b 50 08             	mov    0x8(%eax),%edx
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ede:	01 c2                	add    %eax,%edx
  802ee0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee3:	8b 40 08             	mov    0x8(%eax),%eax
  802ee6:	39 c2                	cmp    %eax,%edx
  802ee8:	0f 85 ae 01 00 00    	jne    80309c <insert_sorted_with_merge_freeList+0x721>
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	8b 50 08             	mov    0x8(%eax),%edx
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	8b 48 08             	mov    0x8(%eax),%ecx
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 40 0c             	mov    0xc(%eax),%eax
  802f00:	01 c8                	add    %ecx,%eax
  802f02:	39 c2                	cmp    %eax,%edx
  802f04:	0f 85 92 01 00 00    	jne    80309c <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 50 0c             	mov    0xc(%eax),%edx
  802f10:	8b 45 08             	mov    0x8(%ebp),%eax
  802f13:	8b 40 0c             	mov    0xc(%eax),%eax
  802f16:	01 c2                	add    %eax,%edx
  802f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1e:	01 c2                	add    %eax,%edx
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	8b 50 08             	mov    0x8(%eax),%edx
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f49:	8b 50 08             	mov    0x8(%eax),%edx
  802f4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4f:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802f52:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f56:	75 17                	jne    802f6f <insert_sorted_with_merge_freeList+0x5f4>
  802f58:	83 ec 04             	sub    $0x4,%esp
  802f5b:	68 1b 3c 80 00       	push   $0x803c1b
  802f60:	68 63 01 00 00       	push   $0x163
  802f65:	68 73 3b 80 00       	push   $0x803b73
  802f6a:	e8 68 01 00 00       	call   8030d7 <_panic>
  802f6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	85 c0                	test   %eax,%eax
  802f76:	74 10                	je     802f88 <insert_sorted_with_merge_freeList+0x60d>
  802f78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f80:	8b 52 04             	mov    0x4(%edx),%edx
  802f83:	89 50 04             	mov    %edx,0x4(%eax)
  802f86:	eb 0b                	jmp    802f93 <insert_sorted_with_merge_freeList+0x618>
  802f88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8b:	8b 40 04             	mov    0x4(%eax),%eax
  802f8e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f96:	8b 40 04             	mov    0x4(%eax),%eax
  802f99:	85 c0                	test   %eax,%eax
  802f9b:	74 0f                	je     802fac <insert_sorted_with_merge_freeList+0x631>
  802f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa0:	8b 40 04             	mov    0x4(%eax),%eax
  802fa3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa6:	8b 12                	mov    (%edx),%edx
  802fa8:	89 10                	mov    %edx,(%eax)
  802faa:	eb 0a                	jmp    802fb6 <insert_sorted_with_merge_freeList+0x63b>
  802fac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	a3 38 41 80 00       	mov    %eax,0x804138
  802fb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc9:	a1 44 41 80 00       	mov    0x804144,%eax
  802fce:	48                   	dec    %eax
  802fcf:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802fd4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd8:	75 17                	jne    802ff1 <insert_sorted_with_merge_freeList+0x676>
  802fda:	83 ec 04             	sub    $0x4,%esp
  802fdd:	68 50 3b 80 00       	push   $0x803b50
  802fe2:	68 64 01 00 00       	push   $0x164
  802fe7:	68 73 3b 80 00       	push   $0x803b73
  802fec:	e8 e6 00 00 00       	call   8030d7 <_panic>
  802ff1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffa:	89 10                	mov    %edx,(%eax)
  802ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	85 c0                	test   %eax,%eax
  803003:	74 0d                	je     803012 <insert_sorted_with_merge_freeList+0x697>
  803005:	a1 48 41 80 00       	mov    0x804148,%eax
  80300a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80300d:	89 50 04             	mov    %edx,0x4(%eax)
  803010:	eb 08                	jmp    80301a <insert_sorted_with_merge_freeList+0x69f>
  803012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803015:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80301a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301d:	a3 48 41 80 00       	mov    %eax,0x804148
  803022:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803025:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302c:	a1 54 41 80 00       	mov    0x804154,%eax
  803031:	40                   	inc    %eax
  803032:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803037:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303b:	75 17                	jne    803054 <insert_sorted_with_merge_freeList+0x6d9>
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	68 50 3b 80 00       	push   $0x803b50
  803045:	68 65 01 00 00       	push   $0x165
  80304a:	68 73 3b 80 00       	push   $0x803b73
  80304f:	e8 83 00 00 00       	call   8030d7 <_panic>
  803054:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	89 10                	mov    %edx,(%eax)
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	8b 00                	mov    (%eax),%eax
  803064:	85 c0                	test   %eax,%eax
  803066:	74 0d                	je     803075 <insert_sorted_with_merge_freeList+0x6fa>
  803068:	a1 48 41 80 00       	mov    0x804148,%eax
  80306d:	8b 55 08             	mov    0x8(%ebp),%edx
  803070:	89 50 04             	mov    %edx,0x4(%eax)
  803073:	eb 08                	jmp    80307d <insert_sorted_with_merge_freeList+0x702>
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	a3 48 41 80 00       	mov    %eax,0x804148
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308f:	a1 54 41 80 00       	mov    0x804154,%eax
  803094:	40                   	inc    %eax
  803095:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  80309a:	eb 38                	jmp    8030d4 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80309c:	a1 40 41 80 00       	mov    0x804140,%eax
  8030a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a8:	74 07                	je     8030b1 <insert_sorted_with_merge_freeList+0x736>
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	eb 05                	jmp    8030b6 <insert_sorted_with_merge_freeList+0x73b>
  8030b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b6:	a3 40 41 80 00       	mov    %eax,0x804140
  8030bb:	a1 40 41 80 00       	mov    0x804140,%eax
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	0f 85 a7 fb ff ff    	jne    802c6f <insert_sorted_with_merge_freeList+0x2f4>
  8030c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030cc:	0f 85 9d fb ff ff    	jne    802c6f <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8030d2:	eb 00                	jmp    8030d4 <insert_sorted_with_merge_freeList+0x759>
  8030d4:	90                   	nop
  8030d5:	c9                   	leave  
  8030d6:	c3                   	ret    

008030d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8030d7:	55                   	push   %ebp
  8030d8:	89 e5                	mov    %esp,%ebp
  8030da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8030dd:	8d 45 10             	lea    0x10(%ebp),%eax
  8030e0:	83 c0 04             	add    $0x4,%eax
  8030e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8030e6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	74 16                	je     803105 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8030ef:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8030f4:	83 ec 08             	sub    $0x8,%esp
  8030f7:	50                   	push   %eax
  8030f8:	68 6c 3c 80 00       	push   $0x803c6c
  8030fd:	e8 81 d5 ff ff       	call   800683 <cprintf>
  803102:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803105:	a1 00 40 80 00       	mov    0x804000,%eax
  80310a:	ff 75 0c             	pushl  0xc(%ebp)
  80310d:	ff 75 08             	pushl  0x8(%ebp)
  803110:	50                   	push   %eax
  803111:	68 71 3c 80 00       	push   $0x803c71
  803116:	e8 68 d5 ff ff       	call   800683 <cprintf>
  80311b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80311e:	8b 45 10             	mov    0x10(%ebp),%eax
  803121:	83 ec 08             	sub    $0x8,%esp
  803124:	ff 75 f4             	pushl  -0xc(%ebp)
  803127:	50                   	push   %eax
  803128:	e8 eb d4 ff ff       	call   800618 <vcprintf>
  80312d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803130:	83 ec 08             	sub    $0x8,%esp
  803133:	6a 00                	push   $0x0
  803135:	68 8d 3c 80 00       	push   $0x803c8d
  80313a:	e8 d9 d4 ff ff       	call   800618 <vcprintf>
  80313f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803142:	e8 5a d4 ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  803147:	eb fe                	jmp    803147 <_panic+0x70>

00803149 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803149:	55                   	push   %ebp
  80314a:	89 e5                	mov    %esp,%ebp
  80314c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80314f:	a1 20 40 80 00       	mov    0x804020,%eax
  803154:	8b 50 74             	mov    0x74(%eax),%edx
  803157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80315a:	39 c2                	cmp    %eax,%edx
  80315c:	74 14                	je     803172 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80315e:	83 ec 04             	sub    $0x4,%esp
  803161:	68 90 3c 80 00       	push   $0x803c90
  803166:	6a 26                	push   $0x26
  803168:	68 dc 3c 80 00       	push   $0x803cdc
  80316d:	e8 65 ff ff ff       	call   8030d7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803172:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803179:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803180:	e9 c2 00 00 00       	jmp    803247 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803185:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803188:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	01 d0                	add    %edx,%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	85 c0                	test   %eax,%eax
  803198:	75 08                	jne    8031a2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80319a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80319d:	e9 a2 00 00 00       	jmp    803244 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8031a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8031b0:	eb 69                	jmp    80321b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8031b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8031b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8031bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c0:	89 d0                	mov    %edx,%eax
  8031c2:	01 c0                	add    %eax,%eax
  8031c4:	01 d0                	add    %edx,%eax
  8031c6:	c1 e0 03             	shl    $0x3,%eax
  8031c9:	01 c8                	add    %ecx,%eax
  8031cb:	8a 40 04             	mov    0x4(%eax),%al
  8031ce:	84 c0                	test   %al,%al
  8031d0:	75 46                	jne    803218 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8031d2:	a1 20 40 80 00       	mov    0x804020,%eax
  8031d7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8031dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e0:	89 d0                	mov    %edx,%eax
  8031e2:	01 c0                	add    %eax,%eax
  8031e4:	01 d0                	add    %edx,%eax
  8031e6:	c1 e0 03             	shl    $0x3,%eax
  8031e9:	01 c8                	add    %ecx,%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8031f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8031f8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8031fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	01 c8                	add    %ecx,%eax
  803209:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80320b:	39 c2                	cmp    %eax,%edx
  80320d:	75 09                	jne    803218 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80320f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803216:	eb 12                	jmp    80322a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803218:	ff 45 e8             	incl   -0x18(%ebp)
  80321b:	a1 20 40 80 00       	mov    0x804020,%eax
  803220:	8b 50 74             	mov    0x74(%eax),%edx
  803223:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803226:	39 c2                	cmp    %eax,%edx
  803228:	77 88                	ja     8031b2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80322a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80322e:	75 14                	jne    803244 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803230:	83 ec 04             	sub    $0x4,%esp
  803233:	68 e8 3c 80 00       	push   $0x803ce8
  803238:	6a 3a                	push   $0x3a
  80323a:	68 dc 3c 80 00       	push   $0x803cdc
  80323f:	e8 93 fe ff ff       	call   8030d7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803244:	ff 45 f0             	incl   -0x10(%ebp)
  803247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80324d:	0f 8c 32 ff ff ff    	jl     803185 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803253:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80325a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803261:	eb 26                	jmp    803289 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803263:	a1 20 40 80 00       	mov    0x804020,%eax
  803268:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80326e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803271:	89 d0                	mov    %edx,%eax
  803273:	01 c0                	add    %eax,%eax
  803275:	01 d0                	add    %edx,%eax
  803277:	c1 e0 03             	shl    $0x3,%eax
  80327a:	01 c8                	add    %ecx,%eax
  80327c:	8a 40 04             	mov    0x4(%eax),%al
  80327f:	3c 01                	cmp    $0x1,%al
  803281:	75 03                	jne    803286 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803283:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803286:	ff 45 e0             	incl   -0x20(%ebp)
  803289:	a1 20 40 80 00       	mov    0x804020,%eax
  80328e:	8b 50 74             	mov    0x74(%eax),%edx
  803291:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803294:	39 c2                	cmp    %eax,%edx
  803296:	77 cb                	ja     803263 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80329e:	74 14                	je     8032b4 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8032a0:	83 ec 04             	sub    $0x4,%esp
  8032a3:	68 3c 3d 80 00       	push   $0x803d3c
  8032a8:	6a 44                	push   $0x44
  8032aa:	68 dc 3c 80 00       	push   $0x803cdc
  8032af:	e8 23 fe ff ff       	call   8030d7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8032b4:	90                   	nop
  8032b5:	c9                   	leave  
  8032b6:	c3                   	ret    
  8032b7:	90                   	nop

008032b8 <__udivdi3>:
  8032b8:	55                   	push   %ebp
  8032b9:	57                   	push   %edi
  8032ba:	56                   	push   %esi
  8032bb:	53                   	push   %ebx
  8032bc:	83 ec 1c             	sub    $0x1c,%esp
  8032bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032cf:	89 ca                	mov    %ecx,%edx
  8032d1:	89 f8                	mov    %edi,%eax
  8032d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032d7:	85 f6                	test   %esi,%esi
  8032d9:	75 2d                	jne    803308 <__udivdi3+0x50>
  8032db:	39 cf                	cmp    %ecx,%edi
  8032dd:	77 65                	ja     803344 <__udivdi3+0x8c>
  8032df:	89 fd                	mov    %edi,%ebp
  8032e1:	85 ff                	test   %edi,%edi
  8032e3:	75 0b                	jne    8032f0 <__udivdi3+0x38>
  8032e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ea:	31 d2                	xor    %edx,%edx
  8032ec:	f7 f7                	div    %edi
  8032ee:	89 c5                	mov    %eax,%ebp
  8032f0:	31 d2                	xor    %edx,%edx
  8032f2:	89 c8                	mov    %ecx,%eax
  8032f4:	f7 f5                	div    %ebp
  8032f6:	89 c1                	mov    %eax,%ecx
  8032f8:	89 d8                	mov    %ebx,%eax
  8032fa:	f7 f5                	div    %ebp
  8032fc:	89 cf                	mov    %ecx,%edi
  8032fe:	89 fa                	mov    %edi,%edx
  803300:	83 c4 1c             	add    $0x1c,%esp
  803303:	5b                   	pop    %ebx
  803304:	5e                   	pop    %esi
  803305:	5f                   	pop    %edi
  803306:	5d                   	pop    %ebp
  803307:	c3                   	ret    
  803308:	39 ce                	cmp    %ecx,%esi
  80330a:	77 28                	ja     803334 <__udivdi3+0x7c>
  80330c:	0f bd fe             	bsr    %esi,%edi
  80330f:	83 f7 1f             	xor    $0x1f,%edi
  803312:	75 40                	jne    803354 <__udivdi3+0x9c>
  803314:	39 ce                	cmp    %ecx,%esi
  803316:	72 0a                	jb     803322 <__udivdi3+0x6a>
  803318:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80331c:	0f 87 9e 00 00 00    	ja     8033c0 <__udivdi3+0x108>
  803322:	b8 01 00 00 00       	mov    $0x1,%eax
  803327:	89 fa                	mov    %edi,%edx
  803329:	83 c4 1c             	add    $0x1c,%esp
  80332c:	5b                   	pop    %ebx
  80332d:	5e                   	pop    %esi
  80332e:	5f                   	pop    %edi
  80332f:	5d                   	pop    %ebp
  803330:	c3                   	ret    
  803331:	8d 76 00             	lea    0x0(%esi),%esi
  803334:	31 ff                	xor    %edi,%edi
  803336:	31 c0                	xor    %eax,%eax
  803338:	89 fa                	mov    %edi,%edx
  80333a:	83 c4 1c             	add    $0x1c,%esp
  80333d:	5b                   	pop    %ebx
  80333e:	5e                   	pop    %esi
  80333f:	5f                   	pop    %edi
  803340:	5d                   	pop    %ebp
  803341:	c3                   	ret    
  803342:	66 90                	xchg   %ax,%ax
  803344:	89 d8                	mov    %ebx,%eax
  803346:	f7 f7                	div    %edi
  803348:	31 ff                	xor    %edi,%edi
  80334a:	89 fa                	mov    %edi,%edx
  80334c:	83 c4 1c             	add    $0x1c,%esp
  80334f:	5b                   	pop    %ebx
  803350:	5e                   	pop    %esi
  803351:	5f                   	pop    %edi
  803352:	5d                   	pop    %ebp
  803353:	c3                   	ret    
  803354:	bd 20 00 00 00       	mov    $0x20,%ebp
  803359:	89 eb                	mov    %ebp,%ebx
  80335b:	29 fb                	sub    %edi,%ebx
  80335d:	89 f9                	mov    %edi,%ecx
  80335f:	d3 e6                	shl    %cl,%esi
  803361:	89 c5                	mov    %eax,%ebp
  803363:	88 d9                	mov    %bl,%cl
  803365:	d3 ed                	shr    %cl,%ebp
  803367:	89 e9                	mov    %ebp,%ecx
  803369:	09 f1                	or     %esi,%ecx
  80336b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80336f:	89 f9                	mov    %edi,%ecx
  803371:	d3 e0                	shl    %cl,%eax
  803373:	89 c5                	mov    %eax,%ebp
  803375:	89 d6                	mov    %edx,%esi
  803377:	88 d9                	mov    %bl,%cl
  803379:	d3 ee                	shr    %cl,%esi
  80337b:	89 f9                	mov    %edi,%ecx
  80337d:	d3 e2                	shl    %cl,%edx
  80337f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803383:	88 d9                	mov    %bl,%cl
  803385:	d3 e8                	shr    %cl,%eax
  803387:	09 c2                	or     %eax,%edx
  803389:	89 d0                	mov    %edx,%eax
  80338b:	89 f2                	mov    %esi,%edx
  80338d:	f7 74 24 0c          	divl   0xc(%esp)
  803391:	89 d6                	mov    %edx,%esi
  803393:	89 c3                	mov    %eax,%ebx
  803395:	f7 e5                	mul    %ebp
  803397:	39 d6                	cmp    %edx,%esi
  803399:	72 19                	jb     8033b4 <__udivdi3+0xfc>
  80339b:	74 0b                	je     8033a8 <__udivdi3+0xf0>
  80339d:	89 d8                	mov    %ebx,%eax
  80339f:	31 ff                	xor    %edi,%edi
  8033a1:	e9 58 ff ff ff       	jmp    8032fe <__udivdi3+0x46>
  8033a6:	66 90                	xchg   %ax,%ax
  8033a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033ac:	89 f9                	mov    %edi,%ecx
  8033ae:	d3 e2                	shl    %cl,%edx
  8033b0:	39 c2                	cmp    %eax,%edx
  8033b2:	73 e9                	jae    80339d <__udivdi3+0xe5>
  8033b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033b7:	31 ff                	xor    %edi,%edi
  8033b9:	e9 40 ff ff ff       	jmp    8032fe <__udivdi3+0x46>
  8033be:	66 90                	xchg   %ax,%ax
  8033c0:	31 c0                	xor    %eax,%eax
  8033c2:	e9 37 ff ff ff       	jmp    8032fe <__udivdi3+0x46>
  8033c7:	90                   	nop

008033c8 <__umoddi3>:
  8033c8:	55                   	push   %ebp
  8033c9:	57                   	push   %edi
  8033ca:	56                   	push   %esi
  8033cb:	53                   	push   %ebx
  8033cc:	83 ec 1c             	sub    $0x1c,%esp
  8033cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033e7:	89 f3                	mov    %esi,%ebx
  8033e9:	89 fa                	mov    %edi,%edx
  8033eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033ef:	89 34 24             	mov    %esi,(%esp)
  8033f2:	85 c0                	test   %eax,%eax
  8033f4:	75 1a                	jne    803410 <__umoddi3+0x48>
  8033f6:	39 f7                	cmp    %esi,%edi
  8033f8:	0f 86 a2 00 00 00    	jbe    8034a0 <__umoddi3+0xd8>
  8033fe:	89 c8                	mov    %ecx,%eax
  803400:	89 f2                	mov    %esi,%edx
  803402:	f7 f7                	div    %edi
  803404:	89 d0                	mov    %edx,%eax
  803406:	31 d2                	xor    %edx,%edx
  803408:	83 c4 1c             	add    $0x1c,%esp
  80340b:	5b                   	pop    %ebx
  80340c:	5e                   	pop    %esi
  80340d:	5f                   	pop    %edi
  80340e:	5d                   	pop    %ebp
  80340f:	c3                   	ret    
  803410:	39 f0                	cmp    %esi,%eax
  803412:	0f 87 ac 00 00 00    	ja     8034c4 <__umoddi3+0xfc>
  803418:	0f bd e8             	bsr    %eax,%ebp
  80341b:	83 f5 1f             	xor    $0x1f,%ebp
  80341e:	0f 84 ac 00 00 00    	je     8034d0 <__umoddi3+0x108>
  803424:	bf 20 00 00 00       	mov    $0x20,%edi
  803429:	29 ef                	sub    %ebp,%edi
  80342b:	89 fe                	mov    %edi,%esi
  80342d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803431:	89 e9                	mov    %ebp,%ecx
  803433:	d3 e0                	shl    %cl,%eax
  803435:	89 d7                	mov    %edx,%edi
  803437:	89 f1                	mov    %esi,%ecx
  803439:	d3 ef                	shr    %cl,%edi
  80343b:	09 c7                	or     %eax,%edi
  80343d:	89 e9                	mov    %ebp,%ecx
  80343f:	d3 e2                	shl    %cl,%edx
  803441:	89 14 24             	mov    %edx,(%esp)
  803444:	89 d8                	mov    %ebx,%eax
  803446:	d3 e0                	shl    %cl,%eax
  803448:	89 c2                	mov    %eax,%edx
  80344a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80344e:	d3 e0                	shl    %cl,%eax
  803450:	89 44 24 04          	mov    %eax,0x4(%esp)
  803454:	8b 44 24 08          	mov    0x8(%esp),%eax
  803458:	89 f1                	mov    %esi,%ecx
  80345a:	d3 e8                	shr    %cl,%eax
  80345c:	09 d0                	or     %edx,%eax
  80345e:	d3 eb                	shr    %cl,%ebx
  803460:	89 da                	mov    %ebx,%edx
  803462:	f7 f7                	div    %edi
  803464:	89 d3                	mov    %edx,%ebx
  803466:	f7 24 24             	mull   (%esp)
  803469:	89 c6                	mov    %eax,%esi
  80346b:	89 d1                	mov    %edx,%ecx
  80346d:	39 d3                	cmp    %edx,%ebx
  80346f:	0f 82 87 00 00 00    	jb     8034fc <__umoddi3+0x134>
  803475:	0f 84 91 00 00 00    	je     80350c <__umoddi3+0x144>
  80347b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80347f:	29 f2                	sub    %esi,%edx
  803481:	19 cb                	sbb    %ecx,%ebx
  803483:	89 d8                	mov    %ebx,%eax
  803485:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803489:	d3 e0                	shl    %cl,%eax
  80348b:	89 e9                	mov    %ebp,%ecx
  80348d:	d3 ea                	shr    %cl,%edx
  80348f:	09 d0                	or     %edx,%eax
  803491:	89 e9                	mov    %ebp,%ecx
  803493:	d3 eb                	shr    %cl,%ebx
  803495:	89 da                	mov    %ebx,%edx
  803497:	83 c4 1c             	add    $0x1c,%esp
  80349a:	5b                   	pop    %ebx
  80349b:	5e                   	pop    %esi
  80349c:	5f                   	pop    %edi
  80349d:	5d                   	pop    %ebp
  80349e:	c3                   	ret    
  80349f:	90                   	nop
  8034a0:	89 fd                	mov    %edi,%ebp
  8034a2:	85 ff                	test   %edi,%edi
  8034a4:	75 0b                	jne    8034b1 <__umoddi3+0xe9>
  8034a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ab:	31 d2                	xor    %edx,%edx
  8034ad:	f7 f7                	div    %edi
  8034af:	89 c5                	mov    %eax,%ebp
  8034b1:	89 f0                	mov    %esi,%eax
  8034b3:	31 d2                	xor    %edx,%edx
  8034b5:	f7 f5                	div    %ebp
  8034b7:	89 c8                	mov    %ecx,%eax
  8034b9:	f7 f5                	div    %ebp
  8034bb:	89 d0                	mov    %edx,%eax
  8034bd:	e9 44 ff ff ff       	jmp    803406 <__umoddi3+0x3e>
  8034c2:	66 90                	xchg   %ax,%ax
  8034c4:	89 c8                	mov    %ecx,%eax
  8034c6:	89 f2                	mov    %esi,%edx
  8034c8:	83 c4 1c             	add    $0x1c,%esp
  8034cb:	5b                   	pop    %ebx
  8034cc:	5e                   	pop    %esi
  8034cd:	5f                   	pop    %edi
  8034ce:	5d                   	pop    %ebp
  8034cf:	c3                   	ret    
  8034d0:	3b 04 24             	cmp    (%esp),%eax
  8034d3:	72 06                	jb     8034db <__umoddi3+0x113>
  8034d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034d9:	77 0f                	ja     8034ea <__umoddi3+0x122>
  8034db:	89 f2                	mov    %esi,%edx
  8034dd:	29 f9                	sub    %edi,%ecx
  8034df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034e3:	89 14 24             	mov    %edx,(%esp)
  8034e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034ee:	8b 14 24             	mov    (%esp),%edx
  8034f1:	83 c4 1c             	add    $0x1c,%esp
  8034f4:	5b                   	pop    %ebx
  8034f5:	5e                   	pop    %esi
  8034f6:	5f                   	pop    %edi
  8034f7:	5d                   	pop    %ebp
  8034f8:	c3                   	ret    
  8034f9:	8d 76 00             	lea    0x0(%esi),%esi
  8034fc:	2b 04 24             	sub    (%esp),%eax
  8034ff:	19 fa                	sbb    %edi,%edx
  803501:	89 d1                	mov    %edx,%ecx
  803503:	89 c6                	mov    %eax,%esi
  803505:	e9 71 ff ff ff       	jmp    80347b <__umoddi3+0xb3>
  80350a:	66 90                	xchg   %ax,%ax
  80350c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803510:	72 ea                	jb     8034fc <__umoddi3+0x134>
  803512:	89 d9                	mov    %ebx,%ecx
  803514:	e9 62 ff ff ff       	jmp    80347b <__umoddi3+0xb3>
