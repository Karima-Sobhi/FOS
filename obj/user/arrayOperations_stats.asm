
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 f7 04 00 00       	call   80052d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 1b 1d 00 00       	call   801d5e <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 45 1d 00 00       	call   801d90 <sys_getparentenvid>
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
  80005f:	68 e0 35 80 00       	push   $0x8035e0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 f5 17 00 00       	call   801861 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e4 35 80 00       	push   $0x8035e4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 df 17 00 00       	call   801861 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ec 35 80 00       	push   $0x8035ec
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 c2 17 00 00       	call   801861 <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 fa 35 80 00       	push   $0x8035fa
  8000b8:	e8 fb 16 00 00       	call   8017b8 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		tmpArray[i] = sharedArray[i];
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

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8d 55 b4             	lea    -0x4c(%ebp),%edx
  800106:	52                   	push   %edx
  800107:	8d 55 b8             	lea    -0x48(%ebp),%edx
  80010a:	52                   	push   %edx
  80010b:	8d 55 bc             	lea    -0x44(%ebp),%edx
  80010e:	52                   	push   %edx
  80010f:	8d 55 c0             	lea    -0x40(%ebp),%edx
  800112:	52                   	push   %edx
  800113:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	ff 75 dc             	pushl  -0x24(%ebp)
  80011b:	e8 55 02 00 00       	call   800375 <ArrayStats>
  800120:	83 c4 20             	add    $0x20,%esp
	cprintf("Stats Calculations are Finished!!!!\n") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 04 36 80 00       	push   $0x803604
  80012b:	e8 0d 06 00 00       	call   80073d <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 29 36 80 00       	push   $0x803629
  80013f:	e8 74 16 00 00       	call   8017b8 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 2e 36 80 00       	push   $0x80362e
  80015e:	e8 55 16 00 00       	call   8017b8 <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 32 36 80 00       	push   $0x803632
  80017d:	e8 36 16 00 00       	call   8017b8 <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 36 36 80 00       	push   $0x803636
  80019c:	e8 17 16 00 00       	call   8017b8 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 3a 36 80 00       	push   $0x80363a
  8001bb:	e8 f8 15 00 00       	call   8017b8 <smalloc>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001c6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001cc:	89 10                	mov    %edx,(%eax)

	(*finishedCount)++ ;
  8001ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	8d 50 01             	lea    0x1(%eax),%edx
  8001d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)

}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  8001e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	48                   	dec    %eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	6a 00                	push   $0x0
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 05 00 00 00       	call   800205 <QSort>
  800200:	83 c4 20             	add    $0x20,%esp
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  80020b:	8b 45 10             	mov    0x10(%ebp),%eax
  80020e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800211:	7c 16                	jl     800229 <QSort+0x24>
  800213:	8b 45 14             	mov    0x14(%ebp),%eax
  800216:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	01 d0                	add    %edx,%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	e9 4a 01 00 00       	jmp    800373 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  800229:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 8e 1b 00 00       	call   801dc3 <sys_get_virtual_time>
  800235:	83 c4 0c             	add    $0xc,%esp
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 55 14             	mov    0x14(%ebp),%edx
  80023e:	2b 55 10             	sub    0x10(%ebp),%edx
  800241:	89 d1                	mov    %edx,%ecx
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 f1                	div    %ecx
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 ec             	pushl  -0x14(%ebp)
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 77 02 00 00       	call   8004da <Swap>
  800263:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800273:	e9 80 00 00 00       	jmp    8002f8 <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800278:	ff 45 f4             	incl   -0xc(%ebp)
  80027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	7f 2b                	jg     8002ae <QSort+0xa9>
  800283:	8b 45 10             	mov    0x10(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800297:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	01 c8                	add    %ecx,%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	39 c2                	cmp    %eax,%edx
  8002a7:	7d cf                	jge    800278 <QSort+0x73>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002a9:	eb 03                	jmp    8002ae <QSort+0xa9>
  8002ab:	ff 4d f0             	decl   -0x10(%ebp)
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002b4:	7e 26                	jle    8002dc <QSort+0xd7>
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 c8                	add    %ecx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	7e cf                	jle    8002ab <QSort+0xa6>

		if (i <= j)
  8002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e2:	7f 14                	jg     8002f8 <QSort+0xf3>
		{
			Swap(Elements, i, j);
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 e5 01 00 00       	call   8004da <Swap>
  8002f5:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fe:	0f 8e 77 ff ff ff    	jle    80027b <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	ff 75 10             	pushl  0x10(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 c5 01 00 00       	call   8004da <Swap>
  800315:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  800318:	8b 45 18             	mov    0x18(%ebp),%eax
  80031b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031e:	75 13                	jne    800333 <QSort+0x12e>
		return Elements[kIndex] ;
  800320:	8b 45 18             	mov    0x18(%ebp),%eax
  800323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	eb 40                	jmp    800373 <QSort+0x16e>
	else if (kIndex < j)
  800333:	8b 45 18             	mov    0x18(%ebp),%eax
  800336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800339:	7d 1e                	jge    800359 <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033e:	48                   	dec    %eax
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 18             	pushl  0x18(%ebp)
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 b1 fe ff ff       	call   800205 <QSort>
  800354:	83 c4 20             	add    $0x20,%esp
  800357:	eb 1a                	jmp    800373 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 18             	pushl  0x18(%ebp)
  80035f:	ff 75 14             	pushl  0x14(%ebp)
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 95 fe ff ff       	call   800205 <QSort>
  800370:	83 c4 20             	add    $0x20,%esp
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	53                   	push   %ebx
  800379:	83 ec 14             	sub    $0x14,%esp
	int i ;
	*mean =0 ;
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*min = 0x7FFFFFFF ;
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  80038e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800391:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80039e:	e9 80 00 00 00       	jmp    800423 <ArrayStats+0xae>
	{
		(*mean) += Elements[i];
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	01 c2                	add    %eax,%edx
  8003bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
		if (Elements[i] < (*min))
  8003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	7d 16                	jge    8003f0 <ArrayStats+0x7b>
		{
			(*min) = Elements[i];
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8003f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	7e 16                	jle    800420 <ArrayStats+0xab>
		{
			(*max) = Elements[i];
  80040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 f4             	incl   -0xc(%ebp)
  800423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	0f 8c 74 ff ff ff    	jl     8003a3 <ArrayStats+0x2e>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	89 c2                	mov    %eax,%edx
  800434:	c1 ea 1f             	shr    $0x1f,%edx
  800437:	01 d0                	add    %edx,%eax
  800439:	d1 f8                	sar    %eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	50                   	push   %eax
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	e8 94 fd ff ff       	call   8001de <KthElement>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	8b 45 20             	mov    0x20(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	f7 7d 0c             	idivl  0xc(%ebp)
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
	(*var) = 0;
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80046d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800474:	eb 46                	jmp    8004bc <ArrayStats+0x147>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c8                	add    %ecx,%eax
  80048a:	8b 08                	mov    (%eax),%ecx
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 cb                	mov    %ecx,%ebx
  800493:	29 c3                	sub    %eax,%ebx
  800495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800498:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 08                	mov    (%eax),%ecx
  8004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	29 c1                	sub    %eax,%ecx
  8004ad:	89 c8                	mov    %ecx,%eax
  8004af:	0f af c3             	imul   %ebx,%eax
  8004b2:	01 c2                	add    %eax,%edx
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b9:	ff 45 f4             	incl   -0xc(%ebp)
  8004bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c2:	7c b2                	jl     800476 <ArrayStats+0x101>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
	}
	(*var) /= NumOfElements;
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	f7 7d 0c             	idivl  0xc(%ebp)
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
}
  8004d4:	90                   	nop
  8004d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 c2                	add    %eax,%edx
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	01 c8                	add    %ecx,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800516:	8b 45 10             	mov    0x10(%ebp),%eax
  800519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c2                	add    %eax,%edx
  800525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800528:	89 02                	mov    %eax,(%edx)
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800533:	e8 3f 18 00 00       	call   801d77 <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 03             	shl    $0x3,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800550:	01 d0                	add    %edx,%eax
  800552:	c1 e0 04             	shl    $0x4,%eax
  800555:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80055a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80055f:	a1 20 40 80 00       	mov    0x804020,%eax
  800564:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80056a:	84 c0                	test   %al,%al
  80056c:	74 0f                	je     80057d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80056e:	a1 20 40 80 00       	mov    0x804020,%eax
  800573:	05 5c 05 00 00       	add    $0x55c,%eax
  800578:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80057d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800581:	7e 0a                	jle    80058d <libmain+0x60>
		binaryname = argv[0];
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 0c             	pushl  0xc(%ebp)
  800593:	ff 75 08             	pushl  0x8(%ebp)
  800596:	e8 9d fa ff ff       	call   800038 <_main>
  80059b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80059e:	e8 e1 15 00 00       	call   801b84 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	68 58 36 80 00       	push   $0x803658
  8005ab:	e8 8d 01 00 00       	call   80073d <cprintf>
  8005b0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8005be:	a1 20 40 80 00       	mov    0x804020,%eax
  8005c3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	52                   	push   %edx
  8005cd:	50                   	push   %eax
  8005ce:	68 80 36 80 00       	push   $0x803680
  8005d3:	e8 65 01 00 00       	call   80073d <cprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005db:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8005e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005eb:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8005f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8005fc:	51                   	push   %ecx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	68 a8 36 80 00       	push   $0x8036a8
  800604:	e8 34 01 00 00       	call   80073d <cprintf>
  800609:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060c:	a1 20 40 80 00       	mov    0x804020,%eax
  800611:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	50                   	push   %eax
  80061b:	68 00 37 80 00       	push   $0x803700
  800620:	e8 18 01 00 00       	call   80073d <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800628:	83 ec 0c             	sub    $0xc,%esp
  80062b:	68 58 36 80 00       	push   $0x803658
  800630:	e8 08 01 00 00       	call   80073d <cprintf>
  800635:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800638:	e8 61 15 00 00       	call   801b9e <sys_enable_interrupt>

	// exit gracefully
	exit();
  80063d:	e8 19 00 00 00       	call   80065b <exit>
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	6a 00                	push   $0x0
  800650:	e8 ee 16 00 00       	call   801d43 <sys_destroy_env>
  800655:	83 c4 10             	add    $0x10,%esp
}
  800658:	90                   	nop
  800659:	c9                   	leave  
  80065a:	c3                   	ret    

0080065b <exit>:

void
exit(void)
{
  80065b:	55                   	push   %ebp
  80065c:	89 e5                	mov    %esp,%ebp
  80065e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800661:	e8 43 17 00 00       	call   801da9 <sys_exit_env>
}
  800666:	90                   	nop
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	8d 48 01             	lea    0x1(%eax),%ecx
  800677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067a:	89 0a                	mov    %ecx,(%edx)
  80067c:	8b 55 08             	mov    0x8(%ebp),%edx
  80067f:	88 d1                	mov    %dl,%cl
  800681:	8b 55 0c             	mov    0xc(%ebp),%edx
  800684:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800692:	75 2c                	jne    8006c0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800694:	a0 24 40 80 00       	mov    0x804024,%al
  800699:	0f b6 c0             	movzbl %al,%eax
  80069c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069f:	8b 12                	mov    (%edx),%edx
  8006a1:	89 d1                	mov    %edx,%ecx
  8006a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a6:	83 c2 08             	add    $0x8,%edx
  8006a9:	83 ec 04             	sub    $0x4,%esp
  8006ac:	50                   	push   %eax
  8006ad:	51                   	push   %ecx
  8006ae:	52                   	push   %edx
  8006af:	e8 22 13 00 00       	call   8019d6 <sys_cputs>
  8006b4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	8b 40 04             	mov    0x4(%eax),%eax
  8006c6:	8d 50 01             	lea    0x1(%eax),%edx
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e2:	00 00 00 
	b.cnt = 0;
  8006e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ec:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ef:	ff 75 0c             	pushl  0xc(%ebp)
  8006f2:	ff 75 08             	pushl  0x8(%ebp)
  8006f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fb:	50                   	push   %eax
  8006fc:	68 69 06 80 00       	push   $0x800669
  800701:	e8 11 02 00 00       	call   800917 <vprintfmt>
  800706:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800709:	a0 24 40 80 00       	mov    0x804024,%al
  80070e:	0f b6 c0             	movzbl %al,%eax
  800711:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	50                   	push   %eax
  80071b:	52                   	push   %edx
  80071c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800722:	83 c0 08             	add    $0x8,%eax
  800725:	50                   	push   %eax
  800726:	e8 ab 12 00 00       	call   8019d6 <sys_cputs>
  80072b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80072e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800735:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <cprintf>:

int cprintf(const char *fmt, ...) {
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800743:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80074a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 f4             	pushl  -0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	e8 73 ff ff ff       	call   8006d2 <vcprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800765:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800770:	e8 0f 14 00 00       	call   801b84 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800775:	8d 45 0c             	lea    0xc(%ebp),%eax
  800778:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	ff 75 f4             	pushl  -0xc(%ebp)
  800784:	50                   	push   %eax
  800785:	e8 48 ff ff ff       	call   8006d2 <vcprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800790:	e8 09 14 00 00       	call   801b9e <sys_enable_interrupt>
	return cnt;
  800795:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	53                   	push   %ebx
  80079e:	83 ec 14             	sub    $0x14,%esp
  8007a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ad:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b8:	77 55                	ja     80080f <printnum+0x75>
  8007ba:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007bd:	72 05                	jb     8007c4 <printnum+0x2a>
  8007bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c2:	77 4b                	ja     80080f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d2:	52                   	push   %edx
  8007d3:	50                   	push   %eax
  8007d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007da:	e8 95 2b 00 00       	call   803374 <__udivdi3>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	83 ec 04             	sub    $0x4,%esp
  8007e5:	ff 75 20             	pushl  0x20(%ebp)
  8007e8:	53                   	push   %ebx
  8007e9:	ff 75 18             	pushl  0x18(%ebp)
  8007ec:	52                   	push   %edx
  8007ed:	50                   	push   %eax
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	ff 75 08             	pushl  0x8(%ebp)
  8007f4:	e8 a1 ff ff ff       	call   80079a <printnum>
  8007f9:	83 c4 20             	add    $0x20,%esp
  8007fc:	eb 1a                	jmp    800818 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	ff 75 20             	pushl  0x20(%ebp)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080f:	ff 4d 1c             	decl   0x1c(%ebp)
  800812:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800816:	7f e6                	jg     8007fe <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800818:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800826:	53                   	push   %ebx
  800827:	51                   	push   %ecx
  800828:	52                   	push   %edx
  800829:	50                   	push   %eax
  80082a:	e8 55 2c 00 00       	call   803484 <__umoddi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	05 34 39 80 00       	add    $0x803934,%eax
  800837:	8a 00                	mov    (%eax),%al
  800839:	0f be c0             	movsbl %al,%eax
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	50                   	push   %eax
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
}
  80084b:	90                   	nop
  80084c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800854:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800858:	7e 1c                	jle    800876 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8d 50 08             	lea    0x8(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 10                	mov    %edx,(%eax)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	83 e8 08             	sub    $0x8,%eax
  80086f:	8b 50 04             	mov    0x4(%eax),%edx
  800872:	8b 00                	mov    (%eax),%eax
  800874:	eb 40                	jmp    8008b6 <getuint+0x65>
	else if (lflag)
  800876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087a:	74 1e                	je     80089a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	89 10                	mov    %edx,(%eax)
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	eb 1c                	jmp    8008b6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008bf:	7e 1c                	jle    8008dd <getint+0x25>
		return va_arg(*ap, long long);
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	8d 50 08             	lea    0x8(%eax),%edx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	89 10                	mov    %edx,(%eax)
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 e8 08             	sub    $0x8,%eax
  8008d6:	8b 50 04             	mov    0x4(%eax),%edx
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	eb 38                	jmp    800915 <getint+0x5d>
	else if (lflag)
  8008dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e1:	74 1a                	je     8008fd <getint+0x45>
		return va_arg(*ap, long);
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	8d 50 04             	lea    0x4(%eax),%edx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	89 10                	mov    %edx,(%eax)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 e8 04             	sub    $0x4,%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	99                   	cltd   
  8008fb:	eb 18                	jmp    800915 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	8d 50 04             	lea    0x4(%eax),%edx
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	89 10                	mov    %edx,(%eax)
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	99                   	cltd   
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091f:	eb 17                	jmp    800938 <vprintfmt+0x21>
			if (ch == '\0')
  800921:	85 db                	test   %ebx,%ebx
  800923:	0f 84 af 03 00 00    	je     800cd8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	53                   	push   %ebx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800938:	8b 45 10             	mov    0x10(%ebp),%eax
  80093b:	8d 50 01             	lea    0x1(%eax),%edx
  80093e:	89 55 10             	mov    %edx,0x10(%ebp)
  800941:	8a 00                	mov    (%eax),%al
  800943:	0f b6 d8             	movzbl %al,%ebx
  800946:	83 fb 25             	cmp    $0x25,%ebx
  800949:	75 d6                	jne    800921 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80094f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800956:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800964:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096b:	8b 45 10             	mov    0x10(%ebp),%eax
  80096e:	8d 50 01             	lea    0x1(%eax),%edx
  800971:	89 55 10             	mov    %edx,0x10(%ebp)
  800974:	8a 00                	mov    (%eax),%al
  800976:	0f b6 d8             	movzbl %al,%ebx
  800979:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097c:	83 f8 55             	cmp    $0x55,%eax
  80097f:	0f 87 2b 03 00 00    	ja     800cb0 <vprintfmt+0x399>
  800985:	8b 04 85 58 39 80 00 	mov    0x803958(,%eax,4),%eax
  80098c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80098e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800992:	eb d7                	jmp    80096b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800994:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800998:	eb d1                	jmp    80096b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	c1 e0 02             	shl    $0x2,%eax
  8009a9:	01 d0                	add    %edx,%eax
  8009ab:	01 c0                	add    %eax,%eax
  8009ad:	01 d8                	add    %ebx,%eax
  8009af:	83 e8 30             	sub    $0x30,%eax
  8009b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b8:	8a 00                	mov    (%eax),%al
  8009ba:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009bd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c0:	7e 3e                	jle    800a00 <vprintfmt+0xe9>
  8009c2:	83 fb 39             	cmp    $0x39,%ebx
  8009c5:	7f 39                	jg     800a00 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ca:	eb d5                	jmp    8009a1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	83 c0 04             	add    $0x4,%eax
  8009d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 e8 04             	sub    $0x4,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e0:	eb 1f                	jmp    800a01 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e6:	79 83                	jns    80096b <vprintfmt+0x54>
				width = 0;
  8009e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ef:	e9 77 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fb:	e9 6b ff ff ff       	jmp    80096b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a00:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a05:	0f 89 60 ff ff ff    	jns    80096b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a18:	e9 4e ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a20:	e9 46 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	50                   	push   %eax
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	ff d0                	call   *%eax
  800a42:	83 c4 10             	add    $0x10,%esp
			break;
  800a45:	e9 89 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 c0 04             	add    $0x4,%eax
  800a50:	89 45 14             	mov    %eax,0x14(%ebp)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 e8 04             	sub    $0x4,%eax
  800a59:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5b:	85 db                	test   %ebx,%ebx
  800a5d:	79 02                	jns    800a61 <vprintfmt+0x14a>
				err = -err;
  800a5f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a61:	83 fb 64             	cmp    $0x64,%ebx
  800a64:	7f 0b                	jg     800a71 <vprintfmt+0x15a>
  800a66:	8b 34 9d a0 37 80 00 	mov    0x8037a0(,%ebx,4),%esi
  800a6d:	85 f6                	test   %esi,%esi
  800a6f:	75 19                	jne    800a8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a71:	53                   	push   %ebx
  800a72:	68 45 39 80 00       	push   $0x803945
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 5e 02 00 00       	call   800ce0 <printfmt>
  800a82:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a85:	e9 49 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8a:	56                   	push   %esi
  800a8b:	68 4e 39 80 00       	push   $0x80394e
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	ff 75 08             	pushl  0x8(%ebp)
  800a96:	e8 45 02 00 00       	call   800ce0 <printfmt>
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 30 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 c0 04             	add    $0x4,%eax
  800aa9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 e8 04             	sub    $0x4,%eax
  800ab2:	8b 30                	mov    (%eax),%esi
  800ab4:	85 f6                	test   %esi,%esi
  800ab6:	75 05                	jne    800abd <vprintfmt+0x1a6>
				p = "(null)";
  800ab8:	be 51 39 80 00       	mov    $0x803951,%esi
			if (width > 0 && padc != '-')
  800abd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac1:	7e 6d                	jle    800b30 <vprintfmt+0x219>
  800ac3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac7:	74 67                	je     800b30 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	50                   	push   %eax
  800ad0:	56                   	push   %esi
  800ad1:	e8 0c 03 00 00       	call   800de2 <strnlen>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800adc:	eb 16                	jmp    800af4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ade:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af1:	ff 4d e4             	decl   -0x1c(%ebp)
  800af4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af8:	7f e4                	jg     800ade <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afa:	eb 34                	jmp    800b30 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b00:	74 1c                	je     800b1e <vprintfmt+0x207>
  800b02:	83 fb 1f             	cmp    $0x1f,%ebx
  800b05:	7e 05                	jle    800b0c <vprintfmt+0x1f5>
  800b07:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0a:	7e 12                	jle    800b1e <vprintfmt+0x207>
					putch('?', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 3f                	push   $0x3f
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	eb 0f                	jmp    800b2d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	53                   	push   %ebx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b30:	89 f0                	mov    %esi,%eax
  800b32:	8d 70 01             	lea    0x1(%eax),%esi
  800b35:	8a 00                	mov    (%eax),%al
  800b37:	0f be d8             	movsbl %al,%ebx
  800b3a:	85 db                	test   %ebx,%ebx
  800b3c:	74 24                	je     800b62 <vprintfmt+0x24b>
  800b3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b42:	78 b8                	js     800afc <vprintfmt+0x1e5>
  800b44:	ff 4d e0             	decl   -0x20(%ebp)
  800b47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4b:	79 af                	jns    800afc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4d:	eb 13                	jmp    800b62 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	6a 20                	push   $0x20
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b66:	7f e7                	jg     800b4f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b68:	e9 66 01 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 e8             	pushl  -0x18(%ebp)
  800b73:	8d 45 14             	lea    0x14(%ebp),%eax
  800b76:	50                   	push   %eax
  800b77:	e8 3c fd ff ff       	call   8008b8 <getint>
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8b:	85 d2                	test   %edx,%edx
  800b8d:	79 23                	jns    800bb2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	6a 2d                	push   $0x2d
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba5:	f7 d8                	neg    %eax
  800ba7:	83 d2 00             	adc    $0x0,%edx
  800baa:	f7 da                	neg    %edx
  800bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb9:	e9 bc 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc7:	50                   	push   %eax
  800bc8:	e8 84 fc ff ff       	call   800851 <getuint>
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdd:	e9 98 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	6a 58                	push   $0x58
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	ff d0                	call   *%eax
  800bef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 58                	push   $0x58
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			break;
  800c12:	e9 bc 00 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	6a 30                	push   $0x30
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 78                	push   $0x78
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c37:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3a:	83 c0 04             	add    $0x4,%eax
  800c3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c40:	8b 45 14             	mov    0x14(%ebp),%eax
  800c43:	83 e8 04             	sub    $0x4,%eax
  800c46:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c59:	eb 1f                	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c61:	8d 45 14             	lea    0x14(%ebp),%eax
  800c64:	50                   	push   %eax
  800c65:	e8 e7 fb ff ff       	call   800851 <getuint>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c81:	83 ec 04             	sub    $0x4,%esp
  800c84:	52                   	push   %edx
  800c85:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c88:	50                   	push   %eax
  800c89:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	ff 75 08             	pushl  0x8(%ebp)
  800c95:	e8 00 fb ff ff       	call   80079a <printnum>
  800c9a:	83 c4 20             	add    $0x20,%esp
			break;
  800c9d:	eb 34                	jmp    800cd3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	53                   	push   %ebx
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	ff d0                	call   *%eax
  800cab:	83 c4 10             	add    $0x10,%esp
			break;
  800cae:	eb 23                	jmp    800cd3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	6a 25                	push   $0x25
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	ff d0                	call   *%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc0:	ff 4d 10             	decl   0x10(%ebp)
  800cc3:	eb 03                	jmp    800cc8 <vprintfmt+0x3b1>
  800cc5:	ff 4d 10             	decl   0x10(%ebp)
  800cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccb:	48                   	dec    %eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	3c 25                	cmp    $0x25,%al
  800cd0:	75 f3                	jne    800cc5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cd2:	90                   	nop
		}
	}
  800cd3:	e9 47 fc ff ff       	jmp    80091f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cd8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ce6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce9:	83 c0 04             	add    $0x4,%eax
  800cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cef:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	50                   	push   %eax
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	ff 75 08             	pushl  0x8(%ebp)
  800cfc:	e8 16 fc ff ff       	call   800917 <vprintfmt>
  800d01:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d04:	90                   	nop
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8b 40 08             	mov    0x8(%eax),%eax
  800d10:	8d 50 01             	lea    0x1(%eax),%edx
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	8b 10                	mov    (%eax),%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8b 40 04             	mov    0x4(%eax),%eax
  800d24:	39 c2                	cmp    %eax,%edx
  800d26:	73 12                	jae    800d3a <sprintputch+0x33>
		*b->buf++ = ch;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d33:	89 0a                	mov    %ecx,(%edx)
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	88 10                	mov    %dl,(%eax)
}
  800d3a:	90                   	nop
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	01 d0                	add    %edx,%eax
  800d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d62:	74 06                	je     800d6a <vsnprintf+0x2d>
  800d64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d68:	7f 07                	jg     800d71 <vsnprintf+0x34>
		return -E_INVAL;
  800d6a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6f:	eb 20                	jmp    800d91 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d71:	ff 75 14             	pushl  0x14(%ebp)
  800d74:	ff 75 10             	pushl  0x10(%ebp)
  800d77:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d7a:	50                   	push   %eax
  800d7b:	68 07 0d 80 00       	push   $0x800d07
  800d80:	e8 92 fb ff ff       	call   800917 <vprintfmt>
  800d85:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d99:	8d 45 10             	lea    0x10(%ebp),%eax
  800d9c:	83 c0 04             	add    $0x4,%eax
  800d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	ff 75 f4             	pushl  -0xc(%ebp)
  800da8:	50                   	push   %eax
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	ff 75 08             	pushl  0x8(%ebp)
  800daf:	e8 89 ff ff ff       	call   800d3d <vsnprintf>
  800db4:	83 c4 10             	add    $0x10,%esp
  800db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcc:	eb 06                	jmp    800dd4 <strlen+0x15>
		n++;
  800dce:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd1:	ff 45 08             	incl   0x8(%ebp)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	75 f1                	jne    800dce <strlen+0xf>
		n++;
	return n;
  800ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800def:	eb 09                	jmp    800dfa <strnlen+0x18>
		n++;
  800df1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df4:	ff 45 08             	incl   0x8(%ebp)
  800df7:	ff 4d 0c             	decl   0xc(%ebp)
  800dfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfe:	74 09                	je     800e09 <strnlen+0x27>
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	84 c0                	test   %al,%al
  800e07:	75 e8                	jne    800df1 <strnlen+0xf>
		n++;
	return n;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e1a:	90                   	nop
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8d 50 01             	lea    0x1(%eax),%edx
  800e21:	89 55 08             	mov    %edx,0x8(%ebp)
  800e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2d:	8a 12                	mov    (%edx),%dl
  800e2f:	88 10                	mov    %dl,(%eax)
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	84 c0                	test   %al,%al
  800e35:	75 e4                	jne    800e1b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4f:	eb 1f                	jmp    800e70 <strncpy+0x34>
		*dst++ = *src;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5d:	8a 12                	mov    (%edx),%dl
  800e5f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	84 c0                	test   %al,%al
  800e68:	74 03                	je     800e6d <strncpy+0x31>
			src++;
  800e6a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e6d:	ff 45 fc             	incl   -0x4(%ebp)
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e76:	72 d9                	jb     800e51 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8d:	74 30                	je     800ebf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e8f:	eb 16                	jmp    800ea7 <strlcpy+0x2a>
			*dst++ = *src++;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8d 50 01             	lea    0x1(%eax),%edx
  800e97:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea3:	8a 12                	mov    (%edx),%dl
  800ea5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ea7:	ff 4d 10             	decl   0x10(%ebp)
  800eaa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eae:	74 09                	je     800eb9 <strlcpy+0x3c>
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 d8                	jne    800e91 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec5:	29 c2                	sub    %eax,%edx
  800ec7:	89 d0                	mov    %edx,%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ece:	eb 06                	jmp    800ed6 <strcmp+0xb>
		p++, q++;
  800ed0:	ff 45 08             	incl   0x8(%ebp)
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	84 c0                	test   %al,%al
  800edd:	74 0e                	je     800eed <strcmp+0x22>
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 10                	mov    (%eax),%dl
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	38 c2                	cmp    %al,%dl
  800eeb:	74 e3                	je     800ed0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f b6 d0             	movzbl %al,%edx
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	0f b6 c0             	movzbl %al,%eax
  800efd:	29 c2                	sub    %eax,%edx
  800eff:	89 d0                	mov    %edx,%eax
}
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f06:	eb 09                	jmp    800f11 <strncmp+0xe>
		n--, p++, q++;
  800f08:	ff 4d 10             	decl   0x10(%ebp)
  800f0b:	ff 45 08             	incl   0x8(%ebp)
  800f0e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f15:	74 17                	je     800f2e <strncmp+0x2b>
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	74 0e                	je     800f2e <strncmp+0x2b>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 10                	mov    (%eax),%dl
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	38 c2                	cmp    %al,%dl
  800f2c:	74 da                	je     800f08 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	75 07                	jne    800f3b <strncmp+0x38>
		return 0;
  800f34:	b8 00 00 00 00       	mov    $0x0,%eax
  800f39:	eb 14                	jmp    800f4f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	0f b6 d0             	movzbl %al,%edx
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 c0             	movzbl %al,%eax
  800f4b:	29 c2                	sub    %eax,%edx
  800f4d:	89 d0                	mov    %edx,%eax
}
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 04             	sub    $0x4,%esp
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f5d:	eb 12                	jmp    800f71 <strchr+0x20>
		if (*s == c)
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f67:	75 05                	jne    800f6e <strchr+0x1d>
			return (char *) s;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	eb 11                	jmp    800f7f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f6e:	ff 45 08             	incl   0x8(%ebp)
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 e5                	jne    800f5f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 04             	sub    $0x4,%esp
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8d:	eb 0d                	jmp    800f9c <strfind+0x1b>
		if (*s == c)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f97:	74 0e                	je     800fa7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f99:	ff 45 08             	incl   0x8(%ebp)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	75 ea                	jne    800f8f <strfind+0xe>
  800fa5:	eb 01                	jmp    800fa8 <strfind+0x27>
		if (*s == c)
			break;
  800fa7:	90                   	nop
	return (char *) s;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fbf:	eb 0e                	jmp    800fcf <memset+0x22>
		*p++ = c;
  800fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc4:	8d 50 01             	lea    0x1(%eax),%edx
  800fc7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fcf:	ff 4d f8             	decl   -0x8(%ebp)
  800fd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fd6:	79 e9                	jns    800fc1 <memset+0x14>
		*p++ = c;

	return v;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fef:	eb 16                	jmp    801007 <memcpy+0x2a>
		*d++ = *s++;
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	8d 50 01             	lea    0x1(%eax),%edx
  800ff7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ffa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffd:	8d 4a 01             	lea    0x1(%edx),%ecx
  801000:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801003:	8a 12                	mov    (%edx),%dl
  801005:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100d:	89 55 10             	mov    %edx,0x10(%ebp)
  801010:	85 c0                	test   %eax,%eax
  801012:	75 dd                	jne    800ff1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80102b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801031:	73 50                	jae    801083 <memmove+0x6a>
  801033:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103e:	76 43                	jbe    801083 <memmove+0x6a>
		s += n;
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80104c:	eb 10                	jmp    80105e <memmove+0x45>
			*--d = *--s;
  80104e:	ff 4d f8             	decl   -0x8(%ebp)
  801051:	ff 4d fc             	decl   -0x4(%ebp)
  801054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801057:	8a 10                	mov    (%eax),%dl
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	8d 50 ff             	lea    -0x1(%eax),%edx
  801064:	89 55 10             	mov    %edx,0x10(%ebp)
  801067:	85 c0                	test   %eax,%eax
  801069:	75 e3                	jne    80104e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80106b:	eb 23                	jmp    801090 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	8d 50 01             	lea    0x1(%eax),%edx
  801073:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801076:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801079:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80107f:	8a 12                	mov    (%edx),%dl
  801081:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	8d 50 ff             	lea    -0x1(%eax),%edx
  801089:	89 55 10             	mov    %edx,0x10(%ebp)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	75 dd                	jne    80106d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010a7:	eb 2a                	jmp    8010d3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ac:	8a 10                	mov    (%eax),%dl
  8010ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	38 c2                	cmp    %al,%dl
  8010b5:	74 16                	je     8010cd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	0f b6 d0             	movzbl %al,%edx
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	0f b6 c0             	movzbl %al,%eax
  8010c7:	29 c2                	sub    %eax,%edx
  8010c9:	89 d0                	mov    %edx,%eax
  8010cb:	eb 18                	jmp    8010e5 <memcmp+0x50>
		s1++, s2++;
  8010cd:	ff 45 fc             	incl   -0x4(%ebp)
  8010d0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	75 c9                	jne    8010a9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010f8:	eb 15                	jmp    80110f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f b6 d0             	movzbl %al,%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	0f b6 c0             	movzbl %al,%eax
  801108:	39 c2                	cmp    %eax,%edx
  80110a:	74 0d                	je     801119 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801115:	72 e3                	jb     8010fa <memfind+0x13>
  801117:	eb 01                	jmp    80111a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801119:	90                   	nop
	return (void *) s;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80112c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801133:	eb 03                	jmp    801138 <strtol+0x19>
		s++;
  801135:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	3c 20                	cmp    $0x20,%al
  80113f:	74 f4                	je     801135 <strtol+0x16>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 09                	cmp    $0x9,%al
  801148:	74 eb                	je     801135 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 2b                	cmp    $0x2b,%al
  801151:	75 05                	jne    801158 <strtol+0x39>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
  801156:	eb 13                	jmp    80116b <strtol+0x4c>
	else if (*s == '-')
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	3c 2d                	cmp    $0x2d,%al
  80115f:	75 0a                	jne    80116b <strtol+0x4c>
		s++, neg = 1;
  801161:	ff 45 08             	incl   0x8(%ebp)
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80116b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116f:	74 06                	je     801177 <strtol+0x58>
  801171:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801175:	75 20                	jne    801197 <strtol+0x78>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 30                	cmp    $0x30,%al
  80117e:	75 17                	jne    801197 <strtol+0x78>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	40                   	inc    %eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 78                	cmp    $0x78,%al
  801188:	75 0d                	jne    801197 <strtol+0x78>
		s += 2, base = 16;
  80118a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80118e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801195:	eb 28                	jmp    8011bf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801197:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119b:	75 15                	jne    8011b2 <strtol+0x93>
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	3c 30                	cmp    $0x30,%al
  8011a4:	75 0c                	jne    8011b2 <strtol+0x93>
		s++, base = 8;
  8011a6:	ff 45 08             	incl   0x8(%ebp)
  8011a9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011b0:	eb 0d                	jmp    8011bf <strtol+0xa0>
	else if (base == 0)
  8011b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b6:	75 07                	jne    8011bf <strtol+0xa0>
		base = 10;
  8011b8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	3c 2f                	cmp    $0x2f,%al
  8011c6:	7e 19                	jle    8011e1 <strtol+0xc2>
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 39                	cmp    $0x39,%al
  8011cf:	7f 10                	jg     8011e1 <strtol+0xc2>
			dig = *s - '0';
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	0f be c0             	movsbl %al,%eax
  8011d9:	83 e8 30             	sub    $0x30,%eax
  8011dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011df:	eb 42                	jmp    801223 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 60                	cmp    $0x60,%al
  8011e8:	7e 19                	jle    801203 <strtol+0xe4>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 7a                	cmp    $0x7a,%al
  8011f1:	7f 10                	jg     801203 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	0f be c0             	movsbl %al,%eax
  8011fb:	83 e8 57             	sub    $0x57,%eax
  8011fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801201:	eb 20                	jmp    801223 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 40                	cmp    $0x40,%al
  80120a:	7e 39                	jle    801245 <strtol+0x126>
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 5a                	cmp    $0x5a,%al
  801213:	7f 30                	jg     801245 <strtol+0x126>
			dig = *s - 'A' + 10;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	83 e8 37             	sub    $0x37,%eax
  801220:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801226:	3b 45 10             	cmp    0x10(%ebp),%eax
  801229:	7d 19                	jge    801244 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80122b:	ff 45 08             	incl   0x8(%ebp)
  80122e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801231:	0f af 45 10          	imul   0x10(%ebp),%eax
  801235:	89 c2                	mov    %eax,%edx
  801237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80123f:	e9 7b ff ff ff       	jmp    8011bf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801244:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801245:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801249:	74 08                	je     801253 <strtol+0x134>
		*endptr = (char *) s;
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801253:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801257:	74 07                	je     801260 <strtol+0x141>
  801259:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125c:	f7 d8                	neg    %eax
  80125e:	eb 03                	jmp    801263 <strtol+0x144>
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <ltostr>:

void
ltostr(long value, char *str)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801272:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127d:	79 13                	jns    801292 <ltostr+0x2d>
	{
		neg = 1;
  80127f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80128c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80128f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80129a:	99                   	cltd   
  80129b:	f7 f9                	idiv   %ecx
  80129d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a3:	8d 50 01             	lea    0x1(%eax),%edx
  8012a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a9:	89 c2                	mov    %eax,%edx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012b3:	83 c2 30             	add    $0x30,%edx
  8012b6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012bb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012c0:	f7 e9                	imul   %ecx
  8012c2:	c1 fa 02             	sar    $0x2,%edx
  8012c5:	89 c8                	mov    %ecx,%eax
  8012c7:	c1 f8 1f             	sar    $0x1f,%eax
  8012ca:	29 c2                	sub    %eax,%edx
  8012cc:	89 d0                	mov    %edx,%eax
  8012ce:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d9:	f7 e9                	imul   %ecx
  8012db:	c1 fa 02             	sar    $0x2,%edx
  8012de:	89 c8                	mov    %ecx,%eax
  8012e0:	c1 f8 1f             	sar    $0x1f,%eax
  8012e3:	29 c2                	sub    %eax,%edx
  8012e5:	89 d0                	mov    %edx,%eax
  8012e7:	c1 e0 02             	shl    $0x2,%eax
  8012ea:	01 d0                	add    %edx,%eax
  8012ec:	01 c0                	add    %eax,%eax
  8012ee:	29 c1                	sub    %eax,%ecx
  8012f0:	89 ca                	mov    %ecx,%edx
  8012f2:	85 d2                	test   %edx,%edx
  8012f4:	75 9c                	jne    801292 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801300:	48                   	dec    %eax
  801301:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801304:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801308:	74 3d                	je     801347 <ltostr+0xe2>
		start = 1 ;
  80130a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801311:	eb 34                	jmp    801347 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	01 d0                	add    %edx,%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 c2                	add    %eax,%edx
  801328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	01 c8                	add    %ecx,%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801334:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 c2                	add    %eax,%edx
  80133c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80133f:	88 02                	mov    %al,(%edx)
		start++ ;
  801341:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801344:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134d:	7c c4                	jl     801313 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80134f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801363:	ff 75 08             	pushl  0x8(%ebp)
  801366:	e8 54 fa ff ff       	call   800dbf <strlen>
  80136b:	83 c4 04             	add    $0x4,%esp
  80136e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801371:	ff 75 0c             	pushl  0xc(%ebp)
  801374:	e8 46 fa ff ff       	call   800dbf <strlen>
  801379:	83 c4 04             	add    $0x4,%esp
  80137c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80137f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 17                	jmp    8013a6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80138f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801392:	8b 45 10             	mov    0x10(%ebp),%eax
  801395:	01 c2                	add    %eax,%edx
  801397:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	01 c8                	add    %ecx,%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013a3:	ff 45 fc             	incl   -0x4(%ebp)
  8013a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ac:	7c e1                	jl     80138f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013bc:	eb 1f                	jmp    8013dd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c1:	8d 50 01             	lea    0x1(%eax),%edx
  8013c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013c7:	89 c2                	mov    %eax,%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 c2                	add    %eax,%edx
  8013ce:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 c8                	add    %ecx,%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013da:	ff 45 f8             	incl   -0x8(%ebp)
  8013dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e3:	7c d9                	jl     8013be <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f0:	90                   	nop
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801402:	8b 00                	mov    (%eax),%eax
  801404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140b:	8b 45 10             	mov    0x10(%ebp),%eax
  80140e:	01 d0                	add    %edx,%eax
  801410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801416:	eb 0c                	jmp    801424 <strsplit+0x31>
			*string++ = 0;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8d 50 01             	lea    0x1(%eax),%edx
  80141e:	89 55 08             	mov    %edx,0x8(%ebp)
  801421:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	84 c0                	test   %al,%al
  80142b:	74 18                	je     801445 <strsplit+0x52>
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f be c0             	movsbl %al,%eax
  801435:	50                   	push   %eax
  801436:	ff 75 0c             	pushl  0xc(%ebp)
  801439:	e8 13 fb ff ff       	call   800f51 <strchr>
  80143e:	83 c4 08             	add    $0x8,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	75 d3                	jne    801418 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	84 c0                	test   %al,%al
  80144c:	74 5a                	je     8014a8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80144e:	8b 45 14             	mov    0x14(%ebp),%eax
  801451:	8b 00                	mov    (%eax),%eax
  801453:	83 f8 0f             	cmp    $0xf,%eax
  801456:	75 07                	jne    80145f <strsplit+0x6c>
		{
			return 0;
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
  80145d:	eb 66                	jmp    8014c5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	8d 48 01             	lea    0x1(%eax),%ecx
  801467:	8b 55 14             	mov    0x14(%ebp),%edx
  80146a:	89 0a                	mov    %ecx,(%edx)
  80146c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801473:	8b 45 10             	mov    0x10(%ebp),%eax
  801476:	01 c2                	add    %eax,%edx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80147d:	eb 03                	jmp    801482 <strsplit+0x8f>
			string++;
  80147f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	74 8b                	je     801416 <strsplit+0x23>
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f be c0             	movsbl %al,%eax
  801493:	50                   	push   %eax
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	e8 b5 fa ff ff       	call   800f51 <strchr>
  80149c:	83 c4 08             	add    $0x8,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	74 dc                	je     80147f <strsplit+0x8c>
			string++;
	}
  8014a3:	e9 6e ff ff ff       	jmp    801416 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014a8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b8:	01 d0                	add    %edx,%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014cd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	74 1f                	je     8014f5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014d6:	e8 1d 00 00 00       	call   8014f8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	68 b0 3a 80 00       	push   $0x803ab0
  8014e3:	e8 55 f2 ff ff       	call   80073d <cprintf>
  8014e8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014eb:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8014f2:	00 00 00 
	}
}
  8014f5:	90                   	nop
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8014fe:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801505:	00 00 00 
  801508:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80150f:	00 00 00 
  801512:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801519:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80151c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801523:	00 00 00 
  801526:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80152d:	00 00 00 
  801530:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801537:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80153a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801541:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801544:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80154b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801553:	2d 00 10 00 00       	sub    $0x1000,%eax
  801558:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80155d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801564:	a1 20 41 80 00       	mov    0x804120,%eax
  801569:	c1 e0 04             	shl    $0x4,%eax
  80156c:	89 c2                	mov    %eax,%edx
  80156e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	48                   	dec    %eax
  801574:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157a:	ba 00 00 00 00       	mov    $0x0,%edx
  80157f:	f7 75 f0             	divl   -0x10(%ebp)
  801582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801585:	29 d0                	sub    %edx,%eax
  801587:	89 c2                	mov    %eax,%edx
  801589:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801590:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801593:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801598:	2d 00 10 00 00       	sub    $0x1000,%eax
  80159d:	83 ec 04             	sub    $0x4,%esp
  8015a0:	6a 06                	push   $0x6
  8015a2:	52                   	push   %edx
  8015a3:	50                   	push   %eax
  8015a4:	e8 71 05 00 00       	call   801b1a <sys_allocate_chunk>
  8015a9:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015ac:	a1 20 41 80 00       	mov    0x804120,%eax
  8015b1:	83 ec 0c             	sub    $0xc,%esp
  8015b4:	50                   	push   %eax
  8015b5:	e8 e6 0b 00 00       	call   8021a0 <initialize_MemBlocksList>
  8015ba:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8015bd:	a1 48 41 80 00       	mov    0x804148,%eax
  8015c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8015c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015c9:	75 14                	jne    8015df <initialize_dyn_block_system+0xe7>
  8015cb:	83 ec 04             	sub    $0x4,%esp
  8015ce:	68 d5 3a 80 00       	push   $0x803ad5
  8015d3:	6a 2b                	push   $0x2b
  8015d5:	68 f3 3a 80 00       	push   $0x803af3
  8015da:	e8 b2 1b 00 00       	call   803191 <_panic>
  8015df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e2:	8b 00                	mov    (%eax),%eax
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	74 10                	je     8015f8 <initialize_dyn_block_system+0x100>
  8015e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015eb:	8b 00                	mov    (%eax),%eax
  8015ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015f0:	8b 52 04             	mov    0x4(%edx),%edx
  8015f3:	89 50 04             	mov    %edx,0x4(%eax)
  8015f6:	eb 0b                	jmp    801603 <initialize_dyn_block_system+0x10b>
  8015f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015fb:	8b 40 04             	mov    0x4(%eax),%eax
  8015fe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801606:	8b 40 04             	mov    0x4(%eax),%eax
  801609:	85 c0                	test   %eax,%eax
  80160b:	74 0f                	je     80161c <initialize_dyn_block_system+0x124>
  80160d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801610:	8b 40 04             	mov    0x4(%eax),%eax
  801613:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801616:	8b 12                	mov    (%edx),%edx
  801618:	89 10                	mov    %edx,(%eax)
  80161a:	eb 0a                	jmp    801626 <initialize_dyn_block_system+0x12e>
  80161c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80161f:	8b 00                	mov    (%eax),%eax
  801621:	a3 48 41 80 00       	mov    %eax,0x804148
  801626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80162f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801639:	a1 54 41 80 00       	mov    0x804154,%eax
  80163e:	48                   	dec    %eax
  80163f:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801644:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801647:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80164e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801651:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80165e:	e8 d2 13 00 00       	call   802a35 <insert_sorted_with_merge_freeList>
  801663:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801666:	90                   	nop
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80166f:	e8 53 fe ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801674:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801678:	75 07                	jne    801681 <malloc+0x18>
  80167a:	b8 00 00 00 00       	mov    $0x0,%eax
  80167f:	eb 61                	jmp    8016e2 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801681:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801688:	8b 55 08             	mov    0x8(%ebp),%edx
  80168b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168e:	01 d0                	add    %edx,%eax
  801690:	48                   	dec    %eax
  801691:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801697:	ba 00 00 00 00       	mov    $0x0,%edx
  80169c:	f7 75 f4             	divl   -0xc(%ebp)
  80169f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a2:	29 d0                	sub    %edx,%eax
  8016a4:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016a7:	e8 3c 08 00 00       	call   801ee8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	74 2d                	je     8016dd <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8016b0:	83 ec 0c             	sub    $0xc,%esp
  8016b3:	ff 75 08             	pushl  0x8(%ebp)
  8016b6:	e8 3e 0f 00 00       	call   8025f9 <alloc_block_FF>
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8016c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016c5:	74 16                	je     8016dd <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8016c7:	83 ec 0c             	sub    $0xc,%esp
  8016ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8016cd:	e8 48 0c 00 00       	call   80231a <insert_sorted_allocList>
  8016d2:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8016d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d8:	8b 40 08             	mov    0x8(%eax),%eax
  8016db:	eb 05                	jmp    8016e2 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016f8:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	83 ec 08             	sub    $0x8,%esp
  801701:	50                   	push   %eax
  801702:	68 40 40 80 00       	push   $0x804040
  801707:	e8 71 0b 00 00       	call   80227d <find_block>
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801715:	8b 50 0c             	mov    0xc(%eax),%edx
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	52                   	push   %edx
  80171f:	50                   	push   %eax
  801720:	e8 bd 03 00 00       	call   801ae2 <sys_free_user_mem>
  801725:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801728:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80172c:	75 14                	jne    801742 <free+0x5e>
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	68 d5 3a 80 00       	push   $0x803ad5
  801736:	6a 71                	push   $0x71
  801738:	68 f3 3a 80 00       	push   $0x803af3
  80173d:	e8 4f 1a 00 00       	call   803191 <_panic>
  801742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801745:	8b 00                	mov    (%eax),%eax
  801747:	85 c0                	test   %eax,%eax
  801749:	74 10                	je     80175b <free+0x77>
  80174b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174e:	8b 00                	mov    (%eax),%eax
  801750:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801753:	8b 52 04             	mov    0x4(%edx),%edx
  801756:	89 50 04             	mov    %edx,0x4(%eax)
  801759:	eb 0b                	jmp    801766 <free+0x82>
  80175b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175e:	8b 40 04             	mov    0x4(%eax),%eax
  801761:	a3 44 40 80 00       	mov    %eax,0x804044
  801766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801769:	8b 40 04             	mov    0x4(%eax),%eax
  80176c:	85 c0                	test   %eax,%eax
  80176e:	74 0f                	je     80177f <free+0x9b>
  801770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801773:	8b 40 04             	mov    0x4(%eax),%eax
  801776:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801779:	8b 12                	mov    (%edx),%edx
  80177b:	89 10                	mov    %edx,(%eax)
  80177d:	eb 0a                	jmp    801789 <free+0xa5>
  80177f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801782:	8b 00                	mov    (%eax),%eax
  801784:	a3 40 40 80 00       	mov    %eax,0x804040
  801789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801795:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80179c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017a1:	48                   	dec    %eax
  8017a2:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8017a7:	83 ec 0c             	sub    $0xc,%esp
  8017aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ad:	e8 83 12 00 00       	call   802a35 <insert_sorted_with_merge_freeList>
  8017b2:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8017b5:	90                   	nop
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	83 ec 28             	sub    $0x28,%esp
  8017be:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c1:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017c4:	e8 fe fc ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017cd:	75 0a                	jne    8017d9 <smalloc+0x21>
  8017cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d4:	e9 86 00 00 00       	jmp    80185f <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8017d9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8017e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e6:	01 d0                	add    %edx,%eax
  8017e8:	48                   	dec    %eax
  8017e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f4:	f7 75 f4             	divl   -0xc(%ebp)
  8017f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fa:	29 d0                	sub    %edx,%eax
  8017fc:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017ff:	e8 e4 06 00 00       	call   801ee8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801804:	85 c0                	test   %eax,%eax
  801806:	74 52                	je     80185a <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801808:	83 ec 0c             	sub    $0xc,%esp
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	e8 e6 0d 00 00       	call   8025f9 <alloc_block_FF>
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801819:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80181d:	75 07                	jne    801826 <smalloc+0x6e>
			return NULL ;
  80181f:	b8 00 00 00 00       	mov    $0x0,%eax
  801824:	eb 39                	jmp    80185f <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801826:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801829:	8b 40 08             	mov    0x8(%eax),%eax
  80182c:	89 c2                	mov    %eax,%edx
  80182e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801832:	52                   	push   %edx
  801833:	50                   	push   %eax
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	ff 75 08             	pushl  0x8(%ebp)
  80183a:	e8 2e 04 00 00       	call   801c6d <sys_createSharedObject>
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801845:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801849:	79 07                	jns    801852 <smalloc+0x9a>
			return (void*)NULL ;
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
  801850:	eb 0d                	jmp    80185f <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801855:	8b 40 08             	mov    0x8(%eax),%eax
  801858:	eb 05                	jmp    80185f <smalloc+0xa7>
		}
		return (void*)NULL ;
  80185a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801867:	e8 5b fc ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80186c:	83 ec 08             	sub    $0x8,%esp
  80186f:	ff 75 0c             	pushl  0xc(%ebp)
  801872:	ff 75 08             	pushl  0x8(%ebp)
  801875:	e8 1d 04 00 00       	call   801c97 <sys_getSizeOfSharedObject>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801880:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801884:	75 0a                	jne    801890 <sget+0x2f>
			return NULL ;
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
  80188b:	e9 83 00 00 00       	jmp    801913 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801890:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189d:	01 d0                	add    %edx,%eax
  80189f:	48                   	dec    %eax
  8018a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ab:	f7 75 f0             	divl   -0x10(%ebp)
  8018ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b1:	29 d0                	sub    %edx,%eax
  8018b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018b6:	e8 2d 06 00 00       	call   801ee8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	74 4f                	je     80190e <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8018bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c2:	83 ec 0c             	sub    $0xc,%esp
  8018c5:	50                   	push   %eax
  8018c6:	e8 2e 0d 00 00       	call   8025f9 <alloc_block_FF>
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8018d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018d5:	75 07                	jne    8018de <sget+0x7d>
					return (void*)NULL ;
  8018d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018dc:	eb 35                	jmp    801913 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8018de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018e1:	8b 40 08             	mov    0x8(%eax),%eax
  8018e4:	83 ec 04             	sub    $0x4,%esp
  8018e7:	50                   	push   %eax
  8018e8:	ff 75 0c             	pushl  0xc(%ebp)
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	e8 c1 03 00 00       	call   801cb4 <sys_getSharedObject>
  8018f3:	83 c4 10             	add    $0x10,%esp
  8018f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8018f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018fd:	79 07                	jns    801906 <sget+0xa5>
				return (void*)NULL ;
  8018ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801904:	eb 0d                	jmp    801913 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801906:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801909:	8b 40 08             	mov    0x8(%eax),%eax
  80190c:	eb 05                	jmp    801913 <sget+0xb2>


		}
	return (void*)NULL ;
  80190e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80191b:	e8 a7 fb ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801920:	83 ec 04             	sub    $0x4,%esp
  801923:	68 00 3b 80 00       	push   $0x803b00
  801928:	68 f9 00 00 00       	push   $0xf9
  80192d:	68 f3 3a 80 00       	push   $0x803af3
  801932:	e8 5a 18 00 00       	call   803191 <_panic>

00801937 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	68 28 3b 80 00       	push   $0x803b28
  801945:	68 0d 01 00 00       	push   $0x10d
  80194a:	68 f3 3a 80 00       	push   $0x803af3
  80194f:	e8 3d 18 00 00       	call   803191 <_panic>

00801954 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80195a:	83 ec 04             	sub    $0x4,%esp
  80195d:	68 4c 3b 80 00       	push   $0x803b4c
  801962:	68 18 01 00 00       	push   $0x118
  801967:	68 f3 3a 80 00       	push   $0x803af3
  80196c:	e8 20 18 00 00       	call   803191 <_panic>

00801971 <shrink>:

}
void shrink(uint32 newSize)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801977:	83 ec 04             	sub    $0x4,%esp
  80197a:	68 4c 3b 80 00       	push   $0x803b4c
  80197f:	68 1d 01 00 00       	push   $0x11d
  801984:	68 f3 3a 80 00       	push   $0x803af3
  801989:	e8 03 18 00 00       	call   803191 <_panic>

0080198e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801994:	83 ec 04             	sub    $0x4,%esp
  801997:	68 4c 3b 80 00       	push   $0x803b4c
  80199c:	68 22 01 00 00       	push   $0x122
  8019a1:	68 f3 3a 80 00       	push   $0x803af3
  8019a6:	e8 e6 17 00 00       	call   803191 <_panic>

008019ab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	57                   	push   %edi
  8019af:	56                   	push   %esi
  8019b0:	53                   	push   %ebx
  8019b1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019c0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019c3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019c6:	cd 30                	int    $0x30
  8019c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019ce:	83 c4 10             	add    $0x10,%esp
  8019d1:	5b                   	pop    %ebx
  8019d2:	5e                   	pop    %esi
  8019d3:	5f                   	pop    %edi
  8019d4:	5d                   	pop    %ebp
  8019d5:	c3                   	ret    

008019d6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	52                   	push   %edx
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	50                   	push   %eax
  8019f2:	6a 00                	push   $0x0
  8019f4:	e8 b2 ff ff ff       	call   8019ab <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	90                   	nop
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_cgetc>:

int
sys_cgetc(void)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 01                	push   $0x1
  801a0e:	e8 98 ff ff ff       	call   8019ab <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	52                   	push   %edx
  801a28:	50                   	push   %eax
  801a29:	6a 05                	push   $0x5
  801a2b:	e8 7b ff ff ff       	call   8019ab <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	56                   	push   %esi
  801a39:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a3a:	8b 75 18             	mov    0x18(%ebp),%esi
  801a3d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	56                   	push   %esi
  801a4a:	53                   	push   %ebx
  801a4b:	51                   	push   %ecx
  801a4c:	52                   	push   %edx
  801a4d:	50                   	push   %eax
  801a4e:	6a 06                	push   $0x6
  801a50:	e8 56 ff ff ff       	call   8019ab <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5b:	5b                   	pop    %ebx
  801a5c:	5e                   	pop    %esi
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    

00801a5f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	52                   	push   %edx
  801a6f:	50                   	push   %eax
  801a70:	6a 07                	push   $0x7
  801a72:	e8 34 ff ff ff       	call   8019ab <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	ff 75 08             	pushl  0x8(%ebp)
  801a8b:	6a 08                	push   $0x8
  801a8d:	e8 19 ff ff ff       	call   8019ab <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 09                	push   $0x9
  801aa6:	e8 00 ff ff ff       	call   8019ab <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 0a                	push   $0xa
  801abf:	e8 e7 fe ff ff       	call   8019ab <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 0b                	push   $0xb
  801ad8:	e8 ce fe ff ff       	call   8019ab <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	ff 75 08             	pushl  0x8(%ebp)
  801af1:	6a 0f                	push   $0xf
  801af3:	e8 b3 fe ff ff       	call   8019ab <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
	return;
  801afb:	90                   	nop
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	ff 75 08             	pushl  0x8(%ebp)
  801b0d:	6a 10                	push   $0x10
  801b0f:	e8 97 fe ff ff       	call   8019ab <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
	return ;
  801b17:	90                   	nop
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	ff 75 10             	pushl  0x10(%ebp)
  801b24:	ff 75 0c             	pushl  0xc(%ebp)
  801b27:	ff 75 08             	pushl  0x8(%ebp)
  801b2a:	6a 11                	push   $0x11
  801b2c:	e8 7a fe ff ff       	call   8019ab <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
	return ;
  801b34:	90                   	nop
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 0c                	push   $0xc
  801b46:	e8 60 fe ff ff       	call   8019ab <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	ff 75 08             	pushl  0x8(%ebp)
  801b5e:	6a 0d                	push   $0xd
  801b60:	e8 46 fe ff ff       	call   8019ab <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 0e                	push   $0xe
  801b79:	e8 2d fe ff ff       	call   8019ab <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	90                   	nop
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 13                	push   $0x13
  801b93:	e8 13 fe ff ff       	call   8019ab <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	90                   	nop
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 14                	push   $0x14
  801bad:	e8 f9 fd ff ff       	call   8019ab <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	90                   	nop
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 04             	sub    $0x4,%esp
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bc4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	50                   	push   %eax
  801bd1:	6a 15                	push   $0x15
  801bd3:	e8 d3 fd ff ff       	call   8019ab <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	90                   	nop
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 16                	push   $0x16
  801bed:	e8 b9 fd ff ff       	call   8019ab <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	90                   	nop
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	50                   	push   %eax
  801c08:	6a 17                	push   $0x17
  801c0a:	e8 9c fd ff ff       	call   8019ab <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	52                   	push   %edx
  801c24:	50                   	push   %eax
  801c25:	6a 1a                	push   $0x1a
  801c27:	e8 7f fd ff ff       	call   8019ab <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	52                   	push   %edx
  801c41:	50                   	push   %eax
  801c42:	6a 18                	push   $0x18
  801c44:	e8 62 fd ff ff       	call   8019ab <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	90                   	nop
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	52                   	push   %edx
  801c5f:	50                   	push   %eax
  801c60:	6a 19                	push   $0x19
  801c62:	e8 44 fd ff ff       	call   8019ab <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	90                   	nop
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	83 ec 04             	sub    $0x4,%esp
  801c73:	8b 45 10             	mov    0x10(%ebp),%eax
  801c76:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c79:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c7c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	6a 00                	push   $0x0
  801c85:	51                   	push   %ecx
  801c86:	52                   	push   %edx
  801c87:	ff 75 0c             	pushl  0xc(%ebp)
  801c8a:	50                   	push   %eax
  801c8b:	6a 1b                	push   $0x1b
  801c8d:	e8 19 fd ff ff       	call   8019ab <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	52                   	push   %edx
  801ca7:	50                   	push   %eax
  801ca8:	6a 1c                	push   $0x1c
  801caa:	e8 fc fc ff ff       	call   8019ab <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cb7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	51                   	push   %ecx
  801cc5:	52                   	push   %edx
  801cc6:	50                   	push   %eax
  801cc7:	6a 1d                	push   $0x1d
  801cc9:	e8 dd fc ff ff       	call   8019ab <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	52                   	push   %edx
  801ce3:	50                   	push   %eax
  801ce4:	6a 1e                	push   $0x1e
  801ce6:	e8 c0 fc ff ff       	call   8019ab <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 1f                	push   $0x1f
  801cff:	e8 a7 fc ff ff       	call   8019ab <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	6a 00                	push   $0x0
  801d11:	ff 75 14             	pushl  0x14(%ebp)
  801d14:	ff 75 10             	pushl  0x10(%ebp)
  801d17:	ff 75 0c             	pushl  0xc(%ebp)
  801d1a:	50                   	push   %eax
  801d1b:	6a 20                	push   $0x20
  801d1d:	e8 89 fc ff ff       	call   8019ab <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	50                   	push   %eax
  801d36:	6a 21                	push   $0x21
  801d38:	e8 6e fc ff ff       	call   8019ab <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	90                   	nop
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	50                   	push   %eax
  801d52:	6a 22                	push   $0x22
  801d54:	e8 52 fc ff ff       	call   8019ab <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 02                	push   $0x2
  801d6d:	e8 39 fc ff ff       	call   8019ab <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 03                	push   $0x3
  801d86:	e8 20 fc ff ff       	call   8019ab <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 04                	push   $0x4
  801d9f:	e8 07 fc ff ff       	call   8019ab <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_exit_env>:


void sys_exit_env(void)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 23                	push   $0x23
  801db8:	e8 ee fb ff ff       	call   8019ab <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	90                   	nop
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dc9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dcc:	8d 50 04             	lea    0x4(%eax),%edx
  801dcf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	52                   	push   %edx
  801dd9:	50                   	push   %eax
  801dda:	6a 24                	push   $0x24
  801ddc:	e8 ca fb ff ff       	call   8019ab <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
	return result;
  801de4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ded:	89 01                	mov    %eax,(%ecx)
  801def:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	c9                   	leave  
  801df6:	c2 04 00             	ret    $0x4

00801df9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	ff 75 10             	pushl  0x10(%ebp)
  801e03:	ff 75 0c             	pushl  0xc(%ebp)
  801e06:	ff 75 08             	pushl  0x8(%ebp)
  801e09:	6a 12                	push   $0x12
  801e0b:	e8 9b fb ff ff       	call   8019ab <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
	return ;
  801e13:	90                   	nop
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 25                	push   $0x25
  801e25:	e8 81 fb ff ff       	call   8019ab <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	83 ec 04             	sub    $0x4,%esp
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e3b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	50                   	push   %eax
  801e48:	6a 26                	push   $0x26
  801e4a:	e8 5c fb ff ff       	call   8019ab <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e52:	90                   	nop
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <rsttst>:
void rsttst()
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 28                	push   $0x28
  801e64:	e8 42 fb ff ff       	call   8019ab <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6c:	90                   	nop
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 04             	sub    $0x4,%esp
  801e75:	8b 45 14             	mov    0x14(%ebp),%eax
  801e78:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e7b:	8b 55 18             	mov    0x18(%ebp),%edx
  801e7e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e82:	52                   	push   %edx
  801e83:	50                   	push   %eax
  801e84:	ff 75 10             	pushl  0x10(%ebp)
  801e87:	ff 75 0c             	pushl  0xc(%ebp)
  801e8a:	ff 75 08             	pushl  0x8(%ebp)
  801e8d:	6a 27                	push   $0x27
  801e8f:	e8 17 fb ff ff       	call   8019ab <syscall>
  801e94:	83 c4 18             	add    $0x18,%esp
	return ;
  801e97:	90                   	nop
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <chktst>:
void chktst(uint32 n)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	ff 75 08             	pushl  0x8(%ebp)
  801ea8:	6a 29                	push   $0x29
  801eaa:	e8 fc fa ff ff       	call   8019ab <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb2:	90                   	nop
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <inctst>:

void inctst()
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 2a                	push   $0x2a
  801ec4:	e8 e2 fa ff ff       	call   8019ab <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecc:	90                   	nop
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <gettst>:
uint32 gettst()
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 2b                	push   $0x2b
  801ede:	e8 c8 fa ff ff       	call   8019ab <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 2c                	push   $0x2c
  801efa:	e8 ac fa ff ff       	call   8019ab <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
  801f02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f05:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f09:	75 07                	jne    801f12 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f10:	eb 05                	jmp    801f17 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 2c                	push   $0x2c
  801f2b:	e8 7b fa ff ff       	call   8019ab <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
  801f33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f36:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f3a:	75 07                	jne    801f43 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f41:	eb 05                	jmp    801f48 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 2c                	push   $0x2c
  801f5c:	e8 4a fa ff ff       	call   8019ab <syscall>
  801f61:	83 c4 18             	add    $0x18,%esp
  801f64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f67:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f6b:	75 07                	jne    801f74 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f72:	eb 05                	jmp    801f79 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 2c                	push   $0x2c
  801f8d:	e8 19 fa ff ff       	call   8019ab <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
  801f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f98:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f9c:	75 07                	jne    801fa5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa3:	eb 05                	jmp    801faa <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	ff 75 08             	pushl  0x8(%ebp)
  801fba:	6a 2d                	push   $0x2d
  801fbc:	e8 ea f9 ff ff       	call   8019ab <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc4:	90                   	nop
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fcb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	6a 00                	push   $0x0
  801fd9:	53                   	push   %ebx
  801fda:	51                   	push   %ecx
  801fdb:	52                   	push   %edx
  801fdc:	50                   	push   %eax
  801fdd:	6a 2e                	push   $0x2e
  801fdf:	e8 c7 f9 ff ff       	call   8019ab <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
}
  801fe7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	52                   	push   %edx
  801ffc:	50                   	push   %eax
  801ffd:	6a 2f                	push   $0x2f
  801fff:	e8 a7 f9 ff ff       	call   8019ab <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80200f:	83 ec 0c             	sub    $0xc,%esp
  802012:	68 5c 3b 80 00       	push   $0x803b5c
  802017:	e8 21 e7 ff ff       	call   80073d <cprintf>
  80201c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80201f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802026:	83 ec 0c             	sub    $0xc,%esp
  802029:	68 88 3b 80 00       	push   $0x803b88
  80202e:	e8 0a e7 ff ff       	call   80073d <cprintf>
  802033:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802036:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80203a:	a1 38 41 80 00       	mov    0x804138,%eax
  80203f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802042:	eb 56                	jmp    80209a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802044:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802048:	74 1c                	je     802066 <print_mem_block_lists+0x5d>
  80204a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204d:	8b 50 08             	mov    0x8(%eax),%edx
  802050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802053:	8b 48 08             	mov    0x8(%eax),%ecx
  802056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802059:	8b 40 0c             	mov    0xc(%eax),%eax
  80205c:	01 c8                	add    %ecx,%eax
  80205e:	39 c2                	cmp    %eax,%edx
  802060:	73 04                	jae    802066 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802062:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	8b 50 08             	mov    0x8(%eax),%edx
  80206c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206f:	8b 40 0c             	mov    0xc(%eax),%eax
  802072:	01 c2                	add    %eax,%edx
  802074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802077:	8b 40 08             	mov    0x8(%eax),%eax
  80207a:	83 ec 04             	sub    $0x4,%esp
  80207d:	52                   	push   %edx
  80207e:	50                   	push   %eax
  80207f:	68 9d 3b 80 00       	push   $0x803b9d
  802084:	e8 b4 e6 ff ff       	call   80073d <cprintf>
  802089:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802092:	a1 40 41 80 00       	mov    0x804140,%eax
  802097:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209e:	74 07                	je     8020a7 <print_mem_block_lists+0x9e>
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	8b 00                	mov    (%eax),%eax
  8020a5:	eb 05                	jmp    8020ac <print_mem_block_lists+0xa3>
  8020a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ac:	a3 40 41 80 00       	mov    %eax,0x804140
  8020b1:	a1 40 41 80 00       	mov    0x804140,%eax
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	75 8a                	jne    802044 <print_mem_block_lists+0x3b>
  8020ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020be:	75 84                	jne    802044 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8020c0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020c4:	75 10                	jne    8020d6 <print_mem_block_lists+0xcd>
  8020c6:	83 ec 0c             	sub    $0xc,%esp
  8020c9:	68 ac 3b 80 00       	push   $0x803bac
  8020ce:	e8 6a e6 ff ff       	call   80073d <cprintf>
  8020d3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020dd:	83 ec 0c             	sub    $0xc,%esp
  8020e0:	68 d0 3b 80 00       	push   $0x803bd0
  8020e5:	e8 53 e6 ff ff       	call   80073d <cprintf>
  8020ea:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020ed:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020f1:	a1 40 40 80 00       	mov    0x804040,%eax
  8020f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f9:	eb 56                	jmp    802151 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020ff:	74 1c                	je     80211d <print_mem_block_lists+0x114>
  802101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802104:	8b 50 08             	mov    0x8(%eax),%edx
  802107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210a:	8b 48 08             	mov    0x8(%eax),%ecx
  80210d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802110:	8b 40 0c             	mov    0xc(%eax),%eax
  802113:	01 c8                	add    %ecx,%eax
  802115:	39 c2                	cmp    %eax,%edx
  802117:	73 04                	jae    80211d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802119:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80211d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802120:	8b 50 08             	mov    0x8(%eax),%edx
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	8b 40 0c             	mov    0xc(%eax),%eax
  802129:	01 c2                	add    %eax,%edx
  80212b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212e:	8b 40 08             	mov    0x8(%eax),%eax
  802131:	83 ec 04             	sub    $0x4,%esp
  802134:	52                   	push   %edx
  802135:	50                   	push   %eax
  802136:	68 9d 3b 80 00       	push   $0x803b9d
  80213b:	e8 fd e5 ff ff       	call   80073d <cprintf>
  802140:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802146:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802149:	a1 48 40 80 00       	mov    0x804048,%eax
  80214e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802151:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802155:	74 07                	je     80215e <print_mem_block_lists+0x155>
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	8b 00                	mov    (%eax),%eax
  80215c:	eb 05                	jmp    802163 <print_mem_block_lists+0x15a>
  80215e:	b8 00 00 00 00       	mov    $0x0,%eax
  802163:	a3 48 40 80 00       	mov    %eax,0x804048
  802168:	a1 48 40 80 00       	mov    0x804048,%eax
  80216d:	85 c0                	test   %eax,%eax
  80216f:	75 8a                	jne    8020fb <print_mem_block_lists+0xf2>
  802171:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802175:	75 84                	jne    8020fb <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802177:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80217b:	75 10                	jne    80218d <print_mem_block_lists+0x184>
  80217d:	83 ec 0c             	sub    $0xc,%esp
  802180:	68 e8 3b 80 00       	push   $0x803be8
  802185:	e8 b3 e5 ff ff       	call   80073d <cprintf>
  80218a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80218d:	83 ec 0c             	sub    $0xc,%esp
  802190:	68 5c 3b 80 00       	push   $0x803b5c
  802195:	e8 a3 e5 ff ff       	call   80073d <cprintf>
  80219a:	83 c4 10             	add    $0x10,%esp

}
  80219d:	90                   	nop
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8021a6:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8021ad:	00 00 00 
  8021b0:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8021b7:	00 00 00 
  8021ba:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8021c1:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8021c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021cb:	e9 9e 00 00 00       	jmp    80226e <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8021d0:	a1 50 40 80 00       	mov    0x804050,%eax
  8021d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d8:	c1 e2 04             	shl    $0x4,%edx
  8021db:	01 d0                	add    %edx,%eax
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	75 14                	jne    8021f5 <initialize_MemBlocksList+0x55>
  8021e1:	83 ec 04             	sub    $0x4,%esp
  8021e4:	68 10 3c 80 00       	push   $0x803c10
  8021e9:	6a 43                	push   $0x43
  8021eb:	68 33 3c 80 00       	push   $0x803c33
  8021f0:	e8 9c 0f 00 00       	call   803191 <_panic>
  8021f5:	a1 50 40 80 00       	mov    0x804050,%eax
  8021fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fd:	c1 e2 04             	shl    $0x4,%edx
  802200:	01 d0                	add    %edx,%eax
  802202:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802208:	89 10                	mov    %edx,(%eax)
  80220a:	8b 00                	mov    (%eax),%eax
  80220c:	85 c0                	test   %eax,%eax
  80220e:	74 18                	je     802228 <initialize_MemBlocksList+0x88>
  802210:	a1 48 41 80 00       	mov    0x804148,%eax
  802215:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80221b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80221e:	c1 e1 04             	shl    $0x4,%ecx
  802221:	01 ca                	add    %ecx,%edx
  802223:	89 50 04             	mov    %edx,0x4(%eax)
  802226:	eb 12                	jmp    80223a <initialize_MemBlocksList+0x9a>
  802228:	a1 50 40 80 00       	mov    0x804050,%eax
  80222d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802230:	c1 e2 04             	shl    $0x4,%edx
  802233:	01 d0                	add    %edx,%eax
  802235:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80223a:	a1 50 40 80 00       	mov    0x804050,%eax
  80223f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802242:	c1 e2 04             	shl    $0x4,%edx
  802245:	01 d0                	add    %edx,%eax
  802247:	a3 48 41 80 00       	mov    %eax,0x804148
  80224c:	a1 50 40 80 00       	mov    0x804050,%eax
  802251:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802254:	c1 e2 04             	shl    $0x4,%edx
  802257:	01 d0                	add    %edx,%eax
  802259:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802260:	a1 54 41 80 00       	mov    0x804154,%eax
  802265:	40                   	inc    %eax
  802266:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80226b:	ff 45 f4             	incl   -0xc(%ebp)
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	3b 45 08             	cmp    0x8(%ebp),%eax
  802274:	0f 82 56 ff ff ff    	jb     8021d0 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80227a:	90                   	nop
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802283:	a1 38 41 80 00       	mov    0x804138,%eax
  802288:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80228b:	eb 18                	jmp    8022a5 <find_block+0x28>
	{
		if (ele->sva==va)
  80228d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802290:	8b 40 08             	mov    0x8(%eax),%eax
  802293:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802296:	75 05                	jne    80229d <find_block+0x20>
			return ele;
  802298:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80229b:	eb 7b                	jmp    802318 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80229d:	a1 40 41 80 00       	mov    0x804140,%eax
  8022a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022a9:	74 07                	je     8022b2 <find_block+0x35>
  8022ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ae:	8b 00                	mov    (%eax),%eax
  8022b0:	eb 05                	jmp    8022b7 <find_block+0x3a>
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b7:	a3 40 41 80 00       	mov    %eax,0x804140
  8022bc:	a1 40 41 80 00       	mov    0x804140,%eax
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	75 c8                	jne    80228d <find_block+0x10>
  8022c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022c9:	75 c2                	jne    80228d <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8022cb:	a1 40 40 80 00       	mov    0x804040,%eax
  8022d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022d3:	eb 18                	jmp    8022ed <find_block+0x70>
	{
		if (ele->sva==va)
  8022d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022d8:	8b 40 08             	mov    0x8(%eax),%eax
  8022db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022de:	75 05                	jne    8022e5 <find_block+0x68>
					return ele;
  8022e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e3:	eb 33                	jmp    802318 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8022e5:	a1 48 40 80 00       	mov    0x804048,%eax
  8022ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022f1:	74 07                	je     8022fa <find_block+0x7d>
  8022f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f6:	8b 00                	mov    (%eax),%eax
  8022f8:	eb 05                	jmp    8022ff <find_block+0x82>
  8022fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ff:	a3 48 40 80 00       	mov    %eax,0x804048
  802304:	a1 48 40 80 00       	mov    0x804048,%eax
  802309:	85 c0                	test   %eax,%eax
  80230b:	75 c8                	jne    8022d5 <find_block+0x58>
  80230d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802311:	75 c2                	jne    8022d5 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802313:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
  80231d:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802320:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802325:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802328:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80232c:	75 62                	jne    802390 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80232e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802332:	75 14                	jne    802348 <insert_sorted_allocList+0x2e>
  802334:	83 ec 04             	sub    $0x4,%esp
  802337:	68 10 3c 80 00       	push   $0x803c10
  80233c:	6a 69                	push   $0x69
  80233e:	68 33 3c 80 00       	push   $0x803c33
  802343:	e8 49 0e 00 00       	call   803191 <_panic>
  802348:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	89 10                	mov    %edx,(%eax)
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	8b 00                	mov    (%eax),%eax
  802358:	85 c0                	test   %eax,%eax
  80235a:	74 0d                	je     802369 <insert_sorted_allocList+0x4f>
  80235c:	a1 40 40 80 00       	mov    0x804040,%eax
  802361:	8b 55 08             	mov    0x8(%ebp),%edx
  802364:	89 50 04             	mov    %edx,0x4(%eax)
  802367:	eb 08                	jmp    802371 <insert_sorted_allocList+0x57>
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	a3 44 40 80 00       	mov    %eax,0x804044
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	a3 40 40 80 00       	mov    %eax,0x804040
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802383:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802388:	40                   	inc    %eax
  802389:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80238e:	eb 72                	jmp    802402 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802390:	a1 40 40 80 00       	mov    0x804040,%eax
  802395:	8b 50 08             	mov    0x8(%eax),%edx
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	8b 40 08             	mov    0x8(%eax),%eax
  80239e:	39 c2                	cmp    %eax,%edx
  8023a0:	76 60                	jbe    802402 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8023a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023a6:	75 14                	jne    8023bc <insert_sorted_allocList+0xa2>
  8023a8:	83 ec 04             	sub    $0x4,%esp
  8023ab:	68 10 3c 80 00       	push   $0x803c10
  8023b0:	6a 6d                	push   $0x6d
  8023b2:	68 33 3c 80 00       	push   $0x803c33
  8023b7:	e8 d5 0d 00 00       	call   803191 <_panic>
  8023bc:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	89 10                	mov    %edx,(%eax)
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	8b 00                	mov    (%eax),%eax
  8023cc:	85 c0                	test   %eax,%eax
  8023ce:	74 0d                	je     8023dd <insert_sorted_allocList+0xc3>
  8023d0:	a1 40 40 80 00       	mov    0x804040,%eax
  8023d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d8:	89 50 04             	mov    %edx,0x4(%eax)
  8023db:	eb 08                	jmp    8023e5 <insert_sorted_allocList+0xcb>
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	a3 44 40 80 00       	mov    %eax,0x804044
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	a3 40 40 80 00       	mov    %eax,0x804040
  8023ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023fc:	40                   	inc    %eax
  8023fd:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802402:	a1 40 40 80 00       	mov    0x804040,%eax
  802407:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240a:	e9 b9 01 00 00       	jmp    8025c8 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	8b 50 08             	mov    0x8(%eax),%edx
  802415:	a1 40 40 80 00       	mov    0x804040,%eax
  80241a:	8b 40 08             	mov    0x8(%eax),%eax
  80241d:	39 c2                	cmp    %eax,%edx
  80241f:	76 7c                	jbe    80249d <insert_sorted_allocList+0x183>
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	8b 50 08             	mov    0x8(%eax),%edx
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 40 08             	mov    0x8(%eax),%eax
  80242d:	39 c2                	cmp    %eax,%edx
  80242f:	73 6c                	jae    80249d <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802435:	74 06                	je     80243d <insert_sorted_allocList+0x123>
  802437:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80243b:	75 14                	jne    802451 <insert_sorted_allocList+0x137>
  80243d:	83 ec 04             	sub    $0x4,%esp
  802440:	68 4c 3c 80 00       	push   $0x803c4c
  802445:	6a 75                	push   $0x75
  802447:	68 33 3c 80 00       	push   $0x803c33
  80244c:	e8 40 0d 00 00       	call   803191 <_panic>
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	8b 50 04             	mov    0x4(%eax),%edx
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	89 50 04             	mov    %edx,0x4(%eax)
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802463:	89 10                	mov    %edx,(%eax)
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 40 04             	mov    0x4(%eax),%eax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	74 0d                	je     80247c <insert_sorted_allocList+0x162>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 40 04             	mov    0x4(%eax),%eax
  802475:	8b 55 08             	mov    0x8(%ebp),%edx
  802478:	89 10                	mov    %edx,(%eax)
  80247a:	eb 08                	jmp    802484 <insert_sorted_allocList+0x16a>
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	a3 40 40 80 00       	mov    %eax,0x804040
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 55 08             	mov    0x8(%ebp),%edx
  80248a:	89 50 04             	mov    %edx,0x4(%eax)
  80248d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802492:	40                   	inc    %eax
  802493:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  802498:	e9 59 01 00 00       	jmp    8025f6 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  80249d:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a0:	8b 50 08             	mov    0x8(%eax),%edx
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 40 08             	mov    0x8(%eax),%eax
  8024a9:	39 c2                	cmp    %eax,%edx
  8024ab:	0f 86 98 00 00 00    	jbe    802549 <insert_sorted_allocList+0x22f>
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	8b 50 08             	mov    0x8(%eax),%edx
  8024b7:	a1 44 40 80 00       	mov    0x804044,%eax
  8024bc:	8b 40 08             	mov    0x8(%eax),%eax
  8024bf:	39 c2                	cmp    %eax,%edx
  8024c1:	0f 83 82 00 00 00    	jae    802549 <insert_sorted_allocList+0x22f>
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	8b 50 08             	mov    0x8(%eax),%edx
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 00                	mov    (%eax),%eax
  8024d2:	8b 40 08             	mov    0x8(%eax),%eax
  8024d5:	39 c2                	cmp    %eax,%edx
  8024d7:	73 70                	jae    802549 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8024d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024dd:	74 06                	je     8024e5 <insert_sorted_allocList+0x1cb>
  8024df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e3:	75 14                	jne    8024f9 <insert_sorted_allocList+0x1df>
  8024e5:	83 ec 04             	sub    $0x4,%esp
  8024e8:	68 84 3c 80 00       	push   $0x803c84
  8024ed:	6a 7c                	push   $0x7c
  8024ef:	68 33 3c 80 00       	push   $0x803c33
  8024f4:	e8 98 0c 00 00       	call   803191 <_panic>
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 10                	mov    (%eax),%edx
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	89 10                	mov    %edx,(%eax)
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	8b 00                	mov    (%eax),%eax
  802508:	85 c0                	test   %eax,%eax
  80250a:	74 0b                	je     802517 <insert_sorted_allocList+0x1fd>
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 00                	mov    (%eax),%eax
  802511:	8b 55 08             	mov    0x8(%ebp),%edx
  802514:	89 50 04             	mov    %edx,0x4(%eax)
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	8b 55 08             	mov    0x8(%ebp),%edx
  80251d:	89 10                	mov    %edx,(%eax)
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802525:	89 50 04             	mov    %edx,0x4(%eax)
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	8b 00                	mov    (%eax),%eax
  80252d:	85 c0                	test   %eax,%eax
  80252f:	75 08                	jne    802539 <insert_sorted_allocList+0x21f>
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	a3 44 40 80 00       	mov    %eax,0x804044
  802539:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80253e:	40                   	inc    %eax
  80253f:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802544:	e9 ad 00 00 00       	jmp    8025f6 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802549:	8b 45 08             	mov    0x8(%ebp),%eax
  80254c:	8b 50 08             	mov    0x8(%eax),%edx
  80254f:	a1 44 40 80 00       	mov    0x804044,%eax
  802554:	8b 40 08             	mov    0x8(%eax),%eax
  802557:	39 c2                	cmp    %eax,%edx
  802559:	76 65                	jbe    8025c0 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80255b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80255f:	75 17                	jne    802578 <insert_sorted_allocList+0x25e>
  802561:	83 ec 04             	sub    $0x4,%esp
  802564:	68 b8 3c 80 00       	push   $0x803cb8
  802569:	68 80 00 00 00       	push   $0x80
  80256e:	68 33 3c 80 00       	push   $0x803c33
  802573:	e8 19 0c 00 00       	call   803191 <_panic>
  802578:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	89 50 04             	mov    %edx,0x4(%eax)
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	8b 40 04             	mov    0x4(%eax),%eax
  80258a:	85 c0                	test   %eax,%eax
  80258c:	74 0c                	je     80259a <insert_sorted_allocList+0x280>
  80258e:	a1 44 40 80 00       	mov    0x804044,%eax
  802593:	8b 55 08             	mov    0x8(%ebp),%edx
  802596:	89 10                	mov    %edx,(%eax)
  802598:	eb 08                	jmp    8025a2 <insert_sorted_allocList+0x288>
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	a3 40 40 80 00       	mov    %eax,0x804040
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	a3 44 40 80 00       	mov    %eax,0x804044
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8025b8:	40                   	inc    %eax
  8025b9:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8025be:	eb 36                	jmp    8025f6 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8025c0:	a1 48 40 80 00       	mov    0x804048,%eax
  8025c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cc:	74 07                	je     8025d5 <insert_sorted_allocList+0x2bb>
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 00                	mov    (%eax),%eax
  8025d3:	eb 05                	jmp    8025da <insert_sorted_allocList+0x2c0>
  8025d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025da:	a3 48 40 80 00       	mov    %eax,0x804048
  8025df:	a1 48 40 80 00       	mov    0x804048,%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	0f 85 23 fe ff ff    	jne    80240f <insert_sorted_allocList+0xf5>
  8025ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f0:	0f 85 19 fe ff ff    	jne    80240f <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8025f6:	90                   	nop
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
  8025fc:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025ff:	a1 38 41 80 00       	mov    0x804138,%eax
  802604:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802607:	e9 7c 01 00 00       	jmp    802788 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 40 0c             	mov    0xc(%eax),%eax
  802612:	3b 45 08             	cmp    0x8(%ebp),%eax
  802615:	0f 85 90 00 00 00    	jne    8026ab <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802625:	75 17                	jne    80263e <alloc_block_FF+0x45>
  802627:	83 ec 04             	sub    $0x4,%esp
  80262a:	68 db 3c 80 00       	push   $0x803cdb
  80262f:	68 ba 00 00 00       	push   $0xba
  802634:	68 33 3c 80 00       	push   $0x803c33
  802639:	e8 53 0b 00 00       	call   803191 <_panic>
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	8b 00                	mov    (%eax),%eax
  802643:	85 c0                	test   %eax,%eax
  802645:	74 10                	je     802657 <alloc_block_FF+0x5e>
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 00                	mov    (%eax),%eax
  80264c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264f:	8b 52 04             	mov    0x4(%edx),%edx
  802652:	89 50 04             	mov    %edx,0x4(%eax)
  802655:	eb 0b                	jmp    802662 <alloc_block_FF+0x69>
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 40 04             	mov    0x4(%eax),%eax
  80265d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 40 04             	mov    0x4(%eax),%eax
  802668:	85 c0                	test   %eax,%eax
  80266a:	74 0f                	je     80267b <alloc_block_FF+0x82>
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 40 04             	mov    0x4(%eax),%eax
  802672:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802675:	8b 12                	mov    (%edx),%edx
  802677:	89 10                	mov    %edx,(%eax)
  802679:	eb 0a                	jmp    802685 <alloc_block_FF+0x8c>
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 00                	mov    (%eax),%eax
  802680:	a3 38 41 80 00       	mov    %eax,0x804138
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802698:	a1 44 41 80 00       	mov    0x804144,%eax
  80269d:	48                   	dec    %eax
  80269e:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8026a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a6:	e9 10 01 00 00       	jmp    8027bb <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b4:	0f 86 c6 00 00 00    	jbe    802780 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8026ba:	a1 48 41 80 00       	mov    0x804148,%eax
  8026bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8026c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026c6:	75 17                	jne    8026df <alloc_block_FF+0xe6>
  8026c8:	83 ec 04             	sub    $0x4,%esp
  8026cb:	68 db 3c 80 00       	push   $0x803cdb
  8026d0:	68 c2 00 00 00       	push   $0xc2
  8026d5:	68 33 3c 80 00       	push   $0x803c33
  8026da:	e8 b2 0a 00 00       	call   803191 <_panic>
  8026df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e2:	8b 00                	mov    (%eax),%eax
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	74 10                	je     8026f8 <alloc_block_FF+0xff>
  8026e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026eb:	8b 00                	mov    (%eax),%eax
  8026ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f0:	8b 52 04             	mov    0x4(%edx),%edx
  8026f3:	89 50 04             	mov    %edx,0x4(%eax)
  8026f6:	eb 0b                	jmp    802703 <alloc_block_FF+0x10a>
  8026f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fb:	8b 40 04             	mov    0x4(%eax),%eax
  8026fe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802706:	8b 40 04             	mov    0x4(%eax),%eax
  802709:	85 c0                	test   %eax,%eax
  80270b:	74 0f                	je     80271c <alloc_block_FF+0x123>
  80270d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802710:	8b 40 04             	mov    0x4(%eax),%eax
  802713:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802716:	8b 12                	mov    (%edx),%edx
  802718:	89 10                	mov    %edx,(%eax)
  80271a:	eb 0a                	jmp    802726 <alloc_block_FF+0x12d>
  80271c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271f:	8b 00                	mov    (%eax),%eax
  802721:	a3 48 41 80 00       	mov    %eax,0x804148
  802726:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802729:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802732:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802739:	a1 54 41 80 00       	mov    0x804154,%eax
  80273e:	48                   	dec    %eax
  80273f:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	8b 50 08             	mov    0x8(%eax),%edx
  80274a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274d:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802753:	8b 55 08             	mov    0x8(%ebp),%edx
  802756:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 40 0c             	mov    0xc(%eax),%eax
  80275f:	2b 45 08             	sub    0x8(%ebp),%eax
  802762:	89 c2                	mov    %eax,%edx
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	8b 50 08             	mov    0x8(%eax),%edx
  802770:	8b 45 08             	mov    0x8(%ebp),%eax
  802773:	01 c2                	add    %eax,%edx
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  80277b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277e:	eb 3b                	jmp    8027bb <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802780:	a1 40 41 80 00       	mov    0x804140,%eax
  802785:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278c:	74 07                	je     802795 <alloc_block_FF+0x19c>
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	eb 05                	jmp    80279a <alloc_block_FF+0x1a1>
  802795:	b8 00 00 00 00       	mov    $0x0,%eax
  80279a:	a3 40 41 80 00       	mov    %eax,0x804140
  80279f:	a1 40 41 80 00       	mov    0x804140,%eax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	0f 85 60 fe ff ff    	jne    80260c <alloc_block_FF+0x13>
  8027ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b0:	0f 85 56 fe ff ff    	jne    80260c <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bb:	c9                   	leave  
  8027bc:	c3                   	ret    

008027bd <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8027bd:	55                   	push   %ebp
  8027be:	89 e5                	mov    %esp,%ebp
  8027c0:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8027c3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8027ca:	a1 38 41 80 00       	mov    0x804138,%eax
  8027cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d2:	eb 3a                	jmp    80280e <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027dd:	72 27                	jb     802806 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8027df:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8027e3:	75 0b                	jne    8027f0 <alloc_block_BF+0x33>
					best_size= element->size;
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8027ee:	eb 16                	jmp    802806 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 50 0c             	mov    0xc(%eax),%edx
  8027f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f9:	39 c2                	cmp    %eax,%edx
  8027fb:	77 09                	ja     802806 <alloc_block_BF+0x49>
					best_size=element->size;
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 40 0c             	mov    0xc(%eax),%eax
  802803:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802806:	a1 40 41 80 00       	mov    0x804140,%eax
  80280b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802812:	74 07                	je     80281b <alloc_block_BF+0x5e>
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 00                	mov    (%eax),%eax
  802819:	eb 05                	jmp    802820 <alloc_block_BF+0x63>
  80281b:	b8 00 00 00 00       	mov    $0x0,%eax
  802820:	a3 40 41 80 00       	mov    %eax,0x804140
  802825:	a1 40 41 80 00       	mov    0x804140,%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	75 a6                	jne    8027d4 <alloc_block_BF+0x17>
  80282e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802832:	75 a0                	jne    8027d4 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802834:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802838:	0f 84 d3 01 00 00    	je     802a11 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80283e:	a1 38 41 80 00       	mov    0x804138,%eax
  802843:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802846:	e9 98 01 00 00       	jmp    8029e3 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  80284b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802851:	0f 86 da 00 00 00    	jbe    802931 <alloc_block_BF+0x174>
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 50 0c             	mov    0xc(%eax),%edx
  80285d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802860:	39 c2                	cmp    %eax,%edx
  802862:	0f 85 c9 00 00 00    	jne    802931 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802868:	a1 48 41 80 00       	mov    0x804148,%eax
  80286d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802870:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802874:	75 17                	jne    80288d <alloc_block_BF+0xd0>
  802876:	83 ec 04             	sub    $0x4,%esp
  802879:	68 db 3c 80 00       	push   $0x803cdb
  80287e:	68 ea 00 00 00       	push   $0xea
  802883:	68 33 3c 80 00       	push   $0x803c33
  802888:	e8 04 09 00 00       	call   803191 <_panic>
  80288d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802890:	8b 00                	mov    (%eax),%eax
  802892:	85 c0                	test   %eax,%eax
  802894:	74 10                	je     8028a6 <alloc_block_BF+0xe9>
  802896:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802899:	8b 00                	mov    (%eax),%eax
  80289b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80289e:	8b 52 04             	mov    0x4(%edx),%edx
  8028a1:	89 50 04             	mov    %edx,0x4(%eax)
  8028a4:	eb 0b                	jmp    8028b1 <alloc_block_BF+0xf4>
  8028a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ac:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b4:	8b 40 04             	mov    0x4(%eax),%eax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	74 0f                	je     8028ca <alloc_block_BF+0x10d>
  8028bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028be:	8b 40 04             	mov    0x4(%eax),%eax
  8028c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c4:	8b 12                	mov    (%edx),%edx
  8028c6:	89 10                	mov    %edx,(%eax)
  8028c8:	eb 0a                	jmp    8028d4 <alloc_block_BF+0x117>
  8028ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cd:	8b 00                	mov    (%eax),%eax
  8028cf:	a3 48 41 80 00       	mov    %eax,0x804148
  8028d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e7:	a1 54 41 80 00       	mov    0x804154,%eax
  8028ec:	48                   	dec    %eax
  8028ed:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	8b 50 08             	mov    0x8(%eax),%edx
  8028f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fb:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8028fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802901:	8b 55 08             	mov    0x8(%ebp),%edx
  802904:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	8b 40 0c             	mov    0xc(%eax),%eax
  80290d:	2b 45 08             	sub    0x8(%ebp),%eax
  802910:	89 c2                	mov    %eax,%edx
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 50 08             	mov    0x8(%eax),%edx
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	01 c2                	add    %eax,%edx
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292c:	e9 e5 00 00 00       	jmp    802a16 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 50 0c             	mov    0xc(%eax),%edx
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	39 c2                	cmp    %eax,%edx
  80293c:	0f 85 99 00 00 00    	jne    8029db <alloc_block_BF+0x21e>
  802942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802945:	3b 45 08             	cmp    0x8(%ebp),%eax
  802948:	0f 85 8d 00 00 00    	jne    8029db <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802954:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802958:	75 17                	jne    802971 <alloc_block_BF+0x1b4>
  80295a:	83 ec 04             	sub    $0x4,%esp
  80295d:	68 db 3c 80 00       	push   $0x803cdb
  802962:	68 f7 00 00 00       	push   $0xf7
  802967:	68 33 3c 80 00       	push   $0x803c33
  80296c:	e8 20 08 00 00       	call   803191 <_panic>
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 00                	mov    (%eax),%eax
  802976:	85 c0                	test   %eax,%eax
  802978:	74 10                	je     80298a <alloc_block_BF+0x1cd>
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 00                	mov    (%eax),%eax
  80297f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802982:	8b 52 04             	mov    0x4(%edx),%edx
  802985:	89 50 04             	mov    %edx,0x4(%eax)
  802988:	eb 0b                	jmp    802995 <alloc_block_BF+0x1d8>
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 40 04             	mov    0x4(%eax),%eax
  802990:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	8b 40 04             	mov    0x4(%eax),%eax
  80299b:	85 c0                	test   %eax,%eax
  80299d:	74 0f                	je     8029ae <alloc_block_BF+0x1f1>
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 40 04             	mov    0x4(%eax),%eax
  8029a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a8:	8b 12                	mov    (%edx),%edx
  8029aa:	89 10                	mov    %edx,(%eax)
  8029ac:	eb 0a                	jmp    8029b8 <alloc_block_BF+0x1fb>
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 00                	mov    (%eax),%eax
  8029b3:	a3 38 41 80 00       	mov    %eax,0x804138
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029cb:	a1 44 41 80 00       	mov    0x804144,%eax
  8029d0:	48                   	dec    %eax
  8029d1:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8029d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d9:	eb 3b                	jmp    802a16 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8029db:	a1 40 41 80 00       	mov    0x804140,%eax
  8029e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e7:	74 07                	je     8029f0 <alloc_block_BF+0x233>
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 00                	mov    (%eax),%eax
  8029ee:	eb 05                	jmp    8029f5 <alloc_block_BF+0x238>
  8029f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f5:	a3 40 41 80 00       	mov    %eax,0x804140
  8029fa:	a1 40 41 80 00       	mov    0x804140,%eax
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	0f 85 44 fe ff ff    	jne    80284b <alloc_block_BF+0x8e>
  802a07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0b:	0f 85 3a fe ff ff    	jne    80284b <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802a11:	b8 00 00 00 00       	mov    $0x0,%eax
  802a16:	c9                   	leave  
  802a17:	c3                   	ret    

00802a18 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a18:	55                   	push   %ebp
  802a19:	89 e5                	mov    %esp,%ebp
  802a1b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802a1e:	83 ec 04             	sub    $0x4,%esp
  802a21:	68 fc 3c 80 00       	push   $0x803cfc
  802a26:	68 04 01 00 00       	push   $0x104
  802a2b:	68 33 3c 80 00       	push   $0x803c33
  802a30:	e8 5c 07 00 00       	call   803191 <_panic>

00802a35 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802a35:	55                   	push   %ebp
  802a36:	89 e5                	mov    %esp,%ebp
  802a38:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802a3b:	a1 38 41 80 00       	mov    0x804138,%eax
  802a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802a43:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a48:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802a4b:	a1 38 41 80 00       	mov    0x804138,%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	75 68                	jne    802abc <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802a54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a58:	75 17                	jne    802a71 <insert_sorted_with_merge_freeList+0x3c>
  802a5a:	83 ec 04             	sub    $0x4,%esp
  802a5d:	68 10 3c 80 00       	push   $0x803c10
  802a62:	68 14 01 00 00       	push   $0x114
  802a67:	68 33 3c 80 00       	push   $0x803c33
  802a6c:	e8 20 07 00 00       	call   803191 <_panic>
  802a71:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	89 10                	mov    %edx,(%eax)
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	8b 00                	mov    (%eax),%eax
  802a81:	85 c0                	test   %eax,%eax
  802a83:	74 0d                	je     802a92 <insert_sorted_with_merge_freeList+0x5d>
  802a85:	a1 38 41 80 00       	mov    0x804138,%eax
  802a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8d:	89 50 04             	mov    %edx,0x4(%eax)
  802a90:	eb 08                	jmp    802a9a <insert_sorted_with_merge_freeList+0x65>
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	a3 38 41 80 00       	mov    %eax,0x804138
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aac:	a1 44 41 80 00       	mov    0x804144,%eax
  802ab1:	40                   	inc    %eax
  802ab2:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802ab7:	e9 d2 06 00 00       	jmp    80318e <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	8b 50 08             	mov    0x8(%eax),%edx
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	8b 40 08             	mov    0x8(%eax),%eax
  802ac8:	39 c2                	cmp    %eax,%edx
  802aca:	0f 83 22 01 00 00    	jae    802bf2 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	8b 50 08             	mov    0x8(%eax),%edx
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	8b 40 0c             	mov    0xc(%eax),%eax
  802adc:	01 c2                	add    %eax,%edx
  802ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae1:	8b 40 08             	mov    0x8(%eax),%eax
  802ae4:	39 c2                	cmp    %eax,%edx
  802ae6:	0f 85 9e 00 00 00    	jne    802b8a <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	8b 50 08             	mov    0x8(%eax),%edx
  802af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af5:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afb:	8b 50 0c             	mov    0xc(%eax),%edx
  802afe:	8b 45 08             	mov    0x8(%ebp),%eax
  802b01:	8b 40 0c             	mov    0xc(%eax),%eax
  802b04:	01 c2                	add    %eax,%edx
  802b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b09:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	8b 50 08             	mov    0x8(%eax),%edx
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b26:	75 17                	jne    802b3f <insert_sorted_with_merge_freeList+0x10a>
  802b28:	83 ec 04             	sub    $0x4,%esp
  802b2b:	68 10 3c 80 00       	push   $0x803c10
  802b30:	68 21 01 00 00       	push   $0x121
  802b35:	68 33 3c 80 00       	push   $0x803c33
  802b3a:	e8 52 06 00 00       	call   803191 <_panic>
  802b3f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b45:	8b 45 08             	mov    0x8(%ebp),%eax
  802b48:	89 10                	mov    %edx,(%eax)
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	85 c0                	test   %eax,%eax
  802b51:	74 0d                	je     802b60 <insert_sorted_with_merge_freeList+0x12b>
  802b53:	a1 48 41 80 00       	mov    0x804148,%eax
  802b58:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5b:	89 50 04             	mov    %edx,0x4(%eax)
  802b5e:	eb 08                	jmp    802b68 <insert_sorted_with_merge_freeList+0x133>
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	a3 48 41 80 00       	mov    %eax,0x804148
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7a:	a1 54 41 80 00       	mov    0x804154,%eax
  802b7f:	40                   	inc    %eax
  802b80:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802b85:	e9 04 06 00 00       	jmp    80318e <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802b8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8e:	75 17                	jne    802ba7 <insert_sorted_with_merge_freeList+0x172>
  802b90:	83 ec 04             	sub    $0x4,%esp
  802b93:	68 10 3c 80 00       	push   $0x803c10
  802b98:	68 26 01 00 00       	push   $0x126
  802b9d:	68 33 3c 80 00       	push   $0x803c33
  802ba2:	e8 ea 05 00 00       	call   803191 <_panic>
  802ba7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	89 10                	mov    %edx,(%eax)
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	8b 00                	mov    (%eax),%eax
  802bb7:	85 c0                	test   %eax,%eax
  802bb9:	74 0d                	je     802bc8 <insert_sorted_with_merge_freeList+0x193>
  802bbb:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc3:	89 50 04             	mov    %edx,0x4(%eax)
  802bc6:	eb 08                	jmp    802bd0 <insert_sorted_with_merge_freeList+0x19b>
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	a3 38 41 80 00       	mov    %eax,0x804138
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be2:	a1 44 41 80 00       	mov    0x804144,%eax
  802be7:	40                   	inc    %eax
  802be8:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802bed:	e9 9c 05 00 00       	jmp    80318e <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 50 08             	mov    0x8(%eax),%edx
  802bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfb:	8b 40 08             	mov    0x8(%eax),%eax
  802bfe:	39 c2                	cmp    %eax,%edx
  802c00:	0f 86 16 01 00 00    	jbe    802d1c <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c09:	8b 50 08             	mov    0x8(%eax),%edx
  802c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c12:	01 c2                	add    %eax,%edx
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	8b 40 08             	mov    0x8(%eax),%eax
  802c1a:	39 c2                	cmp    %eax,%edx
  802c1c:	0f 85 92 00 00 00    	jne    802cb4 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c25:	8b 50 0c             	mov    0xc(%eax),%edx
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2e:	01 c2                	add    %eax,%edx
  802c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c33:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	8b 50 08             	mov    0x8(%eax),%edx
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c50:	75 17                	jne    802c69 <insert_sorted_with_merge_freeList+0x234>
  802c52:	83 ec 04             	sub    $0x4,%esp
  802c55:	68 10 3c 80 00       	push   $0x803c10
  802c5a:	68 31 01 00 00       	push   $0x131
  802c5f:	68 33 3c 80 00       	push   $0x803c33
  802c64:	e8 28 05 00 00       	call   803191 <_panic>
  802c69:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	89 10                	mov    %edx,(%eax)
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 0d                	je     802c8a <insert_sorted_with_merge_freeList+0x255>
  802c7d:	a1 48 41 80 00       	mov    0x804148,%eax
  802c82:	8b 55 08             	mov    0x8(%ebp),%edx
  802c85:	89 50 04             	mov    %edx,0x4(%eax)
  802c88:	eb 08                	jmp    802c92 <insert_sorted_with_merge_freeList+0x25d>
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	a3 48 41 80 00       	mov    %eax,0x804148
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca4:	a1 54 41 80 00       	mov    0x804154,%eax
  802ca9:	40                   	inc    %eax
  802caa:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802caf:	e9 da 04 00 00       	jmp    80318e <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802cb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb8:	75 17                	jne    802cd1 <insert_sorted_with_merge_freeList+0x29c>
  802cba:	83 ec 04             	sub    $0x4,%esp
  802cbd:	68 b8 3c 80 00       	push   $0x803cb8
  802cc2:	68 37 01 00 00       	push   $0x137
  802cc7:	68 33 3c 80 00       	push   $0x803c33
  802ccc:	e8 c0 04 00 00       	call   803191 <_panic>
  802cd1:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	89 50 04             	mov    %edx,0x4(%eax)
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	8b 40 04             	mov    0x4(%eax),%eax
  802ce3:	85 c0                	test   %eax,%eax
  802ce5:	74 0c                	je     802cf3 <insert_sorted_with_merge_freeList+0x2be>
  802ce7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cec:	8b 55 08             	mov    0x8(%ebp),%edx
  802cef:	89 10                	mov    %edx,(%eax)
  802cf1:	eb 08                	jmp    802cfb <insert_sorted_with_merge_freeList+0x2c6>
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	a3 38 41 80 00       	mov    %eax,0x804138
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0c:	a1 44 41 80 00       	mov    0x804144,%eax
  802d11:	40                   	inc    %eax
  802d12:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802d17:	e9 72 04 00 00       	jmp    80318e <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802d1c:	a1 38 41 80 00       	mov    0x804138,%eax
  802d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d24:	e9 35 04 00 00       	jmp    80315e <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8b 50 08             	mov    0x8(%eax),%edx
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 40 08             	mov    0x8(%eax),%eax
  802d3d:	39 c2                	cmp    %eax,%edx
  802d3f:	0f 86 11 04 00 00    	jbe    803156 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 50 08             	mov    0x8(%eax),%edx
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d51:	01 c2                	add    %eax,%edx
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 40 08             	mov    0x8(%eax),%eax
  802d59:	39 c2                	cmp    %eax,%edx
  802d5b:	0f 83 8b 00 00 00    	jae    802dec <insert_sorted_with_merge_freeList+0x3b7>
  802d61:	8b 45 08             	mov    0x8(%ebp),%eax
  802d64:	8b 50 08             	mov    0x8(%eax),%edx
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6d:	01 c2                	add    %eax,%edx
  802d6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d72:	8b 40 08             	mov    0x8(%eax),%eax
  802d75:	39 c2                	cmp    %eax,%edx
  802d77:	73 73                	jae    802dec <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802d79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7d:	74 06                	je     802d85 <insert_sorted_with_merge_freeList+0x350>
  802d7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d83:	75 17                	jne    802d9c <insert_sorted_with_merge_freeList+0x367>
  802d85:	83 ec 04             	sub    $0x4,%esp
  802d88:	68 84 3c 80 00       	push   $0x803c84
  802d8d:	68 48 01 00 00       	push   $0x148
  802d92:	68 33 3c 80 00       	push   $0x803c33
  802d97:	e8 f5 03 00 00       	call   803191 <_panic>
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 10                	mov    (%eax),%edx
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	89 10                	mov    %edx,(%eax)
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	8b 00                	mov    (%eax),%eax
  802dab:	85 c0                	test   %eax,%eax
  802dad:	74 0b                	je     802dba <insert_sorted_with_merge_freeList+0x385>
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	8b 00                	mov    (%eax),%eax
  802db4:	8b 55 08             	mov    0x8(%ebp),%edx
  802db7:	89 50 04             	mov    %edx,0x4(%eax)
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc0:	89 10                	mov    %edx,(%eax)
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc8:	89 50 04             	mov    %edx,0x4(%eax)
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	8b 00                	mov    (%eax),%eax
  802dd0:	85 c0                	test   %eax,%eax
  802dd2:	75 08                	jne    802ddc <insert_sorted_with_merge_freeList+0x3a7>
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ddc:	a1 44 41 80 00       	mov    0x804144,%eax
  802de1:	40                   	inc    %eax
  802de2:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802de7:	e9 a2 03 00 00       	jmp    80318e <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	8b 50 08             	mov    0x8(%eax),%edx
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	8b 40 0c             	mov    0xc(%eax),%eax
  802df8:	01 c2                	add    %eax,%edx
  802dfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfd:	8b 40 08             	mov    0x8(%eax),%eax
  802e00:	39 c2                	cmp    %eax,%edx
  802e02:	0f 83 ae 00 00 00    	jae    802eb6 <insert_sorted_with_merge_freeList+0x481>
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	8b 50 08             	mov    0x8(%eax),%edx
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 48 08             	mov    0x8(%eax),%ecx
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1a:	01 c8                	add    %ecx,%eax
  802e1c:	39 c2                	cmp    %eax,%edx
  802e1e:	0f 85 92 00 00 00    	jne    802eb6 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 50 0c             	mov    0xc(%eax),%edx
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e30:	01 c2                	add    %eax,%edx
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	8b 50 08             	mov    0x8(%eax),%edx
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e52:	75 17                	jne    802e6b <insert_sorted_with_merge_freeList+0x436>
  802e54:	83 ec 04             	sub    $0x4,%esp
  802e57:	68 10 3c 80 00       	push   $0x803c10
  802e5c:	68 51 01 00 00       	push   $0x151
  802e61:	68 33 3c 80 00       	push   $0x803c33
  802e66:	e8 26 03 00 00       	call   803191 <_panic>
  802e6b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	89 10                	mov    %edx,(%eax)
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	8b 00                	mov    (%eax),%eax
  802e7b:	85 c0                	test   %eax,%eax
  802e7d:	74 0d                	je     802e8c <insert_sorted_with_merge_freeList+0x457>
  802e7f:	a1 48 41 80 00       	mov    0x804148,%eax
  802e84:	8b 55 08             	mov    0x8(%ebp),%edx
  802e87:	89 50 04             	mov    %edx,0x4(%eax)
  802e8a:	eb 08                	jmp    802e94 <insert_sorted_with_merge_freeList+0x45f>
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	a3 48 41 80 00       	mov    %eax,0x804148
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea6:	a1 54 41 80 00       	mov    0x804154,%eax
  802eab:	40                   	inc    %eax
  802eac:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802eb1:	e9 d8 02 00 00       	jmp    80318e <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	8b 50 08             	mov    0x8(%eax),%edx
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec2:	01 c2                	add    %eax,%edx
  802ec4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec7:	8b 40 08             	mov    0x8(%eax),%eax
  802eca:	39 c2                	cmp    %eax,%edx
  802ecc:	0f 85 ba 00 00 00    	jne    802f8c <insert_sorted_with_merge_freeList+0x557>
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	8b 50 08             	mov    0x8(%eax),%edx
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 48 08             	mov    0x8(%eax),%ecx
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee4:	01 c8                	add    %ecx,%eax
  802ee6:	39 c2                	cmp    %eax,%edx
  802ee8:	0f 86 9e 00 00 00    	jbe    802f8c <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802eee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	8b 40 0c             	mov    0xc(%eax),%eax
  802efa:	01 c2                	add    %eax,%edx
  802efc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eff:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	8b 50 08             	mov    0x8(%eax),%edx
  802f08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0b:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	8b 50 08             	mov    0x8(%eax),%edx
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f28:	75 17                	jne    802f41 <insert_sorted_with_merge_freeList+0x50c>
  802f2a:	83 ec 04             	sub    $0x4,%esp
  802f2d:	68 10 3c 80 00       	push   $0x803c10
  802f32:	68 5b 01 00 00       	push   $0x15b
  802f37:	68 33 3c 80 00       	push   $0x803c33
  802f3c:	e8 50 02 00 00       	call   803191 <_panic>
  802f41:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	89 10                	mov    %edx,(%eax)
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	74 0d                	je     802f62 <insert_sorted_with_merge_freeList+0x52d>
  802f55:	a1 48 41 80 00       	mov    0x804148,%eax
  802f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5d:	89 50 04             	mov    %edx,0x4(%eax)
  802f60:	eb 08                	jmp    802f6a <insert_sorted_with_merge_freeList+0x535>
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	a3 48 41 80 00       	mov    %eax,0x804148
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7c:	a1 54 41 80 00       	mov    0x804154,%eax
  802f81:	40                   	inc    %eax
  802f82:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f87:	e9 02 02 00 00       	jmp    80318e <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	8b 50 08             	mov    0x8(%eax),%edx
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	8b 40 0c             	mov    0xc(%eax),%eax
  802f98:	01 c2                	add    %eax,%edx
  802f9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9d:	8b 40 08             	mov    0x8(%eax),%eax
  802fa0:	39 c2                	cmp    %eax,%edx
  802fa2:	0f 85 ae 01 00 00    	jne    803156 <insert_sorted_with_merge_freeList+0x721>
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	8b 50 08             	mov    0x8(%eax),%edx
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	8b 48 08             	mov    0x8(%eax),%ecx
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fba:	01 c8                	add    %ecx,%eax
  802fbc:	39 c2                	cmp    %eax,%edx
  802fbe:	0f 85 92 01 00 00    	jne    803156 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc7:	8b 50 0c             	mov    0xc(%eax),%edx
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd0:	01 c2                	add    %eax,%edx
  802fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd8:	01 c2                	add    %eax,%edx
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	8b 50 08             	mov    0x8(%eax),%edx
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802ff6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803000:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803003:	8b 50 08             	mov    0x8(%eax),%edx
  803006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803009:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  80300c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803010:	75 17                	jne    803029 <insert_sorted_with_merge_freeList+0x5f4>
  803012:	83 ec 04             	sub    $0x4,%esp
  803015:	68 db 3c 80 00       	push   $0x803cdb
  80301a:	68 63 01 00 00       	push   $0x163
  80301f:	68 33 3c 80 00       	push   $0x803c33
  803024:	e8 68 01 00 00       	call   803191 <_panic>
  803029:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	85 c0                	test   %eax,%eax
  803030:	74 10                	je     803042 <insert_sorted_with_merge_freeList+0x60d>
  803032:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803035:	8b 00                	mov    (%eax),%eax
  803037:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303a:	8b 52 04             	mov    0x4(%edx),%edx
  80303d:	89 50 04             	mov    %edx,0x4(%eax)
  803040:	eb 0b                	jmp    80304d <insert_sorted_with_merge_freeList+0x618>
  803042:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803045:	8b 40 04             	mov    0x4(%eax),%eax
  803048:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80304d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803050:	8b 40 04             	mov    0x4(%eax),%eax
  803053:	85 c0                	test   %eax,%eax
  803055:	74 0f                	je     803066 <insert_sorted_with_merge_freeList+0x631>
  803057:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305a:	8b 40 04             	mov    0x4(%eax),%eax
  80305d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803060:	8b 12                	mov    (%edx),%edx
  803062:	89 10                	mov    %edx,(%eax)
  803064:	eb 0a                	jmp    803070 <insert_sorted_with_merge_freeList+0x63b>
  803066:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803069:	8b 00                	mov    (%eax),%eax
  80306b:	a3 38 41 80 00       	mov    %eax,0x804138
  803070:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803073:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803079:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803083:	a1 44 41 80 00       	mov    0x804144,%eax
  803088:	48                   	dec    %eax
  803089:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  80308e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803092:	75 17                	jne    8030ab <insert_sorted_with_merge_freeList+0x676>
  803094:	83 ec 04             	sub    $0x4,%esp
  803097:	68 10 3c 80 00       	push   $0x803c10
  80309c:	68 64 01 00 00       	push   $0x164
  8030a1:	68 33 3c 80 00       	push   $0x803c33
  8030a6:	e8 e6 00 00 00       	call   803191 <_panic>
  8030ab:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b4:	89 10                	mov    %edx,(%eax)
  8030b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b9:	8b 00                	mov    (%eax),%eax
  8030bb:	85 c0                	test   %eax,%eax
  8030bd:	74 0d                	je     8030cc <insert_sorted_with_merge_freeList+0x697>
  8030bf:	a1 48 41 80 00       	mov    0x804148,%eax
  8030c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ca:	eb 08                	jmp    8030d4 <insert_sorted_with_merge_freeList+0x69f>
  8030cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d7:	a3 48 41 80 00       	mov    %eax,0x804148
  8030dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e6:	a1 54 41 80 00       	mov    0x804154,%eax
  8030eb:	40                   	inc    %eax
  8030ec:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8030f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f5:	75 17                	jne    80310e <insert_sorted_with_merge_freeList+0x6d9>
  8030f7:	83 ec 04             	sub    $0x4,%esp
  8030fa:	68 10 3c 80 00       	push   $0x803c10
  8030ff:	68 65 01 00 00       	push   $0x165
  803104:	68 33 3c 80 00       	push   $0x803c33
  803109:	e8 83 00 00 00       	call   803191 <_panic>
  80310e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	89 10                	mov    %edx,(%eax)
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	85 c0                	test   %eax,%eax
  803120:	74 0d                	je     80312f <insert_sorted_with_merge_freeList+0x6fa>
  803122:	a1 48 41 80 00       	mov    0x804148,%eax
  803127:	8b 55 08             	mov    0x8(%ebp),%edx
  80312a:	89 50 04             	mov    %edx,0x4(%eax)
  80312d:	eb 08                	jmp    803137 <insert_sorted_with_merge_freeList+0x702>
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	a3 48 41 80 00       	mov    %eax,0x804148
  80313f:	8b 45 08             	mov    0x8(%ebp),%eax
  803142:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803149:	a1 54 41 80 00       	mov    0x804154,%eax
  80314e:	40                   	inc    %eax
  80314f:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  803154:	eb 38                	jmp    80318e <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803156:	a1 40 41 80 00       	mov    0x804140,%eax
  80315b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80315e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803162:	74 07                	je     80316b <insert_sorted_with_merge_freeList+0x736>
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	eb 05                	jmp    803170 <insert_sorted_with_merge_freeList+0x73b>
  80316b:	b8 00 00 00 00       	mov    $0x0,%eax
  803170:	a3 40 41 80 00       	mov    %eax,0x804140
  803175:	a1 40 41 80 00       	mov    0x804140,%eax
  80317a:	85 c0                	test   %eax,%eax
  80317c:	0f 85 a7 fb ff ff    	jne    802d29 <insert_sorted_with_merge_freeList+0x2f4>
  803182:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803186:	0f 85 9d fb ff ff    	jne    802d29 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80318c:	eb 00                	jmp    80318e <insert_sorted_with_merge_freeList+0x759>
  80318e:	90                   	nop
  80318f:	c9                   	leave  
  803190:	c3                   	ret    

00803191 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803191:	55                   	push   %ebp
  803192:	89 e5                	mov    %esp,%ebp
  803194:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803197:	8d 45 10             	lea    0x10(%ebp),%eax
  80319a:	83 c0 04             	add    $0x4,%eax
  80319d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8031a0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	74 16                	je     8031bf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8031a9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031ae:	83 ec 08             	sub    $0x8,%esp
  8031b1:	50                   	push   %eax
  8031b2:	68 2c 3d 80 00       	push   $0x803d2c
  8031b7:	e8 81 d5 ff ff       	call   80073d <cprintf>
  8031bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8031bf:	a1 00 40 80 00       	mov    0x804000,%eax
  8031c4:	ff 75 0c             	pushl  0xc(%ebp)
  8031c7:	ff 75 08             	pushl  0x8(%ebp)
  8031ca:	50                   	push   %eax
  8031cb:	68 31 3d 80 00       	push   $0x803d31
  8031d0:	e8 68 d5 ff ff       	call   80073d <cprintf>
  8031d5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8031d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8031db:	83 ec 08             	sub    $0x8,%esp
  8031de:	ff 75 f4             	pushl  -0xc(%ebp)
  8031e1:	50                   	push   %eax
  8031e2:	e8 eb d4 ff ff       	call   8006d2 <vcprintf>
  8031e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8031ea:	83 ec 08             	sub    $0x8,%esp
  8031ed:	6a 00                	push   $0x0
  8031ef:	68 4d 3d 80 00       	push   $0x803d4d
  8031f4:	e8 d9 d4 ff ff       	call   8006d2 <vcprintf>
  8031f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8031fc:	e8 5a d4 ff ff       	call   80065b <exit>

	// should not return here
	while (1) ;
  803201:	eb fe                	jmp    803201 <_panic+0x70>

00803203 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803203:	55                   	push   %ebp
  803204:	89 e5                	mov    %esp,%ebp
  803206:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803209:	a1 20 40 80 00       	mov    0x804020,%eax
  80320e:	8b 50 74             	mov    0x74(%eax),%edx
  803211:	8b 45 0c             	mov    0xc(%ebp),%eax
  803214:	39 c2                	cmp    %eax,%edx
  803216:	74 14                	je     80322c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803218:	83 ec 04             	sub    $0x4,%esp
  80321b:	68 50 3d 80 00       	push   $0x803d50
  803220:	6a 26                	push   $0x26
  803222:	68 9c 3d 80 00       	push   $0x803d9c
  803227:	e8 65 ff ff ff       	call   803191 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80322c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803233:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80323a:	e9 c2 00 00 00       	jmp    803301 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80323f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	01 d0                	add    %edx,%eax
  80324e:	8b 00                	mov    (%eax),%eax
  803250:	85 c0                	test   %eax,%eax
  803252:	75 08                	jne    80325c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803254:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803257:	e9 a2 00 00 00       	jmp    8032fe <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80325c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803263:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80326a:	eb 69                	jmp    8032d5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80326c:	a1 20 40 80 00       	mov    0x804020,%eax
  803271:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803277:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80327a:	89 d0                	mov    %edx,%eax
  80327c:	01 c0                	add    %eax,%eax
  80327e:	01 d0                	add    %edx,%eax
  803280:	c1 e0 03             	shl    $0x3,%eax
  803283:	01 c8                	add    %ecx,%eax
  803285:	8a 40 04             	mov    0x4(%eax),%al
  803288:	84 c0                	test   %al,%al
  80328a:	75 46                	jne    8032d2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80328c:	a1 20 40 80 00       	mov    0x804020,%eax
  803291:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803297:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329a:	89 d0                	mov    %edx,%eax
  80329c:	01 c0                	add    %eax,%eax
  80329e:	01 d0                	add    %edx,%eax
  8032a0:	c1 e0 03             	shl    $0x3,%eax
  8032a3:	01 c8                	add    %ecx,%eax
  8032a5:	8b 00                	mov    (%eax),%eax
  8032a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8032aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8032b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8032b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	01 c8                	add    %ecx,%eax
  8032c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8032c5:	39 c2                	cmp    %eax,%edx
  8032c7:	75 09                	jne    8032d2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8032c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8032d0:	eb 12                	jmp    8032e4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032d2:	ff 45 e8             	incl   -0x18(%ebp)
  8032d5:	a1 20 40 80 00       	mov    0x804020,%eax
  8032da:	8b 50 74             	mov    0x74(%eax),%edx
  8032dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e0:	39 c2                	cmp    %eax,%edx
  8032e2:	77 88                	ja     80326c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8032e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032e8:	75 14                	jne    8032fe <CheckWSWithoutLastIndex+0xfb>
			panic(
  8032ea:	83 ec 04             	sub    $0x4,%esp
  8032ed:	68 a8 3d 80 00       	push   $0x803da8
  8032f2:	6a 3a                	push   $0x3a
  8032f4:	68 9c 3d 80 00       	push   $0x803d9c
  8032f9:	e8 93 fe ff ff       	call   803191 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8032fe:	ff 45 f0             	incl   -0x10(%ebp)
  803301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803304:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803307:	0f 8c 32 ff ff ff    	jl     80323f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80330d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803314:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80331b:	eb 26                	jmp    803343 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80331d:	a1 20 40 80 00       	mov    0x804020,%eax
  803322:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803328:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80332b:	89 d0                	mov    %edx,%eax
  80332d:	01 c0                	add    %eax,%eax
  80332f:	01 d0                	add    %edx,%eax
  803331:	c1 e0 03             	shl    $0x3,%eax
  803334:	01 c8                	add    %ecx,%eax
  803336:	8a 40 04             	mov    0x4(%eax),%al
  803339:	3c 01                	cmp    $0x1,%al
  80333b:	75 03                	jne    803340 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80333d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803340:	ff 45 e0             	incl   -0x20(%ebp)
  803343:	a1 20 40 80 00       	mov    0x804020,%eax
  803348:	8b 50 74             	mov    0x74(%eax),%edx
  80334b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80334e:	39 c2                	cmp    %eax,%edx
  803350:	77 cb                	ja     80331d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803355:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803358:	74 14                	je     80336e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80335a:	83 ec 04             	sub    $0x4,%esp
  80335d:	68 fc 3d 80 00       	push   $0x803dfc
  803362:	6a 44                	push   $0x44
  803364:	68 9c 3d 80 00       	push   $0x803d9c
  803369:	e8 23 fe ff ff       	call   803191 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80336e:	90                   	nop
  80336f:	c9                   	leave  
  803370:	c3                   	ret    
  803371:	66 90                	xchg   %ax,%ax
  803373:	90                   	nop

00803374 <__udivdi3>:
  803374:	55                   	push   %ebp
  803375:	57                   	push   %edi
  803376:	56                   	push   %esi
  803377:	53                   	push   %ebx
  803378:	83 ec 1c             	sub    $0x1c,%esp
  80337b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80337f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803383:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803387:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80338b:	89 ca                	mov    %ecx,%edx
  80338d:	89 f8                	mov    %edi,%eax
  80338f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803393:	85 f6                	test   %esi,%esi
  803395:	75 2d                	jne    8033c4 <__udivdi3+0x50>
  803397:	39 cf                	cmp    %ecx,%edi
  803399:	77 65                	ja     803400 <__udivdi3+0x8c>
  80339b:	89 fd                	mov    %edi,%ebp
  80339d:	85 ff                	test   %edi,%edi
  80339f:	75 0b                	jne    8033ac <__udivdi3+0x38>
  8033a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8033a6:	31 d2                	xor    %edx,%edx
  8033a8:	f7 f7                	div    %edi
  8033aa:	89 c5                	mov    %eax,%ebp
  8033ac:	31 d2                	xor    %edx,%edx
  8033ae:	89 c8                	mov    %ecx,%eax
  8033b0:	f7 f5                	div    %ebp
  8033b2:	89 c1                	mov    %eax,%ecx
  8033b4:	89 d8                	mov    %ebx,%eax
  8033b6:	f7 f5                	div    %ebp
  8033b8:	89 cf                	mov    %ecx,%edi
  8033ba:	89 fa                	mov    %edi,%edx
  8033bc:	83 c4 1c             	add    $0x1c,%esp
  8033bf:	5b                   	pop    %ebx
  8033c0:	5e                   	pop    %esi
  8033c1:	5f                   	pop    %edi
  8033c2:	5d                   	pop    %ebp
  8033c3:	c3                   	ret    
  8033c4:	39 ce                	cmp    %ecx,%esi
  8033c6:	77 28                	ja     8033f0 <__udivdi3+0x7c>
  8033c8:	0f bd fe             	bsr    %esi,%edi
  8033cb:	83 f7 1f             	xor    $0x1f,%edi
  8033ce:	75 40                	jne    803410 <__udivdi3+0x9c>
  8033d0:	39 ce                	cmp    %ecx,%esi
  8033d2:	72 0a                	jb     8033de <__udivdi3+0x6a>
  8033d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033d8:	0f 87 9e 00 00 00    	ja     80347c <__udivdi3+0x108>
  8033de:	b8 01 00 00 00       	mov    $0x1,%eax
  8033e3:	89 fa                	mov    %edi,%edx
  8033e5:	83 c4 1c             	add    $0x1c,%esp
  8033e8:	5b                   	pop    %ebx
  8033e9:	5e                   	pop    %esi
  8033ea:	5f                   	pop    %edi
  8033eb:	5d                   	pop    %ebp
  8033ec:	c3                   	ret    
  8033ed:	8d 76 00             	lea    0x0(%esi),%esi
  8033f0:	31 ff                	xor    %edi,%edi
  8033f2:	31 c0                	xor    %eax,%eax
  8033f4:	89 fa                	mov    %edi,%edx
  8033f6:	83 c4 1c             	add    $0x1c,%esp
  8033f9:	5b                   	pop    %ebx
  8033fa:	5e                   	pop    %esi
  8033fb:	5f                   	pop    %edi
  8033fc:	5d                   	pop    %ebp
  8033fd:	c3                   	ret    
  8033fe:	66 90                	xchg   %ax,%ax
  803400:	89 d8                	mov    %ebx,%eax
  803402:	f7 f7                	div    %edi
  803404:	31 ff                	xor    %edi,%edi
  803406:	89 fa                	mov    %edi,%edx
  803408:	83 c4 1c             	add    $0x1c,%esp
  80340b:	5b                   	pop    %ebx
  80340c:	5e                   	pop    %esi
  80340d:	5f                   	pop    %edi
  80340e:	5d                   	pop    %ebp
  80340f:	c3                   	ret    
  803410:	bd 20 00 00 00       	mov    $0x20,%ebp
  803415:	89 eb                	mov    %ebp,%ebx
  803417:	29 fb                	sub    %edi,%ebx
  803419:	89 f9                	mov    %edi,%ecx
  80341b:	d3 e6                	shl    %cl,%esi
  80341d:	89 c5                	mov    %eax,%ebp
  80341f:	88 d9                	mov    %bl,%cl
  803421:	d3 ed                	shr    %cl,%ebp
  803423:	89 e9                	mov    %ebp,%ecx
  803425:	09 f1                	or     %esi,%ecx
  803427:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80342b:	89 f9                	mov    %edi,%ecx
  80342d:	d3 e0                	shl    %cl,%eax
  80342f:	89 c5                	mov    %eax,%ebp
  803431:	89 d6                	mov    %edx,%esi
  803433:	88 d9                	mov    %bl,%cl
  803435:	d3 ee                	shr    %cl,%esi
  803437:	89 f9                	mov    %edi,%ecx
  803439:	d3 e2                	shl    %cl,%edx
  80343b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80343f:	88 d9                	mov    %bl,%cl
  803441:	d3 e8                	shr    %cl,%eax
  803443:	09 c2                	or     %eax,%edx
  803445:	89 d0                	mov    %edx,%eax
  803447:	89 f2                	mov    %esi,%edx
  803449:	f7 74 24 0c          	divl   0xc(%esp)
  80344d:	89 d6                	mov    %edx,%esi
  80344f:	89 c3                	mov    %eax,%ebx
  803451:	f7 e5                	mul    %ebp
  803453:	39 d6                	cmp    %edx,%esi
  803455:	72 19                	jb     803470 <__udivdi3+0xfc>
  803457:	74 0b                	je     803464 <__udivdi3+0xf0>
  803459:	89 d8                	mov    %ebx,%eax
  80345b:	31 ff                	xor    %edi,%edi
  80345d:	e9 58 ff ff ff       	jmp    8033ba <__udivdi3+0x46>
  803462:	66 90                	xchg   %ax,%ax
  803464:	8b 54 24 08          	mov    0x8(%esp),%edx
  803468:	89 f9                	mov    %edi,%ecx
  80346a:	d3 e2                	shl    %cl,%edx
  80346c:	39 c2                	cmp    %eax,%edx
  80346e:	73 e9                	jae    803459 <__udivdi3+0xe5>
  803470:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803473:	31 ff                	xor    %edi,%edi
  803475:	e9 40 ff ff ff       	jmp    8033ba <__udivdi3+0x46>
  80347a:	66 90                	xchg   %ax,%ax
  80347c:	31 c0                	xor    %eax,%eax
  80347e:	e9 37 ff ff ff       	jmp    8033ba <__udivdi3+0x46>
  803483:	90                   	nop

00803484 <__umoddi3>:
  803484:	55                   	push   %ebp
  803485:	57                   	push   %edi
  803486:	56                   	push   %esi
  803487:	53                   	push   %ebx
  803488:	83 ec 1c             	sub    $0x1c,%esp
  80348b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80348f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803493:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803497:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80349b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80349f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034a3:	89 f3                	mov    %esi,%ebx
  8034a5:	89 fa                	mov    %edi,%edx
  8034a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034ab:	89 34 24             	mov    %esi,(%esp)
  8034ae:	85 c0                	test   %eax,%eax
  8034b0:	75 1a                	jne    8034cc <__umoddi3+0x48>
  8034b2:	39 f7                	cmp    %esi,%edi
  8034b4:	0f 86 a2 00 00 00    	jbe    80355c <__umoddi3+0xd8>
  8034ba:	89 c8                	mov    %ecx,%eax
  8034bc:	89 f2                	mov    %esi,%edx
  8034be:	f7 f7                	div    %edi
  8034c0:	89 d0                	mov    %edx,%eax
  8034c2:	31 d2                	xor    %edx,%edx
  8034c4:	83 c4 1c             	add    $0x1c,%esp
  8034c7:	5b                   	pop    %ebx
  8034c8:	5e                   	pop    %esi
  8034c9:	5f                   	pop    %edi
  8034ca:	5d                   	pop    %ebp
  8034cb:	c3                   	ret    
  8034cc:	39 f0                	cmp    %esi,%eax
  8034ce:	0f 87 ac 00 00 00    	ja     803580 <__umoddi3+0xfc>
  8034d4:	0f bd e8             	bsr    %eax,%ebp
  8034d7:	83 f5 1f             	xor    $0x1f,%ebp
  8034da:	0f 84 ac 00 00 00    	je     80358c <__umoddi3+0x108>
  8034e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8034e5:	29 ef                	sub    %ebp,%edi
  8034e7:	89 fe                	mov    %edi,%esi
  8034e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034ed:	89 e9                	mov    %ebp,%ecx
  8034ef:	d3 e0                	shl    %cl,%eax
  8034f1:	89 d7                	mov    %edx,%edi
  8034f3:	89 f1                	mov    %esi,%ecx
  8034f5:	d3 ef                	shr    %cl,%edi
  8034f7:	09 c7                	or     %eax,%edi
  8034f9:	89 e9                	mov    %ebp,%ecx
  8034fb:	d3 e2                	shl    %cl,%edx
  8034fd:	89 14 24             	mov    %edx,(%esp)
  803500:	89 d8                	mov    %ebx,%eax
  803502:	d3 e0                	shl    %cl,%eax
  803504:	89 c2                	mov    %eax,%edx
  803506:	8b 44 24 08          	mov    0x8(%esp),%eax
  80350a:	d3 e0                	shl    %cl,%eax
  80350c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803510:	8b 44 24 08          	mov    0x8(%esp),%eax
  803514:	89 f1                	mov    %esi,%ecx
  803516:	d3 e8                	shr    %cl,%eax
  803518:	09 d0                	or     %edx,%eax
  80351a:	d3 eb                	shr    %cl,%ebx
  80351c:	89 da                	mov    %ebx,%edx
  80351e:	f7 f7                	div    %edi
  803520:	89 d3                	mov    %edx,%ebx
  803522:	f7 24 24             	mull   (%esp)
  803525:	89 c6                	mov    %eax,%esi
  803527:	89 d1                	mov    %edx,%ecx
  803529:	39 d3                	cmp    %edx,%ebx
  80352b:	0f 82 87 00 00 00    	jb     8035b8 <__umoddi3+0x134>
  803531:	0f 84 91 00 00 00    	je     8035c8 <__umoddi3+0x144>
  803537:	8b 54 24 04          	mov    0x4(%esp),%edx
  80353b:	29 f2                	sub    %esi,%edx
  80353d:	19 cb                	sbb    %ecx,%ebx
  80353f:	89 d8                	mov    %ebx,%eax
  803541:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803545:	d3 e0                	shl    %cl,%eax
  803547:	89 e9                	mov    %ebp,%ecx
  803549:	d3 ea                	shr    %cl,%edx
  80354b:	09 d0                	or     %edx,%eax
  80354d:	89 e9                	mov    %ebp,%ecx
  80354f:	d3 eb                	shr    %cl,%ebx
  803551:	89 da                	mov    %ebx,%edx
  803553:	83 c4 1c             	add    $0x1c,%esp
  803556:	5b                   	pop    %ebx
  803557:	5e                   	pop    %esi
  803558:	5f                   	pop    %edi
  803559:	5d                   	pop    %ebp
  80355a:	c3                   	ret    
  80355b:	90                   	nop
  80355c:	89 fd                	mov    %edi,%ebp
  80355e:	85 ff                	test   %edi,%edi
  803560:	75 0b                	jne    80356d <__umoddi3+0xe9>
  803562:	b8 01 00 00 00       	mov    $0x1,%eax
  803567:	31 d2                	xor    %edx,%edx
  803569:	f7 f7                	div    %edi
  80356b:	89 c5                	mov    %eax,%ebp
  80356d:	89 f0                	mov    %esi,%eax
  80356f:	31 d2                	xor    %edx,%edx
  803571:	f7 f5                	div    %ebp
  803573:	89 c8                	mov    %ecx,%eax
  803575:	f7 f5                	div    %ebp
  803577:	89 d0                	mov    %edx,%eax
  803579:	e9 44 ff ff ff       	jmp    8034c2 <__umoddi3+0x3e>
  80357e:	66 90                	xchg   %ax,%ax
  803580:	89 c8                	mov    %ecx,%eax
  803582:	89 f2                	mov    %esi,%edx
  803584:	83 c4 1c             	add    $0x1c,%esp
  803587:	5b                   	pop    %ebx
  803588:	5e                   	pop    %esi
  803589:	5f                   	pop    %edi
  80358a:	5d                   	pop    %ebp
  80358b:	c3                   	ret    
  80358c:	3b 04 24             	cmp    (%esp),%eax
  80358f:	72 06                	jb     803597 <__umoddi3+0x113>
  803591:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803595:	77 0f                	ja     8035a6 <__umoddi3+0x122>
  803597:	89 f2                	mov    %esi,%edx
  803599:	29 f9                	sub    %edi,%ecx
  80359b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80359f:	89 14 24             	mov    %edx,(%esp)
  8035a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035aa:	8b 14 24             	mov    (%esp),%edx
  8035ad:	83 c4 1c             	add    $0x1c,%esp
  8035b0:	5b                   	pop    %ebx
  8035b1:	5e                   	pop    %esi
  8035b2:	5f                   	pop    %edi
  8035b3:	5d                   	pop    %ebp
  8035b4:	c3                   	ret    
  8035b5:	8d 76 00             	lea    0x0(%esi),%esi
  8035b8:	2b 04 24             	sub    (%esp),%eax
  8035bb:	19 fa                	sbb    %edi,%edx
  8035bd:	89 d1                	mov    %edx,%ecx
  8035bf:	89 c6                	mov    %eax,%esi
  8035c1:	e9 71 ff ff ff       	jmp    803537 <__umoddi3+0xb3>
  8035c6:	66 90                	xchg   %ax,%ax
  8035c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035cc:	72 ea                	jb     8035b8 <__umoddi3+0x134>
  8035ce:	89 d9                	mov    %ebx,%ecx
  8035d0:	e9 62 ff ff ff       	jmp    803537 <__umoddi3+0xb3>
