
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 80 03 00 00       	call   8003b6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 40 80 00       	mov    0x804020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 40 80 00       	mov    0x804020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 60 34 80 00       	push   $0x803460
  800095:	6a 1a                	push   $0x1a
  800097:	68 7c 34 80 00       	push   $0x80347c
  80009c:	e8 51 04 00 00       	call   8004f2 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 27 16 00 00       	call   8016d2 <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ae:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  8000bc:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  8000c0:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  8000c4:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  8000ca:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  8000d0:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d7:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  8000de:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  8000e4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ee:	89 d7                	mov    %edx,%edi
  8000f0:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f5:	01 c0                	add    %eax,%eax
  8000f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 cf 15 00 00       	call   8016d2 <malloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  80010c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800112:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800118:	01 c0                	add    %eax,%eax
  80011a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011d:	48                   	dec    %eax
  80011e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = minByte ;
  800121:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800124:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800127:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800129:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80012c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012f:	01 c2                	add    %eax,%edx
  800131:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800134:	88 02                	mov    %al,(%edx)

		ptr_allocations[1] = malloc(2*Mega-kilo);
  800136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800139:	01 c0                	add    %eax,%eax
  80013b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	50                   	push   %eax
  800142:	e8 8b 15 00 00       	call   8016d2 <malloc>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800150:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800156:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015c:	01 c0                	add    %eax,%eax
  80015e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800161:	d1 e8                	shr    %eax
  800163:	48                   	dec    %eax
  800164:	89 45 c8             	mov    %eax,-0x38(%ebp)
		shortArr[0] = minShort;
  800167:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80016a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016d:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800170:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800173:	01 c0                	add    %eax,%eax
  800175:	89 c2                	mov    %eax,%edx
  800177:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80017a:	01 c2                	add    %eax,%edx
  80017c:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800180:	66 89 02             	mov    %ax,(%edx)

		ptr_allocations[2] = malloc(3*kilo);
  800183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800186:	89 c2                	mov    %eax,%edx
  800188:	01 d2                	add    %edx,%edx
  80018a:	01 d0                	add    %edx,%eax
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	e8 3d 15 00 00       	call   8016d2 <malloc>
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  80019e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8001a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8001a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	c1 e8 02             	shr    $0x2,%eax
  8001af:	48                   	dec    %eax
  8001b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  8001b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001b9:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8001bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001c8:	01 c2                	add    %eax,%edx
  8001ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001cd:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  8001cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001d2:	89 d0                	mov    %edx,%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	01 d0                	add    %edx,%eax
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	50                   	push   %eax
  8001e0:	e8 ed 14 00 00       	call   8016d2 <malloc>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001fa:	89 d0                	mov    %edx,%eax
  8001fc:	01 c0                	add    %eax,%eax
  8001fe:	01 d0                	add    %edx,%eax
  800200:	01 c0                	add    %eax,%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	c1 e8 03             	shr    $0x3,%eax
  800207:	48                   	dec    %eax
  800208:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80020b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020e:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800211:	88 10                	mov    %dl,(%eax)
  800213:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800219:	66 89 42 02          	mov    %ax,0x2(%edx)
  80021d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800220:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800223:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800226:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800229:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800230:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800233:	01 c2                	add    %eax,%edx
  800235:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800238:	88 02                	mov    %al,(%edx)
  80023a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800244:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800247:	01 c2                	add    %eax,%edx
  800249:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80024d:	66 89 42 02          	mov    %ax,0x2(%edx)
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80025b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80025e:	01 c2                	add    %eax,%edx
  800260:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800263:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800266:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800269:	8a 00                	mov    (%eax),%al
  80026b:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80026e:	75 0f                	jne    80027f <_main+0x247>
  800270:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800273:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8a 00                	mov    (%eax),%al
  80027a:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80027d:	74 14                	je     800293 <_main+0x25b>
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	68 90 34 80 00       	push   $0x803490
  800287:	6a 45                	push   $0x45
  800289:	68 7c 34 80 00       	push   $0x80347c
  80028e:	e8 5f 02 00 00       	call   8004f2 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800293:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800296:	66 8b 00             	mov    (%eax),%ax
  800299:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80029d:	75 15                	jne    8002b4 <_main+0x27c>
  80029f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a2:	01 c0                	add    %eax,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	66 8b 00             	mov    (%eax),%ax
  8002ae:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  8002b2:	74 14                	je     8002c8 <_main+0x290>
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	68 90 34 80 00       	push   $0x803490
  8002bc:	6a 46                	push   $0x46
  8002be:	68 7c 34 80 00       	push   $0x80347c
  8002c3:	e8 2a 02 00 00       	call   8004f2 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8002c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d0:	75 16                	jne    8002e8 <_main+0x2b0>
  8002d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002df:	01 d0                	add    %edx,%eax
  8002e1:	8b 00                	mov    (%eax),%eax
  8002e3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 90 34 80 00       	push   $0x803490
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 7c 34 80 00       	push   $0x80347c
  8002f7:	e8 f6 01 00 00       	call   8004f2 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002ff:	8a 00                	mov    (%eax),%al
  800301:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800304:	75 16                	jne    80031c <_main+0x2e4>
  800306:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800309:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800310:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	8a 00                	mov    (%eax),%al
  800317:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80031a:	74 14                	je     800330 <_main+0x2f8>
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	68 90 34 80 00       	push   $0x803490
  800324:	6a 49                	push   $0x49
  800326:	68 7c 34 80 00       	push   $0x80347c
  80032b:	e8 c2 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800330:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800333:	66 8b 40 02          	mov    0x2(%eax),%ax
  800337:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80033b:	75 19                	jne    800356 <_main+0x31e>
  80033d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800340:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800347:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034a:	01 d0                	add    %edx,%eax
  80034c:	66 8b 40 02          	mov    0x2(%eax),%ax
  800350:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800354:	74 14                	je     80036a <_main+0x332>
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	68 90 34 80 00       	push   $0x803490
  80035e:	6a 4a                	push   $0x4a
  800360:	68 7c 34 80 00       	push   $0x80347c
  800365:	e8 88 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  80036a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80036d:	8b 40 04             	mov    0x4(%eax),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	75 17                	jne    80038c <_main+0x354>
  800375:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800378:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80037f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	8b 40 04             	mov    0x4(%eax),%eax
  800387:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80038a:	74 14                	je     8003a0 <_main+0x368>
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	68 90 34 80 00       	push   $0x803490
  800394:	6a 4b                	push   $0x4b
  800396:	68 7c 34 80 00       	push   $0x80347c
  80039b:	e8 52 01 00 00       	call   8004f2 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 c8 34 80 00       	push   $0x8034c8
  8003a8:	e8 f9 03 00 00       	call   8007a6 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp

	return;
  8003b0:	90                   	nop
}
  8003b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003b4:	c9                   	leave  
  8003b5:	c3                   	ret    

008003b6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003bc:	e8 1f 1a 00 00       	call   801de0 <sys_getenvindex>
  8003c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	c1 e0 03             	shl    $0x3,%eax
  8003cc:	01 d0                	add    %edx,%eax
  8003ce:	01 c0                	add    %eax,%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	c1 e0 04             	shl    $0x4,%eax
  8003de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e3:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ed:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003f3:	84 c0                	test   %al,%al
  8003f5:	74 0f                	je     800406 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fc:	05 5c 05 00 00       	add    $0x55c,%eax
  800401:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80040a:	7e 0a                	jle    800416 <libmain+0x60>
		binaryname = argv[0];
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	ff 75 0c             	pushl  0xc(%ebp)
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 14 fc ff ff       	call   800038 <_main>
  800424:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800427:	e8 c1 17 00 00       	call   801bed <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 1c 35 80 00       	push   $0x80351c
  800434:	e8 6d 03 00 00       	call   8007a6 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80043c:	a1 20 40 80 00       	mov    0x804020,%eax
  800441:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800447:	a1 20 40 80 00       	mov    0x804020,%eax
  80044c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	68 44 35 80 00       	push   $0x803544
  80045c:	e8 45 03 00 00       	call   8007a6 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800464:	a1 20 40 80 00       	mov    0x804020,%eax
  800469:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80046f:	a1 20 40 80 00       	mov    0x804020,%eax
  800474:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80047a:	a1 20 40 80 00       	mov    0x804020,%eax
  80047f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800485:	51                   	push   %ecx
  800486:	52                   	push   %edx
  800487:	50                   	push   %eax
  800488:	68 6c 35 80 00       	push   $0x80356c
  80048d:	e8 14 03 00 00       	call   8007a6 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800495:	a1 20 40 80 00       	mov    0x804020,%eax
  80049a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 c4 35 80 00       	push   $0x8035c4
  8004a9:	e8 f8 02 00 00       	call   8007a6 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	68 1c 35 80 00       	push   $0x80351c
  8004b9:	e8 e8 02 00 00       	call   8007a6 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c1:	e8 41 17 00 00       	call   801c07 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004c6:	e8 19 00 00 00       	call   8004e4 <exit>
}
  8004cb:	90                   	nop
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	6a 00                	push   $0x0
  8004d9:	e8 ce 18 00 00       	call   801dac <sys_destroy_env>
  8004de:	83 c4 10             	add    $0x10,%esp
}
  8004e1:	90                   	nop
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    

008004e4 <exit>:

void
exit(void)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ea:	e8 23 19 00 00       	call   801e12 <sys_exit_env>
}
  8004ef:	90                   	nop
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8004fb:	83 c0 04             	add    $0x4,%eax
  8004fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800501:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800506:	85 c0                	test   %eax,%eax
  800508:	74 16                	je     800520 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80050a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	50                   	push   %eax
  800513:	68 d8 35 80 00       	push   $0x8035d8
  800518:	e8 89 02 00 00       	call   8007a6 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 00 40 80 00       	mov    0x804000,%eax
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	50                   	push   %eax
  80052c:	68 dd 35 80 00       	push   $0x8035dd
  800531:	e8 70 02 00 00       	call   8007a6 <cprintf>
  800536:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800539:	8b 45 10             	mov    0x10(%ebp),%eax
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 f4             	pushl  -0xc(%ebp)
  800542:	50                   	push   %eax
  800543:	e8 f3 01 00 00       	call   80073b <vcprintf>
  800548:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	6a 00                	push   $0x0
  800550:	68 f9 35 80 00       	push   $0x8035f9
  800555:	e8 e1 01 00 00       	call   80073b <vcprintf>
  80055a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80055d:	e8 82 ff ff ff       	call   8004e4 <exit>

	// should not return here
	while (1) ;
  800562:	eb fe                	jmp    800562 <_panic+0x70>

00800564 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80056a:	a1 20 40 80 00       	mov    0x804020,%eax
  80056f:	8b 50 74             	mov    0x74(%eax),%edx
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	74 14                	je     80058d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	68 fc 35 80 00       	push   $0x8035fc
  800581:	6a 26                	push   $0x26
  800583:	68 48 36 80 00       	push   $0x803648
  800588:	e8 65 ff ff ff       	call   8004f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80058d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800594:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059b:	e9 c2 00 00 00       	jmp    800662 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	85 c0                	test   %eax,%eax
  8005b3:	75 08                	jne    8005bd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005b5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005b8:	e9 a2 00 00 00       	jmp    80065f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005cb:	eb 69                	jmp    800636 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005db:	89 d0                	mov    %edx,%eax
  8005dd:	01 c0                	add    %eax,%eax
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	c1 e0 03             	shl    $0x3,%eax
  8005e4:	01 c8                	add    %ecx,%eax
  8005e6:	8a 40 04             	mov    0x4(%eax),%al
  8005e9:	84 c0                	test   %al,%al
  8005eb:	75 46                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	01 c0                	add    %eax,%eax
  8005ff:	01 d0                	add    %edx,%eax
  800601:	c1 e0 03             	shl    $0x3,%eax
  800604:	01 c8                	add    %ecx,%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80060b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800613:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800618:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	01 c8                	add    %ecx,%eax
  800624:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800626:	39 c2                	cmp    %eax,%edx
  800628:	75 09                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80062a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800631:	eb 12                	jmp    800645 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800633:	ff 45 e8             	incl   -0x18(%ebp)
  800636:	a1 20 40 80 00       	mov    0x804020,%eax
  80063b:	8b 50 74             	mov    0x74(%eax),%edx
  80063e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800641:	39 c2                	cmp    %eax,%edx
  800643:	77 88                	ja     8005cd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800649:	75 14                	jne    80065f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80064b:	83 ec 04             	sub    $0x4,%esp
  80064e:	68 54 36 80 00       	push   $0x803654
  800653:	6a 3a                	push   $0x3a
  800655:	68 48 36 80 00       	push   $0x803648
  80065a:	e8 93 fe ff ff       	call   8004f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80065f:	ff 45 f0             	incl   -0x10(%ebp)
  800662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800665:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800668:	0f 8c 32 ff ff ff    	jl     8005a0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80066e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800675:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80067c:	eb 26                	jmp    8006a4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80067e:	a1 20 40 80 00       	mov    0x804020,%eax
  800683:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800689:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068c:	89 d0                	mov    %edx,%eax
  80068e:	01 c0                	add    %eax,%eax
  800690:	01 d0                	add    %edx,%eax
  800692:	c1 e0 03             	shl    $0x3,%eax
  800695:	01 c8                	add    %ecx,%eax
  800697:	8a 40 04             	mov    0x4(%eax),%al
  80069a:	3c 01                	cmp    $0x1,%al
  80069c:	75 03                	jne    8006a1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80069e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a1:	ff 45 e0             	incl   -0x20(%ebp)
  8006a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8006a9:	8b 50 74             	mov    0x74(%eax),%edx
  8006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006af:	39 c2                	cmp    %eax,%edx
  8006b1:	77 cb                	ja     80067e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b9:	74 14                	je     8006cf <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006bb:	83 ec 04             	sub    $0x4,%esp
  8006be:	68 a8 36 80 00       	push   $0x8036a8
  8006c3:	6a 44                	push   $0x44
  8006c5:	68 48 36 80 00       	push   $0x803648
  8006ca:	e8 23 fe ff ff       	call   8004f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8006e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e3:	89 0a                	mov    %ecx,(%edx)
  8006e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8006e8:	88 d1                	mov    %dl,%cl
  8006ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006fb:	75 2c                	jne    800729 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006fd:	a0 24 40 80 00       	mov    0x804024,%al
  800702:	0f b6 c0             	movzbl %al,%eax
  800705:	8b 55 0c             	mov    0xc(%ebp),%edx
  800708:	8b 12                	mov    (%edx),%edx
  80070a:	89 d1                	mov    %edx,%ecx
  80070c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070f:	83 c2 08             	add    $0x8,%edx
  800712:	83 ec 04             	sub    $0x4,%esp
  800715:	50                   	push   %eax
  800716:	51                   	push   %ecx
  800717:	52                   	push   %edx
  800718:	e8 22 13 00 00       	call   801a3f <sys_cputs>
  80071d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	8b 40 04             	mov    0x4(%eax),%eax
  80072f:	8d 50 01             	lea    0x1(%eax),%edx
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	89 50 04             	mov    %edx,0x4(%eax)
}
  800738:	90                   	nop
  800739:	c9                   	leave  
  80073a:	c3                   	ret    

0080073b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800744:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80074b:	00 00 00 
	b.cnt = 0;
  80074e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800755:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	ff 75 08             	pushl  0x8(%ebp)
  80075e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	68 d2 06 80 00       	push   $0x8006d2
  80076a:	e8 11 02 00 00       	call   800980 <vprintfmt>
  80076f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800772:	a0 24 40 80 00       	mov    0x804024,%al
  800777:	0f b6 c0             	movzbl %al,%eax
  80077a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800780:	83 ec 04             	sub    $0x4,%esp
  800783:	50                   	push   %eax
  800784:	52                   	push   %edx
  800785:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80078b:	83 c0 08             	add    $0x8,%eax
  80078e:	50                   	push   %eax
  80078f:	e8 ab 12 00 00       	call   801a3f <sys_cputs>
  800794:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800797:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80079e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007ac:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8007b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 73 ff ff ff       	call   80073b <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007d9:	e8 0f 14 00 00       	call   801bed <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	e8 48 ff ff ff       	call   80073b <vcprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007f9:	e8 09 14 00 00       	call   801c07 <sys_enable_interrupt>
	return cnt;
  8007fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	83 ec 14             	sub    $0x14,%esp
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800816:	8b 45 18             	mov    0x18(%ebp),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800821:	77 55                	ja     800878 <printnum+0x75>
  800823:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800826:	72 05                	jb     80082d <printnum+0x2a>
  800828:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082b:	77 4b                	ja     800878 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800830:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800833:	8b 45 18             	mov    0x18(%ebp),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	ff 75 f0             	pushl  -0x10(%ebp)
  800843:	e8 b4 29 00 00       	call   8031fc <__udivdi3>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	ff 75 20             	pushl  0x20(%ebp)
  800851:	53                   	push   %ebx
  800852:	ff 75 18             	pushl  0x18(%ebp)
  800855:	52                   	push   %edx
  800856:	50                   	push   %eax
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	e8 a1 ff ff ff       	call   800803 <printnum>
  800862:	83 c4 20             	add    $0x20,%esp
  800865:	eb 1a                	jmp    800881 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 20             	pushl  0x20(%ebp)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800878:	ff 4d 1c             	decl   0x1c(%ebp)
  80087b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087f:	7f e6                	jg     800867 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800881:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800884:	bb 00 00 00 00       	mov    $0x0,%ebx
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088f:	53                   	push   %ebx
  800890:	51                   	push   %ecx
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	e8 74 2a 00 00       	call   80330c <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 14 39 80 00       	add    $0x803914,%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be c0             	movsbl %al,%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	90                   	nop
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 40                	jmp    80091f <getuint+0x65>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1e                	je     800903 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	eb 1c                	jmp    80091f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 50 04             	lea    0x4(%eax),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 10                	mov    %edx,(%eax)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800924:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800928:	7e 1c                	jle    800946 <getint+0x25>
		return va_arg(*ap, long long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 08             	lea    0x8(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 08             	sub    $0x8,%eax
  80093f:	8b 50 04             	mov    0x4(%eax),%edx
  800942:	8b 00                	mov    (%eax),%eax
  800944:	eb 38                	jmp    80097e <getint+0x5d>
	else if (lflag)
  800946:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094a:	74 1a                	je     800966 <getint+0x45>
		return va_arg(*ap, long);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
  800964:	eb 18                	jmp    80097e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	99                   	cltd   
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800988:	eb 17                	jmp    8009a1 <vprintfmt+0x21>
			if (ch == '\0')
  80098a:	85 db                	test   %ebx,%ebx
  80098c:	0f 84 af 03 00 00    	je     800d41 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	53                   	push   %ebx
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	8d 50 01             	lea    0x1(%eax),%edx
  8009a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	83 fb 25             	cmp    $0x25,%ebx
  8009b2:	75 d6                	jne    80098a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e5:	83 f8 55             	cmp    $0x55,%eax
  8009e8:	0f 87 2b 03 00 00    	ja     800d19 <vprintfmt+0x399>
  8009ee:	8b 04 85 38 39 80 00 	mov    0x803938(,%eax,4),%eax
  8009f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fb:	eb d7                	jmp    8009d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a01:	eb d1                	jmp    8009d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	c1 e0 02             	shl    $0x2,%eax
  800a12:	01 d0                	add    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d8                	add    %ebx,%eax
  800a18:	83 e8 30             	sub    $0x30,%eax
  800a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a26:	83 fb 2f             	cmp    $0x2f,%ebx
  800a29:	7e 3e                	jle    800a69 <vprintfmt+0xe9>
  800a2b:	83 fb 39             	cmp    $0x39,%ebx
  800a2e:	7f 39                	jg     800a69 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a30:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a33:	eb d5                	jmp    800a0a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4f:	79 83                	jns    8009d4 <vprintfmt+0x54>
				width = 0;
  800a51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a58:	e9 77 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a64:	e9 6b ff ff ff       	jmp    8009d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a69:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	0f 89 60 ff ff ff    	jns    8009d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a81:	e9 4e ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a86:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a89:	e9 46 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 89 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	79 02                	jns    800aca <vprintfmt+0x14a>
				err = -err;
  800ac8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aca:	83 fb 64             	cmp    $0x64,%ebx
  800acd:	7f 0b                	jg     800ada <vprintfmt+0x15a>
  800acf:	8b 34 9d 80 37 80 00 	mov    0x803780(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 25 39 80 00       	push   $0x803925
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 5e 02 00 00       	call   800d49 <printfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aee:	e9 49 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af3:	56                   	push   %esi
  800af4:	68 2e 39 80 00       	push   $0x80392e
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	ff 75 08             	pushl  0x8(%ebp)
  800aff:	e8 45 02 00 00       	call   800d49 <printfmt>
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 30 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 30                	mov    (%eax),%esi
  800b1d:	85 f6                	test   %esi,%esi
  800b1f:	75 05                	jne    800b26 <vprintfmt+0x1a6>
				p = "(null)";
  800b21:	be 31 39 80 00       	mov    $0x803931,%esi
			if (width > 0 && padc != '-')
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7e 6d                	jle    800b99 <vprintfmt+0x219>
  800b2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b30:	74 67                	je     800b99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	50                   	push   %eax
  800b39:	56                   	push   %esi
  800b3a:	e8 0c 03 00 00       	call   800e4b <strnlen>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	50                   	push   %eax
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7f e4                	jg     800b47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	eb 34                	jmp    800b99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	74 1c                	je     800b87 <vprintfmt+0x207>
  800b6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6e:	7e 05                	jle    800b75 <vprintfmt+0x1f5>
  800b70:	83 fb 7e             	cmp    $0x7e,%ebx
  800b73:	7e 12                	jle    800b87 <vprintfmt+0x207>
					putch('?', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 3f                	push   $0x3f
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	eb 0f                	jmp    800b96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	89 f0                	mov    %esi,%eax
  800b9b:	8d 70 01             	lea    0x1(%eax),%esi
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f be d8             	movsbl %al,%ebx
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	74 24                	je     800bcb <vprintfmt+0x24b>
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	78 b8                	js     800b65 <vprintfmt+0x1e5>
  800bad:	ff 4d e0             	decl   -0x20(%ebp)
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	79 af                	jns    800b65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 13                	jmp    800bcb <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 20                	push   $0x20
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcf:	7f e7                	jg     800bb8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd1:	e9 66 01 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	e8 3c fd ff ff       	call   800921 <getint>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	85 d2                	test   %edx,%edx
  800bf6:	79 23                	jns    800c1b <vprintfmt+0x29b>
				putch('-', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 2d                	push   $0x2d
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	f7 d8                	neg    %eax
  800c10:	83 d2 00             	adc    $0x0,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c30:	50                   	push   %eax
  800c31:	e8 84 fc ff ff       	call   8008ba <getuint>
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c46:	e9 98 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 58                	push   $0x58
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 58                	push   $0x58
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 58                	push   $0x58
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			break;
  800c7b:	e9 bc 00 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 30                	push   $0x30
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 78                	push   $0x78
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc2:	eb 1f                	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cca:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	e8 e7 fb ff ff       	call   8008ba <getuint>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	52                   	push   %edx
  800cee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 00 fb ff ff       	call   800803 <printnum>
  800d03:	83 c4 20             	add    $0x20,%esp
			break;
  800d06:	eb 34                	jmp    800d3c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	53                   	push   %ebx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	ff d0                	call   *%eax
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 25                	push   $0x25
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d29:	ff 4d 10             	decl   0x10(%ebp)
  800d2c:	eb 03                	jmp    800d31 <vprintfmt+0x3b1>
  800d2e:	ff 4d 10             	decl   0x10(%ebp)
  800d31:	8b 45 10             	mov    0x10(%ebp),%eax
  800d34:	48                   	dec    %eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	3c 25                	cmp    $0x25,%al
  800d39:	75 f3                	jne    800d2e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d3b:	90                   	nop
		}
	}
  800d3c:	e9 47 fc ff ff       	jmp    800988 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	ff 75 08             	pushl  0x8(%ebp)
  800d65:	e8 16 fc ff ff       	call   800980 <vprintfmt>
  800d6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6d:	90                   	nop
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8b 40 08             	mov    0x8(%eax),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8b 10                	mov    (%eax),%edx
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 40 04             	mov    0x4(%eax),%eax
  800d8d:	39 c2                	cmp    %eax,%edx
  800d8f:	73 12                	jae    800da3 <sprintputch+0x33>
		*b->buf++ = ch;
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	8d 48 01             	lea    0x1(%eax),%ecx
  800d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9c:	89 0a                	mov    %ecx,(%edx)
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	88 10                	mov    %dl,(%eax)
}
  800da3:	90                   	nop
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	01 d0                	add    %edx,%eax
  800dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcb:	74 06                	je     800dd3 <vsnprintf+0x2d>
  800dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd1:	7f 07                	jg     800dda <vsnprintf+0x34>
		return -E_INVAL;
  800dd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd8:	eb 20                	jmp    800dfa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dda:	ff 75 14             	pushl  0x14(%ebp)
  800ddd:	ff 75 10             	pushl  0x10(%ebp)
  800de0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de3:	50                   	push   %eax
  800de4:	68 70 0d 80 00       	push   $0x800d70
  800de9:	e8 92 fb ff ff       	call   800980 <vprintfmt>
  800dee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e02:	8d 45 10             	lea    0x10(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e11:	50                   	push   %eax
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	ff 75 08             	pushl  0x8(%ebp)
  800e18:	e8 89 ff ff ff       	call   800da6 <vsnprintf>
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e35:	eb 06                	jmp    800e3d <strlen+0x15>
		n++;
  800e37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3a:	ff 45 08             	incl   0x8(%ebp)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	75 f1                	jne    800e37 <strlen+0xf>
		n++;
	return n;
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 09                	jmp    800e63 <strnlen+0x18>
		n++;
  800e5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	ff 4d 0c             	decl   0xc(%ebp)
  800e63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e67:	74 09                	je     800e72 <strnlen+0x27>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e8                	jne    800e5a <strnlen+0xf>
		n++;
	return n;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e83:	90                   	nop
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e96:	8a 12                	mov    (%edx),%dl
  800e98:	88 10                	mov    %dl,(%eax)
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	84 c0                	test   %al,%al
  800e9e:	75 e4                	jne    800e84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb8:	eb 1f                	jmp    800ed9 <strncpy+0x34>
		*dst++ = *src;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8d 50 01             	lea    0x1(%eax),%edx
  800ec0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	74 03                	je     800ed6 <strncpy+0x31>
			src++;
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed6:	ff 45 fc             	incl   -0x4(%ebp)
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edf:	72 d9                	jb     800eba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 30                	je     800f28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef8:	eb 16                	jmp    800f10 <strlcpy+0x2a>
			*dst++ = *src++;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 08             	mov    %edx,0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0c:	8a 12                	mov    (%edx),%dl
  800f0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f10:	ff 4d 10             	decl   0x10(%ebp)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 09                	je     800f22 <strlcpy+0x3c>
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 d8                	jne    800efa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2e:	29 c2                	sub    %eax,%edx
  800f30:	89 d0                	mov    %edx,%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f37:	eb 06                	jmp    800f3f <strcmp+0xb>
		p++, q++;
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	74 0e                	je     800f56 <strcmp+0x22>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 10                	mov    (%eax),%dl
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	38 c2                	cmp    %al,%dl
  800f54:	74 e3                	je     800f39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 d0             	movzbl %al,%edx
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	29 c2                	sub    %eax,%edx
  800f68:	89 d0                	mov    %edx,%eax
}
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f6f:	eb 09                	jmp    800f7a <strncmp+0xe>
		n--, p++, q++;
  800f71:	ff 4d 10             	decl   0x10(%ebp)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 17                	je     800f97 <strncmp+0x2b>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	84 c0                	test   %al,%al
  800f87:	74 0e                	je     800f97 <strncmp+0x2b>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 10                	mov    (%eax),%dl
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	38 c2                	cmp    %al,%dl
  800f95:	74 da                	je     800f71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 07                	jne    800fa4 <strncmp+0x38>
		return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	eb 14                	jmp    800fb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
}
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc6:	eb 12                	jmp    800fda <strchr+0x20>
		if (*s == c)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd0:	75 05                	jne    800fd7 <strchr+0x1d>
			return (char *) s;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	eb 11                	jmp    800fe8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd7:	ff 45 08             	incl   0x8(%ebp)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 e5                	jne    800fc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff6:	eb 0d                	jmp    801005 <strfind+0x1b>
		if (*s == c)
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801000:	74 0e                	je     801010 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801002:	ff 45 08             	incl   0x8(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ea                	jne    800ff8 <strfind+0xe>
  80100e:	eb 01                	jmp    801011 <strfind+0x27>
		if (*s == c)
			break;
  801010:	90                   	nop
	return (char *) s;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801028:	eb 0e                	jmp    801038 <memset+0x22>
		*p++ = c;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8d 50 01             	lea    0x1(%eax),%edx
  801030:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801033:	8b 55 0c             	mov    0xc(%ebp),%edx
  801036:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801038:	ff 4d f8             	decl   -0x8(%ebp)
  80103b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80103f:	79 e9                	jns    80102a <memset+0x14>
		*p++ = c;

	return v;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801058:	eb 16                	jmp    801070 <memcpy+0x2a>
		*d++ = *s++;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8d 50 01             	lea    0x1(%eax),%edx
  801060:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801063:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801066:	8d 4a 01             	lea    0x1(%edx),%ecx
  801069:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80106c:	8a 12                	mov    (%edx),%dl
  80106e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	8d 50 ff             	lea    -0x1(%eax),%edx
  801076:	89 55 10             	mov    %edx,0x10(%ebp)
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 dd                	jne    80105a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80109a:	73 50                	jae    8010ec <memmove+0x6a>
  80109c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a7:	76 43                	jbe    8010ec <memmove+0x6a>
		s += n;
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b5:	eb 10                	jmp    8010c7 <memmove+0x45>
			*--d = *--s;
  8010b7:	ff 4d f8             	decl   -0x8(%ebp)
  8010ba:	ff 4d fc             	decl   -0x4(%ebp)
  8010bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c0:	8a 10                	mov    (%eax),%dl
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	75 e3                	jne    8010b7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010d4:	eb 23                	jmp    8010f9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	8d 50 01             	lea    0x1(%eax),%edx
  8010dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e8:	8a 12                	mov    (%edx),%dl
  8010ea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	75 dd                	jne    8010d6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801110:	eb 2a                	jmp    80113c <memcmp+0x3e>
		if (*s1 != *s2)
  801112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801115:	8a 10                	mov    (%eax),%dl
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	38 c2                	cmp    %al,%dl
  80111e:	74 16                	je     801136 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	0f b6 d0             	movzbl %al,%edx
  801128:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	0f b6 c0             	movzbl %al,%eax
  801130:	29 c2                	sub    %eax,%edx
  801132:	89 d0                	mov    %edx,%eax
  801134:	eb 18                	jmp    80114e <memcmp+0x50>
		s1++, s2++;
  801136:	ff 45 fc             	incl   -0x4(%ebp)
  801139:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801142:	89 55 10             	mov    %edx,0x10(%ebp)
  801145:	85 c0                	test   %eax,%eax
  801147:	75 c9                	jne    801112 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801149:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801161:	eb 15                	jmp    801178 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f b6 d0             	movzbl %al,%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	0f b6 c0             	movzbl %al,%eax
  801171:	39 c2                	cmp    %eax,%edx
  801173:	74 0d                	je     801182 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801175:	ff 45 08             	incl   0x8(%ebp)
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80117e:	72 e3                	jb     801163 <memfind+0x13>
  801180:	eb 01                	jmp    801183 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801182:	90                   	nop
	return (void *) s;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80118e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80119c:	eb 03                	jmp    8011a1 <strtol+0x19>
		s++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 20                	cmp    $0x20,%al
  8011a8:	74 f4                	je     80119e <strtol+0x16>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 09                	cmp    $0x9,%al
  8011b1:	74 eb                	je     80119e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 2b                	cmp    $0x2b,%al
  8011ba:	75 05                	jne    8011c1 <strtol+0x39>
		s++;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	eb 13                	jmp    8011d4 <strtol+0x4c>
	else if (*s == '-')
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 2d                	cmp    $0x2d,%al
  8011c8:	75 0a                	jne    8011d4 <strtol+0x4c>
		s++, neg = 1;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d8:	74 06                	je     8011e0 <strtol+0x58>
  8011da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011de:	75 20                	jne    801200 <strtol+0x78>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 30                	cmp    $0x30,%al
  8011e7:	75 17                	jne    801200 <strtol+0x78>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	40                   	inc    %eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 78                	cmp    $0x78,%al
  8011f1:	75 0d                	jne    801200 <strtol+0x78>
		s += 2, base = 16;
  8011f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011fe:	eb 28                	jmp    801228 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801204:	75 15                	jne    80121b <strtol+0x93>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 30                	cmp    $0x30,%al
  80120d:	75 0c                	jne    80121b <strtol+0x93>
		s++, base = 8;
  80120f:	ff 45 08             	incl   0x8(%ebp)
  801212:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801219:	eb 0d                	jmp    801228 <strtol+0xa0>
	else if (base == 0)
  80121b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121f:	75 07                	jne    801228 <strtol+0xa0>
		base = 10;
  801221:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 2f                	cmp    $0x2f,%al
  80122f:	7e 19                	jle    80124a <strtol+0xc2>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 39                	cmp    $0x39,%al
  801238:	7f 10                	jg     80124a <strtol+0xc2>
			dig = *s - '0';
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	0f be c0             	movsbl %al,%eax
  801242:	83 e8 30             	sub    $0x30,%eax
  801245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801248:	eb 42                	jmp    80128c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 60                	cmp    $0x60,%al
  801251:	7e 19                	jle    80126c <strtol+0xe4>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	3c 7a                	cmp    $0x7a,%al
  80125a:	7f 10                	jg     80126c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	0f be c0             	movsbl %al,%eax
  801264:	83 e8 57             	sub    $0x57,%eax
  801267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126a:	eb 20                	jmp    80128c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 40                	cmp    $0x40,%al
  801273:	7e 39                	jle    8012ae <strtol+0x126>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 5a                	cmp    $0x5a,%al
  80127c:	7f 30                	jg     8012ae <strtol+0x126>
			dig = *s - 'A' + 10;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	0f be c0             	movsbl %al,%eax
  801286:	83 e8 37             	sub    $0x37,%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801292:	7d 19                	jge    8012ad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801294:	ff 45 08             	incl   0x8(%ebp)
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80129e:	89 c2                	mov    %eax,%edx
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012a8:	e9 7b ff ff ff       	jmp    801228 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b2:	74 08                	je     8012bc <strtol+0x134>
		*endptr = (char *) s;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c0:	74 07                	je     8012c9 <strtol+0x141>
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	f7 d8                	neg    %eax
  8012c7:	eb 03                	jmp    8012cc <strtol+0x144>
  8012c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <ltostr>:

void
ltostr(long value, char *str)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e6:	79 13                	jns    8012fb <ltostr+0x2d>
	{
		neg = 1;
  8012e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012f5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012f8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801303:	99                   	cltd   
  801304:	f7 f9                	idiv   %ecx
  801306:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	8d 50 01             	lea    0x1(%eax),%edx
  80130f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	01 d0                	add    %edx,%eax
  801319:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80131c:	83 c2 30             	add    $0x30,%edx
  80131f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801321:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801324:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801329:	f7 e9                	imul   %ecx
  80132b:	c1 fa 02             	sar    $0x2,%edx
  80132e:	89 c8                	mov    %ecx,%eax
  801330:	c1 f8 1f             	sar    $0x1f,%eax
  801333:	29 c2                	sub    %eax,%edx
  801335:	89 d0                	mov    %edx,%eax
  801337:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80133a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801342:	f7 e9                	imul   %ecx
  801344:	c1 fa 02             	sar    $0x2,%edx
  801347:	89 c8                	mov    %ecx,%eax
  801349:	c1 f8 1f             	sar    $0x1f,%eax
  80134c:	29 c2                	sub    %eax,%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	c1 e0 02             	shl    $0x2,%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	01 c0                	add    %eax,%eax
  801357:	29 c1                	sub    %eax,%ecx
  801359:	89 ca                	mov    %ecx,%edx
  80135b:	85 d2                	test   %edx,%edx
  80135d:	75 9c                	jne    8012fb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80136d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801371:	74 3d                	je     8013b0 <ltostr+0xe2>
		start = 1 ;
  801373:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80137a:	eb 34                	jmp    8013b0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c2                	add    %eax,%edx
  801391:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	01 c8                	add    %ecx,%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80139d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b6:	7c c4                	jl     80137c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c3:	90                   	nop
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 54 fa ff ff       	call   800e28 <strlen>
  8013d4:	83 c4 04             	add    $0x4,%esp
  8013d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 46 fa ff ff       	call   800e28 <strlen>
  8013e2:	83 c4 04             	add    $0x4,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f6:	eb 17                	jmp    80140f <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80140c:	ff 45 fc             	incl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801415:	7c e1                	jl     8013f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801417:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801425:	eb 1f                	jmp    801446 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	8d 50 01             	lea    0x1(%eax),%edx
  80142d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801430:	89 c2                	mov    %eax,%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801443:	ff 45 f8             	incl   -0x8(%ebp)
  801446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c d9                	jl     801427 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147f:	eb 0c                	jmp    80148d <strsplit+0x31>
			*string++ = 0;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	89 55 08             	mov    %edx,0x8(%ebp)
  80148a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 18                	je     8014ae <strsplit+0x52>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	0f be c0             	movsbl %al,%eax
  80149e:	50                   	push   %eax
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	e8 13 fb ff ff       	call   800fba <strchr>
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	75 d3                	jne    801481 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 5a                	je     801511 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	83 f8 0f             	cmp    $0xf,%eax
  8014bf:	75 07                	jne    8014c8 <strsplit+0x6c>
		{
			return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	eb 66                	jmp    80152e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d3:	89 0a                	mov    %ecx,(%edx)
  8014d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 c2                	add    %eax,%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e6:	eb 03                	jmp    8014eb <strsplit+0x8f>
			string++;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	74 8b                	je     80147f <strsplit+0x23>
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	e8 b5 fa ff ff       	call   800fba <strchr>
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 dc                	je     8014e8 <strsplit+0x8c>
			string++;
	}
  80150c:	e9 6e ff ff ff       	jmp    80147f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801511:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801529:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801536:	a1 04 40 80 00       	mov    0x804004,%eax
  80153b:	85 c0                	test   %eax,%eax
  80153d:	74 1f                	je     80155e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80153f:	e8 1d 00 00 00       	call   801561 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	68 90 3a 80 00       	push   $0x803a90
  80154c:	e8 55 f2 ff ff       	call   8007a6 <cprintf>
  801551:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801554:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80155b:	00 00 00 
	}
}
  80155e:	90                   	nop
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801567:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80156e:	00 00 00 
  801571:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801578:	00 00 00 
  80157b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801582:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801585:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80158c:	00 00 00 
  80158f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801596:	00 00 00 
  801599:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8015a0:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8015a3:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8015aa:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8015ad:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8015b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015bc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c1:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8015c6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015cd:	a1 20 41 80 00       	mov    0x804120,%eax
  8015d2:	c1 e0 04             	shl    $0x4,%eax
  8015d5:	89 c2                	mov    %eax,%edx
  8015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015da:	01 d0                	add    %edx,%eax
  8015dc:	48                   	dec    %eax
  8015dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e8:	f7 75 f0             	divl   -0x10(%ebp)
  8015eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ee:	29 d0                	sub    %edx,%eax
  8015f0:	89 c2                	mov    %eax,%edx
  8015f2:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8015f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801601:	2d 00 10 00 00       	sub    $0x1000,%eax
  801606:	83 ec 04             	sub    $0x4,%esp
  801609:	6a 06                	push   $0x6
  80160b:	52                   	push   %edx
  80160c:	50                   	push   %eax
  80160d:	e8 71 05 00 00       	call   801b83 <sys_allocate_chunk>
  801612:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801615:	a1 20 41 80 00       	mov    0x804120,%eax
  80161a:	83 ec 0c             	sub    $0xc,%esp
  80161d:	50                   	push   %eax
  80161e:	e8 e6 0b 00 00       	call   802209 <initialize_MemBlocksList>
  801623:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801626:	a1 48 41 80 00       	mov    0x804148,%eax
  80162b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  80162e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801632:	75 14                	jne    801648 <initialize_dyn_block_system+0xe7>
  801634:	83 ec 04             	sub    $0x4,%esp
  801637:	68 b5 3a 80 00       	push   $0x803ab5
  80163c:	6a 2b                	push   $0x2b
  80163e:	68 d3 3a 80 00       	push   $0x803ad3
  801643:	e8 aa ee ff ff       	call   8004f2 <_panic>
  801648:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80164b:	8b 00                	mov    (%eax),%eax
  80164d:	85 c0                	test   %eax,%eax
  80164f:	74 10                	je     801661 <initialize_dyn_block_system+0x100>
  801651:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801654:	8b 00                	mov    (%eax),%eax
  801656:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801659:	8b 52 04             	mov    0x4(%edx),%edx
  80165c:	89 50 04             	mov    %edx,0x4(%eax)
  80165f:	eb 0b                	jmp    80166c <initialize_dyn_block_system+0x10b>
  801661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801664:	8b 40 04             	mov    0x4(%eax),%eax
  801667:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80166c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80166f:	8b 40 04             	mov    0x4(%eax),%eax
  801672:	85 c0                	test   %eax,%eax
  801674:	74 0f                	je     801685 <initialize_dyn_block_system+0x124>
  801676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801679:	8b 40 04             	mov    0x4(%eax),%eax
  80167c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80167f:	8b 12                	mov    (%edx),%edx
  801681:	89 10                	mov    %edx,(%eax)
  801683:	eb 0a                	jmp    80168f <initialize_dyn_block_system+0x12e>
  801685:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801688:	8b 00                	mov    (%eax),%eax
  80168a:	a3 48 41 80 00       	mov    %eax,0x804148
  80168f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801692:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80169b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016a2:	a1 54 41 80 00       	mov    0x804154,%eax
  8016a7:	48                   	dec    %eax
  8016a8:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  8016ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016b0:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  8016b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ba:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  8016c1:	83 ec 0c             	sub    $0xc,%esp
  8016c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016c7:	e8 d2 13 00 00       	call   802a9e <insert_sorted_with_merge_freeList>
  8016cc:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8016cf:	90                   	nop
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016d8:	e8 53 fe ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e1:	75 07                	jne    8016ea <malloc+0x18>
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e8:	eb 61                	jmp    80174b <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8016ea:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f7:	01 d0                	add    %edx,%eax
  8016f9:	48                   	dec    %eax
  8016fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801700:	ba 00 00 00 00       	mov    $0x0,%edx
  801705:	f7 75 f4             	divl   -0xc(%ebp)
  801708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170b:	29 d0                	sub    %edx,%eax
  80170d:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801710:	e8 3c 08 00 00       	call   801f51 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801715:	85 c0                	test   %eax,%eax
  801717:	74 2d                	je     801746 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801719:	83 ec 0c             	sub    $0xc,%esp
  80171c:	ff 75 08             	pushl  0x8(%ebp)
  80171f:	e8 3e 0f 00 00       	call   802662 <alloc_block_FF>
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  80172a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80172e:	74 16                	je     801746 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801730:	83 ec 0c             	sub    $0xc,%esp
  801733:	ff 75 ec             	pushl  -0x14(%ebp)
  801736:	e8 48 0c 00 00       	call   802383 <insert_sorted_allocList>
  80173b:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  80173e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801741:	8b 40 08             	mov    0x8(%eax),%eax
  801744:	eb 05                	jmp    80174b <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801746:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801761:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	83 ec 08             	sub    $0x8,%esp
  80176a:	50                   	push   %eax
  80176b:	68 40 40 80 00       	push   $0x804040
  801770:	e8 71 0b 00 00       	call   8022e6 <find_block>
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80177b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177e:	8b 50 0c             	mov    0xc(%eax),%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	83 ec 08             	sub    $0x8,%esp
  801787:	52                   	push   %edx
  801788:	50                   	push   %eax
  801789:	e8 bd 03 00 00       	call   801b4b <sys_free_user_mem>
  80178e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801791:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801795:	75 14                	jne    8017ab <free+0x5e>
  801797:	83 ec 04             	sub    $0x4,%esp
  80179a:	68 b5 3a 80 00       	push   $0x803ab5
  80179f:	6a 71                	push   $0x71
  8017a1:	68 d3 3a 80 00       	push   $0x803ad3
  8017a6:	e8 47 ed ff ff       	call   8004f2 <_panic>
  8017ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ae:	8b 00                	mov    (%eax),%eax
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	74 10                	je     8017c4 <free+0x77>
  8017b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b7:	8b 00                	mov    (%eax),%eax
  8017b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017bc:	8b 52 04             	mov    0x4(%edx),%edx
  8017bf:	89 50 04             	mov    %edx,0x4(%eax)
  8017c2:	eb 0b                	jmp    8017cf <free+0x82>
  8017c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c7:	8b 40 04             	mov    0x4(%eax),%eax
  8017ca:	a3 44 40 80 00       	mov    %eax,0x804044
  8017cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d2:	8b 40 04             	mov    0x4(%eax),%eax
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	74 0f                	je     8017e8 <free+0x9b>
  8017d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017dc:	8b 40 04             	mov    0x4(%eax),%eax
  8017df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e2:	8b 12                	mov    (%edx),%edx
  8017e4:	89 10                	mov    %edx,(%eax)
  8017e6:	eb 0a                	jmp    8017f2 <free+0xa5>
  8017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017eb:	8b 00                	mov    (%eax),%eax
  8017ed:	a3 40 40 80 00       	mov    %eax,0x804040
  8017f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801805:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80180a:	48                   	dec    %eax
  80180b:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  801810:	83 ec 0c             	sub    $0xc,%esp
  801813:	ff 75 f0             	pushl  -0x10(%ebp)
  801816:	e8 83 12 00 00       	call   802a9e <insert_sorted_with_merge_freeList>
  80181b:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80181e:	90                   	nop
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 28             	sub    $0x28,%esp
  801827:	8b 45 10             	mov    0x10(%ebp),%eax
  80182a:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80182d:	e8 fe fc ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  801832:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801836:	75 0a                	jne    801842 <smalloc+0x21>
  801838:	b8 00 00 00 00       	mov    $0x0,%eax
  80183d:	e9 86 00 00 00       	jmp    8018c8 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801842:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184f:	01 d0                	add    %edx,%eax
  801851:	48                   	dec    %eax
  801852:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	f7 75 f4             	divl   -0xc(%ebp)
  801860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801863:	29 d0                	sub    %edx,%eax
  801865:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801868:	e8 e4 06 00 00       	call   801f51 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80186d:	85 c0                	test   %eax,%eax
  80186f:	74 52                	je     8018c3 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801871:	83 ec 0c             	sub    $0xc,%esp
  801874:	ff 75 0c             	pushl  0xc(%ebp)
  801877:	e8 e6 0d 00 00       	call   802662 <alloc_block_FF>
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801882:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801886:	75 07                	jne    80188f <smalloc+0x6e>
			return NULL ;
  801888:	b8 00 00 00 00       	mov    $0x0,%eax
  80188d:	eb 39                	jmp    8018c8 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80188f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801892:	8b 40 08             	mov    0x8(%eax),%eax
  801895:	89 c2                	mov    %eax,%edx
  801897:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80189b:	52                   	push   %edx
  80189c:	50                   	push   %eax
  80189d:	ff 75 0c             	pushl  0xc(%ebp)
  8018a0:	ff 75 08             	pushl  0x8(%ebp)
  8018a3:	e8 2e 04 00 00       	call   801cd6 <sys_createSharedObject>
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  8018ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018b2:	79 07                	jns    8018bb <smalloc+0x9a>
			return (void*)NULL ;
  8018b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b9:	eb 0d                	jmp    8018c8 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  8018bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018be:	8b 40 08             	mov    0x8(%eax),%eax
  8018c1:	eb 05                	jmp    8018c8 <smalloc+0xa7>
		}
		return (void*)NULL ;
  8018c3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018d0:	e8 5b fc ff ff       	call   801530 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018d5:	83 ec 08             	sub    $0x8,%esp
  8018d8:	ff 75 0c             	pushl  0xc(%ebp)
  8018db:	ff 75 08             	pushl  0x8(%ebp)
  8018de:	e8 1d 04 00 00       	call   801d00 <sys_getSizeOfSharedObject>
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8018e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018ed:	75 0a                	jne    8018f9 <sget+0x2f>
			return NULL ;
  8018ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f4:	e9 83 00 00 00       	jmp    80197c <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8018f9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801900:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801906:	01 d0                	add    %edx,%eax
  801908:	48                   	dec    %eax
  801909:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80190c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80190f:	ba 00 00 00 00       	mov    $0x0,%edx
  801914:	f7 75 f0             	divl   -0x10(%ebp)
  801917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191a:	29 d0                	sub    %edx,%eax
  80191c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80191f:	e8 2d 06 00 00       	call   801f51 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801924:	85 c0                	test   %eax,%eax
  801926:	74 4f                	je     801977 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192b:	83 ec 0c             	sub    $0xc,%esp
  80192e:	50                   	push   %eax
  80192f:	e8 2e 0d 00 00       	call   802662 <alloc_block_FF>
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  80193a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80193e:	75 07                	jne    801947 <sget+0x7d>
					return (void*)NULL ;
  801940:	b8 00 00 00 00       	mov    $0x0,%eax
  801945:	eb 35                	jmp    80197c <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801947:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80194a:	8b 40 08             	mov    0x8(%eax),%eax
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	50                   	push   %eax
  801951:	ff 75 0c             	pushl  0xc(%ebp)
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	e8 c1 03 00 00       	call   801d1d <sys_getSharedObject>
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801962:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801966:	79 07                	jns    80196f <sget+0xa5>
				return (void*)NULL ;
  801968:	b8 00 00 00 00       	mov    $0x0,%eax
  80196d:	eb 0d                	jmp    80197c <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  80196f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801972:	8b 40 08             	mov    0x8(%eax),%eax
  801975:	eb 05                	jmp    80197c <sget+0xb2>


		}
	return (void*)NULL ;
  801977:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801984:	e8 a7 fb ff ff       	call   801530 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801989:	83 ec 04             	sub    $0x4,%esp
  80198c:	68 e0 3a 80 00       	push   $0x803ae0
  801991:	68 f9 00 00 00       	push   $0xf9
  801996:	68 d3 3a 80 00       	push   $0x803ad3
  80199b:	e8 52 eb ff ff       	call   8004f2 <_panic>

008019a0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	68 08 3b 80 00       	push   $0x803b08
  8019ae:	68 0d 01 00 00       	push   $0x10d
  8019b3:	68 d3 3a 80 00       	push   $0x803ad3
  8019b8:	e8 35 eb ff ff       	call   8004f2 <_panic>

008019bd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	68 2c 3b 80 00       	push   $0x803b2c
  8019cb:	68 18 01 00 00       	push   $0x118
  8019d0:	68 d3 3a 80 00       	push   $0x803ad3
  8019d5:	e8 18 eb ff ff       	call   8004f2 <_panic>

008019da <shrink>:

}
void shrink(uint32 newSize)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e0:	83 ec 04             	sub    $0x4,%esp
  8019e3:	68 2c 3b 80 00       	push   $0x803b2c
  8019e8:	68 1d 01 00 00       	push   $0x11d
  8019ed:	68 d3 3a 80 00       	push   $0x803ad3
  8019f2:	e8 fb ea ff ff       	call   8004f2 <_panic>

008019f7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	68 2c 3b 80 00       	push   $0x803b2c
  801a05:	68 22 01 00 00       	push   $0x122
  801a0a:	68 d3 3a 80 00       	push   $0x803ad3
  801a0f:	e8 de ea ff ff       	call   8004f2 <_panic>

00801a14 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	57                   	push   %edi
  801a18:	56                   	push   %esi
  801a19:	53                   	push   %ebx
  801a1a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a26:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a29:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a2c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a2f:	cd 30                	int    $0x30
  801a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	5b                   	pop    %ebx
  801a3b:	5e                   	pop    %esi
  801a3c:	5f                   	pop    %edi
  801a3d:	5d                   	pop    %ebp
  801a3e:	c3                   	ret    

00801a3f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	8b 45 10             	mov    0x10(%ebp),%eax
  801a48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a4b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	52                   	push   %edx
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	50                   	push   %eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	e8 b2 ff ff ff       	call   801a14 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	90                   	nop
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 01                	push   $0x1
  801a77:	e8 98 ff ff ff       	call   801a14 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	52                   	push   %edx
  801a91:	50                   	push   %eax
  801a92:	6a 05                	push   $0x5
  801a94:	e8 7b ff ff ff       	call   801a14 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	56                   	push   %esi
  801aa2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801aa3:	8b 75 18             	mov    0x18(%ebp),%esi
  801aa6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aa9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	56                   	push   %esi
  801ab3:	53                   	push   %ebx
  801ab4:	51                   	push   %ecx
  801ab5:	52                   	push   %edx
  801ab6:	50                   	push   %eax
  801ab7:	6a 06                	push   $0x6
  801ab9:	e8 56 ff ff ff       	call   801a14 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac4:	5b                   	pop    %ebx
  801ac5:	5e                   	pop    %esi
  801ac6:	5d                   	pop    %ebp
  801ac7:	c3                   	ret    

00801ac8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801acb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	52                   	push   %edx
  801ad8:	50                   	push   %eax
  801ad9:	6a 07                	push   $0x7
  801adb:	e8 34 ff ff ff       	call   801a14 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	ff 75 0c             	pushl  0xc(%ebp)
  801af1:	ff 75 08             	pushl  0x8(%ebp)
  801af4:	6a 08                	push   $0x8
  801af6:	e8 19 ff ff ff       	call   801a14 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 09                	push   $0x9
  801b0f:	e8 00 ff ff ff       	call   801a14 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 0a                	push   $0xa
  801b28:	e8 e7 fe ff ff       	call   801a14 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 0b                	push   $0xb
  801b41:	e8 ce fe ff ff       	call   801a14 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	ff 75 08             	pushl  0x8(%ebp)
  801b5a:	6a 0f                	push   $0xf
  801b5c:	e8 b3 fe ff ff       	call   801a14 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
	return;
  801b64:	90                   	nop
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	ff 75 0c             	pushl  0xc(%ebp)
  801b73:	ff 75 08             	pushl  0x8(%ebp)
  801b76:	6a 10                	push   $0x10
  801b78:	e8 97 fe ff ff       	call   801a14 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b80:	90                   	nop
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	ff 75 10             	pushl  0x10(%ebp)
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	ff 75 08             	pushl  0x8(%ebp)
  801b93:	6a 11                	push   $0x11
  801b95:	e8 7a fe ff ff       	call   801a14 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9d:	90                   	nop
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 0c                	push   $0xc
  801baf:	e8 60 fe ff ff       	call   801a14 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	ff 75 08             	pushl  0x8(%ebp)
  801bc7:	6a 0d                	push   $0xd
  801bc9:	e8 46 fe ff ff       	call   801a14 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 0e                	push   $0xe
  801be2:	e8 2d fe ff ff       	call   801a14 <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	90                   	nop
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 13                	push   $0x13
  801bfc:	e8 13 fe ff ff       	call   801a14 <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	90                   	nop
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 14                	push   $0x14
  801c16:	e8 f9 fd ff ff       	call   801a14 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	90                   	nop
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 04             	sub    $0x4,%esp
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c2d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	50                   	push   %eax
  801c3a:	6a 15                	push   $0x15
  801c3c:	e8 d3 fd ff ff       	call   801a14 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	90                   	nop
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 16                	push   $0x16
  801c56:	e8 b9 fd ff ff       	call   801a14 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	90                   	nop
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	50                   	push   %eax
  801c71:	6a 17                	push   $0x17
  801c73:	e8 9c fd ff ff       	call   801a14 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	52                   	push   %edx
  801c8d:	50                   	push   %eax
  801c8e:	6a 1a                	push   $0x1a
  801c90:	e8 7f fd ff ff       	call   801a14 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	52                   	push   %edx
  801caa:	50                   	push   %eax
  801cab:	6a 18                	push   $0x18
  801cad:	e8 62 fd ff ff       	call   801a14 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	90                   	nop
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	52                   	push   %edx
  801cc8:	50                   	push   %eax
  801cc9:	6a 19                	push   $0x19
  801ccb:	e8 44 fd ff ff       	call   801a14 <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	90                   	nop
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 04             	sub    $0x4,%esp
  801cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cdf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ce2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ce5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	6a 00                	push   $0x0
  801cee:	51                   	push   %ecx
  801cef:	52                   	push   %edx
  801cf0:	ff 75 0c             	pushl  0xc(%ebp)
  801cf3:	50                   	push   %eax
  801cf4:	6a 1b                	push   $0x1b
  801cf6:	e8 19 fd ff ff       	call   801a14 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	52                   	push   %edx
  801d10:	50                   	push   %eax
  801d11:	6a 1c                	push   $0x1c
  801d13:	e8 fc fc ff ff       	call   801a14 <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	51                   	push   %ecx
  801d2e:	52                   	push   %edx
  801d2f:	50                   	push   %eax
  801d30:	6a 1d                	push   $0x1d
  801d32:	e8 dd fc ff ff       	call   801a14 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	52                   	push   %edx
  801d4c:	50                   	push   %eax
  801d4d:	6a 1e                	push   $0x1e
  801d4f:	e8 c0 fc ff ff       	call   801a14 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 1f                	push   $0x1f
  801d68:	e8 a7 fc ff ff       	call   801a14 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	6a 00                	push   $0x0
  801d7a:	ff 75 14             	pushl  0x14(%ebp)
  801d7d:	ff 75 10             	pushl  0x10(%ebp)
  801d80:	ff 75 0c             	pushl  0xc(%ebp)
  801d83:	50                   	push   %eax
  801d84:	6a 20                	push   $0x20
  801d86:	e8 89 fc ff ff       	call   801a14 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	50                   	push   %eax
  801d9f:	6a 21                	push   $0x21
  801da1:	e8 6e fc ff ff       	call   801a14 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
}
  801da9:	90                   	nop
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	50                   	push   %eax
  801dbb:	6a 22                	push   $0x22
  801dbd:	e8 52 fc ff ff       	call   801a14 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 02                	push   $0x2
  801dd6:	e8 39 fc ff ff       	call   801a14 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 03                	push   $0x3
  801def:	e8 20 fc ff ff       	call   801a14 <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 04                	push   $0x4
  801e08:	e8 07 fc ff ff       	call   801a14 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <sys_exit_env>:


void sys_exit_env(void)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 23                	push   $0x23
  801e21:	e8 ee fb ff ff       	call   801a14 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
}
  801e29:	90                   	nop
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e32:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e35:	8d 50 04             	lea    0x4(%eax),%edx
  801e38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	52                   	push   %edx
  801e42:	50                   	push   %eax
  801e43:	6a 24                	push   $0x24
  801e45:	e8 ca fb ff ff       	call   801a14 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
	return result;
  801e4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e56:	89 01                	mov    %eax,(%ecx)
  801e58:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	c9                   	leave  
  801e5f:	c2 04 00             	ret    $0x4

00801e62 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	ff 75 10             	pushl  0x10(%ebp)
  801e6c:	ff 75 0c             	pushl  0xc(%ebp)
  801e6f:	ff 75 08             	pushl  0x8(%ebp)
  801e72:	6a 12                	push   $0x12
  801e74:	e8 9b fb ff ff       	call   801a14 <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7c:	90                   	nop
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_rcr2>:
uint32 sys_rcr2()
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 25                	push   $0x25
  801e8e:	e8 81 fb ff ff       	call   801a14 <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ea4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	50                   	push   %eax
  801eb1:	6a 26                	push   $0x26
  801eb3:	e8 5c fb ff ff       	call   801a14 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebb:	90                   	nop
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <rsttst>:
void rsttst()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 28                	push   $0x28
  801ecd:	e8 42 fb ff ff       	call   801a14 <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed5:	90                   	nop
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ee4:	8b 55 18             	mov    0x18(%ebp),%edx
  801ee7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eeb:	52                   	push   %edx
  801eec:	50                   	push   %eax
  801eed:	ff 75 10             	pushl  0x10(%ebp)
  801ef0:	ff 75 0c             	pushl  0xc(%ebp)
  801ef3:	ff 75 08             	pushl  0x8(%ebp)
  801ef6:	6a 27                	push   $0x27
  801ef8:	e8 17 fb ff ff       	call   801a14 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
	return ;
  801f00:	90                   	nop
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <chktst>:
void chktst(uint32 n)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	ff 75 08             	pushl  0x8(%ebp)
  801f11:	6a 29                	push   $0x29
  801f13:	e8 fc fa ff ff       	call   801a14 <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1b:	90                   	nop
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <inctst>:

void inctst()
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 2a                	push   $0x2a
  801f2d:	e8 e2 fa ff ff       	call   801a14 <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
	return ;
  801f35:	90                   	nop
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <gettst>:
uint32 gettst()
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 2b                	push   $0x2b
  801f47:	e8 c8 fa ff ff       	call   801a14 <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 2c                	push   $0x2c
  801f63:	e8 ac fa ff ff       	call   801a14 <syscall>
  801f68:	83 c4 18             	add    $0x18,%esp
  801f6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f6e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f72:	75 07                	jne    801f7b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f74:	b8 01 00 00 00       	mov    $0x1,%eax
  801f79:	eb 05                	jmp    801f80 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 2c                	push   $0x2c
  801f94:	e8 7b fa ff ff       	call   801a14 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
  801f9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f9f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fa3:	75 07                	jne    801fac <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fa5:	b8 01 00 00 00       	mov    $0x1,%eax
  801faa:	eb 05                	jmp    801fb1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 2c                	push   $0x2c
  801fc5:	e8 4a fa ff ff       	call   801a14 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
  801fcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fd0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fd4:	75 07                	jne    801fdd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fdb:	eb 05                	jmp    801fe2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 2c                	push   $0x2c
  801ff6:	e8 19 fa ff ff       	call   801a14 <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
  801ffe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802001:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802005:	75 07                	jne    80200e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802007:	b8 01 00 00 00       	mov    $0x1,%eax
  80200c:	eb 05                	jmp    802013 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	ff 75 08             	pushl  0x8(%ebp)
  802023:	6a 2d                	push   $0x2d
  802025:	e8 ea f9 ff ff       	call   801a14 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
	return ;
  80202d:	90                   	nop
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802034:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802037:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80203a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	6a 00                	push   $0x0
  802042:	53                   	push   %ebx
  802043:	51                   	push   %ecx
  802044:	52                   	push   %edx
  802045:	50                   	push   %eax
  802046:	6a 2e                	push   $0x2e
  802048:	e8 c7 f9 ff ff       	call   801a14 <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
}
  802050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802058:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	52                   	push   %edx
  802065:	50                   	push   %eax
  802066:	6a 2f                	push   $0x2f
  802068:	e8 a7 f9 ff ff       	call   801a14 <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802078:	83 ec 0c             	sub    $0xc,%esp
  80207b:	68 3c 3b 80 00       	push   $0x803b3c
  802080:	e8 21 e7 ff ff       	call   8007a6 <cprintf>
  802085:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802088:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80208f:	83 ec 0c             	sub    $0xc,%esp
  802092:	68 68 3b 80 00       	push   $0x803b68
  802097:	e8 0a e7 ff ff       	call   8007a6 <cprintf>
  80209c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80209f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020a3:	a1 38 41 80 00       	mov    0x804138,%eax
  8020a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ab:	eb 56                	jmp    802103 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020b1:	74 1c                	je     8020cf <print_mem_block_lists+0x5d>
  8020b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b6:	8b 50 08             	mov    0x8(%eax),%edx
  8020b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bc:	8b 48 08             	mov    0x8(%eax),%ecx
  8020bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c5:	01 c8                	add    %ecx,%eax
  8020c7:	39 c2                	cmp    %eax,%edx
  8020c9:	73 04                	jae    8020cf <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020cb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d2:	8b 50 08             	mov    0x8(%eax),%edx
  8020d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8020db:	01 c2                	add    %eax,%edx
  8020dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e0:	8b 40 08             	mov    0x8(%eax),%eax
  8020e3:	83 ec 04             	sub    $0x4,%esp
  8020e6:	52                   	push   %edx
  8020e7:	50                   	push   %eax
  8020e8:	68 7d 3b 80 00       	push   $0x803b7d
  8020ed:	e8 b4 e6 ff ff       	call   8007a6 <cprintf>
  8020f2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020fb:	a1 40 41 80 00       	mov    0x804140,%eax
  802100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802103:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802107:	74 07                	je     802110 <print_mem_block_lists+0x9e>
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210c:	8b 00                	mov    (%eax),%eax
  80210e:	eb 05                	jmp    802115 <print_mem_block_lists+0xa3>
  802110:	b8 00 00 00 00       	mov    $0x0,%eax
  802115:	a3 40 41 80 00       	mov    %eax,0x804140
  80211a:	a1 40 41 80 00       	mov    0x804140,%eax
  80211f:	85 c0                	test   %eax,%eax
  802121:	75 8a                	jne    8020ad <print_mem_block_lists+0x3b>
  802123:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802127:	75 84                	jne    8020ad <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802129:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80212d:	75 10                	jne    80213f <print_mem_block_lists+0xcd>
  80212f:	83 ec 0c             	sub    $0xc,%esp
  802132:	68 8c 3b 80 00       	push   $0x803b8c
  802137:	e8 6a e6 ff ff       	call   8007a6 <cprintf>
  80213c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80213f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802146:	83 ec 0c             	sub    $0xc,%esp
  802149:	68 b0 3b 80 00       	push   $0x803bb0
  80214e:	e8 53 e6 ff ff       	call   8007a6 <cprintf>
  802153:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802156:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80215a:	a1 40 40 80 00       	mov    0x804040,%eax
  80215f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802162:	eb 56                	jmp    8021ba <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802164:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802168:	74 1c                	je     802186 <print_mem_block_lists+0x114>
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	8b 50 08             	mov    0x8(%eax),%edx
  802170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802173:	8b 48 08             	mov    0x8(%eax),%ecx
  802176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802179:	8b 40 0c             	mov    0xc(%eax),%eax
  80217c:	01 c8                	add    %ecx,%eax
  80217e:	39 c2                	cmp    %eax,%edx
  802180:	73 04                	jae    802186 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802182:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802189:	8b 50 08             	mov    0x8(%eax),%edx
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 40 0c             	mov    0xc(%eax),%eax
  802192:	01 c2                	add    %eax,%edx
  802194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802197:	8b 40 08             	mov    0x8(%eax),%eax
  80219a:	83 ec 04             	sub    $0x4,%esp
  80219d:	52                   	push   %edx
  80219e:	50                   	push   %eax
  80219f:	68 7d 3b 80 00       	push   $0x803b7d
  8021a4:	e8 fd e5 ff ff       	call   8007a6 <cprintf>
  8021a9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021b2:	a1 48 40 80 00       	mov    0x804048,%eax
  8021b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021be:	74 07                	je     8021c7 <print_mem_block_lists+0x155>
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	eb 05                	jmp    8021cc <print_mem_block_lists+0x15a>
  8021c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cc:	a3 48 40 80 00       	mov    %eax,0x804048
  8021d1:	a1 48 40 80 00       	mov    0x804048,%eax
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	75 8a                	jne    802164 <print_mem_block_lists+0xf2>
  8021da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021de:	75 84                	jne    802164 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021e0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021e4:	75 10                	jne    8021f6 <print_mem_block_lists+0x184>
  8021e6:	83 ec 0c             	sub    $0xc,%esp
  8021e9:	68 c8 3b 80 00       	push   $0x803bc8
  8021ee:	e8 b3 e5 ff ff       	call   8007a6 <cprintf>
  8021f3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021f6:	83 ec 0c             	sub    $0xc,%esp
  8021f9:	68 3c 3b 80 00       	push   $0x803b3c
  8021fe:	e8 a3 e5 ff ff       	call   8007a6 <cprintf>
  802203:	83 c4 10             	add    $0x10,%esp

}
  802206:	90                   	nop
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80220f:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802216:	00 00 00 
  802219:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802220:	00 00 00 
  802223:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80222a:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80222d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802234:	e9 9e 00 00 00       	jmp    8022d7 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802239:	a1 50 40 80 00       	mov    0x804050,%eax
  80223e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802241:	c1 e2 04             	shl    $0x4,%edx
  802244:	01 d0                	add    %edx,%eax
  802246:	85 c0                	test   %eax,%eax
  802248:	75 14                	jne    80225e <initialize_MemBlocksList+0x55>
  80224a:	83 ec 04             	sub    $0x4,%esp
  80224d:	68 f0 3b 80 00       	push   $0x803bf0
  802252:	6a 43                	push   $0x43
  802254:	68 13 3c 80 00       	push   $0x803c13
  802259:	e8 94 e2 ff ff       	call   8004f2 <_panic>
  80225e:	a1 50 40 80 00       	mov    0x804050,%eax
  802263:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802266:	c1 e2 04             	shl    $0x4,%edx
  802269:	01 d0                	add    %edx,%eax
  80226b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802271:	89 10                	mov    %edx,(%eax)
  802273:	8b 00                	mov    (%eax),%eax
  802275:	85 c0                	test   %eax,%eax
  802277:	74 18                	je     802291 <initialize_MemBlocksList+0x88>
  802279:	a1 48 41 80 00       	mov    0x804148,%eax
  80227e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802284:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802287:	c1 e1 04             	shl    $0x4,%ecx
  80228a:	01 ca                	add    %ecx,%edx
  80228c:	89 50 04             	mov    %edx,0x4(%eax)
  80228f:	eb 12                	jmp    8022a3 <initialize_MemBlocksList+0x9a>
  802291:	a1 50 40 80 00       	mov    0x804050,%eax
  802296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802299:	c1 e2 04             	shl    $0x4,%edx
  80229c:	01 d0                	add    %edx,%eax
  80229e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022a3:	a1 50 40 80 00       	mov    0x804050,%eax
  8022a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ab:	c1 e2 04             	shl    $0x4,%edx
  8022ae:	01 d0                	add    %edx,%eax
  8022b0:	a3 48 41 80 00       	mov    %eax,0x804148
  8022b5:	a1 50 40 80 00       	mov    0x804050,%eax
  8022ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bd:	c1 e2 04             	shl    $0x4,%edx
  8022c0:	01 d0                	add    %edx,%eax
  8022c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c9:	a1 54 41 80 00       	mov    0x804154,%eax
  8022ce:	40                   	inc    %eax
  8022cf:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8022d4:	ff 45 f4             	incl   -0xc(%ebp)
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022dd:	0f 82 56 ff ff ff    	jb     802239 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8022e3:	90                   	nop
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8022ec:	a1 38 41 80 00       	mov    0x804138,%eax
  8022f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022f4:	eb 18                	jmp    80230e <find_block+0x28>
	{
		if (ele->sva==va)
  8022f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f9:	8b 40 08             	mov    0x8(%eax),%eax
  8022fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022ff:	75 05                	jne    802306 <find_block+0x20>
			return ele;
  802301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802304:	eb 7b                	jmp    802381 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802306:	a1 40 41 80 00       	mov    0x804140,%eax
  80230b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80230e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802312:	74 07                	je     80231b <find_block+0x35>
  802314:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802317:	8b 00                	mov    (%eax),%eax
  802319:	eb 05                	jmp    802320 <find_block+0x3a>
  80231b:	b8 00 00 00 00       	mov    $0x0,%eax
  802320:	a3 40 41 80 00       	mov    %eax,0x804140
  802325:	a1 40 41 80 00       	mov    0x804140,%eax
  80232a:	85 c0                	test   %eax,%eax
  80232c:	75 c8                	jne    8022f6 <find_block+0x10>
  80232e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802332:	75 c2                	jne    8022f6 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802334:	a1 40 40 80 00       	mov    0x804040,%eax
  802339:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80233c:	eb 18                	jmp    802356 <find_block+0x70>
	{
		if (ele->sva==va)
  80233e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802341:	8b 40 08             	mov    0x8(%eax),%eax
  802344:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802347:	75 05                	jne    80234e <find_block+0x68>
					return ele;
  802349:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80234c:	eb 33                	jmp    802381 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80234e:	a1 48 40 80 00       	mov    0x804048,%eax
  802353:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802356:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80235a:	74 07                	je     802363 <find_block+0x7d>
  80235c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80235f:	8b 00                	mov    (%eax),%eax
  802361:	eb 05                	jmp    802368 <find_block+0x82>
  802363:	b8 00 00 00 00       	mov    $0x0,%eax
  802368:	a3 48 40 80 00       	mov    %eax,0x804048
  80236d:	a1 48 40 80 00       	mov    0x804048,%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	75 c8                	jne    80233e <find_block+0x58>
  802376:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80237a:	75 c2                	jne    80233e <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80237c:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802389:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80238e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802391:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802395:	75 62                	jne    8023f9 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802397:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239b:	75 14                	jne    8023b1 <insert_sorted_allocList+0x2e>
  80239d:	83 ec 04             	sub    $0x4,%esp
  8023a0:	68 f0 3b 80 00       	push   $0x803bf0
  8023a5:	6a 69                	push   $0x69
  8023a7:	68 13 3c 80 00       	push   $0x803c13
  8023ac:	e8 41 e1 ff ff       	call   8004f2 <_panic>
  8023b1:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ba:	89 10                	mov    %edx,(%eax)
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	8b 00                	mov    (%eax),%eax
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	74 0d                	je     8023d2 <insert_sorted_allocList+0x4f>
  8023c5:	a1 40 40 80 00       	mov    0x804040,%eax
  8023ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cd:	89 50 04             	mov    %edx,0x4(%eax)
  8023d0:	eb 08                	jmp    8023da <insert_sorted_allocList+0x57>
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	a3 44 40 80 00       	mov    %eax,0x804044
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	a3 40 40 80 00       	mov    %eax,0x804040
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ec:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023f1:	40                   	inc    %eax
  8023f2:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023f7:	eb 72                	jmp    80246b <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8023f9:	a1 40 40 80 00       	mov    0x804040,%eax
  8023fe:	8b 50 08             	mov    0x8(%eax),%edx
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	8b 40 08             	mov    0x8(%eax),%eax
  802407:	39 c2                	cmp    %eax,%edx
  802409:	76 60                	jbe    80246b <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80240b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80240f:	75 14                	jne    802425 <insert_sorted_allocList+0xa2>
  802411:	83 ec 04             	sub    $0x4,%esp
  802414:	68 f0 3b 80 00       	push   $0x803bf0
  802419:	6a 6d                	push   $0x6d
  80241b:	68 13 3c 80 00       	push   $0x803c13
  802420:	e8 cd e0 ff ff       	call   8004f2 <_panic>
  802425:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	89 10                	mov    %edx,(%eax)
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	74 0d                	je     802446 <insert_sorted_allocList+0xc3>
  802439:	a1 40 40 80 00       	mov    0x804040,%eax
  80243e:	8b 55 08             	mov    0x8(%ebp),%edx
  802441:	89 50 04             	mov    %edx,0x4(%eax)
  802444:	eb 08                	jmp    80244e <insert_sorted_allocList+0xcb>
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	a3 44 40 80 00       	mov    %eax,0x804044
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	a3 40 40 80 00       	mov    %eax,0x804040
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802460:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802465:	40                   	inc    %eax
  802466:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80246b:	a1 40 40 80 00       	mov    0x804040,%eax
  802470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802473:	e9 b9 01 00 00       	jmp    802631 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	8b 50 08             	mov    0x8(%eax),%edx
  80247e:	a1 40 40 80 00       	mov    0x804040,%eax
  802483:	8b 40 08             	mov    0x8(%eax),%eax
  802486:	39 c2                	cmp    %eax,%edx
  802488:	76 7c                	jbe    802506 <insert_sorted_allocList+0x183>
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	8b 50 08             	mov    0x8(%eax),%edx
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 40 08             	mov    0x8(%eax),%eax
  802496:	39 c2                	cmp    %eax,%edx
  802498:	73 6c                	jae    802506 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80249a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249e:	74 06                	je     8024a6 <insert_sorted_allocList+0x123>
  8024a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024a4:	75 14                	jne    8024ba <insert_sorted_allocList+0x137>
  8024a6:	83 ec 04             	sub    $0x4,%esp
  8024a9:	68 2c 3c 80 00       	push   $0x803c2c
  8024ae:	6a 75                	push   $0x75
  8024b0:	68 13 3c 80 00       	push   $0x803c13
  8024b5:	e8 38 e0 ff ff       	call   8004f2 <_panic>
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 50 04             	mov    0x4(%eax),%edx
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	89 50 04             	mov    %edx,0x4(%eax)
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cc:	89 10                	mov    %edx,(%eax)
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	8b 40 04             	mov    0x4(%eax),%eax
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	74 0d                	je     8024e5 <insert_sorted_allocList+0x162>
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 40 04             	mov    0x4(%eax),%eax
  8024de:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e1:	89 10                	mov    %edx,(%eax)
  8024e3:	eb 08                	jmp    8024ed <insert_sorted_allocList+0x16a>
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	a3 40 40 80 00       	mov    %eax,0x804040
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f3:	89 50 04             	mov    %edx,0x4(%eax)
  8024f6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024fb:	40                   	inc    %eax
  8024fc:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  802501:	e9 59 01 00 00       	jmp    80265f <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	8b 50 08             	mov    0x8(%eax),%edx
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 40 08             	mov    0x8(%eax),%eax
  802512:	39 c2                	cmp    %eax,%edx
  802514:	0f 86 98 00 00 00    	jbe    8025b2 <insert_sorted_allocList+0x22f>
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	8b 50 08             	mov    0x8(%eax),%edx
  802520:	a1 44 40 80 00       	mov    0x804044,%eax
  802525:	8b 40 08             	mov    0x8(%eax),%eax
  802528:	39 c2                	cmp    %eax,%edx
  80252a:	0f 83 82 00 00 00    	jae    8025b2 <insert_sorted_allocList+0x22f>
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	8b 50 08             	mov    0x8(%eax),%edx
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 00                	mov    (%eax),%eax
  80253b:	8b 40 08             	mov    0x8(%eax),%eax
  80253e:	39 c2                	cmp    %eax,%edx
  802540:	73 70                	jae    8025b2 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802546:	74 06                	je     80254e <insert_sorted_allocList+0x1cb>
  802548:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80254c:	75 14                	jne    802562 <insert_sorted_allocList+0x1df>
  80254e:	83 ec 04             	sub    $0x4,%esp
  802551:	68 64 3c 80 00       	push   $0x803c64
  802556:	6a 7c                	push   $0x7c
  802558:	68 13 3c 80 00       	push   $0x803c13
  80255d:	e8 90 df ff ff       	call   8004f2 <_panic>
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 10                	mov    (%eax),%edx
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	89 10                	mov    %edx,(%eax)
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	85 c0                	test   %eax,%eax
  802573:	74 0b                	je     802580 <insert_sorted_allocList+0x1fd>
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 00                	mov    (%eax),%eax
  80257a:	8b 55 08             	mov    0x8(%ebp),%edx
  80257d:	89 50 04             	mov    %edx,0x4(%eax)
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 55 08             	mov    0x8(%ebp),%edx
  802586:	89 10                	mov    %edx,(%eax)
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258e:	89 50 04             	mov    %edx,0x4(%eax)
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	8b 00                	mov    (%eax),%eax
  802596:	85 c0                	test   %eax,%eax
  802598:	75 08                	jne    8025a2 <insert_sorted_allocList+0x21f>
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	a3 44 40 80 00       	mov    %eax,0x804044
  8025a2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8025a7:	40                   	inc    %eax
  8025a8:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8025ad:	e9 ad 00 00 00       	jmp    80265f <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8025b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b5:	8b 50 08             	mov    0x8(%eax),%edx
  8025b8:	a1 44 40 80 00       	mov    0x804044,%eax
  8025bd:	8b 40 08             	mov    0x8(%eax),%eax
  8025c0:	39 c2                	cmp    %eax,%edx
  8025c2:	76 65                	jbe    802629 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8025c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025c8:	75 17                	jne    8025e1 <insert_sorted_allocList+0x25e>
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	68 98 3c 80 00       	push   $0x803c98
  8025d2:	68 80 00 00 00       	push   $0x80
  8025d7:	68 13 3c 80 00       	push   $0x803c13
  8025dc:	e8 11 df ff ff       	call   8004f2 <_panic>
  8025e1:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8025e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ea:	89 50 04             	mov    %edx,0x4(%eax)
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	8b 40 04             	mov    0x4(%eax),%eax
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	74 0c                	je     802603 <insert_sorted_allocList+0x280>
  8025f7:	a1 44 40 80 00       	mov    0x804044,%eax
  8025fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ff:	89 10                	mov    %edx,(%eax)
  802601:	eb 08                	jmp    80260b <insert_sorted_allocList+0x288>
  802603:	8b 45 08             	mov    0x8(%ebp),%eax
  802606:	a3 40 40 80 00       	mov    %eax,0x804040
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	a3 44 40 80 00       	mov    %eax,0x804044
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80261c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802621:	40                   	inc    %eax
  802622:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802627:	eb 36                	jmp    80265f <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802629:	a1 48 40 80 00       	mov    0x804048,%eax
  80262e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802635:	74 07                	je     80263e <insert_sorted_allocList+0x2bb>
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	eb 05                	jmp    802643 <insert_sorted_allocList+0x2c0>
  80263e:	b8 00 00 00 00       	mov    $0x0,%eax
  802643:	a3 48 40 80 00       	mov    %eax,0x804048
  802648:	a1 48 40 80 00       	mov    0x804048,%eax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	0f 85 23 fe ff ff    	jne    802478 <insert_sorted_allocList+0xf5>
  802655:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802659:	0f 85 19 fe ff ff    	jne    802478 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  80265f:	90                   	nop
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
  802665:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802668:	a1 38 41 80 00       	mov    0x804138,%eax
  80266d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802670:	e9 7c 01 00 00       	jmp    8027f1 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 40 0c             	mov    0xc(%eax),%eax
  80267b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267e:	0f 85 90 00 00 00    	jne    802714 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80268a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268e:	75 17                	jne    8026a7 <alloc_block_FF+0x45>
  802690:	83 ec 04             	sub    $0x4,%esp
  802693:	68 bb 3c 80 00       	push   $0x803cbb
  802698:	68 ba 00 00 00       	push   $0xba
  80269d:	68 13 3c 80 00       	push   $0x803c13
  8026a2:	e8 4b de ff ff       	call   8004f2 <_panic>
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 00                	mov    (%eax),%eax
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	74 10                	je     8026c0 <alloc_block_FF+0x5e>
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 00                	mov    (%eax),%eax
  8026b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b8:	8b 52 04             	mov    0x4(%edx),%edx
  8026bb:	89 50 04             	mov    %edx,0x4(%eax)
  8026be:	eb 0b                	jmp    8026cb <alloc_block_FF+0x69>
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 40 04             	mov    0x4(%eax),%eax
  8026c6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	8b 40 04             	mov    0x4(%eax),%eax
  8026d1:	85 c0                	test   %eax,%eax
  8026d3:	74 0f                	je     8026e4 <alloc_block_FF+0x82>
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026de:	8b 12                	mov    (%edx),%edx
  8026e0:	89 10                	mov    %edx,(%eax)
  8026e2:	eb 0a                	jmp    8026ee <alloc_block_FF+0x8c>
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 00                	mov    (%eax),%eax
  8026e9:	a3 38 41 80 00       	mov    %eax,0x804138
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802701:	a1 44 41 80 00       	mov    0x804144,%eax
  802706:	48                   	dec    %eax
  802707:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  80270c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270f:	e9 10 01 00 00       	jmp    802824 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 0c             	mov    0xc(%eax),%eax
  80271a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80271d:	0f 86 c6 00 00 00    	jbe    8027e9 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802723:	a1 48 41 80 00       	mov    0x804148,%eax
  802728:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80272b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80272f:	75 17                	jne    802748 <alloc_block_FF+0xe6>
  802731:	83 ec 04             	sub    $0x4,%esp
  802734:	68 bb 3c 80 00       	push   $0x803cbb
  802739:	68 c2 00 00 00       	push   $0xc2
  80273e:	68 13 3c 80 00       	push   $0x803c13
  802743:	e8 aa dd ff ff       	call   8004f2 <_panic>
  802748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	74 10                	je     802761 <alloc_block_FF+0xff>
  802751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802754:	8b 00                	mov    (%eax),%eax
  802756:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802759:	8b 52 04             	mov    0x4(%edx),%edx
  80275c:	89 50 04             	mov    %edx,0x4(%eax)
  80275f:	eb 0b                	jmp    80276c <alloc_block_FF+0x10a>
  802761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802764:	8b 40 04             	mov    0x4(%eax),%eax
  802767:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80276c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276f:	8b 40 04             	mov    0x4(%eax),%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	74 0f                	je     802785 <alloc_block_FF+0x123>
  802776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802779:	8b 40 04             	mov    0x4(%eax),%eax
  80277c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80277f:	8b 12                	mov    (%edx),%edx
  802781:	89 10                	mov    %edx,(%eax)
  802783:	eb 0a                	jmp    80278f <alloc_block_FF+0x12d>
  802785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802788:	8b 00                	mov    (%eax),%eax
  80278a:	a3 48 41 80 00       	mov    %eax,0x804148
  80278f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802792:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a2:	a1 54 41 80 00       	mov    0x804154,%eax
  8027a7:	48                   	dec    %eax
  8027a8:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	8b 50 08             	mov    0x8(%eax),%edx
  8027b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b6:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8027bf:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c8:	2b 45 08             	sub    0x8(%ebp),%eax
  8027cb:	89 c2                	mov    %eax,%edx
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 50 08             	mov    0x8(%eax),%edx
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	01 c2                	add    %eax,%edx
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8027e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e7:	eb 3b                	jmp    802824 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8027e9:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f5:	74 07                	je     8027fe <alloc_block_FF+0x19c>
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	8b 00                	mov    (%eax),%eax
  8027fc:	eb 05                	jmp    802803 <alloc_block_FF+0x1a1>
  8027fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802803:	a3 40 41 80 00       	mov    %eax,0x804140
  802808:	a1 40 41 80 00       	mov    0x804140,%eax
  80280d:	85 c0                	test   %eax,%eax
  80280f:	0f 85 60 fe ff ff    	jne    802675 <alloc_block_FF+0x13>
  802815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802819:	0f 85 56 fe ff ff    	jne    802675 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  80281f:	b8 00 00 00 00       	mov    $0x0,%eax
  802824:	c9                   	leave  
  802825:	c3                   	ret    

00802826 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
  802829:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  80282c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802833:	a1 38 41 80 00       	mov    0x804138,%eax
  802838:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80283b:	eb 3a                	jmp    802877 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 40 0c             	mov    0xc(%eax),%eax
  802843:	3b 45 08             	cmp    0x8(%ebp),%eax
  802846:	72 27                	jb     80286f <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802848:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80284c:	75 0b                	jne    802859 <alloc_block_BF+0x33>
					best_size= element->size;
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 40 0c             	mov    0xc(%eax),%eax
  802854:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802857:	eb 16                	jmp    80286f <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 50 0c             	mov    0xc(%eax),%edx
  80285f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802862:	39 c2                	cmp    %eax,%edx
  802864:	77 09                	ja     80286f <alloc_block_BF+0x49>
					best_size=element->size;
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 40 0c             	mov    0xc(%eax),%eax
  80286c:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80286f:	a1 40 41 80 00       	mov    0x804140,%eax
  802874:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802877:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287b:	74 07                	je     802884 <alloc_block_BF+0x5e>
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 00                	mov    (%eax),%eax
  802882:	eb 05                	jmp    802889 <alloc_block_BF+0x63>
  802884:	b8 00 00 00 00       	mov    $0x0,%eax
  802889:	a3 40 41 80 00       	mov    %eax,0x804140
  80288e:	a1 40 41 80 00       	mov    0x804140,%eax
  802893:	85 c0                	test   %eax,%eax
  802895:	75 a6                	jne    80283d <alloc_block_BF+0x17>
  802897:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289b:	75 a0                	jne    80283d <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80289d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8028a1:	0f 84 d3 01 00 00    	je     802a7a <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8028a7:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028af:	e9 98 01 00 00       	jmp    802a4c <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  8028b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ba:	0f 86 da 00 00 00    	jbe    80299a <alloc_block_BF+0x174>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 50 0c             	mov    0xc(%eax),%edx
  8028c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c9:	39 c2                	cmp    %eax,%edx
  8028cb:	0f 85 c9 00 00 00    	jne    80299a <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8028d1:	a1 48 41 80 00       	mov    0x804148,%eax
  8028d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8028d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028dd:	75 17                	jne    8028f6 <alloc_block_BF+0xd0>
  8028df:	83 ec 04             	sub    $0x4,%esp
  8028e2:	68 bb 3c 80 00       	push   $0x803cbb
  8028e7:	68 ea 00 00 00       	push   $0xea
  8028ec:	68 13 3c 80 00       	push   $0x803c13
  8028f1:	e8 fc db ff ff       	call   8004f2 <_panic>
  8028f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f9:	8b 00                	mov    (%eax),%eax
  8028fb:	85 c0                	test   %eax,%eax
  8028fd:	74 10                	je     80290f <alloc_block_BF+0xe9>
  8028ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802902:	8b 00                	mov    (%eax),%eax
  802904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802907:	8b 52 04             	mov    0x4(%edx),%edx
  80290a:	89 50 04             	mov    %edx,0x4(%eax)
  80290d:	eb 0b                	jmp    80291a <alloc_block_BF+0xf4>
  80290f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802912:	8b 40 04             	mov    0x4(%eax),%eax
  802915:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80291a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291d:	8b 40 04             	mov    0x4(%eax),%eax
  802920:	85 c0                	test   %eax,%eax
  802922:	74 0f                	je     802933 <alloc_block_BF+0x10d>
  802924:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802927:	8b 40 04             	mov    0x4(%eax),%eax
  80292a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80292d:	8b 12                	mov    (%edx),%edx
  80292f:	89 10                	mov    %edx,(%eax)
  802931:	eb 0a                	jmp    80293d <alloc_block_BF+0x117>
  802933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802936:	8b 00                	mov    (%eax),%eax
  802938:	a3 48 41 80 00       	mov    %eax,0x804148
  80293d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802949:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802950:	a1 54 41 80 00       	mov    0x804154,%eax
  802955:	48                   	dec    %eax
  802956:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 50 08             	mov    0x8(%eax),%edx
  802961:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802964:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802967:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296a:	8b 55 08             	mov    0x8(%ebp),%edx
  80296d:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 40 0c             	mov    0xc(%eax),%eax
  802976:	2b 45 08             	sub    0x8(%ebp),%eax
  802979:	89 c2                	mov    %eax,%edx
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 50 08             	mov    0x8(%eax),%edx
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	01 c2                	add    %eax,%edx
  80298c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298f:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802992:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802995:	e9 e5 00 00 00       	jmp    802a7f <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	8b 50 0c             	mov    0xc(%eax),%edx
  8029a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a3:	39 c2                	cmp    %eax,%edx
  8029a5:	0f 85 99 00 00 00    	jne    802a44 <alloc_block_BF+0x21e>
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b1:	0f 85 8d 00 00 00    	jne    802a44 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  8029bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c1:	75 17                	jne    8029da <alloc_block_BF+0x1b4>
  8029c3:	83 ec 04             	sub    $0x4,%esp
  8029c6:	68 bb 3c 80 00       	push   $0x803cbb
  8029cb:	68 f7 00 00 00       	push   $0xf7
  8029d0:	68 13 3c 80 00       	push   $0x803c13
  8029d5:	e8 18 db ff ff       	call   8004f2 <_panic>
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 00                	mov    (%eax),%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	74 10                	je     8029f3 <alloc_block_BF+0x1cd>
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	8b 00                	mov    (%eax),%eax
  8029e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029eb:	8b 52 04             	mov    0x4(%edx),%edx
  8029ee:	89 50 04             	mov    %edx,0x4(%eax)
  8029f1:	eb 0b                	jmp    8029fe <alloc_block_BF+0x1d8>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 40 04             	mov    0x4(%eax),%eax
  8029f9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 40 04             	mov    0x4(%eax),%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	74 0f                	je     802a17 <alloc_block_BF+0x1f1>
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a11:	8b 12                	mov    (%edx),%edx
  802a13:	89 10                	mov    %edx,(%eax)
  802a15:	eb 0a                	jmp    802a21 <alloc_block_BF+0x1fb>
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	a3 38 41 80 00       	mov    %eax,0x804138
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a34:	a1 44 41 80 00       	mov    0x804144,%eax
  802a39:	48                   	dec    %eax
  802a3a:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  802a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a42:	eb 3b                	jmp    802a7f <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802a44:	a1 40 41 80 00       	mov    0x804140,%eax
  802a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a50:	74 07                	je     802a59 <alloc_block_BF+0x233>
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	eb 05                	jmp    802a5e <alloc_block_BF+0x238>
  802a59:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5e:	a3 40 41 80 00       	mov    %eax,0x804140
  802a63:	a1 40 41 80 00       	mov    0x804140,%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	0f 85 44 fe ff ff    	jne    8028b4 <alloc_block_BF+0x8e>
  802a70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a74:	0f 85 3a fe ff ff    	jne    8028b4 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7f:	c9                   	leave  
  802a80:	c3                   	ret    

00802a81 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a81:	55                   	push   %ebp
  802a82:	89 e5                	mov    %esp,%ebp
  802a84:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802a87:	83 ec 04             	sub    $0x4,%esp
  802a8a:	68 dc 3c 80 00       	push   $0x803cdc
  802a8f:	68 04 01 00 00       	push   $0x104
  802a94:	68 13 3c 80 00       	push   $0x803c13
  802a99:	e8 54 da ff ff       	call   8004f2 <_panic>

00802a9e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802a9e:	55                   	push   %ebp
  802a9f:	89 e5                	mov    %esp,%ebp
  802aa1:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802aa4:	a1 38 41 80 00       	mov    0x804138,%eax
  802aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802aac:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ab1:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802ab4:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	75 68                	jne    802b25 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802abd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac1:	75 17                	jne    802ada <insert_sorted_with_merge_freeList+0x3c>
  802ac3:	83 ec 04             	sub    $0x4,%esp
  802ac6:	68 f0 3b 80 00       	push   $0x803bf0
  802acb:	68 14 01 00 00       	push   $0x114
  802ad0:	68 13 3c 80 00       	push   $0x803c13
  802ad5:	e8 18 da ff ff       	call   8004f2 <_panic>
  802ada:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae3:	89 10                	mov    %edx,(%eax)
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	85 c0                	test   %eax,%eax
  802aec:	74 0d                	je     802afb <insert_sorted_with_merge_freeList+0x5d>
  802aee:	a1 38 41 80 00       	mov    0x804138,%eax
  802af3:	8b 55 08             	mov    0x8(%ebp),%edx
  802af6:	89 50 04             	mov    %edx,0x4(%eax)
  802af9:	eb 08                	jmp    802b03 <insert_sorted_with_merge_freeList+0x65>
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b03:	8b 45 08             	mov    0x8(%ebp),%eax
  802b06:	a3 38 41 80 00       	mov    %eax,0x804138
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b15:	a1 44 41 80 00       	mov    0x804144,%eax
  802b1a:	40                   	inc    %eax
  802b1b:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b20:	e9 d2 06 00 00       	jmp    8031f7 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	8b 50 08             	mov    0x8(%eax),%edx
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	8b 40 08             	mov    0x8(%eax),%eax
  802b31:	39 c2                	cmp    %eax,%edx
  802b33:	0f 83 22 01 00 00    	jae    802c5b <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	8b 50 08             	mov    0x8(%eax),%edx
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	8b 40 0c             	mov    0xc(%eax),%eax
  802b45:	01 c2                	add    %eax,%edx
  802b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4a:	8b 40 08             	mov    0x8(%eax),%eax
  802b4d:	39 c2                	cmp    %eax,%edx
  802b4f:	0f 85 9e 00 00 00    	jne    802bf3 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	8b 50 08             	mov    0x8(%eax),%edx
  802b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5e:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b64:	8b 50 0c             	mov    0xc(%eax),%edx
  802b67:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6d:	01 c2                	add    %eax,%edx
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802b75:	8b 45 08             	mov    0x8(%ebp),%eax
  802b78:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	8b 50 08             	mov    0x8(%eax),%edx
  802b85:	8b 45 08             	mov    0x8(%ebp),%eax
  802b88:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8f:	75 17                	jne    802ba8 <insert_sorted_with_merge_freeList+0x10a>
  802b91:	83 ec 04             	sub    $0x4,%esp
  802b94:	68 f0 3b 80 00       	push   $0x803bf0
  802b99:	68 21 01 00 00       	push   $0x121
  802b9e:	68 13 3c 80 00       	push   $0x803c13
  802ba3:	e8 4a d9 ff ff       	call   8004f2 <_panic>
  802ba8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	89 10                	mov    %edx,(%eax)
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	74 0d                	je     802bc9 <insert_sorted_with_merge_freeList+0x12b>
  802bbc:	a1 48 41 80 00       	mov    0x804148,%eax
  802bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc4:	89 50 04             	mov    %edx,0x4(%eax)
  802bc7:	eb 08                	jmp    802bd1 <insert_sorted_with_merge_freeList+0x133>
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	a3 48 41 80 00       	mov    %eax,0x804148
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be3:	a1 54 41 80 00       	mov    0x804154,%eax
  802be8:	40                   	inc    %eax
  802be9:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802bee:	e9 04 06 00 00       	jmp    8031f7 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802bf3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf7:	75 17                	jne    802c10 <insert_sorted_with_merge_freeList+0x172>
  802bf9:	83 ec 04             	sub    $0x4,%esp
  802bfc:	68 f0 3b 80 00       	push   $0x803bf0
  802c01:	68 26 01 00 00       	push   $0x126
  802c06:	68 13 3c 80 00       	push   $0x803c13
  802c0b:	e8 e2 d8 ff ff       	call   8004f2 <_panic>
  802c10:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	89 10                	mov    %edx,(%eax)
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	8b 00                	mov    (%eax),%eax
  802c20:	85 c0                	test   %eax,%eax
  802c22:	74 0d                	je     802c31 <insert_sorted_with_merge_freeList+0x193>
  802c24:	a1 38 41 80 00       	mov    0x804138,%eax
  802c29:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2c:	89 50 04             	mov    %edx,0x4(%eax)
  802c2f:	eb 08                	jmp    802c39 <insert_sorted_with_merge_freeList+0x19b>
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c39:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4b:	a1 44 41 80 00       	mov    0x804144,%eax
  802c50:	40                   	inc    %eax
  802c51:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802c56:	e9 9c 05 00 00       	jmp    8031f7 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	8b 50 08             	mov    0x8(%eax),%edx
  802c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c64:	8b 40 08             	mov    0x8(%eax),%eax
  802c67:	39 c2                	cmp    %eax,%edx
  802c69:	0f 86 16 01 00 00    	jbe    802d85 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c72:	8b 50 08             	mov    0x8(%eax),%edx
  802c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c78:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7b:	01 c2                	add    %eax,%edx
  802c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c80:	8b 40 08             	mov    0x8(%eax),%eax
  802c83:	39 c2                	cmp    %eax,%edx
  802c85:	0f 85 92 00 00 00    	jne    802d1d <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8e:	8b 50 0c             	mov    0xc(%eax),%edx
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	8b 40 0c             	mov    0xc(%eax),%eax
  802c97:	01 c2                	add    %eax,%edx
  802c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cac:	8b 50 08             	mov    0x8(%eax),%edx
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802cb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb9:	75 17                	jne    802cd2 <insert_sorted_with_merge_freeList+0x234>
  802cbb:	83 ec 04             	sub    $0x4,%esp
  802cbe:	68 f0 3b 80 00       	push   $0x803bf0
  802cc3:	68 31 01 00 00       	push   $0x131
  802cc8:	68 13 3c 80 00       	push   $0x803c13
  802ccd:	e8 20 d8 ff ff       	call   8004f2 <_panic>
  802cd2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdb:	89 10                	mov    %edx,(%eax)
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	8b 00                	mov    (%eax),%eax
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	74 0d                	je     802cf3 <insert_sorted_with_merge_freeList+0x255>
  802ce6:	a1 48 41 80 00       	mov    0x804148,%eax
  802ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cee:	89 50 04             	mov    %edx,0x4(%eax)
  802cf1:	eb 08                	jmp    802cfb <insert_sorted_with_merge_freeList+0x25d>
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	a3 48 41 80 00       	mov    %eax,0x804148
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0d:	a1 54 41 80 00       	mov    0x804154,%eax
  802d12:	40                   	inc    %eax
  802d13:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802d18:	e9 da 04 00 00       	jmp    8031f7 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802d1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d21:	75 17                	jne    802d3a <insert_sorted_with_merge_freeList+0x29c>
  802d23:	83 ec 04             	sub    $0x4,%esp
  802d26:	68 98 3c 80 00       	push   $0x803c98
  802d2b:	68 37 01 00 00       	push   $0x137
  802d30:	68 13 3c 80 00       	push   $0x803c13
  802d35:	e8 b8 d7 ff ff       	call   8004f2 <_panic>
  802d3a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	89 50 04             	mov    %edx,0x4(%eax)
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	8b 40 04             	mov    0x4(%eax),%eax
  802d4c:	85 c0                	test   %eax,%eax
  802d4e:	74 0c                	je     802d5c <insert_sorted_with_merge_freeList+0x2be>
  802d50:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d55:	8b 55 08             	mov    0x8(%ebp),%edx
  802d58:	89 10                	mov    %edx,(%eax)
  802d5a:	eb 08                	jmp    802d64 <insert_sorted_with_merge_freeList+0x2c6>
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	a3 38 41 80 00       	mov    %eax,0x804138
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d75:	a1 44 41 80 00       	mov    0x804144,%eax
  802d7a:	40                   	inc    %eax
  802d7b:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802d80:	e9 72 04 00 00       	jmp    8031f7 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802d85:	a1 38 41 80 00       	mov    0x804138,%eax
  802d8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d8d:	e9 35 04 00 00       	jmp    8031c7 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	8b 00                	mov    (%eax),%eax
  802d97:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 50 08             	mov    0x8(%eax),%edx
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 40 08             	mov    0x8(%eax),%eax
  802da6:	39 c2                	cmp    %eax,%edx
  802da8:	0f 86 11 04 00 00    	jbe    8031bf <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	8b 50 08             	mov    0x8(%eax),%edx
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dba:	01 c2                	add    %eax,%edx
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	8b 40 08             	mov    0x8(%eax),%eax
  802dc2:	39 c2                	cmp    %eax,%edx
  802dc4:	0f 83 8b 00 00 00    	jae    802e55 <insert_sorted_with_merge_freeList+0x3b7>
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	8b 50 08             	mov    0x8(%eax),%edx
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd6:	01 c2                	add    %eax,%edx
  802dd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ddb:	8b 40 08             	mov    0x8(%eax),%eax
  802dde:	39 c2                	cmp    %eax,%edx
  802de0:	73 73                	jae    802e55 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802de2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de6:	74 06                	je     802dee <insert_sorted_with_merge_freeList+0x350>
  802de8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dec:	75 17                	jne    802e05 <insert_sorted_with_merge_freeList+0x367>
  802dee:	83 ec 04             	sub    $0x4,%esp
  802df1:	68 64 3c 80 00       	push   $0x803c64
  802df6:	68 48 01 00 00       	push   $0x148
  802dfb:	68 13 3c 80 00       	push   $0x803c13
  802e00:	e8 ed d6 ff ff       	call   8004f2 <_panic>
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	8b 10                	mov    (%eax),%edx
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	89 10                	mov    %edx,(%eax)
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 00                	mov    (%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 0b                	je     802e23 <insert_sorted_with_merge_freeList+0x385>
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e20:	89 50 04             	mov    %edx,0x4(%eax)
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	8b 55 08             	mov    0x8(%ebp),%edx
  802e29:	89 10                	mov    %edx,(%eax)
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e31:	89 50 04             	mov    %edx,0x4(%eax)
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	75 08                	jne    802e45 <insert_sorted_with_merge_freeList+0x3a7>
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e45:	a1 44 41 80 00       	mov    0x804144,%eax
  802e4a:	40                   	inc    %eax
  802e4b:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802e50:	e9 a2 03 00 00       	jmp    8031f7 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	8b 50 08             	mov    0x8(%eax),%edx
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e61:	01 c2                	add    %eax,%edx
  802e63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e66:	8b 40 08             	mov    0x8(%eax),%eax
  802e69:	39 c2                	cmp    %eax,%edx
  802e6b:	0f 83 ae 00 00 00    	jae    802f1f <insert_sorted_with_merge_freeList+0x481>
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	8b 50 08             	mov    0x8(%eax),%edx
  802e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7a:	8b 48 08             	mov    0x8(%eax),%ecx
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	8b 40 0c             	mov    0xc(%eax),%eax
  802e83:	01 c8                	add    %ecx,%eax
  802e85:	39 c2                	cmp    %eax,%edx
  802e87:	0f 85 92 00 00 00    	jne    802f1f <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 50 0c             	mov    0xc(%eax),%edx
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	8b 40 0c             	mov    0xc(%eax),%eax
  802e99:	01 c2                	add    %eax,%edx
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	8b 50 08             	mov    0x8(%eax),%edx
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802eb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ebb:	75 17                	jne    802ed4 <insert_sorted_with_merge_freeList+0x436>
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	68 f0 3b 80 00       	push   $0x803bf0
  802ec5:	68 51 01 00 00       	push   $0x151
  802eca:	68 13 3c 80 00       	push   $0x803c13
  802ecf:	e8 1e d6 ff ff       	call   8004f2 <_panic>
  802ed4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	89 10                	mov    %edx,(%eax)
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	85 c0                	test   %eax,%eax
  802ee6:	74 0d                	je     802ef5 <insert_sorted_with_merge_freeList+0x457>
  802ee8:	a1 48 41 80 00       	mov    0x804148,%eax
  802eed:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef0:	89 50 04             	mov    %edx,0x4(%eax)
  802ef3:	eb 08                	jmp    802efd <insert_sorted_with_merge_freeList+0x45f>
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	a3 48 41 80 00       	mov    %eax,0x804148
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0f:	a1 54 41 80 00       	mov    0x804154,%eax
  802f14:	40                   	inc    %eax
  802f15:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802f1a:	e9 d8 02 00 00       	jmp    8031f7 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	8b 50 08             	mov    0x8(%eax),%edx
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2b:	01 c2                	add    %eax,%edx
  802f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f30:	8b 40 08             	mov    0x8(%eax),%eax
  802f33:	39 c2                	cmp    %eax,%edx
  802f35:	0f 85 ba 00 00 00    	jne    802ff5 <insert_sorted_with_merge_freeList+0x557>
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	8b 50 08             	mov    0x8(%eax),%edx
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	8b 48 08             	mov    0x8(%eax),%ecx
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4d:	01 c8                	add    %ecx,%eax
  802f4f:	39 c2                	cmp    %eax,%edx
  802f51:	0f 86 9e 00 00 00    	jbe    802ff5 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802f57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	8b 40 0c             	mov    0xc(%eax),%eax
  802f63:	01 c2                	add    %eax,%edx
  802f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f68:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	8b 50 08             	mov    0x8(%eax),%edx
  802f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f74:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	8b 50 08             	mov    0x8(%eax),%edx
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f91:	75 17                	jne    802faa <insert_sorted_with_merge_freeList+0x50c>
  802f93:	83 ec 04             	sub    $0x4,%esp
  802f96:	68 f0 3b 80 00       	push   $0x803bf0
  802f9b:	68 5b 01 00 00       	push   $0x15b
  802fa0:	68 13 3c 80 00       	push   $0x803c13
  802fa5:	e8 48 d5 ff ff       	call   8004f2 <_panic>
  802faa:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb3:	89 10                	mov    %edx,(%eax)
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	74 0d                	je     802fcb <insert_sorted_with_merge_freeList+0x52d>
  802fbe:	a1 48 41 80 00       	mov    0x804148,%eax
  802fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc6:	89 50 04             	mov    %edx,0x4(%eax)
  802fc9:	eb 08                	jmp    802fd3 <insert_sorted_with_merge_freeList+0x535>
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	a3 48 41 80 00       	mov    %eax,0x804148
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe5:	a1 54 41 80 00       	mov    0x804154,%eax
  802fea:	40                   	inc    %eax
  802feb:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802ff0:	e9 02 02 00 00       	jmp    8031f7 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	8b 50 08             	mov    0x8(%eax),%edx
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	8b 40 0c             	mov    0xc(%eax),%eax
  803001:	01 c2                	add    %eax,%edx
  803003:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803006:	8b 40 08             	mov    0x8(%eax),%eax
  803009:	39 c2                	cmp    %eax,%edx
  80300b:	0f 85 ae 01 00 00    	jne    8031bf <insert_sorted_with_merge_freeList+0x721>
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	8b 50 08             	mov    0x8(%eax),%edx
  803017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301a:	8b 48 08             	mov    0x8(%eax),%ecx
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 40 0c             	mov    0xc(%eax),%eax
  803023:	01 c8                	add    %ecx,%eax
  803025:	39 c2                	cmp    %eax,%edx
  803027:	0f 85 92 01 00 00    	jne    8031bf <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 50 0c             	mov    0xc(%eax),%edx
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	8b 40 0c             	mov    0xc(%eax),%eax
  803039:	01 c2                	add    %eax,%edx
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	8b 40 0c             	mov    0xc(%eax),%eax
  803041:	01 c2                	add    %eax,%edx
  803043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803046:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	8b 50 08             	mov    0x8(%eax),%edx
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  80305f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803062:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803069:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306c:	8b 50 08             	mov    0x8(%eax),%edx
  80306f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803072:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803075:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803079:	75 17                	jne    803092 <insert_sorted_with_merge_freeList+0x5f4>
  80307b:	83 ec 04             	sub    $0x4,%esp
  80307e:	68 bb 3c 80 00       	push   $0x803cbb
  803083:	68 63 01 00 00       	push   $0x163
  803088:	68 13 3c 80 00       	push   $0x803c13
  80308d:	e8 60 d4 ff ff       	call   8004f2 <_panic>
  803092:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803095:	8b 00                	mov    (%eax),%eax
  803097:	85 c0                	test   %eax,%eax
  803099:	74 10                	je     8030ab <insert_sorted_with_merge_freeList+0x60d>
  80309b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309e:	8b 00                	mov    (%eax),%eax
  8030a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a3:	8b 52 04             	mov    0x4(%edx),%edx
  8030a6:	89 50 04             	mov    %edx,0x4(%eax)
  8030a9:	eb 0b                	jmp    8030b6 <insert_sorted_with_merge_freeList+0x618>
  8030ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ae:	8b 40 04             	mov    0x4(%eax),%eax
  8030b1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8030b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b9:	8b 40 04             	mov    0x4(%eax),%eax
  8030bc:	85 c0                	test   %eax,%eax
  8030be:	74 0f                	je     8030cf <insert_sorted_with_merge_freeList+0x631>
  8030c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c3:	8b 40 04             	mov    0x4(%eax),%eax
  8030c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c9:	8b 12                	mov    (%edx),%edx
  8030cb:	89 10                	mov    %edx,(%eax)
  8030cd:	eb 0a                	jmp    8030d9 <insert_sorted_with_merge_freeList+0x63b>
  8030cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	a3 38 41 80 00       	mov    %eax,0x804138
  8030d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ec:	a1 44 41 80 00       	mov    0x804144,%eax
  8030f1:	48                   	dec    %eax
  8030f2:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8030f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030fb:	75 17                	jne    803114 <insert_sorted_with_merge_freeList+0x676>
  8030fd:	83 ec 04             	sub    $0x4,%esp
  803100:	68 f0 3b 80 00       	push   $0x803bf0
  803105:	68 64 01 00 00       	push   $0x164
  80310a:	68 13 3c 80 00       	push   $0x803c13
  80310f:	e8 de d3 ff ff       	call   8004f2 <_panic>
  803114:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80311a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311d:	89 10                	mov    %edx,(%eax)
  80311f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803122:	8b 00                	mov    (%eax),%eax
  803124:	85 c0                	test   %eax,%eax
  803126:	74 0d                	je     803135 <insert_sorted_with_merge_freeList+0x697>
  803128:	a1 48 41 80 00       	mov    0x804148,%eax
  80312d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803130:	89 50 04             	mov    %edx,0x4(%eax)
  803133:	eb 08                	jmp    80313d <insert_sorted_with_merge_freeList+0x69f>
  803135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803138:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80313d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803140:	a3 48 41 80 00       	mov    %eax,0x804148
  803145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803148:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314f:	a1 54 41 80 00       	mov    0x804154,%eax
  803154:	40                   	inc    %eax
  803155:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80315a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80315e:	75 17                	jne    803177 <insert_sorted_with_merge_freeList+0x6d9>
  803160:	83 ec 04             	sub    $0x4,%esp
  803163:	68 f0 3b 80 00       	push   $0x803bf0
  803168:	68 65 01 00 00       	push   $0x165
  80316d:	68 13 3c 80 00       	push   $0x803c13
  803172:	e8 7b d3 ff ff       	call   8004f2 <_panic>
  803177:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	89 10                	mov    %edx,(%eax)
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	8b 00                	mov    (%eax),%eax
  803187:	85 c0                	test   %eax,%eax
  803189:	74 0d                	je     803198 <insert_sorted_with_merge_freeList+0x6fa>
  80318b:	a1 48 41 80 00       	mov    0x804148,%eax
  803190:	8b 55 08             	mov    0x8(%ebp),%edx
  803193:	89 50 04             	mov    %edx,0x4(%eax)
  803196:	eb 08                	jmp    8031a0 <insert_sorted_with_merge_freeList+0x702>
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	a3 48 41 80 00       	mov    %eax,0x804148
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b2:	a1 54 41 80 00       	mov    0x804154,%eax
  8031b7:	40                   	inc    %eax
  8031b8:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  8031bd:	eb 38                	jmp    8031f7 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8031bf:	a1 40 41 80 00       	mov    0x804140,%eax
  8031c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031cb:	74 07                	je     8031d4 <insert_sorted_with_merge_freeList+0x736>
  8031cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	eb 05                	jmp    8031d9 <insert_sorted_with_merge_freeList+0x73b>
  8031d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d9:	a3 40 41 80 00       	mov    %eax,0x804140
  8031de:	a1 40 41 80 00       	mov    0x804140,%eax
  8031e3:	85 c0                	test   %eax,%eax
  8031e5:	0f 85 a7 fb ff ff    	jne    802d92 <insert_sorted_with_merge_freeList+0x2f4>
  8031eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ef:	0f 85 9d fb ff ff    	jne    802d92 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8031f5:	eb 00                	jmp    8031f7 <insert_sorted_with_merge_freeList+0x759>
  8031f7:	90                   	nop
  8031f8:	c9                   	leave  
  8031f9:	c3                   	ret    
  8031fa:	66 90                	xchg   %ax,%ax

008031fc <__udivdi3>:
  8031fc:	55                   	push   %ebp
  8031fd:	57                   	push   %edi
  8031fe:	56                   	push   %esi
  8031ff:	53                   	push   %ebx
  803200:	83 ec 1c             	sub    $0x1c,%esp
  803203:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803207:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80320b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80320f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803213:	89 ca                	mov    %ecx,%edx
  803215:	89 f8                	mov    %edi,%eax
  803217:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80321b:	85 f6                	test   %esi,%esi
  80321d:	75 2d                	jne    80324c <__udivdi3+0x50>
  80321f:	39 cf                	cmp    %ecx,%edi
  803221:	77 65                	ja     803288 <__udivdi3+0x8c>
  803223:	89 fd                	mov    %edi,%ebp
  803225:	85 ff                	test   %edi,%edi
  803227:	75 0b                	jne    803234 <__udivdi3+0x38>
  803229:	b8 01 00 00 00       	mov    $0x1,%eax
  80322e:	31 d2                	xor    %edx,%edx
  803230:	f7 f7                	div    %edi
  803232:	89 c5                	mov    %eax,%ebp
  803234:	31 d2                	xor    %edx,%edx
  803236:	89 c8                	mov    %ecx,%eax
  803238:	f7 f5                	div    %ebp
  80323a:	89 c1                	mov    %eax,%ecx
  80323c:	89 d8                	mov    %ebx,%eax
  80323e:	f7 f5                	div    %ebp
  803240:	89 cf                	mov    %ecx,%edi
  803242:	89 fa                	mov    %edi,%edx
  803244:	83 c4 1c             	add    $0x1c,%esp
  803247:	5b                   	pop    %ebx
  803248:	5e                   	pop    %esi
  803249:	5f                   	pop    %edi
  80324a:	5d                   	pop    %ebp
  80324b:	c3                   	ret    
  80324c:	39 ce                	cmp    %ecx,%esi
  80324e:	77 28                	ja     803278 <__udivdi3+0x7c>
  803250:	0f bd fe             	bsr    %esi,%edi
  803253:	83 f7 1f             	xor    $0x1f,%edi
  803256:	75 40                	jne    803298 <__udivdi3+0x9c>
  803258:	39 ce                	cmp    %ecx,%esi
  80325a:	72 0a                	jb     803266 <__udivdi3+0x6a>
  80325c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803260:	0f 87 9e 00 00 00    	ja     803304 <__udivdi3+0x108>
  803266:	b8 01 00 00 00       	mov    $0x1,%eax
  80326b:	89 fa                	mov    %edi,%edx
  80326d:	83 c4 1c             	add    $0x1c,%esp
  803270:	5b                   	pop    %ebx
  803271:	5e                   	pop    %esi
  803272:	5f                   	pop    %edi
  803273:	5d                   	pop    %ebp
  803274:	c3                   	ret    
  803275:	8d 76 00             	lea    0x0(%esi),%esi
  803278:	31 ff                	xor    %edi,%edi
  80327a:	31 c0                	xor    %eax,%eax
  80327c:	89 fa                	mov    %edi,%edx
  80327e:	83 c4 1c             	add    $0x1c,%esp
  803281:	5b                   	pop    %ebx
  803282:	5e                   	pop    %esi
  803283:	5f                   	pop    %edi
  803284:	5d                   	pop    %ebp
  803285:	c3                   	ret    
  803286:	66 90                	xchg   %ax,%ax
  803288:	89 d8                	mov    %ebx,%eax
  80328a:	f7 f7                	div    %edi
  80328c:	31 ff                	xor    %edi,%edi
  80328e:	89 fa                	mov    %edi,%edx
  803290:	83 c4 1c             	add    $0x1c,%esp
  803293:	5b                   	pop    %ebx
  803294:	5e                   	pop    %esi
  803295:	5f                   	pop    %edi
  803296:	5d                   	pop    %ebp
  803297:	c3                   	ret    
  803298:	bd 20 00 00 00       	mov    $0x20,%ebp
  80329d:	89 eb                	mov    %ebp,%ebx
  80329f:	29 fb                	sub    %edi,%ebx
  8032a1:	89 f9                	mov    %edi,%ecx
  8032a3:	d3 e6                	shl    %cl,%esi
  8032a5:	89 c5                	mov    %eax,%ebp
  8032a7:	88 d9                	mov    %bl,%cl
  8032a9:	d3 ed                	shr    %cl,%ebp
  8032ab:	89 e9                	mov    %ebp,%ecx
  8032ad:	09 f1                	or     %esi,%ecx
  8032af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8032b3:	89 f9                	mov    %edi,%ecx
  8032b5:	d3 e0                	shl    %cl,%eax
  8032b7:	89 c5                	mov    %eax,%ebp
  8032b9:	89 d6                	mov    %edx,%esi
  8032bb:	88 d9                	mov    %bl,%cl
  8032bd:	d3 ee                	shr    %cl,%esi
  8032bf:	89 f9                	mov    %edi,%ecx
  8032c1:	d3 e2                	shl    %cl,%edx
  8032c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032c7:	88 d9                	mov    %bl,%cl
  8032c9:	d3 e8                	shr    %cl,%eax
  8032cb:	09 c2                	or     %eax,%edx
  8032cd:	89 d0                	mov    %edx,%eax
  8032cf:	89 f2                	mov    %esi,%edx
  8032d1:	f7 74 24 0c          	divl   0xc(%esp)
  8032d5:	89 d6                	mov    %edx,%esi
  8032d7:	89 c3                	mov    %eax,%ebx
  8032d9:	f7 e5                	mul    %ebp
  8032db:	39 d6                	cmp    %edx,%esi
  8032dd:	72 19                	jb     8032f8 <__udivdi3+0xfc>
  8032df:	74 0b                	je     8032ec <__udivdi3+0xf0>
  8032e1:	89 d8                	mov    %ebx,%eax
  8032e3:	31 ff                	xor    %edi,%edi
  8032e5:	e9 58 ff ff ff       	jmp    803242 <__udivdi3+0x46>
  8032ea:	66 90                	xchg   %ax,%ax
  8032ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032f0:	89 f9                	mov    %edi,%ecx
  8032f2:	d3 e2                	shl    %cl,%edx
  8032f4:	39 c2                	cmp    %eax,%edx
  8032f6:	73 e9                	jae    8032e1 <__udivdi3+0xe5>
  8032f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032fb:	31 ff                	xor    %edi,%edi
  8032fd:	e9 40 ff ff ff       	jmp    803242 <__udivdi3+0x46>
  803302:	66 90                	xchg   %ax,%ax
  803304:	31 c0                	xor    %eax,%eax
  803306:	e9 37 ff ff ff       	jmp    803242 <__udivdi3+0x46>
  80330b:	90                   	nop

0080330c <__umoddi3>:
  80330c:	55                   	push   %ebp
  80330d:	57                   	push   %edi
  80330e:	56                   	push   %esi
  80330f:	53                   	push   %ebx
  803310:	83 ec 1c             	sub    $0x1c,%esp
  803313:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803317:	8b 74 24 34          	mov    0x34(%esp),%esi
  80331b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80331f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803323:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803327:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80332b:	89 f3                	mov    %esi,%ebx
  80332d:	89 fa                	mov    %edi,%edx
  80332f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803333:	89 34 24             	mov    %esi,(%esp)
  803336:	85 c0                	test   %eax,%eax
  803338:	75 1a                	jne    803354 <__umoddi3+0x48>
  80333a:	39 f7                	cmp    %esi,%edi
  80333c:	0f 86 a2 00 00 00    	jbe    8033e4 <__umoddi3+0xd8>
  803342:	89 c8                	mov    %ecx,%eax
  803344:	89 f2                	mov    %esi,%edx
  803346:	f7 f7                	div    %edi
  803348:	89 d0                	mov    %edx,%eax
  80334a:	31 d2                	xor    %edx,%edx
  80334c:	83 c4 1c             	add    $0x1c,%esp
  80334f:	5b                   	pop    %ebx
  803350:	5e                   	pop    %esi
  803351:	5f                   	pop    %edi
  803352:	5d                   	pop    %ebp
  803353:	c3                   	ret    
  803354:	39 f0                	cmp    %esi,%eax
  803356:	0f 87 ac 00 00 00    	ja     803408 <__umoddi3+0xfc>
  80335c:	0f bd e8             	bsr    %eax,%ebp
  80335f:	83 f5 1f             	xor    $0x1f,%ebp
  803362:	0f 84 ac 00 00 00    	je     803414 <__umoddi3+0x108>
  803368:	bf 20 00 00 00       	mov    $0x20,%edi
  80336d:	29 ef                	sub    %ebp,%edi
  80336f:	89 fe                	mov    %edi,%esi
  803371:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803375:	89 e9                	mov    %ebp,%ecx
  803377:	d3 e0                	shl    %cl,%eax
  803379:	89 d7                	mov    %edx,%edi
  80337b:	89 f1                	mov    %esi,%ecx
  80337d:	d3 ef                	shr    %cl,%edi
  80337f:	09 c7                	or     %eax,%edi
  803381:	89 e9                	mov    %ebp,%ecx
  803383:	d3 e2                	shl    %cl,%edx
  803385:	89 14 24             	mov    %edx,(%esp)
  803388:	89 d8                	mov    %ebx,%eax
  80338a:	d3 e0                	shl    %cl,%eax
  80338c:	89 c2                	mov    %eax,%edx
  80338e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803392:	d3 e0                	shl    %cl,%eax
  803394:	89 44 24 04          	mov    %eax,0x4(%esp)
  803398:	8b 44 24 08          	mov    0x8(%esp),%eax
  80339c:	89 f1                	mov    %esi,%ecx
  80339e:	d3 e8                	shr    %cl,%eax
  8033a0:	09 d0                	or     %edx,%eax
  8033a2:	d3 eb                	shr    %cl,%ebx
  8033a4:	89 da                	mov    %ebx,%edx
  8033a6:	f7 f7                	div    %edi
  8033a8:	89 d3                	mov    %edx,%ebx
  8033aa:	f7 24 24             	mull   (%esp)
  8033ad:	89 c6                	mov    %eax,%esi
  8033af:	89 d1                	mov    %edx,%ecx
  8033b1:	39 d3                	cmp    %edx,%ebx
  8033b3:	0f 82 87 00 00 00    	jb     803440 <__umoddi3+0x134>
  8033b9:	0f 84 91 00 00 00    	je     803450 <__umoddi3+0x144>
  8033bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8033c3:	29 f2                	sub    %esi,%edx
  8033c5:	19 cb                	sbb    %ecx,%ebx
  8033c7:	89 d8                	mov    %ebx,%eax
  8033c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8033cd:	d3 e0                	shl    %cl,%eax
  8033cf:	89 e9                	mov    %ebp,%ecx
  8033d1:	d3 ea                	shr    %cl,%edx
  8033d3:	09 d0                	or     %edx,%eax
  8033d5:	89 e9                	mov    %ebp,%ecx
  8033d7:	d3 eb                	shr    %cl,%ebx
  8033d9:	89 da                	mov    %ebx,%edx
  8033db:	83 c4 1c             	add    $0x1c,%esp
  8033de:	5b                   	pop    %ebx
  8033df:	5e                   	pop    %esi
  8033e0:	5f                   	pop    %edi
  8033e1:	5d                   	pop    %ebp
  8033e2:	c3                   	ret    
  8033e3:	90                   	nop
  8033e4:	89 fd                	mov    %edi,%ebp
  8033e6:	85 ff                	test   %edi,%edi
  8033e8:	75 0b                	jne    8033f5 <__umoddi3+0xe9>
  8033ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ef:	31 d2                	xor    %edx,%edx
  8033f1:	f7 f7                	div    %edi
  8033f3:	89 c5                	mov    %eax,%ebp
  8033f5:	89 f0                	mov    %esi,%eax
  8033f7:	31 d2                	xor    %edx,%edx
  8033f9:	f7 f5                	div    %ebp
  8033fb:	89 c8                	mov    %ecx,%eax
  8033fd:	f7 f5                	div    %ebp
  8033ff:	89 d0                	mov    %edx,%eax
  803401:	e9 44 ff ff ff       	jmp    80334a <__umoddi3+0x3e>
  803406:	66 90                	xchg   %ax,%ax
  803408:	89 c8                	mov    %ecx,%eax
  80340a:	89 f2                	mov    %esi,%edx
  80340c:	83 c4 1c             	add    $0x1c,%esp
  80340f:	5b                   	pop    %ebx
  803410:	5e                   	pop    %esi
  803411:	5f                   	pop    %edi
  803412:	5d                   	pop    %ebp
  803413:	c3                   	ret    
  803414:	3b 04 24             	cmp    (%esp),%eax
  803417:	72 06                	jb     80341f <__umoddi3+0x113>
  803419:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80341d:	77 0f                	ja     80342e <__umoddi3+0x122>
  80341f:	89 f2                	mov    %esi,%edx
  803421:	29 f9                	sub    %edi,%ecx
  803423:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803427:	89 14 24             	mov    %edx,(%esp)
  80342a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80342e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803432:	8b 14 24             	mov    (%esp),%edx
  803435:	83 c4 1c             	add    $0x1c,%esp
  803438:	5b                   	pop    %ebx
  803439:	5e                   	pop    %esi
  80343a:	5f                   	pop    %edi
  80343b:	5d                   	pop    %ebp
  80343c:	c3                   	ret    
  80343d:	8d 76 00             	lea    0x0(%esi),%esi
  803440:	2b 04 24             	sub    (%esp),%eax
  803443:	19 fa                	sbb    %edi,%edx
  803445:	89 d1                	mov    %edx,%ecx
  803447:	89 c6                	mov    %eax,%esi
  803449:	e9 71 ff ff ff       	jmp    8033bf <__umoddi3+0xb3>
  80344e:	66 90                	xchg   %ax,%ax
  803450:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803454:	72 ea                	jb     803440 <__umoddi3+0x134>
  803456:	89 d9                	mov    %ebx,%ecx
  803458:	e9 62 ff ff ff       	jmp    8033bf <__umoddi3+0xb3>
