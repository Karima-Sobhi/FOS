
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 4a 06 00 00       	call   800680 <libmain>
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
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 95 22 00 00       	call   8022df <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 40 37 80 00       	push   $0x803740
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 5c 37 80 00       	push   $0x80375c
  8000a7:	e8 10 07 00 00       	call   8007bc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 e6 18 00 00       	call   80199c <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 01 00 00 20       	push   $0x20000001
  8000e0:	e8 b7 18 00 00       	call   80199c <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 74 37 80 00       	push   $0x803774
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 5c 37 80 00       	push   $0x80375c
  800101:	e8 b6 06 00 00       	call   8007bc <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 bf 1c 00 00       	call   801dca <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 57 1d 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 75 18 00 00       	call   80199c <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 b8 37 80 00       	push   $0x8037b8
  80013f:	6a 31                	push   $0x31
  800141:	68 5c 37 80 00       	push   $0x80375c
  800146:	e8 71 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014b:	e8 1a 1d 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800150:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 e8 37 80 00       	push   $0x8037e8
  80015d:	6a 33                	push   $0x33
  80015f:	68 5c 37 80 00       	push   $0x80375c
  800164:	e8 53 06 00 00       	call   8007bc <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 5c 1c 00 00       	call   801dca <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 f4 1c 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	01 c0                	add    %eax,%eax
  80017e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	e8 12 18 00 00       	call   80199c <malloc>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	05 00 00 00 80       	add    $0x80000000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 b8 37 80 00       	push   $0x8037b8
  8001ab:	6a 39                	push   $0x39
  8001ad:	68 5c 37 80 00       	push   $0x80375c
  8001b2:	e8 05 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b7:	e8 ae 1c 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  8001bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 e8 37 80 00       	push   $0x8037e8
  8001c9:	6a 3b                	push   $0x3b
  8001cb:	68 5c 37 80 00       	push   $0x80375c
  8001d0:	e8 e7 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001d5:	e8 f0 1b 00 00       	call   801dca <sys_calculate_free_frames>
  8001da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dd:	e8 88 1c 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  8001e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001e8:	89 c2                	mov    %eax,%edx
  8001ea:	01 d2                	add    %edx,%edx
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 a5 17 00 00       	call   80199c <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8001fd:	8b 45 98             	mov    -0x68(%ebp),%eax
  800200:	89 c2                	mov    %eax,%edx
  800202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800205:	c1 e0 02             	shl    $0x2,%eax
  800208:	05 00 00 00 80       	add    $0x80000000,%eax
  80020d:	39 c2                	cmp    %eax,%edx
  80020f:	74 14                	je     800225 <_main+0x1ed>
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	68 b8 37 80 00       	push   $0x8037b8
  800219:	6a 41                	push   $0x41
  80021b:	68 5c 37 80 00       	push   $0x80375c
  800220:	e8 97 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800225:	e8 40 1c 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  80022a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 e8 37 80 00       	push   $0x8037e8
  800237:	6a 43                	push   $0x43
  800239:	68 5c 37 80 00       	push   $0x80375c
  80023e:	e8 79 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800243:	e8 82 1b 00 00       	call   801dca <sys_calculate_free_frames>
  800248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024b:	e8 1a 1c 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800250:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	e8 37 17 00 00       	call   80199c <malloc>
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  80026b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80026e:	89 c2                	mov    %eax,%edx
  800270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800273:	c1 e0 02             	shl    $0x2,%eax
  800276:	89 c1                	mov    %eax,%ecx
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	c1 e0 02             	shl    $0x2,%eax
  80027e:	01 c8                	add    %ecx,%eax
  800280:	05 00 00 00 80       	add    $0x80000000,%eax
  800285:	39 c2                	cmp    %eax,%edx
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 b8 37 80 00       	push   $0x8037b8
  800291:	6a 49                	push   $0x49
  800293:	68 5c 37 80 00       	push   $0x80375c
  800298:	e8 1f 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80029d:	e8 c8 1b 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  8002a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 e8 37 80 00       	push   $0x8037e8
  8002af:	6a 4b                	push   $0x4b
  8002b1:	68 5c 37 80 00       	push   $0x80375c
  8002b6:	e8 01 05 00 00       	call   8007bc <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002bb:	e8 0a 1b 00 00       	call   801dca <sys_calculate_free_frames>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 a2 1b 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	e8 40 17 00 00       	call   801a17 <free>
  8002d7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8002da:	e8 8b 1b 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  8002df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002e2:	74 14                	je     8002f8 <_main+0x2c0>
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 05 38 80 00       	push   $0x803805
  8002ec:	6a 52                	push   $0x52
  8002ee:	68 5c 37 80 00       	push   $0x80375c
  8002f3:	e8 c4 04 00 00       	call   8007bc <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f8:	e8 cd 1a 00 00       	call   801dca <sys_calculate_free_frames>
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800300:	e8 65 1b 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800305:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800308:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80030b:	89 d0                	mov    %edx,%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	01 d0                	add    %edx,%eax
  800311:	01 c0                	add    %eax,%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	50                   	push   %eax
  800319:	e8 7e 16 00 00       	call   80199c <malloc>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800324:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800327:	89 c2                	mov    %eax,%edx
  800329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032c:	c1 e0 02             	shl    $0x2,%eax
  80032f:	89 c1                	mov    %eax,%ecx
  800331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800334:	c1 e0 03             	shl    $0x3,%eax
  800337:	01 c8                	add    %ecx,%eax
  800339:	05 00 00 00 80       	add    $0x80000000,%eax
  80033e:	39 c2                	cmp    %eax,%edx
  800340:	74 14                	je     800356 <_main+0x31e>
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	68 b8 37 80 00       	push   $0x8037b8
  80034a:	6a 58                	push   $0x58
  80034c:	68 5c 37 80 00       	push   $0x80375c
  800351:	e8 66 04 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800356:	e8 0f 1b 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  80035b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80035e:	74 14                	je     800374 <_main+0x33c>
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 e8 37 80 00       	push   $0x8037e8
  800368:	6a 5a                	push   $0x5a
  80036a:	68 5c 37 80 00       	push   $0x80375c
  80036f:	e8 48 04 00 00       	call   8007bc <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800374:	e8 51 1a 00 00       	call   801dca <sys_calculate_free_frames>
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037c:	e8 e9 1a 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800384:	8b 45 90             	mov    -0x70(%ebp),%eax
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	e8 87 16 00 00       	call   801a17 <free>
  800390:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  800393:	e8 d2 1a 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800398:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 05 38 80 00       	push   $0x803805
  8003a5:	6a 61                	push   $0x61
  8003a7:	68 5c 37 80 00       	push   $0x80375c
  8003ac:	e8 0b 04 00 00       	call   8007bc <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b1:	e8 14 1a 00 00       	call   801dca <sys_calculate_free_frames>
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b9:	e8 ac 1a 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  8003be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003c4:	89 c2                	mov    %eax,%edx
  8003c6:	01 d2                	add    %edx,%edx
  8003c8:	01 d0                	add    %edx,%eax
  8003ca:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	50                   	push   %eax
  8003d1:	e8 c6 15 00 00       	call   80199c <malloc>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003dc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	c1 e0 02             	shl    $0x2,%eax
  8003e7:	89 c1                	mov    %eax,%ecx
  8003e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ec:	c1 e0 04             	shl    $0x4,%eax
  8003ef:	01 c8                	add    %ecx,%eax
  8003f1:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	74 14                	je     80040e <_main+0x3d6>
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	68 b8 37 80 00       	push   $0x8037b8
  800402:	6a 67                	push   $0x67
  800404:	68 5c 37 80 00       	push   $0x80375c
  800409:	e8 ae 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80040e:	e8 57 1a 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800413:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 e8 37 80 00       	push   $0x8037e8
  800420:	6a 69                	push   $0x69
  800422:	68 5c 37 80 00       	push   $0x80375c
  800427:	e8 90 03 00 00       	call   8007bc <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80042c:	e8 99 19 00 00       	call   801dca <sys_calculate_free_frames>
  800431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800434:	e8 31 1a 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800439:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	89 c2                	mov    %eax,%edx
  800441:	01 d2                	add    %edx,%edx
  800443:	01 c2                	add    %eax,%edx
  800445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800448:	01 d0                	add    %edx,%eax
  80044a:	01 c0                	add    %eax,%eax
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	50                   	push   %eax
  800450:	e8 47 15 00 00       	call   80199c <malloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80045b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	89 c2                	mov    %eax,%edx
  80046f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800472:	c1 e0 04             	shl    $0x4,%eax
  800475:	01 d0                	add    %edx,%eax
  800477:	05 00 00 00 80       	add    $0x80000000,%eax
  80047c:	39 c1                	cmp    %eax,%ecx
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 b8 37 80 00       	push   $0x8037b8
  800488:	6a 6f                	push   $0x6f
  80048a:	68 5c 37 80 00       	push   $0x80375c
  80048f:	e8 28 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800494:	e8 d1 19 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800499:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80049c:	74 14                	je     8004b2 <_main+0x47a>
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 e8 37 80 00       	push   $0x8037e8
  8004a6:	6a 71                	push   $0x71
  8004a8:	68 5c 37 80 00       	push   $0x80375c
  8004ad:	e8 0a 03 00 00       	call   8007bc <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 13 19 00 00       	call   801dca <sys_calculate_free_frames>
  8004b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ba:	e8 ab 19 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 49 15 00 00       	call   801a17 <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004d1:	e8 94 19 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  8004d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 05 38 80 00       	push   $0x803805
  8004e3:	6a 78                	push   $0x78
  8004e5:	68 5c 37 80 00       	push   $0x80375c
  8004ea:	e8 cd 02 00 00       	call   8007bc <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 d6 18 00 00       	call   801dca <sys_calculate_free_frames>
  8004f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 6e 19 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8004ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 0c 15 00 00       	call   801a17 <free>
  80050b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  80050e:	e8 57 19 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800513:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 05 38 80 00       	push   $0x803805
  800520:	6a 7f                	push   $0x7f
  800522:	68 5c 37 80 00       	push   $0x80375c
  800527:	e8 90 02 00 00       	call   8007bc <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 99 18 00 00       	call   801dca <sys_calculate_free_frames>
  800531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800534:	e8 31 19 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800539:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  80053c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	c1 e0 02             	shl    $0x2,%eax
  800544:	01 d0                	add    %edx,%eax
  800546:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	50                   	push   %eax
  80054d:	e8 4a 14 00 00       	call   80199c <malloc>
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800558:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 03             	shl    $0x3,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	89 c3                	mov    %eax,%ebx
  800569:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056c:	89 d0                	mov    %edx,%eax
  80056e:	01 c0                	add    %eax,%eax
  800570:	01 d0                	add    %edx,%eax
  800572:	c1 e0 03             	shl    $0x3,%eax
  800575:	01 d8                	add    %ebx,%eax
  800577:	05 00 00 00 80       	add    $0x80000000,%eax
  80057c:	39 c1                	cmp    %eax,%ecx
  80057e:	74 17                	je     800597 <_main+0x55f>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 b8 37 80 00       	push   $0x8037b8
  800588:	68 85 00 00 00       	push   $0x85
  80058d:	68 5c 37 80 00       	push   $0x80375c
  800592:	e8 25 02 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800597:	e8 ce 18 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  80059c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059f:	74 17                	je     8005b8 <_main+0x580>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 e8 37 80 00       	push   $0x8037e8
  8005a9:	68 87 00 00 00       	push   $0x87
  8005ae:	68 5c 37 80 00       	push   $0x80375c
  8005b3:	e8 04 02 00 00       	call   8007bc <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8005b8:	e8 0d 18 00 00       	call   801dca <sys_calculate_free_frames>
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c0:	e8 a5 18 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  8005c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(3*Mega-kilo);
  8005c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cb:	89 c2                	mov    %eax,%edx
  8005cd:	01 d2                	add    %edx,%edx
  8005cf:	01 d0                	add    %edx,%eax
  8005d1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8005d4:	83 ec 0c             	sub    $0xc,%esp
  8005d7:	50                   	push   %eax
  8005d8:	e8 bf 13 00 00       	call   80199c <malloc>
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8005e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005e6:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8005eb:	74 17                	je     800604 <_main+0x5cc>
  8005ed:	83 ec 04             	sub    $0x4,%esp
  8005f0:	68 b8 37 80 00       	push   $0x8037b8
  8005f5:	68 95 00 00 00       	push   $0x95
  8005fa:	68 5c 37 80 00       	push   $0x80375c
  8005ff:	e8 b8 01 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800604:	e8 61 18 00 00       	call   801e6a <sys_pf_calculate_allocated_pages>
  800609:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 e8 37 80 00       	push   $0x8037e8
  800616:	68 97 00 00 00       	push   $0x97
  80061b:	68 5c 37 80 00       	push   $0x80375c
  800620:	e8 97 01 00 00       	call   8007bc <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800625:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	01 d0                	add    %edx,%eax
  800632:	01 c0                	add    %eax,%eax
  800634:	f7 d8                	neg    %eax
  800636:	05 00 00 00 20       	add    $0x20000000,%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 58 13 00 00       	call   80199c <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  80064a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80064d:	85 c0                	test   %eax,%eax
  80064f:	74 17                	je     800668 <_main+0x630>
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	68 1c 38 80 00       	push   $0x80381c
  800659:	68 a0 00 00 00       	push   $0xa0
  80065e:	68 5c 37 80 00       	push   $0x80375c
  800663:	e8 54 01 00 00       	call   8007bc <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	68 80 38 80 00       	push   $0x803880
  800670:	e8 fb 03 00 00       	call   800a70 <cprintf>
  800675:	83 c4 10             	add    $0x10,%esp

		return;
  800678:	90                   	nop
	}
}
  800679:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80067c:	5b                   	pop    %ebx
  80067d:	5f                   	pop    %edi
  80067e:	5d                   	pop    %ebp
  80067f:	c3                   	ret    

00800680 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
  800683:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800686:	e8 1f 1a 00 00       	call   8020aa <sys_getenvindex>
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80068e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800691:	89 d0                	mov    %edx,%eax
  800693:	c1 e0 03             	shl    $0x3,%eax
  800696:	01 d0                	add    %edx,%eax
  800698:	01 c0                	add    %eax,%eax
  80069a:	01 d0                	add    %edx,%eax
  80069c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a3:	01 d0                	add    %edx,%eax
  8006a5:	c1 e0 04             	shl    $0x4,%eax
  8006a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006ad:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8006bd:	84 c0                	test   %al,%al
  8006bf:	74 0f                	je     8006d0 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	05 5c 05 00 00       	add    $0x55c,%eax
  8006cb:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006d4:	7e 0a                	jle    8006e0 <libmain+0x60>
		binaryname = argv[0];
  8006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 4a f9 ff ff       	call   800038 <_main>
  8006ee:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006f1:	e8 c1 17 00 00       	call   801eb7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	68 e4 38 80 00       	push   $0x8038e4
  8006fe:	e8 6d 03 00 00       	call   800a70 <cprintf>
  800703:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800706:	a1 20 50 80 00       	mov    0x805020,%eax
  80070b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800711:	a1 20 50 80 00       	mov    0x805020,%eax
  800716:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80071c:	83 ec 04             	sub    $0x4,%esp
  80071f:	52                   	push   %edx
  800720:	50                   	push   %eax
  800721:	68 0c 39 80 00       	push   $0x80390c
  800726:	e8 45 03 00 00       	call   800a70 <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80072e:	a1 20 50 80 00       	mov    0x805020,%eax
  800733:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800739:	a1 20 50 80 00       	mov    0x805020,%eax
  80073e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800744:	a1 20 50 80 00       	mov    0x805020,%eax
  800749:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80074f:	51                   	push   %ecx
  800750:	52                   	push   %edx
  800751:	50                   	push   %eax
  800752:	68 34 39 80 00       	push   $0x803934
  800757:	e8 14 03 00 00       	call   800a70 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80075f:	a1 20 50 80 00       	mov    0x805020,%eax
  800764:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 8c 39 80 00       	push   $0x80398c
  800773:	e8 f8 02 00 00       	call   800a70 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 e4 38 80 00       	push   $0x8038e4
  800783:	e8 e8 02 00 00       	call   800a70 <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80078b:	e8 41 17 00 00       	call   801ed1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800790:	e8 19 00 00 00       	call   8007ae <exit>
}
  800795:	90                   	nop
  800796:	c9                   	leave  
  800797:	c3                   	ret    

00800798 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	e8 ce 18 00 00       	call   802076 <sys_destroy_env>
  8007a8:	83 c4 10             	add    $0x10,%esp
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <exit>:

void
exit(void)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b4:	e8 23 19 00 00       	call   8020dc <sys_exit_env>
}
  8007b9:	90                   	nop
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 16                	je     8007ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	50                   	push   %eax
  8007dd:	68 a0 39 80 00       	push   $0x8039a0
  8007e2:	e8 89 02 00 00       	call   800a70 <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	50                   	push   %eax
  8007f6:	68 a5 39 80 00       	push   $0x8039a5
  8007fb:	e8 70 02 00 00       	call   800a70 <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800803:	8b 45 10             	mov    0x10(%ebp),%eax
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 f4             	pushl  -0xc(%ebp)
  80080c:	50                   	push   %eax
  80080d:	e8 f3 01 00 00       	call   800a05 <vcprintf>
  800812:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	6a 00                	push   $0x0
  80081a:	68 c1 39 80 00       	push   $0x8039c1
  80081f:	e8 e1 01 00 00       	call   800a05 <vcprintf>
  800824:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800827:	e8 82 ff ff ff       	call   8007ae <exit>

	// should not return here
	while (1) ;
  80082c:	eb fe                	jmp    80082c <_panic+0x70>

0080082e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 50 74             	mov    0x74(%eax),%edx
  80083c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083f:	39 c2                	cmp    %eax,%edx
  800841:	74 14                	je     800857 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	68 c4 39 80 00       	push   $0x8039c4
  80084b:	6a 26                	push   $0x26
  80084d:	68 10 3a 80 00       	push   $0x803a10
  800852:	e8 65 ff ff ff       	call   8007bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80085e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800865:	e9 c2 00 00 00       	jmp    80092c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80086a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	01 d0                	add    %edx,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	85 c0                	test   %eax,%eax
  80087d:	75 08                	jne    800887 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80087f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800882:	e9 a2 00 00 00       	jmp    800929 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800887:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800895:	eb 69                	jmp    800900 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800897:	a1 20 50 80 00       	mov    0x805020,%eax
  80089c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a5:	89 d0                	mov    %edx,%eax
  8008a7:	01 c0                	add    %eax,%eax
  8008a9:	01 d0                	add    %edx,%eax
  8008ab:	c1 e0 03             	shl    $0x3,%eax
  8008ae:	01 c8                	add    %ecx,%eax
  8008b0:	8a 40 04             	mov    0x4(%eax),%al
  8008b3:	84 c0                	test   %al,%al
  8008b5:	75 46                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8008bc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c5:	89 d0                	mov    %edx,%eax
  8008c7:	01 c0                	add    %eax,%eax
  8008c9:	01 d0                	add    %edx,%eax
  8008cb:	c1 e0 03             	shl    $0x3,%eax
  8008ce:	01 c8                	add    %ecx,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008dd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	01 c8                	add    %ecx,%eax
  8008ee:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	75 09                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008f4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008fb:	eb 12                	jmp    80090f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fd:	ff 45 e8             	incl   -0x18(%ebp)
  800900:	a1 20 50 80 00       	mov    0x805020,%eax
  800905:	8b 50 74             	mov    0x74(%eax),%edx
  800908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80090b:	39 c2                	cmp    %eax,%edx
  80090d:	77 88                	ja     800897 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80090f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800913:	75 14                	jne    800929 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 1c 3a 80 00       	push   $0x803a1c
  80091d:	6a 3a                	push   $0x3a
  80091f:	68 10 3a 80 00       	push   $0x803a10
  800924:	e8 93 fe ff ff       	call   8007bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800929:	ff 45 f0             	incl   -0x10(%ebp)
  80092c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800932:	0f 8c 32 ff ff ff    	jl     80086a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800938:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80093f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800946:	eb 26                	jmp    80096e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800948:	a1 20 50 80 00       	mov    0x805020,%eax
  80094d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800953:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800956:	89 d0                	mov    %edx,%eax
  800958:	01 c0                	add    %eax,%eax
  80095a:	01 d0                	add    %edx,%eax
  80095c:	c1 e0 03             	shl    $0x3,%eax
  80095f:	01 c8                	add    %ecx,%eax
  800961:	8a 40 04             	mov    0x4(%eax),%al
  800964:	3c 01                	cmp    $0x1,%al
  800966:	75 03                	jne    80096b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800968:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096b:	ff 45 e0             	incl   -0x20(%ebp)
  80096e:	a1 20 50 80 00       	mov    0x805020,%eax
  800973:	8b 50 74             	mov    0x74(%eax),%edx
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	77 cb                	ja     800948 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800980:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800983:	74 14                	je     800999 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 70 3a 80 00       	push   $0x803a70
  80098d:	6a 44                	push   $0x44
  80098f:	68 10 3a 80 00       	push   $0x803a10
  800994:	e8 23 fe ff ff       	call   8007bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800999:	90                   	nop
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ad:	89 0a                	mov    %ecx,(%edx)
  8009af:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b2:	88 d1                	mov    %dl,%cl
  8009b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c5:	75 2c                	jne    8009f3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009c7:	a0 24 50 80 00       	mov    0x805024,%al
  8009cc:	0f b6 c0             	movzbl %al,%eax
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d2:	8b 12                	mov    (%edx),%edx
  8009d4:	89 d1                	mov    %edx,%ecx
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d9:	83 c2 08             	add    $0x8,%edx
  8009dc:	83 ec 04             	sub    $0x4,%esp
  8009df:	50                   	push   %eax
  8009e0:	51                   	push   %ecx
  8009e1:	52                   	push   %edx
  8009e2:	e8 22 13 00 00       	call   801d09 <sys_cputs>
  8009e7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	8b 40 04             	mov    0x4(%eax),%eax
  8009f9:	8d 50 01             	lea    0x1(%eax),%edx
  8009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ff:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a02:	90                   	nop
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a0e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a15:	00 00 00 
	b.cnt = 0;
  800a18:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a1f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	ff 75 08             	pushl  0x8(%ebp)
  800a28:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2e:	50                   	push   %eax
  800a2f:	68 9c 09 80 00       	push   $0x80099c
  800a34:	e8 11 02 00 00       	call   800c4a <vprintfmt>
  800a39:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a3c:	a0 24 50 80 00       	mov    0x805024,%al
  800a41:	0f b6 c0             	movzbl %al,%eax
  800a44:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a4a:	83 ec 04             	sub    $0x4,%esp
  800a4d:	50                   	push   %eax
  800a4e:	52                   	push   %edx
  800a4f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a55:	83 c0 08             	add    $0x8,%eax
  800a58:	50                   	push   %eax
  800a59:	e8 ab 12 00 00       	call   801d09 <sys_cputs>
  800a5e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a61:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a68:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a76:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 73 ff ff ff       	call   800a05 <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800aa3:	e8 0f 14 00 00       	call   801eb7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800aa8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	50                   	push   %eax
  800ab8:	e8 48 ff ff ff       	call   800a05 <vcprintf>
  800abd:	83 c4 10             	add    $0x10,%esp
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ac3:	e8 09 14 00 00       	call   801ed1 <sys_enable_interrupt>
	return cnt;
  800ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    

00800acd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	53                   	push   %ebx
  800ad1:	83 ec 14             	sub    $0x14,%esp
  800ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ae0:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aeb:	77 55                	ja     800b42 <printnum+0x75>
  800aed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800af0:	72 05                	jb     800af7 <printnum+0x2a>
  800af2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800af5:	77 4b                	ja     800b42 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800af7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800afa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800afd:	8b 45 18             	mov    0x18(%ebp),%eax
  800b00:	ba 00 00 00 00       	mov    $0x0,%edx
  800b05:	52                   	push   %edx
  800b06:	50                   	push   %eax
  800b07:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b0d:	e8 b2 29 00 00       	call   8034c4 <__udivdi3>
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	ff 75 20             	pushl  0x20(%ebp)
  800b1b:	53                   	push   %ebx
  800b1c:	ff 75 18             	pushl  0x18(%ebp)
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	ff 75 08             	pushl  0x8(%ebp)
  800b27:	e8 a1 ff ff ff       	call   800acd <printnum>
  800b2c:	83 c4 20             	add    $0x20,%esp
  800b2f:	eb 1a                	jmp    800b4b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 20             	pushl  0x20(%ebp)
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b42:	ff 4d 1c             	decl   0x1c(%ebp)
  800b45:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b49:	7f e6                	jg     800b31 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b4b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b59:	53                   	push   %ebx
  800b5a:	51                   	push   %ecx
  800b5b:	52                   	push   %edx
  800b5c:	50                   	push   %eax
  800b5d:	e8 72 2a 00 00       	call   8035d4 <__umoddi3>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	05 d4 3c 80 00       	add    $0x803cd4,%eax
  800b6a:	8a 00                	mov    (%eax),%al
  800b6c:	0f be c0             	movsbl %al,%eax
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	50                   	push   %eax
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
}
  800b7e:	90                   	nop
  800b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b87:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8b:	7e 1c                	jle    800ba9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	8d 50 08             	lea    0x8(%eax),%edx
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	89 10                	mov    %edx,(%eax)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	83 e8 08             	sub    $0x8,%eax
  800ba2:	8b 50 04             	mov    0x4(%eax),%edx
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	eb 40                	jmp    800be9 <getuint+0x65>
	else if (lflag)
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	74 1e                	je     800bcd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	8d 50 04             	lea    0x4(%eax),%edx
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	89 10                	mov    %edx,(%eax)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	83 e8 04             	sub    $0x4,%eax
  800bc4:	8b 00                	mov    (%eax),%eax
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	eb 1c                	jmp    800be9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf2:	7e 1c                	jle    800c10 <getint+0x25>
		return va_arg(*ap, long long);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 08             	lea    0x8(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 08             	sub    $0x8,%eax
  800c09:	8b 50 04             	mov    0x4(%eax),%edx
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	eb 38                	jmp    800c48 <getint+0x5d>
	else if (lflag)
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	74 1a                	je     800c30 <getint+0x45>
		return va_arg(*ap, long);
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	8d 50 04             	lea    0x4(%eax),%edx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 10                	mov    %edx,(%eax)
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	83 e8 04             	sub    $0x4,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	99                   	cltd   
  800c2e:	eb 18                	jmp    800c48 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	8d 50 04             	lea    0x4(%eax),%edx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 10                	mov    %edx,(%eax)
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	83 e8 04             	sub    $0x4,%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	99                   	cltd   
}
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c52:	eb 17                	jmp    800c6b <vprintfmt+0x21>
			if (ch == '\0')
  800c54:	85 db                	test   %ebx,%ebx
  800c56:	0f 84 af 03 00 00    	je     80100b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	53                   	push   %ebx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6e:	8d 50 01             	lea    0x1(%eax),%edx
  800c71:	89 55 10             	mov    %edx,0x10(%ebp)
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	0f b6 d8             	movzbl %al,%ebx
  800c79:	83 fb 25             	cmp    $0x25,%ebx
  800c7c:	75 d6                	jne    800c54 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c7e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c82:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c90:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca1:	8d 50 01             	lea    0x1(%eax),%edx
  800ca4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	0f b6 d8             	movzbl %al,%ebx
  800cac:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800caf:	83 f8 55             	cmp    $0x55,%eax
  800cb2:	0f 87 2b 03 00 00    	ja     800fe3 <vprintfmt+0x399>
  800cb8:	8b 04 85 f8 3c 80 00 	mov    0x803cf8(,%eax,4),%eax
  800cbf:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cc1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cc5:	eb d7                	jmp    800c9e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cc7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ccb:	eb d1                	jmp    800c9e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cd7:	89 d0                	mov    %edx,%eax
  800cd9:	c1 e0 02             	shl    $0x2,%eax
  800cdc:	01 d0                	add    %edx,%eax
  800cde:	01 c0                	add    %eax,%eax
  800ce0:	01 d8                	add    %ebx,%eax
  800ce2:	83 e8 30             	sub    $0x30,%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cf0:	83 fb 2f             	cmp    $0x2f,%ebx
  800cf3:	7e 3e                	jle    800d33 <vprintfmt+0xe9>
  800cf5:	83 fb 39             	cmp    $0x39,%ebx
  800cf8:	7f 39                	jg     800d33 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cfa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cfd:	eb d5                	jmp    800cd4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	83 c0 04             	add    $0x4,%eax
  800d05:	89 45 14             	mov    %eax,0x14(%ebp)
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d13:	eb 1f                	jmp    800d34 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	79 83                	jns    800c9e <vprintfmt+0x54>
				width = 0;
  800d1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d22:	e9 77 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d27:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d2e:	e9 6b ff ff ff       	jmp    800c9e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d33:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d38:	0f 89 60 ff ff ff    	jns    800c9e <vprintfmt+0x54>
				width = precision, precision = -1;
  800d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d44:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d4b:	e9 4e ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d50:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d53:	e9 46 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	83 c0 04             	add    $0x4,%eax
  800d5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d61:	8b 45 14             	mov    0x14(%ebp),%eax
  800d64:	83 e8 04             	sub    $0x4,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	ff 75 0c             	pushl  0xc(%ebp)
  800d6f:	50                   	push   %eax
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	ff d0                	call   *%eax
  800d75:	83 c4 10             	add    $0x10,%esp
			break;
  800d78:	e9 89 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	83 c0 04             	add    $0x4,%eax
  800d83:	89 45 14             	mov    %eax,0x14(%ebp)
  800d86:	8b 45 14             	mov    0x14(%ebp),%eax
  800d89:	83 e8 04             	sub    $0x4,%eax
  800d8c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d8e:	85 db                	test   %ebx,%ebx
  800d90:	79 02                	jns    800d94 <vprintfmt+0x14a>
				err = -err;
  800d92:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d94:	83 fb 64             	cmp    $0x64,%ebx
  800d97:	7f 0b                	jg     800da4 <vprintfmt+0x15a>
  800d99:	8b 34 9d 40 3b 80 00 	mov    0x803b40(,%ebx,4),%esi
  800da0:	85 f6                	test   %esi,%esi
  800da2:	75 19                	jne    800dbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da4:	53                   	push   %ebx
  800da5:	68 e5 3c 80 00       	push   $0x803ce5
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	ff 75 08             	pushl  0x8(%ebp)
  800db0:	e8 5e 02 00 00       	call   801013 <printfmt>
  800db5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800db8:	e9 49 02 00 00       	jmp    801006 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dbd:	56                   	push   %esi
  800dbe:	68 ee 3c 80 00       	push   $0x803cee
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	ff 75 08             	pushl  0x8(%ebp)
  800dc9:	e8 45 02 00 00       	call   801013 <printfmt>
  800dce:	83 c4 10             	add    $0x10,%esp
			break;
  800dd1:	e9 30 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd9:	83 c0 04             	add    $0x4,%eax
  800ddc:	89 45 14             	mov    %eax,0x14(%ebp)
  800ddf:	8b 45 14             	mov    0x14(%ebp),%eax
  800de2:	83 e8 04             	sub    $0x4,%eax
  800de5:	8b 30                	mov    (%eax),%esi
  800de7:	85 f6                	test   %esi,%esi
  800de9:	75 05                	jne    800df0 <vprintfmt+0x1a6>
				p = "(null)";
  800deb:	be f1 3c 80 00       	mov    $0x803cf1,%esi
			if (width > 0 && padc != '-')
  800df0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df4:	7e 6d                	jle    800e63 <vprintfmt+0x219>
  800df6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dfa:	74 67                	je     800e63 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	50                   	push   %eax
  800e03:	56                   	push   %esi
  800e04:	e8 0c 03 00 00       	call   801115 <strnlen>
  800e09:	83 c4 10             	add    $0x10,%esp
  800e0c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e0f:	eb 16                	jmp    800e27 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e11:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2b:	7f e4                	jg     800e11 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2d:	eb 34                	jmp    800e63 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e33:	74 1c                	je     800e51 <vprintfmt+0x207>
  800e35:	83 fb 1f             	cmp    $0x1f,%ebx
  800e38:	7e 05                	jle    800e3f <vprintfmt+0x1f5>
  800e3a:	83 fb 7e             	cmp    $0x7e,%ebx
  800e3d:	7e 12                	jle    800e51 <vprintfmt+0x207>
					putch('?', putdat);
  800e3f:	83 ec 08             	sub    $0x8,%esp
  800e42:	ff 75 0c             	pushl  0xc(%ebp)
  800e45:	6a 3f                	push   $0x3f
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	ff d0                	call   *%eax
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	eb 0f                	jmp    800e60 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	53                   	push   %ebx
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	ff d0                	call   *%eax
  800e5d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e60:	ff 4d e4             	decl   -0x1c(%ebp)
  800e63:	89 f0                	mov    %esi,%eax
  800e65:	8d 70 01             	lea    0x1(%eax),%esi
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f be d8             	movsbl %al,%ebx
  800e6d:	85 db                	test   %ebx,%ebx
  800e6f:	74 24                	je     800e95 <vprintfmt+0x24b>
  800e71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e75:	78 b8                	js     800e2f <vprintfmt+0x1e5>
  800e77:	ff 4d e0             	decl   -0x20(%ebp)
  800e7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e7e:	79 af                	jns    800e2f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e80:	eb 13                	jmp    800e95 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e82:	83 ec 08             	sub    $0x8,%esp
  800e85:	ff 75 0c             	pushl  0xc(%ebp)
  800e88:	6a 20                	push   $0x20
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	ff d0                	call   *%eax
  800e8f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e92:	ff 4d e4             	decl   -0x1c(%ebp)
  800e95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e99:	7f e7                	jg     800e82 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e9b:	e9 66 01 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea9:	50                   	push   %eax
  800eaa:	e8 3c fd ff ff       	call   800beb <getint>
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebe:	85 d2                	test   %edx,%edx
  800ec0:	79 23                	jns    800ee5 <vprintfmt+0x29b>
				putch('-', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 2d                	push   $0x2d
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed8:	f7 d8                	neg    %eax
  800eda:	83 d2 00             	adc    $0x0,%edx
  800edd:	f7 da                	neg    %edx
  800edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ee5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eec:	e9 bc 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef7:	8d 45 14             	lea    0x14(%ebp),%eax
  800efa:	50                   	push   %eax
  800efb:	e8 84 fc ff ff       	call   800b84 <getuint>
  800f00:	83 c4 10             	add    $0x10,%esp
  800f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f09:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f10:	e9 98 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 0c             	pushl  0xc(%ebp)
  800f1b:	6a 58                	push   $0x58
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	ff d0                	call   *%eax
  800f22:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 0c             	pushl  0xc(%ebp)
  800f2b:	6a 58                	push   $0x58
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	ff d0                	call   *%eax
  800f32:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	6a 58                	push   $0x58
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	ff d0                	call   *%eax
  800f42:	83 c4 10             	add    $0x10,%esp
			break;
  800f45:	e9 bc 00 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f4a:	83 ec 08             	sub    $0x8,%esp
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	6a 30                	push   $0x30
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	ff d0                	call   *%eax
  800f57:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 78                	push   $0x78
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f8c:	eb 1f                	jmp    800fad <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	ff 75 e8             	pushl  -0x18(%ebp)
  800f94:	8d 45 14             	lea    0x14(%ebp),%eax
  800f97:	50                   	push   %eax
  800f98:	e8 e7 fb ff ff       	call   800b84 <getuint>
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fa6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fad:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb4:	83 ec 04             	sub    $0x4,%esp
  800fb7:	52                   	push   %edx
  800fb8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fbb:	50                   	push   %eax
  800fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbf:	ff 75 f0             	pushl  -0x10(%ebp)
  800fc2:	ff 75 0c             	pushl  0xc(%ebp)
  800fc5:	ff 75 08             	pushl  0x8(%ebp)
  800fc8:	e8 00 fb ff ff       	call   800acd <printnum>
  800fcd:	83 c4 20             	add    $0x20,%esp
			break;
  800fd0:	eb 34                	jmp    801006 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	53                   	push   %ebx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	ff d0                	call   *%eax
  800fde:	83 c4 10             	add    $0x10,%esp
			break;
  800fe1:	eb 23                	jmp    801006 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	ff 75 0c             	pushl  0xc(%ebp)
  800fe9:	6a 25                	push   $0x25
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	ff d0                	call   *%eax
  800ff0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff3:	ff 4d 10             	decl   0x10(%ebp)
  800ff6:	eb 03                	jmp    800ffb <vprintfmt+0x3b1>
  800ff8:	ff 4d 10             	decl   0x10(%ebp)
  800ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffe:	48                   	dec    %eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 25                	cmp    $0x25,%al
  801003:	75 f3                	jne    800ff8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801005:	90                   	nop
		}
	}
  801006:	e9 47 fc ff ff       	jmp    800c52 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80100b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80100c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100f:	5b                   	pop    %ebx
  801010:	5e                   	pop    %esi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801019:	8d 45 10             	lea    0x10(%ebp),%eax
  80101c:	83 c0 04             	add    $0x4,%eax
  80101f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	ff 75 f4             	pushl  -0xc(%ebp)
  801028:	50                   	push   %eax
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	ff 75 08             	pushl  0x8(%ebp)
  80102f:	e8 16 fc ff ff       	call   800c4a <vprintfmt>
  801034:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801037:	90                   	nop
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	8b 40 08             	mov    0x8(%eax),%eax
  801043:	8d 50 01             	lea    0x1(%eax),%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	8b 10                	mov    (%eax),%edx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8b 40 04             	mov    0x4(%eax),%eax
  801057:	39 c2                	cmp    %eax,%edx
  801059:	73 12                	jae    80106d <sprintputch+0x33>
		*b->buf++ = ch;
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8b 00                	mov    (%eax),%eax
  801060:	8d 48 01             	lea    0x1(%eax),%ecx
  801063:	8b 55 0c             	mov    0xc(%ebp),%edx
  801066:	89 0a                	mov    %ecx,(%edx)
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	88 10                	mov    %dl,(%eax)
}
  80106d:	90                   	nop
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	01 d0                	add    %edx,%eax
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801095:	74 06                	je     80109d <vsnprintf+0x2d>
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	7f 07                	jg     8010a4 <vsnprintf+0x34>
		return -E_INVAL;
  80109d:	b8 03 00 00 00       	mov    $0x3,%eax
  8010a2:	eb 20                	jmp    8010c4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010a4:	ff 75 14             	pushl  0x14(%ebp)
  8010a7:	ff 75 10             	pushl  0x10(%ebp)
  8010aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ad:	50                   	push   %eax
  8010ae:	68 3a 10 80 00       	push   $0x80103a
  8010b3:	e8 92 fb ff ff       	call   800c4a <vprintfmt>
  8010b8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010be:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8010cf:	83 c0 04             	add    $0x4,%eax
  8010d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010db:	50                   	push   %eax
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	ff 75 08             	pushl  0x8(%ebp)
  8010e2:	e8 89 ff ff ff       	call   801070 <vsnprintf>
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010f0:	c9                   	leave  
  8010f1:	c3                   	ret    

008010f2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ff:	eb 06                	jmp    801107 <strlen+0x15>
		n++;
  801101:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801104:	ff 45 08             	incl   0x8(%ebp)
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	84 c0                	test   %al,%al
  80110e:	75 f1                	jne    801101 <strlen+0xf>
		n++;
	return n;
  801110:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80111b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801122:	eb 09                	jmp    80112d <strnlen+0x18>
		n++;
  801124:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801127:	ff 45 08             	incl   0x8(%ebp)
  80112a:	ff 4d 0c             	decl   0xc(%ebp)
  80112d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801131:	74 09                	je     80113c <strnlen+0x27>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	84 c0                	test   %al,%al
  80113a:	75 e8                	jne    801124 <strnlen+0xf>
		n++;
	return n;
  80113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80114d:	90                   	nop
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8d 50 01             	lea    0x1(%eax),%edx
  801154:	89 55 08             	mov    %edx,0x8(%ebp)
  801157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801160:	8a 12                	mov    (%edx),%dl
  801162:	88 10                	mov    %dl,(%eax)
  801164:	8a 00                	mov    (%eax),%al
  801166:	84 c0                	test   %al,%al
  801168:	75 e4                	jne    80114e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80117b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801182:	eb 1f                	jmp    8011a3 <strncpy+0x34>
		*dst++ = *src;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8d 50 01             	lea    0x1(%eax),%edx
  80118a:	89 55 08             	mov    %edx,0x8(%ebp)
  80118d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801190:	8a 12                	mov    (%edx),%dl
  801192:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	84 c0                	test   %al,%al
  80119b:	74 03                	je     8011a0 <strncpy+0x31>
			src++;
  80119d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a0:	ff 45 fc             	incl   -0x4(%ebp)
  8011a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a9:	72 d9                	jb     801184 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 30                	je     8011f2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011c2:	eb 16                	jmp    8011da <strlcpy+0x2a>
			*dst++ = *src++;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011d6:	8a 12                	mov    (%edx),%dl
  8011d8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011da:	ff 4d 10             	decl   0x10(%ebp)
  8011dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e1:	74 09                	je     8011ec <strlcpy+0x3c>
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	84 c0                	test   %al,%al
  8011ea:	75 d8                	jne    8011c4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f8:	29 c2                	sub    %eax,%edx
  8011fa:	89 d0                	mov    %edx,%eax
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801201:	eb 06                	jmp    801209 <strcmp+0xb>
		p++, q++;
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	84 c0                	test   %al,%al
  801210:	74 0e                	je     801220 <strcmp+0x22>
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 10                	mov    (%eax),%dl
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	38 c2                	cmp    %al,%dl
  80121e:	74 e3                	je     801203 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	0f b6 c0             	movzbl %al,%eax
  801230:	29 c2                	sub    %eax,%edx
  801232:	89 d0                	mov    %edx,%eax
}
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801239:	eb 09                	jmp    801244 <strncmp+0xe>
		n--, p++, q++;
  80123b:	ff 4d 10             	decl   0x10(%ebp)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801248:	74 17                	je     801261 <strncmp+0x2b>
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	84 c0                	test   %al,%al
  801251:	74 0e                	je     801261 <strncmp+0x2b>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 10                	mov    (%eax),%dl
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	38 c2                	cmp    %al,%dl
  80125f:	74 da                	je     80123b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801261:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801265:	75 07                	jne    80126e <strncmp+0x38>
		return 0;
  801267:	b8 00 00 00 00       	mov    $0x0,%eax
  80126c:	eb 14                	jmp    801282 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	0f b6 d0             	movzbl %al,%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	0f b6 c0             	movzbl %al,%eax
  80127e:	29 c2                	sub    %eax,%edx
  801280:	89 d0                	mov    %edx,%eax
}
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    

00801284 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801290:	eb 12                	jmp    8012a4 <strchr+0x20>
		if (*s == c)
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80129a:	75 05                	jne    8012a1 <strchr+0x1d>
			return (char *) s;
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	eb 11                	jmp    8012b2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012a1:	ff 45 08             	incl   0x8(%ebp)
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	84 c0                	test   %al,%al
  8012ab:	75 e5                	jne    801292 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 04             	sub    $0x4,%esp
  8012ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012c0:	eb 0d                	jmp    8012cf <strfind+0x1b>
		if (*s == c)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012ca:	74 0e                	je     8012da <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	84 c0                	test   %al,%al
  8012d6:	75 ea                	jne    8012c2 <strfind+0xe>
  8012d8:	eb 01                	jmp    8012db <strfind+0x27>
		if (*s == c)
			break;
  8012da:	90                   	nop
	return (char *) s;
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012f2:	eb 0e                	jmp    801302 <memset+0x22>
		*p++ = c;
  8012f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801302:	ff 4d f8             	decl   -0x8(%ebp)
  801305:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801309:	79 e9                	jns    8012f4 <memset+0x14>
		*p++ = c;

	return v;
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801322:	eb 16                	jmp    80133a <memcpy+0x2a>
		*d++ = *s++;
  801324:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801327:	8d 50 01             	lea    0x1(%eax),%edx
  80132a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80132d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801330:	8d 4a 01             	lea    0x1(%edx),%ecx
  801333:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801336:	8a 12                	mov    (%edx),%dl
  801338:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80133a:	8b 45 10             	mov    0x10(%ebp),%eax
  80133d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801340:	89 55 10             	mov    %edx,0x10(%ebp)
  801343:	85 c0                	test   %eax,%eax
  801345:	75 dd                	jne    801324 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80135e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801361:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801364:	73 50                	jae    8013b6 <memmove+0x6a>
  801366:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801371:	76 43                	jbe    8013b6 <memmove+0x6a>
		s += n;
  801373:	8b 45 10             	mov    0x10(%ebp),%eax
  801376:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801379:	8b 45 10             	mov    0x10(%ebp),%eax
  80137c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80137f:	eb 10                	jmp    801391 <memmove+0x45>
			*--d = *--s;
  801381:	ff 4d f8             	decl   -0x8(%ebp)
  801384:	ff 4d fc             	decl   -0x4(%ebp)
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 10                	mov    (%eax),%dl
  80138c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	8d 50 ff             	lea    -0x1(%eax),%edx
  801397:	89 55 10             	mov    %edx,0x10(%ebp)
  80139a:	85 c0                	test   %eax,%eax
  80139c:	75 e3                	jne    801381 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80139e:	eb 23                	jmp    8013c3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a3:	8d 50 01             	lea    0x1(%eax),%edx
  8013a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013af:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013b2:	8a 12                	mov    (%edx),%dl
  8013b4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	75 dd                	jne    8013a0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013da:	eb 2a                	jmp    801406 <memcmp+0x3e>
		if (*s1 != *s2)
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 16                	je     801400 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
  8013fe:	eb 18                	jmp    801418 <memcmp+0x50>
		s1++, s2++;
  801400:	ff 45 fc             	incl   -0x4(%ebp)
  801403:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	8d 50 ff             	lea    -0x1(%eax),%edx
  80140c:	89 55 10             	mov    %edx,0x10(%ebp)
  80140f:	85 c0                	test   %eax,%eax
  801411:	75 c9                	jne    8013dc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801420:	8b 55 08             	mov    0x8(%ebp),%edx
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80142b:	eb 15                	jmp    801442 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f b6 d0             	movzbl %al,%edx
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	0f b6 c0             	movzbl %al,%eax
  80143b:	39 c2                	cmp    %eax,%edx
  80143d:	74 0d                	je     80144c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80143f:	ff 45 08             	incl   0x8(%ebp)
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801448:	72 e3                	jb     80142d <memfind+0x13>
  80144a:	eb 01                	jmp    80144d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80144c:	90                   	nop
	return (void *) s;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80145f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801466:	eb 03                	jmp    80146b <strtol+0x19>
		s++;
  801468:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	3c 20                	cmp    $0x20,%al
  801472:	74 f4                	je     801468 <strtol+0x16>
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	3c 09                	cmp    $0x9,%al
  80147b:	74 eb                	je     801468 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 2b                	cmp    $0x2b,%al
  801484:	75 05                	jne    80148b <strtol+0x39>
		s++;
  801486:	ff 45 08             	incl   0x8(%ebp)
  801489:	eb 13                	jmp    80149e <strtol+0x4c>
	else if (*s == '-')
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	3c 2d                	cmp    $0x2d,%al
  801492:	75 0a                	jne    80149e <strtol+0x4c>
		s++, neg = 1;
  801494:	ff 45 08             	incl   0x8(%ebp)
  801497:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80149e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a2:	74 06                	je     8014aa <strtol+0x58>
  8014a4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014a8:	75 20                	jne    8014ca <strtol+0x78>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 30                	cmp    $0x30,%al
  8014b1:	75 17                	jne    8014ca <strtol+0x78>
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	40                   	inc    %eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	3c 78                	cmp    $0x78,%al
  8014bb:	75 0d                	jne    8014ca <strtol+0x78>
		s += 2, base = 16;
  8014bd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014c1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014c8:	eb 28                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ce:	75 15                	jne    8014e5 <strtol+0x93>
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	8a 00                	mov    (%eax),%al
  8014d5:	3c 30                	cmp    $0x30,%al
  8014d7:	75 0c                	jne    8014e5 <strtol+0x93>
		s++, base = 8;
  8014d9:	ff 45 08             	incl   0x8(%ebp)
  8014dc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014e3:	eb 0d                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0)
  8014e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e9:	75 07                	jne    8014f2 <strtol+0xa0>
		base = 10;
  8014eb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	3c 2f                	cmp    $0x2f,%al
  8014f9:	7e 19                	jle    801514 <strtol+0xc2>
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	3c 39                	cmp    $0x39,%al
  801502:	7f 10                	jg     801514 <strtol+0xc2>
			dig = *s - '0';
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	0f be c0             	movsbl %al,%eax
  80150c:	83 e8 30             	sub    $0x30,%eax
  80150f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801512:	eb 42                	jmp    801556 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	3c 60                	cmp    $0x60,%al
  80151b:	7e 19                	jle    801536 <strtol+0xe4>
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	3c 7a                	cmp    $0x7a,%al
  801524:	7f 10                	jg     801536 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	0f be c0             	movsbl %al,%eax
  80152e:	83 e8 57             	sub    $0x57,%eax
  801531:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801534:	eb 20                	jmp    801556 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	3c 40                	cmp    $0x40,%al
  80153d:	7e 39                	jle    801578 <strtol+0x126>
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	3c 5a                	cmp    $0x5a,%al
  801546:	7f 30                	jg     801578 <strtol+0x126>
			dig = *s - 'A' + 10;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	0f be c0             	movsbl %al,%eax
  801550:	83 e8 37             	sub    $0x37,%eax
  801553:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801559:	3b 45 10             	cmp    0x10(%ebp),%eax
  80155c:	7d 19                	jge    801577 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80155e:	ff 45 08             	incl   0x8(%ebp)
  801561:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801564:	0f af 45 10          	imul   0x10(%ebp),%eax
  801568:	89 c2                	mov    %eax,%edx
  80156a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801572:	e9 7b ff ff ff       	jmp    8014f2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801577:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801578:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80157c:	74 08                	je     801586 <strtol+0x134>
		*endptr = (char *) s;
  80157e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801581:	8b 55 08             	mov    0x8(%ebp),%edx
  801584:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801586:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80158a:	74 07                	je     801593 <strtol+0x141>
  80158c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158f:	f7 d8                	neg    %eax
  801591:	eb 03                	jmp    801596 <strtol+0x144>
  801593:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <ltostr>:

void
ltostr(long value, char *str)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80159e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b0:	79 13                	jns    8015c5 <ltostr+0x2d>
	{
		neg = 1;
  8015b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015bf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015c2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015cd:	99                   	cltd   
  8015ce:	f7 f9                	idiv   %ecx
  8015d0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d6:	8d 50 01             	lea    0x1(%eax),%edx
  8015d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015dc:	89 c2                	mov    %eax,%edx
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e1:	01 d0                	add    %edx,%eax
  8015e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e6:	83 c2 30             	add    $0x30,%edx
  8015e9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015f3:	f7 e9                	imul   %ecx
  8015f5:	c1 fa 02             	sar    $0x2,%edx
  8015f8:	89 c8                	mov    %ecx,%eax
  8015fa:	c1 f8 1f             	sar    $0x1f,%eax
  8015fd:	29 c2                	sub    %eax,%edx
  8015ff:	89 d0                	mov    %edx,%eax
  801601:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801604:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801607:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80160c:	f7 e9                	imul   %ecx
  80160e:	c1 fa 02             	sar    $0x2,%edx
  801611:	89 c8                	mov    %ecx,%eax
  801613:	c1 f8 1f             	sar    $0x1f,%eax
  801616:	29 c2                	sub    %eax,%edx
  801618:	89 d0                	mov    %edx,%eax
  80161a:	c1 e0 02             	shl    $0x2,%eax
  80161d:	01 d0                	add    %edx,%eax
  80161f:	01 c0                	add    %eax,%eax
  801621:	29 c1                	sub    %eax,%ecx
  801623:	89 ca                	mov    %ecx,%edx
  801625:	85 d2                	test   %edx,%edx
  801627:	75 9c                	jne    8015c5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801630:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801633:	48                   	dec    %eax
  801634:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801637:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80163b:	74 3d                	je     80167a <ltostr+0xe2>
		start = 1 ;
  80163d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801644:	eb 34                	jmp    80167a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 d0                	add    %edx,%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	01 c2                	add    %eax,%edx
  80165b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	01 c8                	add    %ecx,%eax
  801663:	8a 00                	mov    (%eax),%al
  801665:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801667:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	01 c2                	add    %eax,%edx
  80166f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801672:	88 02                	mov    %al,(%edx)
		start++ ;
  801674:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801677:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801680:	7c c4                	jl     801646 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801682:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801685:	8b 45 0c             	mov    0xc(%ebp),%eax
  801688:	01 d0                	add    %edx,%eax
  80168a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	e8 54 fa ff ff       	call   8010f2 <strlen>
  80169e:	83 c4 04             	add    $0x4,%esp
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	e8 46 fa ff ff       	call   8010f2 <strlen>
  8016ac:	83 c4 04             	add    $0x4,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c0:	eb 17                	jmp    8016d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c8:	01 c2                	add    %eax,%edx
  8016ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	01 c8                	add    %ecx,%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016d6:	ff 45 fc             	incl   -0x4(%ebp)
  8016d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016df:	7c e1                	jl     8016c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ef:	eb 1f                	jmp    801710 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f4:	8d 50 01             	lea    0x1(%eax),%edx
  8016f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016fa:	89 c2                	mov    %eax,%edx
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	01 c2                	add    %eax,%edx
  801701:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801704:	8b 45 0c             	mov    0xc(%ebp),%eax
  801707:	01 c8                	add    %ecx,%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80170d:	ff 45 f8             	incl   -0x8(%ebp)
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801716:	7c d9                	jl     8016f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801718:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171b:	8b 45 10             	mov    0x10(%ebp),%eax
  80171e:	01 d0                	add    %edx,%eax
  801720:	c6 00 00             	movb   $0x0,(%eax)
}
  801723:	90                   	nop
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801729:	8b 45 14             	mov    0x14(%ebp),%eax
  80172c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801732:	8b 45 14             	mov    0x14(%ebp),%eax
  801735:	8b 00                	mov    (%eax),%eax
  801737:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80173e:	8b 45 10             	mov    0x10(%ebp),%eax
  801741:	01 d0                	add    %edx,%eax
  801743:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801749:	eb 0c                	jmp    801757 <strsplit+0x31>
			*string++ = 0;
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	8d 50 01             	lea    0x1(%eax),%edx
  801751:	89 55 08             	mov    %edx,0x8(%ebp)
  801754:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 18                	je     801778 <strsplit+0x52>
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	0f be c0             	movsbl %al,%eax
  801768:	50                   	push   %eax
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	e8 13 fb ff ff       	call   801284 <strchr>
  801771:	83 c4 08             	add    $0x8,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	75 d3                	jne    80174b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	84 c0                	test   %al,%al
  80177f:	74 5a                	je     8017db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801781:	8b 45 14             	mov    0x14(%ebp),%eax
  801784:	8b 00                	mov    (%eax),%eax
  801786:	83 f8 0f             	cmp    $0xf,%eax
  801789:	75 07                	jne    801792 <strsplit+0x6c>
		{
			return 0;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	eb 66                	jmp    8017f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801792:	8b 45 14             	mov    0x14(%ebp),%eax
  801795:	8b 00                	mov    (%eax),%eax
  801797:	8d 48 01             	lea    0x1(%eax),%ecx
  80179a:	8b 55 14             	mov    0x14(%ebp),%edx
  80179d:	89 0a                	mov    %ecx,(%edx)
  80179f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b0:	eb 03                	jmp    8017b5 <strsplit+0x8f>
			string++;
  8017b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	84 c0                	test   %al,%al
  8017bc:	74 8b                	je     801749 <strsplit+0x23>
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8a 00                	mov    (%eax),%al
  8017c3:	0f be c0             	movsbl %al,%eax
  8017c6:	50                   	push   %eax
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	e8 b5 fa ff ff       	call   801284 <strchr>
  8017cf:	83 c4 08             	add    $0x8,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	74 dc                	je     8017b2 <strsplit+0x8c>
			string++;
	}
  8017d6:	e9 6e ff ff ff       	jmp    801749 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017df:	8b 00                	mov    (%eax),%eax
  8017e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801800:	a1 04 50 80 00       	mov    0x805004,%eax
  801805:	85 c0                	test   %eax,%eax
  801807:	74 1f                	je     801828 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801809:	e8 1d 00 00 00       	call   80182b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80180e:	83 ec 0c             	sub    $0xc,%esp
  801811:	68 50 3e 80 00       	push   $0x803e50
  801816:	e8 55 f2 ff ff       	call   800a70 <cprintf>
  80181b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80181e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801825:	00 00 00 
	}
}
  801828:	90                   	nop
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801831:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801838:	00 00 00 
  80183b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801842:	00 00 00 
  801845:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80184c:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80184f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801856:	00 00 00 
  801859:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801860:	00 00 00 
  801863:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80186a:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80186d:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801874:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801877:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801881:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801886:	2d 00 10 00 00       	sub    $0x1000,%eax
  80188b:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801890:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801897:	a1 20 51 80 00       	mov    0x805120,%eax
  80189c:	c1 e0 04             	shl    $0x4,%eax
  80189f:	89 c2                	mov    %eax,%edx
  8018a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a4:	01 d0                	add    %edx,%eax
  8018a6:	48                   	dec    %eax
  8018a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b2:	f7 75 f0             	divl   -0x10(%ebp)
  8018b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b8:	29 d0                	sub    %edx,%eax
  8018ba:	89 c2                	mov    %eax,%edx
  8018bc:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8018c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018cb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018d0:	83 ec 04             	sub    $0x4,%esp
  8018d3:	6a 06                	push   $0x6
  8018d5:	52                   	push   %edx
  8018d6:	50                   	push   %eax
  8018d7:	e8 71 05 00 00       	call   801e4d <sys_allocate_chunk>
  8018dc:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018df:	a1 20 51 80 00       	mov    0x805120,%eax
  8018e4:	83 ec 0c             	sub    $0xc,%esp
  8018e7:	50                   	push   %eax
  8018e8:	e8 e6 0b 00 00       	call   8024d3 <initialize_MemBlocksList>
  8018ed:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8018f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8018f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8018f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018fc:	75 14                	jne    801912 <initialize_dyn_block_system+0xe7>
  8018fe:	83 ec 04             	sub    $0x4,%esp
  801901:	68 75 3e 80 00       	push   $0x803e75
  801906:	6a 2b                	push   $0x2b
  801908:	68 93 3e 80 00       	push   $0x803e93
  80190d:	e8 aa ee ff ff       	call   8007bc <_panic>
  801912:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801915:	8b 00                	mov    (%eax),%eax
  801917:	85 c0                	test   %eax,%eax
  801919:	74 10                	je     80192b <initialize_dyn_block_system+0x100>
  80191b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80191e:	8b 00                	mov    (%eax),%eax
  801920:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801923:	8b 52 04             	mov    0x4(%edx),%edx
  801926:	89 50 04             	mov    %edx,0x4(%eax)
  801929:	eb 0b                	jmp    801936 <initialize_dyn_block_system+0x10b>
  80192b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80192e:	8b 40 04             	mov    0x4(%eax),%eax
  801931:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801936:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801939:	8b 40 04             	mov    0x4(%eax),%eax
  80193c:	85 c0                	test   %eax,%eax
  80193e:	74 0f                	je     80194f <initialize_dyn_block_system+0x124>
  801940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801943:	8b 40 04             	mov    0x4(%eax),%eax
  801946:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801949:	8b 12                	mov    (%edx),%edx
  80194b:	89 10                	mov    %edx,(%eax)
  80194d:	eb 0a                	jmp    801959 <initialize_dyn_block_system+0x12e>
  80194f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801952:	8b 00                	mov    (%eax),%eax
  801954:	a3 48 51 80 00       	mov    %eax,0x805148
  801959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80195c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801965:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80196c:	a1 54 51 80 00       	mov    0x805154,%eax
  801971:	48                   	dec    %eax
  801972:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80197a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801984:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80198b:	83 ec 0c             	sub    $0xc,%esp
  80198e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801991:	e8 d2 13 00 00       	call   802d68 <insert_sorted_with_merge_freeList>
  801996:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801999:	90                   	nop
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019a2:	e8 53 fe ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  8019a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019ab:	75 07                	jne    8019b4 <malloc+0x18>
  8019ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b2:	eb 61                	jmp    801a15 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8019b4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8019bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8019be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c1:	01 d0                	add    %edx,%eax
  8019c3:	48                   	dec    %eax
  8019c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cf:	f7 75 f4             	divl   -0xc(%ebp)
  8019d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d5:	29 d0                	sub    %edx,%eax
  8019d7:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8019da:	e8 3c 08 00 00       	call   80221b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	74 2d                	je     801a10 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8019e3:	83 ec 0c             	sub    $0xc,%esp
  8019e6:	ff 75 08             	pushl  0x8(%ebp)
  8019e9:	e8 3e 0f 00 00       	call   80292c <alloc_block_FF>
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8019f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019f8:	74 16                	je     801a10 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8019fa:	83 ec 0c             	sub    $0xc,%esp
  8019fd:	ff 75 ec             	pushl  -0x14(%ebp)
  801a00:	e8 48 0c 00 00       	call   80264d <insert_sorted_allocList>
  801a05:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801a08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a0b:	8b 40 08             	mov    0x8(%eax),%eax
  801a0e:	eb 05                	jmp    801a15 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801a10:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a2b:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	83 ec 08             	sub    $0x8,%esp
  801a34:	50                   	push   %eax
  801a35:	68 40 50 80 00       	push   $0x805040
  801a3a:	e8 71 0b 00 00       	call   8025b0 <find_block>
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a48:	8b 50 0c             	mov    0xc(%eax),%edx
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	83 ec 08             	sub    $0x8,%esp
  801a51:	52                   	push   %edx
  801a52:	50                   	push   %eax
  801a53:	e8 bd 03 00 00       	call   801e15 <sys_free_user_mem>
  801a58:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801a5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a5f:	75 14                	jne    801a75 <free+0x5e>
  801a61:	83 ec 04             	sub    $0x4,%esp
  801a64:	68 75 3e 80 00       	push   $0x803e75
  801a69:	6a 71                	push   $0x71
  801a6b:	68 93 3e 80 00       	push   $0x803e93
  801a70:	e8 47 ed ff ff       	call   8007bc <_panic>
  801a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a78:	8b 00                	mov    (%eax),%eax
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	74 10                	je     801a8e <free+0x77>
  801a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a81:	8b 00                	mov    (%eax),%eax
  801a83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a86:	8b 52 04             	mov    0x4(%edx),%edx
  801a89:	89 50 04             	mov    %edx,0x4(%eax)
  801a8c:	eb 0b                	jmp    801a99 <free+0x82>
  801a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a91:	8b 40 04             	mov    0x4(%eax),%eax
  801a94:	a3 44 50 80 00       	mov    %eax,0x805044
  801a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9c:	8b 40 04             	mov    0x4(%eax),%eax
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	74 0f                	je     801ab2 <free+0x9b>
  801aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa6:	8b 40 04             	mov    0x4(%eax),%eax
  801aa9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aac:	8b 12                	mov    (%edx),%edx
  801aae:	89 10                	mov    %edx,(%eax)
  801ab0:	eb 0a                	jmp    801abc <free+0xa5>
  801ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab5:	8b 00                	mov    (%eax),%eax
  801ab7:	a3 40 50 80 00       	mov    %eax,0x805040
  801abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801acf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ad4:	48                   	dec    %eax
  801ad5:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801ada:	83 ec 0c             	sub    $0xc,%esp
  801add:	ff 75 f0             	pushl  -0x10(%ebp)
  801ae0:	e8 83 12 00 00       	call   802d68 <insert_sorted_with_merge_freeList>
  801ae5:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801ae8:	90                   	nop
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 28             	sub    $0x28,%esp
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801af7:	e8 fe fc ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801afc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b00:	75 0a                	jne    801b0c <smalloc+0x21>
  801b02:	b8 00 00 00 00       	mov    $0x0,%eax
  801b07:	e9 86 00 00 00       	jmp    801b92 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801b0c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b19:	01 d0                	add    %edx,%eax
  801b1b:	48                   	dec    %eax
  801b1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b22:	ba 00 00 00 00       	mov    $0x0,%edx
  801b27:	f7 75 f4             	divl   -0xc(%ebp)
  801b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2d:	29 d0                	sub    %edx,%eax
  801b2f:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b32:	e8 e4 06 00 00       	call   80221b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b37:	85 c0                	test   %eax,%eax
  801b39:	74 52                	je     801b8d <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801b3b:	83 ec 0c             	sub    $0xc,%esp
  801b3e:	ff 75 0c             	pushl  0xc(%ebp)
  801b41:	e8 e6 0d 00 00       	call   80292c <alloc_block_FF>
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801b4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b50:	75 07                	jne    801b59 <smalloc+0x6e>
			return NULL ;
  801b52:	b8 00 00 00 00       	mov    $0x0,%eax
  801b57:	eb 39                	jmp    801b92 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b5c:	8b 40 08             	mov    0x8(%eax),%eax
  801b5f:	89 c2                	mov    %eax,%edx
  801b61:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	ff 75 08             	pushl  0x8(%ebp)
  801b6d:	e8 2e 04 00 00       	call   801fa0 <sys_createSharedObject>
  801b72:	83 c4 10             	add    $0x10,%esp
  801b75:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801b78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b7c:	79 07                	jns    801b85 <smalloc+0x9a>
			return (void*)NULL ;
  801b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b83:	eb 0d                	jmp    801b92 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b88:	8b 40 08             	mov    0x8(%eax),%eax
  801b8b:	eb 05                	jmp    801b92 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801b8d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b9a:	e8 5b fc ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b9f:	83 ec 08             	sub    $0x8,%esp
  801ba2:	ff 75 0c             	pushl  0xc(%ebp)
  801ba5:	ff 75 08             	pushl  0x8(%ebp)
  801ba8:	e8 1d 04 00 00       	call   801fca <sys_getSizeOfSharedObject>
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801bb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb7:	75 0a                	jne    801bc3 <sget+0x2f>
			return NULL ;
  801bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbe:	e9 83 00 00 00       	jmp    801c46 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801bc3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd0:	01 d0                	add    %edx,%eax
  801bd2:	48                   	dec    %eax
  801bd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bde:	f7 75 f0             	divl   -0x10(%ebp)
  801be1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be4:	29 d0                	sub    %edx,%eax
  801be6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801be9:	e8 2d 06 00 00       	call   80221b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	74 4f                	je     801c41 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf5:	83 ec 0c             	sub    $0xc,%esp
  801bf8:	50                   	push   %eax
  801bf9:	e8 2e 0d 00 00       	call   80292c <alloc_block_FF>
  801bfe:	83 c4 10             	add    $0x10,%esp
  801c01:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801c04:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c08:	75 07                	jne    801c11 <sget+0x7d>
					return (void*)NULL ;
  801c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0f:	eb 35                	jmp    801c46 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c14:	8b 40 08             	mov    0x8(%eax),%eax
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	50                   	push   %eax
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	e8 c1 03 00 00       	call   801fe7 <sys_getSharedObject>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801c2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c30:	79 07                	jns    801c39 <sget+0xa5>
				return (void*)NULL ;
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
  801c37:	eb 0d                	jmp    801c46 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801c39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c3c:	8b 40 08             	mov    0x8(%eax),%eax
  801c3f:	eb 05                	jmp    801c46 <sget+0xb2>


		}
	return (void*)NULL ;
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c4e:	e8 a7 fb ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c53:	83 ec 04             	sub    $0x4,%esp
  801c56:	68 a0 3e 80 00       	push   $0x803ea0
  801c5b:	68 f9 00 00 00       	push   $0xf9
  801c60:	68 93 3e 80 00       	push   $0x803e93
  801c65:	e8 52 eb ff ff       	call   8007bc <_panic>

00801c6a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c70:	83 ec 04             	sub    $0x4,%esp
  801c73:	68 c8 3e 80 00       	push   $0x803ec8
  801c78:	68 0d 01 00 00       	push   $0x10d
  801c7d:	68 93 3e 80 00       	push   $0x803e93
  801c82:	e8 35 eb ff ff       	call   8007bc <_panic>

00801c87 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c8d:	83 ec 04             	sub    $0x4,%esp
  801c90:	68 ec 3e 80 00       	push   $0x803eec
  801c95:	68 18 01 00 00       	push   $0x118
  801c9a:	68 93 3e 80 00       	push   $0x803e93
  801c9f:	e8 18 eb ff ff       	call   8007bc <_panic>

00801ca4 <shrink>:

}
void shrink(uint32 newSize)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801caa:	83 ec 04             	sub    $0x4,%esp
  801cad:	68 ec 3e 80 00       	push   $0x803eec
  801cb2:	68 1d 01 00 00       	push   $0x11d
  801cb7:	68 93 3e 80 00       	push   $0x803e93
  801cbc:	e8 fb ea ff ff       	call   8007bc <_panic>

00801cc1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	68 ec 3e 80 00       	push   $0x803eec
  801ccf:	68 22 01 00 00       	push   $0x122
  801cd4:	68 93 3e 80 00       	push   $0x803e93
  801cd9:	e8 de ea ff ff       	call   8007bc <_panic>

00801cde <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	57                   	push   %edi
  801ce2:	56                   	push   %esi
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ced:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cf6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cf9:	cd 30                	int    $0x30
  801cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d01:	83 c4 10             	add    $0x10,%esp
  801d04:	5b                   	pop    %ebx
  801d05:	5e                   	pop    %esi
  801d06:	5f                   	pop    %edi
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    

00801d09 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 04             	sub    $0x4,%esp
  801d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d12:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d15:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	52                   	push   %edx
  801d21:	ff 75 0c             	pushl  0xc(%ebp)
  801d24:	50                   	push   %eax
  801d25:	6a 00                	push   $0x0
  801d27:	e8 b2 ff ff ff       	call   801cde <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	90                   	nop
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 01                	push   $0x1
  801d41:	e8 98 ff ff ff       	call   801cde <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	52                   	push   %edx
  801d5b:	50                   	push   %eax
  801d5c:	6a 05                	push   $0x5
  801d5e:	e8 7b ff ff ff       	call   801cde <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	56                   	push   %esi
  801d6c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d6d:	8b 75 18             	mov    0x18(%ebp),%esi
  801d70:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	56                   	push   %esi
  801d7d:	53                   	push   %ebx
  801d7e:	51                   	push   %ecx
  801d7f:	52                   	push   %edx
  801d80:	50                   	push   %eax
  801d81:	6a 06                	push   $0x6
  801d83:	e8 56 ff ff ff       	call   801cde <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
}
  801d8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8e:	5b                   	pop    %ebx
  801d8f:	5e                   	pop    %esi
  801d90:	5d                   	pop    %ebp
  801d91:	c3                   	ret    

00801d92 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	52                   	push   %edx
  801da2:	50                   	push   %eax
  801da3:	6a 07                	push   $0x7
  801da5:	e8 34 ff ff ff       	call   801cde <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	ff 75 0c             	pushl  0xc(%ebp)
  801dbb:	ff 75 08             	pushl  0x8(%ebp)
  801dbe:	6a 08                	push   $0x8
  801dc0:	e8 19 ff ff ff       	call   801cde <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 09                	push   $0x9
  801dd9:	e8 00 ff ff ff       	call   801cde <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 0a                	push   $0xa
  801df2:	e8 e7 fe ff ff       	call   801cde <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 0b                	push   $0xb
  801e0b:	e8 ce fe ff ff       	call   801cde <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	ff 75 0c             	pushl  0xc(%ebp)
  801e21:	ff 75 08             	pushl  0x8(%ebp)
  801e24:	6a 0f                	push   $0xf
  801e26:	e8 b3 fe ff ff       	call   801cde <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
	return;
  801e2e:	90                   	nop
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	ff 75 0c             	pushl  0xc(%ebp)
  801e3d:	ff 75 08             	pushl  0x8(%ebp)
  801e40:	6a 10                	push   $0x10
  801e42:	e8 97 fe ff ff       	call   801cde <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4a:	90                   	nop
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	ff 75 10             	pushl  0x10(%ebp)
  801e57:	ff 75 0c             	pushl  0xc(%ebp)
  801e5a:	ff 75 08             	pushl  0x8(%ebp)
  801e5d:	6a 11                	push   $0x11
  801e5f:	e8 7a fe ff ff       	call   801cde <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
	return ;
  801e67:	90                   	nop
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 0c                	push   $0xc
  801e79:	e8 60 fe ff ff       	call   801cde <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	ff 75 08             	pushl  0x8(%ebp)
  801e91:	6a 0d                	push   $0xd
  801e93:	e8 46 fe ff ff       	call   801cde <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 0e                	push   $0xe
  801eac:	e8 2d fe ff ff       	call   801cde <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
}
  801eb4:	90                   	nop
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 13                	push   $0x13
  801ec6:	e8 13 fe ff ff       	call   801cde <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
}
  801ece:	90                   	nop
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 14                	push   $0x14
  801ee0:	e8 f9 fd ff ff       	call   801cde <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
}
  801ee8:	90                   	nop
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_cputc>:


void
sys_cputc(const char c)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 04             	sub    $0x4,%esp
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ef7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	50                   	push   %eax
  801f04:	6a 15                	push   $0x15
  801f06:	e8 d3 fd ff ff       	call   801cde <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
}
  801f0e:	90                   	nop
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 16                	push   $0x16
  801f20:	e8 b9 fd ff ff       	call   801cde <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	90                   	nop
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	ff 75 0c             	pushl  0xc(%ebp)
  801f3a:	50                   	push   %eax
  801f3b:	6a 17                	push   $0x17
  801f3d:	e8 9c fd ff ff       	call   801cde <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	52                   	push   %edx
  801f57:	50                   	push   %eax
  801f58:	6a 1a                	push   $0x1a
  801f5a:	e8 7f fd ff ff       	call   801cde <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	52                   	push   %edx
  801f74:	50                   	push   %eax
  801f75:	6a 18                	push   $0x18
  801f77:	e8 62 fd ff ff       	call   801cde <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
}
  801f7f:	90                   	nop
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	52                   	push   %edx
  801f92:	50                   	push   %eax
  801f93:	6a 19                	push   $0x19
  801f95:	e8 44 fd ff ff       	call   801cde <syscall>
  801f9a:	83 c4 18             	add    $0x18,%esp
}
  801f9d:	90                   	nop
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 04             	sub    $0x4,%esp
  801fa6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801faf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	6a 00                	push   $0x0
  801fb8:	51                   	push   %ecx
  801fb9:	52                   	push   %edx
  801fba:	ff 75 0c             	pushl  0xc(%ebp)
  801fbd:	50                   	push   %eax
  801fbe:	6a 1b                	push   $0x1b
  801fc0:	e8 19 fd ff ff       	call   801cde <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	52                   	push   %edx
  801fda:	50                   	push   %eax
  801fdb:	6a 1c                	push   $0x1c
  801fdd:	e8 fc fc ff ff       	call   801cde <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
}
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	51                   	push   %ecx
  801ff8:	52                   	push   %edx
  801ff9:	50                   	push   %eax
  801ffa:	6a 1d                	push   $0x1d
  801ffc:	e8 dd fc ff ff       	call   801cde <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802009:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	52                   	push   %edx
  802016:	50                   	push   %eax
  802017:	6a 1e                	push   $0x1e
  802019:	e8 c0 fc ff ff       	call   801cde <syscall>
  80201e:	83 c4 18             	add    $0x18,%esp
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 1f                	push   $0x1f
  802032:	e8 a7 fc ff ff       	call   801cde <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	6a 00                	push   $0x0
  802044:	ff 75 14             	pushl  0x14(%ebp)
  802047:	ff 75 10             	pushl  0x10(%ebp)
  80204a:	ff 75 0c             	pushl  0xc(%ebp)
  80204d:	50                   	push   %eax
  80204e:	6a 20                	push   $0x20
  802050:	e8 89 fc ff ff       	call   801cde <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	50                   	push   %eax
  802069:	6a 21                	push   $0x21
  80206b:	e8 6e fc ff ff       	call   801cde <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	90                   	nop
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	50                   	push   %eax
  802085:	6a 22                	push   $0x22
  802087:	e8 52 fc ff ff       	call   801cde <syscall>
  80208c:	83 c4 18             	add    $0x18,%esp
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 02                	push   $0x2
  8020a0:	e8 39 fc ff ff       	call   801cde <syscall>
  8020a5:	83 c4 18             	add    $0x18,%esp
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 03                	push   $0x3
  8020b9:	e8 20 fc ff ff       	call   801cde <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 04                	push   $0x4
  8020d2:	e8 07 fc ff ff       	call   801cde <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_exit_env>:


void sys_exit_env(void)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 23                	push   $0x23
  8020eb:	e8 ee fb ff ff       	call   801cde <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	90                   	nop
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020fc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020ff:	8d 50 04             	lea    0x4(%eax),%edx
  802102:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	52                   	push   %edx
  80210c:	50                   	push   %eax
  80210d:	6a 24                	push   $0x24
  80210f:	e8 ca fb ff ff       	call   801cde <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
	return result;
  802117:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80211a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80211d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802120:	89 01                	mov    %eax,(%ecx)
  802122:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	c9                   	leave  
  802129:	c2 04 00             	ret    $0x4

0080212c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	ff 75 10             	pushl  0x10(%ebp)
  802136:	ff 75 0c             	pushl  0xc(%ebp)
  802139:	ff 75 08             	pushl  0x8(%ebp)
  80213c:	6a 12                	push   $0x12
  80213e:	e8 9b fb ff ff       	call   801cde <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
	return ;
  802146:	90                   	nop
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <sys_rcr2>:
uint32 sys_rcr2()
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 25                	push   $0x25
  802158:	e8 81 fb ff ff       	call   801cde <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 04             	sub    $0x4,%esp
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80216e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	50                   	push   %eax
  80217b:	6a 26                	push   $0x26
  80217d:	e8 5c fb ff ff       	call   801cde <syscall>
  802182:	83 c4 18             	add    $0x18,%esp
	return ;
  802185:	90                   	nop
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <rsttst>:
void rsttst()
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 28                	push   $0x28
  802197:	e8 42 fb ff ff       	call   801cde <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
	return ;
  80219f:	90                   	nop
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	83 ec 04             	sub    $0x4,%esp
  8021a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021ae:	8b 55 18             	mov    0x18(%ebp),%edx
  8021b1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021b5:	52                   	push   %edx
  8021b6:	50                   	push   %eax
  8021b7:	ff 75 10             	pushl  0x10(%ebp)
  8021ba:	ff 75 0c             	pushl  0xc(%ebp)
  8021bd:	ff 75 08             	pushl  0x8(%ebp)
  8021c0:	6a 27                	push   $0x27
  8021c2:	e8 17 fb ff ff       	call   801cde <syscall>
  8021c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ca:	90                   	nop
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <chktst>:
void chktst(uint32 n)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	ff 75 08             	pushl  0x8(%ebp)
  8021db:	6a 29                	push   $0x29
  8021dd:	e8 fc fa ff ff       	call   801cde <syscall>
  8021e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e5:	90                   	nop
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <inctst>:

void inctst()
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 2a                	push   $0x2a
  8021f7:	e8 e2 fa ff ff       	call   801cde <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ff:	90                   	nop
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <gettst>:
uint32 gettst()
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 2b                	push   $0x2b
  802211:	e8 c8 fa ff ff       	call   801cde <syscall>
  802216:	83 c4 18             	add    $0x18,%esp
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 2c                	push   $0x2c
  80222d:	e8 ac fa ff ff       	call   801cde <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
  802235:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802238:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80223c:	75 07                	jne    802245 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80223e:	b8 01 00 00 00       	mov    $0x1,%eax
  802243:	eb 05                	jmp    80224a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802245:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 2c                	push   $0x2c
  80225e:	e8 7b fa ff ff       	call   801cde <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
  802266:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802269:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80226d:	75 07                	jne    802276 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80226f:	b8 01 00 00 00       	mov    $0x1,%eax
  802274:	eb 05                	jmp    80227b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 2c                	push   $0x2c
  80228f:	e8 4a fa ff ff       	call   801cde <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
  802297:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80229a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80229e:	75 07                	jne    8022a7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a5:	eb 05                	jmp    8022ac <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 2c                	push   $0x2c
  8022c0:	e8 19 fa ff ff       	call   801cde <syscall>
  8022c5:	83 c4 18             	add    $0x18,%esp
  8022c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022cb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022cf:	75 07                	jne    8022d8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d6:	eb 05                	jmp    8022dd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	ff 75 08             	pushl  0x8(%ebp)
  8022ed:	6a 2d                	push   $0x2d
  8022ef:	e8 ea f9 ff ff       	call   801cde <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f7:	90                   	nop
}
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    

008022fa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
  8022fd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802301:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802304:	8b 55 0c             	mov    0xc(%ebp),%edx
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	6a 00                	push   $0x0
  80230c:	53                   	push   %ebx
  80230d:	51                   	push   %ecx
  80230e:	52                   	push   %edx
  80230f:	50                   	push   %eax
  802310:	6a 2e                	push   $0x2e
  802312:	e8 c7 f9 ff ff       	call   801cde <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
}
  80231a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802322:	8b 55 0c             	mov    0xc(%ebp),%edx
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	52                   	push   %edx
  80232f:	50                   	push   %eax
  802330:	6a 2f                	push   $0x2f
  802332:	e8 a7 f9 ff ff       	call   801cde <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802342:	83 ec 0c             	sub    $0xc,%esp
  802345:	68 fc 3e 80 00       	push   $0x803efc
  80234a:	e8 21 e7 ff ff       	call   800a70 <cprintf>
  80234f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802352:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802359:	83 ec 0c             	sub    $0xc,%esp
  80235c:	68 28 3f 80 00       	push   $0x803f28
  802361:	e8 0a e7 ff ff       	call   800a70 <cprintf>
  802366:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802369:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80236d:	a1 38 51 80 00       	mov    0x805138,%eax
  802372:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802375:	eb 56                	jmp    8023cd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802377:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80237b:	74 1c                	je     802399 <print_mem_block_lists+0x5d>
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	8b 50 08             	mov    0x8(%eax),%edx
  802383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802386:	8b 48 08             	mov    0x8(%eax),%ecx
  802389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238c:	8b 40 0c             	mov    0xc(%eax),%eax
  80238f:	01 c8                	add    %ecx,%eax
  802391:	39 c2                	cmp    %eax,%edx
  802393:	73 04                	jae    802399 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802395:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 50 08             	mov    0x8(%eax),%edx
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a5:	01 c2                	add    %eax,%edx
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 40 08             	mov    0x8(%eax),%eax
  8023ad:	83 ec 04             	sub    $0x4,%esp
  8023b0:	52                   	push   %edx
  8023b1:	50                   	push   %eax
  8023b2:	68 3d 3f 80 00       	push   $0x803f3d
  8023b7:	e8 b4 e6 ff ff       	call   800a70 <cprintf>
  8023bc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023c5:	a1 40 51 80 00       	mov    0x805140,%eax
  8023ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d1:	74 07                	je     8023da <print_mem_block_lists+0x9e>
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 00                	mov    (%eax),%eax
  8023d8:	eb 05                	jmp    8023df <print_mem_block_lists+0xa3>
  8023da:	b8 00 00 00 00       	mov    $0x0,%eax
  8023df:	a3 40 51 80 00       	mov    %eax,0x805140
  8023e4:	a1 40 51 80 00       	mov    0x805140,%eax
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	75 8a                	jne    802377 <print_mem_block_lists+0x3b>
  8023ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f1:	75 84                	jne    802377 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023f3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023f7:	75 10                	jne    802409 <print_mem_block_lists+0xcd>
  8023f9:	83 ec 0c             	sub    $0xc,%esp
  8023fc:	68 4c 3f 80 00       	push   $0x803f4c
  802401:	e8 6a e6 ff ff       	call   800a70 <cprintf>
  802406:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802409:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802410:	83 ec 0c             	sub    $0xc,%esp
  802413:	68 70 3f 80 00       	push   $0x803f70
  802418:	e8 53 e6 ff ff       	call   800a70 <cprintf>
  80241d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802420:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802424:	a1 40 50 80 00       	mov    0x805040,%eax
  802429:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242c:	eb 56                	jmp    802484 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80242e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802432:	74 1c                	je     802450 <print_mem_block_lists+0x114>
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 50 08             	mov    0x8(%eax),%edx
  80243a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243d:	8b 48 08             	mov    0x8(%eax),%ecx
  802440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802443:	8b 40 0c             	mov    0xc(%eax),%eax
  802446:	01 c8                	add    %ecx,%eax
  802448:	39 c2                	cmp    %eax,%edx
  80244a:	73 04                	jae    802450 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80244c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	8b 50 08             	mov    0x8(%eax),%edx
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 40 0c             	mov    0xc(%eax),%eax
  80245c:	01 c2                	add    %eax,%edx
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 40 08             	mov    0x8(%eax),%eax
  802464:	83 ec 04             	sub    $0x4,%esp
  802467:	52                   	push   %edx
  802468:	50                   	push   %eax
  802469:	68 3d 3f 80 00       	push   $0x803f3d
  80246e:	e8 fd e5 ff ff       	call   800a70 <cprintf>
  802473:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80247c:	a1 48 50 80 00       	mov    0x805048,%eax
  802481:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802488:	74 07                	je     802491 <print_mem_block_lists+0x155>
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 00                	mov    (%eax),%eax
  80248f:	eb 05                	jmp    802496 <print_mem_block_lists+0x15a>
  802491:	b8 00 00 00 00       	mov    $0x0,%eax
  802496:	a3 48 50 80 00       	mov    %eax,0x805048
  80249b:	a1 48 50 80 00       	mov    0x805048,%eax
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	75 8a                	jne    80242e <print_mem_block_lists+0xf2>
  8024a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a8:	75 84                	jne    80242e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024aa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024ae:	75 10                	jne    8024c0 <print_mem_block_lists+0x184>
  8024b0:	83 ec 0c             	sub    $0xc,%esp
  8024b3:	68 88 3f 80 00       	push   $0x803f88
  8024b8:	e8 b3 e5 ff ff       	call   800a70 <cprintf>
  8024bd:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024c0:	83 ec 0c             	sub    $0xc,%esp
  8024c3:	68 fc 3e 80 00       	push   $0x803efc
  8024c8:	e8 a3 e5 ff ff       	call   800a70 <cprintf>
  8024cd:	83 c4 10             	add    $0x10,%esp

}
  8024d0:	90                   	nop
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8024d9:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024e0:	00 00 00 
  8024e3:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024ea:	00 00 00 
  8024ed:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024f4:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8024f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024fe:	e9 9e 00 00 00       	jmp    8025a1 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802503:	a1 50 50 80 00       	mov    0x805050,%eax
  802508:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250b:	c1 e2 04             	shl    $0x4,%edx
  80250e:	01 d0                	add    %edx,%eax
  802510:	85 c0                	test   %eax,%eax
  802512:	75 14                	jne    802528 <initialize_MemBlocksList+0x55>
  802514:	83 ec 04             	sub    $0x4,%esp
  802517:	68 b0 3f 80 00       	push   $0x803fb0
  80251c:	6a 43                	push   $0x43
  80251e:	68 d3 3f 80 00       	push   $0x803fd3
  802523:	e8 94 e2 ff ff       	call   8007bc <_panic>
  802528:	a1 50 50 80 00       	mov    0x805050,%eax
  80252d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802530:	c1 e2 04             	shl    $0x4,%edx
  802533:	01 d0                	add    %edx,%eax
  802535:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80253b:	89 10                	mov    %edx,(%eax)
  80253d:	8b 00                	mov    (%eax),%eax
  80253f:	85 c0                	test   %eax,%eax
  802541:	74 18                	je     80255b <initialize_MemBlocksList+0x88>
  802543:	a1 48 51 80 00       	mov    0x805148,%eax
  802548:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80254e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802551:	c1 e1 04             	shl    $0x4,%ecx
  802554:	01 ca                	add    %ecx,%edx
  802556:	89 50 04             	mov    %edx,0x4(%eax)
  802559:	eb 12                	jmp    80256d <initialize_MemBlocksList+0x9a>
  80255b:	a1 50 50 80 00       	mov    0x805050,%eax
  802560:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802563:	c1 e2 04             	shl    $0x4,%edx
  802566:	01 d0                	add    %edx,%eax
  802568:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80256d:	a1 50 50 80 00       	mov    0x805050,%eax
  802572:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802575:	c1 e2 04             	shl    $0x4,%edx
  802578:	01 d0                	add    %edx,%eax
  80257a:	a3 48 51 80 00       	mov    %eax,0x805148
  80257f:	a1 50 50 80 00       	mov    0x805050,%eax
  802584:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802587:	c1 e2 04             	shl    $0x4,%edx
  80258a:	01 d0                	add    %edx,%eax
  80258c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802593:	a1 54 51 80 00       	mov    0x805154,%eax
  802598:	40                   	inc    %eax
  802599:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80259e:	ff 45 f4             	incl   -0xc(%ebp)
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a7:	0f 82 56 ff ff ff    	jb     802503 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8025ad:	90                   	nop
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8025b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8025bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025be:	eb 18                	jmp    8025d8 <find_block+0x28>
	{
		if (ele->sva==va)
  8025c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c3:	8b 40 08             	mov    0x8(%eax),%eax
  8025c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025c9:	75 05                	jne    8025d0 <find_block+0x20>
			return ele;
  8025cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ce:	eb 7b                	jmp    80264b <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8025d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8025d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025dc:	74 07                	je     8025e5 <find_block+0x35>
  8025de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025e1:	8b 00                	mov    (%eax),%eax
  8025e3:	eb 05                	jmp    8025ea <find_block+0x3a>
  8025e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ea:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ef:	a1 40 51 80 00       	mov    0x805140,%eax
  8025f4:	85 c0                	test   %eax,%eax
  8025f6:	75 c8                	jne    8025c0 <find_block+0x10>
  8025f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025fc:	75 c2                	jne    8025c0 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8025fe:	a1 40 50 80 00       	mov    0x805040,%eax
  802603:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802606:	eb 18                	jmp    802620 <find_block+0x70>
	{
		if (ele->sva==va)
  802608:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80260b:	8b 40 08             	mov    0x8(%eax),%eax
  80260e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802611:	75 05                	jne    802618 <find_block+0x68>
					return ele;
  802613:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802616:	eb 33                	jmp    80264b <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802618:	a1 48 50 80 00       	mov    0x805048,%eax
  80261d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802620:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802624:	74 07                	je     80262d <find_block+0x7d>
  802626:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	eb 05                	jmp    802632 <find_block+0x82>
  80262d:	b8 00 00 00 00       	mov    $0x0,%eax
  802632:	a3 48 50 80 00       	mov    %eax,0x805048
  802637:	a1 48 50 80 00       	mov    0x805048,%eax
  80263c:	85 c0                	test   %eax,%eax
  80263e:	75 c8                	jne    802608 <find_block+0x58>
  802640:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802644:	75 c2                	jne    802608 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802646:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802653:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802658:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80265b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80265f:	75 62                	jne    8026c3 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802661:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802665:	75 14                	jne    80267b <insert_sorted_allocList+0x2e>
  802667:	83 ec 04             	sub    $0x4,%esp
  80266a:	68 b0 3f 80 00       	push   $0x803fb0
  80266f:	6a 69                	push   $0x69
  802671:	68 d3 3f 80 00       	push   $0x803fd3
  802676:	e8 41 e1 ff ff       	call   8007bc <_panic>
  80267b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	89 10                	mov    %edx,(%eax)
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	85 c0                	test   %eax,%eax
  80268d:	74 0d                	je     80269c <insert_sorted_allocList+0x4f>
  80268f:	a1 40 50 80 00       	mov    0x805040,%eax
  802694:	8b 55 08             	mov    0x8(%ebp),%edx
  802697:	89 50 04             	mov    %edx,0x4(%eax)
  80269a:	eb 08                	jmp    8026a4 <insert_sorted_allocList+0x57>
  80269c:	8b 45 08             	mov    0x8(%ebp),%eax
  80269f:	a3 44 50 80 00       	mov    %eax,0x805044
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	a3 40 50 80 00       	mov    %eax,0x805040
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8026af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026bb:	40                   	inc    %eax
  8026bc:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8026c1:	eb 72                	jmp    802735 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8026c3:	a1 40 50 80 00       	mov    0x805040,%eax
  8026c8:	8b 50 08             	mov    0x8(%eax),%edx
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	8b 40 08             	mov    0x8(%eax),%eax
  8026d1:	39 c2                	cmp    %eax,%edx
  8026d3:	76 60                	jbe    802735 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8026d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026d9:	75 14                	jne    8026ef <insert_sorted_allocList+0xa2>
  8026db:	83 ec 04             	sub    $0x4,%esp
  8026de:	68 b0 3f 80 00       	push   $0x803fb0
  8026e3:	6a 6d                	push   $0x6d
  8026e5:	68 d3 3f 80 00       	push   $0x803fd3
  8026ea:	e8 cd e0 ff ff       	call   8007bc <_panic>
  8026ef:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8026f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f8:	89 10                	mov    %edx,(%eax)
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	8b 00                	mov    (%eax),%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	74 0d                	je     802710 <insert_sorted_allocList+0xc3>
  802703:	a1 40 50 80 00       	mov    0x805040,%eax
  802708:	8b 55 08             	mov    0x8(%ebp),%edx
  80270b:	89 50 04             	mov    %edx,0x4(%eax)
  80270e:	eb 08                	jmp    802718 <insert_sorted_allocList+0xcb>
  802710:	8b 45 08             	mov    0x8(%ebp),%eax
  802713:	a3 44 50 80 00       	mov    %eax,0x805044
  802718:	8b 45 08             	mov    0x8(%ebp),%eax
  80271b:	a3 40 50 80 00       	mov    %eax,0x805040
  802720:	8b 45 08             	mov    0x8(%ebp),%eax
  802723:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80272f:	40                   	inc    %eax
  802730:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802735:	a1 40 50 80 00       	mov    0x805040,%eax
  80273a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273d:	e9 b9 01 00 00       	jmp    8028fb <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802742:	8b 45 08             	mov    0x8(%ebp),%eax
  802745:	8b 50 08             	mov    0x8(%eax),%edx
  802748:	a1 40 50 80 00       	mov    0x805040,%eax
  80274d:	8b 40 08             	mov    0x8(%eax),%eax
  802750:	39 c2                	cmp    %eax,%edx
  802752:	76 7c                	jbe    8027d0 <insert_sorted_allocList+0x183>
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	8b 50 08             	mov    0x8(%eax),%edx
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 40 08             	mov    0x8(%eax),%eax
  802760:	39 c2                	cmp    %eax,%edx
  802762:	73 6c                	jae    8027d0 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802764:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802768:	74 06                	je     802770 <insert_sorted_allocList+0x123>
  80276a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80276e:	75 14                	jne    802784 <insert_sorted_allocList+0x137>
  802770:	83 ec 04             	sub    $0x4,%esp
  802773:	68 ec 3f 80 00       	push   $0x803fec
  802778:	6a 75                	push   $0x75
  80277a:	68 d3 3f 80 00       	push   $0x803fd3
  80277f:	e8 38 e0 ff ff       	call   8007bc <_panic>
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	8b 50 04             	mov    0x4(%eax),%edx
  80278a:	8b 45 08             	mov    0x8(%ebp),%eax
  80278d:	89 50 04             	mov    %edx,0x4(%eax)
  802790:	8b 45 08             	mov    0x8(%ebp),%eax
  802793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802796:	89 10                	mov    %edx,(%eax)
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 40 04             	mov    0x4(%eax),%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	74 0d                	je     8027af <insert_sorted_allocList+0x162>
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 40 04             	mov    0x4(%eax),%eax
  8027a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ab:	89 10                	mov    %edx,(%eax)
  8027ad:	eb 08                	jmp    8027b7 <insert_sorted_allocList+0x16a>
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	a3 40 50 80 00       	mov    %eax,0x805040
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8027bd:	89 50 04             	mov    %edx,0x4(%eax)
  8027c0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027c5:	40                   	inc    %eax
  8027c6:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  8027cb:	e9 59 01 00 00       	jmp    802929 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	8b 50 08             	mov    0x8(%eax),%edx
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 40 08             	mov    0x8(%eax),%eax
  8027dc:	39 c2                	cmp    %eax,%edx
  8027de:	0f 86 98 00 00 00    	jbe    80287c <insert_sorted_allocList+0x22f>
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	8b 50 08             	mov    0x8(%eax),%edx
  8027ea:	a1 44 50 80 00       	mov    0x805044,%eax
  8027ef:	8b 40 08             	mov    0x8(%eax),%eax
  8027f2:	39 c2                	cmp    %eax,%edx
  8027f4:	0f 83 82 00 00 00    	jae    80287c <insert_sorted_allocList+0x22f>
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	8b 50 08             	mov    0x8(%eax),%edx
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	8b 40 08             	mov    0x8(%eax),%eax
  802808:	39 c2                	cmp    %eax,%edx
  80280a:	73 70                	jae    80287c <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80280c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802810:	74 06                	je     802818 <insert_sorted_allocList+0x1cb>
  802812:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802816:	75 14                	jne    80282c <insert_sorted_allocList+0x1df>
  802818:	83 ec 04             	sub    $0x4,%esp
  80281b:	68 24 40 80 00       	push   $0x804024
  802820:	6a 7c                	push   $0x7c
  802822:	68 d3 3f 80 00       	push   $0x803fd3
  802827:	e8 90 df ff ff       	call   8007bc <_panic>
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 10                	mov    (%eax),%edx
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	89 10                	mov    %edx,(%eax)
  802836:	8b 45 08             	mov    0x8(%ebp),%eax
  802839:	8b 00                	mov    (%eax),%eax
  80283b:	85 c0                	test   %eax,%eax
  80283d:	74 0b                	je     80284a <insert_sorted_allocList+0x1fd>
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	8b 55 08             	mov    0x8(%ebp),%edx
  802847:	89 50 04             	mov    %edx,0x4(%eax)
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 55 08             	mov    0x8(%ebp),%edx
  802850:	89 10                	mov    %edx,(%eax)
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802858:	89 50 04             	mov    %edx,0x4(%eax)
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	85 c0                	test   %eax,%eax
  802862:	75 08                	jne    80286c <insert_sorted_allocList+0x21f>
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	a3 44 50 80 00       	mov    %eax,0x805044
  80286c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802871:	40                   	inc    %eax
  802872:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802877:	e9 ad 00 00 00       	jmp    802929 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80287c:	8b 45 08             	mov    0x8(%ebp),%eax
  80287f:	8b 50 08             	mov    0x8(%eax),%edx
  802882:	a1 44 50 80 00       	mov    0x805044,%eax
  802887:	8b 40 08             	mov    0x8(%eax),%eax
  80288a:	39 c2                	cmp    %eax,%edx
  80288c:	76 65                	jbe    8028f3 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80288e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802892:	75 17                	jne    8028ab <insert_sorted_allocList+0x25e>
  802894:	83 ec 04             	sub    $0x4,%esp
  802897:	68 58 40 80 00       	push   $0x804058
  80289c:	68 80 00 00 00       	push   $0x80
  8028a1:	68 d3 3f 80 00       	push   $0x803fd3
  8028a6:	e8 11 df ff ff       	call   8007bc <_panic>
  8028ab:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	89 50 04             	mov    %edx,0x4(%eax)
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	8b 40 04             	mov    0x4(%eax),%eax
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	74 0c                	je     8028cd <insert_sorted_allocList+0x280>
  8028c1:	a1 44 50 80 00       	mov    0x805044,%eax
  8028c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c9:	89 10                	mov    %edx,(%eax)
  8028cb:	eb 08                	jmp    8028d5 <insert_sorted_allocList+0x288>
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	a3 40 50 80 00       	mov    %eax,0x805040
  8028d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d8:	a3 44 50 80 00       	mov    %eax,0x805044
  8028dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028eb:	40                   	inc    %eax
  8028ec:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  8028f1:	eb 36                	jmp    802929 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8028f3:	a1 48 50 80 00       	mov    0x805048,%eax
  8028f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ff:	74 07                	je     802908 <insert_sorted_allocList+0x2bb>
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	8b 00                	mov    (%eax),%eax
  802906:	eb 05                	jmp    80290d <insert_sorted_allocList+0x2c0>
  802908:	b8 00 00 00 00       	mov    $0x0,%eax
  80290d:	a3 48 50 80 00       	mov    %eax,0x805048
  802912:	a1 48 50 80 00       	mov    0x805048,%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	0f 85 23 fe ff ff    	jne    802742 <insert_sorted_allocList+0xf5>
  80291f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802923:	0f 85 19 fe ff ff    	jne    802742 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802929:	90                   	nop
  80292a:	c9                   	leave  
  80292b:	c3                   	ret    

0080292c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
  80292f:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802932:	a1 38 51 80 00       	mov    0x805138,%eax
  802937:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293a:	e9 7c 01 00 00       	jmp    802abb <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 40 0c             	mov    0xc(%eax),%eax
  802945:	3b 45 08             	cmp    0x8(%ebp),%eax
  802948:	0f 85 90 00 00 00    	jne    8029de <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802954:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802958:	75 17                	jne    802971 <alloc_block_FF+0x45>
  80295a:	83 ec 04             	sub    $0x4,%esp
  80295d:	68 7b 40 80 00       	push   $0x80407b
  802962:	68 ba 00 00 00       	push   $0xba
  802967:	68 d3 3f 80 00       	push   $0x803fd3
  80296c:	e8 4b de ff ff       	call   8007bc <_panic>
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 00                	mov    (%eax),%eax
  802976:	85 c0                	test   %eax,%eax
  802978:	74 10                	je     80298a <alloc_block_FF+0x5e>
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 00                	mov    (%eax),%eax
  80297f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802982:	8b 52 04             	mov    0x4(%edx),%edx
  802985:	89 50 04             	mov    %edx,0x4(%eax)
  802988:	eb 0b                	jmp    802995 <alloc_block_FF+0x69>
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 40 04             	mov    0x4(%eax),%eax
  802990:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	8b 40 04             	mov    0x4(%eax),%eax
  80299b:	85 c0                	test   %eax,%eax
  80299d:	74 0f                	je     8029ae <alloc_block_FF+0x82>
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 40 04             	mov    0x4(%eax),%eax
  8029a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a8:	8b 12                	mov    (%edx),%edx
  8029aa:	89 10                	mov    %edx,(%eax)
  8029ac:	eb 0a                	jmp    8029b8 <alloc_block_FF+0x8c>
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 00                	mov    (%eax),%eax
  8029b3:	a3 38 51 80 00       	mov    %eax,0x805138
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8029d0:	48                   	dec    %eax
  8029d1:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  8029d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d9:	e9 10 01 00 00       	jmp    802aee <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e7:	0f 86 c6 00 00 00    	jbe    802ab3 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8029ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8029f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8029f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f9:	75 17                	jne    802a12 <alloc_block_FF+0xe6>
  8029fb:	83 ec 04             	sub    $0x4,%esp
  8029fe:	68 7b 40 80 00       	push   $0x80407b
  802a03:	68 c2 00 00 00       	push   $0xc2
  802a08:	68 d3 3f 80 00       	push   $0x803fd3
  802a0d:	e8 aa dd ff ff       	call   8007bc <_panic>
  802a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	74 10                	je     802a2b <alloc_block_FF+0xff>
  802a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1e:	8b 00                	mov    (%eax),%eax
  802a20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a23:	8b 52 04             	mov    0x4(%edx),%edx
  802a26:	89 50 04             	mov    %edx,0x4(%eax)
  802a29:	eb 0b                	jmp    802a36 <alloc_block_FF+0x10a>
  802a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2e:	8b 40 04             	mov    0x4(%eax),%eax
  802a31:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a39:	8b 40 04             	mov    0x4(%eax),%eax
  802a3c:	85 c0                	test   %eax,%eax
  802a3e:	74 0f                	je     802a4f <alloc_block_FF+0x123>
  802a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a43:	8b 40 04             	mov    0x4(%eax),%eax
  802a46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a49:	8b 12                	mov    (%edx),%edx
  802a4b:	89 10                	mov    %edx,(%eax)
  802a4d:	eb 0a                	jmp    802a59 <alloc_block_FF+0x12d>
  802a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a52:	8b 00                	mov    (%eax),%eax
  802a54:	a3 48 51 80 00       	mov    %eax,0x805148
  802a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6c:	a1 54 51 80 00       	mov    0x805154,%eax
  802a71:	48                   	dec    %eax
  802a72:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 50 08             	mov    0x8(%eax),%edx
  802a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a80:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a86:	8b 55 08             	mov    0x8(%ebp),%edx
  802a89:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a92:	2b 45 08             	sub    0x8(%ebp),%eax
  802a95:	89 c2                	mov    %eax,%edx
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 50 08             	mov    0x8(%eax),%edx
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	01 c2                	add    %eax,%edx
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab1:	eb 3b                	jmp    802aee <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802ab3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802abb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802abf:	74 07                	je     802ac8 <alloc_block_FF+0x19c>
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	eb 05                	jmp    802acd <alloc_block_FF+0x1a1>
  802ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  802acd:	a3 40 51 80 00       	mov    %eax,0x805140
  802ad2:	a1 40 51 80 00       	mov    0x805140,%eax
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	0f 85 60 fe ff ff    	jne    80293f <alloc_block_FF+0x13>
  802adf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae3:	0f 85 56 fe ff ff    	jne    80293f <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  802aee:	c9                   	leave  
  802aef:	c3                   	ret    

00802af0 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802af0:	55                   	push   %ebp
  802af1:	89 e5                	mov    %esp,%ebp
  802af3:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802af6:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802afd:	a1 38 51 80 00       	mov    0x805138,%eax
  802b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b05:	eb 3a                	jmp    802b41 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b10:	72 27                	jb     802b39 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802b12:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b16:	75 0b                	jne    802b23 <alloc_block_BF+0x33>
					best_size= element->size;
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b21:	eb 16                	jmp    802b39 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 50 0c             	mov    0xc(%eax),%edx
  802b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2c:	39 c2                	cmp    %eax,%edx
  802b2e:	77 09                	ja     802b39 <alloc_block_BF+0x49>
					best_size=element->size;
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 0c             	mov    0xc(%eax),%eax
  802b36:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802b39:	a1 40 51 80 00       	mov    0x805140,%eax
  802b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b45:	74 07                	je     802b4e <alloc_block_BF+0x5e>
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	eb 05                	jmp    802b53 <alloc_block_BF+0x63>
  802b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b53:	a3 40 51 80 00       	mov    %eax,0x805140
  802b58:	a1 40 51 80 00       	mov    0x805140,%eax
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	75 a6                	jne    802b07 <alloc_block_BF+0x17>
  802b61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b65:	75 a0                	jne    802b07 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802b67:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b6b:	0f 84 d3 01 00 00    	je     802d44 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802b71:	a1 38 51 80 00       	mov    0x805138,%eax
  802b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b79:	e9 98 01 00 00       	jmp    802d16 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b81:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b84:	0f 86 da 00 00 00    	jbe    802c64 <alloc_block_BF+0x174>
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 50 0c             	mov    0xc(%eax),%edx
  802b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b93:	39 c2                	cmp    %eax,%edx
  802b95:	0f 85 c9 00 00 00    	jne    802c64 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802b9b:	a1 48 51 80 00       	mov    0x805148,%eax
  802ba0:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802ba3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ba7:	75 17                	jne    802bc0 <alloc_block_BF+0xd0>
  802ba9:	83 ec 04             	sub    $0x4,%esp
  802bac:	68 7b 40 80 00       	push   $0x80407b
  802bb1:	68 ea 00 00 00       	push   $0xea
  802bb6:	68 d3 3f 80 00       	push   $0x803fd3
  802bbb:	e8 fc db ff ff       	call   8007bc <_panic>
  802bc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	74 10                	je     802bd9 <alloc_block_BF+0xe9>
  802bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd1:	8b 52 04             	mov    0x4(%edx),%edx
  802bd4:	89 50 04             	mov    %edx,0x4(%eax)
  802bd7:	eb 0b                	jmp    802be4 <alloc_block_BF+0xf4>
  802bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdc:	8b 40 04             	mov    0x4(%eax),%eax
  802bdf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be7:	8b 40 04             	mov    0x4(%eax),%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	74 0f                	je     802bfd <alloc_block_BF+0x10d>
  802bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf1:	8b 40 04             	mov    0x4(%eax),%eax
  802bf4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bf7:	8b 12                	mov    (%edx),%edx
  802bf9:	89 10                	mov    %edx,(%eax)
  802bfb:	eb 0a                	jmp    802c07 <alloc_block_BF+0x117>
  802bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	a3 48 51 80 00       	mov    %eax,0x805148
  802c07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1a:	a1 54 51 80 00       	mov    0x805154,%eax
  802c1f:	48                   	dec    %eax
  802c20:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 50 08             	mov    0x8(%eax),%edx
  802c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2e:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c34:	8b 55 08             	mov    0x8(%ebp),%edx
  802c37:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c40:	2b 45 08             	sub    0x8(%ebp),%eax
  802c43:	89 c2                	mov    %eax,%edx
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 50 08             	mov    0x8(%eax),%edx
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	01 c2                	add    %eax,%edx
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5f:	e9 e5 00 00 00       	jmp    802d49 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	8b 50 0c             	mov    0xc(%eax),%edx
  802c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6d:	39 c2                	cmp    %eax,%edx
  802c6f:	0f 85 99 00 00 00    	jne    802d0e <alloc_block_BF+0x21e>
  802c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c7b:	0f 85 8d 00 00 00    	jne    802d0e <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8b:	75 17                	jne    802ca4 <alloc_block_BF+0x1b4>
  802c8d:	83 ec 04             	sub    $0x4,%esp
  802c90:	68 7b 40 80 00       	push   $0x80407b
  802c95:	68 f7 00 00 00       	push   $0xf7
  802c9a:	68 d3 3f 80 00       	push   $0x803fd3
  802c9f:	e8 18 db ff ff       	call   8007bc <_panic>
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 00                	mov    (%eax),%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	74 10                	je     802cbd <alloc_block_BF+0x1cd>
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb5:	8b 52 04             	mov    0x4(%edx),%edx
  802cb8:	89 50 04             	mov    %edx,0x4(%eax)
  802cbb:	eb 0b                	jmp    802cc8 <alloc_block_BF+0x1d8>
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	8b 40 04             	mov    0x4(%eax),%eax
  802cc3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 40 04             	mov    0x4(%eax),%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	74 0f                	je     802ce1 <alloc_block_BF+0x1f1>
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 40 04             	mov    0x4(%eax),%eax
  802cd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdb:	8b 12                	mov    (%edx),%edx
  802cdd:	89 10                	mov    %edx,(%eax)
  802cdf:	eb 0a                	jmp    802ceb <alloc_block_BF+0x1fb>
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	a3 38 51 80 00       	mov    %eax,0x805138
  802ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfe:	a1 44 51 80 00       	mov    0x805144,%eax
  802d03:	48                   	dec    %eax
  802d04:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0c:	eb 3b                	jmp    802d49 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802d0e:	a1 40 51 80 00       	mov    0x805140,%eax
  802d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1a:	74 07                	je     802d23 <alloc_block_BF+0x233>
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	8b 00                	mov    (%eax),%eax
  802d21:	eb 05                	jmp    802d28 <alloc_block_BF+0x238>
  802d23:	b8 00 00 00 00       	mov    $0x0,%eax
  802d28:	a3 40 51 80 00       	mov    %eax,0x805140
  802d2d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d32:	85 c0                	test   %eax,%eax
  802d34:	0f 85 44 fe ff ff    	jne    802b7e <alloc_block_BF+0x8e>
  802d3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3e:	0f 85 3a fe ff ff    	jne    802b7e <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802d44:	b8 00 00 00 00       	mov    $0x0,%eax
  802d49:	c9                   	leave  
  802d4a:	c3                   	ret    

00802d4b <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d4b:	55                   	push   %ebp
  802d4c:	89 e5                	mov    %esp,%ebp
  802d4e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802d51:	83 ec 04             	sub    $0x4,%esp
  802d54:	68 9c 40 80 00       	push   $0x80409c
  802d59:	68 04 01 00 00       	push   $0x104
  802d5e:	68 d3 3f 80 00       	push   $0x803fd3
  802d63:	e8 54 da ff ff       	call   8007bc <_panic>

00802d68 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802d68:	55                   	push   %ebp
  802d69:	89 e5                	mov    %esp,%ebp
  802d6b:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802d6e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802d76:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d7b:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802d7e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d83:	85 c0                	test   %eax,%eax
  802d85:	75 68                	jne    802def <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802d87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d8b:	75 17                	jne    802da4 <insert_sorted_with_merge_freeList+0x3c>
  802d8d:	83 ec 04             	sub    $0x4,%esp
  802d90:	68 b0 3f 80 00       	push   $0x803fb0
  802d95:	68 14 01 00 00       	push   $0x114
  802d9a:	68 d3 3f 80 00       	push   $0x803fd3
  802d9f:	e8 18 da ff ff       	call   8007bc <_panic>
  802da4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	89 10                	mov    %edx,(%eax)
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	8b 00                	mov    (%eax),%eax
  802db4:	85 c0                	test   %eax,%eax
  802db6:	74 0d                	je     802dc5 <insert_sorted_with_merge_freeList+0x5d>
  802db8:	a1 38 51 80 00       	mov    0x805138,%eax
  802dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc0:	89 50 04             	mov    %edx,0x4(%eax)
  802dc3:	eb 08                	jmp    802dcd <insert_sorted_with_merge_freeList+0x65>
  802dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	a3 38 51 80 00       	mov    %eax,0x805138
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddf:	a1 44 51 80 00       	mov    0x805144,%eax
  802de4:	40                   	inc    %eax
  802de5:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802dea:	e9 d2 06 00 00       	jmp    8034c1 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802def:	8b 45 08             	mov    0x8(%ebp),%eax
  802df2:	8b 50 08             	mov    0x8(%eax),%edx
  802df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df8:	8b 40 08             	mov    0x8(%eax),%eax
  802dfb:	39 c2                	cmp    %eax,%edx
  802dfd:	0f 83 22 01 00 00    	jae    802f25 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	8b 50 08             	mov    0x8(%eax),%edx
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0f:	01 c2                	add    %eax,%edx
  802e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e14:	8b 40 08             	mov    0x8(%eax),%eax
  802e17:	39 c2                	cmp    %eax,%edx
  802e19:	0f 85 9e 00 00 00    	jne    802ebd <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	8b 50 08             	mov    0x8(%eax),%edx
  802e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e28:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	8b 40 0c             	mov    0xc(%eax),%eax
  802e37:	01 c2                	add    %eax,%edx
  802e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3c:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	8b 50 08             	mov    0x8(%eax),%edx
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e59:	75 17                	jne    802e72 <insert_sorted_with_merge_freeList+0x10a>
  802e5b:	83 ec 04             	sub    $0x4,%esp
  802e5e:	68 b0 3f 80 00       	push   $0x803fb0
  802e63:	68 21 01 00 00       	push   $0x121
  802e68:	68 d3 3f 80 00       	push   $0x803fd3
  802e6d:	e8 4a d9 ff ff       	call   8007bc <_panic>
  802e72:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	89 10                	mov    %edx,(%eax)
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 0d                	je     802e93 <insert_sorted_with_merge_freeList+0x12b>
  802e86:	a1 48 51 80 00       	mov    0x805148,%eax
  802e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8e:	89 50 04             	mov    %edx,0x4(%eax)
  802e91:	eb 08                	jmp    802e9b <insert_sorted_with_merge_freeList+0x133>
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ead:	a1 54 51 80 00       	mov    0x805154,%eax
  802eb2:	40                   	inc    %eax
  802eb3:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802eb8:	e9 04 06 00 00       	jmp    8034c1 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802ebd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec1:	75 17                	jne    802eda <insert_sorted_with_merge_freeList+0x172>
  802ec3:	83 ec 04             	sub    $0x4,%esp
  802ec6:	68 b0 3f 80 00       	push   $0x803fb0
  802ecb:	68 26 01 00 00       	push   $0x126
  802ed0:	68 d3 3f 80 00       	push   $0x803fd3
  802ed5:	e8 e2 d8 ff ff       	call   8007bc <_panic>
  802eda:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	89 10                	mov    %edx,(%eax)
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	8b 00                	mov    (%eax),%eax
  802eea:	85 c0                	test   %eax,%eax
  802eec:	74 0d                	je     802efb <insert_sorted_with_merge_freeList+0x193>
  802eee:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef6:	89 50 04             	mov    %edx,0x4(%eax)
  802ef9:	eb 08                	jmp    802f03 <insert_sorted_with_merge_freeList+0x19b>
  802efb:	8b 45 08             	mov    0x8(%ebp),%eax
  802efe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	a3 38 51 80 00       	mov    %eax,0x805138
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f15:	a1 44 51 80 00       	mov    0x805144,%eax
  802f1a:	40                   	inc    %eax
  802f1b:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802f20:	e9 9c 05 00 00       	jmp    8034c1 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	8b 50 08             	mov    0x8(%eax),%edx
  802f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2e:	8b 40 08             	mov    0x8(%eax),%eax
  802f31:	39 c2                	cmp    %eax,%edx
  802f33:	0f 86 16 01 00 00    	jbe    80304f <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802f39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3c:	8b 50 08             	mov    0x8(%eax),%edx
  802f3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f42:	8b 40 0c             	mov    0xc(%eax),%eax
  802f45:	01 c2                	add    %eax,%edx
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	8b 40 08             	mov    0x8(%eax),%eax
  802f4d:	39 c2                	cmp    %eax,%edx
  802f4f:	0f 85 92 00 00 00    	jne    802fe7 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802f55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f58:	8b 50 0c             	mov    0xc(%eax),%edx
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f61:	01 c2                	add    %eax,%edx
  802f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f66:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	8b 50 08             	mov    0x8(%eax),%edx
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f83:	75 17                	jne    802f9c <insert_sorted_with_merge_freeList+0x234>
  802f85:	83 ec 04             	sub    $0x4,%esp
  802f88:	68 b0 3f 80 00       	push   $0x803fb0
  802f8d:	68 31 01 00 00       	push   $0x131
  802f92:	68 d3 3f 80 00       	push   $0x803fd3
  802f97:	e8 20 d8 ff ff       	call   8007bc <_panic>
  802f9c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	89 10                	mov    %edx,(%eax)
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	8b 00                	mov    (%eax),%eax
  802fac:	85 c0                	test   %eax,%eax
  802fae:	74 0d                	je     802fbd <insert_sorted_with_merge_freeList+0x255>
  802fb0:	a1 48 51 80 00       	mov    0x805148,%eax
  802fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb8:	89 50 04             	mov    %edx,0x4(%eax)
  802fbb:	eb 08                	jmp    802fc5 <insert_sorted_with_merge_freeList+0x25d>
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	a3 48 51 80 00       	mov    %eax,0x805148
  802fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd7:	a1 54 51 80 00       	mov    0x805154,%eax
  802fdc:	40                   	inc    %eax
  802fdd:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802fe2:	e9 da 04 00 00       	jmp    8034c1 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802fe7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802feb:	75 17                	jne    803004 <insert_sorted_with_merge_freeList+0x29c>
  802fed:	83 ec 04             	sub    $0x4,%esp
  802ff0:	68 58 40 80 00       	push   $0x804058
  802ff5:	68 37 01 00 00       	push   $0x137
  802ffa:	68 d3 3f 80 00       	push   $0x803fd3
  802fff:	e8 b8 d7 ff ff       	call   8007bc <_panic>
  803004:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	89 50 04             	mov    %edx,0x4(%eax)
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	8b 40 04             	mov    0x4(%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 0c                	je     803026 <insert_sorted_with_merge_freeList+0x2be>
  80301a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80301f:	8b 55 08             	mov    0x8(%ebp),%edx
  803022:	89 10                	mov    %edx,(%eax)
  803024:	eb 08                	jmp    80302e <insert_sorted_with_merge_freeList+0x2c6>
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	a3 38 51 80 00       	mov    %eax,0x805138
  80302e:	8b 45 08             	mov    0x8(%ebp),%eax
  803031:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303f:	a1 44 51 80 00       	mov    0x805144,%eax
  803044:	40                   	inc    %eax
  803045:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  80304a:	e9 72 04 00 00       	jmp    8034c1 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80304f:	a1 38 51 80 00       	mov    0x805138,%eax
  803054:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803057:	e9 35 04 00 00       	jmp    803491 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	8b 50 08             	mov    0x8(%eax),%edx
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 40 08             	mov    0x8(%eax),%eax
  803070:	39 c2                	cmp    %eax,%edx
  803072:	0f 86 11 04 00 00    	jbe    803489 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	8b 50 08             	mov    0x8(%eax),%edx
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	8b 40 0c             	mov    0xc(%eax),%eax
  803084:	01 c2                	add    %eax,%edx
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	8b 40 08             	mov    0x8(%eax),%eax
  80308c:	39 c2                	cmp    %eax,%edx
  80308e:	0f 83 8b 00 00 00    	jae    80311f <insert_sorted_with_merge_freeList+0x3b7>
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	8b 50 08             	mov    0x8(%eax),%edx
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a0:	01 c2                	add    %eax,%edx
  8030a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a5:	8b 40 08             	mov    0x8(%eax),%eax
  8030a8:	39 c2                	cmp    %eax,%edx
  8030aa:	73 73                	jae    80311f <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  8030ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b0:	74 06                	je     8030b8 <insert_sorted_with_merge_freeList+0x350>
  8030b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b6:	75 17                	jne    8030cf <insert_sorted_with_merge_freeList+0x367>
  8030b8:	83 ec 04             	sub    $0x4,%esp
  8030bb:	68 24 40 80 00       	push   $0x804024
  8030c0:	68 48 01 00 00       	push   $0x148
  8030c5:	68 d3 3f 80 00       	push   $0x803fd3
  8030ca:	e8 ed d6 ff ff       	call   8007bc <_panic>
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	8b 10                	mov    (%eax),%edx
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	89 10                	mov    %edx,(%eax)
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	74 0b                	je     8030ed <insert_sorted_with_merge_freeList+0x385>
  8030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e5:	8b 00                	mov    (%eax),%eax
  8030e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ea:	89 50 04             	mov    %edx,0x4(%eax)
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f3:	89 10                	mov    %edx,(%eax)
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030fb:	89 50 04             	mov    %edx,0x4(%eax)
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	75 08                	jne    80310f <insert_sorted_with_merge_freeList+0x3a7>
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80310f:	a1 44 51 80 00       	mov    0x805144,%eax
  803114:	40                   	inc    %eax
  803115:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  80311a:	e9 a2 03 00 00       	jmp    8034c1 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80311f:	8b 45 08             	mov    0x8(%ebp),%eax
  803122:	8b 50 08             	mov    0x8(%eax),%edx
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	8b 40 0c             	mov    0xc(%eax),%eax
  80312b:	01 c2                	add    %eax,%edx
  80312d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803130:	8b 40 08             	mov    0x8(%eax),%eax
  803133:	39 c2                	cmp    %eax,%edx
  803135:	0f 83 ae 00 00 00    	jae    8031e9 <insert_sorted_with_merge_freeList+0x481>
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	8b 50 08             	mov    0x8(%eax),%edx
  803141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803144:	8b 48 08             	mov    0x8(%eax),%ecx
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	8b 40 0c             	mov    0xc(%eax),%eax
  80314d:	01 c8                	add    %ecx,%eax
  80314f:	39 c2                	cmp    %eax,%edx
  803151:	0f 85 92 00 00 00    	jne    8031e9 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315a:	8b 50 0c             	mov    0xc(%eax),%edx
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	8b 40 0c             	mov    0xc(%eax),%eax
  803163:	01 c2                	add    %eax,%edx
  803165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803168:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	8b 50 08             	mov    0x8(%eax),%edx
  80317b:	8b 45 08             	mov    0x8(%ebp),%eax
  80317e:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803181:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803185:	75 17                	jne    80319e <insert_sorted_with_merge_freeList+0x436>
  803187:	83 ec 04             	sub    $0x4,%esp
  80318a:	68 b0 3f 80 00       	push   $0x803fb0
  80318f:	68 51 01 00 00       	push   $0x151
  803194:	68 d3 3f 80 00       	push   $0x803fd3
  803199:	e8 1e d6 ff ff       	call   8007bc <_panic>
  80319e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	89 10                	mov    %edx,(%eax)
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	74 0d                	je     8031bf <insert_sorted_with_merge_freeList+0x457>
  8031b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8031b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ba:	89 50 04             	mov    %edx,0x4(%eax)
  8031bd:	eb 08                	jmp    8031c7 <insert_sorted_with_merge_freeList+0x45f>
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8031de:	40                   	inc    %eax
  8031df:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  8031e4:	e9 d8 02 00 00       	jmp    8034c1 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	8b 50 08             	mov    0x8(%eax),%edx
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f5:	01 c2                	add    %eax,%edx
  8031f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fa:	8b 40 08             	mov    0x8(%eax),%eax
  8031fd:	39 c2                	cmp    %eax,%edx
  8031ff:	0f 85 ba 00 00 00    	jne    8032bf <insert_sorted_with_merge_freeList+0x557>
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	8b 50 08             	mov    0x8(%eax),%edx
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	8b 48 08             	mov    0x8(%eax),%ecx
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	8b 40 0c             	mov    0xc(%eax),%eax
  803217:	01 c8                	add    %ecx,%eax
  803219:	39 c2                	cmp    %eax,%edx
  80321b:	0f 86 9e 00 00 00    	jbe    8032bf <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803224:	8b 50 0c             	mov    0xc(%eax),%edx
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	8b 40 0c             	mov    0xc(%eax),%eax
  80322d:	01 c2                	add    %eax,%edx
  80322f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803232:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	8b 50 08             	mov    0x8(%eax),%edx
  80323b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323e:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80324b:	8b 45 08             	mov    0x8(%ebp),%eax
  80324e:	8b 50 08             	mov    0x8(%eax),%edx
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803257:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325b:	75 17                	jne    803274 <insert_sorted_with_merge_freeList+0x50c>
  80325d:	83 ec 04             	sub    $0x4,%esp
  803260:	68 b0 3f 80 00       	push   $0x803fb0
  803265:	68 5b 01 00 00       	push   $0x15b
  80326a:	68 d3 3f 80 00       	push   $0x803fd3
  80326f:	e8 48 d5 ff ff       	call   8007bc <_panic>
  803274:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	89 10                	mov    %edx,(%eax)
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	8b 00                	mov    (%eax),%eax
  803284:	85 c0                	test   %eax,%eax
  803286:	74 0d                	je     803295 <insert_sorted_with_merge_freeList+0x52d>
  803288:	a1 48 51 80 00       	mov    0x805148,%eax
  80328d:	8b 55 08             	mov    0x8(%ebp),%edx
  803290:	89 50 04             	mov    %edx,0x4(%eax)
  803293:	eb 08                	jmp    80329d <insert_sorted_with_merge_freeList+0x535>
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80329d:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a0:	a3 48 51 80 00       	mov    %eax,0x805148
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032af:	a1 54 51 80 00       	mov    0x805154,%eax
  8032b4:	40                   	inc    %eax
  8032b5:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8032ba:	e9 02 02 00 00       	jmp    8034c1 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	8b 50 08             	mov    0x8(%eax),%edx
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032cb:	01 c2                	add    %eax,%edx
  8032cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d0:	8b 40 08             	mov    0x8(%eax),%eax
  8032d3:	39 c2                	cmp    %eax,%edx
  8032d5:	0f 85 ae 01 00 00    	jne    803489 <insert_sorted_with_merge_freeList+0x721>
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	8b 50 08             	mov    0x8(%eax),%edx
  8032e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e4:	8b 48 08             	mov    0x8(%eax),%ecx
  8032e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ed:	01 c8                	add    %ecx,%eax
  8032ef:	39 c2                	cmp    %eax,%edx
  8032f1:	0f 85 92 01 00 00    	jne    803489 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fa:	8b 50 0c             	mov    0xc(%eax),%edx
  8032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803300:	8b 40 0c             	mov    0xc(%eax),%eax
  803303:	01 c2                	add    %eax,%edx
  803305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803308:	8b 40 0c             	mov    0xc(%eax),%eax
  80330b:	01 c2                	add    %eax,%edx
  80330d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803310:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	8b 50 08             	mov    0x8(%eax),%edx
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803333:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803336:	8b 50 08             	mov    0x8(%eax),%edx
  803339:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333c:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  80333f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803343:	75 17                	jne    80335c <insert_sorted_with_merge_freeList+0x5f4>
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	68 7b 40 80 00       	push   $0x80407b
  80334d:	68 63 01 00 00       	push   $0x163
  803352:	68 d3 3f 80 00       	push   $0x803fd3
  803357:	e8 60 d4 ff ff       	call   8007bc <_panic>
  80335c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335f:	8b 00                	mov    (%eax),%eax
  803361:	85 c0                	test   %eax,%eax
  803363:	74 10                	je     803375 <insert_sorted_with_merge_freeList+0x60d>
  803365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803368:	8b 00                	mov    (%eax),%eax
  80336a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80336d:	8b 52 04             	mov    0x4(%edx),%edx
  803370:	89 50 04             	mov    %edx,0x4(%eax)
  803373:	eb 0b                	jmp    803380 <insert_sorted_with_merge_freeList+0x618>
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	8b 40 04             	mov    0x4(%eax),%eax
  80337b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803380:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803383:	8b 40 04             	mov    0x4(%eax),%eax
  803386:	85 c0                	test   %eax,%eax
  803388:	74 0f                	je     803399 <insert_sorted_with_merge_freeList+0x631>
  80338a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338d:	8b 40 04             	mov    0x4(%eax),%eax
  803390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803393:	8b 12                	mov    (%edx),%edx
  803395:	89 10                	mov    %edx,(%eax)
  803397:	eb 0a                	jmp    8033a3 <insert_sorted_with_merge_freeList+0x63b>
  803399:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339c:	8b 00                	mov    (%eax),%eax
  80339e:	a3 38 51 80 00       	mov    %eax,0x805138
  8033a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b6:	a1 44 51 80 00       	mov    0x805144,%eax
  8033bb:	48                   	dec    %eax
  8033bc:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8033c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c5:	75 17                	jne    8033de <insert_sorted_with_merge_freeList+0x676>
  8033c7:	83 ec 04             	sub    $0x4,%esp
  8033ca:	68 b0 3f 80 00       	push   $0x803fb0
  8033cf:	68 64 01 00 00       	push   $0x164
  8033d4:	68 d3 3f 80 00       	push   $0x803fd3
  8033d9:	e8 de d3 ff ff       	call   8007bc <_panic>
  8033de:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e7:	89 10                	mov    %edx,(%eax)
  8033e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	85 c0                	test   %eax,%eax
  8033f0:	74 0d                	je     8033ff <insert_sorted_with_merge_freeList+0x697>
  8033f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033fa:	89 50 04             	mov    %edx,0x4(%eax)
  8033fd:	eb 08                	jmp    803407 <insert_sorted_with_merge_freeList+0x69f>
  8033ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803402:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340a:	a3 48 51 80 00       	mov    %eax,0x805148
  80340f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803412:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803419:	a1 54 51 80 00       	mov    0x805154,%eax
  80341e:	40                   	inc    %eax
  80341f:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803424:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803428:	75 17                	jne    803441 <insert_sorted_with_merge_freeList+0x6d9>
  80342a:	83 ec 04             	sub    $0x4,%esp
  80342d:	68 b0 3f 80 00       	push   $0x803fb0
  803432:	68 65 01 00 00       	push   $0x165
  803437:	68 d3 3f 80 00       	push   $0x803fd3
  80343c:	e8 7b d3 ff ff       	call   8007bc <_panic>
  803441:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803447:	8b 45 08             	mov    0x8(%ebp),%eax
  80344a:	89 10                	mov    %edx,(%eax)
  80344c:	8b 45 08             	mov    0x8(%ebp),%eax
  80344f:	8b 00                	mov    (%eax),%eax
  803451:	85 c0                	test   %eax,%eax
  803453:	74 0d                	je     803462 <insert_sorted_with_merge_freeList+0x6fa>
  803455:	a1 48 51 80 00       	mov    0x805148,%eax
  80345a:	8b 55 08             	mov    0x8(%ebp),%edx
  80345d:	89 50 04             	mov    %edx,0x4(%eax)
  803460:	eb 08                	jmp    80346a <insert_sorted_with_merge_freeList+0x702>
  803462:	8b 45 08             	mov    0x8(%ebp),%eax
  803465:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	a3 48 51 80 00       	mov    %eax,0x805148
  803472:	8b 45 08             	mov    0x8(%ebp),%eax
  803475:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347c:	a1 54 51 80 00       	mov    0x805154,%eax
  803481:	40                   	inc    %eax
  803482:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803487:	eb 38                	jmp    8034c1 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803489:	a1 40 51 80 00       	mov    0x805140,%eax
  80348e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803495:	74 07                	je     80349e <insert_sorted_with_merge_freeList+0x736>
  803497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349a:	8b 00                	mov    (%eax),%eax
  80349c:	eb 05                	jmp    8034a3 <insert_sorted_with_merge_freeList+0x73b>
  80349e:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a3:	a3 40 51 80 00       	mov    %eax,0x805140
  8034a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8034ad:	85 c0                	test   %eax,%eax
  8034af:	0f 85 a7 fb ff ff    	jne    80305c <insert_sorted_with_merge_freeList+0x2f4>
  8034b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b9:	0f 85 9d fb ff ff    	jne    80305c <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8034bf:	eb 00                	jmp    8034c1 <insert_sorted_with_merge_freeList+0x759>
  8034c1:	90                   	nop
  8034c2:	c9                   	leave  
  8034c3:	c3                   	ret    

008034c4 <__udivdi3>:
  8034c4:	55                   	push   %ebp
  8034c5:	57                   	push   %edi
  8034c6:	56                   	push   %esi
  8034c7:	53                   	push   %ebx
  8034c8:	83 ec 1c             	sub    $0x1c,%esp
  8034cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034db:	89 ca                	mov    %ecx,%edx
  8034dd:	89 f8                	mov    %edi,%eax
  8034df:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034e3:	85 f6                	test   %esi,%esi
  8034e5:	75 2d                	jne    803514 <__udivdi3+0x50>
  8034e7:	39 cf                	cmp    %ecx,%edi
  8034e9:	77 65                	ja     803550 <__udivdi3+0x8c>
  8034eb:	89 fd                	mov    %edi,%ebp
  8034ed:	85 ff                	test   %edi,%edi
  8034ef:	75 0b                	jne    8034fc <__udivdi3+0x38>
  8034f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8034f6:	31 d2                	xor    %edx,%edx
  8034f8:	f7 f7                	div    %edi
  8034fa:	89 c5                	mov    %eax,%ebp
  8034fc:	31 d2                	xor    %edx,%edx
  8034fe:	89 c8                	mov    %ecx,%eax
  803500:	f7 f5                	div    %ebp
  803502:	89 c1                	mov    %eax,%ecx
  803504:	89 d8                	mov    %ebx,%eax
  803506:	f7 f5                	div    %ebp
  803508:	89 cf                	mov    %ecx,%edi
  80350a:	89 fa                	mov    %edi,%edx
  80350c:	83 c4 1c             	add    $0x1c,%esp
  80350f:	5b                   	pop    %ebx
  803510:	5e                   	pop    %esi
  803511:	5f                   	pop    %edi
  803512:	5d                   	pop    %ebp
  803513:	c3                   	ret    
  803514:	39 ce                	cmp    %ecx,%esi
  803516:	77 28                	ja     803540 <__udivdi3+0x7c>
  803518:	0f bd fe             	bsr    %esi,%edi
  80351b:	83 f7 1f             	xor    $0x1f,%edi
  80351e:	75 40                	jne    803560 <__udivdi3+0x9c>
  803520:	39 ce                	cmp    %ecx,%esi
  803522:	72 0a                	jb     80352e <__udivdi3+0x6a>
  803524:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803528:	0f 87 9e 00 00 00    	ja     8035cc <__udivdi3+0x108>
  80352e:	b8 01 00 00 00       	mov    $0x1,%eax
  803533:	89 fa                	mov    %edi,%edx
  803535:	83 c4 1c             	add    $0x1c,%esp
  803538:	5b                   	pop    %ebx
  803539:	5e                   	pop    %esi
  80353a:	5f                   	pop    %edi
  80353b:	5d                   	pop    %ebp
  80353c:	c3                   	ret    
  80353d:	8d 76 00             	lea    0x0(%esi),%esi
  803540:	31 ff                	xor    %edi,%edi
  803542:	31 c0                	xor    %eax,%eax
  803544:	89 fa                	mov    %edi,%edx
  803546:	83 c4 1c             	add    $0x1c,%esp
  803549:	5b                   	pop    %ebx
  80354a:	5e                   	pop    %esi
  80354b:	5f                   	pop    %edi
  80354c:	5d                   	pop    %ebp
  80354d:	c3                   	ret    
  80354e:	66 90                	xchg   %ax,%ax
  803550:	89 d8                	mov    %ebx,%eax
  803552:	f7 f7                	div    %edi
  803554:	31 ff                	xor    %edi,%edi
  803556:	89 fa                	mov    %edi,%edx
  803558:	83 c4 1c             	add    $0x1c,%esp
  80355b:	5b                   	pop    %ebx
  80355c:	5e                   	pop    %esi
  80355d:	5f                   	pop    %edi
  80355e:	5d                   	pop    %ebp
  80355f:	c3                   	ret    
  803560:	bd 20 00 00 00       	mov    $0x20,%ebp
  803565:	89 eb                	mov    %ebp,%ebx
  803567:	29 fb                	sub    %edi,%ebx
  803569:	89 f9                	mov    %edi,%ecx
  80356b:	d3 e6                	shl    %cl,%esi
  80356d:	89 c5                	mov    %eax,%ebp
  80356f:	88 d9                	mov    %bl,%cl
  803571:	d3 ed                	shr    %cl,%ebp
  803573:	89 e9                	mov    %ebp,%ecx
  803575:	09 f1                	or     %esi,%ecx
  803577:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80357b:	89 f9                	mov    %edi,%ecx
  80357d:	d3 e0                	shl    %cl,%eax
  80357f:	89 c5                	mov    %eax,%ebp
  803581:	89 d6                	mov    %edx,%esi
  803583:	88 d9                	mov    %bl,%cl
  803585:	d3 ee                	shr    %cl,%esi
  803587:	89 f9                	mov    %edi,%ecx
  803589:	d3 e2                	shl    %cl,%edx
  80358b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80358f:	88 d9                	mov    %bl,%cl
  803591:	d3 e8                	shr    %cl,%eax
  803593:	09 c2                	or     %eax,%edx
  803595:	89 d0                	mov    %edx,%eax
  803597:	89 f2                	mov    %esi,%edx
  803599:	f7 74 24 0c          	divl   0xc(%esp)
  80359d:	89 d6                	mov    %edx,%esi
  80359f:	89 c3                	mov    %eax,%ebx
  8035a1:	f7 e5                	mul    %ebp
  8035a3:	39 d6                	cmp    %edx,%esi
  8035a5:	72 19                	jb     8035c0 <__udivdi3+0xfc>
  8035a7:	74 0b                	je     8035b4 <__udivdi3+0xf0>
  8035a9:	89 d8                	mov    %ebx,%eax
  8035ab:	31 ff                	xor    %edi,%edi
  8035ad:	e9 58 ff ff ff       	jmp    80350a <__udivdi3+0x46>
  8035b2:	66 90                	xchg   %ax,%ax
  8035b4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035b8:	89 f9                	mov    %edi,%ecx
  8035ba:	d3 e2                	shl    %cl,%edx
  8035bc:	39 c2                	cmp    %eax,%edx
  8035be:	73 e9                	jae    8035a9 <__udivdi3+0xe5>
  8035c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035c3:	31 ff                	xor    %edi,%edi
  8035c5:	e9 40 ff ff ff       	jmp    80350a <__udivdi3+0x46>
  8035ca:	66 90                	xchg   %ax,%ax
  8035cc:	31 c0                	xor    %eax,%eax
  8035ce:	e9 37 ff ff ff       	jmp    80350a <__udivdi3+0x46>
  8035d3:	90                   	nop

008035d4 <__umoddi3>:
  8035d4:	55                   	push   %ebp
  8035d5:	57                   	push   %edi
  8035d6:	56                   	push   %esi
  8035d7:	53                   	push   %ebx
  8035d8:	83 ec 1c             	sub    $0x1c,%esp
  8035db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035e7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035f3:	89 f3                	mov    %esi,%ebx
  8035f5:	89 fa                	mov    %edi,%edx
  8035f7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035fb:	89 34 24             	mov    %esi,(%esp)
  8035fe:	85 c0                	test   %eax,%eax
  803600:	75 1a                	jne    80361c <__umoddi3+0x48>
  803602:	39 f7                	cmp    %esi,%edi
  803604:	0f 86 a2 00 00 00    	jbe    8036ac <__umoddi3+0xd8>
  80360a:	89 c8                	mov    %ecx,%eax
  80360c:	89 f2                	mov    %esi,%edx
  80360e:	f7 f7                	div    %edi
  803610:	89 d0                	mov    %edx,%eax
  803612:	31 d2                	xor    %edx,%edx
  803614:	83 c4 1c             	add    $0x1c,%esp
  803617:	5b                   	pop    %ebx
  803618:	5e                   	pop    %esi
  803619:	5f                   	pop    %edi
  80361a:	5d                   	pop    %ebp
  80361b:	c3                   	ret    
  80361c:	39 f0                	cmp    %esi,%eax
  80361e:	0f 87 ac 00 00 00    	ja     8036d0 <__umoddi3+0xfc>
  803624:	0f bd e8             	bsr    %eax,%ebp
  803627:	83 f5 1f             	xor    $0x1f,%ebp
  80362a:	0f 84 ac 00 00 00    	je     8036dc <__umoddi3+0x108>
  803630:	bf 20 00 00 00       	mov    $0x20,%edi
  803635:	29 ef                	sub    %ebp,%edi
  803637:	89 fe                	mov    %edi,%esi
  803639:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80363d:	89 e9                	mov    %ebp,%ecx
  80363f:	d3 e0                	shl    %cl,%eax
  803641:	89 d7                	mov    %edx,%edi
  803643:	89 f1                	mov    %esi,%ecx
  803645:	d3 ef                	shr    %cl,%edi
  803647:	09 c7                	or     %eax,%edi
  803649:	89 e9                	mov    %ebp,%ecx
  80364b:	d3 e2                	shl    %cl,%edx
  80364d:	89 14 24             	mov    %edx,(%esp)
  803650:	89 d8                	mov    %ebx,%eax
  803652:	d3 e0                	shl    %cl,%eax
  803654:	89 c2                	mov    %eax,%edx
  803656:	8b 44 24 08          	mov    0x8(%esp),%eax
  80365a:	d3 e0                	shl    %cl,%eax
  80365c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803660:	8b 44 24 08          	mov    0x8(%esp),%eax
  803664:	89 f1                	mov    %esi,%ecx
  803666:	d3 e8                	shr    %cl,%eax
  803668:	09 d0                	or     %edx,%eax
  80366a:	d3 eb                	shr    %cl,%ebx
  80366c:	89 da                	mov    %ebx,%edx
  80366e:	f7 f7                	div    %edi
  803670:	89 d3                	mov    %edx,%ebx
  803672:	f7 24 24             	mull   (%esp)
  803675:	89 c6                	mov    %eax,%esi
  803677:	89 d1                	mov    %edx,%ecx
  803679:	39 d3                	cmp    %edx,%ebx
  80367b:	0f 82 87 00 00 00    	jb     803708 <__umoddi3+0x134>
  803681:	0f 84 91 00 00 00    	je     803718 <__umoddi3+0x144>
  803687:	8b 54 24 04          	mov    0x4(%esp),%edx
  80368b:	29 f2                	sub    %esi,%edx
  80368d:	19 cb                	sbb    %ecx,%ebx
  80368f:	89 d8                	mov    %ebx,%eax
  803691:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803695:	d3 e0                	shl    %cl,%eax
  803697:	89 e9                	mov    %ebp,%ecx
  803699:	d3 ea                	shr    %cl,%edx
  80369b:	09 d0                	or     %edx,%eax
  80369d:	89 e9                	mov    %ebp,%ecx
  80369f:	d3 eb                	shr    %cl,%ebx
  8036a1:	89 da                	mov    %ebx,%edx
  8036a3:	83 c4 1c             	add    $0x1c,%esp
  8036a6:	5b                   	pop    %ebx
  8036a7:	5e                   	pop    %esi
  8036a8:	5f                   	pop    %edi
  8036a9:	5d                   	pop    %ebp
  8036aa:	c3                   	ret    
  8036ab:	90                   	nop
  8036ac:	89 fd                	mov    %edi,%ebp
  8036ae:	85 ff                	test   %edi,%edi
  8036b0:	75 0b                	jne    8036bd <__umoddi3+0xe9>
  8036b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8036b7:	31 d2                	xor    %edx,%edx
  8036b9:	f7 f7                	div    %edi
  8036bb:	89 c5                	mov    %eax,%ebp
  8036bd:	89 f0                	mov    %esi,%eax
  8036bf:	31 d2                	xor    %edx,%edx
  8036c1:	f7 f5                	div    %ebp
  8036c3:	89 c8                	mov    %ecx,%eax
  8036c5:	f7 f5                	div    %ebp
  8036c7:	89 d0                	mov    %edx,%eax
  8036c9:	e9 44 ff ff ff       	jmp    803612 <__umoddi3+0x3e>
  8036ce:	66 90                	xchg   %ax,%ax
  8036d0:	89 c8                	mov    %ecx,%eax
  8036d2:	89 f2                	mov    %esi,%edx
  8036d4:	83 c4 1c             	add    $0x1c,%esp
  8036d7:	5b                   	pop    %ebx
  8036d8:	5e                   	pop    %esi
  8036d9:	5f                   	pop    %edi
  8036da:	5d                   	pop    %ebp
  8036db:	c3                   	ret    
  8036dc:	3b 04 24             	cmp    (%esp),%eax
  8036df:	72 06                	jb     8036e7 <__umoddi3+0x113>
  8036e1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036e5:	77 0f                	ja     8036f6 <__umoddi3+0x122>
  8036e7:	89 f2                	mov    %esi,%edx
  8036e9:	29 f9                	sub    %edi,%ecx
  8036eb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036ef:	89 14 24             	mov    %edx,(%esp)
  8036f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036f6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036fa:	8b 14 24             	mov    (%esp),%edx
  8036fd:	83 c4 1c             	add    $0x1c,%esp
  803700:	5b                   	pop    %ebx
  803701:	5e                   	pop    %esi
  803702:	5f                   	pop    %edi
  803703:	5d                   	pop    %ebp
  803704:	c3                   	ret    
  803705:	8d 76 00             	lea    0x0(%esi),%esi
  803708:	2b 04 24             	sub    (%esp),%eax
  80370b:	19 fa                	sbb    %edi,%edx
  80370d:	89 d1                	mov    %edx,%ecx
  80370f:	89 c6                	mov    %eax,%esi
  803711:	e9 71 ff ff ff       	jmp    803687 <__umoddi3+0xb3>
  803716:	66 90                	xchg   %ax,%ax
  803718:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80371c:	72 ea                	jb     803708 <__umoddi3+0x134>
  80371e:	89 d9                	mov    %ebx,%ecx
  803720:	e9 62 ff ff ff       	jmp    803687 <__umoddi3+0xb3>
