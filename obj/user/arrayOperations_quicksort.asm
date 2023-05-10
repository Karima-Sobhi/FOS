
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 20 03 00 00       	call   800356 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 44 1b 00 00       	call   801b87 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 6e 1b 00 00       	call   801bb9 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80004e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 00 34 80 00       	push   $0x803400
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 1e 16 00 00       	call   80168a <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 04 34 80 00       	push   $0x803404
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 08 16 00 00       	call   80168a <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 0c 34 80 00       	push   $0x80340c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 eb 15 00 00       	call   80168a <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 1a 34 80 00       	push   $0x80341a
  8000b8:	e8 24 15 00 00       	call   8015e1 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		sortedArray[i] = sharedArray[i];
  8000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	01 c2                	add    %eax,%edx
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	01 c8                	add    %ecx,%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	89 02                	mov    %eax,(%edx)
	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	ff 75 dc             	pushl  -0x24(%ebp)
  800107:	e8 23 00 00 00       	call   80012f <QuickSort>
  80010c:	83 c4 10             	add    $0x10,%esp
	cprintf("Quick sort is Finished!!!!\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 29 34 80 00       	push   $0x803429
  800117:	e8 4a 04 00 00       	call   800566 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  80011f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	8d 50 01             	lea    0x1(%eax),%edx
  800127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012a:	89 10                	mov    %edx,(%eax)

}
  80012c:	90                   	nop
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800135:	8b 45 0c             	mov    0xc(%ebp),%eax
  800138:	48                   	dec    %eax
  800139:	50                   	push   %eax
  80013a:	6a 00                	push   $0x0
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	e8 06 00 00 00       	call   80014d <QSort>
  800147:	83 c4 10             	add    $0x10,%esp
}
  80014a:	90                   	nop
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  800153:	8b 45 10             	mov    0x10(%ebp),%eax
  800156:	3b 45 14             	cmp    0x14(%ebp),%eax
  800159:	0f 8d 1b 01 00 00    	jge    80027a <QSort+0x12d>
	int pvtIndex = RAND(startIndex, finalIndex) ;
  80015f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	50                   	push   %eax
  800166:	e8 81 1a 00 00       	call   801bec <sys_get_virtual_time>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	8b 55 14             	mov    0x14(%ebp),%edx
  800174:	2b 55 10             	sub    0x10(%ebp),%edx
  800177:	89 d1                	mov    %edx,%ecx
  800179:	ba 00 00 00 00       	mov    $0x0,%edx
  80017e:	f7 f1                	div    %ecx
  800180:	8b 45 10             	mov    0x10(%ebp),%eax
  800183:	01 d0                	add    %edx,%eax
  800185:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	ff 75 ec             	pushl  -0x14(%ebp)
  80018e:	ff 75 10             	pushl  0x10(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 e4 00 00 00       	call   80027d <Swap>
  800199:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	40                   	inc    %eax
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8001a9:	e9 80 00 00 00       	jmp    80022e <QSort+0xe1>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8001ae:	ff 45 f4             	incl   -0xc(%ebp)
  8001b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b4:	3b 45 14             	cmp    0x14(%ebp),%eax
  8001b7:	7f 2b                	jg     8001e4 <QSort+0x97>
  8001b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	8b 10                	mov    (%eax),%edx
  8001ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	01 c8                	add    %ecx,%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	7d cf                	jge    8001ae <QSort+0x61>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8001df:	eb 03                	jmp    8001e4 <QSort+0x97>
  8001e1:	ff 4d f0             	decl   -0x10(%ebp)
  8001e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001ea:	7e 26                	jle    800212 <QSort+0xc5>
  8001ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f9:	01 d0                	add    %edx,%eax
  8001fb:	8b 10                	mov    (%eax),%edx
  8001fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800200:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800207:	8b 45 08             	mov    0x8(%ebp),%eax
  80020a:	01 c8                	add    %ecx,%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	39 c2                	cmp    %eax,%edx
  800210:	7e cf                	jle    8001e1 <QSort+0x94>

		if (i <= j)
  800212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800215:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800218:	7f 14                	jg     80022e <QSort+0xe1>
		{
			Swap(Elements, i, j);
  80021a:	83 ec 04             	sub    $0x4,%esp
  80021d:	ff 75 f0             	pushl  -0x10(%ebp)
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	ff 75 08             	pushl  0x8(%ebp)
  800226:	e8 52 00 00 00       	call   80027d <Swap>
  80022b:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80022e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800231:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800234:	0f 8e 77 ff ff ff    	jle    8001b1 <QSort+0x64>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	ff 75 f0             	pushl  -0x10(%ebp)
  800240:	ff 75 10             	pushl  0x10(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 32 00 00 00       	call   80027d <Swap>
  80024b:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  80024e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800251:	48                   	dec    %eax
  800252:	50                   	push   %eax
  800253:	ff 75 10             	pushl  0x10(%ebp)
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 ec fe ff ff       	call   80014d <QSort>
  800261:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800264:	ff 75 14             	pushl  0x14(%ebp)
  800267:	ff 75 f4             	pushl  -0xc(%ebp)
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	e8 d8 fe ff ff       	call   80014d <QSort>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	eb 01                	jmp    80027b <QSort+0x12e>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80027a:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a4:	01 c2                	add    %eax,%edx
  8002a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b3:	01 c8                	add    %ecx,%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8002b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	01 c2                	add    %eax,%edx
  8002c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8002cb:	89 02                	mov    %eax,(%edx)
}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8002d6:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8002dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002e4:	eb 42                	jmp    800328 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8002e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e9:	99                   	cltd   
  8002ea:	f7 7d f0             	idivl  -0x10(%ebp)
  8002ed:	89 d0                	mov    %edx,%eax
  8002ef:	85 c0                	test   %eax,%eax
  8002f1:	75 10                	jne    800303 <PrintElements+0x33>
			cprintf("\n");
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	68 45 34 80 00       	push   $0x803445
  8002fb:	e8 66 02 00 00       	call   800566 <cprintf>
  800300:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	50                   	push   %eax
  800318:	68 47 34 80 00       	push   $0x803447
  80031d:	e8 44 02 00 00       	call   800566 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800325:	ff 45 f4             	incl   -0xc(%ebp)
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	48                   	dec    %eax
  80032c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80032f:	7f b5                	jg     8002e6 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	50                   	push   %eax
  800346:	68 4c 34 80 00       	push   $0x80344c
  80034b:	e8 16 02 00 00       	call   800566 <cprintf>
  800350:	83 c4 10             	add    $0x10,%esp

}
  800353:	90                   	nop
  800354:	c9                   	leave  
  800355:	c3                   	ret    

00800356 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80035c:	e8 3f 18 00 00       	call   801ba0 <sys_getenvindex>
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800367:	89 d0                	mov    %edx,%eax
  800369:	c1 e0 03             	shl    $0x3,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	01 c0                	add    %eax,%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	01 d0                	add    %edx,%eax
  80037b:	c1 e0 04             	shl    $0x4,%eax
  80037e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800383:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800388:	a1 20 40 80 00       	mov    0x804020,%eax
  80038d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800393:	84 c0                	test   %al,%al
  800395:	74 0f                	je     8003a6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003aa:	7e 0a                	jle    8003b6 <libmain+0x60>
		binaryname = argv[0];
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	ff 75 0c             	pushl  0xc(%ebp)
  8003bc:	ff 75 08             	pushl  0x8(%ebp)
  8003bf:	e8 74 fc ff ff       	call   800038 <_main>
  8003c4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003c7:	e8 e1 15 00 00       	call   8019ad <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 68 34 80 00       	push   $0x803468
  8003d4:	e8 8d 01 00 00       	call   800566 <cprintf>
  8003d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f2:	83 ec 04             	sub    $0x4,%esp
  8003f5:	52                   	push   %edx
  8003f6:	50                   	push   %eax
  8003f7:	68 90 34 80 00       	push   $0x803490
  8003fc:	e8 65 01 00 00       	call   800566 <cprintf>
  800401:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800404:	a1 20 40 80 00       	mov    0x804020,%eax
  800409:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80040f:	a1 20 40 80 00       	mov    0x804020,%eax
  800414:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80041a:	a1 20 40 80 00       	mov    0x804020,%eax
  80041f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800425:	51                   	push   %ecx
  800426:	52                   	push   %edx
  800427:	50                   	push   %eax
  800428:	68 b8 34 80 00       	push   $0x8034b8
  80042d:	e8 34 01 00 00       	call   800566 <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800435:	a1 20 40 80 00       	mov    0x804020,%eax
  80043a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	50                   	push   %eax
  800444:	68 10 35 80 00       	push   $0x803510
  800449:	e8 18 01 00 00       	call   800566 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 68 34 80 00       	push   $0x803468
  800459:	e8 08 01 00 00       	call   800566 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800461:	e8 61 15 00 00       	call   8019c7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800466:	e8 19 00 00 00       	call   800484 <exit>
}
  80046b:	90                   	nop
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	6a 00                	push   $0x0
  800479:	e8 ee 16 00 00       	call   801b6c <sys_destroy_env>
  80047e:	83 c4 10             	add    $0x10,%esp
}
  800481:	90                   	nop
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <exit>:

void
exit(void)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048a:	e8 43 17 00 00       	call   801bd2 <sys_exit_env>
}
  80048f:	90                   	nop
  800490:	c9                   	leave  
  800491:	c3                   	ret    

00800492 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800492:	55                   	push   %ebp
  800493:	89 e5                	mov    %esp,%ebp
  800495:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a3:	89 0a                	mov    %ecx,(%edx)
  8004a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a8:	88 d1                	mov    %dl,%cl
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bb:	75 2c                	jne    8004e9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004bd:	a0 24 40 80 00       	mov    0x804024,%al
  8004c2:	0f b6 c0             	movzbl %al,%eax
  8004c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c8:	8b 12                	mov    (%edx),%edx
  8004ca:	89 d1                	mov    %edx,%ecx
  8004cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cf:	83 c2 08             	add    $0x8,%edx
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	50                   	push   %eax
  8004d6:	51                   	push   %ecx
  8004d7:	52                   	push   %edx
  8004d8:	e8 22 13 00 00       	call   8017ff <sys_cputs>
  8004dd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	8b 40 04             	mov    0x4(%eax),%eax
  8004ef:	8d 50 01             	lea    0x1(%eax),%edx
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004f8:	90                   	nop
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800504:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050b:	00 00 00 
	b.cnt = 0;
  80050e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800515:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800524:	50                   	push   %eax
  800525:	68 92 04 80 00       	push   $0x800492
  80052a:	e8 11 02 00 00       	call   800740 <vprintfmt>
  80052f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800532:	a0 24 40 80 00       	mov    0x804024,%al
  800537:	0f b6 c0             	movzbl %al,%eax
  80053a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800540:	83 ec 04             	sub    $0x4,%esp
  800543:	50                   	push   %eax
  800544:	52                   	push   %edx
  800545:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054b:	83 c0 08             	add    $0x8,%eax
  80054e:	50                   	push   %eax
  80054f:	e8 ab 12 00 00       	call   8017ff <sys_cputs>
  800554:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800557:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80055e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <cprintf>:

int cprintf(const char *fmt, ...) {
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800573:	8d 45 0c             	lea    0xc(%ebp),%eax
  800576:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	ff 75 f4             	pushl  -0xc(%ebp)
  800582:	50                   	push   %eax
  800583:	e8 73 ff ff ff       	call   8004fb <vcprintf>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800599:	e8 0f 14 00 00       	call   8019ad <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80059e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ad:	50                   	push   %eax
  8005ae:	e8 48 ff ff ff       	call   8004fb <vcprintf>
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005b9:	e8 09 14 00 00       	call   8019c7 <sys_enable_interrupt>
	return cnt;
  8005be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	53                   	push   %ebx
  8005c7:	83 ec 14             	sub    $0x14,%esp
  8005ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e1:	77 55                	ja     800638 <printnum+0x75>
  8005e3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e6:	72 05                	jb     8005ed <printnum+0x2a>
  8005e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005eb:	77 4b                	ja     800638 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ed:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fb:	52                   	push   %edx
  8005fc:	50                   	push   %eax
  8005fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800600:	ff 75 f0             	pushl  -0x10(%ebp)
  800603:	e8 94 2b 00 00       	call   80319c <__udivdi3>
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	83 ec 04             	sub    $0x4,%esp
  80060e:	ff 75 20             	pushl  0x20(%ebp)
  800611:	53                   	push   %ebx
  800612:	ff 75 18             	pushl  0x18(%ebp)
  800615:	52                   	push   %edx
  800616:	50                   	push   %eax
  800617:	ff 75 0c             	pushl  0xc(%ebp)
  80061a:	ff 75 08             	pushl  0x8(%ebp)
  80061d:	e8 a1 ff ff ff       	call   8005c3 <printnum>
  800622:	83 c4 20             	add    $0x20,%esp
  800625:	eb 1a                	jmp    800641 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	ff 75 0c             	pushl  0xc(%ebp)
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	ff d0                	call   *%eax
  800635:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800638:	ff 4d 1c             	decl   0x1c(%ebp)
  80063b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80063f:	7f e6                	jg     800627 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800641:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800644:	bb 00 00 00 00       	mov    $0x0,%ebx
  800649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80064f:	53                   	push   %ebx
  800650:	51                   	push   %ecx
  800651:	52                   	push   %edx
  800652:	50                   	push   %eax
  800653:	e8 54 2c 00 00       	call   8032ac <__umoddi3>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	05 54 37 80 00       	add    $0x803754,%eax
  800660:	8a 00                	mov    (%eax),%al
  800662:	0f be c0             	movsbl %al,%eax
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	ff 75 0c             	pushl  0xc(%ebp)
  80066b:	50                   	push   %eax
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	ff d0                	call   *%eax
  800671:	83 c4 10             	add    $0x10,%esp
}
  800674:	90                   	nop
  800675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800681:	7e 1c                	jle    80069f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 08             	lea    0x8(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 08             	sub    $0x8,%eax
  800698:	8b 50 04             	mov    0x4(%eax),%edx
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	eb 40                	jmp    8006df <getuint+0x65>
	else if (lflag)
  80069f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a3:	74 1e                	je     8006c3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	8d 50 04             	lea    0x4(%eax),%edx
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	89 10                	mov    %edx,(%eax)
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	83 e8 04             	sub    $0x4,%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c1:	eb 1c                	jmp    8006df <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	8d 50 04             	lea    0x4(%eax),%edx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	83 e8 04             	sub    $0x4,%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006df:	5d                   	pop    %ebp
  8006e0:	c3                   	ret    

008006e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e8:	7e 1c                	jle    800706 <getint+0x25>
		return va_arg(*ap, long long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 08             	lea    0x8(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 08             	sub    $0x8,%eax
  8006ff:	8b 50 04             	mov    0x4(%eax),%edx
  800702:	8b 00                	mov    (%eax),%eax
  800704:	eb 38                	jmp    80073e <getint+0x5d>
	else if (lflag)
  800706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070a:	74 1a                	je     800726 <getint+0x45>
		return va_arg(*ap, long);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	89 10                	mov    %edx,(%eax)
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	83 e8 04             	sub    $0x4,%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	99                   	cltd   
  800724:	eb 18                	jmp    80073e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	99                   	cltd   
}
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	56                   	push   %esi
  800744:	53                   	push   %ebx
  800745:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800748:	eb 17                	jmp    800761 <vprintfmt+0x21>
			if (ch == '\0')
  80074a:	85 db                	test   %ebx,%ebx
  80074c:	0f 84 af 03 00 00    	je     800b01 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	53                   	push   %ebx
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	ff d0                	call   *%eax
  80075e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	83 fb 25             	cmp    $0x25,%ebx
  800772:	75 d6                	jne    80074a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800774:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800778:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80077f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800786:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800794:	8b 45 10             	mov    0x10(%ebp),%eax
  800797:	8d 50 01             	lea    0x1(%eax),%edx
  80079a:	89 55 10             	mov    %edx,0x10(%ebp)
  80079d:	8a 00                	mov    (%eax),%al
  80079f:	0f b6 d8             	movzbl %al,%ebx
  8007a2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a5:	83 f8 55             	cmp    $0x55,%eax
  8007a8:	0f 87 2b 03 00 00    	ja     800ad9 <vprintfmt+0x399>
  8007ae:	8b 04 85 78 37 80 00 	mov    0x803778(,%eax,4),%eax
  8007b5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bb:	eb d7                	jmp    800794 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c1:	eb d1                	jmp    800794 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cd:	89 d0                	mov    %edx,%eax
  8007cf:	c1 e0 02             	shl    $0x2,%eax
  8007d2:	01 d0                	add    %edx,%eax
  8007d4:	01 c0                	add    %eax,%eax
  8007d6:	01 d8                	add    %ebx,%eax
  8007d8:	83 e8 30             	sub    $0x30,%eax
  8007db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	8a 00                	mov    (%eax),%al
  8007e3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e9:	7e 3e                	jle    800829 <vprintfmt+0xe9>
  8007eb:	83 fb 39             	cmp    $0x39,%ebx
  8007ee:	7f 39                	jg     800829 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f3:	eb d5                	jmp    8007ca <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 c0 04             	add    $0x4,%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800809:	eb 1f                	jmp    80082a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080f:	79 83                	jns    800794 <vprintfmt+0x54>
				width = 0;
  800811:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800818:	e9 77 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800824:	e9 6b ff ff ff       	jmp    800794 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800829:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	0f 89 60 ff ff ff    	jns    800794 <vprintfmt+0x54>
				width = precision, precision = -1;
  800834:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800841:	e9 4e ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800846:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800849:	e9 46 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	83 c0 04             	add    $0x4,%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	83 e8 04             	sub    $0x4,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	50                   	push   %eax
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			break;
  80086e:	e9 89 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 c0 04             	add    $0x4,%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	83 e8 04             	sub    $0x4,%eax
  800882:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800884:	85 db                	test   %ebx,%ebx
  800886:	79 02                	jns    80088a <vprintfmt+0x14a>
				err = -err;
  800888:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088a:	83 fb 64             	cmp    $0x64,%ebx
  80088d:	7f 0b                	jg     80089a <vprintfmt+0x15a>
  80088f:	8b 34 9d c0 35 80 00 	mov    0x8035c0(,%ebx,4),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 19                	jne    8008b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089a:	53                   	push   %ebx
  80089b:	68 65 37 80 00       	push   $0x803765
  8008a0:	ff 75 0c             	pushl  0xc(%ebp)
  8008a3:	ff 75 08             	pushl  0x8(%ebp)
  8008a6:	e8 5e 02 00 00       	call   800b09 <printfmt>
  8008ab:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ae:	e9 49 02 00 00       	jmp    800afc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b3:	56                   	push   %esi
  8008b4:	68 6e 37 80 00       	push   $0x80376e
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	ff 75 08             	pushl  0x8(%ebp)
  8008bf:	e8 45 02 00 00       	call   800b09 <printfmt>
  8008c4:	83 c4 10             	add    $0x10,%esp
			break;
  8008c7:	e9 30 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	83 c0 04             	add    $0x4,%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	83 e8 04             	sub    $0x4,%eax
  8008db:	8b 30                	mov    (%eax),%esi
  8008dd:	85 f6                	test   %esi,%esi
  8008df:	75 05                	jne    8008e6 <vprintfmt+0x1a6>
				p = "(null)";
  8008e1:	be 71 37 80 00       	mov    $0x803771,%esi
			if (width > 0 && padc != '-')
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	7e 6d                	jle    800959 <vprintfmt+0x219>
  8008ec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f0:	74 67                	je     800959 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	50                   	push   %eax
  8008f9:	56                   	push   %esi
  8008fa:	e8 0c 03 00 00       	call   800c0b <strnlen>
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800905:	eb 16                	jmp    80091d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800907:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	50                   	push   %eax
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	ff d0                	call   *%eax
  800917:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091a:	ff 4d e4             	decl   -0x1c(%ebp)
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7f e4                	jg     800907 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	eb 34                	jmp    800959 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800925:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800929:	74 1c                	je     800947 <vprintfmt+0x207>
  80092b:	83 fb 1f             	cmp    $0x1f,%ebx
  80092e:	7e 05                	jle    800935 <vprintfmt+0x1f5>
  800930:	83 fb 7e             	cmp    $0x7e,%ebx
  800933:	7e 12                	jle    800947 <vprintfmt+0x207>
					putch('?', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 3f                	push   $0x3f
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
  800945:	eb 0f                	jmp    800956 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800956:	ff 4d e4             	decl   -0x1c(%ebp)
  800959:	89 f0                	mov    %esi,%eax
  80095b:	8d 70 01             	lea    0x1(%eax),%esi
  80095e:	8a 00                	mov    (%eax),%al
  800960:	0f be d8             	movsbl %al,%ebx
  800963:	85 db                	test   %ebx,%ebx
  800965:	74 24                	je     80098b <vprintfmt+0x24b>
  800967:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096b:	78 b8                	js     800925 <vprintfmt+0x1e5>
  80096d:	ff 4d e0             	decl   -0x20(%ebp)
  800970:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800974:	79 af                	jns    800925 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800976:	eb 13                	jmp    80098b <vprintfmt+0x24b>
				putch(' ', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	6a 20                	push   $0x20
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	ff d0                	call   *%eax
  800985:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800988:	ff 4d e4             	decl   -0x1c(%ebp)
  80098b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098f:	7f e7                	jg     800978 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800991:	e9 66 01 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 e8             	pushl  -0x18(%ebp)
  80099c:	8d 45 14             	lea    0x14(%ebp),%eax
  80099f:	50                   	push   %eax
  8009a0:	e8 3c fd ff ff       	call   8006e1 <getint>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b4:	85 d2                	test   %edx,%edx
  8009b6:	79 23                	jns    8009db <vprintfmt+0x29b>
				putch('-', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 2d                	push   $0x2d
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ce:	f7 d8                	neg    %eax
  8009d0:	83 d2 00             	adc    $0x0,%edx
  8009d3:	f7 da                	neg    %edx
  8009d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e2:	e9 bc 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f0:	50                   	push   %eax
  8009f1:	e8 84 fc ff ff       	call   80067a <getuint>
  8009f6:	83 c4 10             	add    $0x10,%esp
  8009f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a06:	e9 98 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 58                	push   $0x58
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 58                	push   $0x58
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	6a 58                	push   $0x58
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	ff d0                	call   *%eax
  800a38:	83 c4 10             	add    $0x10,%esp
			break;
  800a3b:	e9 bc 00 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 0c             	pushl  0xc(%ebp)
  800a46:	6a 30                	push   $0x30
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	ff d0                	call   *%eax
  800a4d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	6a 78                	push   $0x78
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	ff d0                	call   *%eax
  800a5d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 c0 04             	add    $0x4,%eax
  800a66:	89 45 14             	mov    %eax,0x14(%ebp)
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	83 e8 04             	sub    $0x4,%eax
  800a6f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a82:	eb 1f                	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8d:	50                   	push   %eax
  800a8e:	e8 e7 fb ff ff       	call   80067a <getuint>
  800a93:	83 c4 10             	add    $0x10,%esp
  800a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aaa:	83 ec 04             	sub    $0x4,%esp
  800aad:	52                   	push   %edx
  800aae:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab1:	50                   	push   %eax
  800ab2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	ff 75 08             	pushl  0x8(%ebp)
  800abe:	e8 00 fb ff ff       	call   8005c3 <printnum>
  800ac3:	83 c4 20             	add    $0x20,%esp
			break;
  800ac6:	eb 34                	jmp    800afc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	53                   	push   %ebx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			break;
  800ad7:	eb 23                	jmp    800afc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	6a 25                	push   $0x25
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae9:	ff 4d 10             	decl   0x10(%ebp)
  800aec:	eb 03                	jmp    800af1 <vprintfmt+0x3b1>
  800aee:	ff 4d 10             	decl   0x10(%ebp)
  800af1:	8b 45 10             	mov    0x10(%ebp),%eax
  800af4:	48                   	dec    %eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	3c 25                	cmp    $0x25,%al
  800af9:	75 f3                	jne    800aee <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800afb:	90                   	nop
		}
	}
  800afc:	e9 47 fc ff ff       	jmp    800748 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b01:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b0f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b12:	83 c0 04             	add    $0x4,%eax
  800b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b18:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1e:	50                   	push   %eax
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 16 fc ff ff       	call   800740 <vprintfmt>
  800b2a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b2d:	90                   	nop
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8b 40 08             	mov    0x8(%eax),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8b 10                	mov    (%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 40 04             	mov    0x4(%eax),%eax
  800b4d:	39 c2                	cmp    %eax,%edx
  800b4f:	73 12                	jae    800b63 <sprintputch+0x33>
		*b->buf++ = ch;
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 48 01             	lea    0x1(%eax),%ecx
  800b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5c:	89 0a                	mov    %ecx,(%edx)
  800b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b61:	88 10                	mov    %dl,(%eax)
}
  800b63:	90                   	nop
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	01 d0                	add    %edx,%eax
  800b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8b:	74 06                	je     800b93 <vsnprintf+0x2d>
  800b8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b91:	7f 07                	jg     800b9a <vsnprintf+0x34>
		return -E_INVAL;
  800b93:	b8 03 00 00 00       	mov    $0x3,%eax
  800b98:	eb 20                	jmp    800bba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9a:	ff 75 14             	pushl  0x14(%ebp)
  800b9d:	ff 75 10             	pushl  0x10(%ebp)
  800ba0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba3:	50                   	push   %eax
  800ba4:	68 30 0b 80 00       	push   $0x800b30
  800ba9:	e8 92 fb ff ff       	call   800740 <vprintfmt>
  800bae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc2:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc5:	83 c0 04             	add    $0x4,%eax
  800bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	ff 75 08             	pushl  0x8(%ebp)
  800bd8:	e8 89 ff ff ff       	call   800b66 <vsnprintf>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf5:	eb 06                	jmp    800bfd <strlen+0x15>
		n++;
  800bf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfa:	ff 45 08             	incl   0x8(%ebp)
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	84 c0                	test   %al,%al
  800c04:	75 f1                	jne    800bf7 <strlen+0xf>
		n++;
	return n;
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c18:	eb 09                	jmp    800c23 <strnlen+0x18>
		n++;
  800c1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1d:	ff 45 08             	incl   0x8(%ebp)
  800c20:	ff 4d 0c             	decl   0xc(%ebp)
  800c23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c27:	74 09                	je     800c32 <strnlen+0x27>
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	84 c0                	test   %al,%al
  800c30:	75 e8                	jne    800c1a <strnlen+0xf>
		n++;
	return n;
  800c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c43:	90                   	nop
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8d 50 01             	lea    0x1(%eax),%edx
  800c4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	75 e4                	jne    800c44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 1f                	jmp    800c99 <strncpy+0x34>
		*dst++ = *src;
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8d 50 01             	lea    0x1(%eax),%edx
  800c80:	89 55 08             	mov    %edx,0x8(%ebp)
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	8a 12                	mov    (%edx),%dl
  800c88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	84 c0                	test   %al,%al
  800c91:	74 03                	je     800c96 <strncpy+0x31>
			src++;
  800c93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c96:	ff 45 fc             	incl   -0x4(%ebp)
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c9f:	72 d9                	jb     800c7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca4:	c9                   	leave  
  800ca5:	c3                   	ret    

00800ca6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb6:	74 30                	je     800ce8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cb8:	eb 16                	jmp    800cd0 <strlcpy+0x2a>
			*dst++ = *src++;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8d 50 01             	lea    0x1(%eax),%edx
  800cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccc:	8a 12                	mov    (%edx),%dl
  800cce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd7:	74 09                	je     800ce2 <strlcpy+0x3c>
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	75 d8                	jne    800cba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cee:	29 c2                	sub    %eax,%edx
  800cf0:	89 d0                	mov    %edx,%eax
}
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cf7:	eb 06                	jmp    800cff <strcmp+0xb>
		p++, q++;
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strcmp+0x22>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 e3                	je     800cf9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	0f b6 d0             	movzbl %al,%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	0f b6 c0             	movzbl %al,%eax
  800d26:	29 c2                	sub    %eax,%edx
  800d28:	89 d0                	mov    %edx,%eax
}
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d2f:	eb 09                	jmp    800d3a <strncmp+0xe>
		n--, p++, q++;
  800d31:	ff 4d 10             	decl   0x10(%ebp)
  800d34:	ff 45 08             	incl   0x8(%ebp)
  800d37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	74 17                	je     800d57 <strncmp+0x2b>
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	74 0e                	je     800d57 <strncmp+0x2b>
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 10                	mov    (%eax),%dl
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	38 c2                	cmp    %al,%dl
  800d55:	74 da                	je     800d31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5b:	75 07                	jne    800d64 <strncmp+0x38>
		return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d62:	eb 14                	jmp    800d78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	0f b6 d0             	movzbl %al,%edx
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	0f b6 c0             	movzbl %al,%eax
  800d74:	29 c2                	sub    %eax,%edx
  800d76:	89 d0                	mov    %edx,%eax
}
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 12                	jmp    800d9a <strchr+0x20>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	75 05                	jne    800d97 <strchr+0x1d>
			return (char *) s;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	eb 11                	jmp    800da8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	84 c0                	test   %al,%al
  800da1:	75 e5                	jne    800d88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 04             	sub    $0x4,%esp
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db6:	eb 0d                	jmp    800dc5 <strfind+0x1b>
		if (*s == c)
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc0:	74 0e                	je     800dd0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc2:	ff 45 08             	incl   0x8(%ebp)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	84 c0                	test   %al,%al
  800dcc:	75 ea                	jne    800db8 <strfind+0xe>
  800dce:	eb 01                	jmp    800dd1 <strfind+0x27>
		if (*s == c)
			break;
  800dd0:	90                   	nop
	return (char *) s;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de2:	8b 45 10             	mov    0x10(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800de8:	eb 0e                	jmp    800df8 <memset+0x22>
		*p++ = c;
  800dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800df8:	ff 4d f8             	decl   -0x8(%ebp)
  800dfb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dff:	79 e9                	jns    800dea <memset+0x14>
		*p++ = c;

	return v;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e18:	eb 16                	jmp    800e30 <memcpy+0x2a>
		*d++ = *s++;
  800e1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1d:	8d 50 01             	lea    0x1(%eax),%edx
  800e20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e29:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2c:	8a 12                	mov    (%edx),%dl
  800e2e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 dd                	jne    800e1a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5a:	73 50                	jae    800eac <memmove+0x6a>
  800e5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	01 d0                	add    %edx,%eax
  800e64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e67:	76 43                	jbe    800eac <memmove+0x6a>
		s += n;
  800e69:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e75:	eb 10                	jmp    800e87 <memmove+0x45>
			*--d = *--s;
  800e77:	ff 4d f8             	decl   -0x8(%ebp)
  800e7a:	ff 4d fc             	decl   -0x4(%ebp)
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e80:	8a 10                	mov    (%eax),%dl
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e90:	85 c0                	test   %eax,%eax
  800e92:	75 e3                	jne    800e77 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e94:	eb 23                	jmp    800eb9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8d 50 01             	lea    0x1(%eax),%edx
  800e9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea8:	8a 12                	mov    (%edx),%dl
  800eaa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eac:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	75 dd                	jne    800e96 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed0:	eb 2a                	jmp    800efc <memcmp+0x3e>
		if (*s1 != *s2)
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	8a 10                	mov    (%eax),%dl
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	38 c2                	cmp    %al,%dl
  800ede:	74 16                	je     800ef6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	0f b6 d0             	movzbl %al,%edx
  800ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	29 c2                	sub    %eax,%edx
  800ef2:	89 d0                	mov    %edx,%eax
  800ef4:	eb 18                	jmp    800f0e <memcmp+0x50>
		s1++, s2++;
  800ef6:	ff 45 fc             	incl   -0x4(%ebp)
  800ef9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 c9                	jne    800ed2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	01 d0                	add    %edx,%eax
  800f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f21:	eb 15                	jmp    800f38 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	0f b6 d0             	movzbl %al,%edx
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	0f b6 c0             	movzbl %al,%eax
  800f31:	39 c2                	cmp    %eax,%edx
  800f33:	74 0d                	je     800f42 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f3e:	72 e3                	jb     800f23 <memfind+0x13>
  800f40:	eb 01                	jmp    800f43 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f42:	90                   	nop
	return (void *) s;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5c:	eb 03                	jmp    800f61 <strtol+0x19>
		s++;
  800f5e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	3c 20                	cmp    $0x20,%al
  800f68:	74 f4                	je     800f5e <strtol+0x16>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	3c 09                	cmp    $0x9,%al
  800f71:	74 eb                	je     800f5e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	3c 2b                	cmp    $0x2b,%al
  800f7a:	75 05                	jne    800f81 <strtol+0x39>
		s++;
  800f7c:	ff 45 08             	incl   0x8(%ebp)
  800f7f:	eb 13                	jmp    800f94 <strtol+0x4c>
	else if (*s == '-')
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	3c 2d                	cmp    $0x2d,%al
  800f88:	75 0a                	jne    800f94 <strtol+0x4c>
		s++, neg = 1;
  800f8a:	ff 45 08             	incl   0x8(%ebp)
  800f8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	74 06                	je     800fa0 <strtol+0x58>
  800f9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f9e:	75 20                	jne    800fc0 <strtol+0x78>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 30                	cmp    $0x30,%al
  800fa7:	75 17                	jne    800fc0 <strtol+0x78>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	40                   	inc    %eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 78                	cmp    $0x78,%al
  800fb1:	75 0d                	jne    800fc0 <strtol+0x78>
		s += 2, base = 16;
  800fb3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fbe:	eb 28                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc4:	75 15                	jne    800fdb <strtol+0x93>
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 30                	cmp    $0x30,%al
  800fcd:	75 0c                	jne    800fdb <strtol+0x93>
		s++, base = 8;
  800fcf:	ff 45 08             	incl   0x8(%ebp)
  800fd2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fd9:	eb 0d                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0)
  800fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdf:	75 07                	jne    800fe8 <strtol+0xa0>
		base = 10;
  800fe1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 2f                	cmp    $0x2f,%al
  800fef:	7e 19                	jle    80100a <strtol+0xc2>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 39                	cmp    $0x39,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xc2>
			dig = *s - '0';
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 30             	sub    $0x30,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 42                	jmp    80104c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 60                	cmp    $0x60,%al
  801011:	7e 19                	jle    80102c <strtol+0xe4>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 7a                	cmp    $0x7a,%al
  80101a:	7f 10                	jg     80102c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 57             	sub    $0x57,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102a:	eb 20                	jmp    80104c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3c 40                	cmp    $0x40,%al
  801033:	7e 39                	jle    80106e <strtol+0x126>
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	3c 5a                	cmp    $0x5a,%al
  80103c:	7f 30                	jg     80106e <strtol+0x126>
			dig = *s - 'A' + 10;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f be c0             	movsbl %al,%eax
  801046:	83 e8 37             	sub    $0x37,%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80104c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80104f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801052:	7d 19                	jge    80106d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801054:	ff 45 08             	incl   0x8(%ebp)
  801057:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80105e:	89 c2                	mov    %eax,%edx
  801060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801063:	01 d0                	add    %edx,%eax
  801065:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801068:	e9 7b ff ff ff       	jmp    800fe8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80106d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80106e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801072:	74 08                	je     80107c <strtol+0x134>
		*endptr = (char *) s;
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80107c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801080:	74 07                	je     801089 <strtol+0x141>
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	f7 d8                	neg    %eax
  801087:	eb 03                	jmp    80108c <strtol+0x144>
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <ltostr>:

void
ltostr(long value, char *str)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801094:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a6:	79 13                	jns    8010bb <ltostr+0x2d>
	{
		neg = 1;
  8010a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010b8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c3:	99                   	cltd   
  8010c4:	f7 f9                	idiv   %ecx
  8010c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cc:	8d 50 01             	lea    0x1(%eax),%edx
  8010cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010dc:	83 c2 30             	add    $0x30,%edx
  8010df:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e9:	f7 e9                	imul   %ecx
  8010eb:	c1 fa 02             	sar    $0x2,%edx
  8010ee:	89 c8                	mov    %ecx,%eax
  8010f0:	c1 f8 1f             	sar    $0x1f,%eax
  8010f3:	29 c2                	sub    %eax,%edx
  8010f5:	89 d0                	mov    %edx,%eax
  8010f7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801102:	f7 e9                	imul   %ecx
  801104:	c1 fa 02             	sar    $0x2,%edx
  801107:	89 c8                	mov    %ecx,%eax
  801109:	c1 f8 1f             	sar    $0x1f,%eax
  80110c:	29 c2                	sub    %eax,%edx
  80110e:	89 d0                	mov    %edx,%eax
  801110:	c1 e0 02             	shl    $0x2,%eax
  801113:	01 d0                	add    %edx,%eax
  801115:	01 c0                	add    %eax,%eax
  801117:	29 c1                	sub    %eax,%ecx
  801119:	89 ca                	mov    %ecx,%edx
  80111b:	85 d2                	test   %edx,%edx
  80111d:	75 9c                	jne    8010bb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80111f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	48                   	dec    %eax
  80112a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80112d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801131:	74 3d                	je     801170 <ltostr+0xe2>
		start = 1 ;
  801133:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113a:	eb 34                	jmp    801170 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80113c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 d0                	add    %edx,%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	01 c2                	add    %eax,%edx
  801151:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	01 c8                	add    %ecx,%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80115d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	01 c2                	add    %eax,%edx
  801165:	8a 45 eb             	mov    -0x15(%ebp),%al
  801168:	88 02                	mov    %al,(%edx)
		start++ ;
  80116a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80116d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801173:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801176:	7c c4                	jl     80113c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801178:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801183:	90                   	nop
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80118c:	ff 75 08             	pushl  0x8(%ebp)
  80118f:	e8 54 fa ff ff       	call   800be8 <strlen>
  801194:	83 c4 04             	add    $0x4,%esp
  801197:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	e8 46 fa ff ff       	call   800be8 <strlen>
  8011a2:	83 c4 04             	add    $0x4,%esp
  8011a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b6:	eb 17                	jmp    8011cf <strcconcat+0x49>
		final[s] = str1[s] ;
  8011b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011be:	01 c2                	add    %eax,%edx
  8011c0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	01 c8                	add    %ecx,%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011cc:	ff 45 fc             	incl   -0x4(%ebp)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d5:	7c e1                	jl     8011b8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e5:	eb 1f                	jmp    801206 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ea:	8d 50 01             	lea    0x1(%eax),%edx
  8011ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801203:	ff 45 f8             	incl   -0x8(%ebp)
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120c:	7c d9                	jl     8011e7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80120e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 d0                	add    %edx,%eax
  801216:	c6 00 00             	movb   $0x0,(%eax)
}
  801219:	90                   	nop
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80121f:	8b 45 14             	mov    0x14(%ebp),%eax
  801222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801228:	8b 45 14             	mov    0x14(%ebp),%eax
  80122b:	8b 00                	mov    (%eax),%eax
  80122d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801234:	8b 45 10             	mov    0x10(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123f:	eb 0c                	jmp    80124d <strsplit+0x31>
			*string++ = 0;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8d 50 01             	lea    0x1(%eax),%edx
  801247:	89 55 08             	mov    %edx,0x8(%ebp)
  80124a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	84 c0                	test   %al,%al
  801254:	74 18                	je     80126e <strsplit+0x52>
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	0f be c0             	movsbl %al,%eax
  80125e:	50                   	push   %eax
  80125f:	ff 75 0c             	pushl  0xc(%ebp)
  801262:	e8 13 fb ff ff       	call   800d7a <strchr>
  801267:	83 c4 08             	add    $0x8,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	75 d3                	jne    801241 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	84 c0                	test   %al,%al
  801275:	74 5a                	je     8012d1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	83 f8 0f             	cmp    $0xf,%eax
  80127f:	75 07                	jne    801288 <strsplit+0x6c>
		{
			return 0;
  801281:	b8 00 00 00 00       	mov    $0x0,%eax
  801286:	eb 66                	jmp    8012ee <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801288:	8b 45 14             	mov    0x14(%ebp),%eax
  80128b:	8b 00                	mov    (%eax),%eax
  80128d:	8d 48 01             	lea    0x1(%eax),%ecx
  801290:	8b 55 14             	mov    0x14(%ebp),%edx
  801293:	89 0a                	mov    %ecx,(%edx)
  801295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	01 c2                	add    %eax,%edx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a6:	eb 03                	jmp    8012ab <strsplit+0x8f>
			string++;
  8012a8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	84 c0                	test   %al,%al
  8012b2:	74 8b                	je     80123f <strsplit+0x23>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	50                   	push   %eax
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	e8 b5 fa ff ff       	call   800d7a <strchr>
  8012c5:	83 c4 08             	add    $0x8,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 dc                	je     8012a8 <strsplit+0x8c>
			string++;
	}
  8012cc:	e9 6e ff ff ff       	jmp    80123f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d5:	8b 00                	mov    (%eax),%eax
  8012d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 d0                	add    %edx,%eax
  8012e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012f6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	74 1f                	je     80131e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012ff:	e8 1d 00 00 00       	call   801321 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	68 d0 38 80 00       	push   $0x8038d0
  80130c:	e8 55 f2 ff ff       	call   800566 <cprintf>
  801311:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801314:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80131b:	00 00 00 
	}
}
  80131e:	90                   	nop
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801327:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80132e:	00 00 00 
  801331:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801338:	00 00 00 
  80133b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801342:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801345:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80134c:	00 00 00 
  80134f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801356:	00 00 00 
  801359:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801360:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801363:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80136a:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80136d:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801377:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80137c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801381:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801386:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80138d:	a1 20 41 80 00       	mov    0x804120,%eax
  801392:	c1 e0 04             	shl    $0x4,%eax
  801395:	89 c2                	mov    %eax,%edx
  801397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139a:	01 d0                	add    %edx,%eax
  80139c:	48                   	dec    %eax
  80139d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a8:	f7 75 f0             	divl   -0x10(%ebp)
  8013ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ae:	29 d0                	sub    %edx,%eax
  8013b0:	89 c2                	mov    %eax,%edx
  8013b2:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8013b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013c6:	83 ec 04             	sub    $0x4,%esp
  8013c9:	6a 06                	push   $0x6
  8013cb:	52                   	push   %edx
  8013cc:	50                   	push   %eax
  8013cd:	e8 71 05 00 00       	call   801943 <sys_allocate_chunk>
  8013d2:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013d5:	a1 20 41 80 00       	mov    0x804120,%eax
  8013da:	83 ec 0c             	sub    $0xc,%esp
  8013dd:	50                   	push   %eax
  8013de:	e8 e6 0b 00 00       	call   801fc9 <initialize_MemBlocksList>
  8013e3:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8013e6:	a1 48 41 80 00       	mov    0x804148,%eax
  8013eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8013ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013f2:	75 14                	jne    801408 <initialize_dyn_block_system+0xe7>
  8013f4:	83 ec 04             	sub    $0x4,%esp
  8013f7:	68 f5 38 80 00       	push   $0x8038f5
  8013fc:	6a 2b                	push   $0x2b
  8013fe:	68 13 39 80 00       	push   $0x803913
  801403:	e8 b2 1b 00 00       	call   802fba <_panic>
  801408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80140b:	8b 00                	mov    (%eax),%eax
  80140d:	85 c0                	test   %eax,%eax
  80140f:	74 10                	je     801421 <initialize_dyn_block_system+0x100>
  801411:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801414:	8b 00                	mov    (%eax),%eax
  801416:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801419:	8b 52 04             	mov    0x4(%edx),%edx
  80141c:	89 50 04             	mov    %edx,0x4(%eax)
  80141f:	eb 0b                	jmp    80142c <initialize_dyn_block_system+0x10b>
  801421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801424:	8b 40 04             	mov    0x4(%eax),%eax
  801427:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80142c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80142f:	8b 40 04             	mov    0x4(%eax),%eax
  801432:	85 c0                	test   %eax,%eax
  801434:	74 0f                	je     801445 <initialize_dyn_block_system+0x124>
  801436:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801439:	8b 40 04             	mov    0x4(%eax),%eax
  80143c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80143f:	8b 12                	mov    (%edx),%edx
  801441:	89 10                	mov    %edx,(%eax)
  801443:	eb 0a                	jmp    80144f <initialize_dyn_block_system+0x12e>
  801445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801448:	8b 00                	mov    (%eax),%eax
  80144a:	a3 48 41 80 00       	mov    %eax,0x804148
  80144f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801452:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80145b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801462:	a1 54 41 80 00       	mov    0x804154,%eax
  801467:	48                   	dec    %eax
  801468:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  80146d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801470:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801481:	83 ec 0c             	sub    $0xc,%esp
  801484:	ff 75 e4             	pushl  -0x1c(%ebp)
  801487:	e8 d2 13 00 00       	call   80285e <insert_sorted_with_merge_freeList>
  80148c:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80148f:	90                   	nop
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801498:	e8 53 fe ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  80149d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a1:	75 07                	jne    8014aa <malloc+0x18>
  8014a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a8:	eb 61                	jmp    80150b <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8014aa:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b7:	01 d0                	add    %edx,%eax
  8014b9:	48                   	dec    %eax
  8014ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c5:	f7 75 f4             	divl   -0xc(%ebp)
  8014c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cb:	29 d0                	sub    %edx,%eax
  8014cd:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014d0:	e8 3c 08 00 00       	call   801d11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d5:	85 c0                	test   %eax,%eax
  8014d7:	74 2d                	je     801506 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8014d9:	83 ec 0c             	sub    $0xc,%esp
  8014dc:	ff 75 08             	pushl  0x8(%ebp)
  8014df:	e8 3e 0f 00 00       	call   802422 <alloc_block_FF>
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8014ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014ee:	74 16                	je     801506 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8014f0:	83 ec 0c             	sub    $0xc,%esp
  8014f3:	ff 75 ec             	pushl  -0x14(%ebp)
  8014f6:	e8 48 0c 00 00       	call   802143 <insert_sorted_allocList>
  8014fb:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8014fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801501:	8b 40 08             	mov    0x8(%eax),%eax
  801504:	eb 05                	jmp    80150b <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801506:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801521:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	83 ec 08             	sub    $0x8,%esp
  80152a:	50                   	push   %eax
  80152b:	68 40 40 80 00       	push   $0x804040
  801530:	e8 71 0b 00 00       	call   8020a6 <find_block>
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80153b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153e:	8b 50 0c             	mov    0xc(%eax),%edx
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	83 ec 08             	sub    $0x8,%esp
  801547:	52                   	push   %edx
  801548:	50                   	push   %eax
  801549:	e8 bd 03 00 00       	call   80190b <sys_free_user_mem>
  80154e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801551:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801555:	75 14                	jne    80156b <free+0x5e>
  801557:	83 ec 04             	sub    $0x4,%esp
  80155a:	68 f5 38 80 00       	push   $0x8038f5
  80155f:	6a 71                	push   $0x71
  801561:	68 13 39 80 00       	push   $0x803913
  801566:	e8 4f 1a 00 00       	call   802fba <_panic>
  80156b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156e:	8b 00                	mov    (%eax),%eax
  801570:	85 c0                	test   %eax,%eax
  801572:	74 10                	je     801584 <free+0x77>
  801574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157c:	8b 52 04             	mov    0x4(%edx),%edx
  80157f:	89 50 04             	mov    %edx,0x4(%eax)
  801582:	eb 0b                	jmp    80158f <free+0x82>
  801584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801587:	8b 40 04             	mov    0x4(%eax),%eax
  80158a:	a3 44 40 80 00       	mov    %eax,0x804044
  80158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801592:	8b 40 04             	mov    0x4(%eax),%eax
  801595:	85 c0                	test   %eax,%eax
  801597:	74 0f                	je     8015a8 <free+0x9b>
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159c:	8b 40 04             	mov    0x4(%eax),%eax
  80159f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015a2:	8b 12                	mov    (%edx),%edx
  8015a4:	89 10                	mov    %edx,(%eax)
  8015a6:	eb 0a                	jmp    8015b2 <free+0xa5>
  8015a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ab:	8b 00                	mov    (%eax),%eax
  8015ad:	a3 40 40 80 00       	mov    %eax,0x804040
  8015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015c5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015ca:	48                   	dec    %eax
  8015cb:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8015d0:	83 ec 0c             	sub    $0xc,%esp
  8015d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8015d6:	e8 83 12 00 00       	call   80285e <insert_sorted_with_merge_freeList>
  8015db:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015de:	90                   	nop
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 28             	sub    $0x28,%esp
  8015e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ea:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ed:	e8 fe fc ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015f6:	75 0a                	jne    801602 <smalloc+0x21>
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fd:	e9 86 00 00 00       	jmp    801688 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801602:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801609:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160f:	01 d0                	add    %edx,%eax
  801611:	48                   	dec    %eax
  801612:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801618:	ba 00 00 00 00       	mov    $0x0,%edx
  80161d:	f7 75 f4             	divl   -0xc(%ebp)
  801620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801623:	29 d0                	sub    %edx,%eax
  801625:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801628:	e8 e4 06 00 00       	call   801d11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162d:	85 c0                	test   %eax,%eax
  80162f:	74 52                	je     801683 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801631:	83 ec 0c             	sub    $0xc,%esp
  801634:	ff 75 0c             	pushl  0xc(%ebp)
  801637:	e8 e6 0d 00 00       	call   802422 <alloc_block_FF>
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801642:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801646:	75 07                	jne    80164f <smalloc+0x6e>
			return NULL ;
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
  80164d:	eb 39                	jmp    801688 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80164f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801652:	8b 40 08             	mov    0x8(%eax),%eax
  801655:	89 c2                	mov    %eax,%edx
  801657:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80165b:	52                   	push   %edx
  80165c:	50                   	push   %eax
  80165d:	ff 75 0c             	pushl  0xc(%ebp)
  801660:	ff 75 08             	pushl  0x8(%ebp)
  801663:	e8 2e 04 00 00       	call   801a96 <sys_createSharedObject>
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80166e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801672:	79 07                	jns    80167b <smalloc+0x9a>
			return (void*)NULL ;
  801674:	b8 00 00 00 00       	mov    $0x0,%eax
  801679:	eb 0d                	jmp    801688 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  80167b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167e:	8b 40 08             	mov    0x8(%eax),%eax
  801681:	eb 05                	jmp    801688 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801683:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801690:	e8 5b fc ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	ff 75 0c             	pushl  0xc(%ebp)
  80169b:	ff 75 08             	pushl  0x8(%ebp)
  80169e:	e8 1d 04 00 00       	call   801ac0 <sys_getSizeOfSharedObject>
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8016a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016ad:	75 0a                	jne    8016b9 <sget+0x2f>
			return NULL ;
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b4:	e9 83 00 00 00       	jmp    80173c <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8016b9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c6:	01 d0                	add    %edx,%eax
  8016c8:	48                   	dec    %eax
  8016c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d4:	f7 75 f0             	divl   -0x10(%ebp)
  8016d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016da:	29 d0                	sub    %edx,%eax
  8016dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016df:	e8 2d 06 00 00       	call   801d11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	74 4f                	je     801737 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8016e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016eb:	83 ec 0c             	sub    $0xc,%esp
  8016ee:	50                   	push   %eax
  8016ef:	e8 2e 0d 00 00       	call   802422 <alloc_block_FF>
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8016fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016fe:	75 07                	jne    801707 <sget+0x7d>
					return (void*)NULL ;
  801700:	b8 00 00 00 00       	mov    $0x0,%eax
  801705:	eb 35                	jmp    80173c <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801707:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80170a:	8b 40 08             	mov    0x8(%eax),%eax
  80170d:	83 ec 04             	sub    $0x4,%esp
  801710:	50                   	push   %eax
  801711:	ff 75 0c             	pushl  0xc(%ebp)
  801714:	ff 75 08             	pushl  0x8(%ebp)
  801717:	e8 c1 03 00 00       	call   801add <sys_getSharedObject>
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801722:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801726:	79 07                	jns    80172f <sget+0xa5>
				return (void*)NULL ;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	eb 0d                	jmp    80173c <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  80172f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801732:	8b 40 08             	mov    0x8(%eax),%eax
  801735:	eb 05                	jmp    80173c <sget+0xb2>


		}
	return (void*)NULL ;
  801737:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801744:	e8 a7 fb ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	68 20 39 80 00       	push   $0x803920
  801751:	68 f9 00 00 00       	push   $0xf9
  801756:	68 13 39 80 00       	push   $0x803913
  80175b:	e8 5a 18 00 00       	call   802fba <_panic>

00801760 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	68 48 39 80 00       	push   $0x803948
  80176e:	68 0d 01 00 00       	push   $0x10d
  801773:	68 13 39 80 00       	push   $0x803913
  801778:	e8 3d 18 00 00       	call   802fba <_panic>

0080177d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801783:	83 ec 04             	sub    $0x4,%esp
  801786:	68 6c 39 80 00       	push   $0x80396c
  80178b:	68 18 01 00 00       	push   $0x118
  801790:	68 13 39 80 00       	push   $0x803913
  801795:	e8 20 18 00 00       	call   802fba <_panic>

0080179a <shrink>:

}
void shrink(uint32 newSize)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	68 6c 39 80 00       	push   $0x80396c
  8017a8:	68 1d 01 00 00       	push   $0x11d
  8017ad:	68 13 39 80 00       	push   $0x803913
  8017b2:	e8 03 18 00 00       	call   802fba <_panic>

008017b7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	68 6c 39 80 00       	push   $0x80396c
  8017c5:	68 22 01 00 00       	push   $0x122
  8017ca:	68 13 39 80 00       	push   $0x803913
  8017cf:	e8 e6 17 00 00       	call   802fba <_panic>

008017d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	57                   	push   %edi
  8017d8:	56                   	push   %esi
  8017d9:	53                   	push   %ebx
  8017da:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017ec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017ef:	cd 30                	int    $0x30
  8017f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017f7:	83 c4 10             	add    $0x10,%esp
  8017fa:	5b                   	pop    %ebx
  8017fb:	5e                   	pop    %esi
  8017fc:	5f                   	pop    %edi
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    

008017ff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 04             	sub    $0x4,%esp
  801805:	8b 45 10             	mov    0x10(%ebp),%eax
  801808:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80180b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	52                   	push   %edx
  801817:	ff 75 0c             	pushl  0xc(%ebp)
  80181a:	50                   	push   %eax
  80181b:	6a 00                	push   $0x0
  80181d:	e8 b2 ff ff ff       	call   8017d4 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	90                   	nop
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_cgetc>:

int
sys_cgetc(void)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 01                	push   $0x1
  801837:	e8 98 ff ff ff       	call   8017d4 <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801844:	8b 55 0c             	mov    0xc(%ebp),%edx
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	52                   	push   %edx
  801851:	50                   	push   %eax
  801852:	6a 05                	push   $0x5
  801854:	e8 7b ff ff ff       	call   8017d4 <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	56                   	push   %esi
  801862:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801863:	8b 75 18             	mov    0x18(%ebp),%esi
  801866:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801869:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	56                   	push   %esi
  801873:	53                   	push   %ebx
  801874:	51                   	push   %ecx
  801875:	52                   	push   %edx
  801876:	50                   	push   %eax
  801877:	6a 06                	push   $0x6
  801879:	e8 56 ff ff ff       	call   8017d4 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801884:	5b                   	pop    %ebx
  801885:	5e                   	pop    %esi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    

00801888 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80188b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	52                   	push   %edx
  801898:	50                   	push   %eax
  801899:	6a 07                	push   $0x7
  80189b:	e8 34 ff ff ff       	call   8017d4 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	ff 75 0c             	pushl  0xc(%ebp)
  8018b1:	ff 75 08             	pushl  0x8(%ebp)
  8018b4:	6a 08                	push   $0x8
  8018b6:	e8 19 ff ff ff       	call   8017d4 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 09                	push   $0x9
  8018cf:	e8 00 ff ff ff       	call   8017d4 <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 0a                	push   $0xa
  8018e8:	e8 e7 fe ff ff       	call   8017d4 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 0b                	push   $0xb
  801901:	e8 ce fe ff ff       	call   8017d4 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	ff 75 0c             	pushl  0xc(%ebp)
  801917:	ff 75 08             	pushl  0x8(%ebp)
  80191a:	6a 0f                	push   $0xf
  80191c:	e8 b3 fe ff ff       	call   8017d4 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
	return;
  801924:	90                   	nop
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	ff 75 08             	pushl  0x8(%ebp)
  801936:	6a 10                	push   $0x10
  801938:	e8 97 fe ff ff       	call   8017d4 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
	return ;
  801940:	90                   	nop
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	ff 75 10             	pushl  0x10(%ebp)
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	6a 11                	push   $0x11
  801955:	e8 7a fe ff ff       	call   8017d4 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
	return ;
  80195d:	90                   	nop
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 0c                	push   $0xc
  80196f:	e8 60 fe ff ff       	call   8017d4 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	ff 75 08             	pushl  0x8(%ebp)
  801987:	6a 0d                	push   $0xd
  801989:	e8 46 fe ff ff       	call   8017d4 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 0e                	push   $0xe
  8019a2:	e8 2d fe ff ff       	call   8017d4 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	90                   	nop
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 13                	push   $0x13
  8019bc:	e8 13 fe ff ff       	call   8017d4 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	90                   	nop
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 14                	push   $0x14
  8019d6:	e8 f9 fd ff ff       	call   8017d4 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	90                   	nop
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 04             	sub    $0x4,%esp
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019ed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	50                   	push   %eax
  8019fa:	6a 15                	push   $0x15
  8019fc:	e8 d3 fd ff ff       	call   8017d4 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	90                   	nop
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 16                	push   $0x16
  801a16:	e8 b9 fd ff ff       	call   8017d4 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	90                   	nop
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	50                   	push   %eax
  801a31:	6a 17                	push   $0x17
  801a33:	e8 9c fd ff ff       	call   8017d4 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	52                   	push   %edx
  801a4d:	50                   	push   %eax
  801a4e:	6a 1a                	push   $0x1a
  801a50:	e8 7f fd ff ff       	call   8017d4 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	52                   	push   %edx
  801a6a:	50                   	push   %eax
  801a6b:	6a 18                	push   $0x18
  801a6d:	e8 62 fd ff ff       	call   8017d4 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	90                   	nop
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 19                	push   $0x19
  801a8b:	e8 44 fd ff ff       	call   8017d4 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 04             	sub    $0x4,%esp
  801a9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aa2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	51                   	push   %ecx
  801aaf:	52                   	push   %edx
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	50                   	push   %eax
  801ab4:	6a 1b                	push   $0x1b
  801ab6:	e8 19 fd ff ff       	call   8017d4 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	52                   	push   %edx
  801ad0:	50                   	push   %eax
  801ad1:	6a 1c                	push   $0x1c
  801ad3:	e8 fc fc ff ff       	call   8017d4 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ae0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	51                   	push   %ecx
  801aee:	52                   	push   %edx
  801aef:	50                   	push   %eax
  801af0:	6a 1d                	push   $0x1d
  801af2:	e8 dd fc ff ff       	call   8017d4 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	52                   	push   %edx
  801b0c:	50                   	push   %eax
  801b0d:	6a 1e                	push   $0x1e
  801b0f:	e8 c0 fc ff ff       	call   8017d4 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 1f                	push   $0x1f
  801b28:	e8 a7 fc ff ff       	call   8017d4 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	ff 75 14             	pushl  0x14(%ebp)
  801b3d:	ff 75 10             	pushl  0x10(%ebp)
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	50                   	push   %eax
  801b44:	6a 20                	push   $0x20
  801b46:	e8 89 fc ff ff       	call   8017d4 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	50                   	push   %eax
  801b5f:	6a 21                	push   $0x21
  801b61:	e8 6e fc ff ff       	call   8017d4 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	90                   	nop
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	50                   	push   %eax
  801b7b:	6a 22                	push   $0x22
  801b7d:	e8 52 fc ff ff       	call   8017d4 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 02                	push   $0x2
  801b96:	e8 39 fc ff ff       	call   8017d4 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 03                	push   $0x3
  801baf:	e8 20 fc ff ff       	call   8017d4 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 04                	push   $0x4
  801bc8:	e8 07 fc ff ff       	call   8017d4 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_exit_env>:


void sys_exit_env(void)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 23                	push   $0x23
  801be1:	e8 ee fb ff ff       	call   8017d4 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	90                   	nop
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bf2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf5:	8d 50 04             	lea    0x4(%eax),%edx
  801bf8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	52                   	push   %edx
  801c02:	50                   	push   %eax
  801c03:	6a 24                	push   $0x24
  801c05:	e8 ca fb ff ff       	call   8017d4 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
	return result;
  801c0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c16:	89 01                	mov    %eax,(%ecx)
  801c18:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	c9                   	leave  
  801c1f:	c2 04 00             	ret    $0x4

00801c22 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	ff 75 10             	pushl  0x10(%ebp)
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	ff 75 08             	pushl  0x8(%ebp)
  801c32:	6a 12                	push   $0x12
  801c34:	e8 9b fb ff ff       	call   8017d4 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3c:	90                   	nop
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_rcr2>:
uint32 sys_rcr2()
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 25                	push   $0x25
  801c4e:	e8 81 fb ff ff       	call   8017d4 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c64:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	50                   	push   %eax
  801c71:	6a 26                	push   $0x26
  801c73:	e8 5c fb ff ff       	call   8017d4 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7b:	90                   	nop
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <rsttst>:
void rsttst()
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 28                	push   $0x28
  801c8d:	e8 42 fb ff ff       	call   8017d4 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
	return ;
  801c95:	90                   	nop
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ca4:	8b 55 18             	mov    0x18(%ebp),%edx
  801ca7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cab:	52                   	push   %edx
  801cac:	50                   	push   %eax
  801cad:	ff 75 10             	pushl  0x10(%ebp)
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	ff 75 08             	pushl  0x8(%ebp)
  801cb6:	6a 27                	push   $0x27
  801cb8:	e8 17 fb ff ff       	call   8017d4 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc0:	90                   	nop
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <chktst>:
void chktst(uint32 n)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	ff 75 08             	pushl  0x8(%ebp)
  801cd1:	6a 29                	push   $0x29
  801cd3:	e8 fc fa ff ff       	call   8017d4 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdb:	90                   	nop
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <inctst>:

void inctst()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 2a                	push   $0x2a
  801ced:	e8 e2 fa ff ff       	call   8017d4 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf5:	90                   	nop
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <gettst>:
uint32 gettst()
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 2b                	push   $0x2b
  801d07:	e8 c8 fa ff ff       	call   8017d4 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 2c                	push   $0x2c
  801d23:	e8 ac fa ff ff       	call   8017d4 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
  801d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d2e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d32:	75 07                	jne    801d3b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d34:	b8 01 00 00 00       	mov    $0x1,%eax
  801d39:	eb 05                	jmp    801d40 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 2c                	push   $0x2c
  801d54:	e8 7b fa ff ff       	call   8017d4 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
  801d5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d5f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d63:	75 07                	jne    801d6c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d65:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6a:	eb 05                	jmp    801d71 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 2c                	push   $0x2c
  801d85:	e8 4a fa ff ff       	call   8017d4 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
  801d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d90:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d94:	75 07                	jne    801d9d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d96:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9b:	eb 05                	jmp    801da2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 2c                	push   $0x2c
  801db6:	e8 19 fa ff ff       	call   8017d4 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
  801dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dc1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dc5:	75 07                	jne    801dce <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcc:	eb 05                	jmp    801dd3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	ff 75 08             	pushl  0x8(%ebp)
  801de3:	6a 2d                	push   $0x2d
  801de5:	e8 ea f9 ff ff       	call   8017d4 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ded:	90                   	nop
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801df4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801df7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	6a 00                	push   $0x0
  801e02:	53                   	push   %ebx
  801e03:	51                   	push   %ecx
  801e04:	52                   	push   %edx
  801e05:	50                   	push   %eax
  801e06:	6a 2e                	push   $0x2e
  801e08:	e8 c7 f9 ff ff       	call   8017d4 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
}
  801e10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	52                   	push   %edx
  801e25:	50                   	push   %eax
  801e26:	6a 2f                	push   $0x2f
  801e28:	e8 a7 f9 ff ff       	call   8017d4 <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e38:	83 ec 0c             	sub    $0xc,%esp
  801e3b:	68 7c 39 80 00       	push   $0x80397c
  801e40:	e8 21 e7 ff ff       	call   800566 <cprintf>
  801e45:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e48:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e4f:	83 ec 0c             	sub    $0xc,%esp
  801e52:	68 a8 39 80 00       	push   $0x8039a8
  801e57:	e8 0a e7 ff ff       	call   800566 <cprintf>
  801e5c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e5f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e63:	a1 38 41 80 00       	mov    0x804138,%eax
  801e68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e6b:	eb 56                	jmp    801ec3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e71:	74 1c                	je     801e8f <print_mem_block_lists+0x5d>
  801e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e76:	8b 50 08             	mov    0x8(%eax),%edx
  801e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7c:	8b 48 08             	mov    0x8(%eax),%ecx
  801e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e82:	8b 40 0c             	mov    0xc(%eax),%eax
  801e85:	01 c8                	add    %ecx,%eax
  801e87:	39 c2                	cmp    %eax,%edx
  801e89:	73 04                	jae    801e8f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e8b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e92:	8b 50 08             	mov    0x8(%eax),%edx
  801e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e98:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9b:	01 c2                	add    %eax,%edx
  801e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea0:	8b 40 08             	mov    0x8(%eax),%eax
  801ea3:	83 ec 04             	sub    $0x4,%esp
  801ea6:	52                   	push   %edx
  801ea7:	50                   	push   %eax
  801ea8:	68 bd 39 80 00       	push   $0x8039bd
  801ead:	e8 b4 e6 ff ff       	call   800566 <cprintf>
  801eb2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ebb:	a1 40 41 80 00       	mov    0x804140,%eax
  801ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec7:	74 07                	je     801ed0 <print_mem_block_lists+0x9e>
  801ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecc:	8b 00                	mov    (%eax),%eax
  801ece:	eb 05                	jmp    801ed5 <print_mem_block_lists+0xa3>
  801ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed5:	a3 40 41 80 00       	mov    %eax,0x804140
  801eda:	a1 40 41 80 00       	mov    0x804140,%eax
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	75 8a                	jne    801e6d <print_mem_block_lists+0x3b>
  801ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee7:	75 84                	jne    801e6d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ee9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eed:	75 10                	jne    801eff <print_mem_block_lists+0xcd>
  801eef:	83 ec 0c             	sub    $0xc,%esp
  801ef2:	68 cc 39 80 00       	push   $0x8039cc
  801ef7:	e8 6a e6 ff ff       	call   800566 <cprintf>
  801efc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801eff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f06:	83 ec 0c             	sub    $0xc,%esp
  801f09:	68 f0 39 80 00       	push   $0x8039f0
  801f0e:	e8 53 e6 ff ff       	call   800566 <cprintf>
  801f13:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f16:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f1a:	a1 40 40 80 00       	mov    0x804040,%eax
  801f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f22:	eb 56                	jmp    801f7a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f28:	74 1c                	je     801f46 <print_mem_block_lists+0x114>
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	8b 50 08             	mov    0x8(%eax),%edx
  801f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f33:	8b 48 08             	mov    0x8(%eax),%ecx
  801f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f39:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3c:	01 c8                	add    %ecx,%eax
  801f3e:	39 c2                	cmp    %eax,%edx
  801f40:	73 04                	jae    801f46 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f42:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f49:	8b 50 08             	mov    0x8(%eax),%edx
  801f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f52:	01 c2                	add    %eax,%edx
  801f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f57:	8b 40 08             	mov    0x8(%eax),%eax
  801f5a:	83 ec 04             	sub    $0x4,%esp
  801f5d:	52                   	push   %edx
  801f5e:	50                   	push   %eax
  801f5f:	68 bd 39 80 00       	push   $0x8039bd
  801f64:	e8 fd e5 ff ff       	call   800566 <cprintf>
  801f69:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f72:	a1 48 40 80 00       	mov    0x804048,%eax
  801f77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7e:	74 07                	je     801f87 <print_mem_block_lists+0x155>
  801f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f83:	8b 00                	mov    (%eax),%eax
  801f85:	eb 05                	jmp    801f8c <print_mem_block_lists+0x15a>
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8c:	a3 48 40 80 00       	mov    %eax,0x804048
  801f91:	a1 48 40 80 00       	mov    0x804048,%eax
  801f96:	85 c0                	test   %eax,%eax
  801f98:	75 8a                	jne    801f24 <print_mem_block_lists+0xf2>
  801f9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9e:	75 84                	jne    801f24 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fa0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fa4:	75 10                	jne    801fb6 <print_mem_block_lists+0x184>
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	68 08 3a 80 00       	push   $0x803a08
  801fae:	e8 b3 e5 ff ff       	call   800566 <cprintf>
  801fb3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fb6:	83 ec 0c             	sub    $0xc,%esp
  801fb9:	68 7c 39 80 00       	push   $0x80397c
  801fbe:	e8 a3 e5 ff ff       	call   800566 <cprintf>
  801fc3:	83 c4 10             	add    $0x10,%esp

}
  801fc6:	90                   	nop
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801fcf:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fd6:	00 00 00 
  801fd9:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fe0:	00 00 00 
  801fe3:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801fea:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801fed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ff4:	e9 9e 00 00 00       	jmp    802097 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  801ff9:	a1 50 40 80 00       	mov    0x804050,%eax
  801ffe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802001:	c1 e2 04             	shl    $0x4,%edx
  802004:	01 d0                	add    %edx,%eax
  802006:	85 c0                	test   %eax,%eax
  802008:	75 14                	jne    80201e <initialize_MemBlocksList+0x55>
  80200a:	83 ec 04             	sub    $0x4,%esp
  80200d:	68 30 3a 80 00       	push   $0x803a30
  802012:	6a 43                	push   $0x43
  802014:	68 53 3a 80 00       	push   $0x803a53
  802019:	e8 9c 0f 00 00       	call   802fba <_panic>
  80201e:	a1 50 40 80 00       	mov    0x804050,%eax
  802023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802026:	c1 e2 04             	shl    $0x4,%edx
  802029:	01 d0                	add    %edx,%eax
  80202b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802031:	89 10                	mov    %edx,(%eax)
  802033:	8b 00                	mov    (%eax),%eax
  802035:	85 c0                	test   %eax,%eax
  802037:	74 18                	je     802051 <initialize_MemBlocksList+0x88>
  802039:	a1 48 41 80 00       	mov    0x804148,%eax
  80203e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802044:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802047:	c1 e1 04             	shl    $0x4,%ecx
  80204a:	01 ca                	add    %ecx,%edx
  80204c:	89 50 04             	mov    %edx,0x4(%eax)
  80204f:	eb 12                	jmp    802063 <initialize_MemBlocksList+0x9a>
  802051:	a1 50 40 80 00       	mov    0x804050,%eax
  802056:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802059:	c1 e2 04             	shl    $0x4,%edx
  80205c:	01 d0                	add    %edx,%eax
  80205e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802063:	a1 50 40 80 00       	mov    0x804050,%eax
  802068:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206b:	c1 e2 04             	shl    $0x4,%edx
  80206e:	01 d0                	add    %edx,%eax
  802070:	a3 48 41 80 00       	mov    %eax,0x804148
  802075:	a1 50 40 80 00       	mov    0x804050,%eax
  80207a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207d:	c1 e2 04             	shl    $0x4,%edx
  802080:	01 d0                	add    %edx,%eax
  802082:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802089:	a1 54 41 80 00       	mov    0x804154,%eax
  80208e:	40                   	inc    %eax
  80208f:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802094:	ff 45 f4             	incl   -0xc(%ebp)
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80209d:	0f 82 56 ff ff ff    	jb     801ff9 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8020a3:	90                   	nop
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020ac:	a1 38 41 80 00       	mov    0x804138,%eax
  8020b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020b4:	eb 18                	jmp    8020ce <find_block+0x28>
	{
		if (ele->sva==va)
  8020b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020b9:	8b 40 08             	mov    0x8(%eax),%eax
  8020bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020bf:	75 05                	jne    8020c6 <find_block+0x20>
			return ele;
  8020c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c4:	eb 7b                	jmp    802141 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020c6:	a1 40 41 80 00       	mov    0x804140,%eax
  8020cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020d2:	74 07                	je     8020db <find_block+0x35>
  8020d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d7:	8b 00                	mov    (%eax),%eax
  8020d9:	eb 05                	jmp    8020e0 <find_block+0x3a>
  8020db:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e0:	a3 40 41 80 00       	mov    %eax,0x804140
  8020e5:	a1 40 41 80 00       	mov    0x804140,%eax
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	75 c8                	jne    8020b6 <find_block+0x10>
  8020ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f2:	75 c2                	jne    8020b6 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020f4:	a1 40 40 80 00       	mov    0x804040,%eax
  8020f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020fc:	eb 18                	jmp    802116 <find_block+0x70>
	{
		if (ele->sva==va)
  8020fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802101:	8b 40 08             	mov    0x8(%eax),%eax
  802104:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802107:	75 05                	jne    80210e <find_block+0x68>
					return ele;
  802109:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210c:	eb 33                	jmp    802141 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80210e:	a1 48 40 80 00       	mov    0x804048,%eax
  802113:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802116:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80211a:	74 07                	je     802123 <find_block+0x7d>
  80211c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211f:	8b 00                	mov    (%eax),%eax
  802121:	eb 05                	jmp    802128 <find_block+0x82>
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	a3 48 40 80 00       	mov    %eax,0x804048
  80212d:	a1 48 40 80 00       	mov    0x804048,%eax
  802132:	85 c0                	test   %eax,%eax
  802134:	75 c8                	jne    8020fe <find_block+0x58>
  802136:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80213a:	75 c2                	jne    8020fe <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802149:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80214e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802151:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802155:	75 62                	jne    8021b9 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802157:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80215b:	75 14                	jne    802171 <insert_sorted_allocList+0x2e>
  80215d:	83 ec 04             	sub    $0x4,%esp
  802160:	68 30 3a 80 00       	push   $0x803a30
  802165:	6a 69                	push   $0x69
  802167:	68 53 3a 80 00       	push   $0x803a53
  80216c:	e8 49 0e 00 00       	call   802fba <_panic>
  802171:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	89 10                	mov    %edx,(%eax)
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	8b 00                	mov    (%eax),%eax
  802181:	85 c0                	test   %eax,%eax
  802183:	74 0d                	je     802192 <insert_sorted_allocList+0x4f>
  802185:	a1 40 40 80 00       	mov    0x804040,%eax
  80218a:	8b 55 08             	mov    0x8(%ebp),%edx
  80218d:	89 50 04             	mov    %edx,0x4(%eax)
  802190:	eb 08                	jmp    80219a <insert_sorted_allocList+0x57>
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	a3 44 40 80 00       	mov    %eax,0x804044
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	a3 40 40 80 00       	mov    %eax,0x804040
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ac:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021b1:	40                   	inc    %eax
  8021b2:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021b7:	eb 72                	jmp    80222b <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8021b9:	a1 40 40 80 00       	mov    0x804040,%eax
  8021be:	8b 50 08             	mov    0x8(%eax),%edx
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	8b 40 08             	mov    0x8(%eax),%eax
  8021c7:	39 c2                	cmp    %eax,%edx
  8021c9:	76 60                	jbe    80222b <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8021cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021cf:	75 14                	jne    8021e5 <insert_sorted_allocList+0xa2>
  8021d1:	83 ec 04             	sub    $0x4,%esp
  8021d4:	68 30 3a 80 00       	push   $0x803a30
  8021d9:	6a 6d                	push   $0x6d
  8021db:	68 53 3a 80 00       	push   $0x803a53
  8021e0:	e8 d5 0d 00 00       	call   802fba <_panic>
  8021e5:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	89 10                	mov    %edx,(%eax)
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	8b 00                	mov    (%eax),%eax
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	74 0d                	je     802206 <insert_sorted_allocList+0xc3>
  8021f9:	a1 40 40 80 00       	mov    0x804040,%eax
  8021fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802201:	89 50 04             	mov    %edx,0x4(%eax)
  802204:	eb 08                	jmp    80220e <insert_sorted_allocList+0xcb>
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	a3 44 40 80 00       	mov    %eax,0x804044
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	a3 40 40 80 00       	mov    %eax,0x804040
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802220:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802225:	40                   	inc    %eax
  802226:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80222b:	a1 40 40 80 00       	mov    0x804040,%eax
  802230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802233:	e9 b9 01 00 00       	jmp    8023f1 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	8b 50 08             	mov    0x8(%eax),%edx
  80223e:	a1 40 40 80 00       	mov    0x804040,%eax
  802243:	8b 40 08             	mov    0x8(%eax),%eax
  802246:	39 c2                	cmp    %eax,%edx
  802248:	76 7c                	jbe    8022c6 <insert_sorted_allocList+0x183>
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	8b 50 08             	mov    0x8(%eax),%edx
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	8b 40 08             	mov    0x8(%eax),%eax
  802256:	39 c2                	cmp    %eax,%edx
  802258:	73 6c                	jae    8022c6 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80225a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80225e:	74 06                	je     802266 <insert_sorted_allocList+0x123>
  802260:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802264:	75 14                	jne    80227a <insert_sorted_allocList+0x137>
  802266:	83 ec 04             	sub    $0x4,%esp
  802269:	68 6c 3a 80 00       	push   $0x803a6c
  80226e:	6a 75                	push   $0x75
  802270:	68 53 3a 80 00       	push   $0x803a53
  802275:	e8 40 0d 00 00       	call   802fba <_panic>
  80227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227d:	8b 50 04             	mov    0x4(%eax),%edx
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	89 50 04             	mov    %edx,0x4(%eax)
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228c:	89 10                	mov    %edx,(%eax)
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	8b 40 04             	mov    0x4(%eax),%eax
  802294:	85 c0                	test   %eax,%eax
  802296:	74 0d                	je     8022a5 <insert_sorted_allocList+0x162>
  802298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229b:	8b 40 04             	mov    0x4(%eax),%eax
  80229e:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a1:	89 10                	mov    %edx,(%eax)
  8022a3:	eb 08                	jmp    8022ad <insert_sorted_allocList+0x16a>
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	a3 40 40 80 00       	mov    %eax,0x804040
  8022ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b3:	89 50 04             	mov    %edx,0x4(%eax)
  8022b6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022bb:	40                   	inc    %eax
  8022bc:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8022c1:	e9 59 01 00 00       	jmp    80241f <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8b 50 08             	mov    0x8(%eax),%edx
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 40 08             	mov    0x8(%eax),%eax
  8022d2:	39 c2                	cmp    %eax,%edx
  8022d4:	0f 86 98 00 00 00    	jbe    802372 <insert_sorted_allocList+0x22f>
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	8b 50 08             	mov    0x8(%eax),%edx
  8022e0:	a1 44 40 80 00       	mov    0x804044,%eax
  8022e5:	8b 40 08             	mov    0x8(%eax),%eax
  8022e8:	39 c2                	cmp    %eax,%edx
  8022ea:	0f 83 82 00 00 00    	jae    802372 <insert_sorted_allocList+0x22f>
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	8b 50 08             	mov    0x8(%eax),%edx
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	8b 00                	mov    (%eax),%eax
  8022fb:	8b 40 08             	mov    0x8(%eax),%eax
  8022fe:	39 c2                	cmp    %eax,%edx
  802300:	73 70                	jae    802372 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802302:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802306:	74 06                	je     80230e <insert_sorted_allocList+0x1cb>
  802308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80230c:	75 14                	jne    802322 <insert_sorted_allocList+0x1df>
  80230e:	83 ec 04             	sub    $0x4,%esp
  802311:	68 a4 3a 80 00       	push   $0x803aa4
  802316:	6a 7c                	push   $0x7c
  802318:	68 53 3a 80 00       	push   $0x803a53
  80231d:	e8 98 0c 00 00       	call   802fba <_panic>
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	8b 10                	mov    (%eax),%edx
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	89 10                	mov    %edx,(%eax)
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	85 c0                	test   %eax,%eax
  802333:	74 0b                	je     802340 <insert_sorted_allocList+0x1fd>
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 00                	mov    (%eax),%eax
  80233a:	8b 55 08             	mov    0x8(%ebp),%edx
  80233d:	89 50 04             	mov    %edx,0x4(%eax)
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 55 08             	mov    0x8(%ebp),%edx
  802346:	89 10                	mov    %edx,(%eax)
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234e:	89 50 04             	mov    %edx,0x4(%eax)
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	85 c0                	test   %eax,%eax
  802358:	75 08                	jne    802362 <insert_sorted_allocList+0x21f>
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	a3 44 40 80 00       	mov    %eax,0x804044
  802362:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802367:	40                   	inc    %eax
  802368:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80236d:	e9 ad 00 00 00       	jmp    80241f <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	8b 50 08             	mov    0x8(%eax),%edx
  802378:	a1 44 40 80 00       	mov    0x804044,%eax
  80237d:	8b 40 08             	mov    0x8(%eax),%eax
  802380:	39 c2                	cmp    %eax,%edx
  802382:	76 65                	jbe    8023e9 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802384:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802388:	75 17                	jne    8023a1 <insert_sorted_allocList+0x25e>
  80238a:	83 ec 04             	sub    $0x4,%esp
  80238d:	68 d8 3a 80 00       	push   $0x803ad8
  802392:	68 80 00 00 00       	push   $0x80
  802397:	68 53 3a 80 00       	push   $0x803a53
  80239c:	e8 19 0c 00 00       	call   802fba <_panic>
  8023a1:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023aa:	89 50 04             	mov    %edx,0x4(%eax)
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	8b 40 04             	mov    0x4(%eax),%eax
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	74 0c                	je     8023c3 <insert_sorted_allocList+0x280>
  8023b7:	a1 44 40 80 00       	mov    0x804044,%eax
  8023bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023bf:	89 10                	mov    %edx,(%eax)
  8023c1:	eb 08                	jmp    8023cb <insert_sorted_allocList+0x288>
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	a3 40 40 80 00       	mov    %eax,0x804040
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	a3 44 40 80 00       	mov    %eax,0x804044
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023dc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023e1:	40                   	inc    %eax
  8023e2:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8023e7:	eb 36                	jmp    80241f <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8023e9:	a1 48 40 80 00       	mov    0x804048,%eax
  8023ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f5:	74 07                	je     8023fe <insert_sorted_allocList+0x2bb>
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 00                	mov    (%eax),%eax
  8023fc:	eb 05                	jmp    802403 <insert_sorted_allocList+0x2c0>
  8023fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802403:	a3 48 40 80 00       	mov    %eax,0x804048
  802408:	a1 48 40 80 00       	mov    0x804048,%eax
  80240d:	85 c0                	test   %eax,%eax
  80240f:	0f 85 23 fe ff ff    	jne    802238 <insert_sorted_allocList+0xf5>
  802415:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802419:	0f 85 19 fe ff ff    	jne    802238 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  80241f:	90                   	nop
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802428:	a1 38 41 80 00       	mov    0x804138,%eax
  80242d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802430:	e9 7c 01 00 00       	jmp    8025b1 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802438:	8b 40 0c             	mov    0xc(%eax),%eax
  80243b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80243e:	0f 85 90 00 00 00    	jne    8024d4 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80244a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244e:	75 17                	jne    802467 <alloc_block_FF+0x45>
  802450:	83 ec 04             	sub    $0x4,%esp
  802453:	68 fb 3a 80 00       	push   $0x803afb
  802458:	68 ba 00 00 00       	push   $0xba
  80245d:	68 53 3a 80 00       	push   $0x803a53
  802462:	e8 53 0b 00 00       	call   802fba <_panic>
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	85 c0                	test   %eax,%eax
  80246e:	74 10                	je     802480 <alloc_block_FF+0x5e>
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	8b 00                	mov    (%eax),%eax
  802475:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802478:	8b 52 04             	mov    0x4(%edx),%edx
  80247b:	89 50 04             	mov    %edx,0x4(%eax)
  80247e:	eb 0b                	jmp    80248b <alloc_block_FF+0x69>
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 40 04             	mov    0x4(%eax),%eax
  802486:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 40 04             	mov    0x4(%eax),%eax
  802491:	85 c0                	test   %eax,%eax
  802493:	74 0f                	je     8024a4 <alloc_block_FF+0x82>
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 40 04             	mov    0x4(%eax),%eax
  80249b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249e:	8b 12                	mov    (%edx),%edx
  8024a0:	89 10                	mov    %edx,(%eax)
  8024a2:	eb 0a                	jmp    8024ae <alloc_block_FF+0x8c>
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 00                	mov    (%eax),%eax
  8024a9:	a3 38 41 80 00       	mov    %eax,0x804138
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c1:	a1 44 41 80 00       	mov    0x804144,%eax
  8024c6:	48                   	dec    %eax
  8024c7:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8024cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cf:	e9 10 01 00 00       	jmp    8025e4 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024dd:	0f 86 c6 00 00 00    	jbe    8025a9 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8024e3:	a1 48 41 80 00       	mov    0x804148,%eax
  8024e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8024eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024ef:	75 17                	jne    802508 <alloc_block_FF+0xe6>
  8024f1:	83 ec 04             	sub    $0x4,%esp
  8024f4:	68 fb 3a 80 00       	push   $0x803afb
  8024f9:	68 c2 00 00 00       	push   $0xc2
  8024fe:	68 53 3a 80 00       	push   $0x803a53
  802503:	e8 b2 0a 00 00       	call   802fba <_panic>
  802508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250b:	8b 00                	mov    (%eax),%eax
  80250d:	85 c0                	test   %eax,%eax
  80250f:	74 10                	je     802521 <alloc_block_FF+0xff>
  802511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802514:	8b 00                	mov    (%eax),%eax
  802516:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802519:	8b 52 04             	mov    0x4(%edx),%edx
  80251c:	89 50 04             	mov    %edx,0x4(%eax)
  80251f:	eb 0b                	jmp    80252c <alloc_block_FF+0x10a>
  802521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802524:	8b 40 04             	mov    0x4(%eax),%eax
  802527:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80252c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252f:	8b 40 04             	mov    0x4(%eax),%eax
  802532:	85 c0                	test   %eax,%eax
  802534:	74 0f                	je     802545 <alloc_block_FF+0x123>
  802536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802539:	8b 40 04             	mov    0x4(%eax),%eax
  80253c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80253f:	8b 12                	mov    (%edx),%edx
  802541:	89 10                	mov    %edx,(%eax)
  802543:	eb 0a                	jmp    80254f <alloc_block_FF+0x12d>
  802545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	a3 48 41 80 00       	mov    %eax,0x804148
  80254f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802552:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802562:	a1 54 41 80 00       	mov    0x804154,%eax
  802567:	48                   	dec    %eax
  802568:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 50 08             	mov    0x8(%eax),%edx
  802573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802576:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257c:	8b 55 08             	mov    0x8(%ebp),%edx
  80257f:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 40 0c             	mov    0xc(%eax),%eax
  802588:	2b 45 08             	sub    0x8(%ebp),%eax
  80258b:	89 c2                	mov    %eax,%edx
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 50 08             	mov    0x8(%eax),%edx
  802599:	8b 45 08             	mov    0x8(%ebp),%eax
  80259c:	01 c2                	add    %eax,%edx
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8025a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a7:	eb 3b                	jmp    8025e4 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025a9:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b5:	74 07                	je     8025be <alloc_block_FF+0x19c>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	eb 05                	jmp    8025c3 <alloc_block_FF+0x1a1>
  8025be:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c3:	a3 40 41 80 00       	mov    %eax,0x804140
  8025c8:	a1 40 41 80 00       	mov    0x804140,%eax
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	0f 85 60 fe ff ff    	jne    802435 <alloc_block_FF+0x13>
  8025d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d9:	0f 85 56 fe ff ff    	jne    802435 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8025df:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e4:	c9                   	leave  
  8025e5:	c3                   	ret    

008025e6 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8025ec:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025f3:	a1 38 41 80 00       	mov    0x804138,%eax
  8025f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fb:	eb 3a                	jmp    802637 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 40 0c             	mov    0xc(%eax),%eax
  802603:	3b 45 08             	cmp    0x8(%ebp),%eax
  802606:	72 27                	jb     80262f <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802608:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80260c:	75 0b                	jne    802619 <alloc_block_BF+0x33>
					best_size= element->size;
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	8b 40 0c             	mov    0xc(%eax),%eax
  802614:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802617:	eb 16                	jmp    80262f <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 50 0c             	mov    0xc(%eax),%edx
  80261f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802622:	39 c2                	cmp    %eax,%edx
  802624:	77 09                	ja     80262f <alloc_block_BF+0x49>
					best_size=element->size;
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 40 0c             	mov    0xc(%eax),%eax
  80262c:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80262f:	a1 40 41 80 00       	mov    0x804140,%eax
  802634:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263b:	74 07                	je     802644 <alloc_block_BF+0x5e>
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 00                	mov    (%eax),%eax
  802642:	eb 05                	jmp    802649 <alloc_block_BF+0x63>
  802644:	b8 00 00 00 00       	mov    $0x0,%eax
  802649:	a3 40 41 80 00       	mov    %eax,0x804140
  80264e:	a1 40 41 80 00       	mov    0x804140,%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	75 a6                	jne    8025fd <alloc_block_BF+0x17>
  802657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265b:	75 a0                	jne    8025fd <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80265d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802661:	0f 84 d3 01 00 00    	je     80283a <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802667:	a1 38 41 80 00       	mov    0x804138,%eax
  80266c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266f:	e9 98 01 00 00       	jmp    80280c <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802677:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267a:	0f 86 da 00 00 00    	jbe    80275a <alloc_block_BF+0x174>
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 50 0c             	mov    0xc(%eax),%edx
  802686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802689:	39 c2                	cmp    %eax,%edx
  80268b:	0f 85 c9 00 00 00    	jne    80275a <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802691:	a1 48 41 80 00       	mov    0x804148,%eax
  802696:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802699:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80269d:	75 17                	jne    8026b6 <alloc_block_BF+0xd0>
  80269f:	83 ec 04             	sub    $0x4,%esp
  8026a2:	68 fb 3a 80 00       	push   $0x803afb
  8026a7:	68 ea 00 00 00       	push   $0xea
  8026ac:	68 53 3a 80 00       	push   $0x803a53
  8026b1:	e8 04 09 00 00       	call   802fba <_panic>
  8026b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b9:	8b 00                	mov    (%eax),%eax
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	74 10                	je     8026cf <alloc_block_BF+0xe9>
  8026bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026c7:	8b 52 04             	mov    0x4(%edx),%edx
  8026ca:	89 50 04             	mov    %edx,0x4(%eax)
  8026cd:	eb 0b                	jmp    8026da <alloc_block_BF+0xf4>
  8026cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d2:	8b 40 04             	mov    0x4(%eax),%eax
  8026d5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026dd:	8b 40 04             	mov    0x4(%eax),%eax
  8026e0:	85 c0                	test   %eax,%eax
  8026e2:	74 0f                	je     8026f3 <alloc_block_BF+0x10d>
  8026e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026ed:	8b 12                	mov    (%edx),%edx
  8026ef:	89 10                	mov    %edx,(%eax)
  8026f1:	eb 0a                	jmp    8026fd <alloc_block_BF+0x117>
  8026f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f6:	8b 00                	mov    (%eax),%eax
  8026f8:	a3 48 41 80 00       	mov    %eax,0x804148
  8026fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802706:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802709:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802710:	a1 54 41 80 00       	mov    0x804154,%eax
  802715:	48                   	dec    %eax
  802716:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 50 08             	mov    0x8(%eax),%edx
  802721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802724:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272a:	8b 55 08             	mov    0x8(%ebp),%edx
  80272d:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 40 0c             	mov    0xc(%eax),%eax
  802736:	2b 45 08             	sub    0x8(%ebp),%eax
  802739:	89 c2                	mov    %eax,%edx
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 50 08             	mov    0x8(%eax),%edx
  802747:	8b 45 08             	mov    0x8(%ebp),%eax
  80274a:	01 c2                	add    %eax,%edx
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802752:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802755:	e9 e5 00 00 00       	jmp    80283f <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 50 0c             	mov    0xc(%eax),%edx
  802760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802763:	39 c2                	cmp    %eax,%edx
  802765:	0f 85 99 00 00 00    	jne    802804 <alloc_block_BF+0x21e>
  80276b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802771:	0f 85 8d 00 00 00    	jne    802804 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  80277d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802781:	75 17                	jne    80279a <alloc_block_BF+0x1b4>
  802783:	83 ec 04             	sub    $0x4,%esp
  802786:	68 fb 3a 80 00       	push   $0x803afb
  80278b:	68 f7 00 00 00       	push   $0xf7
  802790:	68 53 3a 80 00       	push   $0x803a53
  802795:	e8 20 08 00 00       	call   802fba <_panic>
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	74 10                	je     8027b3 <alloc_block_BF+0x1cd>
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 00                	mov    (%eax),%eax
  8027a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ab:	8b 52 04             	mov    0x4(%edx),%edx
  8027ae:	89 50 04             	mov    %edx,0x4(%eax)
  8027b1:	eb 0b                	jmp    8027be <alloc_block_BF+0x1d8>
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 40 04             	mov    0x4(%eax),%eax
  8027b9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 40 04             	mov    0x4(%eax),%eax
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	74 0f                	je     8027d7 <alloc_block_BF+0x1f1>
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d1:	8b 12                	mov    (%edx),%edx
  8027d3:	89 10                	mov    %edx,(%eax)
  8027d5:	eb 0a                	jmp    8027e1 <alloc_block_BF+0x1fb>
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	a3 38 41 80 00       	mov    %eax,0x804138
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f4:	a1 44 41 80 00       	mov    0x804144,%eax
  8027f9:	48                   	dec    %eax
  8027fa:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8027ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802802:	eb 3b                	jmp    80283f <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802804:	a1 40 41 80 00       	mov    0x804140,%eax
  802809:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802810:	74 07                	je     802819 <alloc_block_BF+0x233>
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 00                	mov    (%eax),%eax
  802817:	eb 05                	jmp    80281e <alloc_block_BF+0x238>
  802819:	b8 00 00 00 00       	mov    $0x0,%eax
  80281e:	a3 40 41 80 00       	mov    %eax,0x804140
  802823:	a1 40 41 80 00       	mov    0x804140,%eax
  802828:	85 c0                	test   %eax,%eax
  80282a:	0f 85 44 fe ff ff    	jne    802674 <alloc_block_BF+0x8e>
  802830:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802834:	0f 85 3a fe ff ff    	jne    802674 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	c9                   	leave  
  802840:	c3                   	ret    

00802841 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
  802844:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802847:	83 ec 04             	sub    $0x4,%esp
  80284a:	68 1c 3b 80 00       	push   $0x803b1c
  80284f:	68 04 01 00 00       	push   $0x104
  802854:	68 53 3a 80 00       	push   $0x803a53
  802859:	e8 5c 07 00 00       	call   802fba <_panic>

0080285e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
  802861:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802864:	a1 38 41 80 00       	mov    0x804138,%eax
  802869:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  80286c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802871:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802874:	a1 38 41 80 00       	mov    0x804138,%eax
  802879:	85 c0                	test   %eax,%eax
  80287b:	75 68                	jne    8028e5 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80287d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802881:	75 17                	jne    80289a <insert_sorted_with_merge_freeList+0x3c>
  802883:	83 ec 04             	sub    $0x4,%esp
  802886:	68 30 3a 80 00       	push   $0x803a30
  80288b:	68 14 01 00 00       	push   $0x114
  802890:	68 53 3a 80 00       	push   $0x803a53
  802895:	e8 20 07 00 00       	call   802fba <_panic>
  80289a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a3:	89 10                	mov    %edx,(%eax)
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	74 0d                	je     8028bb <insert_sorted_with_merge_freeList+0x5d>
  8028ae:	a1 38 41 80 00       	mov    0x804138,%eax
  8028b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b6:	89 50 04             	mov    %edx,0x4(%eax)
  8028b9:	eb 08                	jmp    8028c3 <insert_sorted_with_merge_freeList+0x65>
  8028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028be:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8028cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d5:	a1 44 41 80 00       	mov    0x804144,%eax
  8028da:	40                   	inc    %eax
  8028db:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8028e0:	e9 d2 06 00 00       	jmp    802fb7 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	8b 50 08             	mov    0x8(%eax),%edx
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	8b 40 08             	mov    0x8(%eax),%eax
  8028f1:	39 c2                	cmp    %eax,%edx
  8028f3:	0f 83 22 01 00 00    	jae    802a1b <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	8b 50 08             	mov    0x8(%eax),%edx
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	8b 40 0c             	mov    0xc(%eax),%eax
  802905:	01 c2                	add    %eax,%edx
  802907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290a:	8b 40 08             	mov    0x8(%eax),%eax
  80290d:	39 c2                	cmp    %eax,%edx
  80290f:	0f 85 9e 00 00 00    	jne    8029b3 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	8b 50 08             	mov    0x8(%eax),%edx
  80291b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291e:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802921:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802924:	8b 50 0c             	mov    0xc(%eax),%edx
  802927:	8b 45 08             	mov    0x8(%ebp),%eax
  80292a:	8b 40 0c             	mov    0xc(%eax),%eax
  80292d:	01 c2                	add    %eax,%edx
  80292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802932:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	8b 50 08             	mov    0x8(%eax),%edx
  802945:	8b 45 08             	mov    0x8(%ebp),%eax
  802948:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80294b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80294f:	75 17                	jne    802968 <insert_sorted_with_merge_freeList+0x10a>
  802951:	83 ec 04             	sub    $0x4,%esp
  802954:	68 30 3a 80 00       	push   $0x803a30
  802959:	68 21 01 00 00       	push   $0x121
  80295e:	68 53 3a 80 00       	push   $0x803a53
  802963:	e8 52 06 00 00       	call   802fba <_panic>
  802968:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	89 10                	mov    %edx,(%eax)
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	74 0d                	je     802989 <insert_sorted_with_merge_freeList+0x12b>
  80297c:	a1 48 41 80 00       	mov    0x804148,%eax
  802981:	8b 55 08             	mov    0x8(%ebp),%edx
  802984:	89 50 04             	mov    %edx,0x4(%eax)
  802987:	eb 08                	jmp    802991 <insert_sorted_with_merge_freeList+0x133>
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	a3 48 41 80 00       	mov    %eax,0x804148
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a3:	a1 54 41 80 00       	mov    0x804154,%eax
  8029a8:	40                   	inc    %eax
  8029a9:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8029ae:	e9 04 06 00 00       	jmp    802fb7 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8029b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b7:	75 17                	jne    8029d0 <insert_sorted_with_merge_freeList+0x172>
  8029b9:	83 ec 04             	sub    $0x4,%esp
  8029bc:	68 30 3a 80 00       	push   $0x803a30
  8029c1:	68 26 01 00 00       	push   $0x126
  8029c6:	68 53 3a 80 00       	push   $0x803a53
  8029cb:	e8 ea 05 00 00       	call   802fba <_panic>
  8029d0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	89 10                	mov    %edx,(%eax)
  8029db:	8b 45 08             	mov    0x8(%ebp),%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	74 0d                	je     8029f1 <insert_sorted_with_merge_freeList+0x193>
  8029e4:	a1 38 41 80 00       	mov    0x804138,%eax
  8029e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ec:	89 50 04             	mov    %edx,0x4(%eax)
  8029ef:	eb 08                	jmp    8029f9 <insert_sorted_with_merge_freeList+0x19b>
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fc:	a3 38 41 80 00       	mov    %eax,0x804138
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0b:	a1 44 41 80 00       	mov    0x804144,%eax
  802a10:	40                   	inc    %eax
  802a11:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802a16:	e9 9c 05 00 00       	jmp    802fb7 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	8b 50 08             	mov    0x8(%eax),%edx
  802a21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a24:	8b 40 08             	mov    0x8(%eax),%eax
  802a27:	39 c2                	cmp    %eax,%edx
  802a29:	0f 86 16 01 00 00    	jbe    802b45 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802a2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a32:	8b 50 08             	mov    0x8(%eax),%edx
  802a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a38:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3b:	01 c2                	add    %eax,%edx
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	8b 40 08             	mov    0x8(%eax),%eax
  802a43:	39 c2                	cmp    %eax,%edx
  802a45:	0f 85 92 00 00 00    	jne    802add <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4e:	8b 50 0c             	mov    0xc(%eax),%edx
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	8b 40 0c             	mov    0xc(%eax),%eax
  802a57:	01 c2                	add    %eax,%edx
  802a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	8b 50 08             	mov    0x8(%eax),%edx
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a79:	75 17                	jne    802a92 <insert_sorted_with_merge_freeList+0x234>
  802a7b:	83 ec 04             	sub    $0x4,%esp
  802a7e:	68 30 3a 80 00       	push   $0x803a30
  802a83:	68 31 01 00 00       	push   $0x131
  802a88:	68 53 3a 80 00       	push   $0x803a53
  802a8d:	e8 28 05 00 00       	call   802fba <_panic>
  802a92:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	89 10                	mov    %edx,(%eax)
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	8b 00                	mov    (%eax),%eax
  802aa2:	85 c0                	test   %eax,%eax
  802aa4:	74 0d                	je     802ab3 <insert_sorted_with_merge_freeList+0x255>
  802aa6:	a1 48 41 80 00       	mov    0x804148,%eax
  802aab:	8b 55 08             	mov    0x8(%ebp),%edx
  802aae:	89 50 04             	mov    %edx,0x4(%eax)
  802ab1:	eb 08                	jmp    802abb <insert_sorted_with_merge_freeList+0x25d>
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	a3 48 41 80 00       	mov    %eax,0x804148
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acd:	a1 54 41 80 00       	mov    0x804154,%eax
  802ad2:	40                   	inc    %eax
  802ad3:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802ad8:	e9 da 04 00 00       	jmp    802fb7 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802add:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae1:	75 17                	jne    802afa <insert_sorted_with_merge_freeList+0x29c>
  802ae3:	83 ec 04             	sub    $0x4,%esp
  802ae6:	68 d8 3a 80 00       	push   $0x803ad8
  802aeb:	68 37 01 00 00       	push   $0x137
  802af0:	68 53 3a 80 00       	push   $0x803a53
  802af5:	e8 c0 04 00 00       	call   802fba <_panic>
  802afa:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	89 50 04             	mov    %edx,0x4(%eax)
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	8b 40 04             	mov    0x4(%eax),%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	74 0c                	je     802b1c <insert_sorted_with_merge_freeList+0x2be>
  802b10:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b15:	8b 55 08             	mov    0x8(%ebp),%edx
  802b18:	89 10                	mov    %edx,(%eax)
  802b1a:	eb 08                	jmp    802b24 <insert_sorted_with_merge_freeList+0x2c6>
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	a3 38 41 80 00       	mov    %eax,0x804138
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b35:	a1 44 41 80 00       	mov    0x804144,%eax
  802b3a:	40                   	inc    %eax
  802b3b:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b40:	e9 72 04 00 00       	jmp    802fb7 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802b45:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b4d:	e9 35 04 00 00       	jmp    802f87 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	8b 50 08             	mov    0x8(%eax),%edx
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	8b 40 08             	mov    0x8(%eax),%eax
  802b66:	39 c2                	cmp    %eax,%edx
  802b68:	0f 86 11 04 00 00    	jbe    802f7f <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 50 08             	mov    0x8(%eax),%edx
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7a:	01 c2                	add    %eax,%edx
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	8b 40 08             	mov    0x8(%eax),%eax
  802b82:	39 c2                	cmp    %eax,%edx
  802b84:	0f 83 8b 00 00 00    	jae    802c15 <insert_sorted_with_merge_freeList+0x3b7>
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	8b 50 08             	mov    0x8(%eax),%edx
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	8b 40 0c             	mov    0xc(%eax),%eax
  802b96:	01 c2                	add    %eax,%edx
  802b98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9b:	8b 40 08             	mov    0x8(%eax),%eax
  802b9e:	39 c2                	cmp    %eax,%edx
  802ba0:	73 73                	jae    802c15 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802ba2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba6:	74 06                	je     802bae <insert_sorted_with_merge_freeList+0x350>
  802ba8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bac:	75 17                	jne    802bc5 <insert_sorted_with_merge_freeList+0x367>
  802bae:	83 ec 04             	sub    $0x4,%esp
  802bb1:	68 a4 3a 80 00       	push   $0x803aa4
  802bb6:	68 48 01 00 00       	push   $0x148
  802bbb:	68 53 3a 80 00       	push   $0x803a53
  802bc0:	e8 f5 03 00 00       	call   802fba <_panic>
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 10                	mov    (%eax),%edx
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	89 10                	mov    %edx,(%eax)
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	8b 00                	mov    (%eax),%eax
  802bd4:	85 c0                	test   %eax,%eax
  802bd6:	74 0b                	je     802be3 <insert_sorted_with_merge_freeList+0x385>
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 00                	mov    (%eax),%eax
  802bdd:	8b 55 08             	mov    0x8(%ebp),%edx
  802be0:	89 50 04             	mov    %edx,0x4(%eax)
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	8b 55 08             	mov    0x8(%ebp),%edx
  802be9:	89 10                	mov    %edx,(%eax)
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf1:	89 50 04             	mov    %edx,0x4(%eax)
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	75 08                	jne    802c05 <insert_sorted_with_merge_freeList+0x3a7>
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c05:	a1 44 41 80 00       	mov    0x804144,%eax
  802c0a:	40                   	inc    %eax
  802c0b:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802c10:	e9 a2 03 00 00       	jmp    802fb7 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	8b 50 08             	mov    0x8(%eax),%edx
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c21:	01 c2                	add    %eax,%edx
  802c23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c26:	8b 40 08             	mov    0x8(%eax),%eax
  802c29:	39 c2                	cmp    %eax,%edx
  802c2b:	0f 83 ae 00 00 00    	jae    802cdf <insert_sorted_with_merge_freeList+0x481>
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	8b 50 08             	mov    0x8(%eax),%edx
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 48 08             	mov    0x8(%eax),%ecx
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 40 0c             	mov    0xc(%eax),%eax
  802c43:	01 c8                	add    %ecx,%eax
  802c45:	39 c2                	cmp    %eax,%edx
  802c47:	0f 85 92 00 00 00    	jne    802cdf <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 50 0c             	mov    0xc(%eax),%edx
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8b 40 0c             	mov    0xc(%eax),%eax
  802c59:	01 c2                	add    %eax,%edx
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	8b 50 08             	mov    0x8(%eax),%edx
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c7b:	75 17                	jne    802c94 <insert_sorted_with_merge_freeList+0x436>
  802c7d:	83 ec 04             	sub    $0x4,%esp
  802c80:	68 30 3a 80 00       	push   $0x803a30
  802c85:	68 51 01 00 00       	push   $0x151
  802c8a:	68 53 3a 80 00       	push   $0x803a53
  802c8f:	e8 26 03 00 00       	call   802fba <_panic>
  802c94:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	89 10                	mov    %edx,(%eax)
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	8b 00                	mov    (%eax),%eax
  802ca4:	85 c0                	test   %eax,%eax
  802ca6:	74 0d                	je     802cb5 <insert_sorted_with_merge_freeList+0x457>
  802ca8:	a1 48 41 80 00       	mov    0x804148,%eax
  802cad:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb0:	89 50 04             	mov    %edx,0x4(%eax)
  802cb3:	eb 08                	jmp    802cbd <insert_sorted_with_merge_freeList+0x45f>
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	a3 48 41 80 00       	mov    %eax,0x804148
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccf:	a1 54 41 80 00       	mov    0x804154,%eax
  802cd4:	40                   	inc    %eax
  802cd5:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802cda:	e9 d8 02 00 00       	jmp    802fb7 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	8b 50 08             	mov    0x8(%eax),%edx
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ceb:	01 c2                	add    %eax,%edx
  802ced:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf0:	8b 40 08             	mov    0x8(%eax),%eax
  802cf3:	39 c2                	cmp    %eax,%edx
  802cf5:	0f 85 ba 00 00 00    	jne    802db5 <insert_sorted_with_merge_freeList+0x557>
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	8b 50 08             	mov    0x8(%eax),%edx
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 48 08             	mov    0x8(%eax),%ecx
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0d:	01 c8                	add    %ecx,%eax
  802d0f:	39 c2                	cmp    %eax,%edx
  802d11:	0f 86 9e 00 00 00    	jbe    802db5 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802d17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	8b 40 0c             	mov    0xc(%eax),%eax
  802d23:	01 c2                	add    %eax,%edx
  802d25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d28:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	8b 50 08             	mov    0x8(%eax),%edx
  802d31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d34:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	8b 50 08             	mov    0x8(%eax),%edx
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d51:	75 17                	jne    802d6a <insert_sorted_with_merge_freeList+0x50c>
  802d53:	83 ec 04             	sub    $0x4,%esp
  802d56:	68 30 3a 80 00       	push   $0x803a30
  802d5b:	68 5b 01 00 00       	push   $0x15b
  802d60:	68 53 3a 80 00       	push   $0x803a53
  802d65:	e8 50 02 00 00       	call   802fba <_panic>
  802d6a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	89 10                	mov    %edx,(%eax)
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	8b 00                	mov    (%eax),%eax
  802d7a:	85 c0                	test   %eax,%eax
  802d7c:	74 0d                	je     802d8b <insert_sorted_with_merge_freeList+0x52d>
  802d7e:	a1 48 41 80 00       	mov    0x804148,%eax
  802d83:	8b 55 08             	mov    0x8(%ebp),%edx
  802d86:	89 50 04             	mov    %edx,0x4(%eax)
  802d89:	eb 08                	jmp    802d93 <insert_sorted_with_merge_freeList+0x535>
  802d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	a3 48 41 80 00       	mov    %eax,0x804148
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da5:	a1 54 41 80 00       	mov    0x804154,%eax
  802daa:	40                   	inc    %eax
  802dab:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802db0:	e9 02 02 00 00       	jmp    802fb7 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	8b 50 08             	mov    0x8(%eax),%edx
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc1:	01 c2                	add    %eax,%edx
  802dc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc6:	8b 40 08             	mov    0x8(%eax),%eax
  802dc9:	39 c2                	cmp    %eax,%edx
  802dcb:	0f 85 ae 01 00 00    	jne    802f7f <insert_sorted_with_merge_freeList+0x721>
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	8b 50 08             	mov    0x8(%eax),%edx
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 48 08             	mov    0x8(%eax),%ecx
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 40 0c             	mov    0xc(%eax),%eax
  802de3:	01 c8                	add    %ecx,%eax
  802de5:	39 c2                	cmp    %eax,%edx
  802de7:	0f 85 92 01 00 00    	jne    802f7f <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 50 0c             	mov    0xc(%eax),%edx
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	8b 40 0c             	mov    0xc(%eax),%eax
  802df9:	01 c2                	add    %eax,%edx
  802dfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802e01:	01 c2                	add    %eax,%edx
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	8b 50 08             	mov    0x8(%eax),%edx
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802e1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2c:	8b 50 08             	mov    0x8(%eax),%edx
  802e2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e32:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802e35:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e39:	75 17                	jne    802e52 <insert_sorted_with_merge_freeList+0x5f4>
  802e3b:	83 ec 04             	sub    $0x4,%esp
  802e3e:	68 fb 3a 80 00       	push   $0x803afb
  802e43:	68 63 01 00 00       	push   $0x163
  802e48:	68 53 3a 80 00       	push   $0x803a53
  802e4d:	e8 68 01 00 00       	call   802fba <_panic>
  802e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	85 c0                	test   %eax,%eax
  802e59:	74 10                	je     802e6b <insert_sorted_with_merge_freeList+0x60d>
  802e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5e:	8b 00                	mov    (%eax),%eax
  802e60:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e63:	8b 52 04             	mov    0x4(%edx),%edx
  802e66:	89 50 04             	mov    %edx,0x4(%eax)
  802e69:	eb 0b                	jmp    802e76 <insert_sorted_with_merge_freeList+0x618>
  802e6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e6e:	8b 40 04             	mov    0x4(%eax),%eax
  802e71:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e79:	8b 40 04             	mov    0x4(%eax),%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	74 0f                	je     802e8f <insert_sorted_with_merge_freeList+0x631>
  802e80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e83:	8b 40 04             	mov    0x4(%eax),%eax
  802e86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e89:	8b 12                	mov    (%edx),%edx
  802e8b:	89 10                	mov    %edx,(%eax)
  802e8d:	eb 0a                	jmp    802e99 <insert_sorted_with_merge_freeList+0x63b>
  802e8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e92:	8b 00                	mov    (%eax),%eax
  802e94:	a3 38 41 80 00       	mov    %eax,0x804138
  802e99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eac:	a1 44 41 80 00       	mov    0x804144,%eax
  802eb1:	48                   	dec    %eax
  802eb2:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802eb7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ebb:	75 17                	jne    802ed4 <insert_sorted_with_merge_freeList+0x676>
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	68 30 3a 80 00       	push   $0x803a30
  802ec5:	68 64 01 00 00       	push   $0x164
  802eca:	68 53 3a 80 00       	push   $0x803a53
  802ecf:	e8 e6 00 00 00       	call   802fba <_panic>
  802ed4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802edd:	89 10                	mov    %edx,(%eax)
  802edf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	85 c0                	test   %eax,%eax
  802ee6:	74 0d                	je     802ef5 <insert_sorted_with_merge_freeList+0x697>
  802ee8:	a1 48 41 80 00       	mov    0x804148,%eax
  802eed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ef0:	89 50 04             	mov    %edx,0x4(%eax)
  802ef3:	eb 08                	jmp    802efd <insert_sorted_with_merge_freeList+0x69f>
  802ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f00:	a3 48 41 80 00       	mov    %eax,0x804148
  802f05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0f:	a1 54 41 80 00       	mov    0x804154,%eax
  802f14:	40                   	inc    %eax
  802f15:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1e:	75 17                	jne    802f37 <insert_sorted_with_merge_freeList+0x6d9>
  802f20:	83 ec 04             	sub    $0x4,%esp
  802f23:	68 30 3a 80 00       	push   $0x803a30
  802f28:	68 65 01 00 00       	push   $0x165
  802f2d:	68 53 3a 80 00       	push   $0x803a53
  802f32:	e8 83 00 00 00       	call   802fba <_panic>
  802f37:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	89 10                	mov    %edx,(%eax)
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	74 0d                	je     802f58 <insert_sorted_with_merge_freeList+0x6fa>
  802f4b:	a1 48 41 80 00       	mov    0x804148,%eax
  802f50:	8b 55 08             	mov    0x8(%ebp),%edx
  802f53:	89 50 04             	mov    %edx,0x4(%eax)
  802f56:	eb 08                	jmp    802f60 <insert_sorted_with_merge_freeList+0x702>
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	a3 48 41 80 00       	mov    %eax,0x804148
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f72:	a1 54 41 80 00       	mov    0x804154,%eax
  802f77:	40                   	inc    %eax
  802f78:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f7d:	eb 38                	jmp    802fb7 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f7f:	a1 40 41 80 00       	mov    0x804140,%eax
  802f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8b:	74 07                	je     802f94 <insert_sorted_with_merge_freeList+0x736>
  802f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	eb 05                	jmp    802f99 <insert_sorted_with_merge_freeList+0x73b>
  802f94:	b8 00 00 00 00       	mov    $0x0,%eax
  802f99:	a3 40 41 80 00       	mov    %eax,0x804140
  802f9e:	a1 40 41 80 00       	mov    0x804140,%eax
  802fa3:	85 c0                	test   %eax,%eax
  802fa5:	0f 85 a7 fb ff ff    	jne    802b52 <insert_sorted_with_merge_freeList+0x2f4>
  802fab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802faf:	0f 85 9d fb ff ff    	jne    802b52 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802fb5:	eb 00                	jmp    802fb7 <insert_sorted_with_merge_freeList+0x759>
  802fb7:	90                   	nop
  802fb8:	c9                   	leave  
  802fb9:	c3                   	ret    

00802fba <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802fba:	55                   	push   %ebp
  802fbb:	89 e5                	mov    %esp,%ebp
  802fbd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802fc0:	8d 45 10             	lea    0x10(%ebp),%eax
  802fc3:	83 c0 04             	add    $0x4,%eax
  802fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802fc9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	74 16                	je     802fe8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802fd2:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802fd7:	83 ec 08             	sub    $0x8,%esp
  802fda:	50                   	push   %eax
  802fdb:	68 4c 3b 80 00       	push   $0x803b4c
  802fe0:	e8 81 d5 ff ff       	call   800566 <cprintf>
  802fe5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802fe8:	a1 00 40 80 00       	mov    0x804000,%eax
  802fed:	ff 75 0c             	pushl  0xc(%ebp)
  802ff0:	ff 75 08             	pushl  0x8(%ebp)
  802ff3:	50                   	push   %eax
  802ff4:	68 51 3b 80 00       	push   $0x803b51
  802ff9:	e8 68 d5 ff ff       	call   800566 <cprintf>
  802ffe:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803001:	8b 45 10             	mov    0x10(%ebp),%eax
  803004:	83 ec 08             	sub    $0x8,%esp
  803007:	ff 75 f4             	pushl  -0xc(%ebp)
  80300a:	50                   	push   %eax
  80300b:	e8 eb d4 ff ff       	call   8004fb <vcprintf>
  803010:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803013:	83 ec 08             	sub    $0x8,%esp
  803016:	6a 00                	push   $0x0
  803018:	68 6d 3b 80 00       	push   $0x803b6d
  80301d:	e8 d9 d4 ff ff       	call   8004fb <vcprintf>
  803022:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803025:	e8 5a d4 ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  80302a:	eb fe                	jmp    80302a <_panic+0x70>

0080302c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80302c:	55                   	push   %ebp
  80302d:	89 e5                	mov    %esp,%ebp
  80302f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803032:	a1 20 40 80 00       	mov    0x804020,%eax
  803037:	8b 50 74             	mov    0x74(%eax),%edx
  80303a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303d:	39 c2                	cmp    %eax,%edx
  80303f:	74 14                	je     803055 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803041:	83 ec 04             	sub    $0x4,%esp
  803044:	68 70 3b 80 00       	push   $0x803b70
  803049:	6a 26                	push   $0x26
  80304b:	68 bc 3b 80 00       	push   $0x803bbc
  803050:	e8 65 ff ff ff       	call   802fba <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80305c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803063:	e9 c2 00 00 00       	jmp    80312a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	01 d0                	add    %edx,%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	85 c0                	test   %eax,%eax
  80307b:	75 08                	jne    803085 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80307d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803080:	e9 a2 00 00 00       	jmp    803127 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803085:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80308c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803093:	eb 69                	jmp    8030fe <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803095:	a1 20 40 80 00       	mov    0x804020,%eax
  80309a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a3:	89 d0                	mov    %edx,%eax
  8030a5:	01 c0                	add    %eax,%eax
  8030a7:	01 d0                	add    %edx,%eax
  8030a9:	c1 e0 03             	shl    $0x3,%eax
  8030ac:	01 c8                	add    %ecx,%eax
  8030ae:	8a 40 04             	mov    0x4(%eax),%al
  8030b1:	84 c0                	test   %al,%al
  8030b3:	75 46                	jne    8030fb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8030b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8030ba:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c3:	89 d0                	mov    %edx,%eax
  8030c5:	01 c0                	add    %eax,%eax
  8030c7:	01 d0                	add    %edx,%eax
  8030c9:	c1 e0 03             	shl    $0x3,%eax
  8030cc:	01 c8                	add    %ecx,%eax
  8030ce:	8b 00                	mov    (%eax),%eax
  8030d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8030d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8030db:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8030dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	01 c8                	add    %ecx,%eax
  8030ec:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8030ee:	39 c2                	cmp    %eax,%edx
  8030f0:	75 09                	jne    8030fb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8030f2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8030f9:	eb 12                	jmp    80310d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030fb:	ff 45 e8             	incl   -0x18(%ebp)
  8030fe:	a1 20 40 80 00       	mov    0x804020,%eax
  803103:	8b 50 74             	mov    0x74(%eax),%edx
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	39 c2                	cmp    %eax,%edx
  80310b:	77 88                	ja     803095 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80310d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803111:	75 14                	jne    803127 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803113:	83 ec 04             	sub    $0x4,%esp
  803116:	68 c8 3b 80 00       	push   $0x803bc8
  80311b:	6a 3a                	push   $0x3a
  80311d:	68 bc 3b 80 00       	push   $0x803bbc
  803122:	e8 93 fe ff ff       	call   802fba <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803127:	ff 45 f0             	incl   -0x10(%ebp)
  80312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803130:	0f 8c 32 ff ff ff    	jl     803068 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803136:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80313d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803144:	eb 26                	jmp    80316c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803146:	a1 20 40 80 00       	mov    0x804020,%eax
  80314b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803151:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803154:	89 d0                	mov    %edx,%eax
  803156:	01 c0                	add    %eax,%eax
  803158:	01 d0                	add    %edx,%eax
  80315a:	c1 e0 03             	shl    $0x3,%eax
  80315d:	01 c8                	add    %ecx,%eax
  80315f:	8a 40 04             	mov    0x4(%eax),%al
  803162:	3c 01                	cmp    $0x1,%al
  803164:	75 03                	jne    803169 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803166:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803169:	ff 45 e0             	incl   -0x20(%ebp)
  80316c:	a1 20 40 80 00       	mov    0x804020,%eax
  803171:	8b 50 74             	mov    0x74(%eax),%edx
  803174:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803177:	39 c2                	cmp    %eax,%edx
  803179:	77 cb                	ja     803146 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80317b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803181:	74 14                	je     803197 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803183:	83 ec 04             	sub    $0x4,%esp
  803186:	68 1c 3c 80 00       	push   $0x803c1c
  80318b:	6a 44                	push   $0x44
  80318d:	68 bc 3b 80 00       	push   $0x803bbc
  803192:	e8 23 fe ff ff       	call   802fba <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803197:	90                   	nop
  803198:	c9                   	leave  
  803199:	c3                   	ret    
  80319a:	66 90                	xchg   %ax,%ax

0080319c <__udivdi3>:
  80319c:	55                   	push   %ebp
  80319d:	57                   	push   %edi
  80319e:	56                   	push   %esi
  80319f:	53                   	push   %ebx
  8031a0:	83 ec 1c             	sub    $0x1c,%esp
  8031a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031b3:	89 ca                	mov    %ecx,%edx
  8031b5:	89 f8                	mov    %edi,%eax
  8031b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031bb:	85 f6                	test   %esi,%esi
  8031bd:	75 2d                	jne    8031ec <__udivdi3+0x50>
  8031bf:	39 cf                	cmp    %ecx,%edi
  8031c1:	77 65                	ja     803228 <__udivdi3+0x8c>
  8031c3:	89 fd                	mov    %edi,%ebp
  8031c5:	85 ff                	test   %edi,%edi
  8031c7:	75 0b                	jne    8031d4 <__udivdi3+0x38>
  8031c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ce:	31 d2                	xor    %edx,%edx
  8031d0:	f7 f7                	div    %edi
  8031d2:	89 c5                	mov    %eax,%ebp
  8031d4:	31 d2                	xor    %edx,%edx
  8031d6:	89 c8                	mov    %ecx,%eax
  8031d8:	f7 f5                	div    %ebp
  8031da:	89 c1                	mov    %eax,%ecx
  8031dc:	89 d8                	mov    %ebx,%eax
  8031de:	f7 f5                	div    %ebp
  8031e0:	89 cf                	mov    %ecx,%edi
  8031e2:	89 fa                	mov    %edi,%edx
  8031e4:	83 c4 1c             	add    $0x1c,%esp
  8031e7:	5b                   	pop    %ebx
  8031e8:	5e                   	pop    %esi
  8031e9:	5f                   	pop    %edi
  8031ea:	5d                   	pop    %ebp
  8031eb:	c3                   	ret    
  8031ec:	39 ce                	cmp    %ecx,%esi
  8031ee:	77 28                	ja     803218 <__udivdi3+0x7c>
  8031f0:	0f bd fe             	bsr    %esi,%edi
  8031f3:	83 f7 1f             	xor    $0x1f,%edi
  8031f6:	75 40                	jne    803238 <__udivdi3+0x9c>
  8031f8:	39 ce                	cmp    %ecx,%esi
  8031fa:	72 0a                	jb     803206 <__udivdi3+0x6a>
  8031fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803200:	0f 87 9e 00 00 00    	ja     8032a4 <__udivdi3+0x108>
  803206:	b8 01 00 00 00       	mov    $0x1,%eax
  80320b:	89 fa                	mov    %edi,%edx
  80320d:	83 c4 1c             	add    $0x1c,%esp
  803210:	5b                   	pop    %ebx
  803211:	5e                   	pop    %esi
  803212:	5f                   	pop    %edi
  803213:	5d                   	pop    %ebp
  803214:	c3                   	ret    
  803215:	8d 76 00             	lea    0x0(%esi),%esi
  803218:	31 ff                	xor    %edi,%edi
  80321a:	31 c0                	xor    %eax,%eax
  80321c:	89 fa                	mov    %edi,%edx
  80321e:	83 c4 1c             	add    $0x1c,%esp
  803221:	5b                   	pop    %ebx
  803222:	5e                   	pop    %esi
  803223:	5f                   	pop    %edi
  803224:	5d                   	pop    %ebp
  803225:	c3                   	ret    
  803226:	66 90                	xchg   %ax,%ax
  803228:	89 d8                	mov    %ebx,%eax
  80322a:	f7 f7                	div    %edi
  80322c:	31 ff                	xor    %edi,%edi
  80322e:	89 fa                	mov    %edi,%edx
  803230:	83 c4 1c             	add    $0x1c,%esp
  803233:	5b                   	pop    %ebx
  803234:	5e                   	pop    %esi
  803235:	5f                   	pop    %edi
  803236:	5d                   	pop    %ebp
  803237:	c3                   	ret    
  803238:	bd 20 00 00 00       	mov    $0x20,%ebp
  80323d:	89 eb                	mov    %ebp,%ebx
  80323f:	29 fb                	sub    %edi,%ebx
  803241:	89 f9                	mov    %edi,%ecx
  803243:	d3 e6                	shl    %cl,%esi
  803245:	89 c5                	mov    %eax,%ebp
  803247:	88 d9                	mov    %bl,%cl
  803249:	d3 ed                	shr    %cl,%ebp
  80324b:	89 e9                	mov    %ebp,%ecx
  80324d:	09 f1                	or     %esi,%ecx
  80324f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803253:	89 f9                	mov    %edi,%ecx
  803255:	d3 e0                	shl    %cl,%eax
  803257:	89 c5                	mov    %eax,%ebp
  803259:	89 d6                	mov    %edx,%esi
  80325b:	88 d9                	mov    %bl,%cl
  80325d:	d3 ee                	shr    %cl,%esi
  80325f:	89 f9                	mov    %edi,%ecx
  803261:	d3 e2                	shl    %cl,%edx
  803263:	8b 44 24 08          	mov    0x8(%esp),%eax
  803267:	88 d9                	mov    %bl,%cl
  803269:	d3 e8                	shr    %cl,%eax
  80326b:	09 c2                	or     %eax,%edx
  80326d:	89 d0                	mov    %edx,%eax
  80326f:	89 f2                	mov    %esi,%edx
  803271:	f7 74 24 0c          	divl   0xc(%esp)
  803275:	89 d6                	mov    %edx,%esi
  803277:	89 c3                	mov    %eax,%ebx
  803279:	f7 e5                	mul    %ebp
  80327b:	39 d6                	cmp    %edx,%esi
  80327d:	72 19                	jb     803298 <__udivdi3+0xfc>
  80327f:	74 0b                	je     80328c <__udivdi3+0xf0>
  803281:	89 d8                	mov    %ebx,%eax
  803283:	31 ff                	xor    %edi,%edi
  803285:	e9 58 ff ff ff       	jmp    8031e2 <__udivdi3+0x46>
  80328a:	66 90                	xchg   %ax,%ax
  80328c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803290:	89 f9                	mov    %edi,%ecx
  803292:	d3 e2                	shl    %cl,%edx
  803294:	39 c2                	cmp    %eax,%edx
  803296:	73 e9                	jae    803281 <__udivdi3+0xe5>
  803298:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80329b:	31 ff                	xor    %edi,%edi
  80329d:	e9 40 ff ff ff       	jmp    8031e2 <__udivdi3+0x46>
  8032a2:	66 90                	xchg   %ax,%ax
  8032a4:	31 c0                	xor    %eax,%eax
  8032a6:	e9 37 ff ff ff       	jmp    8031e2 <__udivdi3+0x46>
  8032ab:	90                   	nop

008032ac <__umoddi3>:
  8032ac:	55                   	push   %ebp
  8032ad:	57                   	push   %edi
  8032ae:	56                   	push   %esi
  8032af:	53                   	push   %ebx
  8032b0:	83 ec 1c             	sub    $0x1c,%esp
  8032b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032cb:	89 f3                	mov    %esi,%ebx
  8032cd:	89 fa                	mov    %edi,%edx
  8032cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032d3:	89 34 24             	mov    %esi,(%esp)
  8032d6:	85 c0                	test   %eax,%eax
  8032d8:	75 1a                	jne    8032f4 <__umoddi3+0x48>
  8032da:	39 f7                	cmp    %esi,%edi
  8032dc:	0f 86 a2 00 00 00    	jbe    803384 <__umoddi3+0xd8>
  8032e2:	89 c8                	mov    %ecx,%eax
  8032e4:	89 f2                	mov    %esi,%edx
  8032e6:	f7 f7                	div    %edi
  8032e8:	89 d0                	mov    %edx,%eax
  8032ea:	31 d2                	xor    %edx,%edx
  8032ec:	83 c4 1c             	add    $0x1c,%esp
  8032ef:	5b                   	pop    %ebx
  8032f0:	5e                   	pop    %esi
  8032f1:	5f                   	pop    %edi
  8032f2:	5d                   	pop    %ebp
  8032f3:	c3                   	ret    
  8032f4:	39 f0                	cmp    %esi,%eax
  8032f6:	0f 87 ac 00 00 00    	ja     8033a8 <__umoddi3+0xfc>
  8032fc:	0f bd e8             	bsr    %eax,%ebp
  8032ff:	83 f5 1f             	xor    $0x1f,%ebp
  803302:	0f 84 ac 00 00 00    	je     8033b4 <__umoddi3+0x108>
  803308:	bf 20 00 00 00       	mov    $0x20,%edi
  80330d:	29 ef                	sub    %ebp,%edi
  80330f:	89 fe                	mov    %edi,%esi
  803311:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803315:	89 e9                	mov    %ebp,%ecx
  803317:	d3 e0                	shl    %cl,%eax
  803319:	89 d7                	mov    %edx,%edi
  80331b:	89 f1                	mov    %esi,%ecx
  80331d:	d3 ef                	shr    %cl,%edi
  80331f:	09 c7                	or     %eax,%edi
  803321:	89 e9                	mov    %ebp,%ecx
  803323:	d3 e2                	shl    %cl,%edx
  803325:	89 14 24             	mov    %edx,(%esp)
  803328:	89 d8                	mov    %ebx,%eax
  80332a:	d3 e0                	shl    %cl,%eax
  80332c:	89 c2                	mov    %eax,%edx
  80332e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803332:	d3 e0                	shl    %cl,%eax
  803334:	89 44 24 04          	mov    %eax,0x4(%esp)
  803338:	8b 44 24 08          	mov    0x8(%esp),%eax
  80333c:	89 f1                	mov    %esi,%ecx
  80333e:	d3 e8                	shr    %cl,%eax
  803340:	09 d0                	or     %edx,%eax
  803342:	d3 eb                	shr    %cl,%ebx
  803344:	89 da                	mov    %ebx,%edx
  803346:	f7 f7                	div    %edi
  803348:	89 d3                	mov    %edx,%ebx
  80334a:	f7 24 24             	mull   (%esp)
  80334d:	89 c6                	mov    %eax,%esi
  80334f:	89 d1                	mov    %edx,%ecx
  803351:	39 d3                	cmp    %edx,%ebx
  803353:	0f 82 87 00 00 00    	jb     8033e0 <__umoddi3+0x134>
  803359:	0f 84 91 00 00 00    	je     8033f0 <__umoddi3+0x144>
  80335f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803363:	29 f2                	sub    %esi,%edx
  803365:	19 cb                	sbb    %ecx,%ebx
  803367:	89 d8                	mov    %ebx,%eax
  803369:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80336d:	d3 e0                	shl    %cl,%eax
  80336f:	89 e9                	mov    %ebp,%ecx
  803371:	d3 ea                	shr    %cl,%edx
  803373:	09 d0                	or     %edx,%eax
  803375:	89 e9                	mov    %ebp,%ecx
  803377:	d3 eb                	shr    %cl,%ebx
  803379:	89 da                	mov    %ebx,%edx
  80337b:	83 c4 1c             	add    $0x1c,%esp
  80337e:	5b                   	pop    %ebx
  80337f:	5e                   	pop    %esi
  803380:	5f                   	pop    %edi
  803381:	5d                   	pop    %ebp
  803382:	c3                   	ret    
  803383:	90                   	nop
  803384:	89 fd                	mov    %edi,%ebp
  803386:	85 ff                	test   %edi,%edi
  803388:	75 0b                	jne    803395 <__umoddi3+0xe9>
  80338a:	b8 01 00 00 00       	mov    $0x1,%eax
  80338f:	31 d2                	xor    %edx,%edx
  803391:	f7 f7                	div    %edi
  803393:	89 c5                	mov    %eax,%ebp
  803395:	89 f0                	mov    %esi,%eax
  803397:	31 d2                	xor    %edx,%edx
  803399:	f7 f5                	div    %ebp
  80339b:	89 c8                	mov    %ecx,%eax
  80339d:	f7 f5                	div    %ebp
  80339f:	89 d0                	mov    %edx,%eax
  8033a1:	e9 44 ff ff ff       	jmp    8032ea <__umoddi3+0x3e>
  8033a6:	66 90                	xchg   %ax,%ax
  8033a8:	89 c8                	mov    %ecx,%eax
  8033aa:	89 f2                	mov    %esi,%edx
  8033ac:	83 c4 1c             	add    $0x1c,%esp
  8033af:	5b                   	pop    %ebx
  8033b0:	5e                   	pop    %esi
  8033b1:	5f                   	pop    %edi
  8033b2:	5d                   	pop    %ebp
  8033b3:	c3                   	ret    
  8033b4:	3b 04 24             	cmp    (%esp),%eax
  8033b7:	72 06                	jb     8033bf <__umoddi3+0x113>
  8033b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033bd:	77 0f                	ja     8033ce <__umoddi3+0x122>
  8033bf:	89 f2                	mov    %esi,%edx
  8033c1:	29 f9                	sub    %edi,%ecx
  8033c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033c7:	89 14 24             	mov    %edx,(%esp)
  8033ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033d2:	8b 14 24             	mov    (%esp),%edx
  8033d5:	83 c4 1c             	add    $0x1c,%esp
  8033d8:	5b                   	pop    %ebx
  8033d9:	5e                   	pop    %esi
  8033da:	5f                   	pop    %edi
  8033db:	5d                   	pop    %ebp
  8033dc:	c3                   	ret    
  8033dd:	8d 76 00             	lea    0x0(%esi),%esi
  8033e0:	2b 04 24             	sub    (%esp),%eax
  8033e3:	19 fa                	sbb    %edi,%edx
  8033e5:	89 d1                	mov    %edx,%ecx
  8033e7:	89 c6                	mov    %eax,%esi
  8033e9:	e9 71 ff ff ff       	jmp    80335f <__umoddi3+0xb3>
  8033ee:	66 90                	xchg   %ax,%ax
  8033f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033f4:	72 ea                	jb     8033e0 <__umoddi3+0x134>
  8033f6:	89 d9                	mov    %ebx,%ecx
  8033f8:	e9 62 ff ff ff       	jmp    80335f <__umoddi3+0xb3>
