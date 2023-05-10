
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 b8 17 00 00       	call   8017ee <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 90 01 00 00    	sub    $0x190,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 60 80 00       	mov    0x806020,%eax
  800055:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 c8                	add    %ecx,%eax
  800069:	8a 40 04             	mov    0x4(%eax),%al
  80006c:	84 c0                	test   %al,%al
  80006e:	74 06                	je     800076 <_main+0x3e>
			{
				fullWS = 0;
  800070:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800074:	eb 12                	jmp    800088 <_main+0x50>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800076:	ff 45 f0             	incl   -0x10(%ebp)
  800079:	a1 20 60 80 00       	mov    0x806020,%eax
  80007e:	8b 50 74             	mov    0x74(%eax),%edx
  800081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800084:	39 c2                	cmp    %eax,%edx
  800086:	77 c8                	ja     800050 <_main+0x18>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800088:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008c:	74 14                	je     8000a2 <_main+0x6a>
  80008e:	83 ec 04             	sub    $0x4,%esp
  800091:	68 a0 48 80 00       	push   $0x8048a0
  800096:	6a 1a                	push   $0x1a
  800098:	68 bc 48 80 00       	push   $0x8048bc
  80009d:	e8 88 18 00 00       	call   80192a <_panic>





	int Mega = 1024*1024;
  8000a2:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int kilo = 1024;
  8000a9:	c7 45 dc 00 04 00 00 	movl   $0x400,-0x24(%ebp)
	char minByte = 1<<7;
  8000b0:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
	char maxByte = 0x7F;
  8000b4:	c6 45 da 7f          	movb   $0x7f,-0x26(%ebp)
	short minShort = 1<<15 ;
  8000b8:	66 c7 45 d8 00 80    	movw   $0x8000,-0x28(%ebp)
	short maxShort = 0x7FFF;
  8000be:	66 c7 45 d6 ff 7f    	movw   $0x7fff,-0x2a(%ebp)
	int minInt = 1<<31 ;
  8000c4:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000cb:	c7 45 cc ff ff ff 7f 	movl   $0x7fffffff,-0x34(%ebp)
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	e8 2e 2a 00 00       	call   802b0a <malloc>
  8000dc:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 54 2e 00 00       	call   802f38 <sys_calculate_free_frames>
  8000e4:	89 45 c8             	mov    %eax,-0x38(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 68 fe ff ff    	lea    -0x198(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 d8 2e 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800100:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 f6 29 00 00       	call   802b0a <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 d0 48 80 00       	push   $0x8048d0
  80013c:	6a 3a                	push   $0x3a
  80013e:	68 bc 48 80 00       	push   $0x8048bc
  800143:	e8 e2 17 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 8b 2e 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 38 49 80 00       	push   $0x804938
  80015a:	6a 3b                	push   $0x3b
  80015c:	68 bc 48 80 00       	push   $0x8048bc
  800161:	e8 c4 17 00 00       	call   80192a <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 cd 2d 00 00       	call   802f38 <sys_calculate_free_frames>
  80016b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017a:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800180:	89 45 b8             	mov    %eax,-0x48(%ebp)
		byteArr[0] = minByte ;
  800183:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800186:	8a 55 db             	mov    -0x25(%ebp),%dl
  800189:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800191:	01 c2                	add    %eax,%edx
  800193:	8a 45 da             	mov    -0x26(%ebp),%al
  800196:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800198:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80019b:	e8 98 2d 00 00       	call   802f38 <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 68 49 80 00       	push   $0x804968
  8001b1:	6a 42                	push   $0x42
  8001b3:	68 bc 48 80 00       	push   $0x8048bc
  8001b8:	e8 6d 17 00 00       	call   80192a <_panic>
		int var;
		int found = 0;
  8001bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cb:	e9 82 00 00 00       	jmp    800252 <_main+0x21a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d0:	a1 20 60 80 00       	mov    0x806020,%eax
  8001d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001de:	89 d0                	mov    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001fb:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8001fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800206:	39 c2                	cmp    %eax,%edx
  800208:	75 03                	jne    80020d <_main+0x1d5>
				found++;
  80020a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  80020d:	a1 20 60 80 00       	mov    0x806020,%eax
  800212:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021b:	89 d0                	mov    %edx,%eax
  80021d:	01 c0                	add    %eax,%eax
  80021f:	01 d0                	add    %edx,%eax
  800221:	c1 e0 03             	shl    $0x3,%eax
  800224:	01 c8                	add    %ecx,%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80022b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 c1                	mov    %eax,%ecx
  800235:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800238:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800240:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800243:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800248:	39 c1                	cmp    %eax,%ecx
  80024a:	75 03                	jne    80024f <_main+0x217>
				found++;
  80024c:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80024f:	ff 45 ec             	incl   -0x14(%ebp)
  800252:	a1 20 60 80 00       	mov    0x806020,%eax
  800257:	8b 50 74             	mov    0x74(%eax),%edx
  80025a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025d:	39 c2                	cmp    %eax,%edx
  80025f:	0f 87 6b ff ff ff    	ja     8001d0 <_main+0x198>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800265:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800269:	74 14                	je     80027f <_main+0x247>
  80026b:	83 ec 04             	sub    $0x4,%esp
  80026e:	68 ac 49 80 00       	push   $0x8049ac
  800273:	6a 4c                	push   $0x4c
  800275:	68 bc 48 80 00       	push   $0x8048bc
  80027a:	e8 ab 16 00 00       	call   80192a <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 54 2d 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800284:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 72 28 00 00       	call   802b0a <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a1:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	72 16                	jb     8002cd <_main+0x295>
  8002b7:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002bd:	89 c2                	mov    %eax,%edx
  8002bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	76 14                	jbe    8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 d0 48 80 00       	push   $0x8048d0
  8002d5:	6a 51                	push   $0x51
  8002d7:	68 bc 48 80 00       	push   $0x8048bc
  8002dc:	e8 49 16 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 f2 2c 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 38 49 80 00       	push   $0x804938
  8002f3:	6a 52                	push   $0x52
  8002f5:	68 bc 48 80 00       	push   $0x8048bc
  8002fa:	e8 2b 16 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 34 2c 00 00       	call   802f38 <sys_calculate_free_frames>
  800304:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800307:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  80030d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800310:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800318:	d1 e8                	shr    %eax
  80031a:	48                   	dec    %eax
  80031b:	89 45 a0             	mov    %eax,-0x60(%ebp)
		shortArr[0] = minShort;
  80031e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800321:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800324:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800327:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800331:	01 c2                	add    %eax,%edx
  800333:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800337:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80033a:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80033d:	e8 f6 2b 00 00       	call   802f38 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 68 49 80 00       	push   $0x804968
  800353:	6a 59                	push   $0x59
  800355:	68 bc 48 80 00       	push   $0x8048bc
  80035a:	e8 cb 15 00 00       	call   80192a <_panic>
		found = 0;
  80035f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80036d:	e9 86 00 00 00       	jmp    8003f8 <_main+0x3c0>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800372:	a1 20 60 80 00       	mov    0x806020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800390:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
  80039a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80039d:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003a0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	75 03                	jne    8003af <_main+0x377>
				found++;
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003af:	a1 20 60 80 00       	mov    0x806020,%eax
  8003b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 03             	shl    $0x3,%eax
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003cd:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003da:	01 c0                	add    %eax,%eax
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	89 45 90             	mov    %eax,-0x70(%ebp)
  8003e6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ee:	39 c2                	cmp    %eax,%edx
  8003f0:	75 03                	jne    8003f5 <_main+0x3bd>
				found++;
  8003f2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003f5:	ff 45 ec             	incl   -0x14(%ebp)
  8003f8:	a1 20 60 80 00       	mov    0x806020,%eax
  8003fd:	8b 50 74             	mov    0x74(%eax),%edx
  800400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800403:	39 c2                	cmp    %eax,%edx
  800405:	0f 87 67 ff ff ff    	ja     800372 <_main+0x33a>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80040b:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80040f:	74 14                	je     800425 <_main+0x3ed>
  800411:	83 ec 04             	sub    $0x4,%esp
  800414:	68 ac 49 80 00       	push   $0x8049ac
  800419:	6a 62                	push   $0x62
  80041b:	68 bc 48 80 00       	push   $0x8048bc
  800420:	e8 05 15 00 00       	call   80192a <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 ae 2b 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  80042d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	50                   	push   %eax
  800436:	e8 cf 26 00 00       	call   802b0a <malloc>
  80043b:	83 c4 10             	add    $0x10,%esp
  80043e:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800444:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80044a:	89 c2                	mov    %eax,%edx
  80044c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044f:	c1 e0 02             	shl    $0x2,%eax
  800452:	05 00 00 00 80       	add    $0x80000000,%eax
  800457:	39 c2                	cmp    %eax,%edx
  800459:	72 17                	jb     800472 <_main+0x43a>
  80045b:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  800461:	89 c2                	mov    %eax,%edx
  800463:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800466:	c1 e0 02             	shl    $0x2,%eax
  800469:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80046e:	39 c2                	cmp    %eax,%edx
  800470:	76 14                	jbe    800486 <_main+0x44e>
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	68 d0 48 80 00       	push   $0x8048d0
  80047a:	6a 67                	push   $0x67
  80047c:	68 bc 48 80 00       	push   $0x8048bc
  800481:	e8 a4 14 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800486:	e8 4d 2b 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  80048b:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80048e:	74 14                	je     8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 38 49 80 00       	push   $0x804938
  800498:	6a 68                	push   $0x68
  80049a:	68 bc 48 80 00       	push   $0x8048bc
  80049f:	e8 86 14 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a4:	e8 8f 2a 00 00       	call   802f38 <sys_calculate_free_frames>
  8004a9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004ac:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  8004b2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b8:	01 c0                	add    %eax,%eax
  8004ba:	c1 e8 02             	shr    $0x2,%eax
  8004bd:	48                   	dec    %eax
  8004be:	89 45 88             	mov    %eax,-0x78(%ebp)
		intArr[0] = minInt;
  8004c1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004c7:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004c9:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d6:	01 c2                	add    %eax,%edx
  8004d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004db:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004dd:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004e0:	e8 53 2a 00 00       	call   802f38 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	83 f8 02             	cmp    $0x2,%eax
  8004ec:	74 14                	je     800502 <_main+0x4ca>
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	68 68 49 80 00       	push   $0x804968
  8004f6:	6a 6f                	push   $0x6f
  8004f8:	68 bc 48 80 00       	push   $0x8048bc
  8004fd:	e8 28 14 00 00       	call   80192a <_panic>
		found = 0;
  800502:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800509:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800510:	e9 95 00 00 00       	jmp    8005aa <_main+0x572>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800515:	a1 20 60 80 00       	mov    0x806020,%eax
  80051a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800520:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800523:	89 d0                	mov    %edx,%eax
  800525:	01 c0                	add    %eax,%eax
  800527:	01 d0                	add    %edx,%eax
  800529:	c1 e0 03             	shl    $0x3,%eax
  80052c:	01 c8                	add    %ecx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800533:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800536:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053b:	89 c2                	mov    %eax,%edx
  80053d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800540:	89 45 80             	mov    %eax,-0x80(%ebp)
  800543:	8b 45 80             	mov    -0x80(%ebp),%eax
  800546:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	75 03                	jne    800552 <_main+0x51a>
				found++;
  80054f:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800552:	a1 20 60 80 00       	mov    0x806020,%eax
  800557:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	01 c0                	add    %eax,%eax
  800564:	01 d0                	add    %edx,%eax
  800566:	c1 e0 03             	shl    $0x3,%eax
  800569:	01 c8                	add    %ecx,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800573:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800579:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057e:	89 c2                	mov    %eax,%edx
  800580:	8b 45 88             	mov    -0x78(%ebp),%eax
  800583:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80058d:	01 c8                	add    %ecx,%eax
  80058f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800595:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80059b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a0:	39 c2                	cmp    %eax,%edx
  8005a2:	75 03                	jne    8005a7 <_main+0x56f>
				found++;
  8005a4:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005a7:	ff 45 ec             	incl   -0x14(%ebp)
  8005aa:	a1 20 60 80 00       	mov    0x806020,%eax
  8005af:	8b 50 74             	mov    0x74(%eax),%edx
  8005b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005b5:	39 c2                	cmp    %eax,%edx
  8005b7:	0f 87 58 ff ff ff    	ja     800515 <_main+0x4dd>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005bd:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005c1:	74 14                	je     8005d7 <_main+0x59f>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 ac 49 80 00       	push   $0x8049ac
  8005cb:	6a 78                	push   $0x78
  8005cd:	68 bc 48 80 00       	push   $0x8048bc
  8005d2:	e8 53 13 00 00       	call   80192a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d7:	e8 5c 29 00 00       	call   802f38 <sys_calculate_free_frames>
  8005dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005df:	e8 f4 29 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  8005e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8005e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	50                   	push   %eax
  8005f0:	e8 15 25 00 00       	call   802b0a <malloc>
  8005f5:	83 c4 10             	add    $0x10,%esp
  8005f8:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8005fe:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800604:	89 c2                	mov    %eax,%edx
  800606:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800609:	c1 e0 02             	shl    $0x2,%eax
  80060c:	89 c1                	mov    %eax,%ecx
  80060e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800611:	c1 e0 02             	shl    $0x2,%eax
  800614:	01 c8                	add    %ecx,%eax
  800616:	05 00 00 00 80       	add    $0x80000000,%eax
  80061b:	39 c2                	cmp    %eax,%edx
  80061d:	72 21                	jb     800640 <_main+0x608>
  80061f:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800625:	89 c2                	mov    %eax,%edx
  800627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062a:	c1 e0 02             	shl    $0x2,%eax
  80062d:	89 c1                	mov    %eax,%ecx
  80062f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800632:	c1 e0 02             	shl    $0x2,%eax
  800635:	01 c8                	add    %ecx,%eax
  800637:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80063c:	39 c2                	cmp    %eax,%edx
  80063e:	76 14                	jbe    800654 <_main+0x61c>
  800640:	83 ec 04             	sub    $0x4,%esp
  800643:	68 d0 48 80 00       	push   $0x8048d0
  800648:	6a 7e                	push   $0x7e
  80064a:	68 bc 48 80 00       	push   $0x8048bc
  80064f:	e8 d6 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800654:	e8 7f 29 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800659:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80065c:	74 14                	je     800672 <_main+0x63a>
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 38 49 80 00       	push   $0x804938
  800666:	6a 7f                	push   $0x7f
  800668:	68 bc 48 80 00       	push   $0x8048bc
  80066d:	e8 b8 12 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800672:	e8 61 29 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800677:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80067a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80067d:	89 d0                	mov    %edx,%eax
  80067f:	01 c0                	add    %eax,%eax
  800681:	01 d0                	add    %edx,%eax
  800683:	01 c0                	add    %eax,%eax
  800685:	01 d0                	add    %edx,%eax
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	50                   	push   %eax
  80068b:	e8 7a 24 00 00       	call   802b0a <malloc>
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800699:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  80069f:	89 c2                	mov    %eax,%edx
  8006a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a4:	c1 e0 02             	shl    $0x2,%eax
  8006a7:	89 c1                	mov    %eax,%ecx
  8006a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006ac:	c1 e0 03             	shl    $0x3,%eax
  8006af:	01 c8                	add    %ecx,%eax
  8006b1:	05 00 00 00 80       	add    $0x80000000,%eax
  8006b6:	39 c2                	cmp    %eax,%edx
  8006b8:	72 21                	jb     8006db <_main+0x6a3>
  8006ba:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c5:	c1 e0 02             	shl    $0x2,%eax
  8006c8:	89 c1                	mov    %eax,%ecx
  8006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cd:	c1 e0 03             	shl    $0x3,%eax
  8006d0:	01 c8                	add    %ecx,%eax
  8006d2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d7:	39 c2                	cmp    %eax,%edx
  8006d9:	76 17                	jbe    8006f2 <_main+0x6ba>
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	68 d0 48 80 00       	push   $0x8048d0
  8006e3:	68 85 00 00 00       	push   $0x85
  8006e8:	68 bc 48 80 00       	push   $0x8048bc
  8006ed:	e8 38 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f2:	e8 e1 28 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  8006f7:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8006fa:	74 17                	je     800713 <_main+0x6db>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 38 49 80 00       	push   $0x804938
  800704:	68 86 00 00 00       	push   $0x86
  800709:	68 bc 48 80 00       	push   $0x8048bc
  80070e:	e8 17 12 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800713:	e8 20 28 00 00       	call   802f38 <sys_calculate_free_frames>
  800718:	89 45 c0             	mov    %eax,-0x40(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80071b:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  800721:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800727:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80072a:	89 d0                	mov    %edx,%eax
  80072c:	01 c0                	add    %eax,%eax
  80072e:	01 d0                	add    %edx,%eax
  800730:	01 c0                	add    %eax,%eax
  800732:	01 d0                	add    %edx,%eax
  800734:	c1 e8 03             	shr    $0x3,%eax
  800737:	48                   	dec    %eax
  800738:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80073e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800744:	8a 55 db             	mov    -0x25(%ebp),%dl
  800747:	88 10                	mov    %dl,(%eax)
  800749:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  80074f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800752:	66 89 42 02          	mov    %ax,0x2(%edx)
  800756:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80075c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80075f:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800762:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800768:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80076f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800775:	01 c2                	add    %eax,%edx
  800777:	8a 45 da             	mov    -0x26(%ebp),%al
  80077a:	88 02                	mov    %al,(%edx)
  80077c:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800782:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800789:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80078f:	01 c2                	add    %eax,%edx
  800791:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800795:	66 89 42 02          	mov    %ax,0x2(%edx)
  800799:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80079f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a6:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007ac:	01 c2                	add    %eax,%edx
  8007ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007b1:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007b4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8007b7:	e8 7c 27 00 00       	call   802f38 <sys_calculate_free_frames>
  8007bc:	29 c3                	sub    %eax,%ebx
  8007be:	89 d8                	mov    %ebx,%eax
  8007c0:	83 f8 02             	cmp    $0x2,%eax
  8007c3:	74 17                	je     8007dc <_main+0x7a4>
  8007c5:	83 ec 04             	sub    $0x4,%esp
  8007c8:	68 68 49 80 00       	push   $0x804968
  8007cd:	68 8d 00 00 00       	push   $0x8d
  8007d2:	68 bc 48 80 00       	push   $0x8048bc
  8007d7:	e8 4e 11 00 00       	call   80192a <_panic>
		found = 0;
  8007dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ea:	e9 aa 00 00 00       	jmp    800899 <_main+0x861>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007ef:	a1 20 60 80 00       	mov    0x806020,%eax
  8007f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007fd:	89 d0                	mov    %edx,%eax
  8007ff:	01 c0                	add    %eax,%eax
  800801:	01 d0                	add    %edx,%eax
  800803:	c1 e0 03             	shl    $0x3,%eax
  800806:	01 c8                	add    %ecx,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800810:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800816:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081b:	89 c2                	mov    %eax,%edx
  80081d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800823:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800829:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80082f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800834:	39 c2                	cmp    %eax,%edx
  800836:	75 03                	jne    80083b <_main+0x803>
				found++;
  800838:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80083b:	a1 20 60 80 00       	mov    0x806020,%eax
  800840:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800846:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800849:	89 d0                	mov    %edx,%eax
  80084b:	01 c0                	add    %eax,%eax
  80084d:	01 d0                	add    %edx,%eax
  80084f:	c1 e0 03             	shl    $0x3,%eax
  800852:	01 c8                	add    %ecx,%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80085c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800862:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800867:	89 c2                	mov    %eax,%edx
  800869:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80086f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800876:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80087c:	01 c8                	add    %ecx,%eax
  80087e:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800884:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80088a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80088f:	39 c2                	cmp    %eax,%edx
  800891:	75 03                	jne    800896 <_main+0x85e>
				found++;
  800893:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800896:	ff 45 ec             	incl   -0x14(%ebp)
  800899:	a1 20 60 80 00       	mov    0x806020,%eax
  80089e:	8b 50 74             	mov    0x74(%eax),%edx
  8008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	0f 87 43 ff ff ff    	ja     8007ef <_main+0x7b7>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008ac:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 ac 49 80 00       	push   $0x8049ac
  8008ba:	68 96 00 00 00       	push   $0x96
  8008bf:	68 bc 48 80 00       	push   $0x8048bc
  8008c4:	e8 61 10 00 00       	call   80192a <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 6a 26 00 00       	call   802f38 <sys_calculate_free_frames>
  8008ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d1:	e8 02 27 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008dc:	89 c2                	mov    %eax,%edx
  8008de:	01 d2                	add    %edx,%edx
  8008e0:	01 d0                	add    %edx,%eax
  8008e2:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008e5:	83 ec 0c             	sub    $0xc,%esp
  8008e8:	50                   	push   %eax
  8008e9:	e8 1c 22 00 00       	call   802b0a <malloc>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008f7:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  8008fd:	89 c2                	mov    %eax,%edx
  8008ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800902:	c1 e0 02             	shl    $0x2,%eax
  800905:	89 c1                	mov    %eax,%ecx
  800907:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80090a:	c1 e0 04             	shl    $0x4,%eax
  80090d:	01 c8                	add    %ecx,%eax
  80090f:	05 00 00 00 80       	add    $0x80000000,%eax
  800914:	39 c2                	cmp    %eax,%edx
  800916:	72 21                	jb     800939 <_main+0x901>
  800918:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  80091e:	89 c2                	mov    %eax,%edx
  800920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800923:	c1 e0 02             	shl    $0x2,%eax
  800926:	89 c1                	mov    %eax,%ecx
  800928:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80092b:	c1 e0 04             	shl    $0x4,%eax
  80092e:	01 c8                	add    %ecx,%eax
  800930:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800935:	39 c2                	cmp    %eax,%edx
  800937:	76 17                	jbe    800950 <_main+0x918>
  800939:	83 ec 04             	sub    $0x4,%esp
  80093c:	68 d0 48 80 00       	push   $0x8048d0
  800941:	68 9c 00 00 00       	push   $0x9c
  800946:	68 bc 48 80 00       	push   $0x8048bc
  80094b:	e8 da 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800950:	e8 83 26 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800955:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800958:	74 17                	je     800971 <_main+0x939>
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 38 49 80 00       	push   $0x804938
  800962:	68 9d 00 00 00       	push   $0x9d
  800967:	68 bc 48 80 00       	push   $0x8048bc
  80096c:	e8 b9 0f 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800971:	e8 62 26 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800976:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800979:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80097c:	89 d0                	mov    %edx,%eax
  80097e:	01 c0                	add    %eax,%eax
  800980:	01 d0                	add    %edx,%eax
  800982:	01 c0                	add    %eax,%eax
  800984:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800987:	83 ec 0c             	sub    $0xc,%esp
  80098a:	50                   	push   %eax
  80098b:	e8 7a 21 00 00       	call   802b0a <malloc>
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800999:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  80099f:	89 c1                	mov    %eax,%ecx
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	01 c0                	add    %eax,%eax
  8009a8:	01 d0                	add    %edx,%eax
  8009aa:	01 c0                	add    %eax,%eax
  8009ac:	01 d0                	add    %edx,%eax
  8009ae:	89 c2                	mov    %eax,%edx
  8009b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b3:	c1 e0 04             	shl    $0x4,%eax
  8009b6:	01 d0                	add    %edx,%eax
  8009b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8009bd:	39 c1                	cmp    %eax,%ecx
  8009bf:	72 28                	jb     8009e9 <_main+0x9b1>
  8009c1:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8009c7:	89 c1                	mov    %eax,%ecx
  8009c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009cc:	89 d0                	mov    %edx,%eax
  8009ce:	01 c0                	add    %eax,%eax
  8009d0:	01 d0                	add    %edx,%eax
  8009d2:	01 c0                	add    %eax,%eax
  8009d4:	01 d0                	add    %edx,%eax
  8009d6:	89 c2                	mov    %eax,%edx
  8009d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009db:	c1 e0 04             	shl    $0x4,%eax
  8009de:	01 d0                	add    %edx,%eax
  8009e0:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009e5:	39 c1                	cmp    %eax,%ecx
  8009e7:	76 17                	jbe    800a00 <_main+0x9c8>
  8009e9:	83 ec 04             	sub    $0x4,%esp
  8009ec:	68 d0 48 80 00       	push   $0x8048d0
  8009f1:	68 a3 00 00 00       	push   $0xa3
  8009f6:	68 bc 48 80 00       	push   $0x8048bc
  8009fb:	e8 2a 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a00:	e8 d3 25 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800a05:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800a08:	74 17                	je     800a21 <_main+0x9e9>
  800a0a:	83 ec 04             	sub    $0x4,%esp
  800a0d:	68 38 49 80 00       	push   $0x804938
  800a12:	68 a4 00 00 00       	push   $0xa4
  800a17:	68 bc 48 80 00       	push   $0x8048bc
  800a1c:	e8 09 0f 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a21:	e8 12 25 00 00       	call   802f38 <sys_calculate_free_frames>
  800a26:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a2c:	89 d0                	mov    %edx,%eax
  800a2e:	01 c0                	add    %eax,%eax
  800a30:	01 d0                	add    %edx,%eax
  800a32:	01 c0                	add    %eax,%eax
  800a34:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800a37:	48                   	dec    %eax
  800a38:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a3e:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800a44:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		byteArr2[0] = minByte ;
  800a4a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a50:	8a 55 db             	mov    -0x25(%ebp),%dl
  800a53:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a55:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a5b:	89 c2                	mov    %eax,%edx
  800a5d:	c1 ea 1f             	shr    $0x1f,%edx
  800a60:	01 d0                	add    %edx,%eax
  800a62:	d1 f8                	sar    %eax
  800a64:	89 c2                	mov    %eax,%edx
  800a66:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a6c:	01 c2                	add    %eax,%edx
  800a6e:	8a 45 da             	mov    -0x26(%ebp),%al
  800a71:	88 c1                	mov    %al,%cl
  800a73:	c0 e9 07             	shr    $0x7,%cl
  800a76:	01 c8                	add    %ecx,%eax
  800a78:	d0 f8                	sar    %al
  800a7a:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7c:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800a82:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a88:	01 c2                	add    %eax,%edx
  800a8a:	8a 45 da             	mov    -0x26(%ebp),%al
  800a8d:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a8f:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800a92:	e8 a1 24 00 00       	call   802f38 <sys_calculate_free_frames>
  800a97:	29 c3                	sub    %eax,%ebx
  800a99:	89 d8                	mov    %ebx,%eax
  800a9b:	83 f8 05             	cmp    $0x5,%eax
  800a9e:	74 17                	je     800ab7 <_main+0xa7f>
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 68 49 80 00       	push   $0x804968
  800aa8:	68 ac 00 00 00       	push   $0xac
  800aad:	68 bc 48 80 00       	push   $0x8048bc
  800ab2:	e8 73 0e 00 00       	call   80192a <_panic>
		found = 0;
  800ab7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800abe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac5:	e9 02 01 00 00       	jmp    800bcc <_main+0xb94>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800aca:	a1 20 60 80 00       	mov    0x806020,%eax
  800acf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ad8:	89 d0                	mov    %edx,%eax
  800ada:	01 c0                	add    %eax,%eax
  800adc:	01 d0                	add    %edx,%eax
  800ade:	c1 e0 03             	shl    $0x3,%eax
  800ae1:	01 c8                	add    %ecx,%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800aeb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800af1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af6:	89 c2                	mov    %eax,%edx
  800af8:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800afe:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b04:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b0f:	39 c2                	cmp    %eax,%edx
  800b11:	75 03                	jne    800b16 <_main+0xade>
				found++;
  800b13:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b16:	a1 20 60 80 00       	mov    0x806020,%eax
  800b1b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b24:	89 d0                	mov    %edx,%eax
  800b26:	01 c0                	add    %eax,%eax
  800b28:	01 d0                	add    %edx,%eax
  800b2a:	c1 e0 03             	shl    $0x3,%eax
  800b2d:	01 c8                	add    %ecx,%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b37:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b42:	89 c2                	mov    %eax,%edx
  800b44:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b4a:	89 c1                	mov    %eax,%ecx
  800b4c:	c1 e9 1f             	shr    $0x1f,%ecx
  800b4f:	01 c8                	add    %ecx,%eax
  800b51:	d1 f8                	sar    %eax
  800b53:	89 c1                	mov    %eax,%ecx
  800b55:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b5b:	01 c8                	add    %ecx,%eax
  800b5d:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b63:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b6e:	39 c2                	cmp    %eax,%edx
  800b70:	75 03                	jne    800b75 <_main+0xb3d>
				found++;
  800b72:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b75:	a1 20 60 80 00       	mov    0x806020,%eax
  800b7a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b83:	89 d0                	mov    %edx,%eax
  800b85:	01 c0                	add    %eax,%eax
  800b87:	01 d0                	add    %edx,%eax
  800b89:	c1 e0 03             	shl    $0x3,%eax
  800b8c:	01 c8                	add    %ecx,%eax
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800b96:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800b9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba1:	89 c1                	mov    %eax,%ecx
  800ba3:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800ba9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800baf:	01 d0                	add    %edx,%eax
  800bb1:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800bb7:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800bbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc2:	39 c1                	cmp    %eax,%ecx
  800bc4:	75 03                	jne    800bc9 <_main+0xb91>
				found++;
  800bc6:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bc9:	ff 45 ec             	incl   -0x14(%ebp)
  800bcc:	a1 20 60 80 00       	mov    0x806020,%eax
  800bd1:	8b 50 74             	mov    0x74(%eax),%edx
  800bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd7:	39 c2                	cmp    %eax,%edx
  800bd9:	0f 87 eb fe ff ff    	ja     800aca <_main+0xa92>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800bdf:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800be3:	74 17                	je     800bfc <_main+0xbc4>
  800be5:	83 ec 04             	sub    $0x4,%esp
  800be8:	68 ac 49 80 00       	push   $0x8049ac
  800bed:	68 b7 00 00 00       	push   $0xb7
  800bf2:	68 bc 48 80 00       	push   $0x8048bc
  800bf7:	e8 2e 0d 00 00       	call   80192a <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfc:	e8 d7 23 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800c01:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c04:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c07:	89 d0                	mov    %edx,%eax
  800c09:	01 c0                	add    %eax,%eax
  800c0b:	01 d0                	add    %edx,%eax
  800c0d:	01 c0                	add    %eax,%eax
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	01 c0                	add    %eax,%eax
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	50                   	push   %eax
  800c17:	e8 ee 1e 00 00       	call   802b0a <malloc>
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c25:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c2b:	89 c1                	mov    %eax,%ecx
  800c2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c30:	89 d0                	mov    %edx,%eax
  800c32:	01 c0                	add    %eax,%eax
  800c34:	01 d0                	add    %edx,%eax
  800c36:	c1 e0 02             	shl    $0x2,%eax
  800c39:	01 d0                	add    %edx,%eax
  800c3b:	89 c2                	mov    %eax,%edx
  800c3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c40:	c1 e0 04             	shl    $0x4,%eax
  800c43:	01 d0                	add    %edx,%eax
  800c45:	05 00 00 00 80       	add    $0x80000000,%eax
  800c4a:	39 c1                	cmp    %eax,%ecx
  800c4c:	72 29                	jb     800c77 <_main+0xc3f>
  800c4e:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c54:	89 c1                	mov    %eax,%ecx
  800c56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c59:	89 d0                	mov    %edx,%eax
  800c5b:	01 c0                	add    %eax,%eax
  800c5d:	01 d0                	add    %edx,%eax
  800c5f:	c1 e0 02             	shl    $0x2,%eax
  800c62:	01 d0                	add    %edx,%eax
  800c64:	89 c2                	mov    %eax,%edx
  800c66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c69:	c1 e0 04             	shl    $0x4,%eax
  800c6c:	01 d0                	add    %edx,%eax
  800c6e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c73:	39 c1                	cmp    %eax,%ecx
  800c75:	76 17                	jbe    800c8e <_main+0xc56>
  800c77:	83 ec 04             	sub    $0x4,%esp
  800c7a:	68 d0 48 80 00       	push   $0x8048d0
  800c7f:	68 bc 00 00 00       	push   $0xbc
  800c84:	68 bc 48 80 00       	push   $0x8048bc
  800c89:	e8 9c 0c 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c8e:	e8 45 23 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800c93:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800c96:	74 17                	je     800caf <_main+0xc77>
  800c98:	83 ec 04             	sub    $0x4,%esp
  800c9b:	68 38 49 80 00       	push   $0x804938
  800ca0:	68 bd 00 00 00       	push   $0xbd
  800ca5:	68 bc 48 80 00       	push   $0x8048bc
  800caa:	e8 7b 0c 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800caf:	e8 84 22 00 00       	call   802f38 <sys_calculate_free_frames>
  800cb4:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800cb7:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800cbd:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800cc6:	89 d0                	mov    %edx,%eax
  800cc8:	01 c0                	add    %eax,%eax
  800cca:	01 d0                	add    %edx,%eax
  800ccc:	01 c0                	add    %eax,%eax
  800cce:	01 d0                	add    %edx,%eax
  800cd0:	01 c0                	add    %eax,%eax
  800cd2:	d1 e8                	shr    %eax
  800cd4:	48                   	dec    %eax
  800cd5:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
		shortArr2[0] = minShort;
  800cdb:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800ce1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ce4:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800ce7:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800ced:	01 c0                	add    %eax,%eax
  800cef:	89 c2                	mov    %eax,%edx
  800cf1:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cf7:	01 c2                	add    %eax,%edx
  800cf9:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800cfd:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d00:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800d03:	e8 30 22 00 00       	call   802f38 <sys_calculate_free_frames>
  800d08:	29 c3                	sub    %eax,%ebx
  800d0a:	89 d8                	mov    %ebx,%eax
  800d0c:	83 f8 02             	cmp    $0x2,%eax
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 68 49 80 00       	push   $0x804968
  800d19:	68 c4 00 00 00       	push   $0xc4
  800d1e:	68 bc 48 80 00       	push   $0x8048bc
  800d23:	e8 02 0c 00 00       	call   80192a <_panic>
		found = 0;
  800d28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d2f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d36:	e9 a7 00 00 00       	jmp    800de2 <_main+0xdaa>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d3b:	a1 20 60 80 00       	mov    0x806020,%eax
  800d40:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d49:	89 d0                	mov    %edx,%eax
  800d4b:	01 c0                	add    %eax,%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	c1 e0 03             	shl    $0x3,%eax
  800d52:	01 c8                	add    %ecx,%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d5c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d67:	89 c2                	mov    %eax,%edx
  800d69:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d6f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800d75:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800d7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d80:	39 c2                	cmp    %eax,%edx
  800d82:	75 03                	jne    800d87 <_main+0xd4f>
				found++;
  800d84:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d87:	a1 20 60 80 00       	mov    0x806020,%eax
  800d8c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d95:	89 d0                	mov    %edx,%eax
  800d97:	01 c0                	add    %eax,%eax
  800d99:	01 d0                	add    %edx,%eax
  800d9b:	c1 e0 03             	shl    $0x3,%eax
  800d9e:	01 c8                	add    %ecx,%eax
  800da0:	8b 00                	mov    (%eax),%eax
  800da2:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800da8:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db3:	89 c2                	mov    %eax,%edx
  800db5:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800dbb:	01 c0                	add    %eax,%eax
  800dbd:	89 c1                	mov    %eax,%ecx
  800dbf:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dc5:	01 c8                	add    %ecx,%eax
  800dc7:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800dcd:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800dd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dd8:	39 c2                	cmp    %eax,%edx
  800dda:	75 03                	jne    800ddf <_main+0xda7>
				found++;
  800ddc:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ddf:	ff 45 ec             	incl   -0x14(%ebp)
  800de2:	a1 20 60 80 00       	mov    0x806020,%eax
  800de7:	8b 50 74             	mov    0x74(%eax),%edx
  800dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ded:	39 c2                	cmp    %eax,%edx
  800def:	0f 87 46 ff ff ff    	ja     800d3b <_main+0xd03>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800df5:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800df9:	74 17                	je     800e12 <_main+0xdda>
  800dfb:	83 ec 04             	sub    $0x4,%esp
  800dfe:	68 ac 49 80 00       	push   $0x8049ac
  800e03:	68 cd 00 00 00       	push   $0xcd
  800e08:	68 bc 48 80 00       	push   $0x8048bc
  800e0d:	e8 18 0b 00 00       	call   80192a <_panic>
	}

	{
		//Free 1st 2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800e12:	e8 21 21 00 00       	call   802f38 <sys_calculate_free_frames>
  800e17:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e1d:	e8 b6 21 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800e22:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[0]);
  800e28:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	e8 4e 1d 00 00       	call   802b85 <free>
  800e37:	83 c4 10             	add    $0x10,%esp

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e3a:	e8 99 21 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800e3f:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800e45:	74 17                	je     800e5e <_main+0xe26>
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 cc 49 80 00       	push   $0x8049cc
  800e4f:	68 d6 00 00 00       	push   $0xd6
  800e54:	68 bc 48 80 00       	push   $0x8048bc
  800e59:	e8 cc 0a 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e5e:	e8 d5 20 00 00       	call   802f38 <sys_calculate_free_frames>
  800e63:	89 c2                	mov    %eax,%edx
  800e65:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e6b:	29 c2                	sub    %eax,%edx
  800e6d:	89 d0                	mov    %edx,%eax
  800e6f:	83 f8 02             	cmp    $0x2,%eax
  800e72:	74 17                	je     800e8b <_main+0xe53>
  800e74:	83 ec 04             	sub    $0x4,%esp
  800e77:	68 08 4a 80 00       	push   $0x804a08
  800e7c:	68 d7 00 00 00       	push   $0xd7
  800e81:	68 bc 48 80 00       	push   $0x8048bc
  800e86:	e8 9f 0a 00 00       	call   80192a <_panic>
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800e8b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800e92:	e9 c2 00 00 00       	jmp    800f59 <_main+0xf21>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  800e97:	a1 20 60 80 00       	mov    0x806020,%eax
  800e9c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ea2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ea5:	89 d0                	mov    %edx,%eax
  800ea7:	01 c0                	add    %eax,%eax
  800ea9:	01 d0                	add    %edx,%eax
  800eab:	c1 e0 03             	shl    $0x3,%eax
  800eae:	01 c8                	add    %ecx,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800eb8:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800ebe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ec3:	89 c2                	mov    %eax,%edx
  800ec5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ec8:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  800ece:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800ed4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ed9:	39 c2                	cmp    %eax,%edx
  800edb:	75 17                	jne    800ef4 <_main+0xebc>
				panic("free: page is not removed from WS");
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	68 54 4a 80 00       	push   $0x804a54
  800ee5:	68 dc 00 00 00       	push   $0xdc
  800eea:	68 bc 48 80 00       	push   $0x8048bc
  800eef:	e8 36 0a 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800ef4:	a1 20 60 80 00       	mov    0x806020,%eax
  800ef9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800eff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f02:	89 d0                	mov    %edx,%eax
  800f04:	01 c0                	add    %eax,%eax
  800f06:	01 d0                	add    %edx,%eax
  800f08:	c1 e0 03             	shl    $0x3,%eax
  800f0b:	01 c8                	add    %ecx,%eax
  800f0d:	8b 00                	mov    (%eax),%eax
  800f0f:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800f15:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f20:	89 c1                	mov    %eax,%ecx
  800f22:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800f25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
  800f30:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800f36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f3b:	39 c1                	cmp    %eax,%ecx
  800f3d:	75 17                	jne    800f56 <_main+0xf1e>
				panic("free: page is not removed from WS");
  800f3f:	83 ec 04             	sub    $0x4,%esp
  800f42:	68 54 4a 80 00       	push   $0x804a54
  800f47:	68 de 00 00 00       	push   $0xde
  800f4c:	68 bc 48 80 00       	push   $0x8048bc
  800f51:	e8 d4 09 00 00       	call   80192a <_panic>
		free(ptr_allocations[0]);

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800f56:	ff 45 e4             	incl   -0x1c(%ebp)
  800f59:	a1 20 60 80 00       	mov    0x806020,%eax
  800f5e:	8b 50 74             	mov    0x74(%eax),%edx
  800f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f64:	39 c2                	cmp    %eax,%edx
  800f66:	0f 87 2b ff ff ff    	ja     800e97 <_main+0xe5f>
				panic("free: page is not removed from WS");
		}


		//Free 2nd 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800f6c:	e8 c7 1f 00 00       	call   802f38 <sys_calculate_free_frames>
  800f71:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f77:	e8 5c 20 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800f7c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[1]);
  800f82:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	50                   	push   %eax
  800f8c:	e8 f4 1b 00 00       	call   802b85 <free>
  800f91:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f94:	e8 3f 20 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  800f99:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800f9f:	74 17                	je     800fb8 <_main+0xf80>
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	68 cc 49 80 00       	push   $0x8049cc
  800fa9:	68 e6 00 00 00       	push   $0xe6
  800fae:	68 bc 48 80 00       	push   $0x8048bc
  800fb3:	e8 72 09 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fb8:	e8 7b 1f 00 00       	call   802f38 <sys_calculate_free_frames>
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800fc5:	29 c2                	sub    %eax,%edx
  800fc7:	89 d0                	mov    %edx,%eax
  800fc9:	83 f8 03             	cmp    $0x3,%eax
  800fcc:	74 17                	je     800fe5 <_main+0xfad>
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	68 08 4a 80 00       	push   $0x804a08
  800fd6:	68 e7 00 00 00       	push   $0xe7
  800fdb:	68 bc 48 80 00       	push   $0x8048bc
  800fe0:	e8 45 09 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800fe5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800fec:	e9 c6 00 00 00       	jmp    8010b7 <_main+0x107f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800ff1:	a1 20 60 80 00       	mov    0x806020,%eax
  800ff6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ffc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fff:	89 d0                	mov    %edx,%eax
  801001:	01 c0                	add    %eax,%eax
  801003:	01 d0                	add    %edx,%eax
  801005:	c1 e0 03             	shl    $0x3,%eax
  801008:	01 c8                	add    %ecx,%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
  801012:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801018:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80101d:	89 c2                	mov    %eax,%edx
  80101f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801022:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801028:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80102e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801033:	39 c2                	cmp    %eax,%edx
  801035:	75 17                	jne    80104e <_main+0x1016>
				panic("free: page is not removed from WS");
  801037:	83 ec 04             	sub    $0x4,%esp
  80103a:	68 54 4a 80 00       	push   $0x804a54
  80103f:	68 eb 00 00 00       	push   $0xeb
  801044:	68 bc 48 80 00       	push   $0x8048bc
  801049:	e8 dc 08 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  80104e:	a1 20 60 80 00       	mov    0x806020,%eax
  801053:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801059:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80105c:	89 d0                	mov    %edx,%eax
  80105e:	01 c0                	add    %eax,%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	c1 e0 03             	shl    $0x3,%eax
  801065:	01 c8                	add    %ecx,%eax
  801067:	8b 00                	mov    (%eax),%eax
  801069:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  80106f:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  801075:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80107f:	01 c0                	add    %eax,%eax
  801081:	89 c1                	mov    %eax,%ecx
  801083:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801086:	01 c8                	add    %ecx,%eax
  801088:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  80108e:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  801094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801099:	39 c2                	cmp    %eax,%edx
  80109b:	75 17                	jne    8010b4 <_main+0x107c>
				panic("free: page is not removed from WS");
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	68 54 4a 80 00       	push   $0x804a54
  8010a5:	68 ed 00 00 00       	push   $0xed
  8010aa:	68 bc 48 80 00       	push   $0x8048bc
  8010af:	e8 76 08 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[1]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8010b4:	ff 45 e4             	incl   -0x1c(%ebp)
  8010b7:	a1 20 60 80 00       	mov    0x806020,%eax
  8010bc:	8b 50 74             	mov    0x74(%eax),%edx
  8010bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010c2:	39 c2                	cmp    %eax,%edx
  8010c4:	0f 87 27 ff ff ff    	ja     800ff1 <_main+0xfb9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 6 MB
		freeFrames = sys_calculate_free_frames() ;
  8010ca:	e8 69 1e 00 00       	call   802f38 <sys_calculate_free_frames>
  8010cf:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010d5:	e8 fe 1e 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  8010da:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[6]);
  8010e0:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	50                   	push   %eax
  8010ea:	e8 96 1a 00 00       	call   802b85 <free>
  8010ef:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8010f2:	e8 e1 1e 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  8010f7:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8010fd:	74 17                	je     801116 <_main+0x10de>
  8010ff:	83 ec 04             	sub    $0x4,%esp
  801102:	68 cc 49 80 00       	push   $0x8049cc
  801107:	68 f4 00 00 00       	push   $0xf4
  80110c:	68 bc 48 80 00       	push   $0x8048bc
  801111:	e8 14 08 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801116:	e8 1d 1e 00 00       	call   802f38 <sys_calculate_free_frames>
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801123:	29 c2                	sub    %eax,%edx
  801125:	89 d0                	mov    %edx,%eax
  801127:	83 f8 04             	cmp    $0x4,%eax
  80112a:	74 17                	je     801143 <_main+0x110b>
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	68 08 4a 80 00       	push   $0x804a08
  801134:	68 f5 00 00 00       	push   $0xf5
  801139:	68 bc 48 80 00       	push   $0x8048bc
  80113e:	e8 e7 07 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801143:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80114a:	e9 3e 01 00 00       	jmp    80128d <_main+0x1255>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  80114f:	a1 20 60 80 00       	mov    0x806020,%eax
  801154:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80115a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80115d:	89 d0                	mov    %edx,%eax
  80115f:	01 c0                	add    %eax,%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	c1 e0 03             	shl    $0x3,%eax
  801166:	01 c8                	add    %ecx,%eax
  801168:	8b 00                	mov    (%eax),%eax
  80116a:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801170:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  801176:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801183:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
  801189:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  80118f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801194:	39 c2                	cmp    %eax,%edx
  801196:	75 17                	jne    8011af <_main+0x1177>
				panic("free: page is not removed from WS");
  801198:	83 ec 04             	sub    $0x4,%esp
  80119b:	68 54 4a 80 00       	push   $0x804a54
  8011a0:	68 f9 00 00 00       	push   $0xf9
  8011a5:	68 bc 48 80 00       	push   $0x8048bc
  8011aa:	e8 7b 07 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  8011af:	a1 20 60 80 00       	mov    0x806020,%eax
  8011b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8011ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011bd:	89 d0                	mov    %edx,%eax
  8011bf:	01 c0                	add    %eax,%eax
  8011c1:	01 d0                	add    %edx,%eax
  8011c3:	c1 e0 03             	shl    $0x3,%eax
  8011c6:	01 c8                	add    %ecx,%eax
  8011c8:	8b 00                	mov    (%eax),%eax
  8011ca:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  8011d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8011e3:	89 c1                	mov    %eax,%ecx
  8011e5:	c1 e9 1f             	shr    $0x1f,%ecx
  8011e8:	01 c8                	add    %ecx,%eax
  8011ea:	d1 f8                	sar    %eax
  8011ec:	89 c1                	mov    %eax,%ecx
  8011ee:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8011f4:	01 c8                	add    %ecx,%eax
  8011f6:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  8011fc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801202:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801207:	39 c2                	cmp    %eax,%edx
  801209:	75 17                	jne    801222 <_main+0x11ea>
				panic("free: page is not removed from WS");
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	68 54 4a 80 00       	push   $0x804a54
  801213:	68 fb 00 00 00       	push   $0xfb
  801218:	68 bc 48 80 00       	push   $0x8048bc
  80121d:	e8 08 07 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  801222:	a1 20 60 80 00       	mov    0x806020,%eax
  801227:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80122d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801230:	89 d0                	mov    %edx,%eax
  801232:	01 c0                	add    %eax,%eax
  801234:	01 d0                	add    %edx,%eax
  801236:	c1 e0 03             	shl    $0x3,%eax
  801239:	01 c8                	add    %ecx,%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  801243:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  801249:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80124e:	89 c1                	mov    %eax,%ecx
  801250:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  801256:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
  801264:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  80126a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80126f:	39 c1                	cmp    %eax,%ecx
  801271:	75 17                	jne    80128a <_main+0x1252>
				panic("free: page is not removed from WS");
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	68 54 4a 80 00       	push   $0x804a54
  80127b:	68 fd 00 00 00       	push   $0xfd
  801280:	68 bc 48 80 00       	push   $0x8048bc
  801285:	e8 a0 06 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[6]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80128a:	ff 45 e4             	incl   -0x1c(%ebp)
  80128d:	a1 20 60 80 00       	mov    0x806020,%eax
  801292:	8b 50 74             	mov    0x74(%eax),%edx
  801295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801298:	39 c2                	cmp    %eax,%edx
  80129a:	0f 87 af fe ff ff    	ja     80114f <_main+0x1117>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 7 KB
		freeFrames = sys_calculate_free_frames() ;
  8012a0:	e8 93 1c 00 00       	call   802f38 <sys_calculate_free_frames>
  8012a5:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012ab:	e8 28 1d 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  8012b0:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[4]);
  8012b6:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8012bc:	83 ec 0c             	sub    $0xc,%esp
  8012bf:	50                   	push   %eax
  8012c0:	e8 c0 18 00 00       	call   802b85 <free>
  8012c5:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8012c8:	e8 0b 1d 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  8012cd:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8012d3:	74 17                	je     8012ec <_main+0x12b4>
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	68 cc 49 80 00       	push   $0x8049cc
  8012dd:	68 04 01 00 00       	push   $0x104
  8012e2:	68 bc 48 80 00       	push   $0x8048bc
  8012e7:	e8 3e 06 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8012ec:	e8 47 1c 00 00       	call   802f38 <sys_calculate_free_frames>
  8012f1:	89 c2                	mov    %eax,%edx
  8012f3:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8012f9:	29 c2                	sub    %eax,%edx
  8012fb:	89 d0                	mov    %edx,%eax
  8012fd:	83 f8 02             	cmp    $0x2,%eax
  801300:	74 17                	je     801319 <_main+0x12e1>
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	68 08 4a 80 00       	push   $0x804a08
  80130a:	68 05 01 00 00       	push   $0x105
  80130f:	68 bc 48 80 00       	push   $0x8048bc
  801314:	e8 11 06 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801319:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801320:	e9 d2 00 00 00       	jmp    8013f7 <_main+0x13bf>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  801325:	a1 20 60 80 00       	mov    0x806020,%eax
  80132a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801333:	89 d0                	mov    %edx,%eax
  801335:	01 c0                	add    %eax,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	c1 e0 03             	shl    $0x3,%eax
  80133c:	01 c8                	add    %ecx,%eax
  80133e:	8b 00                	mov    (%eax),%eax
  801340:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  801346:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80134c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801351:	89 c2                	mov    %eax,%edx
  801353:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801359:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  80135f:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  801365:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136a:	39 c2                	cmp    %eax,%edx
  80136c:	75 17                	jne    801385 <_main+0x134d>
				panic("free: page is not removed from WS");
  80136e:	83 ec 04             	sub    $0x4,%esp
  801371:	68 54 4a 80 00       	push   $0x804a54
  801376:	68 09 01 00 00       	push   $0x109
  80137b:	68 bc 48 80 00       	push   $0x8048bc
  801380:	e8 a5 05 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  801385:	a1 20 60 80 00       	mov    0x806020,%eax
  80138a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801390:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	01 c0                	add    %eax,%eax
  801397:	01 d0                	add    %edx,%eax
  801399:	c1 e0 03             	shl    $0x3,%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  8013a6:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8013ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b1:	89 c2                	mov    %eax,%edx
  8013b3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8013b9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8013c0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8013c6:	01 c8                	add    %ecx,%eax
  8013c8:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  8013ce:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8013d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d9:	39 c2                	cmp    %eax,%edx
  8013db:	75 17                	jne    8013f4 <_main+0x13bc>
				panic("free: page is not removed from WS");
  8013dd:	83 ec 04             	sub    $0x4,%esp
  8013e0:	68 54 4a 80 00       	push   $0x804a54
  8013e5:	68 0b 01 00 00       	push   $0x10b
  8013ea:	68 bc 48 80 00       	push   $0x8048bc
  8013ef:	e8 36 05 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[4]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8013f4:	ff 45 e4             	incl   -0x1c(%ebp)
  8013f7:	a1 20 60 80 00       	mov    0x806020,%eax
  8013fc:	8b 50 74             	mov    0x74(%eax),%edx
  8013ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801402:	39 c2                	cmp    %eax,%edx
  801404:	0f 87 1b ff ff ff    	ja     801325 <_main+0x12ed>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80140a:	e8 29 1b 00 00       	call   802f38 <sys_calculate_free_frames>
  80140f:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801415:	e8 be 1b 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  80141a:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[5]);
  801420:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  801426:	83 ec 0c             	sub    $0xc,%esp
  801429:	50                   	push   %eax
  80142a:	e8 56 17 00 00       	call   802b85 <free>
  80142f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801432:	e8 a1 1b 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  801437:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  80143d:	74 17                	je     801456 <_main+0x141e>
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	68 cc 49 80 00       	push   $0x8049cc
  801447:	68 12 01 00 00       	push   $0x112
  80144c:	68 bc 48 80 00       	push   $0x8048bc
  801451:	e8 d4 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801456:	e8 dd 1a 00 00       	call   802f38 <sys_calculate_free_frames>
  80145b:	89 c2                	mov    %eax,%edx
  80145d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801463:	39 c2                	cmp    %eax,%edx
  801465:	74 17                	je     80147e <_main+0x1446>
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	68 08 4a 80 00       	push   $0x804a08
  80146f:	68 13 01 00 00       	push   $0x113
  801474:	68 bc 48 80 00       	push   $0x8048bc
  801479:	e8 ac 04 00 00       	call   80192a <_panic>

		//Free 1st 2 KB
		freeFrames = sys_calculate_free_frames() ;
  80147e:	e8 b5 1a 00 00       	call   802f38 <sys_calculate_free_frames>
  801483:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801489:	e8 4a 1b 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  80148e:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[2]);
  801494:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80149a:	83 ec 0c             	sub    $0xc,%esp
  80149d:	50                   	push   %eax
  80149e:	e8 e2 16 00 00       	call   802b85 <free>
  8014a3:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8014a6:	e8 2d 1b 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  8014ab:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8014b1:	74 17                	je     8014ca <_main+0x1492>
  8014b3:	83 ec 04             	sub    $0x4,%esp
  8014b6:	68 cc 49 80 00       	push   $0x8049cc
  8014bb:	68 19 01 00 00       	push   $0x119
  8014c0:	68 bc 48 80 00       	push   $0x8048bc
  8014c5:	e8 60 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014ca:	e8 69 1a 00 00       	call   802f38 <sys_calculate_free_frames>
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8014d7:	29 c2                	sub    %eax,%edx
  8014d9:	89 d0                	mov    %edx,%eax
  8014db:	83 f8 02             	cmp    $0x2,%eax
  8014de:	74 17                	je     8014f7 <_main+0x14bf>
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	68 08 4a 80 00       	push   $0x804a08
  8014e8:	68 1a 01 00 00       	push   $0x11a
  8014ed:	68 bc 48 80 00       	push   $0x8048bc
  8014f2:	e8 33 04 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8014f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8014fe:	e9 c9 00 00 00       	jmp    8015cc <_main+0x1594>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  801503:	a1 20 60 80 00       	mov    0x806020,%eax
  801508:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80150e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801511:	89 d0                	mov    %edx,%eax
  801513:	01 c0                	add    %eax,%eax
  801515:	01 d0                	add    %edx,%eax
  801517:	c1 e0 03             	shl    $0x3,%eax
  80151a:	01 c8                	add    %ecx,%eax
  80151c:	8b 00                	mov    (%eax),%eax
  80151e:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  801524:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  80152a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80152f:	89 c2                	mov    %eax,%edx
  801531:	8b 45 8c             	mov    -0x74(%ebp),%eax
  801534:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  80153a:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  801540:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801545:	39 c2                	cmp    %eax,%edx
  801547:	75 17                	jne    801560 <_main+0x1528>
				panic("free: page is not removed from WS");
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	68 54 4a 80 00       	push   $0x804a54
  801551:	68 1e 01 00 00       	push   $0x11e
  801556:	68 bc 48 80 00       	push   $0x8048bc
  80155b:	e8 ca 03 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  801560:	a1 20 60 80 00       	mov    0x806020,%eax
  801565:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80156b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80156e:	89 d0                	mov    %edx,%eax
  801570:	01 c0                	add    %eax,%eax
  801572:	01 d0                	add    %edx,%eax
  801574:	c1 e0 03             	shl    $0x3,%eax
  801577:	01 c8                	add    %ecx,%eax
  801579:	8b 00                	mov    (%eax),%eax
  80157b:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  801581:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801587:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80158c:	89 c2                	mov    %eax,%edx
  80158e:	8b 45 88             	mov    -0x78(%ebp),%eax
  801591:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801598:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80159b:	01 c8                	add    %ecx,%eax
  80159d:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
  8015a3:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8015a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ae:	39 c2                	cmp    %eax,%edx
  8015b0:	75 17                	jne    8015c9 <_main+0x1591>
				panic("free: page is not removed from WS");
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	68 54 4a 80 00       	push   $0x804a54
  8015ba:	68 20 01 00 00       	push   $0x120
  8015bf:	68 bc 48 80 00       	push   $0x8048bc
  8015c4:	e8 61 03 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[2]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8015c9:	ff 45 e4             	incl   -0x1c(%ebp)
  8015cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8015d1:	8b 50 74             	mov    0x74(%eax),%edx
  8015d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d7:	39 c2                	cmp    %eax,%edx
  8015d9:	0f 87 24 ff ff ff    	ja     801503 <_main+0x14cb>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 2nd 2 KB
		freeFrames = sys_calculate_free_frames() ;
  8015df:	e8 54 19 00 00       	call   802f38 <sys_calculate_free_frames>
  8015e4:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8015ea:	e8 e9 19 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  8015ef:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[3]);
  8015f5:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  8015fb:	83 ec 0c             	sub    $0xc,%esp
  8015fe:	50                   	push   %eax
  8015ff:	e8 81 15 00 00       	call   802b85 <free>
  801604:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801607:	e8 cc 19 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  80160c:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801612:	74 17                	je     80162b <_main+0x15f3>
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 cc 49 80 00       	push   $0x8049cc
  80161c:	68 27 01 00 00       	push   $0x127
  801621:	68 bc 48 80 00       	push   $0x8048bc
  801626:	e8 ff 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80162b:	e8 08 19 00 00       	call   802f38 <sys_calculate_free_frames>
  801630:	89 c2                	mov    %eax,%edx
  801632:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801638:	39 c2                	cmp    %eax,%edx
  80163a:	74 17                	je     801653 <_main+0x161b>
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 08 4a 80 00       	push   $0x804a08
  801644:	68 28 01 00 00       	push   $0x128
  801649:	68 bc 48 80 00       	push   $0x8048bc
  80164e:	e8 d7 02 00 00       	call   80192a <_panic>


		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  801653:	e8 e0 18 00 00       	call   802f38 <sys_calculate_free_frames>
  801658:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80165e:	e8 75 19 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  801663:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[7]);
  801669:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	50                   	push   %eax
  801673:	e8 0d 15 00 00       	call   802b85 <free>
  801678:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80167b:	e8 58 19 00 00       	call   802fd8 <sys_pf_calculate_allocated_pages>
  801680:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801686:	74 17                	je     80169f <_main+0x1667>
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	68 cc 49 80 00       	push   $0x8049cc
  801690:	68 2f 01 00 00       	push   $0x12f
  801695:	68 bc 48 80 00       	push   $0x8048bc
  80169a:	e8 8b 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80169f:	e8 94 18 00 00       	call   802f38 <sys_calculate_free_frames>
  8016a4:	89 c2                	mov    %eax,%edx
  8016a6:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8016ac:	29 c2                	sub    %eax,%edx
  8016ae:	89 d0                	mov    %edx,%eax
  8016b0:	83 f8 03             	cmp    $0x3,%eax
  8016b3:	74 17                	je     8016cc <_main+0x1694>
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 08 4a 80 00       	push   $0x804a08
  8016bd:	68 30 01 00 00       	push   $0x130
  8016c2:	68 bc 48 80 00       	push   $0x8048bc
  8016c7:	e8 5e 02 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8016cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016d3:	e9 c6 00 00 00       	jmp    80179e <_main+0x1766>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  8016d8:	a1 20 60 80 00       	mov    0x806020,%eax
  8016dd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8016e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016e6:	89 d0                	mov    %edx,%eax
  8016e8:	01 c0                	add    %eax,%eax
  8016ea:	01 d0                	add    %edx,%eax
  8016ec:	c1 e0 03             	shl    $0x3,%eax
  8016ef:	01 c8                	add    %ecx,%eax
  8016f1:	8b 00                	mov    (%eax),%eax
  8016f3:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
  8016f9:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  8016ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801704:	89 c2                	mov    %eax,%edx
  801706:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801709:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
  80170f:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  801715:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80171a:	39 c2                	cmp    %eax,%edx
  80171c:	75 17                	jne    801735 <_main+0x16fd>
				panic("free: page is not removed from WS");
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	68 54 4a 80 00       	push   $0x804a54
  801726:	68 34 01 00 00       	push   $0x134
  80172b:	68 bc 48 80 00       	push   $0x8048bc
  801730:	e8 f5 01 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  801735:	a1 20 60 80 00       	mov    0x806020,%eax
  80173a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801740:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801743:	89 d0                	mov    %edx,%eax
  801745:	01 c0                	add    %eax,%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	c1 e0 03             	shl    $0x3,%eax
  80174c:	01 c8                	add    %ecx,%eax
  80174e:	8b 00                	mov    (%eax),%eax
  801750:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
  801756:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  80175c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801761:	89 c2                	mov    %eax,%edx
  801763:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801766:	01 c0                	add    %eax,%eax
  801768:	89 c1                	mov    %eax,%ecx
  80176a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80176d:	01 c8                	add    %ecx,%eax
  80176f:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
  801775:	8b 85 b8 fe ff ff    	mov    -0x148(%ebp),%eax
  80177b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801780:	39 c2                	cmp    %eax,%edx
  801782:	75 17                	jne    80179b <_main+0x1763>
				panic("free: page is not removed from WS");
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	68 54 4a 80 00       	push   $0x804a54
  80178c:	68 36 01 00 00       	push   $0x136
  801791:	68 bc 48 80 00       	push   $0x8048bc
  801796:	e8 8f 01 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[7]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80179b:	ff 45 e4             	incl   -0x1c(%ebp)
  80179e:	a1 20 60 80 00       	mov    0x806020,%eax
  8017a3:	8b 50 74             	mov    0x74(%eax),%edx
  8017a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a9:	39 c2                	cmp    %eax,%edx
  8017ab:	0f 87 27 ff ff ff    	ja     8016d8 <_main+0x16a0>
				panic("free: page is not removed from WS");
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		if(start_freeFrames != (sys_calculate_free_frames())) {panic("Wrong free: not all pages removed correctly at end");}
  8017b1:	e8 82 17 00 00       	call   802f38 <sys_calculate_free_frames>
  8017b6:	89 c2                	mov    %eax,%edx
  8017b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017bb:	39 c2                	cmp    %eax,%edx
  8017bd:	74 17                	je     8017d6 <_main+0x179e>
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 78 4a 80 00       	push   $0x804a78
  8017c7:	68 39 01 00 00       	push   $0x139
  8017cc:	68 bc 48 80 00       	push   $0x8048bc
  8017d1:	e8 54 01 00 00       	call   80192a <_panic>
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	68 ac 4a 80 00       	push   $0x804aac
  8017de:	e8 fb 03 00 00       	call   801bde <cprintf>
  8017e3:	83 c4 10             	add    $0x10,%esp

	return;
  8017e6:	90                   	nop
}
  8017e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ea:	5b                   	pop    %ebx
  8017eb:	5f                   	pop    %edi
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    

008017ee <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8017f4:	e8 1f 1a 00 00       	call   803218 <sys_getenvindex>
  8017f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8017fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ff:	89 d0                	mov    %edx,%eax
  801801:	c1 e0 03             	shl    $0x3,%eax
  801804:	01 d0                	add    %edx,%eax
  801806:	01 c0                	add    %eax,%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801811:	01 d0                	add    %edx,%eax
  801813:	c1 e0 04             	shl    $0x4,%eax
  801816:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80181b:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801820:	a1 20 60 80 00       	mov    0x806020,%eax
  801825:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80182b:	84 c0                	test   %al,%al
  80182d:	74 0f                	je     80183e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80182f:	a1 20 60 80 00       	mov    0x806020,%eax
  801834:	05 5c 05 00 00       	add    $0x55c,%eax
  801839:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80183e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801842:	7e 0a                	jle    80184e <libmain+0x60>
		binaryname = argv[0];
  801844:	8b 45 0c             	mov    0xc(%ebp),%eax
  801847:	8b 00                	mov    (%eax),%eax
  801849:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80184e:	83 ec 08             	sub    $0x8,%esp
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	ff 75 08             	pushl  0x8(%ebp)
  801857:	e8 dc e7 ff ff       	call   800038 <_main>
  80185c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80185f:	e8 c1 17 00 00       	call   803025 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801864:	83 ec 0c             	sub    $0xc,%esp
  801867:	68 00 4b 80 00       	push   $0x804b00
  80186c:	e8 6d 03 00 00       	call   801bde <cprintf>
  801871:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801874:	a1 20 60 80 00       	mov    0x806020,%eax
  801879:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80187f:	a1 20 60 80 00       	mov    0x806020,%eax
  801884:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	68 28 4b 80 00       	push   $0x804b28
  801894:	e8 45 03 00 00       	call   801bde <cprintf>
  801899:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80189c:	a1 20 60 80 00       	mov    0x806020,%eax
  8018a1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8018a7:	a1 20 60 80 00       	mov    0x806020,%eax
  8018ac:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8018b2:	a1 20 60 80 00       	mov    0x806020,%eax
  8018b7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8018bd:	51                   	push   %ecx
  8018be:	52                   	push   %edx
  8018bf:	50                   	push   %eax
  8018c0:	68 50 4b 80 00       	push   $0x804b50
  8018c5:	e8 14 03 00 00       	call   801bde <cprintf>
  8018ca:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8018cd:	a1 20 60 80 00       	mov    0x806020,%eax
  8018d2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8018d8:	83 ec 08             	sub    $0x8,%esp
  8018db:	50                   	push   %eax
  8018dc:	68 a8 4b 80 00       	push   $0x804ba8
  8018e1:	e8 f8 02 00 00       	call   801bde <cprintf>
  8018e6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8018e9:	83 ec 0c             	sub    $0xc,%esp
  8018ec:	68 00 4b 80 00       	push   $0x804b00
  8018f1:	e8 e8 02 00 00       	call   801bde <cprintf>
  8018f6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8018f9:	e8 41 17 00 00       	call   80303f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8018fe:	e8 19 00 00 00       	call   80191c <exit>
}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80190c:	83 ec 0c             	sub    $0xc,%esp
  80190f:	6a 00                	push   $0x0
  801911:	e8 ce 18 00 00       	call   8031e4 <sys_destroy_env>
  801916:	83 c4 10             	add    $0x10,%esp
}
  801919:	90                   	nop
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <exit>:

void
exit(void)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801922:	e8 23 19 00 00       	call   80324a <sys_exit_env>
}
  801927:	90                   	nop
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801930:	8d 45 10             	lea    0x10(%ebp),%eax
  801933:	83 c0 04             	add    $0x4,%eax
  801936:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801939:	a1 5c 61 80 00       	mov    0x80615c,%eax
  80193e:	85 c0                	test   %eax,%eax
  801940:	74 16                	je     801958 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801942:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801947:	83 ec 08             	sub    $0x8,%esp
  80194a:	50                   	push   %eax
  80194b:	68 bc 4b 80 00       	push   $0x804bbc
  801950:	e8 89 02 00 00       	call   801bde <cprintf>
  801955:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801958:	a1 00 60 80 00       	mov    0x806000,%eax
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	ff 75 08             	pushl  0x8(%ebp)
  801963:	50                   	push   %eax
  801964:	68 c1 4b 80 00       	push   $0x804bc1
  801969:	e8 70 02 00 00       	call   801bde <cprintf>
  80196e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	ff 75 f4             	pushl  -0xc(%ebp)
  80197a:	50                   	push   %eax
  80197b:	e8 f3 01 00 00       	call   801b73 <vcprintf>
  801980:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801983:	83 ec 08             	sub    $0x8,%esp
  801986:	6a 00                	push   $0x0
  801988:	68 dd 4b 80 00       	push   $0x804bdd
  80198d:	e8 e1 01 00 00       	call   801b73 <vcprintf>
  801992:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801995:	e8 82 ff ff ff       	call   80191c <exit>

	// should not return here
	while (1) ;
  80199a:	eb fe                	jmp    80199a <_panic+0x70>

0080199c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8019a7:	8b 50 74             	mov    0x74(%eax),%edx
  8019aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ad:	39 c2                	cmp    %eax,%edx
  8019af:	74 14                	je     8019c5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	68 e0 4b 80 00       	push   $0x804be0
  8019b9:	6a 26                	push   $0x26
  8019bb:	68 2c 4c 80 00       	push   $0x804c2c
  8019c0:	e8 65 ff ff ff       	call   80192a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019d3:	e9 c2 00 00 00       	jmp    801a9a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8019d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	01 d0                	add    %edx,%eax
  8019e7:	8b 00                	mov    (%eax),%eax
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	75 08                	jne    8019f5 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8019ed:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019f0:	e9 a2 00 00 00       	jmp    801a97 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8019f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a03:	eb 69                	jmp    801a6e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a05:	a1 20 60 80 00       	mov    0x806020,%eax
  801a0a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801a10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a13:	89 d0                	mov    %edx,%eax
  801a15:	01 c0                	add    %eax,%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c1 e0 03             	shl    $0x3,%eax
  801a1c:	01 c8                	add    %ecx,%eax
  801a1e:	8a 40 04             	mov    0x4(%eax),%al
  801a21:	84 c0                	test   %al,%al
  801a23:	75 46                	jne    801a6b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a25:	a1 20 60 80 00       	mov    0x806020,%eax
  801a2a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801a30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a33:	89 d0                	mov    %edx,%eax
  801a35:	01 c0                	add    %eax,%eax
  801a37:	01 d0                	add    %edx,%eax
  801a39:	c1 e0 03             	shl    $0x3,%eax
  801a3c:	01 c8                	add    %ecx,%eax
  801a3e:	8b 00                	mov    (%eax),%eax
  801a40:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a4b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a50:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	01 c8                	add    %ecx,%eax
  801a5c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a5e:	39 c2                	cmp    %eax,%edx
  801a60:	75 09                	jne    801a6b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801a62:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a69:	eb 12                	jmp    801a7d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a6b:	ff 45 e8             	incl   -0x18(%ebp)
  801a6e:	a1 20 60 80 00       	mov    0x806020,%eax
  801a73:	8b 50 74             	mov    0x74(%eax),%edx
  801a76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a79:	39 c2                	cmp    %eax,%edx
  801a7b:	77 88                	ja     801a05 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a81:	75 14                	jne    801a97 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801a83:	83 ec 04             	sub    $0x4,%esp
  801a86:	68 38 4c 80 00       	push   $0x804c38
  801a8b:	6a 3a                	push   $0x3a
  801a8d:	68 2c 4c 80 00       	push   $0x804c2c
  801a92:	e8 93 fe ff ff       	call   80192a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a97:	ff 45 f0             	incl   -0x10(%ebp)
  801a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801aa0:	0f 8c 32 ff ff ff    	jl     8019d8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801aa6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ab4:	eb 26                	jmp    801adc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801ab6:	a1 20 60 80 00       	mov    0x806020,%eax
  801abb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801ac1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ac4:	89 d0                	mov    %edx,%eax
  801ac6:	01 c0                	add    %eax,%eax
  801ac8:	01 d0                	add    %edx,%eax
  801aca:	c1 e0 03             	shl    $0x3,%eax
  801acd:	01 c8                	add    %ecx,%eax
  801acf:	8a 40 04             	mov    0x4(%eax),%al
  801ad2:	3c 01                	cmp    $0x1,%al
  801ad4:	75 03                	jne    801ad9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801ad6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ad9:	ff 45 e0             	incl   -0x20(%ebp)
  801adc:	a1 20 60 80 00       	mov    0x806020,%eax
  801ae1:	8b 50 74             	mov    0x74(%eax),%edx
  801ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae7:	39 c2                	cmp    %eax,%edx
  801ae9:	77 cb                	ja     801ab6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aee:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801af1:	74 14                	je     801b07 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	68 8c 4c 80 00       	push   $0x804c8c
  801afb:	6a 44                	push   $0x44
  801afd:	68 2c 4c 80 00       	push   $0x804c2c
  801b02:	e8 23 fe ff ff       	call   80192a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b07:	90                   	nop
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b13:	8b 00                	mov    (%eax),%eax
  801b15:	8d 48 01             	lea    0x1(%eax),%ecx
  801b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1b:	89 0a                	mov    %ecx,(%edx)
  801b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  801b20:	88 d1                	mov    %dl,%cl
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	8b 00                	mov    (%eax),%eax
  801b2e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801b33:	75 2c                	jne    801b61 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801b35:	a0 24 60 80 00       	mov    0x806024,%al
  801b3a:	0f b6 c0             	movzbl %al,%eax
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 12                	mov    (%edx),%edx
  801b42:	89 d1                	mov    %edx,%ecx
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	83 c2 08             	add    $0x8,%edx
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	50                   	push   %eax
  801b4e:	51                   	push   %ecx
  801b4f:	52                   	push   %edx
  801b50:	e8 22 13 00 00       	call   802e77 <sys_cputs>
  801b55:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b64:	8b 40 04             	mov    0x4(%eax),%eax
  801b67:	8d 50 01             	lea    0x1(%eax),%edx
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	89 50 04             	mov    %edx,0x4(%eax)
}
  801b70:	90                   	nop
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801b7c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b83:	00 00 00 
	b.cnt = 0;
  801b86:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801b8d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801b90:	ff 75 0c             	pushl  0xc(%ebp)
  801b93:	ff 75 08             	pushl  0x8(%ebp)
  801b96:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801b9c:	50                   	push   %eax
  801b9d:	68 0a 1b 80 00       	push   $0x801b0a
  801ba2:	e8 11 02 00 00       	call   801db8 <vprintfmt>
  801ba7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801baa:	a0 24 60 80 00       	mov    0x806024,%al
  801baf:	0f b6 c0             	movzbl %al,%eax
  801bb2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801bb8:	83 ec 04             	sub    $0x4,%esp
  801bbb:	50                   	push   %eax
  801bbc:	52                   	push   %edx
  801bbd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801bc3:	83 c0 08             	add    $0x8,%eax
  801bc6:	50                   	push   %eax
  801bc7:	e8 ab 12 00 00       	call   802e77 <sys_cputs>
  801bcc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801bcf:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  801bd6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <cprintf>:

int cprintf(const char *fmt, ...) {
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801be4:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  801beb:	8d 45 0c             	lea    0xc(%ebp),%eax
  801bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	83 ec 08             	sub    $0x8,%esp
  801bf7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfa:	50                   	push   %eax
  801bfb:	e8 73 ff ff ff       	call   801b73 <vcprintf>
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801c11:	e8 0f 14 00 00       	call   803025 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c16:	8d 45 0c             	lea    0xc(%ebp),%eax
  801c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	83 ec 08             	sub    $0x8,%esp
  801c22:	ff 75 f4             	pushl  -0xc(%ebp)
  801c25:	50                   	push   %eax
  801c26:	e8 48 ff ff ff       	call   801b73 <vcprintf>
  801c2b:	83 c4 10             	add    $0x10,%esp
  801c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801c31:	e8 09 14 00 00       	call   80303f <sys_enable_interrupt>
	return cnt;
  801c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	53                   	push   %ebx
  801c3f:	83 ec 14             	sub    $0x14,%esp
  801c42:	8b 45 10             	mov    0x10(%ebp),%eax
  801c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c48:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c4e:	8b 45 18             	mov    0x18(%ebp),%eax
  801c51:	ba 00 00 00 00       	mov    $0x0,%edx
  801c56:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801c59:	77 55                	ja     801cb0 <printnum+0x75>
  801c5b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801c5e:	72 05                	jb     801c65 <printnum+0x2a>
  801c60:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c63:	77 4b                	ja     801cb0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c65:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801c68:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c6b:	8b 45 18             	mov    0x18(%ebp),%eax
  801c6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c73:	52                   	push   %edx
  801c74:	50                   	push   %eax
  801c75:	ff 75 f4             	pushl  -0xc(%ebp)
  801c78:	ff 75 f0             	pushl  -0x10(%ebp)
  801c7b:	e8 b4 29 00 00       	call   804634 <__udivdi3>
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	83 ec 04             	sub    $0x4,%esp
  801c86:	ff 75 20             	pushl  0x20(%ebp)
  801c89:	53                   	push   %ebx
  801c8a:	ff 75 18             	pushl  0x18(%ebp)
  801c8d:	52                   	push   %edx
  801c8e:	50                   	push   %eax
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	e8 a1 ff ff ff       	call   801c3b <printnum>
  801c9a:	83 c4 20             	add    $0x20,%esp
  801c9d:	eb 1a                	jmp    801cb9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801c9f:	83 ec 08             	sub    $0x8,%esp
  801ca2:	ff 75 0c             	pushl  0xc(%ebp)
  801ca5:	ff 75 20             	pushl  0x20(%ebp)
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	ff d0                	call   *%eax
  801cad:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801cb0:	ff 4d 1c             	decl   0x1c(%ebp)
  801cb3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801cb7:	7f e6                	jg     801c9f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801cb9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801cbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cc7:	53                   	push   %ebx
  801cc8:	51                   	push   %ecx
  801cc9:	52                   	push   %edx
  801cca:	50                   	push   %eax
  801ccb:	e8 74 2a 00 00       	call   804744 <__umoddi3>
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	05 f4 4e 80 00       	add    $0x804ef4,%eax
  801cd8:	8a 00                	mov    (%eax),%al
  801cda:	0f be c0             	movsbl %al,%eax
  801cdd:	83 ec 08             	sub    $0x8,%esp
  801ce0:	ff 75 0c             	pushl  0xc(%ebp)
  801ce3:	50                   	push   %eax
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	ff d0                	call   *%eax
  801ce9:	83 c4 10             	add    $0x10,%esp
}
  801cec:	90                   	nop
  801ced:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801cf5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801cf9:	7e 1c                	jle    801d17 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	8b 00                	mov    (%eax),%eax
  801d00:	8d 50 08             	lea    0x8(%eax),%edx
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	89 10                	mov    %edx,(%eax)
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	8b 00                	mov    (%eax),%eax
  801d0d:	83 e8 08             	sub    $0x8,%eax
  801d10:	8b 50 04             	mov    0x4(%eax),%edx
  801d13:	8b 00                	mov    (%eax),%eax
  801d15:	eb 40                	jmp    801d57 <getuint+0x65>
	else if (lflag)
  801d17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d1b:	74 1e                	je     801d3b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 00                	mov    (%eax),%eax
  801d22:	8d 50 04             	lea    0x4(%eax),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	89 10                	mov    %edx,(%eax)
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8b 00                	mov    (%eax),%eax
  801d2f:	83 e8 04             	sub    $0x4,%eax
  801d32:	8b 00                	mov    (%eax),%eax
  801d34:	ba 00 00 00 00       	mov    $0x0,%edx
  801d39:	eb 1c                	jmp    801d57 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	8b 00                	mov    (%eax),%eax
  801d40:	8d 50 04             	lea    0x4(%eax),%edx
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	89 10                	mov    %edx,(%eax)
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	83 e8 04             	sub    $0x4,%eax
  801d50:	8b 00                	mov    (%eax),%eax
  801d52:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    

00801d59 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801d5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801d60:	7e 1c                	jle    801d7e <getint+0x25>
		return va_arg(*ap, long long);
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	8b 00                	mov    (%eax),%eax
  801d67:	8d 50 08             	lea    0x8(%eax),%edx
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	89 10                	mov    %edx,(%eax)
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	8b 00                	mov    (%eax),%eax
  801d74:	83 e8 08             	sub    $0x8,%eax
  801d77:	8b 50 04             	mov    0x4(%eax),%edx
  801d7a:	8b 00                	mov    (%eax),%eax
  801d7c:	eb 38                	jmp    801db6 <getint+0x5d>
	else if (lflag)
  801d7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d82:	74 1a                	je     801d9e <getint+0x45>
		return va_arg(*ap, long);
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	8b 00                	mov    (%eax),%eax
  801d89:	8d 50 04             	lea    0x4(%eax),%edx
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	89 10                	mov    %edx,(%eax)
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	8b 00                	mov    (%eax),%eax
  801d96:	83 e8 04             	sub    $0x4,%eax
  801d99:	8b 00                	mov    (%eax),%eax
  801d9b:	99                   	cltd   
  801d9c:	eb 18                	jmp    801db6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	8b 00                	mov    (%eax),%eax
  801da3:	8d 50 04             	lea    0x4(%eax),%edx
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	89 10                	mov    %edx,(%eax)
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	8b 00                	mov    (%eax),%eax
  801db0:	83 e8 04             	sub    $0x4,%eax
  801db3:	8b 00                	mov    (%eax),%eax
  801db5:	99                   	cltd   
}
  801db6:	5d                   	pop    %ebp
  801db7:	c3                   	ret    

00801db8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	56                   	push   %esi
  801dbc:	53                   	push   %ebx
  801dbd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801dc0:	eb 17                	jmp    801dd9 <vprintfmt+0x21>
			if (ch == '\0')
  801dc2:	85 db                	test   %ebx,%ebx
  801dc4:	0f 84 af 03 00 00    	je     802179 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801dca:	83 ec 08             	sub    $0x8,%esp
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	53                   	push   %ebx
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	ff d0                	call   *%eax
  801dd6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddc:	8d 50 01             	lea    0x1(%eax),%edx
  801ddf:	89 55 10             	mov    %edx,0x10(%ebp)
  801de2:	8a 00                	mov    (%eax),%al
  801de4:	0f b6 d8             	movzbl %al,%ebx
  801de7:	83 fb 25             	cmp    $0x25,%ebx
  801dea:	75 d6                	jne    801dc2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801dec:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801df0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801df7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801dfe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801e05:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801e0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0f:	8d 50 01             	lea    0x1(%eax),%edx
  801e12:	89 55 10             	mov    %edx,0x10(%ebp)
  801e15:	8a 00                	mov    (%eax),%al
  801e17:	0f b6 d8             	movzbl %al,%ebx
  801e1a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801e1d:	83 f8 55             	cmp    $0x55,%eax
  801e20:	0f 87 2b 03 00 00    	ja     802151 <vprintfmt+0x399>
  801e26:	8b 04 85 18 4f 80 00 	mov    0x804f18(,%eax,4),%eax
  801e2d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801e2f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801e33:	eb d7                	jmp    801e0c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801e35:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801e39:	eb d1                	jmp    801e0c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e3b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801e42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e45:	89 d0                	mov    %edx,%eax
  801e47:	c1 e0 02             	shl    $0x2,%eax
  801e4a:	01 d0                	add    %edx,%eax
  801e4c:	01 c0                	add    %eax,%eax
  801e4e:	01 d8                	add    %ebx,%eax
  801e50:	83 e8 30             	sub    $0x30,%eax
  801e53:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801e56:	8b 45 10             	mov    0x10(%ebp),%eax
  801e59:	8a 00                	mov    (%eax),%al
  801e5b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801e5e:	83 fb 2f             	cmp    $0x2f,%ebx
  801e61:	7e 3e                	jle    801ea1 <vprintfmt+0xe9>
  801e63:	83 fb 39             	cmp    $0x39,%ebx
  801e66:	7f 39                	jg     801ea1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e68:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801e6b:	eb d5                	jmp    801e42 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801e6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e70:	83 c0 04             	add    $0x4,%eax
  801e73:	89 45 14             	mov    %eax,0x14(%ebp)
  801e76:	8b 45 14             	mov    0x14(%ebp),%eax
  801e79:	83 e8 04             	sub    $0x4,%eax
  801e7c:	8b 00                	mov    (%eax),%eax
  801e7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801e81:	eb 1f                	jmp    801ea2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801e83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e87:	79 83                	jns    801e0c <vprintfmt+0x54>
				width = 0;
  801e89:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801e90:	e9 77 ff ff ff       	jmp    801e0c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801e95:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801e9c:	e9 6b ff ff ff       	jmp    801e0c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801ea1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801ea2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ea6:	0f 89 60 ff ff ff    	jns    801e0c <vprintfmt+0x54>
				width = precision, precision = -1;
  801eac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eaf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801eb2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801eb9:	e9 4e ff ff ff       	jmp    801e0c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801ebe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801ec1:	e9 46 ff ff ff       	jmp    801e0c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801ec6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec9:	83 c0 04             	add    $0x4,%eax
  801ecc:	89 45 14             	mov    %eax,0x14(%ebp)
  801ecf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed2:	83 e8 04             	sub    $0x4,%eax
  801ed5:	8b 00                	mov    (%eax),%eax
  801ed7:	83 ec 08             	sub    $0x8,%esp
  801eda:	ff 75 0c             	pushl  0xc(%ebp)
  801edd:	50                   	push   %eax
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	ff d0                	call   *%eax
  801ee3:	83 c4 10             	add    $0x10,%esp
			break;
  801ee6:	e9 89 02 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801eeb:	8b 45 14             	mov    0x14(%ebp),%eax
  801eee:	83 c0 04             	add    $0x4,%eax
  801ef1:	89 45 14             	mov    %eax,0x14(%ebp)
  801ef4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef7:	83 e8 04             	sub    $0x4,%eax
  801efa:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801efc:	85 db                	test   %ebx,%ebx
  801efe:	79 02                	jns    801f02 <vprintfmt+0x14a>
				err = -err;
  801f00:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801f02:	83 fb 64             	cmp    $0x64,%ebx
  801f05:	7f 0b                	jg     801f12 <vprintfmt+0x15a>
  801f07:	8b 34 9d 60 4d 80 00 	mov    0x804d60(,%ebx,4),%esi
  801f0e:	85 f6                	test   %esi,%esi
  801f10:	75 19                	jne    801f2b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801f12:	53                   	push   %ebx
  801f13:	68 05 4f 80 00       	push   $0x804f05
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	e8 5e 02 00 00       	call   802181 <printfmt>
  801f23:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801f26:	e9 49 02 00 00       	jmp    802174 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801f2b:	56                   	push   %esi
  801f2c:	68 0e 4f 80 00       	push   $0x804f0e
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	ff 75 08             	pushl  0x8(%ebp)
  801f37:	e8 45 02 00 00       	call   802181 <printfmt>
  801f3c:	83 c4 10             	add    $0x10,%esp
			break;
  801f3f:	e9 30 02 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801f44:	8b 45 14             	mov    0x14(%ebp),%eax
  801f47:	83 c0 04             	add    $0x4,%eax
  801f4a:	89 45 14             	mov    %eax,0x14(%ebp)
  801f4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f50:	83 e8 04             	sub    $0x4,%eax
  801f53:	8b 30                	mov    (%eax),%esi
  801f55:	85 f6                	test   %esi,%esi
  801f57:	75 05                	jne    801f5e <vprintfmt+0x1a6>
				p = "(null)";
  801f59:	be 11 4f 80 00       	mov    $0x804f11,%esi
			if (width > 0 && padc != '-')
  801f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f62:	7e 6d                	jle    801fd1 <vprintfmt+0x219>
  801f64:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801f68:	74 67                	je     801fd1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f6d:	83 ec 08             	sub    $0x8,%esp
  801f70:	50                   	push   %eax
  801f71:	56                   	push   %esi
  801f72:	e8 0c 03 00 00       	call   802283 <strnlen>
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801f7d:	eb 16                	jmp    801f95 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801f7f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801f83:	83 ec 08             	sub    $0x8,%esp
  801f86:	ff 75 0c             	pushl  0xc(%ebp)
  801f89:	50                   	push   %eax
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	ff d0                	call   *%eax
  801f8f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801f92:	ff 4d e4             	decl   -0x1c(%ebp)
  801f95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f99:	7f e4                	jg     801f7f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f9b:	eb 34                	jmp    801fd1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801f9d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fa1:	74 1c                	je     801fbf <vprintfmt+0x207>
  801fa3:	83 fb 1f             	cmp    $0x1f,%ebx
  801fa6:	7e 05                	jle    801fad <vprintfmt+0x1f5>
  801fa8:	83 fb 7e             	cmp    $0x7e,%ebx
  801fab:	7e 12                	jle    801fbf <vprintfmt+0x207>
					putch('?', putdat);
  801fad:	83 ec 08             	sub    $0x8,%esp
  801fb0:	ff 75 0c             	pushl  0xc(%ebp)
  801fb3:	6a 3f                	push   $0x3f
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	ff d0                	call   *%eax
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	eb 0f                	jmp    801fce <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801fbf:	83 ec 08             	sub    $0x8,%esp
  801fc2:	ff 75 0c             	pushl  0xc(%ebp)
  801fc5:	53                   	push   %ebx
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	ff d0                	call   *%eax
  801fcb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801fce:	ff 4d e4             	decl   -0x1c(%ebp)
  801fd1:	89 f0                	mov    %esi,%eax
  801fd3:	8d 70 01             	lea    0x1(%eax),%esi
  801fd6:	8a 00                	mov    (%eax),%al
  801fd8:	0f be d8             	movsbl %al,%ebx
  801fdb:	85 db                	test   %ebx,%ebx
  801fdd:	74 24                	je     802003 <vprintfmt+0x24b>
  801fdf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fe3:	78 b8                	js     801f9d <vprintfmt+0x1e5>
  801fe5:	ff 4d e0             	decl   -0x20(%ebp)
  801fe8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fec:	79 af                	jns    801f9d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801fee:	eb 13                	jmp    802003 <vprintfmt+0x24b>
				putch(' ', putdat);
  801ff0:	83 ec 08             	sub    $0x8,%esp
  801ff3:	ff 75 0c             	pushl  0xc(%ebp)
  801ff6:	6a 20                	push   $0x20
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	ff d0                	call   *%eax
  801ffd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802000:	ff 4d e4             	decl   -0x1c(%ebp)
  802003:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802007:	7f e7                	jg     801ff0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  802009:	e9 66 01 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80200e:	83 ec 08             	sub    $0x8,%esp
  802011:	ff 75 e8             	pushl  -0x18(%ebp)
  802014:	8d 45 14             	lea    0x14(%ebp),%eax
  802017:	50                   	push   %eax
  802018:	e8 3c fd ff ff       	call   801d59 <getint>
  80201d:	83 c4 10             	add    $0x10,%esp
  802020:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802023:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  802026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802029:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202c:	85 d2                	test   %edx,%edx
  80202e:	79 23                	jns    802053 <vprintfmt+0x29b>
				putch('-', putdat);
  802030:	83 ec 08             	sub    $0x8,%esp
  802033:	ff 75 0c             	pushl  0xc(%ebp)
  802036:	6a 2d                	push   $0x2d
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	ff d0                	call   *%eax
  80203d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  802040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802046:	f7 d8                	neg    %eax
  802048:	83 d2 00             	adc    $0x0,%edx
  80204b:	f7 da                	neg    %edx
  80204d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802050:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  802053:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80205a:	e9 bc 00 00 00       	jmp    80211b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80205f:	83 ec 08             	sub    $0x8,%esp
  802062:	ff 75 e8             	pushl  -0x18(%ebp)
  802065:	8d 45 14             	lea    0x14(%ebp),%eax
  802068:	50                   	push   %eax
  802069:	e8 84 fc ff ff       	call   801cf2 <getuint>
  80206e:	83 c4 10             	add    $0x10,%esp
  802071:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802074:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802077:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80207e:	e9 98 00 00 00       	jmp    80211b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802083:	83 ec 08             	sub    $0x8,%esp
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	6a 58                	push   $0x58
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	ff d0                	call   *%eax
  802090:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  802093:	83 ec 08             	sub    $0x8,%esp
  802096:	ff 75 0c             	pushl  0xc(%ebp)
  802099:	6a 58                	push   $0x58
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	ff d0                	call   *%eax
  8020a0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8020a3:	83 ec 08             	sub    $0x8,%esp
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	6a 58                	push   $0x58
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	ff d0                	call   *%eax
  8020b0:	83 c4 10             	add    $0x10,%esp
			break;
  8020b3:	e9 bc 00 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8020b8:	83 ec 08             	sub    $0x8,%esp
  8020bb:	ff 75 0c             	pushl  0xc(%ebp)
  8020be:	6a 30                	push   $0x30
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	ff d0                	call   *%eax
  8020c5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8020c8:	83 ec 08             	sub    $0x8,%esp
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	6a 78                	push   $0x78
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	ff d0                	call   *%eax
  8020d5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8020d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8020db:	83 c0 04             	add    $0x4,%eax
  8020de:	89 45 14             	mov    %eax,0x14(%ebp)
  8020e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e4:	83 e8 04             	sub    $0x4,%eax
  8020e7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8020e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8020f3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8020fa:	eb 1f                	jmp    80211b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8020fc:	83 ec 08             	sub    $0x8,%esp
  8020ff:	ff 75 e8             	pushl  -0x18(%ebp)
  802102:	8d 45 14             	lea    0x14(%ebp),%eax
  802105:	50                   	push   %eax
  802106:	e8 e7 fb ff ff       	call   801cf2 <getuint>
  80210b:	83 c4 10             	add    $0x10,%esp
  80210e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802111:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  802114:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80211b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80211f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802122:	83 ec 04             	sub    $0x4,%esp
  802125:	52                   	push   %edx
  802126:	ff 75 e4             	pushl  -0x1c(%ebp)
  802129:	50                   	push   %eax
  80212a:	ff 75 f4             	pushl  -0xc(%ebp)
  80212d:	ff 75 f0             	pushl  -0x10(%ebp)
  802130:	ff 75 0c             	pushl  0xc(%ebp)
  802133:	ff 75 08             	pushl  0x8(%ebp)
  802136:	e8 00 fb ff ff       	call   801c3b <printnum>
  80213b:	83 c4 20             	add    $0x20,%esp
			break;
  80213e:	eb 34                	jmp    802174 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802140:	83 ec 08             	sub    $0x8,%esp
  802143:	ff 75 0c             	pushl  0xc(%ebp)
  802146:	53                   	push   %ebx
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	ff d0                	call   *%eax
  80214c:	83 c4 10             	add    $0x10,%esp
			break;
  80214f:	eb 23                	jmp    802174 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802151:	83 ec 08             	sub    $0x8,%esp
  802154:	ff 75 0c             	pushl  0xc(%ebp)
  802157:	6a 25                	push   $0x25
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	ff d0                	call   *%eax
  80215e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802161:	ff 4d 10             	decl   0x10(%ebp)
  802164:	eb 03                	jmp    802169 <vprintfmt+0x3b1>
  802166:	ff 4d 10             	decl   0x10(%ebp)
  802169:	8b 45 10             	mov    0x10(%ebp),%eax
  80216c:	48                   	dec    %eax
  80216d:	8a 00                	mov    (%eax),%al
  80216f:	3c 25                	cmp    $0x25,%al
  802171:	75 f3                	jne    802166 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  802173:	90                   	nop
		}
	}
  802174:	e9 47 fc ff ff       	jmp    801dc0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802179:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80217a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80217d:	5b                   	pop    %ebx
  80217e:	5e                   	pop    %esi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    

00802181 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802187:	8d 45 10             	lea    0x10(%ebp),%eax
  80218a:	83 c0 04             	add    $0x4,%eax
  80218d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802190:	8b 45 10             	mov    0x10(%ebp),%eax
  802193:	ff 75 f4             	pushl  -0xc(%ebp)
  802196:	50                   	push   %eax
  802197:	ff 75 0c             	pushl  0xc(%ebp)
  80219a:	ff 75 08             	pushl  0x8(%ebp)
  80219d:	e8 16 fc ff ff       	call   801db8 <vprintfmt>
  8021a2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8021a5:	90                   	nop
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8021ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ae:	8b 40 08             	mov    0x8(%eax),%eax
  8021b1:	8d 50 01             	lea    0x1(%eax),%edx
  8021b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8021ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bd:	8b 10                	mov    (%eax),%edx
  8021bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c2:	8b 40 04             	mov    0x4(%eax),%eax
  8021c5:	39 c2                	cmp    %eax,%edx
  8021c7:	73 12                	jae    8021db <sprintputch+0x33>
		*b->buf++ = ch;
  8021c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cc:	8b 00                	mov    (%eax),%eax
  8021ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8021d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d4:	89 0a                	mov    %ecx,(%edx)
  8021d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d9:	88 10                	mov    %dl,(%eax)
}
  8021db:	90                   	nop
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    

008021de <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	01 d0                	add    %edx,%eax
  8021f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8021ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802203:	74 06                	je     80220b <vsnprintf+0x2d>
  802205:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802209:	7f 07                	jg     802212 <vsnprintf+0x34>
		return -E_INVAL;
  80220b:	b8 03 00 00 00       	mov    $0x3,%eax
  802210:	eb 20                	jmp    802232 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802212:	ff 75 14             	pushl  0x14(%ebp)
  802215:	ff 75 10             	pushl  0x10(%ebp)
  802218:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80221b:	50                   	push   %eax
  80221c:	68 a8 21 80 00       	push   $0x8021a8
  802221:	e8 92 fb ff ff       	call   801db8 <vprintfmt>
  802226:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80223a:	8d 45 10             	lea    0x10(%ebp),%eax
  80223d:	83 c0 04             	add    $0x4,%eax
  802240:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802243:	8b 45 10             	mov    0x10(%ebp),%eax
  802246:	ff 75 f4             	pushl  -0xc(%ebp)
  802249:	50                   	push   %eax
  80224a:	ff 75 0c             	pushl  0xc(%ebp)
  80224d:	ff 75 08             	pushl  0x8(%ebp)
  802250:	e8 89 ff ff ff       	call   8021de <vsnprintf>
  802255:	83 c4 10             	add    $0x10,%esp
  802258:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802266:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80226d:	eb 06                	jmp    802275 <strlen+0x15>
		n++;
  80226f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802272:	ff 45 08             	incl   0x8(%ebp)
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	8a 00                	mov    (%eax),%al
  80227a:	84 c0                	test   %al,%al
  80227c:	75 f1                	jne    80226f <strlen+0xf>
		n++;
	return n;
  80227e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802290:	eb 09                	jmp    80229b <strnlen+0x18>
		n++;
  802292:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802295:	ff 45 08             	incl   0x8(%ebp)
  802298:	ff 4d 0c             	decl   0xc(%ebp)
  80229b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80229f:	74 09                	je     8022aa <strnlen+0x27>
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	8a 00                	mov    (%eax),%al
  8022a6:	84 c0                	test   %al,%al
  8022a8:	75 e8                	jne    802292 <strnlen+0xf>
		n++;
	return n;
  8022aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8022bb:	90                   	nop
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	8d 50 01             	lea    0x1(%eax),%edx
  8022c2:	89 55 08             	mov    %edx,0x8(%ebp)
  8022c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022cb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8022ce:	8a 12                	mov    (%edx),%dl
  8022d0:	88 10                	mov    %dl,(%eax)
  8022d2:	8a 00                	mov    (%eax),%al
  8022d4:	84 c0                	test   %al,%al
  8022d6:	75 e4                	jne    8022bc <strcpy+0xd>
		/* do nothing */;
	return ret;
  8022d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8022e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022f0:	eb 1f                	jmp    802311 <strncpy+0x34>
		*dst++ = *src;
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	8d 50 01             	lea    0x1(%eax),%edx
  8022f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8022fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fe:	8a 12                	mov    (%edx),%dl
  802300:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802302:	8b 45 0c             	mov    0xc(%ebp),%eax
  802305:	8a 00                	mov    (%eax),%al
  802307:	84 c0                	test   %al,%al
  802309:	74 03                	je     80230e <strncpy+0x31>
			src++;
  80230b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80230e:	ff 45 fc             	incl   -0x4(%ebp)
  802311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802314:	3b 45 10             	cmp    0x10(%ebp),%eax
  802317:	72 d9                	jb     8022f2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802319:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80232a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80232e:	74 30                	je     802360 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802330:	eb 16                	jmp    802348 <strlcpy+0x2a>
			*dst++ = *src++;
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8d 50 01             	lea    0x1(%eax),%edx
  802338:	89 55 08             	mov    %edx,0x8(%ebp)
  80233b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233e:	8d 4a 01             	lea    0x1(%edx),%ecx
  802341:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802344:	8a 12                	mov    (%edx),%dl
  802346:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802348:	ff 4d 10             	decl   0x10(%ebp)
  80234b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80234f:	74 09                	je     80235a <strlcpy+0x3c>
  802351:	8b 45 0c             	mov    0xc(%ebp),%eax
  802354:	8a 00                	mov    (%eax),%al
  802356:	84 c0                	test   %al,%al
  802358:	75 d8                	jne    802332 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802360:	8b 55 08             	mov    0x8(%ebp),%edx
  802363:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802366:	29 c2                	sub    %eax,%edx
  802368:	89 d0                	mov    %edx,%eax
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80236f:	eb 06                	jmp    802377 <strcmp+0xb>
		p++, q++;
  802371:	ff 45 08             	incl   0x8(%ebp)
  802374:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	8a 00                	mov    (%eax),%al
  80237c:	84 c0                	test   %al,%al
  80237e:	74 0e                	je     80238e <strcmp+0x22>
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	8a 10                	mov    (%eax),%dl
  802385:	8b 45 0c             	mov    0xc(%ebp),%eax
  802388:	8a 00                	mov    (%eax),%al
  80238a:	38 c2                	cmp    %al,%dl
  80238c:	74 e3                	je     802371 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	8a 00                	mov    (%eax),%al
  802393:	0f b6 d0             	movzbl %al,%edx
  802396:	8b 45 0c             	mov    0xc(%ebp),%eax
  802399:	8a 00                	mov    (%eax),%al
  80239b:	0f b6 c0             	movzbl %al,%eax
  80239e:	29 c2                	sub    %eax,%edx
  8023a0:	89 d0                	mov    %edx,%eax
}
  8023a2:	5d                   	pop    %ebp
  8023a3:	c3                   	ret    

008023a4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8023a7:	eb 09                	jmp    8023b2 <strncmp+0xe>
		n--, p++, q++;
  8023a9:	ff 4d 10             	decl   0x10(%ebp)
  8023ac:	ff 45 08             	incl   0x8(%ebp)
  8023af:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8023b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023b6:	74 17                	je     8023cf <strncmp+0x2b>
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8a 00                	mov    (%eax),%al
  8023bd:	84 c0                	test   %al,%al
  8023bf:	74 0e                	je     8023cf <strncmp+0x2b>
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	8a 10                	mov    (%eax),%dl
  8023c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c9:	8a 00                	mov    (%eax),%al
  8023cb:	38 c2                	cmp    %al,%dl
  8023cd:	74 da                	je     8023a9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8023cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023d3:	75 07                	jne    8023dc <strncmp+0x38>
		return 0;
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023da:	eb 14                	jmp    8023f0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	8a 00                	mov    (%eax),%al
  8023e1:	0f b6 d0             	movzbl %al,%edx
  8023e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e7:	8a 00                	mov    (%eax),%al
  8023e9:	0f b6 c0             	movzbl %al,%eax
  8023ec:	29 c2                	sub    %eax,%edx
  8023ee:	89 d0                	mov    %edx,%eax
}
  8023f0:	5d                   	pop    %ebp
  8023f1:	c3                   	ret    

008023f2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8023fe:	eb 12                	jmp    802412 <strchr+0x20>
		if (*s == c)
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	8a 00                	mov    (%eax),%al
  802405:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802408:	75 05                	jne    80240f <strchr+0x1d>
			return (char *) s;
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	eb 11                	jmp    802420 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80240f:	ff 45 08             	incl   0x8(%ebp)
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	8a 00                	mov    (%eax),%al
  802417:	84 c0                	test   %al,%al
  802419:	75 e5                	jne    802400 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	83 ec 04             	sub    $0x4,%esp
  802428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80242e:	eb 0d                	jmp    80243d <strfind+0x1b>
		if (*s == c)
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8a 00                	mov    (%eax),%al
  802435:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802438:	74 0e                	je     802448 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80243a:	ff 45 08             	incl   0x8(%ebp)
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	8a 00                	mov    (%eax),%al
  802442:	84 c0                	test   %al,%al
  802444:	75 ea                	jne    802430 <strfind+0xe>
  802446:	eb 01                	jmp    802449 <strfind+0x27>
		if (*s == c)
			break;
  802448:	90                   	nop
	return (char *) s;
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80245a:	8b 45 10             	mov    0x10(%ebp),%eax
  80245d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  802460:	eb 0e                	jmp    802470 <memset+0x22>
		*p++ = c;
  802462:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802465:	8d 50 01             	lea    0x1(%eax),%edx
  802468:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80246b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  802470:	ff 4d f8             	decl   -0x8(%ebp)
  802473:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802477:	79 e9                	jns    802462 <memset+0x14>
		*p++ = c;

	return v;
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802484:	8b 45 0c             	mov    0xc(%ebp),%eax
  802487:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  802490:	eb 16                	jmp    8024a8 <memcpy+0x2a>
		*d++ = *s++;
  802492:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802495:	8d 50 01             	lea    0x1(%eax),%edx
  802498:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80249b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80249e:	8d 4a 01             	lea    0x1(%edx),%ecx
  8024a1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8024a4:	8a 12                	mov    (%edx),%dl
  8024a6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8024a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	75 dd                	jne    802492 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8024c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8024cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024d2:	73 50                	jae    802524 <memmove+0x6a>
  8024d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024da:	01 d0                	add    %edx,%eax
  8024dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024df:	76 43                	jbe    802524 <memmove+0x6a>
		s += n;
  8024e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8024e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ea:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8024ed:	eb 10                	jmp    8024ff <memmove+0x45>
			*--d = *--s;
  8024ef:	ff 4d f8             	decl   -0x8(%ebp)
  8024f2:	ff 4d fc             	decl   -0x4(%ebp)
  8024f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024f8:	8a 10                	mov    (%eax),%dl
  8024fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024fd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8024ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802502:	8d 50 ff             	lea    -0x1(%eax),%edx
  802505:	89 55 10             	mov    %edx,0x10(%ebp)
  802508:	85 c0                	test   %eax,%eax
  80250a:	75 e3                	jne    8024ef <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80250c:	eb 23                	jmp    802531 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80250e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802511:	8d 50 01             	lea    0x1(%eax),%edx
  802514:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802517:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80251a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80251d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802520:	8a 12                	mov    (%edx),%dl
  802522:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802524:	8b 45 10             	mov    0x10(%ebp),%eax
  802527:	8d 50 ff             	lea    -0x1(%eax),%edx
  80252a:	89 55 10             	mov    %edx,0x10(%ebp)
  80252d:	85 c0                	test   %eax,%eax
  80252f:	75 dd                	jne    80250e <memmove+0x54>
			*d++ = *s++;

	return dst;
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802542:	8b 45 0c             	mov    0xc(%ebp),%eax
  802545:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802548:	eb 2a                	jmp    802574 <memcmp+0x3e>
		if (*s1 != *s2)
  80254a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80254d:	8a 10                	mov    (%eax),%dl
  80254f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802552:	8a 00                	mov    (%eax),%al
  802554:	38 c2                	cmp    %al,%dl
  802556:	74 16                	je     80256e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802558:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80255b:	8a 00                	mov    (%eax),%al
  80255d:	0f b6 d0             	movzbl %al,%edx
  802560:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802563:	8a 00                	mov    (%eax),%al
  802565:	0f b6 c0             	movzbl %al,%eax
  802568:	29 c2                	sub    %eax,%edx
  80256a:	89 d0                	mov    %edx,%eax
  80256c:	eb 18                	jmp    802586 <memcmp+0x50>
		s1++, s2++;
  80256e:	ff 45 fc             	incl   -0x4(%ebp)
  802571:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802574:	8b 45 10             	mov    0x10(%ebp),%eax
  802577:	8d 50 ff             	lea    -0x1(%eax),%edx
  80257a:	89 55 10             	mov    %edx,0x10(%ebp)
  80257d:	85 c0                	test   %eax,%eax
  80257f:	75 c9                	jne    80254a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    

00802588 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
  80258b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80258e:	8b 55 08             	mov    0x8(%ebp),%edx
  802591:	8b 45 10             	mov    0x10(%ebp),%eax
  802594:	01 d0                	add    %edx,%eax
  802596:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802599:	eb 15                	jmp    8025b0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	8a 00                	mov    (%eax),%al
  8025a0:	0f b6 d0             	movzbl %al,%edx
  8025a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a6:	0f b6 c0             	movzbl %al,%eax
  8025a9:	39 c2                	cmp    %eax,%edx
  8025ab:	74 0d                	je     8025ba <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8025ad:	ff 45 08             	incl   0x8(%ebp)
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8025b6:	72 e3                	jb     80259b <memfind+0x13>
  8025b8:	eb 01                	jmp    8025bb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8025ba:	90                   	nop
	return (void *) s;
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8025c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8025cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025d4:	eb 03                	jmp    8025d9 <strtol+0x19>
		s++;
  8025d6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	8a 00                	mov    (%eax),%al
  8025de:	3c 20                	cmp    $0x20,%al
  8025e0:	74 f4                	je     8025d6 <strtol+0x16>
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	8a 00                	mov    (%eax),%al
  8025e7:	3c 09                	cmp    $0x9,%al
  8025e9:	74 eb                	je     8025d6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	8a 00                	mov    (%eax),%al
  8025f0:	3c 2b                	cmp    $0x2b,%al
  8025f2:	75 05                	jne    8025f9 <strtol+0x39>
		s++;
  8025f4:	ff 45 08             	incl   0x8(%ebp)
  8025f7:	eb 13                	jmp    80260c <strtol+0x4c>
	else if (*s == '-')
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	8a 00                	mov    (%eax),%al
  8025fe:	3c 2d                	cmp    $0x2d,%al
  802600:	75 0a                	jne    80260c <strtol+0x4c>
		s++, neg = 1;
  802602:	ff 45 08             	incl   0x8(%ebp)
  802605:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80260c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802610:	74 06                	je     802618 <strtol+0x58>
  802612:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802616:	75 20                	jne    802638 <strtol+0x78>
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	8a 00                	mov    (%eax),%al
  80261d:	3c 30                	cmp    $0x30,%al
  80261f:	75 17                	jne    802638 <strtol+0x78>
  802621:	8b 45 08             	mov    0x8(%ebp),%eax
  802624:	40                   	inc    %eax
  802625:	8a 00                	mov    (%eax),%al
  802627:	3c 78                	cmp    $0x78,%al
  802629:	75 0d                	jne    802638 <strtol+0x78>
		s += 2, base = 16;
  80262b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80262f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802636:	eb 28                	jmp    802660 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802638:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80263c:	75 15                	jne    802653 <strtol+0x93>
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	8a 00                	mov    (%eax),%al
  802643:	3c 30                	cmp    $0x30,%al
  802645:	75 0c                	jne    802653 <strtol+0x93>
		s++, base = 8;
  802647:	ff 45 08             	incl   0x8(%ebp)
  80264a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802651:	eb 0d                	jmp    802660 <strtol+0xa0>
	else if (base == 0)
  802653:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802657:	75 07                	jne    802660 <strtol+0xa0>
		base = 10;
  802659:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	8a 00                	mov    (%eax),%al
  802665:	3c 2f                	cmp    $0x2f,%al
  802667:	7e 19                	jle    802682 <strtol+0xc2>
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	8a 00                	mov    (%eax),%al
  80266e:	3c 39                	cmp    $0x39,%al
  802670:	7f 10                	jg     802682 <strtol+0xc2>
			dig = *s - '0';
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	8a 00                	mov    (%eax),%al
  802677:	0f be c0             	movsbl %al,%eax
  80267a:	83 e8 30             	sub    $0x30,%eax
  80267d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802680:	eb 42                	jmp    8026c4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	8a 00                	mov    (%eax),%al
  802687:	3c 60                	cmp    $0x60,%al
  802689:	7e 19                	jle    8026a4 <strtol+0xe4>
  80268b:	8b 45 08             	mov    0x8(%ebp),%eax
  80268e:	8a 00                	mov    (%eax),%al
  802690:	3c 7a                	cmp    $0x7a,%al
  802692:	7f 10                	jg     8026a4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	8a 00                	mov    (%eax),%al
  802699:	0f be c0             	movsbl %al,%eax
  80269c:	83 e8 57             	sub    $0x57,%eax
  80269f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a2:	eb 20                	jmp    8026c4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	8a 00                	mov    (%eax),%al
  8026a9:	3c 40                	cmp    $0x40,%al
  8026ab:	7e 39                	jle    8026e6 <strtol+0x126>
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	8a 00                	mov    (%eax),%al
  8026b2:	3c 5a                	cmp    $0x5a,%al
  8026b4:	7f 30                	jg     8026e6 <strtol+0x126>
			dig = *s - 'A' + 10;
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	8a 00                	mov    (%eax),%al
  8026bb:	0f be c0             	movsbl %al,%eax
  8026be:	83 e8 37             	sub    $0x37,%eax
  8026c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8026ca:	7d 19                	jge    8026e5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8026cc:	ff 45 08             	incl   0x8(%ebp)
  8026cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026d2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8026d6:	89 c2                	mov    %eax,%edx
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	01 d0                	add    %edx,%eax
  8026dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8026e0:	e9 7b ff ff ff       	jmp    802660 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8026e5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8026e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026ea:	74 08                	je     8026f4 <strtol+0x134>
		*endptr = (char *) s;
  8026ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8026f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026f8:	74 07                	je     802701 <strtol+0x141>
  8026fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026fd:	f7 d8                	neg    %eax
  8026ff:	eb 03                	jmp    802704 <strtol+0x144>
  802701:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <ltostr>:

void
ltostr(long value, char *str)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80270c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802713:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80271a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80271e:	79 13                	jns    802733 <ltostr+0x2d>
	{
		neg = 1;
  802720:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802727:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80272d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802730:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802733:	8b 45 08             	mov    0x8(%ebp),%eax
  802736:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80273b:	99                   	cltd   
  80273c:	f7 f9                	idiv   %ecx
  80273e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802741:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802744:	8d 50 01             	lea    0x1(%eax),%edx
  802747:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80274a:	89 c2                	mov    %eax,%edx
  80274c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274f:	01 d0                	add    %edx,%eax
  802751:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802754:	83 c2 30             	add    $0x30,%edx
  802757:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802759:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80275c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802761:	f7 e9                	imul   %ecx
  802763:	c1 fa 02             	sar    $0x2,%edx
  802766:	89 c8                	mov    %ecx,%eax
  802768:	c1 f8 1f             	sar    $0x1f,%eax
  80276b:	29 c2                	sub    %eax,%edx
  80276d:	89 d0                	mov    %edx,%eax
  80276f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802772:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802775:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80277a:	f7 e9                	imul   %ecx
  80277c:	c1 fa 02             	sar    $0x2,%edx
  80277f:	89 c8                	mov    %ecx,%eax
  802781:	c1 f8 1f             	sar    $0x1f,%eax
  802784:	29 c2                	sub    %eax,%edx
  802786:	89 d0                	mov    %edx,%eax
  802788:	c1 e0 02             	shl    $0x2,%eax
  80278b:	01 d0                	add    %edx,%eax
  80278d:	01 c0                	add    %eax,%eax
  80278f:	29 c1                	sub    %eax,%ecx
  802791:	89 ca                	mov    %ecx,%edx
  802793:	85 d2                	test   %edx,%edx
  802795:	75 9c                	jne    802733 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802797:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80279e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027a1:	48                   	dec    %eax
  8027a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8027a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027a9:	74 3d                	je     8027e8 <ltostr+0xe2>
		start = 1 ;
  8027ab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8027b2:	eb 34                	jmp    8027e8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8027b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ba:	01 d0                	add    %edx,%eax
  8027bc:	8a 00                	mov    (%eax),%al
  8027be:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8027c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c7:	01 c2                	add    %eax,%edx
  8027c9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8027cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027cf:	01 c8                	add    %ecx,%eax
  8027d1:	8a 00                	mov    (%eax),%al
  8027d3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8027d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027db:	01 c2                	add    %eax,%edx
  8027dd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8027e0:	88 02                	mov    %al,(%edx)
		start++ ;
  8027e2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8027e5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027ee:	7c c4                	jl     8027b4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8027f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8027f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f6:	01 d0                	add    %edx,%eax
  8027f8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8027fb:	90                   	nop
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    

008027fe <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802804:	ff 75 08             	pushl  0x8(%ebp)
  802807:	e8 54 fa ff ff       	call   802260 <strlen>
  80280c:	83 c4 04             	add    $0x4,%esp
  80280f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802812:	ff 75 0c             	pushl  0xc(%ebp)
  802815:	e8 46 fa ff ff       	call   802260 <strlen>
  80281a:	83 c4 04             	add    $0x4,%esp
  80281d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802820:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802827:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80282e:	eb 17                	jmp    802847 <strcconcat+0x49>
		final[s] = str1[s] ;
  802830:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802833:	8b 45 10             	mov    0x10(%ebp),%eax
  802836:	01 c2                	add    %eax,%edx
  802838:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	01 c8                	add    %ecx,%eax
  802840:	8a 00                	mov    (%eax),%al
  802842:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802844:	ff 45 fc             	incl   -0x4(%ebp)
  802847:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80284a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80284d:	7c e1                	jl     802830 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80284f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802856:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80285d:	eb 1f                	jmp    80287e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80285f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802862:	8d 50 01             	lea    0x1(%eax),%edx
  802865:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802868:	89 c2                	mov    %eax,%edx
  80286a:	8b 45 10             	mov    0x10(%ebp),%eax
  80286d:	01 c2                	add    %eax,%edx
  80286f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802872:	8b 45 0c             	mov    0xc(%ebp),%eax
  802875:	01 c8                	add    %ecx,%eax
  802877:	8a 00                	mov    (%eax),%al
  802879:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80287b:	ff 45 f8             	incl   -0x8(%ebp)
  80287e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802881:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802884:	7c d9                	jl     80285f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802886:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802889:	8b 45 10             	mov    0x10(%ebp),%eax
  80288c:	01 d0                	add    %edx,%eax
  80288e:	c6 00 00             	movb   $0x0,(%eax)
}
  802891:	90                   	nop
  802892:	c9                   	leave  
  802893:	c3                   	ret    

00802894 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802894:	55                   	push   %ebp
  802895:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802897:	8b 45 14             	mov    0x14(%ebp),%eax
  80289a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8028a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8028af:	01 d0                	add    %edx,%eax
  8028b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028b7:	eb 0c                	jmp    8028c5 <strsplit+0x31>
			*string++ = 0;
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	8d 50 01             	lea    0x1(%eax),%edx
  8028bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8028c2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	8a 00                	mov    (%eax),%al
  8028ca:	84 c0                	test   %al,%al
  8028cc:	74 18                	je     8028e6 <strsplit+0x52>
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	8a 00                	mov    (%eax),%al
  8028d3:	0f be c0             	movsbl %al,%eax
  8028d6:	50                   	push   %eax
  8028d7:	ff 75 0c             	pushl  0xc(%ebp)
  8028da:	e8 13 fb ff ff       	call   8023f2 <strchr>
  8028df:	83 c4 08             	add    $0x8,%esp
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	75 d3                	jne    8028b9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	8a 00                	mov    (%eax),%al
  8028eb:	84 c0                	test   %al,%al
  8028ed:	74 5a                	je     802949 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8028ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	83 f8 0f             	cmp    $0xf,%eax
  8028f7:	75 07                	jne    802900 <strsplit+0x6c>
		{
			return 0;
  8028f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fe:	eb 66                	jmp    802966 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802900:	8b 45 14             	mov    0x14(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	8d 48 01             	lea    0x1(%eax),%ecx
  802908:	8b 55 14             	mov    0x14(%ebp),%edx
  80290b:	89 0a                	mov    %ecx,(%edx)
  80290d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802914:	8b 45 10             	mov    0x10(%ebp),%eax
  802917:	01 c2                	add    %eax,%edx
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80291e:	eb 03                	jmp    802923 <strsplit+0x8f>
			string++;
  802920:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	8a 00                	mov    (%eax),%al
  802928:	84 c0                	test   %al,%al
  80292a:	74 8b                	je     8028b7 <strsplit+0x23>
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	8a 00                	mov    (%eax),%al
  802931:	0f be c0             	movsbl %al,%eax
  802934:	50                   	push   %eax
  802935:	ff 75 0c             	pushl  0xc(%ebp)
  802938:	e8 b5 fa ff ff       	call   8023f2 <strchr>
  80293d:	83 c4 08             	add    $0x8,%esp
  802940:	85 c0                	test   %eax,%eax
  802942:	74 dc                	je     802920 <strsplit+0x8c>
			string++;
	}
  802944:	e9 6e ff ff ff       	jmp    8028b7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802949:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80294a:	8b 45 14             	mov    0x14(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802956:	8b 45 10             	mov    0x10(%ebp),%eax
  802959:	01 d0                	add    %edx,%eax
  80295b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802961:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802966:	c9                   	leave  
  802967:	c3                   	ret    

00802968 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp
  80296b:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80296e:	a1 04 60 80 00       	mov    0x806004,%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	74 1f                	je     802996 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802977:	e8 1d 00 00 00       	call   802999 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80297c:	83 ec 0c             	sub    $0xc,%esp
  80297f:	68 70 50 80 00       	push   $0x805070
  802984:	e8 55 f2 ff ff       	call   801bde <cprintf>
  802989:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80298c:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  802993:	00 00 00 
	}
}
  802996:	90                   	nop
  802997:	c9                   	leave  
  802998:	c3                   	ret    

00802999 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802999:	55                   	push   %ebp
  80299a:	89 e5                	mov    %esp,%ebp
  80299c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80299f:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  8029a6:	00 00 00 
  8029a9:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  8029b0:	00 00 00 
  8029b3:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  8029ba:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  8029bd:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8029c4:	00 00 00 
  8029c7:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8029ce:	00 00 00 
  8029d1:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8029d8:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8029db:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  8029e2:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8029e5:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8029f4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8029f9:	a3 50 60 80 00       	mov    %eax,0x806050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8029fe:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802a05:	a1 20 61 80 00       	mov    0x806120,%eax
  802a0a:	c1 e0 04             	shl    $0x4,%eax
  802a0d:	89 c2                	mov    %eax,%edx
  802a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a12:	01 d0                	add    %edx,%eax
  802a14:	48                   	dec    %eax
  802a15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a20:	f7 75 f0             	divl   -0x10(%ebp)
  802a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a26:	29 d0                	sub    %edx,%eax
  802a28:	89 c2                	mov    %eax,%edx
  802a2a:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  802a31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a34:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a39:	2d 00 10 00 00       	sub    $0x1000,%eax
  802a3e:	83 ec 04             	sub    $0x4,%esp
  802a41:	6a 06                	push   $0x6
  802a43:	52                   	push   %edx
  802a44:	50                   	push   %eax
  802a45:	e8 71 05 00 00       	call   802fbb <sys_allocate_chunk>
  802a4a:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802a4d:	a1 20 61 80 00       	mov    0x806120,%eax
  802a52:	83 ec 0c             	sub    $0xc,%esp
  802a55:	50                   	push   %eax
  802a56:	e8 e6 0b 00 00       	call   803641 <initialize_MemBlocksList>
  802a5b:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  802a5e:	a1 48 61 80 00       	mov    0x806148,%eax
  802a63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  802a66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a6a:	75 14                	jne    802a80 <initialize_dyn_block_system+0xe7>
  802a6c:	83 ec 04             	sub    $0x4,%esp
  802a6f:	68 95 50 80 00       	push   $0x805095
  802a74:	6a 2b                	push   $0x2b
  802a76:	68 b3 50 80 00       	push   $0x8050b3
  802a7b:	e8 aa ee ff ff       	call   80192a <_panic>
  802a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	74 10                	je     802a99 <initialize_dyn_block_system+0x100>
  802a89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a91:	8b 52 04             	mov    0x4(%edx),%edx
  802a94:	89 50 04             	mov    %edx,0x4(%eax)
  802a97:	eb 0b                	jmp    802aa4 <initialize_dyn_block_system+0x10b>
  802a99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  802aa4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa7:	8b 40 04             	mov    0x4(%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 0f                	je     802abd <initialize_dyn_block_system+0x124>
  802aae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab1:	8b 40 04             	mov    0x4(%eax),%eax
  802ab4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ab7:	8b 12                	mov    (%edx),%edx
  802ab9:	89 10                	mov    %edx,(%eax)
  802abb:	eb 0a                	jmp    802ac7 <initialize_dyn_block_system+0x12e>
  802abd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	a3 48 61 80 00       	mov    %eax,0x806148
  802ac7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ada:	a1 54 61 80 00       	mov    0x806154,%eax
  802adf:	48                   	dec    %eax
  802ae0:	a3 54 61 80 00       	mov    %eax,0x806154
		block_node->sva = USER_HEAP_START ;
  802ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae8:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  802aef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af2:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  802af9:	83 ec 0c             	sub    $0xc,%esp
  802afc:	ff 75 e4             	pushl  -0x1c(%ebp)
  802aff:	e8 d2 13 00 00       	call   803ed6 <insert_sorted_with_merge_freeList>
  802b04:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  802b07:	90                   	nop
  802b08:	c9                   	leave  
  802b09:	c3                   	ret    

00802b0a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
  802b0d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802b10:	e8 53 fe ff ff       	call   802968 <InitializeUHeap>
	if (size == 0) return NULL ;
  802b15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b19:	75 07                	jne    802b22 <malloc+0x18>
  802b1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b20:	eb 61                	jmp    802b83 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  802b22:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802b29:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	01 d0                	add    %edx,%eax
  802b31:	48                   	dec    %eax
  802b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	ba 00 00 00 00       	mov    $0x0,%edx
  802b3d:	f7 75 f4             	divl   -0xc(%ebp)
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	29 d0                	sub    %edx,%eax
  802b45:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802b48:	e8 3c 08 00 00       	call   803389 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	74 2d                	je     802b7e <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  802b51:	83 ec 0c             	sub    $0xc,%esp
  802b54:	ff 75 08             	pushl  0x8(%ebp)
  802b57:	e8 3e 0f 00 00       	call   803a9a <alloc_block_FF>
  802b5c:	83 c4 10             	add    $0x10,%esp
  802b5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  802b62:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b66:	74 16                	je     802b7e <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  802b68:	83 ec 0c             	sub    $0xc,%esp
  802b6b:	ff 75 ec             	pushl  -0x14(%ebp)
  802b6e:	e8 48 0c 00 00       	call   8037bb <insert_sorted_allocList>
  802b73:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  802b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b79:	8b 40 08             	mov    0x8(%eax),%eax
  802b7c:	eb 05                	jmp    802b83 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  802b7e:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  802b83:	c9                   	leave  
  802b84:	c3                   	ret    

00802b85 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802b85:	55                   	push   %ebp
  802b86:	89 e5                	mov    %esp,%ebp
  802b88:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802b99:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	83 ec 08             	sub    $0x8,%esp
  802ba2:	50                   	push   %eax
  802ba3:	68 40 60 80 00       	push   $0x806040
  802ba8:	e8 71 0b 00 00       	call   80371e <find_block>
  802bad:	83 c4 10             	add    $0x10,%esp
  802bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  802bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb6:	8b 50 0c             	mov    0xc(%eax),%edx
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	83 ec 08             	sub    $0x8,%esp
  802bbf:	52                   	push   %edx
  802bc0:	50                   	push   %eax
  802bc1:	e8 bd 03 00 00       	call   802f83 <sys_free_user_mem>
  802bc6:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  802bc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bcd:	75 14                	jne    802be3 <free+0x5e>
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	68 95 50 80 00       	push   $0x805095
  802bd7:	6a 71                	push   $0x71
  802bd9:	68 b3 50 80 00       	push   $0x8050b3
  802bde:	e8 47 ed ff ff       	call   80192a <_panic>
  802be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	85 c0                	test   %eax,%eax
  802bea:	74 10                	je     802bfc <free+0x77>
  802bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bef:	8b 00                	mov    (%eax),%eax
  802bf1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf4:	8b 52 04             	mov    0x4(%edx),%edx
  802bf7:	89 50 04             	mov    %edx,0x4(%eax)
  802bfa:	eb 0b                	jmp    802c07 <free+0x82>
  802bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bff:	8b 40 04             	mov    0x4(%eax),%eax
  802c02:	a3 44 60 80 00       	mov    %eax,0x806044
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	8b 40 04             	mov    0x4(%eax),%eax
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	74 0f                	je     802c20 <free+0x9b>
  802c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c14:	8b 40 04             	mov    0x4(%eax),%eax
  802c17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c1a:	8b 12                	mov    (%edx),%edx
  802c1c:	89 10                	mov    %edx,(%eax)
  802c1e:	eb 0a                	jmp    802c2a <free+0xa5>
  802c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c23:	8b 00                	mov    (%eax),%eax
  802c25:	a3 40 60 80 00       	mov    %eax,0x806040
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3d:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802c42:	48                   	dec    %eax
  802c43:	a3 4c 60 80 00       	mov    %eax,0x80604c
		insert_sorted_with_merge_freeList(elementForEach);
  802c48:	83 ec 0c             	sub    $0xc,%esp
  802c4b:	ff 75 f0             	pushl  -0x10(%ebp)
  802c4e:	e8 83 12 00 00       	call   803ed6 <insert_sorted_with_merge_freeList>
  802c53:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802c56:	90                   	nop
  802c57:	c9                   	leave  
  802c58:	c3                   	ret    

00802c59 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802c59:	55                   	push   %ebp
  802c5a:	89 e5                	mov    %esp,%ebp
  802c5c:	83 ec 28             	sub    $0x28,%esp
  802c5f:	8b 45 10             	mov    0x10(%ebp),%eax
  802c62:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802c65:	e8 fe fc ff ff       	call   802968 <InitializeUHeap>
	if (size == 0) return NULL ;
  802c6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c6e:	75 0a                	jne    802c7a <smalloc+0x21>
  802c70:	b8 00 00 00 00       	mov    $0x0,%eax
  802c75:	e9 86 00 00 00       	jmp    802d00 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  802c7a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802c81:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	01 d0                	add    %edx,%eax
  802c89:	48                   	dec    %eax
  802c8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c90:	ba 00 00 00 00       	mov    $0x0,%edx
  802c95:	f7 75 f4             	divl   -0xc(%ebp)
  802c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9b:	29 d0                	sub    %edx,%eax
  802c9d:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802ca0:	e8 e4 06 00 00       	call   803389 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	74 52                	je     802cfb <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  802ca9:	83 ec 0c             	sub    $0xc,%esp
  802cac:	ff 75 0c             	pushl  0xc(%ebp)
  802caf:	e8 e6 0d 00 00       	call   803a9a <alloc_block_FF>
  802cb4:	83 c4 10             	add    $0x10,%esp
  802cb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  802cba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cbe:	75 07                	jne    802cc7 <smalloc+0x6e>
			return NULL ;
  802cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc5:	eb 39                	jmp    802d00 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  802cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cca:	8b 40 08             	mov    0x8(%eax),%eax
  802ccd:	89 c2                	mov    %eax,%edx
  802ccf:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802cd3:	52                   	push   %edx
  802cd4:	50                   	push   %eax
  802cd5:	ff 75 0c             	pushl  0xc(%ebp)
  802cd8:	ff 75 08             	pushl  0x8(%ebp)
  802cdb:	e8 2e 04 00 00       	call   80310e <sys_createSharedObject>
  802ce0:	83 c4 10             	add    $0x10,%esp
  802ce3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  802ce6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cea:	79 07                	jns    802cf3 <smalloc+0x9a>
			return (void*)NULL ;
  802cec:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf1:	eb 0d                	jmp    802d00 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  802cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf6:	8b 40 08             	mov    0x8(%eax),%eax
  802cf9:	eb 05                	jmp    802d00 <smalloc+0xa7>
		}
		return (void*)NULL ;
  802cfb:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802d00:	c9                   	leave  
  802d01:	c3                   	ret    

00802d02 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802d02:	55                   	push   %ebp
  802d03:	89 e5                	mov    %esp,%ebp
  802d05:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802d08:	e8 5b fc ff ff       	call   802968 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802d0d:	83 ec 08             	sub    $0x8,%esp
  802d10:	ff 75 0c             	pushl  0xc(%ebp)
  802d13:	ff 75 08             	pushl  0x8(%ebp)
  802d16:	e8 1d 04 00 00       	call   803138 <sys_getSizeOfSharedObject>
  802d1b:	83 c4 10             	add    $0x10,%esp
  802d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  802d21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d25:	75 0a                	jne    802d31 <sget+0x2f>
			return NULL ;
  802d27:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2c:	e9 83 00 00 00       	jmp    802db4 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  802d31:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	01 d0                	add    %edx,%eax
  802d40:	48                   	dec    %eax
  802d41:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d47:	ba 00 00 00 00       	mov    $0x0,%edx
  802d4c:	f7 75 f0             	divl   -0x10(%ebp)
  802d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d52:	29 d0                	sub    %edx,%eax
  802d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802d57:	e8 2d 06 00 00       	call   803389 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802d5c:	85 c0                	test   %eax,%eax
  802d5e:	74 4f                	je     802daf <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	83 ec 0c             	sub    $0xc,%esp
  802d66:	50                   	push   %eax
  802d67:	e8 2e 0d 00 00       	call   803a9a <alloc_block_FF>
  802d6c:	83 c4 10             	add    $0x10,%esp
  802d6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  802d72:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d76:	75 07                	jne    802d7f <sget+0x7d>
					return (void*)NULL ;
  802d78:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7d:	eb 35                	jmp    802db4 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  802d7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d82:	8b 40 08             	mov    0x8(%eax),%eax
  802d85:	83 ec 04             	sub    $0x4,%esp
  802d88:	50                   	push   %eax
  802d89:	ff 75 0c             	pushl  0xc(%ebp)
  802d8c:	ff 75 08             	pushl  0x8(%ebp)
  802d8f:	e8 c1 03 00 00       	call   803155 <sys_getSharedObject>
  802d94:	83 c4 10             	add    $0x10,%esp
  802d97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  802d9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d9e:	79 07                	jns    802da7 <sget+0xa5>
				return (void*)NULL ;
  802da0:	b8 00 00 00 00       	mov    $0x0,%eax
  802da5:	eb 0d                	jmp    802db4 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  802da7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802daa:	8b 40 08             	mov    0x8(%eax),%eax
  802dad:	eb 05                	jmp    802db4 <sget+0xb2>


		}
	return (void*)NULL ;
  802daf:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802db4:	c9                   	leave  
  802db5:	c3                   	ret    

00802db6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802db6:	55                   	push   %ebp
  802db7:	89 e5                	mov    %esp,%ebp
  802db9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802dbc:	e8 a7 fb ff ff       	call   802968 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802dc1:	83 ec 04             	sub    $0x4,%esp
  802dc4:	68 c0 50 80 00       	push   $0x8050c0
  802dc9:	68 f9 00 00 00       	push   $0xf9
  802dce:	68 b3 50 80 00       	push   $0x8050b3
  802dd3:	e8 52 eb ff ff       	call   80192a <_panic>

00802dd8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802dd8:	55                   	push   %ebp
  802dd9:	89 e5                	mov    %esp,%ebp
  802ddb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802dde:	83 ec 04             	sub    $0x4,%esp
  802de1:	68 e8 50 80 00       	push   $0x8050e8
  802de6:	68 0d 01 00 00       	push   $0x10d
  802deb:	68 b3 50 80 00       	push   $0x8050b3
  802df0:	e8 35 eb ff ff       	call   80192a <_panic>

00802df5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802df5:	55                   	push   %ebp
  802df6:	89 e5                	mov    %esp,%ebp
  802df8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802dfb:	83 ec 04             	sub    $0x4,%esp
  802dfe:	68 0c 51 80 00       	push   $0x80510c
  802e03:	68 18 01 00 00       	push   $0x118
  802e08:	68 b3 50 80 00       	push   $0x8050b3
  802e0d:	e8 18 eb ff ff       	call   80192a <_panic>

00802e12 <shrink>:

}
void shrink(uint32 newSize)
{
  802e12:	55                   	push   %ebp
  802e13:	89 e5                	mov    %esp,%ebp
  802e15:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e18:	83 ec 04             	sub    $0x4,%esp
  802e1b:	68 0c 51 80 00       	push   $0x80510c
  802e20:	68 1d 01 00 00       	push   $0x11d
  802e25:	68 b3 50 80 00       	push   $0x8050b3
  802e2a:	e8 fb ea ff ff       	call   80192a <_panic>

00802e2f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802e2f:	55                   	push   %ebp
  802e30:	89 e5                	mov    %esp,%ebp
  802e32:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e35:	83 ec 04             	sub    $0x4,%esp
  802e38:	68 0c 51 80 00       	push   $0x80510c
  802e3d:	68 22 01 00 00       	push   $0x122
  802e42:	68 b3 50 80 00       	push   $0x8050b3
  802e47:	e8 de ea ff ff       	call   80192a <_panic>

00802e4c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e4c:	55                   	push   %ebp
  802e4d:	89 e5                	mov    %esp,%ebp
  802e4f:	57                   	push   %edi
  802e50:	56                   	push   %esi
  802e51:	53                   	push   %ebx
  802e52:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e5e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e61:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e64:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e67:	cd 30                	int    $0x30
  802e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e6f:	83 c4 10             	add    $0x10,%esp
  802e72:	5b                   	pop    %ebx
  802e73:	5e                   	pop    %esi
  802e74:	5f                   	pop    %edi
  802e75:	5d                   	pop    %ebp
  802e76:	c3                   	ret    

00802e77 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802e77:	55                   	push   %ebp
  802e78:	89 e5                	mov    %esp,%ebp
  802e7a:	83 ec 04             	sub    $0x4,%esp
  802e7d:	8b 45 10             	mov    0x10(%ebp),%eax
  802e80:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802e83:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	6a 00                	push   $0x0
  802e8c:	6a 00                	push   $0x0
  802e8e:	52                   	push   %edx
  802e8f:	ff 75 0c             	pushl  0xc(%ebp)
  802e92:	50                   	push   %eax
  802e93:	6a 00                	push   $0x0
  802e95:	e8 b2 ff ff ff       	call   802e4c <syscall>
  802e9a:	83 c4 18             	add    $0x18,%esp
}
  802e9d:	90                   	nop
  802e9e:	c9                   	leave  
  802e9f:	c3                   	ret    

00802ea0 <sys_cgetc>:

int
sys_cgetc(void)
{
  802ea0:	55                   	push   %ebp
  802ea1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802ea3:	6a 00                	push   $0x0
  802ea5:	6a 00                	push   $0x0
  802ea7:	6a 00                	push   $0x0
  802ea9:	6a 00                	push   $0x0
  802eab:	6a 00                	push   $0x0
  802ead:	6a 01                	push   $0x1
  802eaf:	e8 98 ff ff ff       	call   802e4c <syscall>
  802eb4:	83 c4 18             	add    $0x18,%esp
}
  802eb7:	c9                   	leave  
  802eb8:	c3                   	ret    

00802eb9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802eb9:	55                   	push   %ebp
  802eba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	6a 00                	push   $0x0
  802ec4:	6a 00                	push   $0x0
  802ec6:	6a 00                	push   $0x0
  802ec8:	52                   	push   %edx
  802ec9:	50                   	push   %eax
  802eca:	6a 05                	push   $0x5
  802ecc:	e8 7b ff ff ff       	call   802e4c <syscall>
  802ed1:	83 c4 18             	add    $0x18,%esp
}
  802ed4:	c9                   	leave  
  802ed5:	c3                   	ret    

00802ed6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802ed6:	55                   	push   %ebp
  802ed7:	89 e5                	mov    %esp,%ebp
  802ed9:	56                   	push   %esi
  802eda:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802edb:	8b 75 18             	mov    0x18(%ebp),%esi
  802ede:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ee1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	56                   	push   %esi
  802eeb:	53                   	push   %ebx
  802eec:	51                   	push   %ecx
  802eed:	52                   	push   %edx
  802eee:	50                   	push   %eax
  802eef:	6a 06                	push   $0x6
  802ef1:	e8 56 ff ff ff       	call   802e4c <syscall>
  802ef6:	83 c4 18             	add    $0x18,%esp
}
  802ef9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802efc:	5b                   	pop    %ebx
  802efd:	5e                   	pop    %esi
  802efe:	5d                   	pop    %ebp
  802eff:	c3                   	ret    

00802f00 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802f00:	55                   	push   %ebp
  802f01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	6a 00                	push   $0x0
  802f0b:	6a 00                	push   $0x0
  802f0d:	6a 00                	push   $0x0
  802f0f:	52                   	push   %edx
  802f10:	50                   	push   %eax
  802f11:	6a 07                	push   $0x7
  802f13:	e8 34 ff ff ff       	call   802e4c <syscall>
  802f18:	83 c4 18             	add    $0x18,%esp
}
  802f1b:	c9                   	leave  
  802f1c:	c3                   	ret    

00802f1d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f1d:	55                   	push   %ebp
  802f1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f20:	6a 00                	push   $0x0
  802f22:	6a 00                	push   $0x0
  802f24:	6a 00                	push   $0x0
  802f26:	ff 75 0c             	pushl  0xc(%ebp)
  802f29:	ff 75 08             	pushl  0x8(%ebp)
  802f2c:	6a 08                	push   $0x8
  802f2e:	e8 19 ff ff ff       	call   802e4c <syscall>
  802f33:	83 c4 18             	add    $0x18,%esp
}
  802f36:	c9                   	leave  
  802f37:	c3                   	ret    

00802f38 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f38:	55                   	push   %ebp
  802f39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f3b:	6a 00                	push   $0x0
  802f3d:	6a 00                	push   $0x0
  802f3f:	6a 00                	push   $0x0
  802f41:	6a 00                	push   $0x0
  802f43:	6a 00                	push   $0x0
  802f45:	6a 09                	push   $0x9
  802f47:	e8 00 ff ff ff       	call   802e4c <syscall>
  802f4c:	83 c4 18             	add    $0x18,%esp
}
  802f4f:	c9                   	leave  
  802f50:	c3                   	ret    

00802f51 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f51:	55                   	push   %ebp
  802f52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f54:	6a 00                	push   $0x0
  802f56:	6a 00                	push   $0x0
  802f58:	6a 00                	push   $0x0
  802f5a:	6a 00                	push   $0x0
  802f5c:	6a 00                	push   $0x0
  802f5e:	6a 0a                	push   $0xa
  802f60:	e8 e7 fe ff ff       	call   802e4c <syscall>
  802f65:	83 c4 18             	add    $0x18,%esp
}
  802f68:	c9                   	leave  
  802f69:	c3                   	ret    

00802f6a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802f6a:	55                   	push   %ebp
  802f6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802f6d:	6a 00                	push   $0x0
  802f6f:	6a 00                	push   $0x0
  802f71:	6a 00                	push   $0x0
  802f73:	6a 00                	push   $0x0
  802f75:	6a 00                	push   $0x0
  802f77:	6a 0b                	push   $0xb
  802f79:	e8 ce fe ff ff       	call   802e4c <syscall>
  802f7e:	83 c4 18             	add    $0x18,%esp
}
  802f81:	c9                   	leave  
  802f82:	c3                   	ret    

00802f83 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802f83:	55                   	push   %ebp
  802f84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802f86:	6a 00                	push   $0x0
  802f88:	6a 00                	push   $0x0
  802f8a:	6a 00                	push   $0x0
  802f8c:	ff 75 0c             	pushl  0xc(%ebp)
  802f8f:	ff 75 08             	pushl  0x8(%ebp)
  802f92:	6a 0f                	push   $0xf
  802f94:	e8 b3 fe ff ff       	call   802e4c <syscall>
  802f99:	83 c4 18             	add    $0x18,%esp
	return;
  802f9c:	90                   	nop
}
  802f9d:	c9                   	leave  
  802f9e:	c3                   	ret    

00802f9f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802f9f:	55                   	push   %ebp
  802fa0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802fa2:	6a 00                	push   $0x0
  802fa4:	6a 00                	push   $0x0
  802fa6:	6a 00                	push   $0x0
  802fa8:	ff 75 0c             	pushl  0xc(%ebp)
  802fab:	ff 75 08             	pushl  0x8(%ebp)
  802fae:	6a 10                	push   $0x10
  802fb0:	e8 97 fe ff ff       	call   802e4c <syscall>
  802fb5:	83 c4 18             	add    $0x18,%esp
	return ;
  802fb8:	90                   	nop
}
  802fb9:	c9                   	leave  
  802fba:	c3                   	ret    

00802fbb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802fbb:	55                   	push   %ebp
  802fbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802fbe:	6a 00                	push   $0x0
  802fc0:	6a 00                	push   $0x0
  802fc2:	ff 75 10             	pushl  0x10(%ebp)
  802fc5:	ff 75 0c             	pushl  0xc(%ebp)
  802fc8:	ff 75 08             	pushl  0x8(%ebp)
  802fcb:	6a 11                	push   $0x11
  802fcd:	e8 7a fe ff ff       	call   802e4c <syscall>
  802fd2:	83 c4 18             	add    $0x18,%esp
	return ;
  802fd5:	90                   	nop
}
  802fd6:	c9                   	leave  
  802fd7:	c3                   	ret    

00802fd8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802fd8:	55                   	push   %ebp
  802fd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802fdb:	6a 00                	push   $0x0
  802fdd:	6a 00                	push   $0x0
  802fdf:	6a 00                	push   $0x0
  802fe1:	6a 00                	push   $0x0
  802fe3:	6a 00                	push   $0x0
  802fe5:	6a 0c                	push   $0xc
  802fe7:	e8 60 fe ff ff       	call   802e4c <syscall>
  802fec:	83 c4 18             	add    $0x18,%esp
}
  802fef:	c9                   	leave  
  802ff0:	c3                   	ret    

00802ff1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802ff1:	55                   	push   %ebp
  802ff2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802ff4:	6a 00                	push   $0x0
  802ff6:	6a 00                	push   $0x0
  802ff8:	6a 00                	push   $0x0
  802ffa:	6a 00                	push   $0x0
  802ffc:	ff 75 08             	pushl  0x8(%ebp)
  802fff:	6a 0d                	push   $0xd
  803001:	e8 46 fe ff ff       	call   802e4c <syscall>
  803006:	83 c4 18             	add    $0x18,%esp
}
  803009:	c9                   	leave  
  80300a:	c3                   	ret    

0080300b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80300b:	55                   	push   %ebp
  80300c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80300e:	6a 00                	push   $0x0
  803010:	6a 00                	push   $0x0
  803012:	6a 00                	push   $0x0
  803014:	6a 00                	push   $0x0
  803016:	6a 00                	push   $0x0
  803018:	6a 0e                	push   $0xe
  80301a:	e8 2d fe ff ff       	call   802e4c <syscall>
  80301f:	83 c4 18             	add    $0x18,%esp
}
  803022:	90                   	nop
  803023:	c9                   	leave  
  803024:	c3                   	ret    

00803025 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  803025:	55                   	push   %ebp
  803026:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  803028:	6a 00                	push   $0x0
  80302a:	6a 00                	push   $0x0
  80302c:	6a 00                	push   $0x0
  80302e:	6a 00                	push   $0x0
  803030:	6a 00                	push   $0x0
  803032:	6a 13                	push   $0x13
  803034:	e8 13 fe ff ff       	call   802e4c <syscall>
  803039:	83 c4 18             	add    $0x18,%esp
}
  80303c:	90                   	nop
  80303d:	c9                   	leave  
  80303e:	c3                   	ret    

0080303f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80303f:	55                   	push   %ebp
  803040:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  803042:	6a 00                	push   $0x0
  803044:	6a 00                	push   $0x0
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	6a 00                	push   $0x0
  80304c:	6a 14                	push   $0x14
  80304e:	e8 f9 fd ff ff       	call   802e4c <syscall>
  803053:	83 c4 18             	add    $0x18,%esp
}
  803056:	90                   	nop
  803057:	c9                   	leave  
  803058:	c3                   	ret    

00803059 <sys_cputc>:


void
sys_cputc(const char c)
{
  803059:	55                   	push   %ebp
  80305a:	89 e5                	mov    %esp,%ebp
  80305c:	83 ec 04             	sub    $0x4,%esp
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803065:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803069:	6a 00                	push   $0x0
  80306b:	6a 00                	push   $0x0
  80306d:	6a 00                	push   $0x0
  80306f:	6a 00                	push   $0x0
  803071:	50                   	push   %eax
  803072:	6a 15                	push   $0x15
  803074:	e8 d3 fd ff ff       	call   802e4c <syscall>
  803079:	83 c4 18             	add    $0x18,%esp
}
  80307c:	90                   	nop
  80307d:	c9                   	leave  
  80307e:	c3                   	ret    

0080307f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80307f:	55                   	push   %ebp
  803080:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803082:	6a 00                	push   $0x0
  803084:	6a 00                	push   $0x0
  803086:	6a 00                	push   $0x0
  803088:	6a 00                	push   $0x0
  80308a:	6a 00                	push   $0x0
  80308c:	6a 16                	push   $0x16
  80308e:	e8 b9 fd ff ff       	call   802e4c <syscall>
  803093:	83 c4 18             	add    $0x18,%esp
}
  803096:	90                   	nop
  803097:	c9                   	leave  
  803098:	c3                   	ret    

00803099 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  803099:	55                   	push   %ebp
  80309a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	6a 00                	push   $0x0
  8030a1:	6a 00                	push   $0x0
  8030a3:	6a 00                	push   $0x0
  8030a5:	ff 75 0c             	pushl  0xc(%ebp)
  8030a8:	50                   	push   %eax
  8030a9:	6a 17                	push   $0x17
  8030ab:	e8 9c fd ff ff       	call   802e4c <syscall>
  8030b0:	83 c4 18             	add    $0x18,%esp
}
  8030b3:	c9                   	leave  
  8030b4:	c3                   	ret    

008030b5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8030b5:	55                   	push   %ebp
  8030b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8030b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	6a 00                	push   $0x0
  8030c0:	6a 00                	push   $0x0
  8030c2:	6a 00                	push   $0x0
  8030c4:	52                   	push   %edx
  8030c5:	50                   	push   %eax
  8030c6:	6a 1a                	push   $0x1a
  8030c8:	e8 7f fd ff ff       	call   802e4c <syscall>
  8030cd:	83 c4 18             	add    $0x18,%esp
}
  8030d0:	c9                   	leave  
  8030d1:	c3                   	ret    

008030d2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8030d2:	55                   	push   %ebp
  8030d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8030d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	6a 00                	push   $0x0
  8030dd:	6a 00                	push   $0x0
  8030df:	6a 00                	push   $0x0
  8030e1:	52                   	push   %edx
  8030e2:	50                   	push   %eax
  8030e3:	6a 18                	push   $0x18
  8030e5:	e8 62 fd ff ff       	call   802e4c <syscall>
  8030ea:	83 c4 18             	add    $0x18,%esp
}
  8030ed:	90                   	nop
  8030ee:	c9                   	leave  
  8030ef:	c3                   	ret    

008030f0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8030f0:	55                   	push   %ebp
  8030f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8030f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	6a 00                	push   $0x0
  8030fb:	6a 00                	push   $0x0
  8030fd:	6a 00                	push   $0x0
  8030ff:	52                   	push   %edx
  803100:	50                   	push   %eax
  803101:	6a 19                	push   $0x19
  803103:	e8 44 fd ff ff       	call   802e4c <syscall>
  803108:	83 c4 18             	add    $0x18,%esp
}
  80310b:	90                   	nop
  80310c:	c9                   	leave  
  80310d:	c3                   	ret    

0080310e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80310e:	55                   	push   %ebp
  80310f:	89 e5                	mov    %esp,%ebp
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	8b 45 10             	mov    0x10(%ebp),%eax
  803117:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80311a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80311d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	6a 00                	push   $0x0
  803126:	51                   	push   %ecx
  803127:	52                   	push   %edx
  803128:	ff 75 0c             	pushl  0xc(%ebp)
  80312b:	50                   	push   %eax
  80312c:	6a 1b                	push   $0x1b
  80312e:	e8 19 fd ff ff       	call   802e4c <syscall>
  803133:	83 c4 18             	add    $0x18,%esp
}
  803136:	c9                   	leave  
  803137:	c3                   	ret    

00803138 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  803138:	55                   	push   %ebp
  803139:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80313b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	6a 00                	push   $0x0
  803143:	6a 00                	push   $0x0
  803145:	6a 00                	push   $0x0
  803147:	52                   	push   %edx
  803148:	50                   	push   %eax
  803149:	6a 1c                	push   $0x1c
  80314b:	e8 fc fc ff ff       	call   802e4c <syscall>
  803150:	83 c4 18             	add    $0x18,%esp
}
  803153:	c9                   	leave  
  803154:	c3                   	ret    

00803155 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  803155:	55                   	push   %ebp
  803156:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803158:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80315b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	6a 00                	push   $0x0
  803163:	6a 00                	push   $0x0
  803165:	51                   	push   %ecx
  803166:	52                   	push   %edx
  803167:	50                   	push   %eax
  803168:	6a 1d                	push   $0x1d
  80316a:	e8 dd fc ff ff       	call   802e4c <syscall>
  80316f:	83 c4 18             	add    $0x18,%esp
}
  803172:	c9                   	leave  
  803173:	c3                   	ret    

00803174 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  803174:	55                   	push   %ebp
  803175:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	6a 00                	push   $0x0
  80317f:	6a 00                	push   $0x0
  803181:	6a 00                	push   $0x0
  803183:	52                   	push   %edx
  803184:	50                   	push   %eax
  803185:	6a 1e                	push   $0x1e
  803187:	e8 c0 fc ff ff       	call   802e4c <syscall>
  80318c:	83 c4 18             	add    $0x18,%esp
}
  80318f:	c9                   	leave  
  803190:	c3                   	ret    

00803191 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  803191:	55                   	push   %ebp
  803192:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  803194:	6a 00                	push   $0x0
  803196:	6a 00                	push   $0x0
  803198:	6a 00                	push   $0x0
  80319a:	6a 00                	push   $0x0
  80319c:	6a 00                	push   $0x0
  80319e:	6a 1f                	push   $0x1f
  8031a0:	e8 a7 fc ff ff       	call   802e4c <syscall>
  8031a5:	83 c4 18             	add    $0x18,%esp
}
  8031a8:	c9                   	leave  
  8031a9:	c3                   	ret    

008031aa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8031aa:	55                   	push   %ebp
  8031ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	6a 00                	push   $0x0
  8031b2:	ff 75 14             	pushl  0x14(%ebp)
  8031b5:	ff 75 10             	pushl  0x10(%ebp)
  8031b8:	ff 75 0c             	pushl  0xc(%ebp)
  8031bb:	50                   	push   %eax
  8031bc:	6a 20                	push   $0x20
  8031be:	e8 89 fc ff ff       	call   802e4c <syscall>
  8031c3:	83 c4 18             	add    $0x18,%esp
}
  8031c6:	c9                   	leave  
  8031c7:	c3                   	ret    

008031c8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8031c8:	55                   	push   %ebp
  8031c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	6a 00                	push   $0x0
  8031d0:	6a 00                	push   $0x0
  8031d2:	6a 00                	push   $0x0
  8031d4:	6a 00                	push   $0x0
  8031d6:	50                   	push   %eax
  8031d7:	6a 21                	push   $0x21
  8031d9:	e8 6e fc ff ff       	call   802e4c <syscall>
  8031de:	83 c4 18             	add    $0x18,%esp
}
  8031e1:	90                   	nop
  8031e2:	c9                   	leave  
  8031e3:	c3                   	ret    

008031e4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8031e4:	55                   	push   %ebp
  8031e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	6a 00                	push   $0x0
  8031ec:	6a 00                	push   $0x0
  8031ee:	6a 00                	push   $0x0
  8031f0:	6a 00                	push   $0x0
  8031f2:	50                   	push   %eax
  8031f3:	6a 22                	push   $0x22
  8031f5:	e8 52 fc ff ff       	call   802e4c <syscall>
  8031fa:	83 c4 18             	add    $0x18,%esp
}
  8031fd:	c9                   	leave  
  8031fe:	c3                   	ret    

008031ff <sys_getenvid>:

int32 sys_getenvid(void)
{
  8031ff:	55                   	push   %ebp
  803200:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803202:	6a 00                	push   $0x0
  803204:	6a 00                	push   $0x0
  803206:	6a 00                	push   $0x0
  803208:	6a 00                	push   $0x0
  80320a:	6a 00                	push   $0x0
  80320c:	6a 02                	push   $0x2
  80320e:	e8 39 fc ff ff       	call   802e4c <syscall>
  803213:	83 c4 18             	add    $0x18,%esp
}
  803216:	c9                   	leave  
  803217:	c3                   	ret    

00803218 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803218:	55                   	push   %ebp
  803219:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80321b:	6a 00                	push   $0x0
  80321d:	6a 00                	push   $0x0
  80321f:	6a 00                	push   $0x0
  803221:	6a 00                	push   $0x0
  803223:	6a 00                	push   $0x0
  803225:	6a 03                	push   $0x3
  803227:	e8 20 fc ff ff       	call   802e4c <syscall>
  80322c:	83 c4 18             	add    $0x18,%esp
}
  80322f:	c9                   	leave  
  803230:	c3                   	ret    

00803231 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803231:	55                   	push   %ebp
  803232:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803234:	6a 00                	push   $0x0
  803236:	6a 00                	push   $0x0
  803238:	6a 00                	push   $0x0
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 04                	push   $0x4
  803240:	e8 07 fc ff ff       	call   802e4c <syscall>
  803245:	83 c4 18             	add    $0x18,%esp
}
  803248:	c9                   	leave  
  803249:	c3                   	ret    

0080324a <sys_exit_env>:


void sys_exit_env(void)
{
  80324a:	55                   	push   %ebp
  80324b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80324d:	6a 00                	push   $0x0
  80324f:	6a 00                	push   $0x0
  803251:	6a 00                	push   $0x0
  803253:	6a 00                	push   $0x0
  803255:	6a 00                	push   $0x0
  803257:	6a 23                	push   $0x23
  803259:	e8 ee fb ff ff       	call   802e4c <syscall>
  80325e:	83 c4 18             	add    $0x18,%esp
}
  803261:	90                   	nop
  803262:	c9                   	leave  
  803263:	c3                   	ret    

00803264 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  803264:	55                   	push   %ebp
  803265:	89 e5                	mov    %esp,%ebp
  803267:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80326a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80326d:	8d 50 04             	lea    0x4(%eax),%edx
  803270:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803273:	6a 00                	push   $0x0
  803275:	6a 00                	push   $0x0
  803277:	6a 00                	push   $0x0
  803279:	52                   	push   %edx
  80327a:	50                   	push   %eax
  80327b:	6a 24                	push   $0x24
  80327d:	e8 ca fb ff ff       	call   802e4c <syscall>
  803282:	83 c4 18             	add    $0x18,%esp
	return result;
  803285:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803288:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80328b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80328e:	89 01                	mov    %eax,(%ecx)
  803290:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	c9                   	leave  
  803297:	c2 04 00             	ret    $0x4

0080329a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80329a:	55                   	push   %ebp
  80329b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80329d:	6a 00                	push   $0x0
  80329f:	6a 00                	push   $0x0
  8032a1:	ff 75 10             	pushl  0x10(%ebp)
  8032a4:	ff 75 0c             	pushl  0xc(%ebp)
  8032a7:	ff 75 08             	pushl  0x8(%ebp)
  8032aa:	6a 12                	push   $0x12
  8032ac:	e8 9b fb ff ff       	call   802e4c <syscall>
  8032b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8032b4:	90                   	nop
}
  8032b5:	c9                   	leave  
  8032b6:	c3                   	ret    

008032b7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8032b7:	55                   	push   %ebp
  8032b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8032ba:	6a 00                	push   $0x0
  8032bc:	6a 00                	push   $0x0
  8032be:	6a 00                	push   $0x0
  8032c0:	6a 00                	push   $0x0
  8032c2:	6a 00                	push   $0x0
  8032c4:	6a 25                	push   $0x25
  8032c6:	e8 81 fb ff ff       	call   802e4c <syscall>
  8032cb:	83 c4 18             	add    $0x18,%esp
}
  8032ce:	c9                   	leave  
  8032cf:	c3                   	ret    

008032d0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8032d0:	55                   	push   %ebp
  8032d1:	89 e5                	mov    %esp,%ebp
  8032d3:	83 ec 04             	sub    $0x4,%esp
  8032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8032dc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8032e0:	6a 00                	push   $0x0
  8032e2:	6a 00                	push   $0x0
  8032e4:	6a 00                	push   $0x0
  8032e6:	6a 00                	push   $0x0
  8032e8:	50                   	push   %eax
  8032e9:	6a 26                	push   $0x26
  8032eb:	e8 5c fb ff ff       	call   802e4c <syscall>
  8032f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8032f3:	90                   	nop
}
  8032f4:	c9                   	leave  
  8032f5:	c3                   	ret    

008032f6 <rsttst>:
void rsttst()
{
  8032f6:	55                   	push   %ebp
  8032f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8032f9:	6a 00                	push   $0x0
  8032fb:	6a 00                	push   $0x0
  8032fd:	6a 00                	push   $0x0
  8032ff:	6a 00                	push   $0x0
  803301:	6a 00                	push   $0x0
  803303:	6a 28                	push   $0x28
  803305:	e8 42 fb ff ff       	call   802e4c <syscall>
  80330a:	83 c4 18             	add    $0x18,%esp
	return ;
  80330d:	90                   	nop
}
  80330e:	c9                   	leave  
  80330f:	c3                   	ret    

00803310 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803310:	55                   	push   %ebp
  803311:	89 e5                	mov    %esp,%ebp
  803313:	83 ec 04             	sub    $0x4,%esp
  803316:	8b 45 14             	mov    0x14(%ebp),%eax
  803319:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80331c:	8b 55 18             	mov    0x18(%ebp),%edx
  80331f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803323:	52                   	push   %edx
  803324:	50                   	push   %eax
  803325:	ff 75 10             	pushl  0x10(%ebp)
  803328:	ff 75 0c             	pushl  0xc(%ebp)
  80332b:	ff 75 08             	pushl  0x8(%ebp)
  80332e:	6a 27                	push   $0x27
  803330:	e8 17 fb ff ff       	call   802e4c <syscall>
  803335:	83 c4 18             	add    $0x18,%esp
	return ;
  803338:	90                   	nop
}
  803339:	c9                   	leave  
  80333a:	c3                   	ret    

0080333b <chktst>:
void chktst(uint32 n)
{
  80333b:	55                   	push   %ebp
  80333c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80333e:	6a 00                	push   $0x0
  803340:	6a 00                	push   $0x0
  803342:	6a 00                	push   $0x0
  803344:	6a 00                	push   $0x0
  803346:	ff 75 08             	pushl  0x8(%ebp)
  803349:	6a 29                	push   $0x29
  80334b:	e8 fc fa ff ff       	call   802e4c <syscall>
  803350:	83 c4 18             	add    $0x18,%esp
	return ;
  803353:	90                   	nop
}
  803354:	c9                   	leave  
  803355:	c3                   	ret    

00803356 <inctst>:

void inctst()
{
  803356:	55                   	push   %ebp
  803357:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803359:	6a 00                	push   $0x0
  80335b:	6a 00                	push   $0x0
  80335d:	6a 00                	push   $0x0
  80335f:	6a 00                	push   $0x0
  803361:	6a 00                	push   $0x0
  803363:	6a 2a                	push   $0x2a
  803365:	e8 e2 fa ff ff       	call   802e4c <syscall>
  80336a:	83 c4 18             	add    $0x18,%esp
	return ;
  80336d:	90                   	nop
}
  80336e:	c9                   	leave  
  80336f:	c3                   	ret    

00803370 <gettst>:
uint32 gettst()
{
  803370:	55                   	push   %ebp
  803371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803373:	6a 00                	push   $0x0
  803375:	6a 00                	push   $0x0
  803377:	6a 00                	push   $0x0
  803379:	6a 00                	push   $0x0
  80337b:	6a 00                	push   $0x0
  80337d:	6a 2b                	push   $0x2b
  80337f:	e8 c8 fa ff ff       	call   802e4c <syscall>
  803384:	83 c4 18             	add    $0x18,%esp
}
  803387:	c9                   	leave  
  803388:	c3                   	ret    

00803389 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  803389:	55                   	push   %ebp
  80338a:	89 e5                	mov    %esp,%ebp
  80338c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80338f:	6a 00                	push   $0x0
  803391:	6a 00                	push   $0x0
  803393:	6a 00                	push   $0x0
  803395:	6a 00                	push   $0x0
  803397:	6a 00                	push   $0x0
  803399:	6a 2c                	push   $0x2c
  80339b:	e8 ac fa ff ff       	call   802e4c <syscall>
  8033a0:	83 c4 18             	add    $0x18,%esp
  8033a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8033a6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8033aa:	75 07                	jne    8033b3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8033ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8033b1:	eb 05                	jmp    8033b8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8033b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033b8:	c9                   	leave  
  8033b9:	c3                   	ret    

008033ba <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8033ba:	55                   	push   %ebp
  8033bb:	89 e5                	mov    %esp,%ebp
  8033bd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033c0:	6a 00                	push   $0x0
  8033c2:	6a 00                	push   $0x0
  8033c4:	6a 00                	push   $0x0
  8033c6:	6a 00                	push   $0x0
  8033c8:	6a 00                	push   $0x0
  8033ca:	6a 2c                	push   $0x2c
  8033cc:	e8 7b fa ff ff       	call   802e4c <syscall>
  8033d1:	83 c4 18             	add    $0x18,%esp
  8033d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8033d7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8033db:	75 07                	jne    8033e4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8033dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8033e2:	eb 05                	jmp    8033e9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8033e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033e9:	c9                   	leave  
  8033ea:	c3                   	ret    

008033eb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8033eb:	55                   	push   %ebp
  8033ec:	89 e5                	mov    %esp,%ebp
  8033ee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033f1:	6a 00                	push   $0x0
  8033f3:	6a 00                	push   $0x0
  8033f5:	6a 00                	push   $0x0
  8033f7:	6a 00                	push   $0x0
  8033f9:	6a 00                	push   $0x0
  8033fb:	6a 2c                	push   $0x2c
  8033fd:	e8 4a fa ff ff       	call   802e4c <syscall>
  803402:	83 c4 18             	add    $0x18,%esp
  803405:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803408:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80340c:	75 07                	jne    803415 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80340e:	b8 01 00 00 00       	mov    $0x1,%eax
  803413:	eb 05                	jmp    80341a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803415:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80341a:	c9                   	leave  
  80341b:	c3                   	ret    

0080341c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80341c:	55                   	push   %ebp
  80341d:	89 e5                	mov    %esp,%ebp
  80341f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803422:	6a 00                	push   $0x0
  803424:	6a 00                	push   $0x0
  803426:	6a 00                	push   $0x0
  803428:	6a 00                	push   $0x0
  80342a:	6a 00                	push   $0x0
  80342c:	6a 2c                	push   $0x2c
  80342e:	e8 19 fa ff ff       	call   802e4c <syscall>
  803433:	83 c4 18             	add    $0x18,%esp
  803436:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803439:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80343d:	75 07                	jne    803446 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80343f:	b8 01 00 00 00       	mov    $0x1,%eax
  803444:	eb 05                	jmp    80344b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803446:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80344b:	c9                   	leave  
  80344c:	c3                   	ret    

0080344d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80344d:	55                   	push   %ebp
  80344e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803450:	6a 00                	push   $0x0
  803452:	6a 00                	push   $0x0
  803454:	6a 00                	push   $0x0
  803456:	6a 00                	push   $0x0
  803458:	ff 75 08             	pushl  0x8(%ebp)
  80345b:	6a 2d                	push   $0x2d
  80345d:	e8 ea f9 ff ff       	call   802e4c <syscall>
  803462:	83 c4 18             	add    $0x18,%esp
	return ;
  803465:	90                   	nop
}
  803466:	c9                   	leave  
  803467:	c3                   	ret    

00803468 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803468:	55                   	push   %ebp
  803469:	89 e5                	mov    %esp,%ebp
  80346b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80346c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80346f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803472:	8b 55 0c             	mov    0xc(%ebp),%edx
  803475:	8b 45 08             	mov    0x8(%ebp),%eax
  803478:	6a 00                	push   $0x0
  80347a:	53                   	push   %ebx
  80347b:	51                   	push   %ecx
  80347c:	52                   	push   %edx
  80347d:	50                   	push   %eax
  80347e:	6a 2e                	push   $0x2e
  803480:	e8 c7 f9 ff ff       	call   802e4c <syscall>
  803485:	83 c4 18             	add    $0x18,%esp
}
  803488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80348b:	c9                   	leave  
  80348c:	c3                   	ret    

0080348d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80348d:	55                   	push   %ebp
  80348e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803490:	8b 55 0c             	mov    0xc(%ebp),%edx
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	6a 00                	push   $0x0
  803498:	6a 00                	push   $0x0
  80349a:	6a 00                	push   $0x0
  80349c:	52                   	push   %edx
  80349d:	50                   	push   %eax
  80349e:	6a 2f                	push   $0x2f
  8034a0:	e8 a7 f9 ff ff       	call   802e4c <syscall>
  8034a5:	83 c4 18             	add    $0x18,%esp
}
  8034a8:	c9                   	leave  
  8034a9:	c3                   	ret    

008034aa <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8034aa:	55                   	push   %ebp
  8034ab:	89 e5                	mov    %esp,%ebp
  8034ad:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8034b0:	83 ec 0c             	sub    $0xc,%esp
  8034b3:	68 1c 51 80 00       	push   $0x80511c
  8034b8:	e8 21 e7 ff ff       	call   801bde <cprintf>
  8034bd:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8034c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8034c7:	83 ec 0c             	sub    $0xc,%esp
  8034ca:	68 48 51 80 00       	push   $0x805148
  8034cf:	e8 0a e7 ff ff       	call   801bde <cprintf>
  8034d4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8034d7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8034db:	a1 38 61 80 00       	mov    0x806138,%eax
  8034e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034e3:	eb 56                	jmp    80353b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8034e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034e9:	74 1c                	je     803507 <print_mem_block_lists+0x5d>
  8034eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ee:	8b 50 08             	mov    0x8(%eax),%edx
  8034f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f4:	8b 48 08             	mov    0x8(%eax),%ecx
  8034f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8034fd:	01 c8                	add    %ecx,%eax
  8034ff:	39 c2                	cmp    %eax,%edx
  803501:	73 04                	jae    803507 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  803503:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350a:	8b 50 08             	mov    0x8(%eax),%edx
  80350d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803510:	8b 40 0c             	mov    0xc(%eax),%eax
  803513:	01 c2                	add    %eax,%edx
  803515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803518:	8b 40 08             	mov    0x8(%eax),%eax
  80351b:	83 ec 04             	sub    $0x4,%esp
  80351e:	52                   	push   %edx
  80351f:	50                   	push   %eax
  803520:	68 5d 51 80 00       	push   $0x80515d
  803525:	e8 b4 e6 ff ff       	call   801bde <cprintf>
  80352a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80352d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803530:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803533:	a1 40 61 80 00       	mov    0x806140,%eax
  803538:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80353b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80353f:	74 07                	je     803548 <print_mem_block_lists+0x9e>
  803541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803544:	8b 00                	mov    (%eax),%eax
  803546:	eb 05                	jmp    80354d <print_mem_block_lists+0xa3>
  803548:	b8 00 00 00 00       	mov    $0x0,%eax
  80354d:	a3 40 61 80 00       	mov    %eax,0x806140
  803552:	a1 40 61 80 00       	mov    0x806140,%eax
  803557:	85 c0                	test   %eax,%eax
  803559:	75 8a                	jne    8034e5 <print_mem_block_lists+0x3b>
  80355b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80355f:	75 84                	jne    8034e5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  803561:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803565:	75 10                	jne    803577 <print_mem_block_lists+0xcd>
  803567:	83 ec 0c             	sub    $0xc,%esp
  80356a:	68 6c 51 80 00       	push   $0x80516c
  80356f:	e8 6a e6 ff ff       	call   801bde <cprintf>
  803574:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  803577:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80357e:	83 ec 0c             	sub    $0xc,%esp
  803581:	68 90 51 80 00       	push   $0x805190
  803586:	e8 53 e6 ff ff       	call   801bde <cprintf>
  80358b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80358e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803592:	a1 40 60 80 00       	mov    0x806040,%eax
  803597:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80359a:	eb 56                	jmp    8035f2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80359c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035a0:	74 1c                	je     8035be <print_mem_block_lists+0x114>
  8035a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a5:	8b 50 08             	mov    0x8(%eax),%edx
  8035a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ab:	8b 48 08             	mov    0x8(%eax),%ecx
  8035ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b4:	01 c8                	add    %ecx,%eax
  8035b6:	39 c2                	cmp    %eax,%edx
  8035b8:	73 04                	jae    8035be <print_mem_block_lists+0x114>
			sorted = 0 ;
  8035ba:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	8b 50 08             	mov    0x8(%eax),%edx
  8035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ca:	01 c2                	add    %eax,%edx
  8035cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cf:	8b 40 08             	mov    0x8(%eax),%eax
  8035d2:	83 ec 04             	sub    $0x4,%esp
  8035d5:	52                   	push   %edx
  8035d6:	50                   	push   %eax
  8035d7:	68 5d 51 80 00       	push   $0x80515d
  8035dc:	e8 fd e5 ff ff       	call   801bde <cprintf>
  8035e1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8035ea:	a1 48 60 80 00       	mov    0x806048,%eax
  8035ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f6:	74 07                	je     8035ff <print_mem_block_lists+0x155>
  8035f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fb:	8b 00                	mov    (%eax),%eax
  8035fd:	eb 05                	jmp    803604 <print_mem_block_lists+0x15a>
  8035ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803604:	a3 48 60 80 00       	mov    %eax,0x806048
  803609:	a1 48 60 80 00       	mov    0x806048,%eax
  80360e:	85 c0                	test   %eax,%eax
  803610:	75 8a                	jne    80359c <print_mem_block_lists+0xf2>
  803612:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803616:	75 84                	jne    80359c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803618:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80361c:	75 10                	jne    80362e <print_mem_block_lists+0x184>
  80361e:	83 ec 0c             	sub    $0xc,%esp
  803621:	68 a8 51 80 00       	push   $0x8051a8
  803626:	e8 b3 e5 ff ff       	call   801bde <cprintf>
  80362b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80362e:	83 ec 0c             	sub    $0xc,%esp
  803631:	68 1c 51 80 00       	push   $0x80511c
  803636:	e8 a3 e5 ff ff       	call   801bde <cprintf>
  80363b:	83 c4 10             	add    $0x10,%esp

}
  80363e:	90                   	nop
  80363f:	c9                   	leave  
  803640:	c3                   	ret    

00803641 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  803641:	55                   	push   %ebp
  803642:	89 e5                	mov    %esp,%ebp
  803644:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  803647:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  80364e:	00 00 00 
  803651:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  803658:	00 00 00 
  80365b:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  803662:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  803665:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80366c:	e9 9e 00 00 00       	jmp    80370f <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  803671:	a1 50 60 80 00       	mov    0x806050,%eax
  803676:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803679:	c1 e2 04             	shl    $0x4,%edx
  80367c:	01 d0                	add    %edx,%eax
  80367e:	85 c0                	test   %eax,%eax
  803680:	75 14                	jne    803696 <initialize_MemBlocksList+0x55>
  803682:	83 ec 04             	sub    $0x4,%esp
  803685:	68 d0 51 80 00       	push   $0x8051d0
  80368a:	6a 43                	push   $0x43
  80368c:	68 f3 51 80 00       	push   $0x8051f3
  803691:	e8 94 e2 ff ff       	call   80192a <_panic>
  803696:	a1 50 60 80 00       	mov    0x806050,%eax
  80369b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80369e:	c1 e2 04             	shl    $0x4,%edx
  8036a1:	01 d0                	add    %edx,%eax
  8036a3:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8036a9:	89 10                	mov    %edx,(%eax)
  8036ab:	8b 00                	mov    (%eax),%eax
  8036ad:	85 c0                	test   %eax,%eax
  8036af:	74 18                	je     8036c9 <initialize_MemBlocksList+0x88>
  8036b1:	a1 48 61 80 00       	mov    0x806148,%eax
  8036b6:	8b 15 50 60 80 00    	mov    0x806050,%edx
  8036bc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8036bf:	c1 e1 04             	shl    $0x4,%ecx
  8036c2:	01 ca                	add    %ecx,%edx
  8036c4:	89 50 04             	mov    %edx,0x4(%eax)
  8036c7:	eb 12                	jmp    8036db <initialize_MemBlocksList+0x9a>
  8036c9:	a1 50 60 80 00       	mov    0x806050,%eax
  8036ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036d1:	c1 e2 04             	shl    $0x4,%edx
  8036d4:	01 d0                	add    %edx,%eax
  8036d6:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8036db:	a1 50 60 80 00       	mov    0x806050,%eax
  8036e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e3:	c1 e2 04             	shl    $0x4,%edx
  8036e6:	01 d0                	add    %edx,%eax
  8036e8:	a3 48 61 80 00       	mov    %eax,0x806148
  8036ed:	a1 50 60 80 00       	mov    0x806050,%eax
  8036f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f5:	c1 e2 04             	shl    $0x4,%edx
  8036f8:	01 d0                	add    %edx,%eax
  8036fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803701:	a1 54 61 80 00       	mov    0x806154,%eax
  803706:	40                   	inc    %eax
  803707:	a3 54 61 80 00       	mov    %eax,0x806154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80370c:	ff 45 f4             	incl   -0xc(%ebp)
  80370f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803712:	3b 45 08             	cmp    0x8(%ebp),%eax
  803715:	0f 82 56 ff ff ff    	jb     803671 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80371b:	90                   	nop
  80371c:	c9                   	leave  
  80371d:	c3                   	ret    

0080371e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80371e:	55                   	push   %ebp
  80371f:	89 e5                	mov    %esp,%ebp
  803721:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  803724:	a1 38 61 80 00       	mov    0x806138,%eax
  803729:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80372c:	eb 18                	jmp    803746 <find_block+0x28>
	{
		if (ele->sva==va)
  80372e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803731:	8b 40 08             	mov    0x8(%eax),%eax
  803734:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803737:	75 05                	jne    80373e <find_block+0x20>
			return ele;
  803739:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80373c:	eb 7b                	jmp    8037b9 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80373e:	a1 40 61 80 00       	mov    0x806140,%eax
  803743:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803746:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80374a:	74 07                	je     803753 <find_block+0x35>
  80374c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80374f:	8b 00                	mov    (%eax),%eax
  803751:	eb 05                	jmp    803758 <find_block+0x3a>
  803753:	b8 00 00 00 00       	mov    $0x0,%eax
  803758:	a3 40 61 80 00       	mov    %eax,0x806140
  80375d:	a1 40 61 80 00       	mov    0x806140,%eax
  803762:	85 c0                	test   %eax,%eax
  803764:	75 c8                	jne    80372e <find_block+0x10>
  803766:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80376a:	75 c2                	jne    80372e <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80376c:	a1 40 60 80 00       	mov    0x806040,%eax
  803771:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803774:	eb 18                	jmp    80378e <find_block+0x70>
	{
		if (ele->sva==va)
  803776:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803779:	8b 40 08             	mov    0x8(%eax),%eax
  80377c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80377f:	75 05                	jne    803786 <find_block+0x68>
					return ele;
  803781:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803784:	eb 33                	jmp    8037b9 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  803786:	a1 48 60 80 00       	mov    0x806048,%eax
  80378b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80378e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803792:	74 07                	je     80379b <find_block+0x7d>
  803794:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803797:	8b 00                	mov    (%eax),%eax
  803799:	eb 05                	jmp    8037a0 <find_block+0x82>
  80379b:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a0:	a3 48 60 80 00       	mov    %eax,0x806048
  8037a5:	a1 48 60 80 00       	mov    0x806048,%eax
  8037aa:	85 c0                	test   %eax,%eax
  8037ac:	75 c8                	jne    803776 <find_block+0x58>
  8037ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8037b2:	75 c2                	jne    803776 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8037b4:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8037b9:	c9                   	leave  
  8037ba:	c3                   	ret    

008037bb <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8037bb:	55                   	push   %ebp
  8037bc:	89 e5                	mov    %esp,%ebp
  8037be:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  8037c1:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8037c6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8037c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037cd:	75 62                	jne    803831 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8037cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d3:	75 14                	jne    8037e9 <insert_sorted_allocList+0x2e>
  8037d5:	83 ec 04             	sub    $0x4,%esp
  8037d8:	68 d0 51 80 00       	push   $0x8051d0
  8037dd:	6a 69                	push   $0x69
  8037df:	68 f3 51 80 00       	push   $0x8051f3
  8037e4:	e8 41 e1 ff ff       	call   80192a <_panic>
  8037e9:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8037ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f2:	89 10                	mov    %edx,(%eax)
  8037f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f7:	8b 00                	mov    (%eax),%eax
  8037f9:	85 c0                	test   %eax,%eax
  8037fb:	74 0d                	je     80380a <insert_sorted_allocList+0x4f>
  8037fd:	a1 40 60 80 00       	mov    0x806040,%eax
  803802:	8b 55 08             	mov    0x8(%ebp),%edx
  803805:	89 50 04             	mov    %edx,0x4(%eax)
  803808:	eb 08                	jmp    803812 <insert_sorted_allocList+0x57>
  80380a:	8b 45 08             	mov    0x8(%ebp),%eax
  80380d:	a3 44 60 80 00       	mov    %eax,0x806044
  803812:	8b 45 08             	mov    0x8(%ebp),%eax
  803815:	a3 40 60 80 00       	mov    %eax,0x806040
  80381a:	8b 45 08             	mov    0x8(%ebp),%eax
  80381d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803824:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803829:	40                   	inc    %eax
  80382a:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80382f:	eb 72                	jmp    8038a3 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  803831:	a1 40 60 80 00       	mov    0x806040,%eax
  803836:	8b 50 08             	mov    0x8(%eax),%edx
  803839:	8b 45 08             	mov    0x8(%ebp),%eax
  80383c:	8b 40 08             	mov    0x8(%eax),%eax
  80383f:	39 c2                	cmp    %eax,%edx
  803841:	76 60                	jbe    8038a3 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  803843:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803847:	75 14                	jne    80385d <insert_sorted_allocList+0xa2>
  803849:	83 ec 04             	sub    $0x4,%esp
  80384c:	68 d0 51 80 00       	push   $0x8051d0
  803851:	6a 6d                	push   $0x6d
  803853:	68 f3 51 80 00       	push   $0x8051f3
  803858:	e8 cd e0 ff ff       	call   80192a <_panic>
  80385d:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803863:	8b 45 08             	mov    0x8(%ebp),%eax
  803866:	89 10                	mov    %edx,(%eax)
  803868:	8b 45 08             	mov    0x8(%ebp),%eax
  80386b:	8b 00                	mov    (%eax),%eax
  80386d:	85 c0                	test   %eax,%eax
  80386f:	74 0d                	je     80387e <insert_sorted_allocList+0xc3>
  803871:	a1 40 60 80 00       	mov    0x806040,%eax
  803876:	8b 55 08             	mov    0x8(%ebp),%edx
  803879:	89 50 04             	mov    %edx,0x4(%eax)
  80387c:	eb 08                	jmp    803886 <insert_sorted_allocList+0xcb>
  80387e:	8b 45 08             	mov    0x8(%ebp),%eax
  803881:	a3 44 60 80 00       	mov    %eax,0x806044
  803886:	8b 45 08             	mov    0x8(%ebp),%eax
  803889:	a3 40 60 80 00       	mov    %eax,0x806040
  80388e:	8b 45 08             	mov    0x8(%ebp),%eax
  803891:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803898:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80389d:	40                   	inc    %eax
  80389e:	a3 4c 60 80 00       	mov    %eax,0x80604c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8038a3:	a1 40 60 80 00       	mov    0x806040,%eax
  8038a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038ab:	e9 b9 01 00 00       	jmp    803a69 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8038b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b3:	8b 50 08             	mov    0x8(%eax),%edx
  8038b6:	a1 40 60 80 00       	mov    0x806040,%eax
  8038bb:	8b 40 08             	mov    0x8(%eax),%eax
  8038be:	39 c2                	cmp    %eax,%edx
  8038c0:	76 7c                	jbe    80393e <insert_sorted_allocList+0x183>
  8038c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c5:	8b 50 08             	mov    0x8(%eax),%edx
  8038c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cb:	8b 40 08             	mov    0x8(%eax),%eax
  8038ce:	39 c2                	cmp    %eax,%edx
  8038d0:	73 6c                	jae    80393e <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  8038d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038d6:	74 06                	je     8038de <insert_sorted_allocList+0x123>
  8038d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038dc:	75 14                	jne    8038f2 <insert_sorted_allocList+0x137>
  8038de:	83 ec 04             	sub    $0x4,%esp
  8038e1:	68 0c 52 80 00       	push   $0x80520c
  8038e6:	6a 75                	push   $0x75
  8038e8:	68 f3 51 80 00       	push   $0x8051f3
  8038ed:	e8 38 e0 ff ff       	call   80192a <_panic>
  8038f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f5:	8b 50 04             	mov    0x4(%eax),%edx
  8038f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fb:	89 50 04             	mov    %edx,0x4(%eax)
  8038fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803901:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803904:	89 10                	mov    %edx,(%eax)
  803906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803909:	8b 40 04             	mov    0x4(%eax),%eax
  80390c:	85 c0                	test   %eax,%eax
  80390e:	74 0d                	je     80391d <insert_sorted_allocList+0x162>
  803910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803913:	8b 40 04             	mov    0x4(%eax),%eax
  803916:	8b 55 08             	mov    0x8(%ebp),%edx
  803919:	89 10                	mov    %edx,(%eax)
  80391b:	eb 08                	jmp    803925 <insert_sorted_allocList+0x16a>
  80391d:	8b 45 08             	mov    0x8(%ebp),%eax
  803920:	a3 40 60 80 00       	mov    %eax,0x806040
  803925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803928:	8b 55 08             	mov    0x8(%ebp),%edx
  80392b:	89 50 04             	mov    %edx,0x4(%eax)
  80392e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803933:	40                   	inc    %eax
  803934:	a3 4c 60 80 00       	mov    %eax,0x80604c

		break;}
  803939:	e9 59 01 00 00       	jmp    803a97 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  80393e:	8b 45 08             	mov    0x8(%ebp),%eax
  803941:	8b 50 08             	mov    0x8(%eax),%edx
  803944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803947:	8b 40 08             	mov    0x8(%eax),%eax
  80394a:	39 c2                	cmp    %eax,%edx
  80394c:	0f 86 98 00 00 00    	jbe    8039ea <insert_sorted_allocList+0x22f>
  803952:	8b 45 08             	mov    0x8(%ebp),%eax
  803955:	8b 50 08             	mov    0x8(%eax),%edx
  803958:	a1 44 60 80 00       	mov    0x806044,%eax
  80395d:	8b 40 08             	mov    0x8(%eax),%eax
  803960:	39 c2                	cmp    %eax,%edx
  803962:	0f 83 82 00 00 00    	jae    8039ea <insert_sorted_allocList+0x22f>
  803968:	8b 45 08             	mov    0x8(%ebp),%eax
  80396b:	8b 50 08             	mov    0x8(%eax),%edx
  80396e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803971:	8b 00                	mov    (%eax),%eax
  803973:	8b 40 08             	mov    0x8(%eax),%eax
  803976:	39 c2                	cmp    %eax,%edx
  803978:	73 70                	jae    8039ea <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80397a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80397e:	74 06                	je     803986 <insert_sorted_allocList+0x1cb>
  803980:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803984:	75 14                	jne    80399a <insert_sorted_allocList+0x1df>
  803986:	83 ec 04             	sub    $0x4,%esp
  803989:	68 44 52 80 00       	push   $0x805244
  80398e:	6a 7c                	push   $0x7c
  803990:	68 f3 51 80 00       	push   $0x8051f3
  803995:	e8 90 df ff ff       	call   80192a <_panic>
  80399a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399d:	8b 10                	mov    (%eax),%edx
  80399f:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a2:	89 10                	mov    %edx,(%eax)
  8039a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a7:	8b 00                	mov    (%eax),%eax
  8039a9:	85 c0                	test   %eax,%eax
  8039ab:	74 0b                	je     8039b8 <insert_sorted_allocList+0x1fd>
  8039ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b0:	8b 00                	mov    (%eax),%eax
  8039b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8039b5:	89 50 04             	mov    %edx,0x4(%eax)
  8039b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8039be:	89 10                	mov    %edx,(%eax)
  8039c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039c6:	89 50 04             	mov    %edx,0x4(%eax)
  8039c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cc:	8b 00                	mov    (%eax),%eax
  8039ce:	85 c0                	test   %eax,%eax
  8039d0:	75 08                	jne    8039da <insert_sorted_allocList+0x21f>
  8039d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d5:	a3 44 60 80 00       	mov    %eax,0x806044
  8039da:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8039df:	40                   	inc    %eax
  8039e0:	a3 4c 60 80 00       	mov    %eax,0x80604c
		break;
  8039e5:	e9 ad 00 00 00       	jmp    803a97 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8039ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ed:	8b 50 08             	mov    0x8(%eax),%edx
  8039f0:	a1 44 60 80 00       	mov    0x806044,%eax
  8039f5:	8b 40 08             	mov    0x8(%eax),%eax
  8039f8:	39 c2                	cmp    %eax,%edx
  8039fa:	76 65                	jbe    803a61 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8039fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a00:	75 17                	jne    803a19 <insert_sorted_allocList+0x25e>
  803a02:	83 ec 04             	sub    $0x4,%esp
  803a05:	68 78 52 80 00       	push   $0x805278
  803a0a:	68 80 00 00 00       	push   $0x80
  803a0f:	68 f3 51 80 00       	push   $0x8051f3
  803a14:	e8 11 df ff ff       	call   80192a <_panic>
  803a19:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a22:	89 50 04             	mov    %edx,0x4(%eax)
  803a25:	8b 45 08             	mov    0x8(%ebp),%eax
  803a28:	8b 40 04             	mov    0x4(%eax),%eax
  803a2b:	85 c0                	test   %eax,%eax
  803a2d:	74 0c                	je     803a3b <insert_sorted_allocList+0x280>
  803a2f:	a1 44 60 80 00       	mov    0x806044,%eax
  803a34:	8b 55 08             	mov    0x8(%ebp),%edx
  803a37:	89 10                	mov    %edx,(%eax)
  803a39:	eb 08                	jmp    803a43 <insert_sorted_allocList+0x288>
  803a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3e:	a3 40 60 80 00       	mov    %eax,0x806040
  803a43:	8b 45 08             	mov    0x8(%ebp),%eax
  803a46:	a3 44 60 80 00       	mov    %eax,0x806044
  803a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a54:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803a59:	40                   	inc    %eax
  803a5a:	a3 4c 60 80 00       	mov    %eax,0x80604c
		break;
  803a5f:	eb 36                	jmp    803a97 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  803a61:	a1 48 60 80 00       	mov    0x806048,%eax
  803a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a6d:	74 07                	je     803a76 <insert_sorted_allocList+0x2bb>
  803a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a72:	8b 00                	mov    (%eax),%eax
  803a74:	eb 05                	jmp    803a7b <insert_sorted_allocList+0x2c0>
  803a76:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7b:	a3 48 60 80 00       	mov    %eax,0x806048
  803a80:	a1 48 60 80 00       	mov    0x806048,%eax
  803a85:	85 c0                	test   %eax,%eax
  803a87:	0f 85 23 fe ff ff    	jne    8038b0 <insert_sorted_allocList+0xf5>
  803a8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a91:	0f 85 19 fe ff ff    	jne    8038b0 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  803a97:	90                   	nop
  803a98:	c9                   	leave  
  803a99:	c3                   	ret    

00803a9a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803a9a:	55                   	push   %ebp
  803a9b:	89 e5                	mov    %esp,%ebp
  803a9d:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803aa0:	a1 38 61 80 00       	mov    0x806138,%eax
  803aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803aa8:	e9 7c 01 00 00       	jmp    803c29 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  803aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab0:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab3:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ab6:	0f 85 90 00 00 00    	jne    803b4c <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  803abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abf:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  803ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ac6:	75 17                	jne    803adf <alloc_block_FF+0x45>
  803ac8:	83 ec 04             	sub    $0x4,%esp
  803acb:	68 9b 52 80 00       	push   $0x80529b
  803ad0:	68 ba 00 00 00       	push   $0xba
  803ad5:	68 f3 51 80 00       	push   $0x8051f3
  803ada:	e8 4b de ff ff       	call   80192a <_panic>
  803adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae2:	8b 00                	mov    (%eax),%eax
  803ae4:	85 c0                	test   %eax,%eax
  803ae6:	74 10                	je     803af8 <alloc_block_FF+0x5e>
  803ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aeb:	8b 00                	mov    (%eax),%eax
  803aed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803af0:	8b 52 04             	mov    0x4(%edx),%edx
  803af3:	89 50 04             	mov    %edx,0x4(%eax)
  803af6:	eb 0b                	jmp    803b03 <alloc_block_FF+0x69>
  803af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afb:	8b 40 04             	mov    0x4(%eax),%eax
  803afe:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b06:	8b 40 04             	mov    0x4(%eax),%eax
  803b09:	85 c0                	test   %eax,%eax
  803b0b:	74 0f                	je     803b1c <alloc_block_FF+0x82>
  803b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b10:	8b 40 04             	mov    0x4(%eax),%eax
  803b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b16:	8b 12                	mov    (%edx),%edx
  803b18:	89 10                	mov    %edx,(%eax)
  803b1a:	eb 0a                	jmp    803b26 <alloc_block_FF+0x8c>
  803b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1f:	8b 00                	mov    (%eax),%eax
  803b21:	a3 38 61 80 00       	mov    %eax,0x806138
  803b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b39:	a1 44 61 80 00       	mov    0x806144,%eax
  803b3e:	48                   	dec    %eax
  803b3f:	a3 44 61 80 00       	mov    %eax,0x806144
					return tmp_block;
  803b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b47:	e9 10 01 00 00       	jmp    803c5c <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  803b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4f:	8b 40 0c             	mov    0xc(%eax),%eax
  803b52:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b55:	0f 86 c6 00 00 00    	jbe    803c21 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  803b5b:	a1 48 61 80 00       	mov    0x806148,%eax
  803b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  803b63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b67:	75 17                	jne    803b80 <alloc_block_FF+0xe6>
  803b69:	83 ec 04             	sub    $0x4,%esp
  803b6c:	68 9b 52 80 00       	push   $0x80529b
  803b71:	68 c2 00 00 00       	push   $0xc2
  803b76:	68 f3 51 80 00       	push   $0x8051f3
  803b7b:	e8 aa dd ff ff       	call   80192a <_panic>
  803b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b83:	8b 00                	mov    (%eax),%eax
  803b85:	85 c0                	test   %eax,%eax
  803b87:	74 10                	je     803b99 <alloc_block_FF+0xff>
  803b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b8c:	8b 00                	mov    (%eax),%eax
  803b8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b91:	8b 52 04             	mov    0x4(%edx),%edx
  803b94:	89 50 04             	mov    %edx,0x4(%eax)
  803b97:	eb 0b                	jmp    803ba4 <alloc_block_FF+0x10a>
  803b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b9c:	8b 40 04             	mov    0x4(%eax),%eax
  803b9f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ba7:	8b 40 04             	mov    0x4(%eax),%eax
  803baa:	85 c0                	test   %eax,%eax
  803bac:	74 0f                	je     803bbd <alloc_block_FF+0x123>
  803bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bb1:	8b 40 04             	mov    0x4(%eax),%eax
  803bb4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bb7:	8b 12                	mov    (%edx),%edx
  803bb9:	89 10                	mov    %edx,(%eax)
  803bbb:	eb 0a                	jmp    803bc7 <alloc_block_FF+0x12d>
  803bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc0:	8b 00                	mov    (%eax),%eax
  803bc2:	a3 48 61 80 00       	mov    %eax,0x806148
  803bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bda:	a1 54 61 80 00       	mov    0x806154,%eax
  803bdf:	48                   	dec    %eax
  803be0:	a3 54 61 80 00       	mov    %eax,0x806154
					tmp_block->sva=element->sva;
  803be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be8:	8b 50 08             	mov    0x8(%eax),%edx
  803beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bee:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  803bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  803bf7:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  803bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  803c00:	2b 45 08             	sub    0x8(%ebp),%eax
  803c03:	89 c2                	mov    %eax,%edx
  803c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c08:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  803c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0e:	8b 50 08             	mov    0x8(%eax),%edx
  803c11:	8b 45 08             	mov    0x8(%ebp),%eax
  803c14:	01 c2                	add    %eax,%edx
  803c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c19:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  803c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c1f:	eb 3b                	jmp    803c5c <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803c21:	a1 40 61 80 00       	mov    0x806140,%eax
  803c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c2d:	74 07                	je     803c36 <alloc_block_FF+0x19c>
  803c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c32:	8b 00                	mov    (%eax),%eax
  803c34:	eb 05                	jmp    803c3b <alloc_block_FF+0x1a1>
  803c36:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3b:	a3 40 61 80 00       	mov    %eax,0x806140
  803c40:	a1 40 61 80 00       	mov    0x806140,%eax
  803c45:	85 c0                	test   %eax,%eax
  803c47:	0f 85 60 fe ff ff    	jne    803aad <alloc_block_FF+0x13>
  803c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c51:	0f 85 56 fe ff ff    	jne    803aad <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  803c57:	b8 00 00 00 00       	mov    $0x0,%eax
  803c5c:	c9                   	leave  
  803c5d:	c3                   	ret    

00803c5e <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  803c5e:	55                   	push   %ebp
  803c5f:	89 e5                	mov    %esp,%ebp
  803c61:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  803c64:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803c6b:	a1 38 61 80 00       	mov    0x806138,%eax
  803c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c73:	eb 3a                	jmp    803caf <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  803c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c78:	8b 40 0c             	mov    0xc(%eax),%eax
  803c7b:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c7e:	72 27                	jb     803ca7 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  803c80:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803c84:	75 0b                	jne    803c91 <alloc_block_BF+0x33>
					best_size= element->size;
  803c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c89:	8b 40 0c             	mov    0xc(%eax),%eax
  803c8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803c8f:	eb 16                	jmp    803ca7 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  803c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c94:	8b 50 0c             	mov    0xc(%eax),%edx
  803c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c9a:	39 c2                	cmp    %eax,%edx
  803c9c:	77 09                	ja     803ca7 <alloc_block_BF+0x49>
					best_size=element->size;
  803c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  803ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803ca7:	a1 40 61 80 00       	mov    0x806140,%eax
  803cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803caf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cb3:	74 07                	je     803cbc <alloc_block_BF+0x5e>
  803cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb8:	8b 00                	mov    (%eax),%eax
  803cba:	eb 05                	jmp    803cc1 <alloc_block_BF+0x63>
  803cbc:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc1:	a3 40 61 80 00       	mov    %eax,0x806140
  803cc6:	a1 40 61 80 00       	mov    0x806140,%eax
  803ccb:	85 c0                	test   %eax,%eax
  803ccd:	75 a6                	jne    803c75 <alloc_block_BF+0x17>
  803ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cd3:	75 a0                	jne    803c75 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  803cd5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803cd9:	0f 84 d3 01 00 00    	je     803eb2 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  803cdf:	a1 38 61 80 00       	mov    0x806138,%eax
  803ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ce7:	e9 98 01 00 00       	jmp    803e84 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  803cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cef:	3b 45 08             	cmp    0x8(%ebp),%eax
  803cf2:	0f 86 da 00 00 00    	jbe    803dd2 <alloc_block_BF+0x174>
  803cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfb:	8b 50 0c             	mov    0xc(%eax),%edx
  803cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d01:	39 c2                	cmp    %eax,%edx
  803d03:	0f 85 c9 00 00 00    	jne    803dd2 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  803d09:	a1 48 61 80 00       	mov    0x806148,%eax
  803d0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  803d11:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803d15:	75 17                	jne    803d2e <alloc_block_BF+0xd0>
  803d17:	83 ec 04             	sub    $0x4,%esp
  803d1a:	68 9b 52 80 00       	push   $0x80529b
  803d1f:	68 ea 00 00 00       	push   $0xea
  803d24:	68 f3 51 80 00       	push   $0x8051f3
  803d29:	e8 fc db ff ff       	call   80192a <_panic>
  803d2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d31:	8b 00                	mov    (%eax),%eax
  803d33:	85 c0                	test   %eax,%eax
  803d35:	74 10                	je     803d47 <alloc_block_BF+0xe9>
  803d37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d3a:	8b 00                	mov    (%eax),%eax
  803d3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d3f:	8b 52 04             	mov    0x4(%edx),%edx
  803d42:	89 50 04             	mov    %edx,0x4(%eax)
  803d45:	eb 0b                	jmp    803d52 <alloc_block_BF+0xf4>
  803d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d4a:	8b 40 04             	mov    0x4(%eax),%eax
  803d4d:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803d52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d55:	8b 40 04             	mov    0x4(%eax),%eax
  803d58:	85 c0                	test   %eax,%eax
  803d5a:	74 0f                	je     803d6b <alloc_block_BF+0x10d>
  803d5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d5f:	8b 40 04             	mov    0x4(%eax),%eax
  803d62:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d65:	8b 12                	mov    (%edx),%edx
  803d67:	89 10                	mov    %edx,(%eax)
  803d69:	eb 0a                	jmp    803d75 <alloc_block_BF+0x117>
  803d6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d6e:	8b 00                	mov    (%eax),%eax
  803d70:	a3 48 61 80 00       	mov    %eax,0x806148
  803d75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d88:	a1 54 61 80 00       	mov    0x806154,%eax
  803d8d:	48                   	dec    %eax
  803d8e:	a3 54 61 80 00       	mov    %eax,0x806154
				tmp_block->sva=element->sva;
  803d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d96:	8b 50 08             	mov    0x8(%eax),%edx
  803d99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d9c:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  803d9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803da2:	8b 55 08             	mov    0x8(%ebp),%edx
  803da5:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  803da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dab:	8b 40 0c             	mov    0xc(%eax),%eax
  803dae:	2b 45 08             	sub    0x8(%ebp),%eax
  803db1:	89 c2                	mov    %eax,%edx
  803db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db6:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  803db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbc:	8b 50 08             	mov    0x8(%eax),%edx
  803dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc2:	01 c2                	add    %eax,%edx
  803dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc7:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  803dca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dcd:	e9 e5 00 00 00       	jmp    803eb7 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  803dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd5:	8b 50 0c             	mov    0xc(%eax),%edx
  803dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ddb:	39 c2                	cmp    %eax,%edx
  803ddd:	0f 85 99 00 00 00    	jne    803e7c <alloc_block_BF+0x21e>
  803de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de6:	3b 45 08             	cmp    0x8(%ebp),%eax
  803de9:	0f 85 8d 00 00 00    	jne    803e7c <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  803def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df2:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  803df5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803df9:	75 17                	jne    803e12 <alloc_block_BF+0x1b4>
  803dfb:	83 ec 04             	sub    $0x4,%esp
  803dfe:	68 9b 52 80 00       	push   $0x80529b
  803e03:	68 f7 00 00 00       	push   $0xf7
  803e08:	68 f3 51 80 00       	push   $0x8051f3
  803e0d:	e8 18 db ff ff       	call   80192a <_panic>
  803e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e15:	8b 00                	mov    (%eax),%eax
  803e17:	85 c0                	test   %eax,%eax
  803e19:	74 10                	je     803e2b <alloc_block_BF+0x1cd>
  803e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1e:	8b 00                	mov    (%eax),%eax
  803e20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e23:	8b 52 04             	mov    0x4(%edx),%edx
  803e26:	89 50 04             	mov    %edx,0x4(%eax)
  803e29:	eb 0b                	jmp    803e36 <alloc_block_BF+0x1d8>
  803e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2e:	8b 40 04             	mov    0x4(%eax),%eax
  803e31:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e39:	8b 40 04             	mov    0x4(%eax),%eax
  803e3c:	85 c0                	test   %eax,%eax
  803e3e:	74 0f                	je     803e4f <alloc_block_BF+0x1f1>
  803e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e43:	8b 40 04             	mov    0x4(%eax),%eax
  803e46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e49:	8b 12                	mov    (%edx),%edx
  803e4b:	89 10                	mov    %edx,(%eax)
  803e4d:	eb 0a                	jmp    803e59 <alloc_block_BF+0x1fb>
  803e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e52:	8b 00                	mov    (%eax),%eax
  803e54:	a3 38 61 80 00       	mov    %eax,0x806138
  803e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e6c:	a1 44 61 80 00       	mov    0x806144,%eax
  803e71:	48                   	dec    %eax
  803e72:	a3 44 61 80 00       	mov    %eax,0x806144
				return tmp_block;
  803e77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e7a:	eb 3b                	jmp    803eb7 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  803e7c:	a1 40 61 80 00       	mov    0x806140,%eax
  803e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e88:	74 07                	je     803e91 <alloc_block_BF+0x233>
  803e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8d:	8b 00                	mov    (%eax),%eax
  803e8f:	eb 05                	jmp    803e96 <alloc_block_BF+0x238>
  803e91:	b8 00 00 00 00       	mov    $0x0,%eax
  803e96:	a3 40 61 80 00       	mov    %eax,0x806140
  803e9b:	a1 40 61 80 00       	mov    0x806140,%eax
  803ea0:	85 c0                	test   %eax,%eax
  803ea2:	0f 85 44 fe ff ff    	jne    803cec <alloc_block_BF+0x8e>
  803ea8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eac:	0f 85 3a fe ff ff    	jne    803cec <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  803eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb7:	c9                   	leave  
  803eb8:	c3                   	ret    

00803eb9 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803eb9:	55                   	push   %ebp
  803eba:	89 e5                	mov    %esp,%ebp
  803ebc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  803ebf:	83 ec 04             	sub    $0x4,%esp
  803ec2:	68 bc 52 80 00       	push   $0x8052bc
  803ec7:	68 04 01 00 00       	push   $0x104
  803ecc:	68 f3 51 80 00       	push   $0x8051f3
  803ed1:	e8 54 da ff ff       	call   80192a <_panic>

00803ed6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  803ed6:	55                   	push   %ebp
  803ed7:	89 e5                	mov    %esp,%ebp
  803ed9:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  803edc:	a1 38 61 80 00       	mov    0x806138,%eax
  803ee1:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  803ee4:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803ee9:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  803eec:	a1 38 61 80 00       	mov    0x806138,%eax
  803ef1:	85 c0                	test   %eax,%eax
  803ef3:	75 68                	jne    803f5d <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803ef5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ef9:	75 17                	jne    803f12 <insert_sorted_with_merge_freeList+0x3c>
  803efb:	83 ec 04             	sub    $0x4,%esp
  803efe:	68 d0 51 80 00       	push   $0x8051d0
  803f03:	68 14 01 00 00       	push   $0x114
  803f08:	68 f3 51 80 00       	push   $0x8051f3
  803f0d:	e8 18 da ff ff       	call   80192a <_panic>
  803f12:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803f18:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1b:	89 10                	mov    %edx,(%eax)
  803f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f20:	8b 00                	mov    (%eax),%eax
  803f22:	85 c0                	test   %eax,%eax
  803f24:	74 0d                	je     803f33 <insert_sorted_with_merge_freeList+0x5d>
  803f26:	a1 38 61 80 00       	mov    0x806138,%eax
  803f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  803f2e:	89 50 04             	mov    %edx,0x4(%eax)
  803f31:	eb 08                	jmp    803f3b <insert_sorted_with_merge_freeList+0x65>
  803f33:	8b 45 08             	mov    0x8(%ebp),%eax
  803f36:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3e:	a3 38 61 80 00       	mov    %eax,0x806138
  803f43:	8b 45 08             	mov    0x8(%ebp),%eax
  803f46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f4d:	a1 44 61 80 00       	mov    0x806144,%eax
  803f52:	40                   	inc    %eax
  803f53:	a3 44 61 80 00       	mov    %eax,0x806144
						}
				}
        }

}
}
  803f58:	e9 d2 06 00 00       	jmp    80462f <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  803f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f60:	8b 50 08             	mov    0x8(%eax),%edx
  803f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f66:	8b 40 08             	mov    0x8(%eax),%eax
  803f69:	39 c2                	cmp    %eax,%edx
  803f6b:	0f 83 22 01 00 00    	jae    804093 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  803f71:	8b 45 08             	mov    0x8(%ebp),%eax
  803f74:	8b 50 08             	mov    0x8(%eax),%edx
  803f77:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7a:	8b 40 0c             	mov    0xc(%eax),%eax
  803f7d:	01 c2                	add    %eax,%edx
  803f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f82:	8b 40 08             	mov    0x8(%eax),%eax
  803f85:	39 c2                	cmp    %eax,%edx
  803f87:	0f 85 9e 00 00 00    	jne    80402b <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  803f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f90:	8b 50 08             	mov    0x8(%eax),%edx
  803f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f96:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f9c:	8b 50 0c             	mov    0xc(%eax),%edx
  803f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa2:	8b 40 0c             	mov    0xc(%eax),%eax
  803fa5:	01 c2                	add    %eax,%edx
  803fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803faa:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  803fad:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  803fba:	8b 50 08             	mov    0x8(%eax),%edx
  803fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc0:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803fc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803fc7:	75 17                	jne    803fe0 <insert_sorted_with_merge_freeList+0x10a>
  803fc9:	83 ec 04             	sub    $0x4,%esp
  803fcc:	68 d0 51 80 00       	push   $0x8051d0
  803fd1:	68 21 01 00 00       	push   $0x121
  803fd6:	68 f3 51 80 00       	push   $0x8051f3
  803fdb:	e8 4a d9 ff ff       	call   80192a <_panic>
  803fe0:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe9:	89 10                	mov    %edx,(%eax)
  803feb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fee:	8b 00                	mov    (%eax),%eax
  803ff0:	85 c0                	test   %eax,%eax
  803ff2:	74 0d                	je     804001 <insert_sorted_with_merge_freeList+0x12b>
  803ff4:	a1 48 61 80 00       	mov    0x806148,%eax
  803ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  803ffc:	89 50 04             	mov    %edx,0x4(%eax)
  803fff:	eb 08                	jmp    804009 <insert_sorted_with_merge_freeList+0x133>
  804001:	8b 45 08             	mov    0x8(%ebp),%eax
  804004:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804009:	8b 45 08             	mov    0x8(%ebp),%eax
  80400c:	a3 48 61 80 00       	mov    %eax,0x806148
  804011:	8b 45 08             	mov    0x8(%ebp),%eax
  804014:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80401b:	a1 54 61 80 00       	mov    0x806154,%eax
  804020:	40                   	inc    %eax
  804021:	a3 54 61 80 00       	mov    %eax,0x806154
						}
				}
        }

}
}
  804026:	e9 04 06 00 00       	jmp    80462f <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80402b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80402f:	75 17                	jne    804048 <insert_sorted_with_merge_freeList+0x172>
  804031:	83 ec 04             	sub    $0x4,%esp
  804034:	68 d0 51 80 00       	push   $0x8051d0
  804039:	68 26 01 00 00       	push   $0x126
  80403e:	68 f3 51 80 00       	push   $0x8051f3
  804043:	e8 e2 d8 ff ff       	call   80192a <_panic>
  804048:	8b 15 38 61 80 00    	mov    0x806138,%edx
  80404e:	8b 45 08             	mov    0x8(%ebp),%eax
  804051:	89 10                	mov    %edx,(%eax)
  804053:	8b 45 08             	mov    0x8(%ebp),%eax
  804056:	8b 00                	mov    (%eax),%eax
  804058:	85 c0                	test   %eax,%eax
  80405a:	74 0d                	je     804069 <insert_sorted_with_merge_freeList+0x193>
  80405c:	a1 38 61 80 00       	mov    0x806138,%eax
  804061:	8b 55 08             	mov    0x8(%ebp),%edx
  804064:	89 50 04             	mov    %edx,0x4(%eax)
  804067:	eb 08                	jmp    804071 <insert_sorted_with_merge_freeList+0x19b>
  804069:	8b 45 08             	mov    0x8(%ebp),%eax
  80406c:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804071:	8b 45 08             	mov    0x8(%ebp),%eax
  804074:	a3 38 61 80 00       	mov    %eax,0x806138
  804079:	8b 45 08             	mov    0x8(%ebp),%eax
  80407c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804083:	a1 44 61 80 00       	mov    0x806144,%eax
  804088:	40                   	inc    %eax
  804089:	a3 44 61 80 00       	mov    %eax,0x806144
						}
				}
        }

}
}
  80408e:	e9 9c 05 00 00       	jmp    80462f <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  804093:	8b 45 08             	mov    0x8(%ebp),%eax
  804096:	8b 50 08             	mov    0x8(%eax),%edx
  804099:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80409c:	8b 40 08             	mov    0x8(%eax),%eax
  80409f:	39 c2                	cmp    %eax,%edx
  8040a1:	0f 86 16 01 00 00    	jbe    8041bd <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  8040a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040aa:	8b 50 08             	mov    0x8(%eax),%edx
  8040ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8040b3:	01 c2                	add    %eax,%edx
  8040b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b8:	8b 40 08             	mov    0x8(%eax),%eax
  8040bb:	39 c2                	cmp    %eax,%edx
  8040bd:	0f 85 92 00 00 00    	jne    804155 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  8040c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8040c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8040cf:	01 c2                	add    %eax,%edx
  8040d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040d4:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  8040d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8040e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e4:	8b 50 08             	mov    0x8(%eax),%edx
  8040e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ea:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8040ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040f1:	75 17                	jne    80410a <insert_sorted_with_merge_freeList+0x234>
  8040f3:	83 ec 04             	sub    $0x4,%esp
  8040f6:	68 d0 51 80 00       	push   $0x8051d0
  8040fb:	68 31 01 00 00       	push   $0x131
  804100:	68 f3 51 80 00       	push   $0x8051f3
  804105:	e8 20 d8 ff ff       	call   80192a <_panic>
  80410a:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804110:	8b 45 08             	mov    0x8(%ebp),%eax
  804113:	89 10                	mov    %edx,(%eax)
  804115:	8b 45 08             	mov    0x8(%ebp),%eax
  804118:	8b 00                	mov    (%eax),%eax
  80411a:	85 c0                	test   %eax,%eax
  80411c:	74 0d                	je     80412b <insert_sorted_with_merge_freeList+0x255>
  80411e:	a1 48 61 80 00       	mov    0x806148,%eax
  804123:	8b 55 08             	mov    0x8(%ebp),%edx
  804126:	89 50 04             	mov    %edx,0x4(%eax)
  804129:	eb 08                	jmp    804133 <insert_sorted_with_merge_freeList+0x25d>
  80412b:	8b 45 08             	mov    0x8(%ebp),%eax
  80412e:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804133:	8b 45 08             	mov    0x8(%ebp),%eax
  804136:	a3 48 61 80 00       	mov    %eax,0x806148
  80413b:	8b 45 08             	mov    0x8(%ebp),%eax
  80413e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804145:	a1 54 61 80 00       	mov    0x806154,%eax
  80414a:	40                   	inc    %eax
  80414b:	a3 54 61 80 00       	mov    %eax,0x806154
						}
				}
        }

}
}
  804150:	e9 da 04 00 00       	jmp    80462f <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  804155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804159:	75 17                	jne    804172 <insert_sorted_with_merge_freeList+0x29c>
  80415b:	83 ec 04             	sub    $0x4,%esp
  80415e:	68 78 52 80 00       	push   $0x805278
  804163:	68 37 01 00 00       	push   $0x137
  804168:	68 f3 51 80 00       	push   $0x8051f3
  80416d:	e8 b8 d7 ff ff       	call   80192a <_panic>
  804172:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  804178:	8b 45 08             	mov    0x8(%ebp),%eax
  80417b:	89 50 04             	mov    %edx,0x4(%eax)
  80417e:	8b 45 08             	mov    0x8(%ebp),%eax
  804181:	8b 40 04             	mov    0x4(%eax),%eax
  804184:	85 c0                	test   %eax,%eax
  804186:	74 0c                	je     804194 <insert_sorted_with_merge_freeList+0x2be>
  804188:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80418d:	8b 55 08             	mov    0x8(%ebp),%edx
  804190:	89 10                	mov    %edx,(%eax)
  804192:	eb 08                	jmp    80419c <insert_sorted_with_merge_freeList+0x2c6>
  804194:	8b 45 08             	mov    0x8(%ebp),%eax
  804197:	a3 38 61 80 00       	mov    %eax,0x806138
  80419c:	8b 45 08             	mov    0x8(%ebp),%eax
  80419f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8041a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8041a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041ad:	a1 44 61 80 00       	mov    0x806144,%eax
  8041b2:	40                   	inc    %eax
  8041b3:	a3 44 61 80 00       	mov    %eax,0x806144
						}
				}
        }

}
}
  8041b8:	e9 72 04 00 00       	jmp    80462f <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8041bd:	a1 38 61 80 00       	mov    0x806138,%eax
  8041c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8041c5:	e9 35 04 00 00       	jmp    8045ff <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  8041ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041cd:	8b 00                	mov    (%eax),%eax
  8041cf:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  8041d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d5:	8b 50 08             	mov    0x8(%eax),%edx
  8041d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041db:	8b 40 08             	mov    0x8(%eax),%eax
  8041de:	39 c2                	cmp    %eax,%edx
  8041e0:	0f 86 11 04 00 00    	jbe    8045f7 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  8041e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041e9:	8b 50 08             	mov    0x8(%eax),%edx
  8041ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8041f2:	01 c2                	add    %eax,%edx
  8041f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f7:	8b 40 08             	mov    0x8(%eax),%eax
  8041fa:	39 c2                	cmp    %eax,%edx
  8041fc:	0f 83 8b 00 00 00    	jae    80428d <insert_sorted_with_merge_freeList+0x3b7>
  804202:	8b 45 08             	mov    0x8(%ebp),%eax
  804205:	8b 50 08             	mov    0x8(%eax),%edx
  804208:	8b 45 08             	mov    0x8(%ebp),%eax
  80420b:	8b 40 0c             	mov    0xc(%eax),%eax
  80420e:	01 c2                	add    %eax,%edx
  804210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804213:	8b 40 08             	mov    0x8(%eax),%eax
  804216:	39 c2                	cmp    %eax,%edx
  804218:	73 73                	jae    80428d <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  80421a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80421e:	74 06                	je     804226 <insert_sorted_with_merge_freeList+0x350>
  804220:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804224:	75 17                	jne    80423d <insert_sorted_with_merge_freeList+0x367>
  804226:	83 ec 04             	sub    $0x4,%esp
  804229:	68 44 52 80 00       	push   $0x805244
  80422e:	68 48 01 00 00       	push   $0x148
  804233:	68 f3 51 80 00       	push   $0x8051f3
  804238:	e8 ed d6 ff ff       	call   80192a <_panic>
  80423d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804240:	8b 10                	mov    (%eax),%edx
  804242:	8b 45 08             	mov    0x8(%ebp),%eax
  804245:	89 10                	mov    %edx,(%eax)
  804247:	8b 45 08             	mov    0x8(%ebp),%eax
  80424a:	8b 00                	mov    (%eax),%eax
  80424c:	85 c0                	test   %eax,%eax
  80424e:	74 0b                	je     80425b <insert_sorted_with_merge_freeList+0x385>
  804250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804253:	8b 00                	mov    (%eax),%eax
  804255:	8b 55 08             	mov    0x8(%ebp),%edx
  804258:	89 50 04             	mov    %edx,0x4(%eax)
  80425b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80425e:	8b 55 08             	mov    0x8(%ebp),%edx
  804261:	89 10                	mov    %edx,(%eax)
  804263:	8b 45 08             	mov    0x8(%ebp),%eax
  804266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804269:	89 50 04             	mov    %edx,0x4(%eax)
  80426c:	8b 45 08             	mov    0x8(%ebp),%eax
  80426f:	8b 00                	mov    (%eax),%eax
  804271:	85 c0                	test   %eax,%eax
  804273:	75 08                	jne    80427d <insert_sorted_with_merge_freeList+0x3a7>
  804275:	8b 45 08             	mov    0x8(%ebp),%eax
  804278:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80427d:	a1 44 61 80 00       	mov    0x806144,%eax
  804282:	40                   	inc    %eax
  804283:	a3 44 61 80 00       	mov    %eax,0x806144
								break;
  804288:	e9 a2 03 00 00       	jmp    80462f <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80428d:	8b 45 08             	mov    0x8(%ebp),%eax
  804290:	8b 50 08             	mov    0x8(%eax),%edx
  804293:	8b 45 08             	mov    0x8(%ebp),%eax
  804296:	8b 40 0c             	mov    0xc(%eax),%eax
  804299:	01 c2                	add    %eax,%edx
  80429b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80429e:	8b 40 08             	mov    0x8(%eax),%eax
  8042a1:	39 c2                	cmp    %eax,%edx
  8042a3:	0f 83 ae 00 00 00    	jae    804357 <insert_sorted_with_merge_freeList+0x481>
  8042a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ac:	8b 50 08             	mov    0x8(%eax),%edx
  8042af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042b2:	8b 48 08             	mov    0x8(%eax),%ecx
  8042b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8042bb:	01 c8                	add    %ecx,%eax
  8042bd:	39 c2                	cmp    %eax,%edx
  8042bf:	0f 85 92 00 00 00    	jne    804357 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  8042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8042cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8042d1:	01 c2                	add    %eax,%edx
  8042d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042d6:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  8042d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8042dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8042e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8042e6:	8b 50 08             	mov    0x8(%eax),%edx
  8042e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ec:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8042ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042f3:	75 17                	jne    80430c <insert_sorted_with_merge_freeList+0x436>
  8042f5:	83 ec 04             	sub    $0x4,%esp
  8042f8:	68 d0 51 80 00       	push   $0x8051d0
  8042fd:	68 51 01 00 00       	push   $0x151
  804302:	68 f3 51 80 00       	push   $0x8051f3
  804307:	e8 1e d6 ff ff       	call   80192a <_panic>
  80430c:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804312:	8b 45 08             	mov    0x8(%ebp),%eax
  804315:	89 10                	mov    %edx,(%eax)
  804317:	8b 45 08             	mov    0x8(%ebp),%eax
  80431a:	8b 00                	mov    (%eax),%eax
  80431c:	85 c0                	test   %eax,%eax
  80431e:	74 0d                	je     80432d <insert_sorted_with_merge_freeList+0x457>
  804320:	a1 48 61 80 00       	mov    0x806148,%eax
  804325:	8b 55 08             	mov    0x8(%ebp),%edx
  804328:	89 50 04             	mov    %edx,0x4(%eax)
  80432b:	eb 08                	jmp    804335 <insert_sorted_with_merge_freeList+0x45f>
  80432d:	8b 45 08             	mov    0x8(%ebp),%eax
  804330:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804335:	8b 45 08             	mov    0x8(%ebp),%eax
  804338:	a3 48 61 80 00       	mov    %eax,0x806148
  80433d:	8b 45 08             	mov    0x8(%ebp),%eax
  804340:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804347:	a1 54 61 80 00       	mov    0x806154,%eax
  80434c:	40                   	inc    %eax
  80434d:	a3 54 61 80 00       	mov    %eax,0x806154
								 break;
  804352:	e9 d8 02 00 00       	jmp    80462f <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  804357:	8b 45 08             	mov    0x8(%ebp),%eax
  80435a:	8b 50 08             	mov    0x8(%eax),%edx
  80435d:	8b 45 08             	mov    0x8(%ebp),%eax
  804360:	8b 40 0c             	mov    0xc(%eax),%eax
  804363:	01 c2                	add    %eax,%edx
  804365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804368:	8b 40 08             	mov    0x8(%eax),%eax
  80436b:	39 c2                	cmp    %eax,%edx
  80436d:	0f 85 ba 00 00 00    	jne    80442d <insert_sorted_with_merge_freeList+0x557>
  804373:	8b 45 08             	mov    0x8(%ebp),%eax
  804376:	8b 50 08             	mov    0x8(%eax),%edx
  804379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80437c:	8b 48 08             	mov    0x8(%eax),%ecx
  80437f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804382:	8b 40 0c             	mov    0xc(%eax),%eax
  804385:	01 c8                	add    %ecx,%eax
  804387:	39 c2                	cmp    %eax,%edx
  804389:	0f 86 9e 00 00 00    	jbe    80442d <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  80438f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804392:	8b 50 0c             	mov    0xc(%eax),%edx
  804395:	8b 45 08             	mov    0x8(%ebp),%eax
  804398:	8b 40 0c             	mov    0xc(%eax),%eax
  80439b:	01 c2                	add    %eax,%edx
  80439d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043a0:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  8043a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8043a6:	8b 50 08             	mov    0x8(%eax),%edx
  8043a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043ac:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  8043af:	8b 45 08             	mov    0x8(%ebp),%eax
  8043b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8043b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8043bc:	8b 50 08             	mov    0x8(%eax),%edx
  8043bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8043c2:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8043c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8043c9:	75 17                	jne    8043e2 <insert_sorted_with_merge_freeList+0x50c>
  8043cb:	83 ec 04             	sub    $0x4,%esp
  8043ce:	68 d0 51 80 00       	push   $0x8051d0
  8043d3:	68 5b 01 00 00       	push   $0x15b
  8043d8:	68 f3 51 80 00       	push   $0x8051f3
  8043dd:	e8 48 d5 ff ff       	call   80192a <_panic>
  8043e2:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8043e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8043eb:	89 10                	mov    %edx,(%eax)
  8043ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8043f0:	8b 00                	mov    (%eax),%eax
  8043f2:	85 c0                	test   %eax,%eax
  8043f4:	74 0d                	je     804403 <insert_sorted_with_merge_freeList+0x52d>
  8043f6:	a1 48 61 80 00       	mov    0x806148,%eax
  8043fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8043fe:	89 50 04             	mov    %edx,0x4(%eax)
  804401:	eb 08                	jmp    80440b <insert_sorted_with_merge_freeList+0x535>
  804403:	8b 45 08             	mov    0x8(%ebp),%eax
  804406:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80440b:	8b 45 08             	mov    0x8(%ebp),%eax
  80440e:	a3 48 61 80 00       	mov    %eax,0x806148
  804413:	8b 45 08             	mov    0x8(%ebp),%eax
  804416:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80441d:	a1 54 61 80 00       	mov    0x806154,%eax
  804422:	40                   	inc    %eax
  804423:	a3 54 61 80 00       	mov    %eax,0x806154
								break;
  804428:	e9 02 02 00 00       	jmp    80462f <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80442d:	8b 45 08             	mov    0x8(%ebp),%eax
  804430:	8b 50 08             	mov    0x8(%eax),%edx
  804433:	8b 45 08             	mov    0x8(%ebp),%eax
  804436:	8b 40 0c             	mov    0xc(%eax),%eax
  804439:	01 c2                	add    %eax,%edx
  80443b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80443e:	8b 40 08             	mov    0x8(%eax),%eax
  804441:	39 c2                	cmp    %eax,%edx
  804443:	0f 85 ae 01 00 00    	jne    8045f7 <insert_sorted_with_merge_freeList+0x721>
  804449:	8b 45 08             	mov    0x8(%ebp),%eax
  80444c:	8b 50 08             	mov    0x8(%eax),%edx
  80444f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804452:	8b 48 08             	mov    0x8(%eax),%ecx
  804455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804458:	8b 40 0c             	mov    0xc(%eax),%eax
  80445b:	01 c8                	add    %ecx,%eax
  80445d:	39 c2                	cmp    %eax,%edx
  80445f:	0f 85 92 01 00 00    	jne    8045f7 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  804465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804468:	8b 50 0c             	mov    0xc(%eax),%edx
  80446b:	8b 45 08             	mov    0x8(%ebp),%eax
  80446e:	8b 40 0c             	mov    0xc(%eax),%eax
  804471:	01 c2                	add    %eax,%edx
  804473:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804476:	8b 40 0c             	mov    0xc(%eax),%eax
  804479:	01 c2                	add    %eax,%edx
  80447b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80447e:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  804481:	8b 45 08             	mov    0x8(%ebp),%eax
  804484:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80448b:	8b 45 08             	mov    0x8(%ebp),%eax
  80448e:	8b 50 08             	mov    0x8(%eax),%edx
  804491:	8b 45 08             	mov    0x8(%ebp),%eax
  804494:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  804497:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80449a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8044a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044a4:	8b 50 08             	mov    0x8(%eax),%edx
  8044a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044aa:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  8044ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8044b1:	75 17                	jne    8044ca <insert_sorted_with_merge_freeList+0x5f4>
  8044b3:	83 ec 04             	sub    $0x4,%esp
  8044b6:	68 9b 52 80 00       	push   $0x80529b
  8044bb:	68 63 01 00 00       	push   $0x163
  8044c0:	68 f3 51 80 00       	push   $0x8051f3
  8044c5:	e8 60 d4 ff ff       	call   80192a <_panic>
  8044ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044cd:	8b 00                	mov    (%eax),%eax
  8044cf:	85 c0                	test   %eax,%eax
  8044d1:	74 10                	je     8044e3 <insert_sorted_with_merge_freeList+0x60d>
  8044d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044d6:	8b 00                	mov    (%eax),%eax
  8044d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8044db:	8b 52 04             	mov    0x4(%edx),%edx
  8044de:	89 50 04             	mov    %edx,0x4(%eax)
  8044e1:	eb 0b                	jmp    8044ee <insert_sorted_with_merge_freeList+0x618>
  8044e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044e6:	8b 40 04             	mov    0x4(%eax),%eax
  8044e9:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8044ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044f1:	8b 40 04             	mov    0x4(%eax),%eax
  8044f4:	85 c0                	test   %eax,%eax
  8044f6:	74 0f                	je     804507 <insert_sorted_with_merge_freeList+0x631>
  8044f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044fb:	8b 40 04             	mov    0x4(%eax),%eax
  8044fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804501:	8b 12                	mov    (%edx),%edx
  804503:	89 10                	mov    %edx,(%eax)
  804505:	eb 0a                	jmp    804511 <insert_sorted_with_merge_freeList+0x63b>
  804507:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80450a:	8b 00                	mov    (%eax),%eax
  80450c:	a3 38 61 80 00       	mov    %eax,0x806138
  804511:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804514:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80451a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80451d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804524:	a1 44 61 80 00       	mov    0x806144,%eax
  804529:	48                   	dec    %eax
  80452a:	a3 44 61 80 00       	mov    %eax,0x806144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  80452f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804533:	75 17                	jne    80454c <insert_sorted_with_merge_freeList+0x676>
  804535:	83 ec 04             	sub    $0x4,%esp
  804538:	68 d0 51 80 00       	push   $0x8051d0
  80453d:	68 64 01 00 00       	push   $0x164
  804542:	68 f3 51 80 00       	push   $0x8051f3
  804547:	e8 de d3 ff ff       	call   80192a <_panic>
  80454c:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804552:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804555:	89 10                	mov    %edx,(%eax)
  804557:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80455a:	8b 00                	mov    (%eax),%eax
  80455c:	85 c0                	test   %eax,%eax
  80455e:	74 0d                	je     80456d <insert_sorted_with_merge_freeList+0x697>
  804560:	a1 48 61 80 00       	mov    0x806148,%eax
  804565:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804568:	89 50 04             	mov    %edx,0x4(%eax)
  80456b:	eb 08                	jmp    804575 <insert_sorted_with_merge_freeList+0x69f>
  80456d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804570:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804578:	a3 48 61 80 00       	mov    %eax,0x806148
  80457d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804580:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804587:	a1 54 61 80 00       	mov    0x806154,%eax
  80458c:	40                   	inc    %eax
  80458d:	a3 54 61 80 00       	mov    %eax,0x806154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  804592:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804596:	75 17                	jne    8045af <insert_sorted_with_merge_freeList+0x6d9>
  804598:	83 ec 04             	sub    $0x4,%esp
  80459b:	68 d0 51 80 00       	push   $0x8051d0
  8045a0:	68 65 01 00 00       	push   $0x165
  8045a5:	68 f3 51 80 00       	push   $0x8051f3
  8045aa:	e8 7b d3 ff ff       	call   80192a <_panic>
  8045af:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8045b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8045b8:	89 10                	mov    %edx,(%eax)
  8045ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8045bd:	8b 00                	mov    (%eax),%eax
  8045bf:	85 c0                	test   %eax,%eax
  8045c1:	74 0d                	je     8045d0 <insert_sorted_with_merge_freeList+0x6fa>
  8045c3:	a1 48 61 80 00       	mov    0x806148,%eax
  8045c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8045cb:	89 50 04             	mov    %edx,0x4(%eax)
  8045ce:	eb 08                	jmp    8045d8 <insert_sorted_with_merge_freeList+0x702>
  8045d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8045d3:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8045d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8045db:	a3 48 61 80 00       	mov    %eax,0x806148
  8045e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045ea:	a1 54 61 80 00       	mov    0x806154,%eax
  8045ef:	40                   	inc    %eax
  8045f0:	a3 54 61 80 00       	mov    %eax,0x806154
								break;
  8045f5:	eb 38                	jmp    80462f <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8045f7:	a1 40 61 80 00       	mov    0x806140,%eax
  8045fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8045ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804603:	74 07                	je     80460c <insert_sorted_with_merge_freeList+0x736>
  804605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804608:	8b 00                	mov    (%eax),%eax
  80460a:	eb 05                	jmp    804611 <insert_sorted_with_merge_freeList+0x73b>
  80460c:	b8 00 00 00 00       	mov    $0x0,%eax
  804611:	a3 40 61 80 00       	mov    %eax,0x806140
  804616:	a1 40 61 80 00       	mov    0x806140,%eax
  80461b:	85 c0                	test   %eax,%eax
  80461d:	0f 85 a7 fb ff ff    	jne    8041ca <insert_sorted_with_merge_freeList+0x2f4>
  804623:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804627:	0f 85 9d fb ff ff    	jne    8041ca <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80462d:	eb 00                	jmp    80462f <insert_sorted_with_merge_freeList+0x759>
  80462f:	90                   	nop
  804630:	c9                   	leave  
  804631:	c3                   	ret    
  804632:	66 90                	xchg   %ax,%ax

00804634 <__udivdi3>:
  804634:	55                   	push   %ebp
  804635:	57                   	push   %edi
  804636:	56                   	push   %esi
  804637:	53                   	push   %ebx
  804638:	83 ec 1c             	sub    $0x1c,%esp
  80463b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80463f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804643:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804647:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80464b:	89 ca                	mov    %ecx,%edx
  80464d:	89 f8                	mov    %edi,%eax
  80464f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804653:	85 f6                	test   %esi,%esi
  804655:	75 2d                	jne    804684 <__udivdi3+0x50>
  804657:	39 cf                	cmp    %ecx,%edi
  804659:	77 65                	ja     8046c0 <__udivdi3+0x8c>
  80465b:	89 fd                	mov    %edi,%ebp
  80465d:	85 ff                	test   %edi,%edi
  80465f:	75 0b                	jne    80466c <__udivdi3+0x38>
  804661:	b8 01 00 00 00       	mov    $0x1,%eax
  804666:	31 d2                	xor    %edx,%edx
  804668:	f7 f7                	div    %edi
  80466a:	89 c5                	mov    %eax,%ebp
  80466c:	31 d2                	xor    %edx,%edx
  80466e:	89 c8                	mov    %ecx,%eax
  804670:	f7 f5                	div    %ebp
  804672:	89 c1                	mov    %eax,%ecx
  804674:	89 d8                	mov    %ebx,%eax
  804676:	f7 f5                	div    %ebp
  804678:	89 cf                	mov    %ecx,%edi
  80467a:	89 fa                	mov    %edi,%edx
  80467c:	83 c4 1c             	add    $0x1c,%esp
  80467f:	5b                   	pop    %ebx
  804680:	5e                   	pop    %esi
  804681:	5f                   	pop    %edi
  804682:	5d                   	pop    %ebp
  804683:	c3                   	ret    
  804684:	39 ce                	cmp    %ecx,%esi
  804686:	77 28                	ja     8046b0 <__udivdi3+0x7c>
  804688:	0f bd fe             	bsr    %esi,%edi
  80468b:	83 f7 1f             	xor    $0x1f,%edi
  80468e:	75 40                	jne    8046d0 <__udivdi3+0x9c>
  804690:	39 ce                	cmp    %ecx,%esi
  804692:	72 0a                	jb     80469e <__udivdi3+0x6a>
  804694:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804698:	0f 87 9e 00 00 00    	ja     80473c <__udivdi3+0x108>
  80469e:	b8 01 00 00 00       	mov    $0x1,%eax
  8046a3:	89 fa                	mov    %edi,%edx
  8046a5:	83 c4 1c             	add    $0x1c,%esp
  8046a8:	5b                   	pop    %ebx
  8046a9:	5e                   	pop    %esi
  8046aa:	5f                   	pop    %edi
  8046ab:	5d                   	pop    %ebp
  8046ac:	c3                   	ret    
  8046ad:	8d 76 00             	lea    0x0(%esi),%esi
  8046b0:	31 ff                	xor    %edi,%edi
  8046b2:	31 c0                	xor    %eax,%eax
  8046b4:	89 fa                	mov    %edi,%edx
  8046b6:	83 c4 1c             	add    $0x1c,%esp
  8046b9:	5b                   	pop    %ebx
  8046ba:	5e                   	pop    %esi
  8046bb:	5f                   	pop    %edi
  8046bc:	5d                   	pop    %ebp
  8046bd:	c3                   	ret    
  8046be:	66 90                	xchg   %ax,%ax
  8046c0:	89 d8                	mov    %ebx,%eax
  8046c2:	f7 f7                	div    %edi
  8046c4:	31 ff                	xor    %edi,%edi
  8046c6:	89 fa                	mov    %edi,%edx
  8046c8:	83 c4 1c             	add    $0x1c,%esp
  8046cb:	5b                   	pop    %ebx
  8046cc:	5e                   	pop    %esi
  8046cd:	5f                   	pop    %edi
  8046ce:	5d                   	pop    %ebp
  8046cf:	c3                   	ret    
  8046d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8046d5:	89 eb                	mov    %ebp,%ebx
  8046d7:	29 fb                	sub    %edi,%ebx
  8046d9:	89 f9                	mov    %edi,%ecx
  8046db:	d3 e6                	shl    %cl,%esi
  8046dd:	89 c5                	mov    %eax,%ebp
  8046df:	88 d9                	mov    %bl,%cl
  8046e1:	d3 ed                	shr    %cl,%ebp
  8046e3:	89 e9                	mov    %ebp,%ecx
  8046e5:	09 f1                	or     %esi,%ecx
  8046e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8046eb:	89 f9                	mov    %edi,%ecx
  8046ed:	d3 e0                	shl    %cl,%eax
  8046ef:	89 c5                	mov    %eax,%ebp
  8046f1:	89 d6                	mov    %edx,%esi
  8046f3:	88 d9                	mov    %bl,%cl
  8046f5:	d3 ee                	shr    %cl,%esi
  8046f7:	89 f9                	mov    %edi,%ecx
  8046f9:	d3 e2                	shl    %cl,%edx
  8046fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046ff:	88 d9                	mov    %bl,%cl
  804701:	d3 e8                	shr    %cl,%eax
  804703:	09 c2                	or     %eax,%edx
  804705:	89 d0                	mov    %edx,%eax
  804707:	89 f2                	mov    %esi,%edx
  804709:	f7 74 24 0c          	divl   0xc(%esp)
  80470d:	89 d6                	mov    %edx,%esi
  80470f:	89 c3                	mov    %eax,%ebx
  804711:	f7 e5                	mul    %ebp
  804713:	39 d6                	cmp    %edx,%esi
  804715:	72 19                	jb     804730 <__udivdi3+0xfc>
  804717:	74 0b                	je     804724 <__udivdi3+0xf0>
  804719:	89 d8                	mov    %ebx,%eax
  80471b:	31 ff                	xor    %edi,%edi
  80471d:	e9 58 ff ff ff       	jmp    80467a <__udivdi3+0x46>
  804722:	66 90                	xchg   %ax,%ax
  804724:	8b 54 24 08          	mov    0x8(%esp),%edx
  804728:	89 f9                	mov    %edi,%ecx
  80472a:	d3 e2                	shl    %cl,%edx
  80472c:	39 c2                	cmp    %eax,%edx
  80472e:	73 e9                	jae    804719 <__udivdi3+0xe5>
  804730:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804733:	31 ff                	xor    %edi,%edi
  804735:	e9 40 ff ff ff       	jmp    80467a <__udivdi3+0x46>
  80473a:	66 90                	xchg   %ax,%ax
  80473c:	31 c0                	xor    %eax,%eax
  80473e:	e9 37 ff ff ff       	jmp    80467a <__udivdi3+0x46>
  804743:	90                   	nop

00804744 <__umoddi3>:
  804744:	55                   	push   %ebp
  804745:	57                   	push   %edi
  804746:	56                   	push   %esi
  804747:	53                   	push   %ebx
  804748:	83 ec 1c             	sub    $0x1c,%esp
  80474b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80474f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804753:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804757:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80475b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80475f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804763:	89 f3                	mov    %esi,%ebx
  804765:	89 fa                	mov    %edi,%edx
  804767:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80476b:	89 34 24             	mov    %esi,(%esp)
  80476e:	85 c0                	test   %eax,%eax
  804770:	75 1a                	jne    80478c <__umoddi3+0x48>
  804772:	39 f7                	cmp    %esi,%edi
  804774:	0f 86 a2 00 00 00    	jbe    80481c <__umoddi3+0xd8>
  80477a:	89 c8                	mov    %ecx,%eax
  80477c:	89 f2                	mov    %esi,%edx
  80477e:	f7 f7                	div    %edi
  804780:	89 d0                	mov    %edx,%eax
  804782:	31 d2                	xor    %edx,%edx
  804784:	83 c4 1c             	add    $0x1c,%esp
  804787:	5b                   	pop    %ebx
  804788:	5e                   	pop    %esi
  804789:	5f                   	pop    %edi
  80478a:	5d                   	pop    %ebp
  80478b:	c3                   	ret    
  80478c:	39 f0                	cmp    %esi,%eax
  80478e:	0f 87 ac 00 00 00    	ja     804840 <__umoddi3+0xfc>
  804794:	0f bd e8             	bsr    %eax,%ebp
  804797:	83 f5 1f             	xor    $0x1f,%ebp
  80479a:	0f 84 ac 00 00 00    	je     80484c <__umoddi3+0x108>
  8047a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8047a5:	29 ef                	sub    %ebp,%edi
  8047a7:	89 fe                	mov    %edi,%esi
  8047a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8047ad:	89 e9                	mov    %ebp,%ecx
  8047af:	d3 e0                	shl    %cl,%eax
  8047b1:	89 d7                	mov    %edx,%edi
  8047b3:	89 f1                	mov    %esi,%ecx
  8047b5:	d3 ef                	shr    %cl,%edi
  8047b7:	09 c7                	or     %eax,%edi
  8047b9:	89 e9                	mov    %ebp,%ecx
  8047bb:	d3 e2                	shl    %cl,%edx
  8047bd:	89 14 24             	mov    %edx,(%esp)
  8047c0:	89 d8                	mov    %ebx,%eax
  8047c2:	d3 e0                	shl    %cl,%eax
  8047c4:	89 c2                	mov    %eax,%edx
  8047c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047ca:	d3 e0                	shl    %cl,%eax
  8047cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8047d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047d4:	89 f1                	mov    %esi,%ecx
  8047d6:	d3 e8                	shr    %cl,%eax
  8047d8:	09 d0                	or     %edx,%eax
  8047da:	d3 eb                	shr    %cl,%ebx
  8047dc:	89 da                	mov    %ebx,%edx
  8047de:	f7 f7                	div    %edi
  8047e0:	89 d3                	mov    %edx,%ebx
  8047e2:	f7 24 24             	mull   (%esp)
  8047e5:	89 c6                	mov    %eax,%esi
  8047e7:	89 d1                	mov    %edx,%ecx
  8047e9:	39 d3                	cmp    %edx,%ebx
  8047eb:	0f 82 87 00 00 00    	jb     804878 <__umoddi3+0x134>
  8047f1:	0f 84 91 00 00 00    	je     804888 <__umoddi3+0x144>
  8047f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8047fb:	29 f2                	sub    %esi,%edx
  8047fd:	19 cb                	sbb    %ecx,%ebx
  8047ff:	89 d8                	mov    %ebx,%eax
  804801:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804805:	d3 e0                	shl    %cl,%eax
  804807:	89 e9                	mov    %ebp,%ecx
  804809:	d3 ea                	shr    %cl,%edx
  80480b:	09 d0                	or     %edx,%eax
  80480d:	89 e9                	mov    %ebp,%ecx
  80480f:	d3 eb                	shr    %cl,%ebx
  804811:	89 da                	mov    %ebx,%edx
  804813:	83 c4 1c             	add    $0x1c,%esp
  804816:	5b                   	pop    %ebx
  804817:	5e                   	pop    %esi
  804818:	5f                   	pop    %edi
  804819:	5d                   	pop    %ebp
  80481a:	c3                   	ret    
  80481b:	90                   	nop
  80481c:	89 fd                	mov    %edi,%ebp
  80481e:	85 ff                	test   %edi,%edi
  804820:	75 0b                	jne    80482d <__umoddi3+0xe9>
  804822:	b8 01 00 00 00       	mov    $0x1,%eax
  804827:	31 d2                	xor    %edx,%edx
  804829:	f7 f7                	div    %edi
  80482b:	89 c5                	mov    %eax,%ebp
  80482d:	89 f0                	mov    %esi,%eax
  80482f:	31 d2                	xor    %edx,%edx
  804831:	f7 f5                	div    %ebp
  804833:	89 c8                	mov    %ecx,%eax
  804835:	f7 f5                	div    %ebp
  804837:	89 d0                	mov    %edx,%eax
  804839:	e9 44 ff ff ff       	jmp    804782 <__umoddi3+0x3e>
  80483e:	66 90                	xchg   %ax,%ax
  804840:	89 c8                	mov    %ecx,%eax
  804842:	89 f2                	mov    %esi,%edx
  804844:	83 c4 1c             	add    $0x1c,%esp
  804847:	5b                   	pop    %ebx
  804848:	5e                   	pop    %esi
  804849:	5f                   	pop    %edi
  80484a:	5d                   	pop    %ebp
  80484b:	c3                   	ret    
  80484c:	3b 04 24             	cmp    (%esp),%eax
  80484f:	72 06                	jb     804857 <__umoddi3+0x113>
  804851:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804855:	77 0f                	ja     804866 <__umoddi3+0x122>
  804857:	89 f2                	mov    %esi,%edx
  804859:	29 f9                	sub    %edi,%ecx
  80485b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80485f:	89 14 24             	mov    %edx,(%esp)
  804862:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804866:	8b 44 24 04          	mov    0x4(%esp),%eax
  80486a:	8b 14 24             	mov    (%esp),%edx
  80486d:	83 c4 1c             	add    $0x1c,%esp
  804870:	5b                   	pop    %ebx
  804871:	5e                   	pop    %esi
  804872:	5f                   	pop    %edi
  804873:	5d                   	pop    %ebp
  804874:	c3                   	ret    
  804875:	8d 76 00             	lea    0x0(%esi),%esi
  804878:	2b 04 24             	sub    (%esp),%eax
  80487b:	19 fa                	sbb    %edi,%edx
  80487d:	89 d1                	mov    %edx,%ecx
  80487f:	89 c6                	mov    %eax,%esi
  804881:	e9 71 ff ff ff       	jmp    8047f7 <__umoddi3+0xb3>
  804886:	66 90                	xchg   %ax,%ax
  804888:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80488c:	72 ea                	jb     804878 <__umoddi3+0x134>
  80488e:	89 d9                	mov    %ebx,%ecx
  804890:	e9 62 ff ff ff       	jmp    8047f7 <__umoddi3+0xb3>
