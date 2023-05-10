
obj/user/tst_realloc_2:     file format elf32-i386


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
  800031:	e8 b7 12 00 00       	call   8012ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 c4 80             	add    $0xffffff80,%esp
	int Mega = 1024*1024;
  800040:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  800047:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
  800054:	b9 14 00 00 00       	mov    $0x14,%ecx
  800059:	b8 00 00 00 00       	mov    $0x0,%eax
  80005e:	89 d7                	mov    %edx,%edi
  800060:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  800062:	83 ec 0c             	sub    $0xc,%esp
  800065:	68 a0 43 80 00       	push   $0x8043a0
  80006a:	e8 6e 16 00 00       	call   8016dd <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800072:	e8 c0 29 00 00       	call   802a37 <sys_calculate_free_frames>
  800077:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80007a:	e8 58 2a 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  800082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800085:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	50                   	push   %eax
  80008c:	e8 78 25 00 00       	call   802609 <malloc>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8000a0:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a5:	74 14                	je     8000bb <_main+0x83>
  8000a7:	83 ec 04             	sub    $0x4,%esp
  8000aa:	68 c4 43 80 00       	push   $0x8043c4
  8000af:	6a 11                	push   $0x11
  8000b1:	68 f4 43 80 00       	push   $0x8043f4
  8000b6:	e8 6e 13 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000be:	e8 74 29 00 00       	call   802a37 <sys_calculate_free_frames>
  8000c3:	29 c3                	sub    %eax,%ebx
  8000c5:	89 d8                	mov    %ebx,%eax
  8000c7:	83 f8 01             	cmp    $0x1,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 0c 44 80 00       	push   $0x80440c
  8000d4:	6a 13                	push   $0x13
  8000d6:	68 f4 43 80 00       	push   $0x8043f4
  8000db:	e8 49 13 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8000e0:	e8 f2 29 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8000e5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8000e8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 78 44 80 00       	push   $0x804478
  8000f7:	6a 14                	push   $0x14
  8000f9:	68 f4 43 80 00       	push   $0x8043f4
  8000fe:	e8 26 13 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800103:	e8 2f 29 00 00       	call   802a37 <sys_calculate_free_frames>
  800108:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 c7 29 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800110:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	50                   	push   %eax
  80011d:	e8 e7 24 00 00       	call   802609 <malloc>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80012b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800131:	89 c2                	mov    %eax,%edx
  800133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800136:	05 00 00 00 80       	add    $0x80000000,%eax
  80013b:	39 c2                	cmp    %eax,%edx
  80013d:	74 14                	je     800153 <_main+0x11b>
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 c4 43 80 00       	push   $0x8043c4
  800147:	6a 1a                	push   $0x1a
  800149:	68 f4 43 80 00       	push   $0x8043f4
  80014e:	e8 d6 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800153:	e8 df 28 00 00       	call   802a37 <sys_calculate_free_frames>
  800158:	89 c2                	mov    %eax,%edx
  80015a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015d:	39 c2                	cmp    %eax,%edx
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 0c 44 80 00       	push   $0x80440c
  800169:	6a 1c                	push   $0x1c
  80016b:	68 f4 43 80 00       	push   $0x8043f4
  800170:	e8 b4 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800175:	e8 5d 29 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80017a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017d:	3d 00 01 00 00       	cmp    $0x100,%eax
  800182:	74 14                	je     800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 78 44 80 00       	push   $0x804478
  80018c:	6a 1d                	push   $0x1d
  80018e:	68 f4 43 80 00       	push   $0x8043f4
  800193:	e8 91 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800198:	e8 9a 28 00 00       	call   802a37 <sys_calculate_free_frames>
  80019d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001a0:	e8 32 29 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8001a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ab:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	50                   	push   %eax
  8001b2:	e8 52 24 00 00       	call   802609 <malloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001bd:	8b 45 80             	mov    -0x80(%ebp),%eax
  8001c0:	89 c2                	mov    %eax,%edx
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 c4 43 80 00       	push   $0x8043c4
  8001d8:	6a 23                	push   $0x23
  8001da:	68 f4 43 80 00       	push   $0x8043f4
  8001df:	e8 45 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001e4:	e8 4e 28 00 00       	call   802a37 <sys_calculate_free_frames>
  8001e9:	89 c2                	mov    %eax,%edx
  8001eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	74 14                	je     800206 <_main+0x1ce>
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	68 0c 44 80 00       	push   $0x80440c
  8001fa:	6a 25                	push   $0x25
  8001fc:	68 f4 43 80 00       	push   $0x8043f4
  800201:	e8 23 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800206:	e8 cc 28 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80020b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80020e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800213:	74 14                	je     800229 <_main+0x1f1>
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	68 78 44 80 00       	push   $0x804478
  80021d:	6a 26                	push   $0x26
  80021f:	68 f4 43 80 00       	push   $0x8043f4
  800224:	e8 00 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800229:	e8 09 28 00 00       	call   802a37 <sys_calculate_free_frames>
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800231:	e8 a1 28 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800236:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	50                   	push   %eax
  800243:	e8 c1 23 00 00       	call   802609 <malloc>
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80024e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800251:	89 c1                	mov    %eax,%ecx
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	05 00 00 00 80       	add    $0x80000000,%eax
  800261:	39 c1                	cmp    %eax,%ecx
  800263:	74 14                	je     800279 <_main+0x241>
  800265:	83 ec 04             	sub    $0x4,%esp
  800268:	68 c4 43 80 00       	push   $0x8043c4
  80026d:	6a 2c                	push   $0x2c
  80026f:	68 f4 43 80 00       	push   $0x8043f4
  800274:	e8 b0 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800279:	e8 b9 27 00 00       	call   802a37 <sys_calculate_free_frames>
  80027e:	89 c2                	mov    %eax,%edx
  800280:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 0c 44 80 00       	push   $0x80440c
  80028f:	6a 2e                	push   $0x2e
  800291:	68 f4 43 80 00       	push   $0x8043f4
  800296:	e8 8e 11 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80029b:	e8 37 28 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8002a0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002a3:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002a8:	74 14                	je     8002be <_main+0x286>
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 78 44 80 00       	push   $0x804478
  8002b2:	6a 2f                	push   $0x2f
  8002b4:	68 f4 43 80 00       	push   $0x8043f4
  8002b9:	e8 6b 11 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002be:	e8 74 27 00 00       	call   802a37 <sys_calculate_free_frames>
  8002c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002c6:	e8 0c 28 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8002cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d1:	01 c0                	add    %eax,%eax
  8002d3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 2a 23 00 00       	call   802609 <malloc>
  8002df:	83 c4 10             	add    $0x10,%esp
  8002e2:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002e5:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002e8:	89 c2                	mov    %eax,%edx
  8002ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	05 00 00 00 80       	add    $0x80000000,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 14                	je     80030d <_main+0x2d5>
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 c4 43 80 00       	push   $0x8043c4
  800301:	6a 35                	push   $0x35
  800303:	68 f4 43 80 00       	push   $0x8043f4
  800308:	e8 1c 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80030d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800310:	e8 22 27 00 00       	call   802a37 <sys_calculate_free_frames>
  800315:	29 c3                	sub    %eax,%ebx
  800317:	89 d8                	mov    %ebx,%eax
  800319:	83 f8 01             	cmp    $0x1,%eax
  80031c:	74 14                	je     800332 <_main+0x2fa>
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	68 0c 44 80 00       	push   $0x80440c
  800326:	6a 37                	push   $0x37
  800328:	68 f4 43 80 00       	push   $0x8043f4
  80032d:	e8 f7 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800332:	e8 a0 27 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800337:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80033a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033f:	74 14                	je     800355 <_main+0x31d>
  800341:	83 ec 04             	sub    $0x4,%esp
  800344:	68 78 44 80 00       	push   $0x804478
  800349:	6a 38                	push   $0x38
  80034b:	68 f4 43 80 00       	push   $0x8043f4
  800350:	e8 d4 10 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800355:	e8 dd 26 00 00       	call   802a37 <sys_calculate_free_frames>
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035d:	e8 75 27 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800362:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	50                   	push   %eax
  800371:	e8 93 22 00 00       	call   802609 <malloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80037c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80037f:	89 c1                	mov    %eax,%ecx
  800381:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800384:	89 d0                	mov    %edx,%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	01 d0                	add    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	05 00 00 00 80       	add    $0x80000000,%eax
  800391:	39 c1                	cmp    %eax,%ecx
  800393:	74 14                	je     8003a9 <_main+0x371>
  800395:	83 ec 04             	sub    $0x4,%esp
  800398:	68 c4 43 80 00       	push   $0x8043c4
  80039d:	6a 3e                	push   $0x3e
  80039f:	68 f4 43 80 00       	push   $0x8043f4
  8003a4:	e8 80 10 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003a9:	e8 89 26 00 00       	call   802a37 <sys_calculate_free_frames>
  8003ae:	89 c2                	mov    %eax,%edx
  8003b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 0c 44 80 00       	push   $0x80440c
  8003bf:	6a 40                	push   $0x40
  8003c1:	68 f4 43 80 00       	push   $0x8043f4
  8003c6:	e8 5e 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003cb:	e8 07 27 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8003d0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 78 44 80 00       	push   $0x804478
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 f4 43 80 00       	push   $0x8043f4
  8003e9:	e8 3b 10 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003ee:	e8 44 26 00 00       	call   802a37 <sys_calculate_free_frames>
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003f6:	e8 dc 26 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8003fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800401:	89 c2                	mov    %eax,%edx
  800403:	01 d2                	add    %edx,%edx
  800405:	01 d0                	add    %edx,%eax
  800407:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	50                   	push   %eax
  80040e:	e8 f6 21 00 00       	call   802609 <malloc>
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800419:	8b 45 90             	mov    -0x70(%ebp),%eax
  80041c:	89 c2                	mov    %eax,%edx
  80041e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	05 00 00 00 80       	add    $0x80000000,%eax
  800429:	39 c2                	cmp    %eax,%edx
  80042b:	74 14                	je     800441 <_main+0x409>
  80042d:	83 ec 04             	sub    $0x4,%esp
  800430:	68 c4 43 80 00       	push   $0x8043c4
  800435:	6a 47                	push   $0x47
  800437:	68 f4 43 80 00       	push   $0x8043f4
  80043c:	e8 e8 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800441:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800444:	e8 ee 25 00 00       	call   802a37 <sys_calculate_free_frames>
  800449:	29 c3                	sub    %eax,%ebx
  80044b:	89 d8                	mov    %ebx,%eax
  80044d:	83 f8 01             	cmp    $0x1,%eax
  800450:	74 14                	je     800466 <_main+0x42e>
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	68 0c 44 80 00       	push   $0x80440c
  80045a:	6a 49                	push   $0x49
  80045c:	68 f4 43 80 00       	push   $0x8043f4
  800461:	e8 c3 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800466:	e8 6c 26 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80046b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80046e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 78 44 80 00       	push   $0x804478
  80047d:	6a 4a                	push   $0x4a
  80047f:	68 f4 43 80 00       	push   $0x8043f4
  800484:	e8 a0 0f 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800489:	e8 a9 25 00 00       	call   802a37 <sys_calculate_free_frames>
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800491:	e8 41 26 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800496:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	01 d2                	add    %edx,%edx
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8004a5:	83 ec 0c             	sub    $0xc,%esp
  8004a8:	50                   	push   %eax
  8004a9:	e8 5b 21 00 00       	call   802609 <malloc>
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004b4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004b7:	89 c1                	mov    %eax,%ecx
  8004b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004bc:	89 d0                	mov    %edx,%eax
  8004be:	c1 e0 02             	shl    $0x2,%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	01 c0                	add    %eax,%eax
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8004cc:	39 c1                	cmp    %eax,%ecx
  8004ce:	74 14                	je     8004e4 <_main+0x4ac>
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	68 c4 43 80 00       	push   $0x8043c4
  8004d8:	6a 50                	push   $0x50
  8004da:	68 f4 43 80 00       	push   $0x8043f4
  8004df:	e8 45 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004e4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e7:	e8 4b 25 00 00       	call   802a37 <sys_calculate_free_frames>
  8004ec:	29 c3                	sub    %eax,%ebx
  8004ee:	89 d8                	mov    %ebx,%eax
  8004f0:	83 f8 01             	cmp    $0x1,%eax
  8004f3:	74 14                	je     800509 <_main+0x4d1>
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 0c 44 80 00       	push   $0x80440c
  8004fd:	6a 52                	push   $0x52
  8004ff:	68 f4 43 80 00       	push   $0x8043f4
  800504:	e8 20 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800509:	e8 c9 25 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80050e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800511:	3d 00 03 00 00       	cmp    $0x300,%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 78 44 80 00       	push   $0x804478
  800520:	6a 53                	push   $0x53
  800522:	68 f4 43 80 00       	push   $0x8043f4
  800527:	e8 fd 0e 00 00       	call   801429 <_panic>

		//Allocate the remaining space in user heap
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 06 25 00 00       	call   802a37 <sys_calculate_free_frames>
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800534:	e8 9e 25 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800539:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc((USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega - kilo);
  80053c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	01 c0                	add    %eax,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	01 c0                	add    %eax,%eax
  80054b:	f7 d8                	neg    %eax
  80054d:	89 c2                	mov    %eax,%edx
  80054f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800552:	29 c2                	sub    %eax,%edx
  800554:	89 d0                	mov    %edx,%eax
  800556:	05 00 00 00 20       	add    $0x20000000,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 a5 20 00 00       	call   802609 <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80056a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056d:	89 c1                	mov    %eax,%ecx
  80056f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800572:	89 d0                	mov    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	01 c0                	add    %eax,%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	01 c0                	add    %eax,%eax
  80057e:	05 00 00 00 80       	add    $0x80000000,%eax
  800583:	39 c1                	cmp    %eax,%ecx
  800585:	74 14                	je     80059b <_main+0x563>
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	68 c4 43 80 00       	push   $0x8043c4
  80058f:	6a 59                	push   $0x59
  800591:	68 f4 43 80 00       	push   $0x8043f4
  800596:	e8 8e 0e 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80059b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059e:	e8 94 24 00 00       	call   802a37 <sys_calculate_free_frames>
  8005a3:	29 c3                	sub    %eax,%ebx
  8005a5:	89 d8                	mov    %ebx,%eax
  8005a7:	83 f8 7c             	cmp    $0x7c,%eax
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 0c 44 80 00       	push   $0x80440c
  8005b4:	6a 5b                	push   $0x5b
  8005b6:	68 f4 43 80 00       	push   $0x8043f4
  8005bb:	e8 69 0e 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005c0:	e8 12 25 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8005c5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8005c8:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005cd:	74 14                	je     8005e3 <_main+0x5ab>
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 78 44 80 00       	push   $0x804478
  8005d7:	6a 5c                	push   $0x5c
  8005d9:	68 f4 43 80 00       	push   $0x8043f4
  8005de:	e8 46 0e 00 00       	call   801429 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005e3:	e8 4f 24 00 00       	call   802a37 <sys_calculate_free_frames>
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005eb:	e8 e7 24 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  8005f3:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	e8 82 20 00 00       	call   802684 <free>
  800602:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800605:	e8 cd 24 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80060a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80060d:	29 c2                	sub    %eax,%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	3d 00 01 00 00       	cmp    $0x100,%eax
  800616:	74 14                	je     80062c <_main+0x5f4>
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	68 a8 44 80 00       	push   $0x8044a8
  800620:	6a 67                	push   $0x67
  800622:	68 f4 43 80 00       	push   $0x8043f4
  800627:	e8 fd 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80062c:	e8 06 24 00 00       	call   802a37 <sys_calculate_free_frames>
  800631:	89 c2                	mov    %eax,%edx
  800633:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800636:	39 c2                	cmp    %eax,%edx
  800638:	74 14                	je     80064e <_main+0x616>
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	68 e4 44 80 00       	push   $0x8044e4
  800642:	6a 68                	push   $0x68
  800644:	68 f4 43 80 00       	push   $0x8043f4
  800649:	e8 db 0d 00 00       	call   801429 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80064e:	e8 e4 23 00 00       	call   802a37 <sys_calculate_free_frames>
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800656:	e8 7c 24 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80065b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  80065e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800661:	83 ec 0c             	sub    $0xc,%esp
  800664:	50                   	push   %eax
  800665:	e8 1a 20 00 00       	call   802684 <free>
  80066a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80066d:	e8 65 24 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800672:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800675:	29 c2                	sub    %eax,%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	3d 00 02 00 00       	cmp    $0x200,%eax
  80067e:	74 14                	je     800694 <_main+0x65c>
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	68 a8 44 80 00       	push   $0x8044a8
  800688:	6a 6f                	push   $0x6f
  80068a:	68 f4 43 80 00       	push   $0x8043f4
  80068f:	e8 95 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800694:	e8 9e 23 00 00       	call   802a37 <sys_calculate_free_frames>
  800699:	89 c2                	mov    %eax,%edx
  80069b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069e:	39 c2                	cmp    %eax,%edx
  8006a0:	74 14                	je     8006b6 <_main+0x67e>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 e4 44 80 00       	push   $0x8044e4
  8006aa:	6a 70                	push   $0x70
  8006ac:	68 f4 43 80 00       	push   $0x8043f4
  8006b1:	e8 73 0d 00 00       	call   801429 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006b6:	e8 7c 23 00 00       	call   802a37 <sys_calculate_free_frames>
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006be:	e8 14 24 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8006c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  8006c6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006c9:	83 ec 0c             	sub    $0xc,%esp
  8006cc:	50                   	push   %eax
  8006cd:	e8 b2 1f 00 00       	call   802684 <free>
  8006d2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006d5:	e8 fd 23 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8006da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006dd:	29 c2                	sub    %eax,%edx
  8006df:	89 d0                	mov    %edx,%eax
  8006e1:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006e6:	74 14                	je     8006fc <_main+0x6c4>
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	68 a8 44 80 00       	push   $0x8044a8
  8006f0:	6a 77                	push   $0x77
  8006f2:	68 f4 43 80 00       	push   $0x8043f4
  8006f7:	e8 2d 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006fc:	e8 36 23 00 00       	call   802a37 <sys_calculate_free_frames>
  800701:	89 c2                	mov    %eax,%edx
  800703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 14                	je     80071e <_main+0x6e6>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 e4 44 80 00       	push   $0x8044e4
  800712:	6a 78                	push   $0x78
  800714:	68 f4 43 80 00       	push   $0x8043f4
  800719:	e8 0b 0d 00 00       	call   801429 <_panic>
//		free(ptr_allocations[8]);
//		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
//		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
//		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
	}
	int cnt = 0;
  80071e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 03                	push   $0x3
  80072a:	e8 a0 26 00 00       	call   802dcf <sys_bypassPageFault>
  80072f:	83 c4 10             	add    $0x10,%esp

	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate with size = 0*/

		char *byteArr = (char *) ptr_allocations[0];
  800732:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//Reallocate with size = 0 [delete it]
		freeFrames = sys_calculate_free_frames() ;
  80073b:	e8 f7 22 00 00       	call   802a37 <sys_calculate_free_frames>
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800743:	e8 8f 23 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800748:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 0);
  80074b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	6a 00                	push   $0x0
  800756:	50                   	push   %eax
  800757:	e8 59 21 00 00       	call   8028b5 <realloc>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != 0) panic("Wrong start address for the re-allocated space...it should return NULL!");
  800765:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80076b:	85 c0                	test   %eax,%eax
  80076d:	74 17                	je     800786 <_main+0x74e>
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	68 30 45 80 00       	push   $0x804530
  800777:	68 94 00 00 00       	push   $0x94
  80077c:	68 f4 43 80 00       	push   $0x8043f4
  800781:	e8 a3 0c 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800786:	e8 ac 22 00 00       	call   802a37 <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	39 c2                	cmp    %eax,%edx
  800792:	74 17                	je     8007ab <_main+0x773>
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	68 78 45 80 00       	push   $0x804578
  80079c:	68 96 00 00 00       	push   $0x96
  8007a1:	68 f4 43 80 00       	push   $0x8043f4
  8007a6:	e8 7e 0c 00 00       	call   801429 <_panic>
		if((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8007ab:	e8 27 23 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8007b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007b3:	29 c2                	sub    %eax,%edx
  8007b5:	89 d0                	mov    %edx,%eax
  8007b7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 e8 45 80 00       	push   $0x8045e8
  8007c6:	68 97 00 00 00       	push   $0x97
  8007cb:	68 f4 43 80 00       	push   $0x8043f4
  8007d0:	e8 54 0c 00 00       	call   801429 <_panic>

		//[2] test memory access
		byteArr[0] = 10;
  8007d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("successful access to re-allocated space with size 0!! it should not be succeeded");
  8007db:	e8 d6 25 00 00       	call   802db6 <sys_rcr2>
  8007e0:	89 c2                	mov    %eax,%edx
  8007e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 17                	je     800800 <_main+0x7c8>
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 1c 46 80 00       	push   $0x80461c
  8007f1:	68 9b 00 00 00       	push   $0x9b
  8007f6:	68 f4 43 80 00       	push   $0x8043f4
  8007fb:	e8 29 0c 00 00       	call   801429 <_panic>
		byteArr[(1*Mega-kilo)/sizeof(char) - 1] = 10;
  800800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800803:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800806:	8d 50 ff             	lea    -0x1(%eax),%edx
  800809:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[(1*Mega-kilo)/sizeof(char) - 1])) panic("successful access to reallocated space of size 0!! it should not be succeeded");
  800811:	e8 a0 25 00 00       	call   802db6 <sys_rcr2>
  800816:	89 c2                	mov    %eax,%edx
  800818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80081e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800821:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800824:	01 c8                	add    %ecx,%eax
  800826:	39 c2                	cmp    %eax,%edx
  800828:	74 17                	je     800841 <_main+0x809>
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	68 70 46 80 00       	push   $0x804670
  800832:	68 9d 00 00 00       	push   $0x9d
  800837:	68 f4 43 80 00       	push   $0x8043f4
  80083c:	e8 e8 0b 00 00       	call   801429 <_panic>

		//set it to 0 again to cancel the bypassing option
		sys_bypassPageFault(0);
  800841:	83 ec 0c             	sub    $0xc,%esp
  800844:	6a 00                	push   $0x0
  800846:	e8 84 25 00 00       	call   802dcf <sys_bypassPageFault>
  80084b:	83 c4 10             	add    $0x10,%esp

		vcprintf("\b\b\b20%", NULL);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	6a 00                	push   $0x0
  800853:	68 be 46 80 00       	push   $0x8046be
  800858:	e8 15 0e 00 00       	call   801672 <vcprintf>
  80085d:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate with address = NULL*/

		//new allocation with size = 2.5 MB, should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800860:	e8 d2 21 00 00       	call   802a37 <sys_calculate_free_frames>
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800868:	e8 6a 22 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80086d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(NULL, 2*Mega + 510*kilo);
  800870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800873:	89 d0                	mov    %edx,%eax
  800875:	c1 e0 08             	shl    $0x8,%eax
  800878:	29 d0                	sub    %edx,%eax
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	01 c0                	add    %eax,%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	50                   	push   %eax
  800887:	6a 00                	push   $0x0
  800889:	e8 27 20 00 00       	call   8028b5 <realloc>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800894:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800897:	89 c2                	mov    %eax,%edx
  800899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80089c:	c1 e0 03             	shl    $0x3,%eax
  80089f:	05 00 00 00 80       	add    $0x80000000,%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	83 ec 04             	sub    $0x4,%esp
  8008ab:	68 c4 43 80 00       	push   $0x8043c4
  8008b0:	68 aa 00 00 00       	push   $0xaa
  8008b5:	68 f4 43 80 00       	push   $0x8043f4
  8008ba:	e8 6a 0b 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 640) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008bf:	e8 73 21 00 00       	call   802a37 <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	68 78 45 80 00       	push   $0x804578
  8008d5:	68 ac 00 00 00       	push   $0xac
  8008da:	68 f4 43 80 00       	push   $0x8043f4
  8008df:	e8 45 0b 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 640) panic("Extra or less pages are re-allocated in PageFile");
  8008e4:	e8 ee 21 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8008e9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008ec:	3d 80 02 00 00       	cmp    $0x280,%eax
  8008f1:	74 17                	je     80090a <_main+0x8d2>
  8008f3:	83 ec 04             	sub    $0x4,%esp
  8008f6:	68 e8 45 80 00       	push   $0x8045e8
  8008fb:	68 ad 00 00 00       	push   $0xad
  800900:	68 f4 43 80 00       	push   $0x8043f4
  800905:	e8 1f 0b 00 00       	call   801429 <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[10];
  80090a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80090d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfInt1 = (2*Mega + 510*kilo)/sizeof(int) - 1;
  800910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800913:	89 d0                	mov    %edx,%eax
  800915:	c1 e0 08             	shl    $0x8,%eax
  800918:	29 d0                	sub    %edx,%eax
  80091a:	89 c2                	mov    %eax,%edx
  80091c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	01 c0                	add    %eax,%eax
  800923:	c1 e8 02             	shr    $0x2,%eax
  800926:	48                   	dec    %eax
  800927:	89 45 d0             	mov    %eax,-0x30(%ebp)

		int i = 0;
  80092a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  800931:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800938:	eb 17                	jmp    800951 <_main+0x919>
		{
			intArr[i] = i;
  80093a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800947:	01 c2                	add    %eax,%edx
  800949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094c:	89 02                	mov    %eax,(%edx)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  80094e:	ff 45 f0             	incl   -0x10(%ebp)
  800951:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800955:	7e e3                	jle    80093a <_main+0x902>
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800957:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80095a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095d:	eb 17                	jmp    800976 <_main+0x93e>
		{
			intArr[i] = i;
  80095f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800962:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80096c:	01 c2                	add    %eax,%edx
  80096e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800971:	89 02                	mov    %eax,(%edx)
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800973:	ff 4d f0             	decl   -0x10(%ebp)
  800976:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800979:	83 e8 63             	sub    $0x63,%eax
  80097c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80097f:	7e de                	jle    80095f <_main+0x927>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800981:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800988:	eb 33                	jmp    8009bd <_main+0x985>
		{
			cnt++;
  80098a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800997:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80099a:	01 d0                	add    %edx,%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009a1:	74 17                	je     8009ba <_main+0x982>
  8009a3:	83 ec 04             	sub    $0x4,%esp
  8009a6:	68 c8 46 80 00       	push   $0x8046c8
  8009ab:	68 ca 00 00 00       	push   $0xca
  8009b0:	68 f4 43 80 00       	push   $0x8043f4
  8009b5:	e8 6f 0a 00 00       	call   801429 <_panic>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  8009ba:	ff 45 f0             	incl   -0x10(%ebp)
  8009bd:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8009c1:	7e c7                	jle    80098a <_main+0x952>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	eb 33                	jmp    8009fe <_main+0x9c6>
		{
			cnt++;
  8009cb:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009e2:	74 17                	je     8009fb <_main+0x9c3>
  8009e4:	83 ec 04             	sub    $0x4,%esp
  8009e7:	68 c8 46 80 00       	push   $0x8046c8
  8009ec:	68 d0 00 00 00       	push   $0xd0
  8009f1:	68 f4 43 80 00       	push   $0x8043f4
  8009f6:	e8 2e 0a 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009fb:	ff 4d f0             	decl   -0x10(%ebp)
  8009fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a01:	83 e8 63             	sub    $0x63,%eax
  800a04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a07:	7e c2                	jle    8009cb <_main+0x993>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		vcprintf("\b\b\b40%", NULL);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	68 00 47 80 00       	push   $0x804700
  800a13:	e8 5a 0c 00 00       	call   801672 <vcprintf>
  800a18:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate in the existing internal fragment (no additional pages are required)*/

		//Reallocate last allocation with 1 extra KB [should be placed in the existing 2 KB internal fragment]
		freeFrames = sys_calculate_free_frames() ;
  800a1b:	e8 17 20 00 00       	call   802a37 <sys_calculate_free_frames>
  800a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a23:	e8 af 20 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800a28:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(ptr_allocations[10], 2*Mega + 510*kilo + kilo);
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	c1 e0 08             	shl    $0x8,%eax
  800a33:	29 d0                	sub    %edx,%eax
  800a35:	89 c2                	mov    %eax,%edx
  800a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a3a:	01 d0                	add    %edx,%eax
  800a3c:	01 c0                	add    %eax,%eax
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	52                   	push   %edx
  800a4e:	50                   	push   %eax
  800a4f:	e8 61 1e 00 00       	call   8028b5 <realloc>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 a0             	mov    %eax,-0x60(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800a5a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a62:	c1 e0 03             	shl    $0x3,%eax
  800a65:	05 00 00 00 80       	add    $0x80000000,%eax
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	68 08 47 80 00       	push   $0x804708
  800a76:	68 dc 00 00 00       	push   $0xdc
  800a7b:	68 f4 43 80 00       	push   $0x8043f4
  800a80:	e8 a4 09 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");

		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800a85:	e8 ad 1f 00 00       	call   802a37 <sys_calculate_free_frames>
  800a8a:	89 c2                	mov    %eax,%edx
  800a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8f:	39 c2                	cmp    %eax,%edx
  800a91:	74 17                	je     800aaa <_main+0xa72>
  800a93:	83 ec 04             	sub    $0x4,%esp
  800a96:	68 78 45 80 00       	push   $0x804578
  800a9b:	68 df 00 00 00       	push   $0xdf
  800aa0:	68 f4 43 80 00       	push   $0x8043f4
  800aa5:	e8 7f 09 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800aaa:	e8 28 20 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800aaf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 e8 45 80 00       	push   $0x8045e8
  800abc:	68 e0 00 00 00       	push   $0xe0
  800ac1:	68 f4 43 80 00       	push   $0x8043f4
  800ac6:	e8 5e 09 00 00       	call   801429 <_panic>

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;
  800acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	c1 e0 08             	shl    $0x8,%eax
  800ad3:	29 d0                	sub    %edx,%eax
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ada:	01 d0                	add    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	89 c2                	mov    %eax,%edx
  800ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ae3:	01 d0                	add    %edx,%eax
  800ae5:	c1 e8 02             	shr    $0x2,%eax
  800ae8:	48                   	dec    %eax
  800ae9:	89 45 cc             	mov    %eax,-0x34(%ebp)

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800aec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800aef:	40                   	inc    %eax
  800af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af3:	eb 17                	jmp    800b0c <_main+0xad4>
		{
			intArr[i] = i ;
  800af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b02:	01 c2                	add    %eax,%edx
  800b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b07:	89 02                	mov    %eax,(%edx)
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800b09:	ff 45 f0             	incl   -0x10(%ebp)
  800b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b0f:	83 c0 65             	add    $0x65,%eax
  800b12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b15:	7f de                	jg     800af5 <_main+0xabd>
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1d:	eb 17                	jmp    800b36 <_main+0xafe>
		{
			intArr[i] = i ;
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b2c:	01 c2                	add    %eax,%edx
  800b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b31:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b33:	ff 4d f0             	decl   -0x10(%ebp)
  800b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b39:	83 e8 63             	sub    $0x63,%eax
  800b3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b3f:	7e de                	jle    800b1f <_main+0xae7>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b48:	eb 33                	jmp    800b7d <_main+0xb45>
		{
			cnt++;
  800b4a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b5a:	01 d0                	add    %edx,%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b61:	74 17                	je     800b7a <_main+0xb42>
  800b63:	83 ec 04             	sub    $0x4,%esp
  800b66:	68 c8 46 80 00       	push   $0x8046c8
  800b6b:	68 f4 00 00 00       	push   $0xf4
  800b70:	68 f4 43 80 00       	push   $0x8043f4
  800b75:	e8 af 08 00 00       	call   801429 <_panic>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b7a:	ff 45 f0             	incl   -0x10(%ebp)
  800b7d:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800b81:	7e c7                	jle    800b4a <_main+0xb12>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800b83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b86:	48                   	dec    %eax
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	eb 33                	jmp    800bbf <_main+0xb87>
		{
			cnt++;
  800b8c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b9c:	01 d0                	add    %edx,%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ba3:	74 17                	je     800bbc <_main+0xb84>
  800ba5:	83 ec 04             	sub    $0x4,%esp
  800ba8:	68 c8 46 80 00       	push   $0x8046c8
  800bad:	68 f9 00 00 00       	push   $0xf9
  800bb2:	68 f4 43 80 00       	push   $0x8043f4
  800bb7:	e8 6d 08 00 00       	call   801429 <_panic>
		for (i=0; i < 100 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800bbc:	ff 4d f0             	decl   -0x10(%ebp)
  800bbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc2:	83 e8 63             	sub    $0x63,%eax
  800bc5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bc8:	7e c2                	jle    800b8c <_main+0xb54>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800bca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bcd:	40                   	inc    %eax
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	eb 33                	jmp    800c06 <_main+0xbce>
		{
			cnt++;
  800bd3:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800be3:	01 d0                	add    %edx,%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bea:	74 17                	je     800c03 <_main+0xbcb>
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	68 c8 46 80 00       	push   $0x8046c8
  800bf4:	68 fe 00 00 00       	push   $0xfe
  800bf9:	68 f4 43 80 00       	push   $0x8043f4
  800bfe:	e8 26 08 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800c03:	ff 45 f0             	incl   -0x10(%ebp)
  800c06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c09:	83 c0 65             	add    $0x65,%eax
  800c0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c0f:	7f c2                	jg     800bd3 <_main+0xb9b>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	eb 33                	jmp    800c4c <_main+0xc14>
		{
			cnt++;
  800c19:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c29:	01 d0                	add    %edx,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c30:	74 17                	je     800c49 <_main+0xc11>
  800c32:	83 ec 04             	sub    $0x4,%esp
  800c35:	68 c8 46 80 00       	push   $0x8046c8
  800c3a:	68 03 01 00 00       	push   $0x103
  800c3f:	68 f4 43 80 00       	push   $0x8043f4
  800c44:	e8 e0 07 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c49:	ff 4d f0             	decl   -0x10(%ebp)
  800c4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c4f:	83 e8 63             	sub    $0x63,%eax
  800c52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c55:	7e c2                	jle    800c19 <_main+0xbe1>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800c57:	e8 db 1d 00 00       	call   802a37 <sys_calculate_free_frames>
  800c5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c5f:	e8 73 1e 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800c64:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[10]);
  800c67:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	e8 11 1a 00 00       	call   802684 <free>
  800c73:	83 c4 10             	add    $0x10,%esp

		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800c76:	e8 5c 1e 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800c7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c7e:	29 c2                	sub    %eax,%edx
  800c80:	89 d0                	mov    %edx,%eax
  800c82:	3d 80 02 00 00       	cmp    $0x280,%eax
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 3c 47 80 00       	push   $0x80473c
  800c91:	68 0d 01 00 00       	push   $0x10d
  800c96:	68 f4 43 80 00       	push   $0x8043f4
  800c9b:	e8 89 07 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800ca0:	e8 92 1d 00 00       	call   802a37 <sys_calculate_free_frames>
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800caa:	29 c2                	sub    %eax,%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	83 f8 03             	cmp    $0x3,%eax
  800cb1:	74 17                	je     800cca <_main+0xc92>
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	68 90 47 80 00       	push   $0x804790
  800cbb:	68 0e 01 00 00       	push   $0x10e
  800cc0:	68 f4 43 80 00       	push   $0x8043f4
  800cc5:	e8 5f 07 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b60%", NULL);
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	6a 00                	push   $0x0
  800ccf:	68 f4 47 80 00       	push   $0x8047f4
  800cd4:	e8 99 09 00 00       	call   801672 <vcprintf>
  800cd9:	83 c4 10             	add    $0x10,%esp

		/*CASE4: Re-allocate that can NOT fit in any free fragment*/

		//Fill 3rd allocation with data
		intArr = (int*) ptr_allocations[2];
  800cdc:	8b 45 80             	mov    -0x80(%ebp),%eax
  800cdf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ce5:	c1 e8 02             	shr    $0x2,%eax
  800ce8:	48                   	dec    %eax
  800ce9:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  800cec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800cf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cfa:	eb 17                	jmp    800d13 <_main+0xcdb>
		{
			intArr[i] = i ;
  800cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d09:	01 c2                	add    %eax,%edx
  800d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0e:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800d10:	ff 45 f0             	incl   -0x10(%ebp)
  800d13:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800d17:	7e e3                	jle    800cfc <_main+0xcc4>
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d1f:	eb 17                	jmp    800d38 <_main+0xd00>
		{
			intArr[i] = i;
  800d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d2e:	01 c2                	add    %eax,%edx
  800d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d33:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d35:	ff 4d ec             	decl   -0x14(%ebp)
  800d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d3b:	83 e8 64             	sub    $0x64,%eax
  800d3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d41:	7c de                	jl     800d21 <_main+0xce9>
		{
			intArr[i] = i;
		}

		//Reallocate it to large size that can't be fit in any free segment
		freeFrames = sys_calculate_free_frames() ;
  800d43:	e8 ef 1c 00 00       	call   802a37 <sys_calculate_free_frames>
  800d48:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d4b:	e8 87 1d 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800d50:	89 45 dc             	mov    %eax,-0x24(%ebp)
		void* origAddress = ptr_allocations[2];
  800d53:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d56:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = realloc(ptr_allocations[2], (USER_HEAP_MAX - USER_HEAP_START - 13*Mega));
  800d59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d5c:	89 d0                	mov    %edx,%eax
  800d5e:	01 c0                	add    %eax,%eax
  800d60:	01 d0                	add    %edx,%eax
  800d62:	c1 e0 02             	shl    $0x2,%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	f7 d8                	neg    %eax
  800d69:	8d 90 00 00 00 20    	lea    0x20000000(%eax),%edx
  800d6f:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	52                   	push   %edx
  800d76:	50                   	push   %eax
  800d77:	e8 39 1b 00 00       	call   8028b5 <realloc>
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	89 45 80             	mov    %eax,-0x80(%ebp)

		//cprintf("%x\n", ptr_allocations[2]);
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[2] != 0) panic("Wrong start address for the re-allocated space... ");
  800d82:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d85:	85 c0                	test   %eax,%eax
  800d87:	74 17                	je     800da0 <_main+0xd68>
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	68 08 47 80 00       	push   $0x804708
  800d91:	68 2d 01 00 00       	push   $0x12d
  800d96:	68 f4 43 80 00       	push   $0x8043f4
  800d9b:	e8 89 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800da0:	e8 92 1c 00 00       	call   802a37 <sys_calculate_free_frames>
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800daa:	39 c2                	cmp    %eax,%edx
  800dac:	74 17                	je     800dc5 <_main+0xd8d>
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	68 78 45 80 00       	push   $0x804578
  800db6:	68 2f 01 00 00       	push   $0x12f
  800dbb:	68 f4 43 80 00       	push   $0x8043f4
  800dc0:	e8 64 06 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800dc5:	e8 0d 1d 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800dca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dcd:	74 17                	je     800de6 <_main+0xdae>
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	68 e8 45 80 00       	push   $0x8045e8
  800dd7:	68 30 01 00 00       	push   $0x130
  800ddc:	68 f4 43 80 00       	push   $0x8043f4
  800de1:	e8 43 06 00 00       	call   801429 <_panic>

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800de6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ded:	eb 33                	jmp    800e22 <_main+0xdea>
		{
			cnt++;
  800def:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dff:	01 d0                	add    %edx,%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e06:	74 17                	je     800e1f <_main+0xde7>
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	68 c8 46 80 00       	push   $0x8046c8
  800e10:	68 36 01 00 00       	push   $0x136
  800e15:	68 f4 43 80 00       	push   $0x8043f4
  800e1a:	e8 0a 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800e1f:	ff 45 f0             	incl   -0x10(%ebp)
  800e22:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800e26:	7e c7                	jle    800def <_main+0xdb7>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2e:	eb 33                	jmp    800e63 <_main+0xe2b>
		{
			cnt++;
  800e30:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e47:	74 17                	je     800e60 <_main+0xe28>
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	68 c8 46 80 00       	push   $0x8046c8
  800e51:	68 3c 01 00 00       	push   $0x13c
  800e56:	68 f4 43 80 00       	push   $0x8043f4
  800e5b:	e8 c9 05 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e60:	ff 4d f0             	decl   -0x10(%ebp)
  800e63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e66:	83 e8 64             	sub    $0x64,%eax
  800e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6c:	7c c2                	jl     800e30 <_main+0xdf8>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after FAILURE expansion
		freeFrames = sys_calculate_free_frames() ;
  800e6e:	e8 c4 1b 00 00       	call   802a37 <sys_calculate_free_frames>
  800e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e76:	e8 5c 1c 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800e7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(origAddress);
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	ff 75 c8             	pushl  -0x38(%ebp)
  800e84:	e8 fb 17 00 00       	call   802684 <free>
  800e89:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e8c:	e8 46 1c 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800e94:	29 c2                	sub    %eax,%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	3d 00 01 00 00       	cmp    $0x100,%eax
  800e9d:	74 17                	je     800eb6 <_main+0xe7e>
  800e9f:	83 ec 04             	sub    $0x4,%esp
  800ea2:	68 3c 47 80 00       	push   $0x80473c
  800ea7:	68 44 01 00 00       	push   $0x144
  800eac:	68 f4 43 80 00       	push   $0x8043f4
  800eb1:	e8 73 05 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800eb6:	e8 7c 1b 00 00       	call   802a37 <sys_calculate_free_frames>
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	83 f8 03             	cmp    $0x3,%eax
  800ec7:	74 17                	je     800ee0 <_main+0xea8>
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	68 90 47 80 00       	push   $0x804790
  800ed1:	68 45 01 00 00       	push   $0x145
  800ed6:	68 f4 43 80 00       	push   $0x8043f4
  800edb:	e8 49 05 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b80%", NULL);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	6a 00                	push   $0x0
  800ee5:	68 fb 47 80 00       	push   $0x8047fb
  800eea:	e8 83 07 00 00       	call   801672 <vcprintf>
  800eef:	83 c4 10             	add    $0x10,%esp
		/*CASE5: Re-allocate that test FIRST FIT strategy*/

		//[1] create 4 MB hole at beginning of the heap

		//Take 2 MB from currently 3 MB hole at beginning of the heap
		freeFrames = sys_calculate_free_frames() ;
  800ef2:	e8 40 1b 00 00       	call   802a37 <sys_calculate_free_frames>
  800ef7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800efa:	e8 d8 1b 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800eff:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(2*Mega-kilo);
  800f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f05:	01 c0                	add    %eax,%eax
  800f07:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	e8 f6 16 00 00       	call   802609 <malloc>
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800f19:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800f1c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800f21:	74 17                	je     800f3a <_main+0xf02>
  800f23:	83 ec 04             	sub    $0x4,%esp
  800f26:	68 c4 43 80 00       	push   $0x8043c4
  800f2b:	68 51 01 00 00       	push   $0x151
  800f30:	68 f4 43 80 00       	push   $0x8043f4
  800f35:	e8 ef 04 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800f3a:	e8 f8 1a 00 00       	call   802a37 <sys_calculate_free_frames>
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	39 c2                	cmp    %eax,%edx
  800f46:	74 17                	je     800f5f <_main+0xf27>
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	68 0c 44 80 00       	push   $0x80440c
  800f50:	68 53 01 00 00       	push   $0x153
  800f55:	68 f4 43 80 00       	push   $0x8043f4
  800f5a:	e8 ca 04 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800f5f:	e8 73 1b 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800f64:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800f67:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f6c:	74 17                	je     800f85 <_main+0xf4d>
  800f6e:	83 ec 04             	sub    $0x4,%esp
  800f71:	68 78 44 80 00       	push   $0x804478
  800f76:	68 54 01 00 00       	push   $0x154
  800f7b:	68 f4 43 80 00       	push   $0x8043f4
  800f80:	e8 a4 04 00 00       	call   801429 <_panic>

		//remove 1 MB allocation between 1 MB hole and 2 MB hole to create 4 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f85:	e8 ad 1a 00 00       	call   802a37 <sys_calculate_free_frames>
  800f8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8d:	e8 45 1b 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800f92:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800f95:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	e8 e3 16 00 00       	call   802684 <free>
  800fa1:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fa4:	e8 2e 1b 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  800fa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	3d 00 01 00 00       	cmp    $0x100,%eax
  800fb5:	74 17                	je     800fce <_main+0xf96>
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	68 a8 44 80 00       	push   $0x8044a8
  800fbf:	68 5b 01 00 00       	push   $0x15b
  800fc4:	68 f4 43 80 00       	push   $0x8043f4
  800fc9:	e8 5b 04 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fce:	e8 64 1a 00 00       	call   802a37 <sys_calculate_free_frames>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd8:	39 c2                	cmp    %eax,%edx
  800fda:	74 17                	je     800ff3 <_main+0xfbb>
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 e4 44 80 00       	push   $0x8044e4
  800fe4:	68 5c 01 00 00       	push   $0x15c
  800fe9:	68 f4 43 80 00       	push   $0x8043f4
  800fee:	e8 36 04 00 00       	call   801429 <_panic>
		{
			//allocate 1 page after each 3 MB
			sys_allocateMem(i, PAGE_SIZE) ;
		}*/

		malloc(5*Mega-kilo);
  800ff3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ff6:	89 d0                	mov    %edx,%eax
  800ff8:	c1 e0 02             	shl    $0x2,%eax
  800ffb:	01 d0                	add    %edx,%eax
  800ffd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	50                   	push   %eax
  801004:	e8 00 16 00 00       	call   802609 <malloc>
  801009:	83 c4 10             	add    $0x10,%esp

		//Fill last 3MB allocation with data
		intArr = (int*) ptr_allocations[7];
  80100c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80100f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;
  801012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801015:	89 c2                	mov    %eax,%edx
  801017:	01 d2                	add    %edx,%edx
  801019:	01 d0                	add    %edx,%eax
  80101b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80101e:	c1 e8 02             	shr    $0x2,%eax
  801021:	48                   	dec    %eax
  801022:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  801025:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  80102c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801033:	eb 17                	jmp    80104c <_main+0x1014>
		{
			intArr[i] = i ;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801042:	01 c2                	add    %eax,%edx
  801044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801047:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[7];
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  801049:	ff 45 f0             	incl   -0x10(%ebp)
  80104c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  801050:	7e e3                	jle    801035 <_main+0xffd>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801052:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801055:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801058:	eb 17                	jmp    801071 <_main+0x1039>
		{
			intArr[i] = i;
  80105a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801064:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801067:	01 c2                	add    %eax,%edx
  801069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106c:	89 02                	mov    %eax,(%edx)
		for (i=0; i < 100 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  80106e:	ff 4d f0             	decl   -0x10(%ebp)
  801071:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801074:	83 e8 64             	sub    $0x64,%eax
  801077:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80107a:	7c de                	jl     80105a <_main+0x1022>
		{
			intArr[i] = i;
		}

		//Reallocate it to 4 MB, so that it can only fit at the 1st fragment
		freeFrames = sys_calculate_free_frames() ;
  80107c:	e8 b6 19 00 00       	call   802a37 <sys_calculate_free_frames>
  801081:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801084:	e8 4e 1a 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  801089:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = realloc(ptr_allocations[7], 4*Mega-kilo);
  80108c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80108f:	c1 e0 02             	shl    $0x2,%eax
  801092:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	52                   	push   %edx
  80109e:	50                   	push   %eax
  80109f:	e8 11 18 00 00       	call   8028b5 <realloc>
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	89 45 94             	mov    %eax,-0x6c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the re-allocated space... ");
  8010aa:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b2:	01 c0                	add    %eax,%eax
  8010b4:	05 00 00 00 80       	add    $0x80000000,%eax
  8010b9:	39 c2                	cmp    %eax,%edx
  8010bb:	74 17                	je     8010d4 <_main+0x109c>
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	68 08 47 80 00       	push   $0x804708
  8010c5:	68 7d 01 00 00       	push   $0x17d
  8010ca:	68 f4 43 80 00       	push   $0x8043f4
  8010cf:	e8 55 03 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 - 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 2) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8010d4:	e8 fe 19 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  8010d9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8010dc:	3d 00 01 00 00       	cmp    $0x100,%eax
  8010e1:	74 17                	je     8010fa <_main+0x10c2>
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	68 e8 45 80 00       	push   $0x8045e8
  8010eb:	68 80 01 00 00       	push   $0x180
  8010f0:	68 f4 43 80 00       	push   $0x8043f4
  8010f5:	e8 2f 03 00 00       	call   801429 <_panic>


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
  8010fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010fd:	c1 e0 02             	shl    $0x2,%eax
  801100:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801103:	c1 e8 02             	shr    $0x2,%eax
  801106:	48                   	dec    %eax
  801107:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[7];
  80110a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80110d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801110:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801113:	40                   	inc    %eax
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801117:	eb 17                	jmp    801130 <_main+0x10f8>
		{
			intArr[i] = i ;
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801123:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801126:	01 c2                	add    %eax,%edx
  801128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112b:	89 02                	mov    %eax,(%edx)


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[7];
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  80112d:	ff 45 f0             	incl   -0x10(%ebp)
  801130:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801133:	83 c0 65             	add    $0x65,%eax
  801136:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801139:	7f de                	jg     801119 <_main+0x10e1>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80113b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80113e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801141:	eb 17                	jmp    80115a <_main+0x1122>
		{
			intArr[i] = i;
  801143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801150:	01 c2                	add    %eax,%edx
  801152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801155:	89 02                	mov    %eax,(%edx)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801157:	ff 4d f0             	decl   -0x10(%ebp)
  80115a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80115d:	83 e8 64             	sub    $0x64,%eax
  801160:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801163:	7c de                	jl     801143 <_main+0x110b>
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  801165:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80116c:	eb 33                	jmp    8011a1 <_main+0x1169>
		{
			cnt++;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  801171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801185:	74 17                	je     80119e <_main+0x1166>
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	68 c8 46 80 00       	push   $0x8046c8
  80118f:	68 93 01 00 00       	push   $0x193
  801194:	68 f4 43 80 00       	push   $0x8043f4
  801199:	e8 8b 02 00 00       	call   801429 <_panic>
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  80119e:	ff 45 f0             	incl   -0x10(%ebp)
  8011a1:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8011a5:	7e c7                	jle    80116e <_main+0x1136>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ad:	eb 33                	jmp    8011e2 <_main+0x11aa>
		{
			cnt++;
  8011af:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011bf:	01 d0                	add    %edx,%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c6:	74 17                	je     8011df <_main+0x11a7>
  8011c8:	83 ec 04             	sub    $0x4,%esp
  8011cb:	68 c8 46 80 00       	push   $0x8046c8
  8011d0:	68 99 01 00 00       	push   $0x199
  8011d5:	68 f4 43 80 00       	push   $0x8043f4
  8011da:	e8 4a 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011df:	ff 4d f0             	decl   -0x10(%ebp)
  8011e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011e5:	83 e8 64             	sub    $0x64,%eax
  8011e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011eb:	7c c2                	jl     8011af <_main+0x1177>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  8011ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011f0:	40                   	inc    %eax
  8011f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f4:	eb 33                	jmp    801229 <_main+0x11f1>
		{
			cnt++;
  8011f6:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801206:	01 d0                	add    %edx,%eax
  801208:	8b 00                	mov    (%eax),%eax
  80120a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120d:	74 17                	je     801226 <_main+0x11ee>
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	68 c8 46 80 00       	push   $0x8046c8
  801217:	68 9f 01 00 00       	push   $0x19f
  80121c:	68 f4 43 80 00       	push   $0x8043f4
  801221:	e8 03 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801226:	ff 45 f0             	incl   -0x10(%ebp)
  801229:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80122c:	83 c0 65             	add    $0x65,%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7f c2                	jg     8011f6 <_main+0x11be>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801234:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123a:	eb 33                	jmp    80126f <_main+0x1237>
		{
			cnt++;
  80123c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801249:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80124c:	01 d0                	add    %edx,%eax
  80124e:	8b 00                	mov    (%eax),%eax
  801250:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801253:	74 17                	je     80126c <_main+0x1234>
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	68 c8 46 80 00       	push   $0x8046c8
  80125d:	68 a5 01 00 00       	push   $0x1a5
  801262:	68 f4 43 80 00       	push   $0x8043f4
  801267:	e8 bd 01 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80126c:	ff 4d f0             	decl   -0x10(%ebp)
  80126f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801272:	83 e8 64             	sub    $0x64,%eax
  801275:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801278:	7c c2                	jl     80123c <_main+0x1204>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  80127a:	e8 b8 17 00 00       	call   802a37 <sys_calculate_free_frames>
  80127f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801282:	e8 50 18 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  801287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[7]);
  80128a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 ee 13 00 00       	call   802684 <free>
  801296:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  801299:	e8 39 18 00 00       	call   802ad7 <sys_pf_calculate_allocated_pages>
  80129e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012a1:	29 c2                	sub    %eax,%edx
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012aa:	74 17                	je     8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 3c 47 80 00       	push   $0x80473c
  8012b4:	68 ad 01 00 00       	push   $0x1ad
  8012b9:	68 f4 43 80 00       	push   $0x8043f4
  8012be:	e8 66 01 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	6a 00                	push   $0x0
  8012c8:	68 02 48 80 00       	push   $0x804802
  8012cd:	e8 a0 03 00 00       	call   801672 <vcprintf>
  8012d2:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [2] completed successfully.\n");
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	68 0c 48 80 00       	push   $0x80480c
  8012dd:	e8 fb 03 00 00       	call   8016dd <cprintf>
  8012e2:	83 c4 10             	add    $0x10,%esp

	return;
  8012e5:	90                   	nop
}
  8012e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5f                   	pop    %edi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8012f3:	e8 1f 1a 00 00       	call   802d17 <sys_getenvindex>
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8012fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	c1 e0 03             	shl    $0x3,%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	01 c0                	add    %eax,%eax
  801307:	01 d0                	add    %edx,%eax
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	01 d0                	add    %edx,%eax
  801312:	c1 e0 04             	shl    $0x4,%eax
  801315:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80131a:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80131f:	a1 20 60 80 00       	mov    0x806020,%eax
  801324:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80132a:	84 c0                	test   %al,%al
  80132c:	74 0f                	je     80133d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80132e:	a1 20 60 80 00       	mov    0x806020,%eax
  801333:	05 5c 05 00 00       	add    $0x55c,%eax
  801338:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80133d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801341:	7e 0a                	jle    80134d <libmain+0x60>
		binaryname = argv[0];
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	ff 75 08             	pushl  0x8(%ebp)
  801356:	e8 dd ec ff ff       	call   800038 <_main>
  80135b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80135e:	e8 c1 17 00 00       	call   802b24 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	68 60 48 80 00       	push   $0x804860
  80136b:	e8 6d 03 00 00       	call   8016dd <cprintf>
  801370:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801373:	a1 20 60 80 00       	mov    0x806020,%eax
  801378:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80137e:	a1 20 60 80 00       	mov    0x806020,%eax
  801383:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	52                   	push   %edx
  80138d:	50                   	push   %eax
  80138e:	68 88 48 80 00       	push   $0x804888
  801393:	e8 45 03 00 00       	call   8016dd <cprintf>
  801398:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80139b:	a1 20 60 80 00       	mov    0x806020,%eax
  8013a0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8013a6:	a1 20 60 80 00       	mov    0x806020,%eax
  8013ab:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8013b1:	a1 20 60 80 00       	mov    0x806020,%eax
  8013b6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8013bc:	51                   	push   %ecx
  8013bd:	52                   	push   %edx
  8013be:	50                   	push   %eax
  8013bf:	68 b0 48 80 00       	push   $0x8048b0
  8013c4:	e8 14 03 00 00       	call   8016dd <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8013cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8013d1:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	50                   	push   %eax
  8013db:	68 08 49 80 00       	push   $0x804908
  8013e0:	e8 f8 02 00 00       	call   8016dd <cprintf>
  8013e5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	68 60 48 80 00       	push   $0x804860
  8013f0:	e8 e8 02 00 00       	call   8016dd <cprintf>
  8013f5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8013f8:	e8 41 17 00 00       	call   802b3e <sys_enable_interrupt>

	// exit gracefully
	exit();
  8013fd:	e8 19 00 00 00       	call   80141b <exit>
}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	6a 00                	push   $0x0
  801410:	e8 ce 18 00 00       	call   802ce3 <sys_destroy_env>
  801415:	83 c4 10             	add    $0x10,%esp
}
  801418:	90                   	nop
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <exit>:

void
exit(void)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801421:	e8 23 19 00 00       	call   802d49 <sys_exit_env>
}
  801426:	90                   	nop
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80142f:	8d 45 10             	lea    0x10(%ebp),%eax
  801432:	83 c0 04             	add    $0x4,%eax
  801435:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801438:	a1 5c 61 80 00       	mov    0x80615c,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 16                	je     801457 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801441:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	50                   	push   %eax
  80144a:	68 1c 49 80 00       	push   $0x80491c
  80144f:	e8 89 02 00 00       	call   8016dd <cprintf>
  801454:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801457:	a1 00 60 80 00       	mov    0x806000,%eax
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	ff 75 08             	pushl  0x8(%ebp)
  801462:	50                   	push   %eax
  801463:	68 21 49 80 00       	push   $0x804921
  801468:	e8 70 02 00 00       	call   8016dd <cprintf>
  80146d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	ff 75 f4             	pushl  -0xc(%ebp)
  801479:	50                   	push   %eax
  80147a:	e8 f3 01 00 00       	call   801672 <vcprintf>
  80147f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	6a 00                	push   $0x0
  801487:	68 3d 49 80 00       	push   $0x80493d
  80148c:	e8 e1 01 00 00       	call   801672 <vcprintf>
  801491:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801494:	e8 82 ff ff ff       	call   80141b <exit>

	// should not return here
	while (1) ;
  801499:	eb fe                	jmp    801499 <_panic+0x70>

0080149b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8014a1:	a1 20 60 80 00       	mov    0x806020,%eax
  8014a6:	8b 50 74             	mov    0x74(%eax),%edx
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	39 c2                	cmp    %eax,%edx
  8014ae:	74 14                	je     8014c4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	68 40 49 80 00       	push   $0x804940
  8014b8:	6a 26                	push   $0x26
  8014ba:	68 8c 49 80 00       	push   $0x80498c
  8014bf:	e8 65 ff ff ff       	call   801429 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8014c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8014cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014d2:	e9 c2 00 00 00       	jmp    801599 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	75 08                	jne    8014f4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8014ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8014ef:	e9 a2 00 00 00       	jmp    801596 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8014f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8014fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801502:	eb 69                	jmp    80156d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801504:	a1 20 60 80 00       	mov    0x806020,%eax
  801509:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80150f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	01 c0                	add    %eax,%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	c1 e0 03             	shl    $0x3,%eax
  80151b:	01 c8                	add    %ecx,%eax
  80151d:	8a 40 04             	mov    0x4(%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	75 46                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801524:	a1 20 60 80 00       	mov    0x806020,%eax
  801529:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80152f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801532:	89 d0                	mov    %edx,%eax
  801534:	01 c0                	add    %eax,%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	c1 e0 03             	shl    $0x3,%eax
  80153b:	01 c8                	add    %ecx,%eax
  80153d:	8b 00                	mov    (%eax),%eax
  80153f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801542:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801545:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80154c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	01 c8                	add    %ecx,%eax
  80155b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80155d:	39 c2                	cmp    %eax,%edx
  80155f:	75 09                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801561:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801568:	eb 12                	jmp    80157c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80156a:	ff 45 e8             	incl   -0x18(%ebp)
  80156d:	a1 20 60 80 00       	mov    0x806020,%eax
  801572:	8b 50 74             	mov    0x74(%eax),%edx
  801575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801578:	39 c2                	cmp    %eax,%edx
  80157a:	77 88                	ja     801504 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80157c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801580:	75 14                	jne    801596 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 98 49 80 00       	push   $0x804998
  80158a:	6a 3a                	push   $0x3a
  80158c:	68 8c 49 80 00       	push   $0x80498c
  801591:	e8 93 fe ff ff       	call   801429 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801596:	ff 45 f0             	incl   -0x10(%ebp)
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80159f:	0f 8c 32 ff ff ff    	jl     8014d7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8015a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015b3:	eb 26                	jmp    8015db <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8015b5:	a1 20 60 80 00       	mov    0x806020,%eax
  8015ba:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8015c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015c3:	89 d0                	mov    %edx,%eax
  8015c5:	01 c0                	add    %eax,%eax
  8015c7:	01 d0                	add    %edx,%eax
  8015c9:	c1 e0 03             	shl    $0x3,%eax
  8015cc:	01 c8                	add    %ecx,%eax
  8015ce:	8a 40 04             	mov    0x4(%eax),%al
  8015d1:	3c 01                	cmp    $0x1,%al
  8015d3:	75 03                	jne    8015d8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8015d5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015d8:	ff 45 e0             	incl   -0x20(%ebp)
  8015db:	a1 20 60 80 00       	mov    0x806020,%eax
  8015e0:	8b 50 74             	mov    0x74(%eax),%edx
  8015e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e6:	39 c2                	cmp    %eax,%edx
  8015e8:	77 cb                	ja     8015b5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8015ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015f0:	74 14                	je     801606 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 ec 49 80 00       	push   $0x8049ec
  8015fa:	6a 44                	push   $0x44
  8015fc:	68 8c 49 80 00       	push   $0x80498c
  801601:	e8 23 fe ff ff       	call   801429 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801606:	90                   	nop
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	8b 00                	mov    (%eax),%eax
  801614:	8d 48 01             	lea    0x1(%eax),%ecx
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	89 0a                	mov    %ecx,(%edx)
  80161c:	8b 55 08             	mov    0x8(%ebp),%edx
  80161f:	88 d1                	mov    %dl,%cl
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	8b 00                	mov    (%eax),%eax
  80162d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801632:	75 2c                	jne    801660 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801634:	a0 24 60 80 00       	mov    0x806024,%al
  801639:	0f b6 c0             	movzbl %al,%eax
  80163c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163f:	8b 12                	mov    (%edx),%edx
  801641:	89 d1                	mov    %edx,%ecx
  801643:	8b 55 0c             	mov    0xc(%ebp),%edx
  801646:	83 c2 08             	add    $0x8,%edx
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	50                   	push   %eax
  80164d:	51                   	push   %ecx
  80164e:	52                   	push   %edx
  80164f:	e8 22 13 00 00       	call   802976 <sys_cputs>
  801654:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801660:	8b 45 0c             	mov    0xc(%ebp),%eax
  801663:	8b 40 04             	mov    0x4(%eax),%eax
  801666:	8d 50 01             	lea    0x1(%eax),%edx
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80166f:	90                   	nop
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80167b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801682:	00 00 00 
	b.cnt = 0;
  801685:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80168c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	68 09 16 80 00       	push   $0x801609
  8016a1:	e8 11 02 00 00       	call   8018b7 <vprintfmt>
  8016a6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8016a9:	a0 24 60 80 00       	mov    0x806024,%al
  8016ae:	0f b6 c0             	movzbl %al,%eax
  8016b1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	50                   	push   %eax
  8016bb:	52                   	push   %edx
  8016bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016c2:	83 c0 08             	add    $0x8,%eax
  8016c5:	50                   	push   %eax
  8016c6:	e8 ab 12 00 00       	call   802976 <sys_cputs>
  8016cb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8016ce:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  8016d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <cprintf>:

int cprintf(const char *fmt, ...) {
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8016e3:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  8016ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8016ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	83 ec 08             	sub    $0x8,%esp
  8016f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	e8 73 ff ff ff       	call   801672 <vcprintf>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801710:	e8 0f 14 00 00       	call   802b24 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801715:	8d 45 0c             	lea    0xc(%ebp),%eax
  801718:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	83 ec 08             	sub    $0x8,%esp
  801721:	ff 75 f4             	pushl  -0xc(%ebp)
  801724:	50                   	push   %eax
  801725:	e8 48 ff ff ff       	call   801672 <vcprintf>
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801730:	e8 09 14 00 00       	call   802b3e <sys_enable_interrupt>
	return cnt;
  801735:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	53                   	push   %ebx
  80173e:	83 ec 14             	sub    $0x14,%esp
  801741:	8b 45 10             	mov    0x10(%ebp),%eax
  801744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801747:	8b 45 14             	mov    0x14(%ebp),%eax
  80174a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80174d:	8b 45 18             	mov    0x18(%ebp),%eax
  801750:	ba 00 00 00 00       	mov    $0x0,%edx
  801755:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801758:	77 55                	ja     8017af <printnum+0x75>
  80175a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80175d:	72 05                	jb     801764 <printnum+0x2a>
  80175f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801762:	77 4b                	ja     8017af <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801764:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801767:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80176a:	8b 45 18             	mov    0x18(%ebp),%eax
  80176d:	ba 00 00 00 00       	mov    $0x0,%edx
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	ff 75 f4             	pushl  -0xc(%ebp)
  801777:	ff 75 f0             	pushl  -0x10(%ebp)
  80177a:	e8 b5 29 00 00       	call   804134 <__udivdi3>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	ff 75 20             	pushl  0x20(%ebp)
  801788:	53                   	push   %ebx
  801789:	ff 75 18             	pushl  0x18(%ebp)
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	e8 a1 ff ff ff       	call   80173a <printnum>
  801799:	83 c4 20             	add    $0x20,%esp
  80179c:	eb 1a                	jmp    8017b8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80179e:	83 ec 08             	sub    $0x8,%esp
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 20             	pushl  0x20(%ebp)
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	ff d0                	call   *%eax
  8017ac:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8017af:	ff 4d 1c             	decl   0x1c(%ebp)
  8017b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8017b6:	7f e6                	jg     80179e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017b8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8017bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	53                   	push   %ebx
  8017c7:	51                   	push   %ecx
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	e8 75 2a 00 00       	call   804244 <__umoddi3>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	05 54 4c 80 00       	add    $0x804c54,%eax
  8017d7:	8a 00                	mov    (%eax),%al
  8017d9:	0f be c0             	movsbl %al,%eax
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	50                   	push   %eax
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	ff d0                	call   *%eax
  8017e8:	83 c4 10             	add    $0x10,%esp
}
  8017eb:	90                   	nop
  8017ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8017f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8017f8:	7e 1c                	jle    801816 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 00                	mov    (%eax),%eax
  8017ff:	8d 50 08             	lea    0x8(%eax),%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	89 10                	mov    %edx,(%eax)
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	83 e8 08             	sub    $0x8,%eax
  80180f:	8b 50 04             	mov    0x4(%eax),%edx
  801812:	8b 00                	mov    (%eax),%eax
  801814:	eb 40                	jmp    801856 <getuint+0x65>
	else if (lflag)
  801816:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80181a:	74 1e                	je     80183a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8b 00                	mov    (%eax),%eax
  801821:	8d 50 04             	lea    0x4(%eax),%edx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	89 10                	mov    %edx,(%eax)
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8b 00                	mov    (%eax),%eax
  80182e:	83 e8 04             	sub    $0x4,%eax
  801831:	8b 00                	mov    (%eax),%eax
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
  801838:	eb 1c                	jmp    801856 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	8b 00                	mov    (%eax),%eax
  80183f:	8d 50 04             	lea    0x4(%eax),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	89 10                	mov    %edx,(%eax)
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 00                	mov    (%eax),%eax
  80184c:	83 e8 04             	sub    $0x4,%eax
  80184f:	8b 00                	mov    (%eax),%eax
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    

00801858 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80185b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80185f:	7e 1c                	jle    80187d <getint+0x25>
		return va_arg(*ap, long long);
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	8b 00                	mov    (%eax),%eax
  801866:	8d 50 08             	lea    0x8(%eax),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	89 10                	mov    %edx,(%eax)
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8b 00                	mov    (%eax),%eax
  801873:	83 e8 08             	sub    $0x8,%eax
  801876:	8b 50 04             	mov    0x4(%eax),%edx
  801879:	8b 00                	mov    (%eax),%eax
  80187b:	eb 38                	jmp    8018b5 <getint+0x5d>
	else if (lflag)
  80187d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801881:	74 1a                	je     80189d <getint+0x45>
		return va_arg(*ap, long);
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8b 00                	mov    (%eax),%eax
  801888:	8d 50 04             	lea    0x4(%eax),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	89 10                	mov    %edx,(%eax)
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	8b 00                	mov    (%eax),%eax
  801895:	83 e8 04             	sub    $0x4,%eax
  801898:	8b 00                	mov    (%eax),%eax
  80189a:	99                   	cltd   
  80189b:	eb 18                	jmp    8018b5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8b 00                	mov    (%eax),%eax
  8018a2:	8d 50 04             	lea    0x4(%eax),%edx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	89 10                	mov    %edx,(%eax)
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8b 00                	mov    (%eax),%eax
  8018af:	83 e8 04             	sub    $0x4,%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	99                   	cltd   
}
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
  8018bc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018bf:	eb 17                	jmp    8018d8 <vprintfmt+0x21>
			if (ch == '\0')
  8018c1:	85 db                	test   %ebx,%ebx
  8018c3:	0f 84 af 03 00 00    	je     801c78 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	53                   	push   %ebx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	ff d0                	call   *%eax
  8018d5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	8d 50 01             	lea    0x1(%eax),%edx
  8018de:	89 55 10             	mov    %edx,0x10(%ebp)
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	0f b6 d8             	movzbl %al,%ebx
  8018e6:	83 fb 25             	cmp    $0x25,%ebx
  8018e9:	75 d6                	jne    8018c1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8018eb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8018ef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8018f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8018fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801904:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80190b:	8b 45 10             	mov    0x10(%ebp),%eax
  80190e:	8d 50 01             	lea    0x1(%eax),%edx
  801911:	89 55 10             	mov    %edx,0x10(%ebp)
  801914:	8a 00                	mov    (%eax),%al
  801916:	0f b6 d8             	movzbl %al,%ebx
  801919:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80191c:	83 f8 55             	cmp    $0x55,%eax
  80191f:	0f 87 2b 03 00 00    	ja     801c50 <vprintfmt+0x399>
  801925:	8b 04 85 78 4c 80 00 	mov    0x804c78(,%eax,4),%eax
  80192c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80192e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801932:	eb d7                	jmp    80190b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801934:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801938:	eb d1                	jmp    80190b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80193a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801941:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801944:	89 d0                	mov    %edx,%eax
  801946:	c1 e0 02             	shl    $0x2,%eax
  801949:	01 d0                	add    %edx,%eax
  80194b:	01 c0                	add    %eax,%eax
  80194d:	01 d8                	add    %ebx,%eax
  80194f:	83 e8 30             	sub    $0x30,%eax
  801952:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	8a 00                	mov    (%eax),%al
  80195a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80195d:	83 fb 2f             	cmp    $0x2f,%ebx
  801960:	7e 3e                	jle    8019a0 <vprintfmt+0xe9>
  801962:	83 fb 39             	cmp    $0x39,%ebx
  801965:	7f 39                	jg     8019a0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801967:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80196a:	eb d5                	jmp    801941 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80196c:	8b 45 14             	mov    0x14(%ebp),%eax
  80196f:	83 c0 04             	add    $0x4,%eax
  801972:	89 45 14             	mov    %eax,0x14(%ebp)
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	83 e8 04             	sub    $0x4,%eax
  80197b:	8b 00                	mov    (%eax),%eax
  80197d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801980:	eb 1f                	jmp    8019a1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801982:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801986:	79 83                	jns    80190b <vprintfmt+0x54>
				width = 0;
  801988:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80198f:	e9 77 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801994:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80199b:	e9 6b ff ff ff       	jmp    80190b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8019a0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8019a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019a5:	0f 89 60 ff ff ff    	jns    80190b <vprintfmt+0x54>
				width = precision, precision = -1;
  8019ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8019b8:	e9 4e ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8019bd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8019c0:	e9 46 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8019c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c8:	83 c0 04             	add    $0x4,%eax
  8019cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8019ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d1:	83 e8 04             	sub    $0x4,%eax
  8019d4:	8b 00                	mov    (%eax),%eax
  8019d6:	83 ec 08             	sub    $0x8,%esp
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	50                   	push   %eax
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	ff d0                	call   *%eax
  8019e2:	83 c4 10             	add    $0x10,%esp
			break;
  8019e5:	e9 89 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8019ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ed:	83 c0 04             	add    $0x4,%eax
  8019f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8019f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f6:	83 e8 04             	sub    $0x4,%eax
  8019f9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8019fb:	85 db                	test   %ebx,%ebx
  8019fd:	79 02                	jns    801a01 <vprintfmt+0x14a>
				err = -err;
  8019ff:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801a01:	83 fb 64             	cmp    $0x64,%ebx
  801a04:	7f 0b                	jg     801a11 <vprintfmt+0x15a>
  801a06:	8b 34 9d c0 4a 80 00 	mov    0x804ac0(,%ebx,4),%esi
  801a0d:	85 f6                	test   %esi,%esi
  801a0f:	75 19                	jne    801a2a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801a11:	53                   	push   %ebx
  801a12:	68 65 4c 80 00       	push   $0x804c65
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	e8 5e 02 00 00       	call   801c80 <printfmt>
  801a22:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a25:	e9 49 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a2a:	56                   	push   %esi
  801a2b:	68 6e 4c 80 00       	push   $0x804c6e
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	e8 45 02 00 00       	call   801c80 <printfmt>
  801a3b:	83 c4 10             	add    $0x10,%esp
			break;
  801a3e:	e9 30 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	83 c0 04             	add    $0x4,%eax
  801a49:	89 45 14             	mov    %eax,0x14(%ebp)
  801a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4f:	83 e8 04             	sub    $0x4,%eax
  801a52:	8b 30                	mov    (%eax),%esi
  801a54:	85 f6                	test   %esi,%esi
  801a56:	75 05                	jne    801a5d <vprintfmt+0x1a6>
				p = "(null)";
  801a58:	be 71 4c 80 00       	mov    $0x804c71,%esi
			if (width > 0 && padc != '-')
  801a5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a61:	7e 6d                	jle    801ad0 <vprintfmt+0x219>
  801a63:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801a67:	74 67                	je     801ad0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	50                   	push   %eax
  801a70:	56                   	push   %esi
  801a71:	e8 0c 03 00 00       	call   801d82 <strnlen>
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801a7c:	eb 16                	jmp    801a94 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801a7e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	ff d0                	call   *%eax
  801a8e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801a91:	ff 4d e4             	decl   -0x1c(%ebp)
  801a94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a98:	7f e4                	jg     801a7e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a9a:	eb 34                	jmp    801ad0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801a9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801aa0:	74 1c                	je     801abe <vprintfmt+0x207>
  801aa2:	83 fb 1f             	cmp    $0x1f,%ebx
  801aa5:	7e 05                	jle    801aac <vprintfmt+0x1f5>
  801aa7:	83 fb 7e             	cmp    $0x7e,%ebx
  801aaa:	7e 12                	jle    801abe <vprintfmt+0x207>
					putch('?', putdat);
  801aac:	83 ec 08             	sub    $0x8,%esp
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	6a 3f                	push   $0x3f
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	ff d0                	call   *%eax
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	eb 0f                	jmp    801acd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	53                   	push   %ebx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	ff d0                	call   *%eax
  801aca:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801acd:	ff 4d e4             	decl   -0x1c(%ebp)
  801ad0:	89 f0                	mov    %esi,%eax
  801ad2:	8d 70 01             	lea    0x1(%eax),%esi
  801ad5:	8a 00                	mov    (%eax),%al
  801ad7:	0f be d8             	movsbl %al,%ebx
  801ada:	85 db                	test   %ebx,%ebx
  801adc:	74 24                	je     801b02 <vprintfmt+0x24b>
  801ade:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ae2:	78 b8                	js     801a9c <vprintfmt+0x1e5>
  801ae4:	ff 4d e0             	decl   -0x20(%ebp)
  801ae7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801aeb:	79 af                	jns    801a9c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aed:	eb 13                	jmp    801b02 <vprintfmt+0x24b>
				putch(' ', putdat);
  801aef:	83 ec 08             	sub    $0x8,%esp
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	6a 20                	push   $0x20
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	ff d0                	call   *%eax
  801afc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aff:	ff 4d e4             	decl   -0x1c(%ebp)
  801b02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b06:	7f e7                	jg     801aef <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801b08:	e9 66 01 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	ff 75 e8             	pushl  -0x18(%ebp)
  801b13:	8d 45 14             	lea    0x14(%ebp),%eax
  801b16:	50                   	push   %eax
  801b17:	e8 3c fd ff ff       	call   801858 <getint>
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2b:	85 d2                	test   %edx,%edx
  801b2d:	79 23                	jns    801b52 <vprintfmt+0x29b>
				putch('-', putdat);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	6a 2d                	push   $0x2d
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	ff d0                	call   *%eax
  801b3c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b45:	f7 d8                	neg    %eax
  801b47:	83 d2 00             	adc    $0x0,%edx
  801b4a:	f7 da                	neg    %edx
  801b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801b52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b59:	e9 bc 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	ff 75 e8             	pushl  -0x18(%ebp)
  801b64:	8d 45 14             	lea    0x14(%ebp),%eax
  801b67:	50                   	push   %eax
  801b68:	e8 84 fc ff ff       	call   8017f1 <getuint>
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801b76:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b7d:	e9 98 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	6a 58                	push   $0x58
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	ff d0                	call   *%eax
  801b8f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b92:	83 ec 08             	sub    $0x8,%esp
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	6a 58                	push   $0x58
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	ff d0                	call   *%eax
  801b9f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	6a 58                	push   $0x58
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	ff d0                	call   *%eax
  801baf:	83 c4 10             	add    $0x10,%esp
			break;
  801bb2:	e9 bc 00 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	6a 30                	push   $0x30
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	ff d0                	call   *%eax
  801bc4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	6a 78                	push   $0x78
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	ff d0                	call   *%eax
  801bd4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bda:	83 c0 04             	add    $0x4,%eax
  801bdd:	89 45 14             	mov    %eax,0x14(%ebp)
  801be0:	8b 45 14             	mov    0x14(%ebp),%eax
  801be3:	83 e8 04             	sub    $0x4,%eax
  801be6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801bf9:	eb 1f                	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	ff 75 e8             	pushl  -0x18(%ebp)
  801c01:	8d 45 14             	lea    0x14(%ebp),%eax
  801c04:	50                   	push   %eax
  801c05:	e8 e7 fb ff ff       	call   8017f1 <getuint>
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801c13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801c1a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	52                   	push   %edx
  801c25:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c28:	50                   	push   %eax
  801c29:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	ff 75 08             	pushl  0x8(%ebp)
  801c35:	e8 00 fb ff ff       	call   80173a <printnum>
  801c3a:	83 c4 20             	add    $0x20,%esp
			break;
  801c3d:	eb 34                	jmp    801c73 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801c3f:	83 ec 08             	sub    $0x8,%esp
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	53                   	push   %ebx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	ff d0                	call   *%eax
  801c4b:	83 c4 10             	add    $0x10,%esp
			break;
  801c4e:	eb 23                	jmp    801c73 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801c50:	83 ec 08             	sub    $0x8,%esp
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	6a 25                	push   $0x25
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	ff d0                	call   *%eax
  801c5d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c60:	ff 4d 10             	decl   0x10(%ebp)
  801c63:	eb 03                	jmp    801c68 <vprintfmt+0x3b1>
  801c65:	ff 4d 10             	decl   0x10(%ebp)
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	48                   	dec    %eax
  801c6c:	8a 00                	mov    (%eax),%al
  801c6e:	3c 25                	cmp    $0x25,%al
  801c70:	75 f3                	jne    801c65 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801c72:	90                   	nop
		}
	}
  801c73:	e9 47 fc ff ff       	jmp    8018bf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801c78:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801c79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801c86:	8d 45 10             	lea    0x10(%ebp),%eax
  801c89:	83 c0 04             	add    $0x4,%eax
  801c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c92:	ff 75 f4             	pushl  -0xc(%ebp)
  801c95:	50                   	push   %eax
  801c96:	ff 75 0c             	pushl  0xc(%ebp)
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	e8 16 fc ff ff       	call   8018b7 <vprintfmt>
  801ca1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ca4:	90                   	nop
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cad:	8b 40 08             	mov    0x8(%eax),%eax
  801cb0:	8d 50 01             	lea    0x1(%eax),%edx
  801cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbc:	8b 10                	mov    (%eax),%edx
  801cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc1:	8b 40 04             	mov    0x4(%eax),%eax
  801cc4:	39 c2                	cmp    %eax,%edx
  801cc6:	73 12                	jae    801cda <sprintputch+0x33>
		*b->buf++ = ch;
  801cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccb:	8b 00                	mov    (%eax),%eax
  801ccd:	8d 48 01             	lea    0x1(%eax),%ecx
  801cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd3:	89 0a                	mov    %ecx,(%edx)
  801cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd8:	88 10                	mov    %dl,(%eax)
}
  801cda:	90                   	nop
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    

00801cdd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cec:	8d 50 ff             	lea    -0x1(%eax),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801cfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d02:	74 06                	je     801d0a <vsnprintf+0x2d>
  801d04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d08:	7f 07                	jg     801d11 <vsnprintf+0x34>
		return -E_INVAL;
  801d0a:	b8 03 00 00 00       	mov    $0x3,%eax
  801d0f:	eb 20                	jmp    801d31 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801d11:	ff 75 14             	pushl  0x14(%ebp)
  801d14:	ff 75 10             	pushl  0x10(%ebp)
  801d17:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	68 a7 1c 80 00       	push   $0x801ca7
  801d20:	e8 92 fb ff ff       	call   8018b7 <vprintfmt>
  801d25:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801d39:	8d 45 10             	lea    0x10(%ebp),%eax
  801d3c:	83 c0 04             	add    $0x4,%eax
  801d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801d42:	8b 45 10             	mov    0x10(%ebp),%eax
  801d45:	ff 75 f4             	pushl  -0xc(%ebp)
  801d48:	50                   	push   %eax
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	ff 75 08             	pushl  0x8(%ebp)
  801d4f:	e8 89 ff ff ff       	call   801cdd <vsnprintf>
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d6c:	eb 06                	jmp    801d74 <strlen+0x15>
		n++;
  801d6e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d71:	ff 45 08             	incl   0x8(%ebp)
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	8a 00                	mov    (%eax),%al
  801d79:	84 c0                	test   %al,%al
  801d7b:	75 f1                	jne    801d6e <strlen+0xf>
		n++;
	return n;
  801d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d8f:	eb 09                	jmp    801d9a <strnlen+0x18>
		n++;
  801d91:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d94:	ff 45 08             	incl   0x8(%ebp)
  801d97:	ff 4d 0c             	decl   0xc(%ebp)
  801d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d9e:	74 09                	je     801da9 <strnlen+0x27>
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8a 00                	mov    (%eax),%al
  801da5:	84 c0                	test   %al,%al
  801da7:	75 e8                	jne    801d91 <strnlen+0xf>
		n++;
	return n;
  801da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801dba:	90                   	nop
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	8d 50 01             	lea    0x1(%eax),%edx
  801dc1:	89 55 08             	mov    %edx,0x8(%ebp)
  801dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801dcd:	8a 12                	mov    (%edx),%dl
  801dcf:	88 10                	mov    %dl,(%eax)
  801dd1:	8a 00                	mov    (%eax),%al
  801dd3:	84 c0                	test   %al,%al
  801dd5:	75 e4                	jne    801dbb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801def:	eb 1f                	jmp    801e10 <strncpy+0x34>
		*dst++ = *src;
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	8d 50 01             	lea    0x1(%eax),%edx
  801df7:	89 55 08             	mov    %edx,0x8(%ebp)
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8a 12                	mov    (%edx),%dl
  801dff:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e04:	8a 00                	mov    (%eax),%al
  801e06:	84 c0                	test   %al,%al
  801e08:	74 03                	je     801e0d <strncpy+0x31>
			src++;
  801e0a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801e0d:	ff 45 fc             	incl   -0x4(%ebp)
  801e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e13:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e16:	72 d9                	jb     801df1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801e18:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801e29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e2d:	74 30                	je     801e5f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801e2f:	eb 16                	jmp    801e47 <strlcpy+0x2a>
			*dst++ = *src++;
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	8d 50 01             	lea    0x1(%eax),%edx
  801e37:	89 55 08             	mov    %edx,0x8(%ebp)
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e40:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e43:	8a 12                	mov    (%edx),%dl
  801e45:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e47:	ff 4d 10             	decl   0x10(%ebp)
  801e4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e4e:	74 09                	je     801e59 <strlcpy+0x3c>
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	8a 00                	mov    (%eax),%al
  801e55:	84 c0                	test   %al,%al
  801e57:	75 d8                	jne    801e31 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e65:	29 c2                	sub    %eax,%edx
  801e67:	89 d0                	mov    %edx,%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e6e:	eb 06                	jmp    801e76 <strcmp+0xb>
		p++, q++;
  801e70:	ff 45 08             	incl   0x8(%ebp)
  801e73:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8a 00                	mov    (%eax),%al
  801e7b:	84 c0                	test   %al,%al
  801e7d:	74 0e                	je     801e8d <strcmp+0x22>
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	8a 10                	mov    (%eax),%dl
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	8a 00                	mov    (%eax),%al
  801e89:	38 c2                	cmp    %al,%dl
  801e8b:	74 e3                	je     801e70 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	8a 00                	mov    (%eax),%al
  801e92:	0f b6 d0             	movzbl %al,%edx
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	8a 00                	mov    (%eax),%al
  801e9a:	0f b6 c0             	movzbl %al,%eax
  801e9d:	29 c2                	sub    %eax,%edx
  801e9f:	89 d0                	mov    %edx,%eax
}
  801ea1:	5d                   	pop    %ebp
  801ea2:	c3                   	ret    

00801ea3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801ea6:	eb 09                	jmp    801eb1 <strncmp+0xe>
		n--, p++, q++;
  801ea8:	ff 4d 10             	decl   0x10(%ebp)
  801eab:	ff 45 08             	incl   0x8(%ebp)
  801eae:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801eb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eb5:	74 17                	je     801ece <strncmp+0x2b>
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	8a 00                	mov    (%eax),%al
  801ebc:	84 c0                	test   %al,%al
  801ebe:	74 0e                	je     801ece <strncmp+0x2b>
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	8a 10                	mov    (%eax),%dl
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	8a 00                	mov    (%eax),%al
  801eca:	38 c2                	cmp    %al,%dl
  801ecc:	74 da                	je     801ea8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ed2:	75 07                	jne    801edb <strncmp+0x38>
		return 0;
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	eb 14                	jmp    801eef <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	8a 00                	mov    (%eax),%al
  801ee0:	0f b6 d0             	movzbl %al,%edx
  801ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee6:	8a 00                	mov    (%eax),%al
  801ee8:	0f b6 c0             	movzbl %al,%eax
  801eeb:	29 c2                	sub    %eax,%edx
  801eed:	89 d0                	mov    %edx,%eax
}
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    

00801ef1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 04             	sub    $0x4,%esp
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801efd:	eb 12                	jmp    801f11 <strchr+0x20>
		if (*s == c)
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	8a 00                	mov    (%eax),%al
  801f04:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f07:	75 05                	jne    801f0e <strchr+0x1d>
			return (char *) s;
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	eb 11                	jmp    801f1f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801f0e:	ff 45 08             	incl   0x8(%ebp)
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8a 00                	mov    (%eax),%al
  801f16:	84 c0                	test   %al,%al
  801f18:	75 e5                	jne    801eff <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 04             	sub    $0x4,%esp
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f2d:	eb 0d                	jmp    801f3c <strfind+0x1b>
		if (*s == c)
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	8a 00                	mov    (%eax),%al
  801f34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f37:	74 0e                	je     801f47 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f39:	ff 45 08             	incl   0x8(%ebp)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	8a 00                	mov    (%eax),%al
  801f41:	84 c0                	test   %al,%al
  801f43:	75 ea                	jne    801f2f <strfind+0xe>
  801f45:	eb 01                	jmp    801f48 <strfind+0x27>
		if (*s == c)
			break;
  801f47:	90                   	nop
	return (char *) s;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801f59:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801f5f:	eb 0e                	jmp    801f6f <memset+0x22>
		*p++ = c;
  801f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f64:	8d 50 01             	lea    0x1(%eax),%edx
  801f67:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801f6f:	ff 4d f8             	decl   -0x8(%ebp)
  801f72:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f76:	79 e9                	jns    801f61 <memset+0x14>
		*p++ = c;

	return v;
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801f8f:	eb 16                	jmp    801fa7 <memcpy+0x2a>
		*d++ = *s++;
  801f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f94:	8d 50 01             	lea    0x1(%eax),%edx
  801f97:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fa0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801fa3:	8a 12                	mov    (%edx),%dl
  801fa5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  801faa:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fad:	89 55 10             	mov    %edx,0x10(%ebp)
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	75 dd                	jne    801f91 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fd1:	73 50                	jae    802023 <memmove+0x6a>
  801fd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd9:	01 d0                	add    %edx,%eax
  801fdb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fde:	76 43                	jbe    802023 <memmove+0x6a>
		s += n;
  801fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fec:	eb 10                	jmp    801ffe <memmove+0x45>
			*--d = *--s;
  801fee:	ff 4d f8             	decl   -0x8(%ebp)
  801ff1:	ff 4d fc             	decl   -0x4(%ebp)
  801ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff7:	8a 10                	mov    (%eax),%dl
  801ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ffc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  802001:	8d 50 ff             	lea    -0x1(%eax),%edx
  802004:	89 55 10             	mov    %edx,0x10(%ebp)
  802007:	85 c0                	test   %eax,%eax
  802009:	75 e3                	jne    801fee <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80200b:	eb 23                	jmp    802030 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80200d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802010:	8d 50 01             	lea    0x1(%eax),%edx
  802013:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802016:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802019:	8d 4a 01             	lea    0x1(%edx),%ecx
  80201c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80201f:	8a 12                	mov    (%edx),%dl
  802021:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802023:	8b 45 10             	mov    0x10(%ebp),%eax
  802026:	8d 50 ff             	lea    -0x1(%eax),%edx
  802029:	89 55 10             	mov    %edx,0x10(%ebp)
  80202c:	85 c0                	test   %eax,%eax
  80202e:	75 dd                	jne    80200d <memmove+0x54>
			*d++ = *s++;

	return dst;
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802041:	8b 45 0c             	mov    0xc(%ebp),%eax
  802044:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802047:	eb 2a                	jmp    802073 <memcmp+0x3e>
		if (*s1 != *s2)
  802049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204c:	8a 10                	mov    (%eax),%dl
  80204e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802051:	8a 00                	mov    (%eax),%al
  802053:	38 c2                	cmp    %al,%dl
  802055:	74 16                	je     80206d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205a:	8a 00                	mov    (%eax),%al
  80205c:	0f b6 d0             	movzbl %al,%edx
  80205f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802062:	8a 00                	mov    (%eax),%al
  802064:	0f b6 c0             	movzbl %al,%eax
  802067:	29 c2                	sub    %eax,%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	eb 18                	jmp    802085 <memcmp+0x50>
		s1++, s2++;
  80206d:	ff 45 fc             	incl   -0x4(%ebp)
  802070:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802073:	8b 45 10             	mov    0x10(%ebp),%eax
  802076:	8d 50 ff             	lea    -0x1(%eax),%edx
  802079:	89 55 10             	mov    %edx,0x10(%ebp)
  80207c:	85 c0                	test   %eax,%eax
  80207e:	75 c9                	jne    802049 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80208d:	8b 55 08             	mov    0x8(%ebp),%edx
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	01 d0                	add    %edx,%eax
  802095:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802098:	eb 15                	jmp    8020af <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	8a 00                	mov    (%eax),%al
  80209f:	0f b6 d0             	movzbl %al,%edx
  8020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a5:	0f b6 c0             	movzbl %al,%eax
  8020a8:	39 c2                	cmp    %eax,%edx
  8020aa:	74 0d                	je     8020b9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8020ac:	ff 45 08             	incl   0x8(%ebp)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020b5:	72 e3                	jb     80209a <memfind+0x13>
  8020b7:	eb 01                	jmp    8020ba <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8020b9:	90                   	nop
	return (void *) s;
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8020c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d3:	eb 03                	jmp    8020d8 <strtol+0x19>
		s++;
  8020d5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	8a 00                	mov    (%eax),%al
  8020dd:	3c 20                	cmp    $0x20,%al
  8020df:	74 f4                	je     8020d5 <strtol+0x16>
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8a 00                	mov    (%eax),%al
  8020e6:	3c 09                	cmp    $0x9,%al
  8020e8:	74 eb                	je     8020d5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	8a 00                	mov    (%eax),%al
  8020ef:	3c 2b                	cmp    $0x2b,%al
  8020f1:	75 05                	jne    8020f8 <strtol+0x39>
		s++;
  8020f3:	ff 45 08             	incl   0x8(%ebp)
  8020f6:	eb 13                	jmp    80210b <strtol+0x4c>
	else if (*s == '-')
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	8a 00                	mov    (%eax),%al
  8020fd:	3c 2d                	cmp    $0x2d,%al
  8020ff:	75 0a                	jne    80210b <strtol+0x4c>
		s++, neg = 1;
  802101:	ff 45 08             	incl   0x8(%ebp)
  802104:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80210b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210f:	74 06                	je     802117 <strtol+0x58>
  802111:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802115:	75 20                	jne    802137 <strtol+0x78>
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	8a 00                	mov    (%eax),%al
  80211c:	3c 30                	cmp    $0x30,%al
  80211e:	75 17                	jne    802137 <strtol+0x78>
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	40                   	inc    %eax
  802124:	8a 00                	mov    (%eax),%al
  802126:	3c 78                	cmp    $0x78,%al
  802128:	75 0d                	jne    802137 <strtol+0x78>
		s += 2, base = 16;
  80212a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80212e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802135:	eb 28                	jmp    80215f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802137:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213b:	75 15                	jne    802152 <strtol+0x93>
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	8a 00                	mov    (%eax),%al
  802142:	3c 30                	cmp    $0x30,%al
  802144:	75 0c                	jne    802152 <strtol+0x93>
		s++, base = 8;
  802146:	ff 45 08             	incl   0x8(%ebp)
  802149:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802150:	eb 0d                	jmp    80215f <strtol+0xa0>
	else if (base == 0)
  802152:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802156:	75 07                	jne    80215f <strtol+0xa0>
		base = 10;
  802158:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8a 00                	mov    (%eax),%al
  802164:	3c 2f                	cmp    $0x2f,%al
  802166:	7e 19                	jle    802181 <strtol+0xc2>
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	8a 00                	mov    (%eax),%al
  80216d:	3c 39                	cmp    $0x39,%al
  80216f:	7f 10                	jg     802181 <strtol+0xc2>
			dig = *s - '0';
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	8a 00                	mov    (%eax),%al
  802176:	0f be c0             	movsbl %al,%eax
  802179:	83 e8 30             	sub    $0x30,%eax
  80217c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217f:	eb 42                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8a 00                	mov    (%eax),%al
  802186:	3c 60                	cmp    $0x60,%al
  802188:	7e 19                	jle    8021a3 <strtol+0xe4>
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8a 00                	mov    (%eax),%al
  80218f:	3c 7a                	cmp    $0x7a,%al
  802191:	7f 10                	jg     8021a3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8a 00                	mov    (%eax),%al
  802198:	0f be c0             	movsbl %al,%eax
  80219b:	83 e8 57             	sub    $0x57,%eax
  80219e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a1:	eb 20                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8a 00                	mov    (%eax),%al
  8021a8:	3c 40                	cmp    $0x40,%al
  8021aa:	7e 39                	jle    8021e5 <strtol+0x126>
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8a 00                	mov    (%eax),%al
  8021b1:	3c 5a                	cmp    $0x5a,%al
  8021b3:	7f 30                	jg     8021e5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8a 00                	mov    (%eax),%al
  8021ba:	0f be c0             	movsbl %al,%eax
  8021bd:	83 e8 37             	sub    $0x37,%eax
  8021c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021c9:	7d 19                	jge    8021e4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021cb:	ff 45 08             	incl   0x8(%ebp)
  8021ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021d5:	89 c2                	mov    %eax,%edx
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	01 d0                	add    %edx,%eax
  8021dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021df:	e9 7b ff ff ff       	jmp    80215f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021e4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021e9:	74 08                	je     8021f3 <strtol+0x134>
		*endptr = (char *) s;
  8021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f7:	74 07                	je     802200 <strtol+0x141>
  8021f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021fc:	f7 d8                	neg    %eax
  8021fe:	eb 03                	jmp    802203 <strtol+0x144>
  802200:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <ltostr>:

void
ltostr(long value, char *str)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80220b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802212:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221d:	79 13                	jns    802232 <ltostr+0x2d>
	{
		neg = 1;
  80221f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802226:	8b 45 0c             	mov    0xc(%ebp),%eax
  802229:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80222c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80222f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80223a:	99                   	cltd   
  80223b:	f7 f9                	idiv   %ecx
  80223d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802240:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802243:	8d 50 01             	lea    0x1(%eax),%edx
  802246:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802249:	89 c2                	mov    %eax,%edx
  80224b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224e:	01 d0                	add    %edx,%eax
  802250:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802253:	83 c2 30             	add    $0x30,%edx
  802256:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802258:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80225b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802260:	f7 e9                	imul   %ecx
  802262:	c1 fa 02             	sar    $0x2,%edx
  802265:	89 c8                	mov    %ecx,%eax
  802267:	c1 f8 1f             	sar    $0x1f,%eax
  80226a:	29 c2                	sub    %eax,%edx
  80226c:	89 d0                	mov    %edx,%eax
  80226e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802274:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802279:	f7 e9                	imul   %ecx
  80227b:	c1 fa 02             	sar    $0x2,%edx
  80227e:	89 c8                	mov    %ecx,%eax
  802280:	c1 f8 1f             	sar    $0x1f,%eax
  802283:	29 c2                	sub    %eax,%edx
  802285:	89 d0                	mov    %edx,%eax
  802287:	c1 e0 02             	shl    $0x2,%eax
  80228a:	01 d0                	add    %edx,%eax
  80228c:	01 c0                	add    %eax,%eax
  80228e:	29 c1                	sub    %eax,%ecx
  802290:	89 ca                	mov    %ecx,%edx
  802292:	85 d2                	test   %edx,%edx
  802294:	75 9c                	jne    802232 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802296:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80229d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022a0:	48                   	dec    %eax
  8022a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8022a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022a8:	74 3d                	je     8022e7 <ltostr+0xe2>
		start = 1 ;
  8022aa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8022b1:	eb 34                	jmp    8022e7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	8a 00                	mov    (%eax),%al
  8022bd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8022c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c6:	01 c2                	add    %eax,%edx
  8022c8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ce:	01 c8                	add    %ecx,%eax
  8022d0:	8a 00                	mov    (%eax),%al
  8022d2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8022d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022da:	01 c2                	add    %eax,%edx
  8022dc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8022df:	88 02                	mov    %al,(%edx)
		start++ ;
  8022e1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8022e4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022ed:	7c c4                	jl     8022b3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8022ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8022f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f5:	01 d0                	add    %edx,%eax
  8022f7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8022fa:	90                   	nop
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	e8 54 fa ff ff       	call   801d5f <strlen>
  80230b:	83 c4 04             	add    $0x4,%esp
  80230e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802311:	ff 75 0c             	pushl  0xc(%ebp)
  802314:	e8 46 fa ff ff       	call   801d5f <strlen>
  802319:	83 c4 04             	add    $0x4,%esp
  80231c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80231f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802326:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80232d:	eb 17                	jmp    802346 <strcconcat+0x49>
		final[s] = str1[s] ;
  80232f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802332:	8b 45 10             	mov    0x10(%ebp),%eax
  802335:	01 c2                	add    %eax,%edx
  802337:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	01 c8                	add    %ecx,%eax
  80233f:	8a 00                	mov    (%eax),%al
  802341:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802343:	ff 45 fc             	incl   -0x4(%ebp)
  802346:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802349:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80234c:	7c e1                	jl     80232f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80234e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802355:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80235c:	eb 1f                	jmp    80237d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80235e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802361:	8d 50 01             	lea    0x1(%eax),%edx
  802364:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802367:	89 c2                	mov    %eax,%edx
  802369:	8b 45 10             	mov    0x10(%ebp),%eax
  80236c:	01 c2                	add    %eax,%edx
  80236e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	01 c8                	add    %ecx,%eax
  802376:	8a 00                	mov    (%eax),%al
  802378:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80237a:	ff 45 f8             	incl   -0x8(%ebp)
  80237d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802380:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802383:	7c d9                	jl     80235e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802385:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802388:	8b 45 10             	mov    0x10(%ebp),%eax
  80238b:	01 d0                	add    %edx,%eax
  80238d:	c6 00 00             	movb   $0x0,(%eax)
}
  802390:	90                   	nop
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802396:	8b 45 14             	mov    0x14(%ebp),%eax
  802399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80239f:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023b6:	eb 0c                	jmp    8023c4 <strsplit+0x31>
			*string++ = 0;
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8d 50 01             	lea    0x1(%eax),%edx
  8023be:	89 55 08             	mov    %edx,0x8(%ebp)
  8023c1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	8a 00                	mov    (%eax),%al
  8023c9:	84 c0                	test   %al,%al
  8023cb:	74 18                	je     8023e5 <strsplit+0x52>
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8a 00                	mov    (%eax),%al
  8023d2:	0f be c0             	movsbl %al,%eax
  8023d5:	50                   	push   %eax
  8023d6:	ff 75 0c             	pushl  0xc(%ebp)
  8023d9:	e8 13 fb ff ff       	call   801ef1 <strchr>
  8023de:	83 c4 08             	add    $0x8,%esp
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	75 d3                	jne    8023b8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	8a 00                	mov    (%eax),%al
  8023ea:	84 c0                	test   %al,%al
  8023ec:	74 5a                	je     802448 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8023ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	83 f8 0f             	cmp    $0xf,%eax
  8023f6:	75 07                	jne    8023ff <strsplit+0x6c>
		{
			return 0;
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	eb 66                	jmp    802465 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	8d 48 01             	lea    0x1(%eax),%ecx
  802407:	8b 55 14             	mov    0x14(%ebp),%edx
  80240a:	89 0a                	mov    %ecx,(%edx)
  80240c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802413:	8b 45 10             	mov    0x10(%ebp),%eax
  802416:	01 c2                	add    %eax,%edx
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80241d:	eb 03                	jmp    802422 <strsplit+0x8f>
			string++;
  80241f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	8a 00                	mov    (%eax),%al
  802427:	84 c0                	test   %al,%al
  802429:	74 8b                	je     8023b6 <strsplit+0x23>
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	8a 00                	mov    (%eax),%al
  802430:	0f be c0             	movsbl %al,%eax
  802433:	50                   	push   %eax
  802434:	ff 75 0c             	pushl  0xc(%ebp)
  802437:	e8 b5 fa ff ff       	call   801ef1 <strchr>
  80243c:	83 c4 08             	add    $0x8,%esp
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 dc                	je     80241f <strsplit+0x8c>
			string++;
	}
  802443:	e9 6e ff ff ff       	jmp    8023b6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802448:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802449:	8b 45 14             	mov    0x14(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802455:	8b 45 10             	mov    0x10(%ebp),%eax
  802458:	01 d0                	add    %edx,%eax
  80245a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802460:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80246d:	a1 04 60 80 00       	mov    0x806004,%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 1f                	je     802495 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802476:	e8 1d 00 00 00       	call   802498 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80247b:	83 ec 0c             	sub    $0xc,%esp
  80247e:	68 d0 4d 80 00       	push   $0x804dd0
  802483:	e8 55 f2 ff ff       	call   8016dd <cprintf>
  802488:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80248b:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  802492:	00 00 00 
	}
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80249e:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  8024a5:	00 00 00 
  8024a8:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  8024af:	00 00 00 
  8024b2:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  8024b9:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  8024bc:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8024c3:	00 00 00 
  8024c6:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8024cd:	00 00 00 
  8024d0:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8024d7:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8024da:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  8024e1:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8024e4:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024f3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024f8:	a3 50 60 80 00       	mov    %eax,0x806050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8024fd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802504:	a1 20 61 80 00       	mov    0x806120,%eax
  802509:	c1 e0 04             	shl    $0x4,%eax
  80250c:	89 c2                	mov    %eax,%edx
  80250e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802511:	01 d0                	add    %edx,%eax
  802513:	48                   	dec    %eax
  802514:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802517:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251a:	ba 00 00 00 00       	mov    $0x0,%edx
  80251f:	f7 75 f0             	divl   -0x10(%ebp)
  802522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802525:	29 d0                	sub    %edx,%eax
  802527:	89 c2                	mov    %eax,%edx
  802529:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  802530:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802533:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802538:	2d 00 10 00 00       	sub    $0x1000,%eax
  80253d:	83 ec 04             	sub    $0x4,%esp
  802540:	6a 06                	push   $0x6
  802542:	52                   	push   %edx
  802543:	50                   	push   %eax
  802544:	e8 71 05 00 00       	call   802aba <sys_allocate_chunk>
  802549:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80254c:	a1 20 61 80 00       	mov    0x806120,%eax
  802551:	83 ec 0c             	sub    $0xc,%esp
  802554:	50                   	push   %eax
  802555:	e8 e6 0b 00 00       	call   803140 <initialize_MemBlocksList>
  80255a:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  80255d:	a1 48 61 80 00       	mov    0x806148,%eax
  802562:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  802565:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802569:	75 14                	jne    80257f <initialize_dyn_block_system+0xe7>
  80256b:	83 ec 04             	sub    $0x4,%esp
  80256e:	68 f5 4d 80 00       	push   $0x804df5
  802573:	6a 2b                	push   $0x2b
  802575:	68 13 4e 80 00       	push   $0x804e13
  80257a:	e8 aa ee ff ff       	call   801429 <_panic>
  80257f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802582:	8b 00                	mov    (%eax),%eax
  802584:	85 c0                	test   %eax,%eax
  802586:	74 10                	je     802598 <initialize_dyn_block_system+0x100>
  802588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258b:	8b 00                	mov    (%eax),%eax
  80258d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802590:	8b 52 04             	mov    0x4(%edx),%edx
  802593:	89 50 04             	mov    %edx,0x4(%eax)
  802596:	eb 0b                	jmp    8025a3 <initialize_dyn_block_system+0x10b>
  802598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259b:	8b 40 04             	mov    0x4(%eax),%eax
  80259e:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8025a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a6:	8b 40 04             	mov    0x4(%eax),%eax
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	74 0f                	je     8025bc <initialize_dyn_block_system+0x124>
  8025ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b0:	8b 40 04             	mov    0x4(%eax),%eax
  8025b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b6:	8b 12                	mov    (%edx),%edx
  8025b8:	89 10                	mov    %edx,(%eax)
  8025ba:	eb 0a                	jmp    8025c6 <initialize_dyn_block_system+0x12e>
  8025bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bf:	8b 00                	mov    (%eax),%eax
  8025c1:	a3 48 61 80 00       	mov    %eax,0x806148
  8025c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d9:	a1 54 61 80 00       	mov    0x806154,%eax
  8025de:	48                   	dec    %eax
  8025df:	a3 54 61 80 00       	mov    %eax,0x806154
		block_node->sva = USER_HEAP_START ;
  8025e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  8025ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f1:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  8025f8:	83 ec 0c             	sub    $0xc,%esp
  8025fb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8025fe:	e8 d2 13 00 00       	call   8039d5 <insert_sorted_with_merge_freeList>
  802603:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  802606:	90                   	nop
  802607:	c9                   	leave  
  802608:	c3                   	ret    

00802609 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80260f:	e8 53 fe ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  802614:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802618:	75 07                	jne    802621 <malloc+0x18>
  80261a:	b8 00 00 00 00       	mov    $0x0,%eax
  80261f:	eb 61                	jmp    802682 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  802621:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802628:	8b 55 08             	mov    0x8(%ebp),%edx
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	01 d0                	add    %edx,%eax
  802630:	48                   	dec    %eax
  802631:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802637:	ba 00 00 00 00       	mov    $0x0,%edx
  80263c:	f7 75 f4             	divl   -0xc(%ebp)
  80263f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802642:	29 d0                	sub    %edx,%eax
  802644:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802647:	e8 3c 08 00 00       	call   802e88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80264c:	85 c0                	test   %eax,%eax
  80264e:	74 2d                	je     80267d <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  802650:	83 ec 0c             	sub    $0xc,%esp
  802653:	ff 75 08             	pushl  0x8(%ebp)
  802656:	e8 3e 0f 00 00       	call   803599 <alloc_block_FF>
  80265b:	83 c4 10             	add    $0x10,%esp
  80265e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  802661:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802665:	74 16                	je     80267d <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  802667:	83 ec 0c             	sub    $0xc,%esp
  80266a:	ff 75 ec             	pushl  -0x14(%ebp)
  80266d:	e8 48 0c 00 00       	call   8032ba <insert_sorted_allocList>
  802672:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  802675:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802678:	8b 40 08             	mov    0x8(%eax),%eax
  80267b:	eb 05                	jmp    802682 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  80267d:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
  802687:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  80268a:	8b 45 08             	mov    0x8(%ebp),%eax
  80268d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802698:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	83 ec 08             	sub    $0x8,%esp
  8026a1:	50                   	push   %eax
  8026a2:	68 40 60 80 00       	push   $0x806040
  8026a7:	e8 71 0b 00 00       	call   80321d <find_block>
  8026ac:	83 c4 10             	add    $0x10,%esp
  8026af:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  8026b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bb:	83 ec 08             	sub    $0x8,%esp
  8026be:	52                   	push   %edx
  8026bf:	50                   	push   %eax
  8026c0:	e8 bd 03 00 00       	call   802a82 <sys_free_user_mem>
  8026c5:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  8026c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026cc:	75 14                	jne    8026e2 <free+0x5e>
  8026ce:	83 ec 04             	sub    $0x4,%esp
  8026d1:	68 f5 4d 80 00       	push   $0x804df5
  8026d6:	6a 71                	push   $0x71
  8026d8:	68 13 4e 80 00       	push   $0x804e13
  8026dd:	e8 47 ed ff ff       	call   801429 <_panic>
  8026e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e5:	8b 00                	mov    (%eax),%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	74 10                	je     8026fb <free+0x77>
  8026eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ee:	8b 00                	mov    (%eax),%eax
  8026f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f3:	8b 52 04             	mov    0x4(%edx),%edx
  8026f6:	89 50 04             	mov    %edx,0x4(%eax)
  8026f9:	eb 0b                	jmp    802706 <free+0x82>
  8026fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fe:	8b 40 04             	mov    0x4(%eax),%eax
  802701:	a3 44 60 80 00       	mov    %eax,0x806044
  802706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802709:	8b 40 04             	mov    0x4(%eax),%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	74 0f                	je     80271f <free+0x9b>
  802710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802713:	8b 40 04             	mov    0x4(%eax),%eax
  802716:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802719:	8b 12                	mov    (%edx),%edx
  80271b:	89 10                	mov    %edx,(%eax)
  80271d:	eb 0a                	jmp    802729 <free+0xa5>
  80271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	a3 40 60 80 00       	mov    %eax,0x806040
  802729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802735:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273c:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802741:	48                   	dec    %eax
  802742:	a3 4c 60 80 00       	mov    %eax,0x80604c
		insert_sorted_with_merge_freeList(elementForEach);
  802747:	83 ec 0c             	sub    $0xc,%esp
  80274a:	ff 75 f0             	pushl  -0x10(%ebp)
  80274d:	e8 83 12 00 00       	call   8039d5 <insert_sorted_with_merge_freeList>
  802752:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802755:	90                   	nop
  802756:	c9                   	leave  
  802757:	c3                   	ret    

00802758 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802758:	55                   	push   %ebp
  802759:	89 e5                	mov    %esp,%ebp
  80275b:	83 ec 28             	sub    $0x28,%esp
  80275e:	8b 45 10             	mov    0x10(%ebp),%eax
  802761:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802764:	e8 fe fc ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  802769:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80276d:	75 0a                	jne    802779 <smalloc+0x21>
  80276f:	b8 00 00 00 00       	mov    $0x0,%eax
  802774:	e9 86 00 00 00       	jmp    8027ff <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  802779:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802780:	8b 55 0c             	mov    0xc(%ebp),%edx
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	01 d0                	add    %edx,%eax
  802788:	48                   	dec    %eax
  802789:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80278c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278f:	ba 00 00 00 00       	mov    $0x0,%edx
  802794:	f7 75 f4             	divl   -0xc(%ebp)
  802797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279a:	29 d0                	sub    %edx,%eax
  80279c:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80279f:	e8 e4 06 00 00       	call   802e88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	74 52                	je     8027fa <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8027a8:	83 ec 0c             	sub    $0xc,%esp
  8027ab:	ff 75 0c             	pushl  0xc(%ebp)
  8027ae:	e8 e6 0d 00 00       	call   803599 <alloc_block_FF>
  8027b3:	83 c4 10             	add    $0x10,%esp
  8027b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  8027b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027bd:	75 07                	jne    8027c6 <smalloc+0x6e>
			return NULL ;
  8027bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c4:	eb 39                	jmp    8027ff <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  8027c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c9:	8b 40 08             	mov    0x8(%eax),%eax
  8027cc:	89 c2                	mov    %eax,%edx
  8027ce:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8027d2:	52                   	push   %edx
  8027d3:	50                   	push   %eax
  8027d4:	ff 75 0c             	pushl  0xc(%ebp)
  8027d7:	ff 75 08             	pushl  0x8(%ebp)
  8027da:	e8 2e 04 00 00       	call   802c0d <sys_createSharedObject>
  8027df:	83 c4 10             	add    $0x10,%esp
  8027e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  8027e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027e9:	79 07                	jns    8027f2 <smalloc+0x9a>
			return (void*)NULL ;
  8027eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f0:	eb 0d                	jmp    8027ff <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  8027f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f5:	8b 40 08             	mov    0x8(%eax),%eax
  8027f8:	eb 05                	jmp    8027ff <smalloc+0xa7>
		}
		return (void*)NULL ;
  8027fa:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8027ff:	c9                   	leave  
  802800:	c3                   	ret    

00802801 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802801:	55                   	push   %ebp
  802802:	89 e5                	mov    %esp,%ebp
  802804:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802807:	e8 5b fc ff ff       	call   802467 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80280c:	83 ec 08             	sub    $0x8,%esp
  80280f:	ff 75 0c             	pushl  0xc(%ebp)
  802812:	ff 75 08             	pushl  0x8(%ebp)
  802815:	e8 1d 04 00 00       	call   802c37 <sys_getSizeOfSharedObject>
  80281a:	83 c4 10             	add    $0x10,%esp
  80281d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  802820:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802824:	75 0a                	jne    802830 <sget+0x2f>
			return NULL ;
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
  80282b:	e9 83 00 00 00       	jmp    8028b3 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  802830:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802837:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283d:	01 d0                	add    %edx,%eax
  80283f:	48                   	dec    %eax
  802840:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802846:	ba 00 00 00 00       	mov    $0x0,%edx
  80284b:	f7 75 f0             	divl   -0x10(%ebp)
  80284e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802851:	29 d0                	sub    %edx,%eax
  802853:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802856:	e8 2d 06 00 00       	call   802e88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80285b:	85 c0                	test   %eax,%eax
  80285d:	74 4f                	je     8028ae <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	83 ec 0c             	sub    $0xc,%esp
  802865:	50                   	push   %eax
  802866:	e8 2e 0d 00 00       	call   803599 <alloc_block_FF>
  80286b:	83 c4 10             	add    $0x10,%esp
  80286e:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  802871:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802875:	75 07                	jne    80287e <sget+0x7d>
					return (void*)NULL ;
  802877:	b8 00 00 00 00       	mov    $0x0,%eax
  80287c:	eb 35                	jmp    8028b3 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  80287e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802881:	8b 40 08             	mov    0x8(%eax),%eax
  802884:	83 ec 04             	sub    $0x4,%esp
  802887:	50                   	push   %eax
  802888:	ff 75 0c             	pushl  0xc(%ebp)
  80288b:	ff 75 08             	pushl  0x8(%ebp)
  80288e:	e8 c1 03 00 00       	call   802c54 <sys_getSharedObject>
  802893:	83 c4 10             	add    $0x10,%esp
  802896:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  802899:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80289d:	79 07                	jns    8028a6 <sget+0xa5>
				return (void*)NULL ;
  80289f:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a4:	eb 0d                	jmp    8028b3 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8028a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a9:	8b 40 08             	mov    0x8(%eax),%eax
  8028ac:	eb 05                	jmp    8028b3 <sget+0xb2>


		}
	return (void*)NULL ;
  8028ae:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8028b3:	c9                   	leave  
  8028b4:	c3                   	ret    

008028b5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8028b5:	55                   	push   %ebp
  8028b6:	89 e5                	mov    %esp,%ebp
  8028b8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8028bb:	e8 a7 fb ff ff       	call   802467 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8028c0:	83 ec 04             	sub    $0x4,%esp
  8028c3:	68 20 4e 80 00       	push   $0x804e20
  8028c8:	68 f9 00 00 00       	push   $0xf9
  8028cd:	68 13 4e 80 00       	push   $0x804e13
  8028d2:	e8 52 eb ff ff       	call   801429 <_panic>

008028d7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8028d7:	55                   	push   %ebp
  8028d8:	89 e5                	mov    %esp,%ebp
  8028da:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8028dd:	83 ec 04             	sub    $0x4,%esp
  8028e0:	68 48 4e 80 00       	push   $0x804e48
  8028e5:	68 0d 01 00 00       	push   $0x10d
  8028ea:	68 13 4e 80 00       	push   $0x804e13
  8028ef:	e8 35 eb ff ff       	call   801429 <_panic>

008028f4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8028f4:	55                   	push   %ebp
  8028f5:	89 e5                	mov    %esp,%ebp
  8028f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8028fa:	83 ec 04             	sub    $0x4,%esp
  8028fd:	68 6c 4e 80 00       	push   $0x804e6c
  802902:	68 18 01 00 00       	push   $0x118
  802907:	68 13 4e 80 00       	push   $0x804e13
  80290c:	e8 18 eb ff ff       	call   801429 <_panic>

00802911 <shrink>:

}
void shrink(uint32 newSize)
{
  802911:	55                   	push   %ebp
  802912:	89 e5                	mov    %esp,%ebp
  802914:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802917:	83 ec 04             	sub    $0x4,%esp
  80291a:	68 6c 4e 80 00       	push   $0x804e6c
  80291f:	68 1d 01 00 00       	push   $0x11d
  802924:	68 13 4e 80 00       	push   $0x804e13
  802929:	e8 fb ea ff ff       	call   801429 <_panic>

0080292e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80292e:	55                   	push   %ebp
  80292f:	89 e5                	mov    %esp,%ebp
  802931:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802934:	83 ec 04             	sub    $0x4,%esp
  802937:	68 6c 4e 80 00       	push   $0x804e6c
  80293c:	68 22 01 00 00       	push   $0x122
  802941:	68 13 4e 80 00       	push   $0x804e13
  802946:	e8 de ea ff ff       	call   801429 <_panic>

0080294b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80294b:	55                   	push   %ebp
  80294c:	89 e5                	mov    %esp,%ebp
  80294e:	57                   	push   %edi
  80294f:	56                   	push   %esi
  802950:	53                   	push   %ebx
  802951:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80295a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80295d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802960:	8b 7d 18             	mov    0x18(%ebp),%edi
  802963:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802966:	cd 30                	int    $0x30
  802968:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80296b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80296e:	83 c4 10             	add    $0x10,%esp
  802971:	5b                   	pop    %ebx
  802972:	5e                   	pop    %esi
  802973:	5f                   	pop    %edi
  802974:	5d                   	pop    %ebp
  802975:	c3                   	ret    

00802976 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802976:	55                   	push   %ebp
  802977:	89 e5                	mov    %esp,%ebp
  802979:	83 ec 04             	sub    $0x4,%esp
  80297c:	8b 45 10             	mov    0x10(%ebp),%eax
  80297f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802982:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802986:	8b 45 08             	mov    0x8(%ebp),%eax
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	52                   	push   %edx
  80298e:	ff 75 0c             	pushl  0xc(%ebp)
  802991:	50                   	push   %eax
  802992:	6a 00                	push   $0x0
  802994:	e8 b2 ff ff ff       	call   80294b <syscall>
  802999:	83 c4 18             	add    $0x18,%esp
}
  80299c:	90                   	nop
  80299d:	c9                   	leave  
  80299e:	c3                   	ret    

0080299f <sys_cgetc>:

int
sys_cgetc(void)
{
  80299f:	55                   	push   %ebp
  8029a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8029a2:	6a 00                	push   $0x0
  8029a4:	6a 00                	push   $0x0
  8029a6:	6a 00                	push   $0x0
  8029a8:	6a 00                	push   $0x0
  8029aa:	6a 00                	push   $0x0
  8029ac:	6a 01                	push   $0x1
  8029ae:	e8 98 ff ff ff       	call   80294b <syscall>
  8029b3:	83 c4 18             	add    $0x18,%esp
}
  8029b6:	c9                   	leave  
  8029b7:	c3                   	ret    

008029b8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8029b8:	55                   	push   %ebp
  8029b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8029bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 00                	push   $0x0
  8029c7:	52                   	push   %edx
  8029c8:	50                   	push   %eax
  8029c9:	6a 05                	push   $0x5
  8029cb:	e8 7b ff ff ff       	call   80294b <syscall>
  8029d0:	83 c4 18             	add    $0x18,%esp
}
  8029d3:	c9                   	leave  
  8029d4:	c3                   	ret    

008029d5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8029d5:	55                   	push   %ebp
  8029d6:	89 e5                	mov    %esp,%ebp
  8029d8:	56                   	push   %esi
  8029d9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8029da:	8b 75 18             	mov    0x18(%ebp),%esi
  8029dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	56                   	push   %esi
  8029ea:	53                   	push   %ebx
  8029eb:	51                   	push   %ecx
  8029ec:	52                   	push   %edx
  8029ed:	50                   	push   %eax
  8029ee:	6a 06                	push   $0x6
  8029f0:	e8 56 ff ff ff       	call   80294b <syscall>
  8029f5:	83 c4 18             	add    $0x18,%esp
}
  8029f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029fb:	5b                   	pop    %ebx
  8029fc:	5e                   	pop    %esi
  8029fd:	5d                   	pop    %ebp
  8029fe:	c3                   	ret    

008029ff <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8029ff:	55                   	push   %ebp
  802a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	52                   	push   %edx
  802a0f:	50                   	push   %eax
  802a10:	6a 07                	push   $0x7
  802a12:	e8 34 ff ff ff       	call   80294b <syscall>
  802a17:	83 c4 18             	add    $0x18,%esp
}
  802a1a:	c9                   	leave  
  802a1b:	c3                   	ret    

00802a1c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a1f:	6a 00                	push   $0x0
  802a21:	6a 00                	push   $0x0
  802a23:	6a 00                	push   $0x0
  802a25:	ff 75 0c             	pushl  0xc(%ebp)
  802a28:	ff 75 08             	pushl  0x8(%ebp)
  802a2b:	6a 08                	push   $0x8
  802a2d:	e8 19 ff ff ff       	call   80294b <syscall>
  802a32:	83 c4 18             	add    $0x18,%esp
}
  802a35:	c9                   	leave  
  802a36:	c3                   	ret    

00802a37 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a37:	55                   	push   %ebp
  802a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a3a:	6a 00                	push   $0x0
  802a3c:	6a 00                	push   $0x0
  802a3e:	6a 00                	push   $0x0
  802a40:	6a 00                	push   $0x0
  802a42:	6a 00                	push   $0x0
  802a44:	6a 09                	push   $0x9
  802a46:	e8 00 ff ff ff       	call   80294b <syscall>
  802a4b:	83 c4 18             	add    $0x18,%esp
}
  802a4e:	c9                   	leave  
  802a4f:	c3                   	ret    

00802a50 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802a50:	55                   	push   %ebp
  802a51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802a53:	6a 00                	push   $0x0
  802a55:	6a 00                	push   $0x0
  802a57:	6a 00                	push   $0x0
  802a59:	6a 00                	push   $0x0
  802a5b:	6a 00                	push   $0x0
  802a5d:	6a 0a                	push   $0xa
  802a5f:	e8 e7 fe ff ff       	call   80294b <syscall>
  802a64:	83 c4 18             	add    $0x18,%esp
}
  802a67:	c9                   	leave  
  802a68:	c3                   	ret    

00802a69 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802a69:	55                   	push   %ebp
  802a6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802a6c:	6a 00                	push   $0x0
  802a6e:	6a 00                	push   $0x0
  802a70:	6a 00                	push   $0x0
  802a72:	6a 00                	push   $0x0
  802a74:	6a 00                	push   $0x0
  802a76:	6a 0b                	push   $0xb
  802a78:	e8 ce fe ff ff       	call   80294b <syscall>
  802a7d:	83 c4 18             	add    $0x18,%esp
}
  802a80:	c9                   	leave  
  802a81:	c3                   	ret    

00802a82 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802a82:	55                   	push   %ebp
  802a83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802a85:	6a 00                	push   $0x0
  802a87:	6a 00                	push   $0x0
  802a89:	6a 00                	push   $0x0
  802a8b:	ff 75 0c             	pushl  0xc(%ebp)
  802a8e:	ff 75 08             	pushl  0x8(%ebp)
  802a91:	6a 0f                	push   $0xf
  802a93:	e8 b3 fe ff ff       	call   80294b <syscall>
  802a98:	83 c4 18             	add    $0x18,%esp
	return;
  802a9b:	90                   	nop
}
  802a9c:	c9                   	leave  
  802a9d:	c3                   	ret    

00802a9e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802a9e:	55                   	push   %ebp
  802a9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802aa1:	6a 00                	push   $0x0
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 00                	push   $0x0
  802aa7:	ff 75 0c             	pushl  0xc(%ebp)
  802aaa:	ff 75 08             	pushl  0x8(%ebp)
  802aad:	6a 10                	push   $0x10
  802aaf:	e8 97 fe ff ff       	call   80294b <syscall>
  802ab4:	83 c4 18             	add    $0x18,%esp
	return ;
  802ab7:	90                   	nop
}
  802ab8:	c9                   	leave  
  802ab9:	c3                   	ret    

00802aba <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802aba:	55                   	push   %ebp
  802abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802abd:	6a 00                	push   $0x0
  802abf:	6a 00                	push   $0x0
  802ac1:	ff 75 10             	pushl  0x10(%ebp)
  802ac4:	ff 75 0c             	pushl  0xc(%ebp)
  802ac7:	ff 75 08             	pushl  0x8(%ebp)
  802aca:	6a 11                	push   $0x11
  802acc:	e8 7a fe ff ff       	call   80294b <syscall>
  802ad1:	83 c4 18             	add    $0x18,%esp
	return ;
  802ad4:	90                   	nop
}
  802ad5:	c9                   	leave  
  802ad6:	c3                   	ret    

00802ad7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802ad7:	55                   	push   %ebp
  802ad8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802ada:	6a 00                	push   $0x0
  802adc:	6a 00                	push   $0x0
  802ade:	6a 00                	push   $0x0
  802ae0:	6a 00                	push   $0x0
  802ae2:	6a 00                	push   $0x0
  802ae4:	6a 0c                	push   $0xc
  802ae6:	e8 60 fe ff ff       	call   80294b <syscall>
  802aeb:	83 c4 18             	add    $0x18,%esp
}
  802aee:	c9                   	leave  
  802aef:	c3                   	ret    

00802af0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802af0:	55                   	push   %ebp
  802af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802af3:	6a 00                	push   $0x0
  802af5:	6a 00                	push   $0x0
  802af7:	6a 00                	push   $0x0
  802af9:	6a 00                	push   $0x0
  802afb:	ff 75 08             	pushl  0x8(%ebp)
  802afe:	6a 0d                	push   $0xd
  802b00:	e8 46 fe ff ff       	call   80294b <syscall>
  802b05:	83 c4 18             	add    $0x18,%esp
}
  802b08:	c9                   	leave  
  802b09:	c3                   	ret    

00802b0a <sys_scarce_memory>:

void sys_scarce_memory()
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802b0d:	6a 00                	push   $0x0
  802b0f:	6a 00                	push   $0x0
  802b11:	6a 00                	push   $0x0
  802b13:	6a 00                	push   $0x0
  802b15:	6a 00                	push   $0x0
  802b17:	6a 0e                	push   $0xe
  802b19:	e8 2d fe ff ff       	call   80294b <syscall>
  802b1e:	83 c4 18             	add    $0x18,%esp
}
  802b21:	90                   	nop
  802b22:	c9                   	leave  
  802b23:	c3                   	ret    

00802b24 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802b24:	55                   	push   %ebp
  802b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 00                	push   $0x0
  802b2d:	6a 00                	push   $0x0
  802b2f:	6a 00                	push   $0x0
  802b31:	6a 13                	push   $0x13
  802b33:	e8 13 fe ff ff       	call   80294b <syscall>
  802b38:	83 c4 18             	add    $0x18,%esp
}
  802b3b:	90                   	nop
  802b3c:	c9                   	leave  
  802b3d:	c3                   	ret    

00802b3e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802b3e:	55                   	push   %ebp
  802b3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	6a 00                	push   $0x0
  802b4b:	6a 14                	push   $0x14
  802b4d:	e8 f9 fd ff ff       	call   80294b <syscall>
  802b52:	83 c4 18             	add    $0x18,%esp
}
  802b55:	90                   	nop
  802b56:	c9                   	leave  
  802b57:	c3                   	ret    

00802b58 <sys_cputc>:


void
sys_cputc(const char c)
{
  802b58:	55                   	push   %ebp
  802b59:	89 e5                	mov    %esp,%ebp
  802b5b:	83 ec 04             	sub    $0x4,%esp
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802b64:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b68:	6a 00                	push   $0x0
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	50                   	push   %eax
  802b71:	6a 15                	push   $0x15
  802b73:	e8 d3 fd ff ff       	call   80294b <syscall>
  802b78:	83 c4 18             	add    $0x18,%esp
}
  802b7b:	90                   	nop
  802b7c:	c9                   	leave  
  802b7d:	c3                   	ret    

00802b7e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802b7e:	55                   	push   %ebp
  802b7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802b81:	6a 00                	push   $0x0
  802b83:	6a 00                	push   $0x0
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 16                	push   $0x16
  802b8d:	e8 b9 fd ff ff       	call   80294b <syscall>
  802b92:	83 c4 18             	add    $0x18,%esp
}
  802b95:	90                   	nop
  802b96:	c9                   	leave  
  802b97:	c3                   	ret    

00802b98 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802b98:	55                   	push   %ebp
  802b99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	6a 00                	push   $0x0
  802ba0:	6a 00                	push   $0x0
  802ba2:	6a 00                	push   $0x0
  802ba4:	ff 75 0c             	pushl  0xc(%ebp)
  802ba7:	50                   	push   %eax
  802ba8:	6a 17                	push   $0x17
  802baa:	e8 9c fd ff ff       	call   80294b <syscall>
  802baf:	83 c4 18             	add    $0x18,%esp
}
  802bb2:	c9                   	leave  
  802bb3:	c3                   	ret    

00802bb4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802bb4:	55                   	push   %ebp
  802bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	6a 00                	push   $0x0
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	52                   	push   %edx
  802bc4:	50                   	push   %eax
  802bc5:	6a 1a                	push   $0x1a
  802bc7:	e8 7f fd ff ff       	call   80294b <syscall>
  802bcc:	83 c4 18             	add    $0x18,%esp
}
  802bcf:	c9                   	leave  
  802bd0:	c3                   	ret    

00802bd1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802bd1:	55                   	push   %ebp
  802bd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	6a 00                	push   $0x0
  802bdc:	6a 00                	push   $0x0
  802bde:	6a 00                	push   $0x0
  802be0:	52                   	push   %edx
  802be1:	50                   	push   %eax
  802be2:	6a 18                	push   $0x18
  802be4:	e8 62 fd ff ff       	call   80294b <syscall>
  802be9:	83 c4 18             	add    $0x18,%esp
}
  802bec:	90                   	nop
  802bed:	c9                   	leave  
  802bee:	c3                   	ret    

00802bef <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802bef:	55                   	push   %ebp
  802bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	6a 00                	push   $0x0
  802bfa:	6a 00                	push   $0x0
  802bfc:	6a 00                	push   $0x0
  802bfe:	52                   	push   %edx
  802bff:	50                   	push   %eax
  802c00:	6a 19                	push   $0x19
  802c02:	e8 44 fd ff ff       	call   80294b <syscall>
  802c07:	83 c4 18             	add    $0x18,%esp
}
  802c0a:	90                   	nop
  802c0b:	c9                   	leave  
  802c0c:	c3                   	ret    

00802c0d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802c0d:	55                   	push   %ebp
  802c0e:	89 e5                	mov    %esp,%ebp
  802c10:	83 ec 04             	sub    $0x4,%esp
  802c13:	8b 45 10             	mov    0x10(%ebp),%eax
  802c16:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802c19:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c1c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	6a 00                	push   $0x0
  802c25:	51                   	push   %ecx
  802c26:	52                   	push   %edx
  802c27:	ff 75 0c             	pushl  0xc(%ebp)
  802c2a:	50                   	push   %eax
  802c2b:	6a 1b                	push   $0x1b
  802c2d:	e8 19 fd ff ff       	call   80294b <syscall>
  802c32:	83 c4 18             	add    $0x18,%esp
}
  802c35:	c9                   	leave  
  802c36:	c3                   	ret    

00802c37 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802c37:	55                   	push   %ebp
  802c38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	6a 00                	push   $0x0
  802c42:	6a 00                	push   $0x0
  802c44:	6a 00                	push   $0x0
  802c46:	52                   	push   %edx
  802c47:	50                   	push   %eax
  802c48:	6a 1c                	push   $0x1c
  802c4a:	e8 fc fc ff ff       	call   80294b <syscall>
  802c4f:	83 c4 18             	add    $0x18,%esp
}
  802c52:	c9                   	leave  
  802c53:	c3                   	ret    

00802c54 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802c54:	55                   	push   %ebp
  802c55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802c57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	6a 00                	push   $0x0
  802c62:	6a 00                	push   $0x0
  802c64:	51                   	push   %ecx
  802c65:	52                   	push   %edx
  802c66:	50                   	push   %eax
  802c67:	6a 1d                	push   $0x1d
  802c69:	e8 dd fc ff ff       	call   80294b <syscall>
  802c6e:	83 c4 18             	add    $0x18,%esp
}
  802c71:	c9                   	leave  
  802c72:	c3                   	ret    

00802c73 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802c73:	55                   	push   %ebp
  802c74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	6a 00                	push   $0x0
  802c7e:	6a 00                	push   $0x0
  802c80:	6a 00                	push   $0x0
  802c82:	52                   	push   %edx
  802c83:	50                   	push   %eax
  802c84:	6a 1e                	push   $0x1e
  802c86:	e8 c0 fc ff ff       	call   80294b <syscall>
  802c8b:	83 c4 18             	add    $0x18,%esp
}
  802c8e:	c9                   	leave  
  802c8f:	c3                   	ret    

00802c90 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802c90:	55                   	push   %ebp
  802c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802c93:	6a 00                	push   $0x0
  802c95:	6a 00                	push   $0x0
  802c97:	6a 00                	push   $0x0
  802c99:	6a 00                	push   $0x0
  802c9b:	6a 00                	push   $0x0
  802c9d:	6a 1f                	push   $0x1f
  802c9f:	e8 a7 fc ff ff       	call   80294b <syscall>
  802ca4:	83 c4 18             	add    $0x18,%esp
}
  802ca7:	c9                   	leave  
  802ca8:	c3                   	ret    

00802ca9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802ca9:	55                   	push   %ebp
  802caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	6a 00                	push   $0x0
  802cb1:	ff 75 14             	pushl  0x14(%ebp)
  802cb4:	ff 75 10             	pushl  0x10(%ebp)
  802cb7:	ff 75 0c             	pushl  0xc(%ebp)
  802cba:	50                   	push   %eax
  802cbb:	6a 20                	push   $0x20
  802cbd:	e8 89 fc ff ff       	call   80294b <syscall>
  802cc2:	83 c4 18             	add    $0x18,%esp
}
  802cc5:	c9                   	leave  
  802cc6:	c3                   	ret    

00802cc7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802cc7:	55                   	push   %ebp
  802cc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802cca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccd:	6a 00                	push   $0x0
  802ccf:	6a 00                	push   $0x0
  802cd1:	6a 00                	push   $0x0
  802cd3:	6a 00                	push   $0x0
  802cd5:	50                   	push   %eax
  802cd6:	6a 21                	push   $0x21
  802cd8:	e8 6e fc ff ff       	call   80294b <syscall>
  802cdd:	83 c4 18             	add    $0x18,%esp
}
  802ce0:	90                   	nop
  802ce1:	c9                   	leave  
  802ce2:	c3                   	ret    

00802ce3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802ce3:	55                   	push   %ebp
  802ce4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	6a 00                	push   $0x0
  802ceb:	6a 00                	push   $0x0
  802ced:	6a 00                	push   $0x0
  802cef:	6a 00                	push   $0x0
  802cf1:	50                   	push   %eax
  802cf2:	6a 22                	push   $0x22
  802cf4:	e8 52 fc ff ff       	call   80294b <syscall>
  802cf9:	83 c4 18             	add    $0x18,%esp
}
  802cfc:	c9                   	leave  
  802cfd:	c3                   	ret    

00802cfe <sys_getenvid>:

int32 sys_getenvid(void)
{
  802cfe:	55                   	push   %ebp
  802cff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802d01:	6a 00                	push   $0x0
  802d03:	6a 00                	push   $0x0
  802d05:	6a 00                	push   $0x0
  802d07:	6a 00                	push   $0x0
  802d09:	6a 00                	push   $0x0
  802d0b:	6a 02                	push   $0x2
  802d0d:	e8 39 fc ff ff       	call   80294b <syscall>
  802d12:	83 c4 18             	add    $0x18,%esp
}
  802d15:	c9                   	leave  
  802d16:	c3                   	ret    

00802d17 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802d17:	55                   	push   %ebp
  802d18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802d1a:	6a 00                	push   $0x0
  802d1c:	6a 00                	push   $0x0
  802d1e:	6a 00                	push   $0x0
  802d20:	6a 00                	push   $0x0
  802d22:	6a 00                	push   $0x0
  802d24:	6a 03                	push   $0x3
  802d26:	e8 20 fc ff ff       	call   80294b <syscall>
  802d2b:	83 c4 18             	add    $0x18,%esp
}
  802d2e:	c9                   	leave  
  802d2f:	c3                   	ret    

00802d30 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802d30:	55                   	push   %ebp
  802d31:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802d33:	6a 00                	push   $0x0
  802d35:	6a 00                	push   $0x0
  802d37:	6a 00                	push   $0x0
  802d39:	6a 00                	push   $0x0
  802d3b:	6a 00                	push   $0x0
  802d3d:	6a 04                	push   $0x4
  802d3f:	e8 07 fc ff ff       	call   80294b <syscall>
  802d44:	83 c4 18             	add    $0x18,%esp
}
  802d47:	c9                   	leave  
  802d48:	c3                   	ret    

00802d49 <sys_exit_env>:


void sys_exit_env(void)
{
  802d49:	55                   	push   %ebp
  802d4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802d4c:	6a 00                	push   $0x0
  802d4e:	6a 00                	push   $0x0
  802d50:	6a 00                	push   $0x0
  802d52:	6a 00                	push   $0x0
  802d54:	6a 00                	push   $0x0
  802d56:	6a 23                	push   $0x23
  802d58:	e8 ee fb ff ff       	call   80294b <syscall>
  802d5d:	83 c4 18             	add    $0x18,%esp
}
  802d60:	90                   	nop
  802d61:	c9                   	leave  
  802d62:	c3                   	ret    

00802d63 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802d63:	55                   	push   %ebp
  802d64:	89 e5                	mov    %esp,%ebp
  802d66:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802d69:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802d6c:	8d 50 04             	lea    0x4(%eax),%edx
  802d6f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802d72:	6a 00                	push   $0x0
  802d74:	6a 00                	push   $0x0
  802d76:	6a 00                	push   $0x0
  802d78:	52                   	push   %edx
  802d79:	50                   	push   %eax
  802d7a:	6a 24                	push   $0x24
  802d7c:	e8 ca fb ff ff       	call   80294b <syscall>
  802d81:	83 c4 18             	add    $0x18,%esp
	return result;
  802d84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802d8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802d8d:	89 01                	mov    %eax,(%ecx)
  802d8f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	c9                   	leave  
  802d96:	c2 04 00             	ret    $0x4

00802d99 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802d99:	55                   	push   %ebp
  802d9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802d9c:	6a 00                	push   $0x0
  802d9e:	6a 00                	push   $0x0
  802da0:	ff 75 10             	pushl  0x10(%ebp)
  802da3:	ff 75 0c             	pushl  0xc(%ebp)
  802da6:	ff 75 08             	pushl  0x8(%ebp)
  802da9:	6a 12                	push   $0x12
  802dab:	e8 9b fb ff ff       	call   80294b <syscall>
  802db0:	83 c4 18             	add    $0x18,%esp
	return ;
  802db3:	90                   	nop
}
  802db4:	c9                   	leave  
  802db5:	c3                   	ret    

00802db6 <sys_rcr2>:
uint32 sys_rcr2()
{
  802db6:	55                   	push   %ebp
  802db7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802db9:	6a 00                	push   $0x0
  802dbb:	6a 00                	push   $0x0
  802dbd:	6a 00                	push   $0x0
  802dbf:	6a 00                	push   $0x0
  802dc1:	6a 00                	push   $0x0
  802dc3:	6a 25                	push   $0x25
  802dc5:	e8 81 fb ff ff       	call   80294b <syscall>
  802dca:	83 c4 18             	add    $0x18,%esp
}
  802dcd:	c9                   	leave  
  802dce:	c3                   	ret    

00802dcf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802dcf:	55                   	push   %ebp
  802dd0:	89 e5                	mov    %esp,%ebp
  802dd2:	83 ec 04             	sub    $0x4,%esp
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ddb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ddf:	6a 00                	push   $0x0
  802de1:	6a 00                	push   $0x0
  802de3:	6a 00                	push   $0x0
  802de5:	6a 00                	push   $0x0
  802de7:	50                   	push   %eax
  802de8:	6a 26                	push   $0x26
  802dea:	e8 5c fb ff ff       	call   80294b <syscall>
  802def:	83 c4 18             	add    $0x18,%esp
	return ;
  802df2:	90                   	nop
}
  802df3:	c9                   	leave  
  802df4:	c3                   	ret    

00802df5 <rsttst>:
void rsttst()
{
  802df5:	55                   	push   %ebp
  802df6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802df8:	6a 00                	push   $0x0
  802dfa:	6a 00                	push   $0x0
  802dfc:	6a 00                	push   $0x0
  802dfe:	6a 00                	push   $0x0
  802e00:	6a 00                	push   $0x0
  802e02:	6a 28                	push   $0x28
  802e04:	e8 42 fb ff ff       	call   80294b <syscall>
  802e09:	83 c4 18             	add    $0x18,%esp
	return ;
  802e0c:	90                   	nop
}
  802e0d:	c9                   	leave  
  802e0e:	c3                   	ret    

00802e0f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802e0f:	55                   	push   %ebp
  802e10:	89 e5                	mov    %esp,%ebp
  802e12:	83 ec 04             	sub    $0x4,%esp
  802e15:	8b 45 14             	mov    0x14(%ebp),%eax
  802e18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802e1b:	8b 55 18             	mov    0x18(%ebp),%edx
  802e1e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e22:	52                   	push   %edx
  802e23:	50                   	push   %eax
  802e24:	ff 75 10             	pushl  0x10(%ebp)
  802e27:	ff 75 0c             	pushl  0xc(%ebp)
  802e2a:	ff 75 08             	pushl  0x8(%ebp)
  802e2d:	6a 27                	push   $0x27
  802e2f:	e8 17 fb ff ff       	call   80294b <syscall>
  802e34:	83 c4 18             	add    $0x18,%esp
	return ;
  802e37:	90                   	nop
}
  802e38:	c9                   	leave  
  802e39:	c3                   	ret    

00802e3a <chktst>:
void chktst(uint32 n)
{
  802e3a:	55                   	push   %ebp
  802e3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802e3d:	6a 00                	push   $0x0
  802e3f:	6a 00                	push   $0x0
  802e41:	6a 00                	push   $0x0
  802e43:	6a 00                	push   $0x0
  802e45:	ff 75 08             	pushl  0x8(%ebp)
  802e48:	6a 29                	push   $0x29
  802e4a:	e8 fc fa ff ff       	call   80294b <syscall>
  802e4f:	83 c4 18             	add    $0x18,%esp
	return ;
  802e52:	90                   	nop
}
  802e53:	c9                   	leave  
  802e54:	c3                   	ret    

00802e55 <inctst>:

void inctst()
{
  802e55:	55                   	push   %ebp
  802e56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802e58:	6a 00                	push   $0x0
  802e5a:	6a 00                	push   $0x0
  802e5c:	6a 00                	push   $0x0
  802e5e:	6a 00                	push   $0x0
  802e60:	6a 00                	push   $0x0
  802e62:	6a 2a                	push   $0x2a
  802e64:	e8 e2 fa ff ff       	call   80294b <syscall>
  802e69:	83 c4 18             	add    $0x18,%esp
	return ;
  802e6c:	90                   	nop
}
  802e6d:	c9                   	leave  
  802e6e:	c3                   	ret    

00802e6f <gettst>:
uint32 gettst()
{
  802e6f:	55                   	push   %ebp
  802e70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802e72:	6a 00                	push   $0x0
  802e74:	6a 00                	push   $0x0
  802e76:	6a 00                	push   $0x0
  802e78:	6a 00                	push   $0x0
  802e7a:	6a 00                	push   $0x0
  802e7c:	6a 2b                	push   $0x2b
  802e7e:	e8 c8 fa ff ff       	call   80294b <syscall>
  802e83:	83 c4 18             	add    $0x18,%esp
}
  802e86:	c9                   	leave  
  802e87:	c3                   	ret    

00802e88 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802e88:	55                   	push   %ebp
  802e89:	89 e5                	mov    %esp,%ebp
  802e8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e8e:	6a 00                	push   $0x0
  802e90:	6a 00                	push   $0x0
  802e92:	6a 00                	push   $0x0
  802e94:	6a 00                	push   $0x0
  802e96:	6a 00                	push   $0x0
  802e98:	6a 2c                	push   $0x2c
  802e9a:	e8 ac fa ff ff       	call   80294b <syscall>
  802e9f:	83 c4 18             	add    $0x18,%esp
  802ea2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802ea5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802ea9:	75 07                	jne    802eb2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802eab:	b8 01 00 00 00       	mov    $0x1,%eax
  802eb0:	eb 05                	jmp    802eb7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eb7:	c9                   	leave  
  802eb8:	c3                   	ret    

00802eb9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802eb9:	55                   	push   %ebp
  802eba:	89 e5                	mov    %esp,%ebp
  802ebc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ebf:	6a 00                	push   $0x0
  802ec1:	6a 00                	push   $0x0
  802ec3:	6a 00                	push   $0x0
  802ec5:	6a 00                	push   $0x0
  802ec7:	6a 00                	push   $0x0
  802ec9:	6a 2c                	push   $0x2c
  802ecb:	e8 7b fa ff ff       	call   80294b <syscall>
  802ed0:	83 c4 18             	add    $0x18,%esp
  802ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802ed6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802eda:	75 07                	jne    802ee3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802edc:	b8 01 00 00 00       	mov    $0x1,%eax
  802ee1:	eb 05                	jmp    802ee8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802ee3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ee8:	c9                   	leave  
  802ee9:	c3                   	ret    

00802eea <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802eea:	55                   	push   %ebp
  802eeb:	89 e5                	mov    %esp,%ebp
  802eed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ef0:	6a 00                	push   $0x0
  802ef2:	6a 00                	push   $0x0
  802ef4:	6a 00                	push   $0x0
  802ef6:	6a 00                	push   $0x0
  802ef8:	6a 00                	push   $0x0
  802efa:	6a 2c                	push   $0x2c
  802efc:	e8 4a fa ff ff       	call   80294b <syscall>
  802f01:	83 c4 18             	add    $0x18,%esp
  802f04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802f07:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802f0b:	75 07                	jne    802f14 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802f0d:	b8 01 00 00 00       	mov    $0x1,%eax
  802f12:	eb 05                	jmp    802f19 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f19:	c9                   	leave  
  802f1a:	c3                   	ret    

00802f1b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802f1b:	55                   	push   %ebp
  802f1c:	89 e5                	mov    %esp,%ebp
  802f1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f21:	6a 00                	push   $0x0
  802f23:	6a 00                	push   $0x0
  802f25:	6a 00                	push   $0x0
  802f27:	6a 00                	push   $0x0
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 2c                	push   $0x2c
  802f2d:	e8 19 fa ff ff       	call   80294b <syscall>
  802f32:	83 c4 18             	add    $0x18,%esp
  802f35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802f38:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802f3c:	75 07                	jne    802f45 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802f3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802f43:	eb 05                	jmp    802f4a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802f45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f4a:	c9                   	leave  
  802f4b:	c3                   	ret    

00802f4c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802f4c:	55                   	push   %ebp
  802f4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802f4f:	6a 00                	push   $0x0
  802f51:	6a 00                	push   $0x0
  802f53:	6a 00                	push   $0x0
  802f55:	6a 00                	push   $0x0
  802f57:	ff 75 08             	pushl  0x8(%ebp)
  802f5a:	6a 2d                	push   $0x2d
  802f5c:	e8 ea f9 ff ff       	call   80294b <syscall>
  802f61:	83 c4 18             	add    $0x18,%esp
	return ;
  802f64:	90                   	nop
}
  802f65:	c9                   	leave  
  802f66:	c3                   	ret    

00802f67 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802f67:	55                   	push   %ebp
  802f68:	89 e5                	mov    %esp,%ebp
  802f6a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802f6b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f71:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	6a 00                	push   $0x0
  802f79:	53                   	push   %ebx
  802f7a:	51                   	push   %ecx
  802f7b:	52                   	push   %edx
  802f7c:	50                   	push   %eax
  802f7d:	6a 2e                	push   $0x2e
  802f7f:	e8 c7 f9 ff ff       	call   80294b <syscall>
  802f84:	83 c4 18             	add    $0x18,%esp
}
  802f87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f8a:	c9                   	leave  
  802f8b:	c3                   	ret    

00802f8c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802f8c:	55                   	push   %ebp
  802f8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	6a 00                	push   $0x0
  802f97:	6a 00                	push   $0x0
  802f99:	6a 00                	push   $0x0
  802f9b:	52                   	push   %edx
  802f9c:	50                   	push   %eax
  802f9d:	6a 2f                	push   $0x2f
  802f9f:	e8 a7 f9 ff ff       	call   80294b <syscall>
  802fa4:	83 c4 18             	add    $0x18,%esp
}
  802fa7:	c9                   	leave  
  802fa8:	c3                   	ret    

00802fa9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802fa9:	55                   	push   %ebp
  802faa:	89 e5                	mov    %esp,%ebp
  802fac:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802faf:	83 ec 0c             	sub    $0xc,%esp
  802fb2:	68 7c 4e 80 00       	push   $0x804e7c
  802fb7:	e8 21 e7 ff ff       	call   8016dd <cprintf>
  802fbc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802fbf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802fc6:	83 ec 0c             	sub    $0xc,%esp
  802fc9:	68 a8 4e 80 00       	push   $0x804ea8
  802fce:	e8 0a e7 ff ff       	call   8016dd <cprintf>
  802fd3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802fd6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802fda:	a1 38 61 80 00       	mov    0x806138,%eax
  802fdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe2:	eb 56                	jmp    80303a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802fe4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fe8:	74 1c                	je     803006 <print_mem_block_lists+0x5d>
  802fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fed:	8b 50 08             	mov    0x8(%eax),%edx
  802ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff3:	8b 48 08             	mov    0x8(%eax),%ecx
  802ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffc:	01 c8                	add    %ecx,%eax
  802ffe:	39 c2                	cmp    %eax,%edx
  803000:	73 04                	jae    803006 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  803002:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 50 08             	mov    0x8(%eax),%edx
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	8b 40 0c             	mov    0xc(%eax),%eax
  803012:	01 c2                	add    %eax,%edx
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	8b 40 08             	mov    0x8(%eax),%eax
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	52                   	push   %edx
  80301e:	50                   	push   %eax
  80301f:	68 bd 4e 80 00       	push   $0x804ebd
  803024:	e8 b4 e6 ff ff       	call   8016dd <cprintf>
  803029:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803032:	a1 40 61 80 00       	mov    0x806140,%eax
  803037:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80303a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303e:	74 07                	je     803047 <print_mem_block_lists+0x9e>
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	eb 05                	jmp    80304c <print_mem_block_lists+0xa3>
  803047:	b8 00 00 00 00       	mov    $0x0,%eax
  80304c:	a3 40 61 80 00       	mov    %eax,0x806140
  803051:	a1 40 61 80 00       	mov    0x806140,%eax
  803056:	85 c0                	test   %eax,%eax
  803058:	75 8a                	jne    802fe4 <print_mem_block_lists+0x3b>
  80305a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305e:	75 84                	jne    802fe4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  803060:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803064:	75 10                	jne    803076 <print_mem_block_lists+0xcd>
  803066:	83 ec 0c             	sub    $0xc,%esp
  803069:	68 cc 4e 80 00       	push   $0x804ecc
  80306e:	e8 6a e6 ff ff       	call   8016dd <cprintf>
  803073:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  803076:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80307d:	83 ec 0c             	sub    $0xc,%esp
  803080:	68 f0 4e 80 00       	push   $0x804ef0
  803085:	e8 53 e6 ff ff       	call   8016dd <cprintf>
  80308a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80308d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803091:	a1 40 60 80 00       	mov    0x806040,%eax
  803096:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803099:	eb 56                	jmp    8030f1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80309b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80309f:	74 1c                	je     8030bd <print_mem_block_lists+0x114>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 50 08             	mov    0x8(%eax),%edx
  8030a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030aa:	8b 48 08             	mov    0x8(%eax),%ecx
  8030ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b3:	01 c8                	add    %ecx,%eax
  8030b5:	39 c2                	cmp    %eax,%edx
  8030b7:	73 04                	jae    8030bd <print_mem_block_lists+0x114>
			sorted = 0 ;
  8030b9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	8b 50 08             	mov    0x8(%eax),%edx
  8030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c9:	01 c2                	add    %eax,%edx
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	8b 40 08             	mov    0x8(%eax),%eax
  8030d1:	83 ec 04             	sub    $0x4,%esp
  8030d4:	52                   	push   %edx
  8030d5:	50                   	push   %eax
  8030d6:	68 bd 4e 80 00       	push   $0x804ebd
  8030db:	e8 fd e5 ff ff       	call   8016dd <cprintf>
  8030e0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8030e9:	a1 48 60 80 00       	mov    0x806048,%eax
  8030ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f5:	74 07                	je     8030fe <print_mem_block_lists+0x155>
  8030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	eb 05                	jmp    803103 <print_mem_block_lists+0x15a>
  8030fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803103:	a3 48 60 80 00       	mov    %eax,0x806048
  803108:	a1 48 60 80 00       	mov    0x806048,%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	75 8a                	jne    80309b <print_mem_block_lists+0xf2>
  803111:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803115:	75 84                	jne    80309b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803117:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80311b:	75 10                	jne    80312d <print_mem_block_lists+0x184>
  80311d:	83 ec 0c             	sub    $0xc,%esp
  803120:	68 08 4f 80 00       	push   $0x804f08
  803125:	e8 b3 e5 ff ff       	call   8016dd <cprintf>
  80312a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80312d:	83 ec 0c             	sub    $0xc,%esp
  803130:	68 7c 4e 80 00       	push   $0x804e7c
  803135:	e8 a3 e5 ff ff       	call   8016dd <cprintf>
  80313a:	83 c4 10             	add    $0x10,%esp

}
  80313d:	90                   	nop
  80313e:	c9                   	leave  
  80313f:	c3                   	ret    

00803140 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  803140:	55                   	push   %ebp
  803141:	89 e5                	mov    %esp,%ebp
  803143:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  803146:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  80314d:	00 00 00 
  803150:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  803157:	00 00 00 
  80315a:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  803161:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  803164:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80316b:	e9 9e 00 00 00       	jmp    80320e <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  803170:	a1 50 60 80 00       	mov    0x806050,%eax
  803175:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803178:	c1 e2 04             	shl    $0x4,%edx
  80317b:	01 d0                	add    %edx,%eax
  80317d:	85 c0                	test   %eax,%eax
  80317f:	75 14                	jne    803195 <initialize_MemBlocksList+0x55>
  803181:	83 ec 04             	sub    $0x4,%esp
  803184:	68 30 4f 80 00       	push   $0x804f30
  803189:	6a 43                	push   $0x43
  80318b:	68 53 4f 80 00       	push   $0x804f53
  803190:	e8 94 e2 ff ff       	call   801429 <_panic>
  803195:	a1 50 60 80 00       	mov    0x806050,%eax
  80319a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80319d:	c1 e2 04             	shl    $0x4,%edx
  8031a0:	01 d0                	add    %edx,%eax
  8031a2:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8031a8:	89 10                	mov    %edx,(%eax)
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	85 c0                	test   %eax,%eax
  8031ae:	74 18                	je     8031c8 <initialize_MemBlocksList+0x88>
  8031b0:	a1 48 61 80 00       	mov    0x806148,%eax
  8031b5:	8b 15 50 60 80 00    	mov    0x806050,%edx
  8031bb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8031be:	c1 e1 04             	shl    $0x4,%ecx
  8031c1:	01 ca                	add    %ecx,%edx
  8031c3:	89 50 04             	mov    %edx,0x4(%eax)
  8031c6:	eb 12                	jmp    8031da <initialize_MemBlocksList+0x9a>
  8031c8:	a1 50 60 80 00       	mov    0x806050,%eax
  8031cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031d0:	c1 e2 04             	shl    $0x4,%edx
  8031d3:	01 d0                	add    %edx,%eax
  8031d5:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8031da:	a1 50 60 80 00       	mov    0x806050,%eax
  8031df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031e2:	c1 e2 04             	shl    $0x4,%edx
  8031e5:	01 d0                	add    %edx,%eax
  8031e7:	a3 48 61 80 00       	mov    %eax,0x806148
  8031ec:	a1 50 60 80 00       	mov    0x806050,%eax
  8031f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f4:	c1 e2 04             	shl    $0x4,%edx
  8031f7:	01 d0                	add    %edx,%eax
  8031f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803200:	a1 54 61 80 00       	mov    0x806154,%eax
  803205:	40                   	inc    %eax
  803206:	a3 54 61 80 00       	mov    %eax,0x806154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80320b:	ff 45 f4             	incl   -0xc(%ebp)
  80320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803211:	3b 45 08             	cmp    0x8(%ebp),%eax
  803214:	0f 82 56 ff ff ff    	jb     803170 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80321a:	90                   	nop
  80321b:	c9                   	leave  
  80321c:	c3                   	ret    

0080321d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80321d:	55                   	push   %ebp
  80321e:	89 e5                	mov    %esp,%ebp
  803220:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  803223:	a1 38 61 80 00       	mov    0x806138,%eax
  803228:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80322b:	eb 18                	jmp    803245 <find_block+0x28>
	{
		if (ele->sva==va)
  80322d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803230:	8b 40 08             	mov    0x8(%eax),%eax
  803233:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803236:	75 05                	jne    80323d <find_block+0x20>
			return ele;
  803238:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80323b:	eb 7b                	jmp    8032b8 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80323d:	a1 40 61 80 00       	mov    0x806140,%eax
  803242:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803245:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803249:	74 07                	je     803252 <find_block+0x35>
  80324b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80324e:	8b 00                	mov    (%eax),%eax
  803250:	eb 05                	jmp    803257 <find_block+0x3a>
  803252:	b8 00 00 00 00       	mov    $0x0,%eax
  803257:	a3 40 61 80 00       	mov    %eax,0x806140
  80325c:	a1 40 61 80 00       	mov    0x806140,%eax
  803261:	85 c0                	test   %eax,%eax
  803263:	75 c8                	jne    80322d <find_block+0x10>
  803265:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803269:	75 c2                	jne    80322d <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80326b:	a1 40 60 80 00       	mov    0x806040,%eax
  803270:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803273:	eb 18                	jmp    80328d <find_block+0x70>
	{
		if (ele->sva==va)
  803275:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803278:	8b 40 08             	mov    0x8(%eax),%eax
  80327b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80327e:	75 05                	jne    803285 <find_block+0x68>
					return ele;
  803280:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803283:	eb 33                	jmp    8032b8 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  803285:	a1 48 60 80 00       	mov    0x806048,%eax
  80328a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80328d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803291:	74 07                	je     80329a <find_block+0x7d>
  803293:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803296:	8b 00                	mov    (%eax),%eax
  803298:	eb 05                	jmp    80329f <find_block+0x82>
  80329a:	b8 00 00 00 00       	mov    $0x0,%eax
  80329f:	a3 48 60 80 00       	mov    %eax,0x806048
  8032a4:	a1 48 60 80 00       	mov    0x806048,%eax
  8032a9:	85 c0                	test   %eax,%eax
  8032ab:	75 c8                	jne    803275 <find_block+0x58>
  8032ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8032b1:	75 c2                	jne    803275 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8032b3:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8032b8:	c9                   	leave  
  8032b9:	c3                   	ret    

008032ba <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8032ba:	55                   	push   %ebp
  8032bb:	89 e5                	mov    %esp,%ebp
  8032bd:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  8032c0:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8032c5:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8032c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032cc:	75 62                	jne    803330 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8032ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d2:	75 14                	jne    8032e8 <insert_sorted_allocList+0x2e>
  8032d4:	83 ec 04             	sub    $0x4,%esp
  8032d7:	68 30 4f 80 00       	push   $0x804f30
  8032dc:	6a 69                	push   $0x69
  8032de:	68 53 4f 80 00       	push   $0x804f53
  8032e3:	e8 41 e1 ff ff       	call   801429 <_panic>
  8032e8:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	89 10                	mov    %edx,(%eax)
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	8b 00                	mov    (%eax),%eax
  8032f8:	85 c0                	test   %eax,%eax
  8032fa:	74 0d                	je     803309 <insert_sorted_allocList+0x4f>
  8032fc:	a1 40 60 80 00       	mov    0x806040,%eax
  803301:	8b 55 08             	mov    0x8(%ebp),%edx
  803304:	89 50 04             	mov    %edx,0x4(%eax)
  803307:	eb 08                	jmp    803311 <insert_sorted_allocList+0x57>
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	a3 44 60 80 00       	mov    %eax,0x806044
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	a3 40 60 80 00       	mov    %eax,0x806040
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803323:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803328:	40                   	inc    %eax
  803329:	a3 4c 60 80 00       	mov    %eax,0x80604c
  80332e:	eb 72                	jmp    8033a2 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  803330:	a1 40 60 80 00       	mov    0x806040,%eax
  803335:	8b 50 08             	mov    0x8(%eax),%edx
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	8b 40 08             	mov    0x8(%eax),%eax
  80333e:	39 c2                	cmp    %eax,%edx
  803340:	76 60                	jbe    8033a2 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  803342:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803346:	75 14                	jne    80335c <insert_sorted_allocList+0xa2>
  803348:	83 ec 04             	sub    $0x4,%esp
  80334b:	68 30 4f 80 00       	push   $0x804f30
  803350:	6a 6d                	push   $0x6d
  803352:	68 53 4f 80 00       	push   $0x804f53
  803357:	e8 cd e0 ff ff       	call   801429 <_panic>
  80335c:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	89 10                	mov    %edx,(%eax)
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	8b 00                	mov    (%eax),%eax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	74 0d                	je     80337d <insert_sorted_allocList+0xc3>
  803370:	a1 40 60 80 00       	mov    0x806040,%eax
  803375:	8b 55 08             	mov    0x8(%ebp),%edx
  803378:	89 50 04             	mov    %edx,0x4(%eax)
  80337b:	eb 08                	jmp    803385 <insert_sorted_allocList+0xcb>
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	a3 44 60 80 00       	mov    %eax,0x806044
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	a3 40 60 80 00       	mov    %eax,0x806040
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803397:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80339c:	40                   	inc    %eax
  80339d:	a3 4c 60 80 00       	mov    %eax,0x80604c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8033a2:	a1 40 60 80 00       	mov    0x806040,%eax
  8033a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033aa:	e9 b9 01 00 00       	jmp    803568 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	8b 50 08             	mov    0x8(%eax),%edx
  8033b5:	a1 40 60 80 00       	mov    0x806040,%eax
  8033ba:	8b 40 08             	mov    0x8(%eax),%eax
  8033bd:	39 c2                	cmp    %eax,%edx
  8033bf:	76 7c                	jbe    80343d <insert_sorted_allocList+0x183>
  8033c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c4:	8b 50 08             	mov    0x8(%eax),%edx
  8033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ca:	8b 40 08             	mov    0x8(%eax),%eax
  8033cd:	39 c2                	cmp    %eax,%edx
  8033cf:	73 6c                	jae    80343d <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  8033d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d5:	74 06                	je     8033dd <insert_sorted_allocList+0x123>
  8033d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033db:	75 14                	jne    8033f1 <insert_sorted_allocList+0x137>
  8033dd:	83 ec 04             	sub    $0x4,%esp
  8033e0:	68 6c 4f 80 00       	push   $0x804f6c
  8033e5:	6a 75                	push   $0x75
  8033e7:	68 53 4f 80 00       	push   $0x804f53
  8033ec:	e8 38 e0 ff ff       	call   801429 <_panic>
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	8b 50 04             	mov    0x4(%eax),%edx
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	89 50 04             	mov    %edx,0x4(%eax)
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803403:	89 10                	mov    %edx,(%eax)
  803405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803408:	8b 40 04             	mov    0x4(%eax),%eax
  80340b:	85 c0                	test   %eax,%eax
  80340d:	74 0d                	je     80341c <insert_sorted_allocList+0x162>
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	8b 40 04             	mov    0x4(%eax),%eax
  803415:	8b 55 08             	mov    0x8(%ebp),%edx
  803418:	89 10                	mov    %edx,(%eax)
  80341a:	eb 08                	jmp    803424 <insert_sorted_allocList+0x16a>
  80341c:	8b 45 08             	mov    0x8(%ebp),%eax
  80341f:	a3 40 60 80 00       	mov    %eax,0x806040
  803424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803427:	8b 55 08             	mov    0x8(%ebp),%edx
  80342a:	89 50 04             	mov    %edx,0x4(%eax)
  80342d:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803432:	40                   	inc    %eax
  803433:	a3 4c 60 80 00       	mov    %eax,0x80604c

		break;}
  803438:	e9 59 01 00 00       	jmp    803596 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	8b 50 08             	mov    0x8(%eax),%edx
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	8b 40 08             	mov    0x8(%eax),%eax
  803449:	39 c2                	cmp    %eax,%edx
  80344b:	0f 86 98 00 00 00    	jbe    8034e9 <insert_sorted_allocList+0x22f>
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	8b 50 08             	mov    0x8(%eax),%edx
  803457:	a1 44 60 80 00       	mov    0x806044,%eax
  80345c:	8b 40 08             	mov    0x8(%eax),%eax
  80345f:	39 c2                	cmp    %eax,%edx
  803461:	0f 83 82 00 00 00    	jae    8034e9 <insert_sorted_allocList+0x22f>
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	8b 50 08             	mov    0x8(%eax),%edx
  80346d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803470:	8b 00                	mov    (%eax),%eax
  803472:	8b 40 08             	mov    0x8(%eax),%eax
  803475:	39 c2                	cmp    %eax,%edx
  803477:	73 70                	jae    8034e9 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  803479:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80347d:	74 06                	je     803485 <insert_sorted_allocList+0x1cb>
  80347f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803483:	75 14                	jne    803499 <insert_sorted_allocList+0x1df>
  803485:	83 ec 04             	sub    $0x4,%esp
  803488:	68 a4 4f 80 00       	push   $0x804fa4
  80348d:	6a 7c                	push   $0x7c
  80348f:	68 53 4f 80 00       	push   $0x804f53
  803494:	e8 90 df ff ff       	call   801429 <_panic>
  803499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349c:	8b 10                	mov    (%eax),%edx
  80349e:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a1:	89 10                	mov    %edx,(%eax)
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	8b 00                	mov    (%eax),%eax
  8034a8:	85 c0                	test   %eax,%eax
  8034aa:	74 0b                	je     8034b7 <insert_sorted_allocList+0x1fd>
  8034ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b4:	89 50 04             	mov    %edx,0x4(%eax)
  8034b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8034bd:	89 10                	mov    %edx,(%eax)
  8034bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c5:	89 50 04             	mov    %edx,0x4(%eax)
  8034c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cb:	8b 00                	mov    (%eax),%eax
  8034cd:	85 c0                	test   %eax,%eax
  8034cf:	75 08                	jne    8034d9 <insert_sorted_allocList+0x21f>
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	a3 44 60 80 00       	mov    %eax,0x806044
  8034d9:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8034de:	40                   	inc    %eax
  8034df:	a3 4c 60 80 00       	mov    %eax,0x80604c
		break;
  8034e4:	e9 ad 00 00 00       	jmp    803596 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	8b 50 08             	mov    0x8(%eax),%edx
  8034ef:	a1 44 60 80 00       	mov    0x806044,%eax
  8034f4:	8b 40 08             	mov    0x8(%eax),%eax
  8034f7:	39 c2                	cmp    %eax,%edx
  8034f9:	76 65                	jbe    803560 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8034fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ff:	75 17                	jne    803518 <insert_sorted_allocList+0x25e>
  803501:	83 ec 04             	sub    $0x4,%esp
  803504:	68 d8 4f 80 00       	push   $0x804fd8
  803509:	68 80 00 00 00       	push   $0x80
  80350e:	68 53 4f 80 00       	push   $0x804f53
  803513:	e8 11 df ff ff       	call   801429 <_panic>
  803518:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	89 50 04             	mov    %edx,0x4(%eax)
  803524:	8b 45 08             	mov    0x8(%ebp),%eax
  803527:	8b 40 04             	mov    0x4(%eax),%eax
  80352a:	85 c0                	test   %eax,%eax
  80352c:	74 0c                	je     80353a <insert_sorted_allocList+0x280>
  80352e:	a1 44 60 80 00       	mov    0x806044,%eax
  803533:	8b 55 08             	mov    0x8(%ebp),%edx
  803536:	89 10                	mov    %edx,(%eax)
  803538:	eb 08                	jmp    803542 <insert_sorted_allocList+0x288>
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	a3 40 60 80 00       	mov    %eax,0x806040
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	a3 44 60 80 00       	mov    %eax,0x806044
  80354a:	8b 45 08             	mov    0x8(%ebp),%eax
  80354d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803553:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803558:	40                   	inc    %eax
  803559:	a3 4c 60 80 00       	mov    %eax,0x80604c
		break;
  80355e:	eb 36                	jmp    803596 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  803560:	a1 48 60 80 00       	mov    0x806048,%eax
  803565:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80356c:	74 07                	je     803575 <insert_sorted_allocList+0x2bb>
  80356e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803571:	8b 00                	mov    (%eax),%eax
  803573:	eb 05                	jmp    80357a <insert_sorted_allocList+0x2c0>
  803575:	b8 00 00 00 00       	mov    $0x0,%eax
  80357a:	a3 48 60 80 00       	mov    %eax,0x806048
  80357f:	a1 48 60 80 00       	mov    0x806048,%eax
  803584:	85 c0                	test   %eax,%eax
  803586:	0f 85 23 fe ff ff    	jne    8033af <insert_sorted_allocList+0xf5>
  80358c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803590:	0f 85 19 fe ff ff    	jne    8033af <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  803596:	90                   	nop
  803597:	c9                   	leave  
  803598:	c3                   	ret    

00803599 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803599:	55                   	push   %ebp
  80359a:	89 e5                	mov    %esp,%ebp
  80359c:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80359f:	a1 38 61 80 00       	mov    0x806138,%eax
  8035a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035a7:	e9 7c 01 00 00       	jmp    803728 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  8035ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035af:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035b5:	0f 85 90 00 00 00    	jne    80364b <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  8035bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035be:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  8035c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c5:	75 17                	jne    8035de <alloc_block_FF+0x45>
  8035c7:	83 ec 04             	sub    $0x4,%esp
  8035ca:	68 fb 4f 80 00       	push   $0x804ffb
  8035cf:	68 ba 00 00 00       	push   $0xba
  8035d4:	68 53 4f 80 00       	push   $0x804f53
  8035d9:	e8 4b de ff ff       	call   801429 <_panic>
  8035de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e1:	8b 00                	mov    (%eax),%eax
  8035e3:	85 c0                	test   %eax,%eax
  8035e5:	74 10                	je     8035f7 <alloc_block_FF+0x5e>
  8035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ea:	8b 00                	mov    (%eax),%eax
  8035ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ef:	8b 52 04             	mov    0x4(%edx),%edx
  8035f2:	89 50 04             	mov    %edx,0x4(%eax)
  8035f5:	eb 0b                	jmp    803602 <alloc_block_FF+0x69>
  8035f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fa:	8b 40 04             	mov    0x4(%eax),%eax
  8035fd:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803605:	8b 40 04             	mov    0x4(%eax),%eax
  803608:	85 c0                	test   %eax,%eax
  80360a:	74 0f                	je     80361b <alloc_block_FF+0x82>
  80360c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360f:	8b 40 04             	mov    0x4(%eax),%eax
  803612:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803615:	8b 12                	mov    (%edx),%edx
  803617:	89 10                	mov    %edx,(%eax)
  803619:	eb 0a                	jmp    803625 <alloc_block_FF+0x8c>
  80361b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361e:	8b 00                	mov    (%eax),%eax
  803620:	a3 38 61 80 00       	mov    %eax,0x806138
  803625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803628:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803631:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803638:	a1 44 61 80 00       	mov    0x806144,%eax
  80363d:	48                   	dec    %eax
  80363e:	a3 44 61 80 00       	mov    %eax,0x806144
					return tmp_block;
  803643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803646:	e9 10 01 00 00       	jmp    80375b <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  80364b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364e:	8b 40 0c             	mov    0xc(%eax),%eax
  803651:	3b 45 08             	cmp    0x8(%ebp),%eax
  803654:	0f 86 c6 00 00 00    	jbe    803720 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  80365a:	a1 48 61 80 00       	mov    0x806148,%eax
  80365f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  803662:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803666:	75 17                	jne    80367f <alloc_block_FF+0xe6>
  803668:	83 ec 04             	sub    $0x4,%esp
  80366b:	68 fb 4f 80 00       	push   $0x804ffb
  803670:	68 c2 00 00 00       	push   $0xc2
  803675:	68 53 4f 80 00       	push   $0x804f53
  80367a:	e8 aa dd ff ff       	call   801429 <_panic>
  80367f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803682:	8b 00                	mov    (%eax),%eax
  803684:	85 c0                	test   %eax,%eax
  803686:	74 10                	je     803698 <alloc_block_FF+0xff>
  803688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80368b:	8b 00                	mov    (%eax),%eax
  80368d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803690:	8b 52 04             	mov    0x4(%edx),%edx
  803693:	89 50 04             	mov    %edx,0x4(%eax)
  803696:	eb 0b                	jmp    8036a3 <alloc_block_FF+0x10a>
  803698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369b:	8b 40 04             	mov    0x4(%eax),%eax
  80369e:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8036a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a6:	8b 40 04             	mov    0x4(%eax),%eax
  8036a9:	85 c0                	test   %eax,%eax
  8036ab:	74 0f                	je     8036bc <alloc_block_FF+0x123>
  8036ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b0:	8b 40 04             	mov    0x4(%eax),%eax
  8036b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036b6:	8b 12                	mov    (%edx),%edx
  8036b8:	89 10                	mov    %edx,(%eax)
  8036ba:	eb 0a                	jmp    8036c6 <alloc_block_FF+0x12d>
  8036bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036bf:	8b 00                	mov    (%eax),%eax
  8036c1:	a3 48 61 80 00       	mov    %eax,0x806148
  8036c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d9:	a1 54 61 80 00       	mov    0x806154,%eax
  8036de:	48                   	dec    %eax
  8036df:	a3 54 61 80 00       	mov    %eax,0x806154
					tmp_block->sva=element->sva;
  8036e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e7:	8b 50 08             	mov    0x8(%eax),%edx
  8036ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ed:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  8036f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f6:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  8036f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ff:	2b 45 08             	sub    0x8(%ebp),%eax
  803702:	89 c2                	mov    %eax,%edx
  803704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803707:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  80370a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370d:	8b 50 08             	mov    0x8(%eax),%edx
  803710:	8b 45 08             	mov    0x8(%ebp),%eax
  803713:	01 c2                	add    %eax,%edx
  803715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803718:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  80371b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80371e:	eb 3b                	jmp    80375b <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803720:	a1 40 61 80 00       	mov    0x806140,%eax
  803725:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803728:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80372c:	74 07                	je     803735 <alloc_block_FF+0x19c>
  80372e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803731:	8b 00                	mov    (%eax),%eax
  803733:	eb 05                	jmp    80373a <alloc_block_FF+0x1a1>
  803735:	b8 00 00 00 00       	mov    $0x0,%eax
  80373a:	a3 40 61 80 00       	mov    %eax,0x806140
  80373f:	a1 40 61 80 00       	mov    0x806140,%eax
  803744:	85 c0                	test   %eax,%eax
  803746:	0f 85 60 fe ff ff    	jne    8035ac <alloc_block_FF+0x13>
  80374c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803750:	0f 85 56 fe ff ff    	jne    8035ac <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  803756:	b8 00 00 00 00       	mov    $0x0,%eax
  80375b:	c9                   	leave  
  80375c:	c3                   	ret    

0080375d <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  80375d:	55                   	push   %ebp
  80375e:	89 e5                	mov    %esp,%ebp
  803760:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  803763:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80376a:	a1 38 61 80 00       	mov    0x806138,%eax
  80376f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803772:	eb 3a                	jmp    8037ae <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  803774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803777:	8b 40 0c             	mov    0xc(%eax),%eax
  80377a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80377d:	72 27                	jb     8037a6 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  80377f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803783:	75 0b                	jne    803790 <alloc_block_BF+0x33>
					best_size= element->size;
  803785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803788:	8b 40 0c             	mov    0xc(%eax),%eax
  80378b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80378e:	eb 16                	jmp    8037a6 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  803790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803793:	8b 50 0c             	mov    0xc(%eax),%edx
  803796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803799:	39 c2                	cmp    %eax,%edx
  80379b:	77 09                	ja     8037a6 <alloc_block_BF+0x49>
					best_size=element->size;
  80379d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a3:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8037a6:	a1 40 61 80 00       	mov    0x806140,%eax
  8037ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b2:	74 07                	je     8037bb <alloc_block_BF+0x5e>
  8037b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b7:	8b 00                	mov    (%eax),%eax
  8037b9:	eb 05                	jmp    8037c0 <alloc_block_BF+0x63>
  8037bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c0:	a3 40 61 80 00       	mov    %eax,0x806140
  8037c5:	a1 40 61 80 00       	mov    0x806140,%eax
  8037ca:	85 c0                	test   %eax,%eax
  8037cc:	75 a6                	jne    803774 <alloc_block_BF+0x17>
  8037ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d2:	75 a0                	jne    803774 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  8037d4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8037d8:	0f 84 d3 01 00 00    	je     8039b1 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8037de:	a1 38 61 80 00       	mov    0x806138,%eax
  8037e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037e6:	e9 98 01 00 00       	jmp    803983 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  8037eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037f1:	0f 86 da 00 00 00    	jbe    8038d1 <alloc_block_BF+0x174>
  8037f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fa:	8b 50 0c             	mov    0xc(%eax),%edx
  8037fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803800:	39 c2                	cmp    %eax,%edx
  803802:	0f 85 c9 00 00 00    	jne    8038d1 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  803808:	a1 48 61 80 00       	mov    0x806148,%eax
  80380d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  803810:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803814:	75 17                	jne    80382d <alloc_block_BF+0xd0>
  803816:	83 ec 04             	sub    $0x4,%esp
  803819:	68 fb 4f 80 00       	push   $0x804ffb
  80381e:	68 ea 00 00 00       	push   $0xea
  803823:	68 53 4f 80 00       	push   $0x804f53
  803828:	e8 fc db ff ff       	call   801429 <_panic>
  80382d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803830:	8b 00                	mov    (%eax),%eax
  803832:	85 c0                	test   %eax,%eax
  803834:	74 10                	je     803846 <alloc_block_BF+0xe9>
  803836:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803839:	8b 00                	mov    (%eax),%eax
  80383b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80383e:	8b 52 04             	mov    0x4(%edx),%edx
  803841:	89 50 04             	mov    %edx,0x4(%eax)
  803844:	eb 0b                	jmp    803851 <alloc_block_BF+0xf4>
  803846:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803849:	8b 40 04             	mov    0x4(%eax),%eax
  80384c:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803851:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803854:	8b 40 04             	mov    0x4(%eax),%eax
  803857:	85 c0                	test   %eax,%eax
  803859:	74 0f                	je     80386a <alloc_block_BF+0x10d>
  80385b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385e:	8b 40 04             	mov    0x4(%eax),%eax
  803861:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803864:	8b 12                	mov    (%edx),%edx
  803866:	89 10                	mov    %edx,(%eax)
  803868:	eb 0a                	jmp    803874 <alloc_block_BF+0x117>
  80386a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80386d:	8b 00                	mov    (%eax),%eax
  80386f:	a3 48 61 80 00       	mov    %eax,0x806148
  803874:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803877:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80387d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803880:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803887:	a1 54 61 80 00       	mov    0x806154,%eax
  80388c:	48                   	dec    %eax
  80388d:	a3 54 61 80 00       	mov    %eax,0x806154
				tmp_block->sva=element->sva;
  803892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803895:	8b 50 08             	mov    0x8(%eax),%edx
  803898:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80389b:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80389e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8038a4:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8038a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8038ad:	2b 45 08             	sub    0x8(%ebp),%eax
  8038b0:	89 c2                	mov    %eax,%edx
  8038b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b5:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  8038b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bb:	8b 50 08             	mov    0x8(%eax),%edx
  8038be:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c1:	01 c2                	add    %eax,%edx
  8038c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c6:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  8038c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038cc:	e9 e5 00 00 00       	jmp    8039b6 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  8038d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d4:	8b 50 0c             	mov    0xc(%eax),%edx
  8038d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038da:	39 c2                	cmp    %eax,%edx
  8038dc:	0f 85 99 00 00 00    	jne    80397b <alloc_block_BF+0x21e>
  8038e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038e8:	0f 85 8d 00 00 00    	jne    80397b <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  8038ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  8038f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f8:	75 17                	jne    803911 <alloc_block_BF+0x1b4>
  8038fa:	83 ec 04             	sub    $0x4,%esp
  8038fd:	68 fb 4f 80 00       	push   $0x804ffb
  803902:	68 f7 00 00 00       	push   $0xf7
  803907:	68 53 4f 80 00       	push   $0x804f53
  80390c:	e8 18 db ff ff       	call   801429 <_panic>
  803911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803914:	8b 00                	mov    (%eax),%eax
  803916:	85 c0                	test   %eax,%eax
  803918:	74 10                	je     80392a <alloc_block_BF+0x1cd>
  80391a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391d:	8b 00                	mov    (%eax),%eax
  80391f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803922:	8b 52 04             	mov    0x4(%edx),%edx
  803925:	89 50 04             	mov    %edx,0x4(%eax)
  803928:	eb 0b                	jmp    803935 <alloc_block_BF+0x1d8>
  80392a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392d:	8b 40 04             	mov    0x4(%eax),%eax
  803930:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803938:	8b 40 04             	mov    0x4(%eax),%eax
  80393b:	85 c0                	test   %eax,%eax
  80393d:	74 0f                	je     80394e <alloc_block_BF+0x1f1>
  80393f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803942:	8b 40 04             	mov    0x4(%eax),%eax
  803945:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803948:	8b 12                	mov    (%edx),%edx
  80394a:	89 10                	mov    %edx,(%eax)
  80394c:	eb 0a                	jmp    803958 <alloc_block_BF+0x1fb>
  80394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803951:	8b 00                	mov    (%eax),%eax
  803953:	a3 38 61 80 00       	mov    %eax,0x806138
  803958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803964:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80396b:	a1 44 61 80 00       	mov    0x806144,%eax
  803970:	48                   	dec    %eax
  803971:	a3 44 61 80 00       	mov    %eax,0x806144
				return tmp_block;
  803976:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803979:	eb 3b                	jmp    8039b6 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80397b:	a1 40 61 80 00       	mov    0x806140,%eax
  803980:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803983:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803987:	74 07                	je     803990 <alloc_block_BF+0x233>
  803989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398c:	8b 00                	mov    (%eax),%eax
  80398e:	eb 05                	jmp    803995 <alloc_block_BF+0x238>
  803990:	b8 00 00 00 00       	mov    $0x0,%eax
  803995:	a3 40 61 80 00       	mov    %eax,0x806140
  80399a:	a1 40 61 80 00       	mov    0x806140,%eax
  80399f:	85 c0                	test   %eax,%eax
  8039a1:	0f 85 44 fe ff ff    	jne    8037eb <alloc_block_BF+0x8e>
  8039a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ab:	0f 85 3a fe ff ff    	jne    8037eb <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  8039b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b6:	c9                   	leave  
  8039b7:	c3                   	ret    

008039b8 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8039b8:	55                   	push   %ebp
  8039b9:	89 e5                	mov    %esp,%ebp
  8039bb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8039be:	83 ec 04             	sub    $0x4,%esp
  8039c1:	68 1c 50 80 00       	push   $0x80501c
  8039c6:	68 04 01 00 00       	push   $0x104
  8039cb:	68 53 4f 80 00       	push   $0x804f53
  8039d0:	e8 54 da ff ff       	call   801429 <_panic>

008039d5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  8039d5:	55                   	push   %ebp
  8039d6:	89 e5                	mov    %esp,%ebp
  8039d8:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  8039db:	a1 38 61 80 00       	mov    0x806138,%eax
  8039e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  8039e3:	a1 3c 61 80 00       	mov    0x80613c,%eax
  8039e8:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  8039eb:	a1 38 61 80 00       	mov    0x806138,%eax
  8039f0:	85 c0                	test   %eax,%eax
  8039f2:	75 68                	jne    803a5c <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8039f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039f8:	75 17                	jne    803a11 <insert_sorted_with_merge_freeList+0x3c>
  8039fa:	83 ec 04             	sub    $0x4,%esp
  8039fd:	68 30 4f 80 00       	push   $0x804f30
  803a02:	68 14 01 00 00       	push   $0x114
  803a07:	68 53 4f 80 00       	push   $0x804f53
  803a0c:	e8 18 da ff ff       	call   801429 <_panic>
  803a11:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803a17:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1a:	89 10                	mov    %edx,(%eax)
  803a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1f:	8b 00                	mov    (%eax),%eax
  803a21:	85 c0                	test   %eax,%eax
  803a23:	74 0d                	je     803a32 <insert_sorted_with_merge_freeList+0x5d>
  803a25:	a1 38 61 80 00       	mov    0x806138,%eax
  803a2a:	8b 55 08             	mov    0x8(%ebp),%edx
  803a2d:	89 50 04             	mov    %edx,0x4(%eax)
  803a30:	eb 08                	jmp    803a3a <insert_sorted_with_merge_freeList+0x65>
  803a32:	8b 45 08             	mov    0x8(%ebp),%eax
  803a35:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3d:	a3 38 61 80 00       	mov    %eax,0x806138
  803a42:	8b 45 08             	mov    0x8(%ebp),%eax
  803a45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a4c:	a1 44 61 80 00       	mov    0x806144,%eax
  803a51:	40                   	inc    %eax
  803a52:	a3 44 61 80 00       	mov    %eax,0x806144
						}
				}
        }

}
}
  803a57:	e9 d2 06 00 00       	jmp    80412e <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  803a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5f:	8b 50 08             	mov    0x8(%eax),%edx
  803a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a65:	8b 40 08             	mov    0x8(%eax),%eax
  803a68:	39 c2                	cmp    %eax,%edx
  803a6a:	0f 83 22 01 00 00    	jae    803b92 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  803a70:	8b 45 08             	mov    0x8(%ebp),%eax
  803a73:	8b 50 08             	mov    0x8(%eax),%edx
  803a76:	8b 45 08             	mov    0x8(%ebp),%eax
  803a79:	8b 40 0c             	mov    0xc(%eax),%eax
  803a7c:	01 c2                	add    %eax,%edx
  803a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a81:	8b 40 08             	mov    0x8(%eax),%eax
  803a84:	39 c2                	cmp    %eax,%edx
  803a86:	0f 85 9e 00 00 00    	jne    803b2a <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  803a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8f:	8b 50 08             	mov    0x8(%eax),%edx
  803a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a95:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a9b:	8b 50 0c             	mov    0xc(%eax),%edx
  803a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa1:	8b 40 0c             	mov    0xc(%eax),%eax
  803aa4:	01 c2                	add    %eax,%edx
  803aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa9:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  803aac:	8b 45 08             	mov    0x8(%ebp),%eax
  803aaf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab9:	8b 50 08             	mov    0x8(%eax),%edx
  803abc:	8b 45 08             	mov    0x8(%ebp),%eax
  803abf:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803ac2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ac6:	75 17                	jne    803adf <insert_sorted_with_merge_freeList+0x10a>
  803ac8:	83 ec 04             	sub    $0x4,%esp
  803acb:	68 30 4f 80 00       	push   $0x804f30
  803ad0:	68 21 01 00 00       	push   $0x121
  803ad5:	68 53 4f 80 00       	push   $0x804f53
  803ada:	e8 4a d9 ff ff       	call   801429 <_panic>
  803adf:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae8:	89 10                	mov    %edx,(%eax)
  803aea:	8b 45 08             	mov    0x8(%ebp),%eax
  803aed:	8b 00                	mov    (%eax),%eax
  803aef:	85 c0                	test   %eax,%eax
  803af1:	74 0d                	je     803b00 <insert_sorted_with_merge_freeList+0x12b>
  803af3:	a1 48 61 80 00       	mov    0x806148,%eax
  803af8:	8b 55 08             	mov    0x8(%ebp),%edx
  803afb:	89 50 04             	mov    %edx,0x4(%eax)
  803afe:	eb 08                	jmp    803b08 <insert_sorted_with_merge_freeList+0x133>
  803b00:	8b 45 08             	mov    0x8(%ebp),%eax
  803b03:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803b08:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0b:	a3 48 61 80 00       	mov    %eax,0x806148
  803b10:	8b 45 08             	mov    0x8(%ebp),%eax
  803b13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b1a:	a1 54 61 80 00       	mov    0x806154,%eax
  803b1f:	40                   	inc    %eax
  803b20:	a3 54 61 80 00       	mov    %eax,0x806154
						}
				}
        }

}
}
  803b25:	e9 04 06 00 00       	jmp    80412e <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803b2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b2e:	75 17                	jne    803b47 <insert_sorted_with_merge_freeList+0x172>
  803b30:	83 ec 04             	sub    $0x4,%esp
  803b33:	68 30 4f 80 00       	push   $0x804f30
  803b38:	68 26 01 00 00       	push   $0x126
  803b3d:	68 53 4f 80 00       	push   $0x804f53
  803b42:	e8 e2 d8 ff ff       	call   801429 <_panic>
  803b47:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b50:	89 10                	mov    %edx,(%eax)
  803b52:	8b 45 08             	mov    0x8(%ebp),%eax
  803b55:	8b 00                	mov    (%eax),%eax
  803b57:	85 c0                	test   %eax,%eax
  803b59:	74 0d                	je     803b68 <insert_sorted_with_merge_freeList+0x193>
  803b5b:	a1 38 61 80 00       	mov    0x806138,%eax
  803b60:	8b 55 08             	mov    0x8(%ebp),%edx
  803b63:	89 50 04             	mov    %edx,0x4(%eax)
  803b66:	eb 08                	jmp    803b70 <insert_sorted_with_merge_freeList+0x19b>
  803b68:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6b:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803b70:	8b 45 08             	mov    0x8(%ebp),%eax
  803b73:	a3 38 61 80 00       	mov    %eax,0x806138
  803b78:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b82:	a1 44 61 80 00       	mov    0x806144,%eax
  803b87:	40                   	inc    %eax
  803b88:	a3 44 61 80 00       	mov    %eax,0x806144
						}
				}
        }

}
}
  803b8d:	e9 9c 05 00 00       	jmp    80412e <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  803b92:	8b 45 08             	mov    0x8(%ebp),%eax
  803b95:	8b 50 08             	mov    0x8(%eax),%edx
  803b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b9b:	8b 40 08             	mov    0x8(%eax),%eax
  803b9e:	39 c2                	cmp    %eax,%edx
  803ba0:	0f 86 16 01 00 00    	jbe    803cbc <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ba9:	8b 50 08             	mov    0x8(%eax),%edx
  803bac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803baf:	8b 40 0c             	mov    0xc(%eax),%eax
  803bb2:	01 c2                	add    %eax,%edx
  803bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb7:	8b 40 08             	mov    0x8(%eax),%eax
  803bba:	39 c2                	cmp    %eax,%edx
  803bbc:	0f 85 92 00 00 00    	jne    803c54 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  803bc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bc5:	8b 50 0c             	mov    0xc(%eax),%edx
  803bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcb:	8b 40 0c             	mov    0xc(%eax),%eax
  803bce:	01 c2                	add    %eax,%edx
  803bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bd3:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  803bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803be0:	8b 45 08             	mov    0x8(%ebp),%eax
  803be3:	8b 50 08             	mov    0x8(%eax),%edx
  803be6:	8b 45 08             	mov    0x8(%ebp),%eax
  803be9:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803bec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bf0:	75 17                	jne    803c09 <insert_sorted_with_merge_freeList+0x234>
  803bf2:	83 ec 04             	sub    $0x4,%esp
  803bf5:	68 30 4f 80 00       	push   $0x804f30
  803bfa:	68 31 01 00 00       	push   $0x131
  803bff:	68 53 4f 80 00       	push   $0x804f53
  803c04:	e8 20 d8 ff ff       	call   801429 <_panic>
  803c09:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c12:	89 10                	mov    %edx,(%eax)
  803c14:	8b 45 08             	mov    0x8(%ebp),%eax
  803c17:	8b 00                	mov    (%eax),%eax
  803c19:	85 c0                	test   %eax,%eax
  803c1b:	74 0d                	je     803c2a <insert_sorted_with_merge_freeList+0x255>
  803c1d:	a1 48 61 80 00       	mov    0x806148,%eax
  803c22:	8b 55 08             	mov    0x8(%ebp),%edx
  803c25:	89 50 04             	mov    %edx,0x4(%eax)
  803c28:	eb 08                	jmp    803c32 <insert_sorted_with_merge_freeList+0x25d>
  803c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2d:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803c32:	8b 45 08             	mov    0x8(%ebp),%eax
  803c35:	a3 48 61 80 00       	mov    %eax,0x806148
  803c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c44:	a1 54 61 80 00       	mov    0x806154,%eax
  803c49:	40                   	inc    %eax
  803c4a:	a3 54 61 80 00       	mov    %eax,0x806154
						}
				}
        }

}
}
  803c4f:	e9 da 04 00 00       	jmp    80412e <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  803c54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c58:	75 17                	jne    803c71 <insert_sorted_with_merge_freeList+0x29c>
  803c5a:	83 ec 04             	sub    $0x4,%esp
  803c5d:	68 d8 4f 80 00       	push   $0x804fd8
  803c62:	68 37 01 00 00       	push   $0x137
  803c67:	68 53 4f 80 00       	push   $0x804f53
  803c6c:	e8 b8 d7 ff ff       	call   801429 <_panic>
  803c71:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803c77:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7a:	89 50 04             	mov    %edx,0x4(%eax)
  803c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c80:	8b 40 04             	mov    0x4(%eax),%eax
  803c83:	85 c0                	test   %eax,%eax
  803c85:	74 0c                	je     803c93 <insert_sorted_with_merge_freeList+0x2be>
  803c87:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  803c8f:	89 10                	mov    %edx,(%eax)
  803c91:	eb 08                	jmp    803c9b <insert_sorted_with_merge_freeList+0x2c6>
  803c93:	8b 45 08             	mov    0x8(%ebp),%eax
  803c96:	a3 38 61 80 00       	mov    %eax,0x806138
  803c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9e:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cac:	a1 44 61 80 00       	mov    0x806144,%eax
  803cb1:	40                   	inc    %eax
  803cb2:	a3 44 61 80 00       	mov    %eax,0x806144
						}
				}
        }

}
}
  803cb7:	e9 72 04 00 00       	jmp    80412e <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803cbc:	a1 38 61 80 00       	mov    0x806138,%eax
  803cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cc4:	e9 35 04 00 00       	jmp    8040fe <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccc:	8b 00                	mov    (%eax),%eax
  803cce:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  803cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd4:	8b 50 08             	mov    0x8(%eax),%edx
  803cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cda:	8b 40 08             	mov    0x8(%eax),%eax
  803cdd:	39 c2                	cmp    %eax,%edx
  803cdf:	0f 86 11 04 00 00    	jbe    8040f6 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce8:	8b 50 08             	mov    0x8(%eax),%edx
  803ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cee:	8b 40 0c             	mov    0xc(%eax),%eax
  803cf1:	01 c2                	add    %eax,%edx
  803cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf6:	8b 40 08             	mov    0x8(%eax),%eax
  803cf9:	39 c2                	cmp    %eax,%edx
  803cfb:	0f 83 8b 00 00 00    	jae    803d8c <insert_sorted_with_merge_freeList+0x3b7>
  803d01:	8b 45 08             	mov    0x8(%ebp),%eax
  803d04:	8b 50 08             	mov    0x8(%eax),%edx
  803d07:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0a:	8b 40 0c             	mov    0xc(%eax),%eax
  803d0d:	01 c2                	add    %eax,%edx
  803d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d12:	8b 40 08             	mov    0x8(%eax),%eax
  803d15:	39 c2                	cmp    %eax,%edx
  803d17:	73 73                	jae    803d8c <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803d19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d1d:	74 06                	je     803d25 <insert_sorted_with_merge_freeList+0x350>
  803d1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d23:	75 17                	jne    803d3c <insert_sorted_with_merge_freeList+0x367>
  803d25:	83 ec 04             	sub    $0x4,%esp
  803d28:	68 a4 4f 80 00       	push   $0x804fa4
  803d2d:	68 48 01 00 00       	push   $0x148
  803d32:	68 53 4f 80 00       	push   $0x804f53
  803d37:	e8 ed d6 ff ff       	call   801429 <_panic>
  803d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3f:	8b 10                	mov    (%eax),%edx
  803d41:	8b 45 08             	mov    0x8(%ebp),%eax
  803d44:	89 10                	mov    %edx,(%eax)
  803d46:	8b 45 08             	mov    0x8(%ebp),%eax
  803d49:	8b 00                	mov    (%eax),%eax
  803d4b:	85 c0                	test   %eax,%eax
  803d4d:	74 0b                	je     803d5a <insert_sorted_with_merge_freeList+0x385>
  803d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d52:	8b 00                	mov    (%eax),%eax
  803d54:	8b 55 08             	mov    0x8(%ebp),%edx
  803d57:	89 50 04             	mov    %edx,0x4(%eax)
  803d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5d:	8b 55 08             	mov    0x8(%ebp),%edx
  803d60:	89 10                	mov    %edx,(%eax)
  803d62:	8b 45 08             	mov    0x8(%ebp),%eax
  803d65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d68:	89 50 04             	mov    %edx,0x4(%eax)
  803d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6e:	8b 00                	mov    (%eax),%eax
  803d70:	85 c0                	test   %eax,%eax
  803d72:	75 08                	jne    803d7c <insert_sorted_with_merge_freeList+0x3a7>
  803d74:	8b 45 08             	mov    0x8(%ebp),%eax
  803d77:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803d7c:	a1 44 61 80 00       	mov    0x806144,%eax
  803d81:	40                   	inc    %eax
  803d82:	a3 44 61 80 00       	mov    %eax,0x806144
								break;
  803d87:	e9 a2 03 00 00       	jmp    80412e <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8f:	8b 50 08             	mov    0x8(%eax),%edx
  803d92:	8b 45 08             	mov    0x8(%ebp),%eax
  803d95:	8b 40 0c             	mov    0xc(%eax),%eax
  803d98:	01 c2                	add    %eax,%edx
  803d9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d9d:	8b 40 08             	mov    0x8(%eax),%eax
  803da0:	39 c2                	cmp    %eax,%edx
  803da2:	0f 83 ae 00 00 00    	jae    803e56 <insert_sorted_with_merge_freeList+0x481>
  803da8:	8b 45 08             	mov    0x8(%ebp),%eax
  803dab:	8b 50 08             	mov    0x8(%eax),%edx
  803dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db1:	8b 48 08             	mov    0x8(%eax),%ecx
  803db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db7:	8b 40 0c             	mov    0xc(%eax),%eax
  803dba:	01 c8                	add    %ecx,%eax
  803dbc:	39 c2                	cmp    %eax,%edx
  803dbe:	0f 85 92 00 00 00    	jne    803e56 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc7:	8b 50 0c             	mov    0xc(%eax),%edx
  803dca:	8b 45 08             	mov    0x8(%ebp),%eax
  803dcd:	8b 40 0c             	mov    0xc(%eax),%eax
  803dd0:	01 c2                	add    %eax,%edx
  803dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd5:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  803ddb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803de2:	8b 45 08             	mov    0x8(%ebp),%eax
  803de5:	8b 50 08             	mov    0x8(%eax),%edx
  803de8:	8b 45 08             	mov    0x8(%ebp),%eax
  803deb:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803dee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803df2:	75 17                	jne    803e0b <insert_sorted_with_merge_freeList+0x436>
  803df4:	83 ec 04             	sub    $0x4,%esp
  803df7:	68 30 4f 80 00       	push   $0x804f30
  803dfc:	68 51 01 00 00       	push   $0x151
  803e01:	68 53 4f 80 00       	push   $0x804f53
  803e06:	e8 1e d6 ff ff       	call   801429 <_panic>
  803e0b:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803e11:	8b 45 08             	mov    0x8(%ebp),%eax
  803e14:	89 10                	mov    %edx,(%eax)
  803e16:	8b 45 08             	mov    0x8(%ebp),%eax
  803e19:	8b 00                	mov    (%eax),%eax
  803e1b:	85 c0                	test   %eax,%eax
  803e1d:	74 0d                	je     803e2c <insert_sorted_with_merge_freeList+0x457>
  803e1f:	a1 48 61 80 00       	mov    0x806148,%eax
  803e24:	8b 55 08             	mov    0x8(%ebp),%edx
  803e27:	89 50 04             	mov    %edx,0x4(%eax)
  803e2a:	eb 08                	jmp    803e34 <insert_sorted_with_merge_freeList+0x45f>
  803e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803e34:	8b 45 08             	mov    0x8(%ebp),%eax
  803e37:	a3 48 61 80 00       	mov    %eax,0x806148
  803e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e46:	a1 54 61 80 00       	mov    0x806154,%eax
  803e4b:	40                   	inc    %eax
  803e4c:	a3 54 61 80 00       	mov    %eax,0x806154
								 break;
  803e51:	e9 d8 02 00 00       	jmp    80412e <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803e56:	8b 45 08             	mov    0x8(%ebp),%eax
  803e59:	8b 50 08             	mov    0x8(%eax),%edx
  803e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5f:	8b 40 0c             	mov    0xc(%eax),%eax
  803e62:	01 c2                	add    %eax,%edx
  803e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e67:	8b 40 08             	mov    0x8(%eax),%eax
  803e6a:	39 c2                	cmp    %eax,%edx
  803e6c:	0f 85 ba 00 00 00    	jne    803f2c <insert_sorted_with_merge_freeList+0x557>
  803e72:	8b 45 08             	mov    0x8(%ebp),%eax
  803e75:	8b 50 08             	mov    0x8(%eax),%edx
  803e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7b:	8b 48 08             	mov    0x8(%eax),%ecx
  803e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e81:	8b 40 0c             	mov    0xc(%eax),%eax
  803e84:	01 c8                	add    %ecx,%eax
  803e86:	39 c2                	cmp    %eax,%edx
  803e88:	0f 86 9e 00 00 00    	jbe    803f2c <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803e8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e91:	8b 50 0c             	mov    0xc(%eax),%edx
  803e94:	8b 45 08             	mov    0x8(%ebp),%eax
  803e97:	8b 40 0c             	mov    0xc(%eax),%eax
  803e9a:	01 c2                	add    %eax,%edx
  803e9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e9f:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea5:	8b 50 08             	mov    0x8(%eax),%edx
  803ea8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eab:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803eae:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  803ebb:	8b 50 08             	mov    0x8(%eax),%edx
  803ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec1:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803ec4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ec8:	75 17                	jne    803ee1 <insert_sorted_with_merge_freeList+0x50c>
  803eca:	83 ec 04             	sub    $0x4,%esp
  803ecd:	68 30 4f 80 00       	push   $0x804f30
  803ed2:	68 5b 01 00 00       	push   $0x15b
  803ed7:	68 53 4f 80 00       	push   $0x804f53
  803edc:	e8 48 d5 ff ff       	call   801429 <_panic>
  803ee1:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  803eea:	89 10                	mov    %edx,(%eax)
  803eec:	8b 45 08             	mov    0x8(%ebp),%eax
  803eef:	8b 00                	mov    (%eax),%eax
  803ef1:	85 c0                	test   %eax,%eax
  803ef3:	74 0d                	je     803f02 <insert_sorted_with_merge_freeList+0x52d>
  803ef5:	a1 48 61 80 00       	mov    0x806148,%eax
  803efa:	8b 55 08             	mov    0x8(%ebp),%edx
  803efd:	89 50 04             	mov    %edx,0x4(%eax)
  803f00:	eb 08                	jmp    803f0a <insert_sorted_with_merge_freeList+0x535>
  803f02:	8b 45 08             	mov    0x8(%ebp),%eax
  803f05:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0d:	a3 48 61 80 00       	mov    %eax,0x806148
  803f12:	8b 45 08             	mov    0x8(%ebp),%eax
  803f15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f1c:	a1 54 61 80 00       	mov    0x806154,%eax
  803f21:	40                   	inc    %eax
  803f22:	a3 54 61 80 00       	mov    %eax,0x806154
								break;
  803f27:	e9 02 02 00 00       	jmp    80412e <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f2f:	8b 50 08             	mov    0x8(%eax),%edx
  803f32:	8b 45 08             	mov    0x8(%ebp),%eax
  803f35:	8b 40 0c             	mov    0xc(%eax),%eax
  803f38:	01 c2                	add    %eax,%edx
  803f3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f3d:	8b 40 08             	mov    0x8(%eax),%eax
  803f40:	39 c2                	cmp    %eax,%edx
  803f42:	0f 85 ae 01 00 00    	jne    8040f6 <insert_sorted_with_merge_freeList+0x721>
  803f48:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4b:	8b 50 08             	mov    0x8(%eax),%edx
  803f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f51:	8b 48 08             	mov    0x8(%eax),%ecx
  803f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f57:	8b 40 0c             	mov    0xc(%eax),%eax
  803f5a:	01 c8                	add    %ecx,%eax
  803f5c:	39 c2                	cmp    %eax,%edx
  803f5e:	0f 85 92 01 00 00    	jne    8040f6 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f67:	8b 50 0c             	mov    0xc(%eax),%edx
  803f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f6d:	8b 40 0c             	mov    0xc(%eax),%eax
  803f70:	01 c2                	add    %eax,%edx
  803f72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f75:	8b 40 0c             	mov    0xc(%eax),%eax
  803f78:	01 c2                	add    %eax,%edx
  803f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7d:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803f80:	8b 45 08             	mov    0x8(%ebp),%eax
  803f83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f8d:	8b 50 08             	mov    0x8(%eax),%edx
  803f90:	8b 45 08             	mov    0x8(%ebp),%eax
  803f93:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f99:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803fa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fa3:	8b 50 08             	mov    0x8(%eax),%edx
  803fa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fa9:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803fac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803fb0:	75 17                	jne    803fc9 <insert_sorted_with_merge_freeList+0x5f4>
  803fb2:	83 ec 04             	sub    $0x4,%esp
  803fb5:	68 fb 4f 80 00       	push   $0x804ffb
  803fba:	68 63 01 00 00       	push   $0x163
  803fbf:	68 53 4f 80 00       	push   $0x804f53
  803fc4:	e8 60 d4 ff ff       	call   801429 <_panic>
  803fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fcc:	8b 00                	mov    (%eax),%eax
  803fce:	85 c0                	test   %eax,%eax
  803fd0:	74 10                	je     803fe2 <insert_sorted_with_merge_freeList+0x60d>
  803fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fd5:	8b 00                	mov    (%eax),%eax
  803fd7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fda:	8b 52 04             	mov    0x4(%edx),%edx
  803fdd:	89 50 04             	mov    %edx,0x4(%eax)
  803fe0:	eb 0b                	jmp    803fed <insert_sorted_with_merge_freeList+0x618>
  803fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fe5:	8b 40 04             	mov    0x4(%eax),%eax
  803fe8:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ff0:	8b 40 04             	mov    0x4(%eax),%eax
  803ff3:	85 c0                	test   %eax,%eax
  803ff5:	74 0f                	je     804006 <insert_sorted_with_merge_freeList+0x631>
  803ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ffa:	8b 40 04             	mov    0x4(%eax),%eax
  803ffd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804000:	8b 12                	mov    (%edx),%edx
  804002:	89 10                	mov    %edx,(%eax)
  804004:	eb 0a                	jmp    804010 <insert_sorted_with_merge_freeList+0x63b>
  804006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804009:	8b 00                	mov    (%eax),%eax
  80400b:	a3 38 61 80 00       	mov    %eax,0x806138
  804010:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804013:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80401c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804023:	a1 44 61 80 00       	mov    0x806144,%eax
  804028:	48                   	dec    %eax
  804029:	a3 44 61 80 00       	mov    %eax,0x806144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  80402e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804032:	75 17                	jne    80404b <insert_sorted_with_merge_freeList+0x676>
  804034:	83 ec 04             	sub    $0x4,%esp
  804037:	68 30 4f 80 00       	push   $0x804f30
  80403c:	68 64 01 00 00       	push   $0x164
  804041:	68 53 4f 80 00       	push   $0x804f53
  804046:	e8 de d3 ff ff       	call   801429 <_panic>
  80404b:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804051:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804054:	89 10                	mov    %edx,(%eax)
  804056:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804059:	8b 00                	mov    (%eax),%eax
  80405b:	85 c0                	test   %eax,%eax
  80405d:	74 0d                	je     80406c <insert_sorted_with_merge_freeList+0x697>
  80405f:	a1 48 61 80 00       	mov    0x806148,%eax
  804064:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804067:	89 50 04             	mov    %edx,0x4(%eax)
  80406a:	eb 08                	jmp    804074 <insert_sorted_with_merge_freeList+0x69f>
  80406c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80406f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804077:	a3 48 61 80 00       	mov    %eax,0x806148
  80407c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80407f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804086:	a1 54 61 80 00       	mov    0x806154,%eax
  80408b:	40                   	inc    %eax
  80408c:	a3 54 61 80 00       	mov    %eax,0x806154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  804091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804095:	75 17                	jne    8040ae <insert_sorted_with_merge_freeList+0x6d9>
  804097:	83 ec 04             	sub    $0x4,%esp
  80409a:	68 30 4f 80 00       	push   $0x804f30
  80409f:	68 65 01 00 00       	push   $0x165
  8040a4:	68 53 4f 80 00       	push   $0x804f53
  8040a9:	e8 7b d3 ff ff       	call   801429 <_panic>
  8040ae:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8040b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b7:	89 10                	mov    %edx,(%eax)
  8040b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040bc:	8b 00                	mov    (%eax),%eax
  8040be:	85 c0                	test   %eax,%eax
  8040c0:	74 0d                	je     8040cf <insert_sorted_with_merge_freeList+0x6fa>
  8040c2:	a1 48 61 80 00       	mov    0x806148,%eax
  8040c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8040ca:	89 50 04             	mov    %edx,0x4(%eax)
  8040cd:	eb 08                	jmp    8040d7 <insert_sorted_with_merge_freeList+0x702>
  8040cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d2:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8040d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040da:	a3 48 61 80 00       	mov    %eax,0x806148
  8040df:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040e9:	a1 54 61 80 00       	mov    0x806154,%eax
  8040ee:	40                   	inc    %eax
  8040ef:	a3 54 61 80 00       	mov    %eax,0x806154
								break;
  8040f4:	eb 38                	jmp    80412e <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8040f6:	a1 40 61 80 00       	mov    0x806140,%eax
  8040fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804102:	74 07                	je     80410b <insert_sorted_with_merge_freeList+0x736>
  804104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804107:	8b 00                	mov    (%eax),%eax
  804109:	eb 05                	jmp    804110 <insert_sorted_with_merge_freeList+0x73b>
  80410b:	b8 00 00 00 00       	mov    $0x0,%eax
  804110:	a3 40 61 80 00       	mov    %eax,0x806140
  804115:	a1 40 61 80 00       	mov    0x806140,%eax
  80411a:	85 c0                	test   %eax,%eax
  80411c:	0f 85 a7 fb ff ff    	jne    803cc9 <insert_sorted_with_merge_freeList+0x2f4>
  804122:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804126:	0f 85 9d fb ff ff    	jne    803cc9 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80412c:	eb 00                	jmp    80412e <insert_sorted_with_merge_freeList+0x759>
  80412e:	90                   	nop
  80412f:	c9                   	leave  
  804130:	c3                   	ret    
  804131:	66 90                	xchg   %ax,%ax
  804133:	90                   	nop

00804134 <__udivdi3>:
  804134:	55                   	push   %ebp
  804135:	57                   	push   %edi
  804136:	56                   	push   %esi
  804137:	53                   	push   %ebx
  804138:	83 ec 1c             	sub    $0x1c,%esp
  80413b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80413f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804143:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804147:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80414b:	89 ca                	mov    %ecx,%edx
  80414d:	89 f8                	mov    %edi,%eax
  80414f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804153:	85 f6                	test   %esi,%esi
  804155:	75 2d                	jne    804184 <__udivdi3+0x50>
  804157:	39 cf                	cmp    %ecx,%edi
  804159:	77 65                	ja     8041c0 <__udivdi3+0x8c>
  80415b:	89 fd                	mov    %edi,%ebp
  80415d:	85 ff                	test   %edi,%edi
  80415f:	75 0b                	jne    80416c <__udivdi3+0x38>
  804161:	b8 01 00 00 00       	mov    $0x1,%eax
  804166:	31 d2                	xor    %edx,%edx
  804168:	f7 f7                	div    %edi
  80416a:	89 c5                	mov    %eax,%ebp
  80416c:	31 d2                	xor    %edx,%edx
  80416e:	89 c8                	mov    %ecx,%eax
  804170:	f7 f5                	div    %ebp
  804172:	89 c1                	mov    %eax,%ecx
  804174:	89 d8                	mov    %ebx,%eax
  804176:	f7 f5                	div    %ebp
  804178:	89 cf                	mov    %ecx,%edi
  80417a:	89 fa                	mov    %edi,%edx
  80417c:	83 c4 1c             	add    $0x1c,%esp
  80417f:	5b                   	pop    %ebx
  804180:	5e                   	pop    %esi
  804181:	5f                   	pop    %edi
  804182:	5d                   	pop    %ebp
  804183:	c3                   	ret    
  804184:	39 ce                	cmp    %ecx,%esi
  804186:	77 28                	ja     8041b0 <__udivdi3+0x7c>
  804188:	0f bd fe             	bsr    %esi,%edi
  80418b:	83 f7 1f             	xor    $0x1f,%edi
  80418e:	75 40                	jne    8041d0 <__udivdi3+0x9c>
  804190:	39 ce                	cmp    %ecx,%esi
  804192:	72 0a                	jb     80419e <__udivdi3+0x6a>
  804194:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804198:	0f 87 9e 00 00 00    	ja     80423c <__udivdi3+0x108>
  80419e:	b8 01 00 00 00       	mov    $0x1,%eax
  8041a3:	89 fa                	mov    %edi,%edx
  8041a5:	83 c4 1c             	add    $0x1c,%esp
  8041a8:	5b                   	pop    %ebx
  8041a9:	5e                   	pop    %esi
  8041aa:	5f                   	pop    %edi
  8041ab:	5d                   	pop    %ebp
  8041ac:	c3                   	ret    
  8041ad:	8d 76 00             	lea    0x0(%esi),%esi
  8041b0:	31 ff                	xor    %edi,%edi
  8041b2:	31 c0                	xor    %eax,%eax
  8041b4:	89 fa                	mov    %edi,%edx
  8041b6:	83 c4 1c             	add    $0x1c,%esp
  8041b9:	5b                   	pop    %ebx
  8041ba:	5e                   	pop    %esi
  8041bb:	5f                   	pop    %edi
  8041bc:	5d                   	pop    %ebp
  8041bd:	c3                   	ret    
  8041be:	66 90                	xchg   %ax,%ax
  8041c0:	89 d8                	mov    %ebx,%eax
  8041c2:	f7 f7                	div    %edi
  8041c4:	31 ff                	xor    %edi,%edi
  8041c6:	89 fa                	mov    %edi,%edx
  8041c8:	83 c4 1c             	add    $0x1c,%esp
  8041cb:	5b                   	pop    %ebx
  8041cc:	5e                   	pop    %esi
  8041cd:	5f                   	pop    %edi
  8041ce:	5d                   	pop    %ebp
  8041cf:	c3                   	ret    
  8041d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8041d5:	89 eb                	mov    %ebp,%ebx
  8041d7:	29 fb                	sub    %edi,%ebx
  8041d9:	89 f9                	mov    %edi,%ecx
  8041db:	d3 e6                	shl    %cl,%esi
  8041dd:	89 c5                	mov    %eax,%ebp
  8041df:	88 d9                	mov    %bl,%cl
  8041e1:	d3 ed                	shr    %cl,%ebp
  8041e3:	89 e9                	mov    %ebp,%ecx
  8041e5:	09 f1                	or     %esi,%ecx
  8041e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8041eb:	89 f9                	mov    %edi,%ecx
  8041ed:	d3 e0                	shl    %cl,%eax
  8041ef:	89 c5                	mov    %eax,%ebp
  8041f1:	89 d6                	mov    %edx,%esi
  8041f3:	88 d9                	mov    %bl,%cl
  8041f5:	d3 ee                	shr    %cl,%esi
  8041f7:	89 f9                	mov    %edi,%ecx
  8041f9:	d3 e2                	shl    %cl,%edx
  8041fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041ff:	88 d9                	mov    %bl,%cl
  804201:	d3 e8                	shr    %cl,%eax
  804203:	09 c2                	or     %eax,%edx
  804205:	89 d0                	mov    %edx,%eax
  804207:	89 f2                	mov    %esi,%edx
  804209:	f7 74 24 0c          	divl   0xc(%esp)
  80420d:	89 d6                	mov    %edx,%esi
  80420f:	89 c3                	mov    %eax,%ebx
  804211:	f7 e5                	mul    %ebp
  804213:	39 d6                	cmp    %edx,%esi
  804215:	72 19                	jb     804230 <__udivdi3+0xfc>
  804217:	74 0b                	je     804224 <__udivdi3+0xf0>
  804219:	89 d8                	mov    %ebx,%eax
  80421b:	31 ff                	xor    %edi,%edi
  80421d:	e9 58 ff ff ff       	jmp    80417a <__udivdi3+0x46>
  804222:	66 90                	xchg   %ax,%ax
  804224:	8b 54 24 08          	mov    0x8(%esp),%edx
  804228:	89 f9                	mov    %edi,%ecx
  80422a:	d3 e2                	shl    %cl,%edx
  80422c:	39 c2                	cmp    %eax,%edx
  80422e:	73 e9                	jae    804219 <__udivdi3+0xe5>
  804230:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804233:	31 ff                	xor    %edi,%edi
  804235:	e9 40 ff ff ff       	jmp    80417a <__udivdi3+0x46>
  80423a:	66 90                	xchg   %ax,%ax
  80423c:	31 c0                	xor    %eax,%eax
  80423e:	e9 37 ff ff ff       	jmp    80417a <__udivdi3+0x46>
  804243:	90                   	nop

00804244 <__umoddi3>:
  804244:	55                   	push   %ebp
  804245:	57                   	push   %edi
  804246:	56                   	push   %esi
  804247:	53                   	push   %ebx
  804248:	83 ec 1c             	sub    $0x1c,%esp
  80424b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80424f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804253:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804257:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80425b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80425f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804263:	89 f3                	mov    %esi,%ebx
  804265:	89 fa                	mov    %edi,%edx
  804267:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80426b:	89 34 24             	mov    %esi,(%esp)
  80426e:	85 c0                	test   %eax,%eax
  804270:	75 1a                	jne    80428c <__umoddi3+0x48>
  804272:	39 f7                	cmp    %esi,%edi
  804274:	0f 86 a2 00 00 00    	jbe    80431c <__umoddi3+0xd8>
  80427a:	89 c8                	mov    %ecx,%eax
  80427c:	89 f2                	mov    %esi,%edx
  80427e:	f7 f7                	div    %edi
  804280:	89 d0                	mov    %edx,%eax
  804282:	31 d2                	xor    %edx,%edx
  804284:	83 c4 1c             	add    $0x1c,%esp
  804287:	5b                   	pop    %ebx
  804288:	5e                   	pop    %esi
  804289:	5f                   	pop    %edi
  80428a:	5d                   	pop    %ebp
  80428b:	c3                   	ret    
  80428c:	39 f0                	cmp    %esi,%eax
  80428e:	0f 87 ac 00 00 00    	ja     804340 <__umoddi3+0xfc>
  804294:	0f bd e8             	bsr    %eax,%ebp
  804297:	83 f5 1f             	xor    $0x1f,%ebp
  80429a:	0f 84 ac 00 00 00    	je     80434c <__umoddi3+0x108>
  8042a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8042a5:	29 ef                	sub    %ebp,%edi
  8042a7:	89 fe                	mov    %edi,%esi
  8042a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8042ad:	89 e9                	mov    %ebp,%ecx
  8042af:	d3 e0                	shl    %cl,%eax
  8042b1:	89 d7                	mov    %edx,%edi
  8042b3:	89 f1                	mov    %esi,%ecx
  8042b5:	d3 ef                	shr    %cl,%edi
  8042b7:	09 c7                	or     %eax,%edi
  8042b9:	89 e9                	mov    %ebp,%ecx
  8042bb:	d3 e2                	shl    %cl,%edx
  8042bd:	89 14 24             	mov    %edx,(%esp)
  8042c0:	89 d8                	mov    %ebx,%eax
  8042c2:	d3 e0                	shl    %cl,%eax
  8042c4:	89 c2                	mov    %eax,%edx
  8042c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042ca:	d3 e0                	shl    %cl,%eax
  8042cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042d4:	89 f1                	mov    %esi,%ecx
  8042d6:	d3 e8                	shr    %cl,%eax
  8042d8:	09 d0                	or     %edx,%eax
  8042da:	d3 eb                	shr    %cl,%ebx
  8042dc:	89 da                	mov    %ebx,%edx
  8042de:	f7 f7                	div    %edi
  8042e0:	89 d3                	mov    %edx,%ebx
  8042e2:	f7 24 24             	mull   (%esp)
  8042e5:	89 c6                	mov    %eax,%esi
  8042e7:	89 d1                	mov    %edx,%ecx
  8042e9:	39 d3                	cmp    %edx,%ebx
  8042eb:	0f 82 87 00 00 00    	jb     804378 <__umoddi3+0x134>
  8042f1:	0f 84 91 00 00 00    	je     804388 <__umoddi3+0x144>
  8042f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8042fb:	29 f2                	sub    %esi,%edx
  8042fd:	19 cb                	sbb    %ecx,%ebx
  8042ff:	89 d8                	mov    %ebx,%eax
  804301:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804305:	d3 e0                	shl    %cl,%eax
  804307:	89 e9                	mov    %ebp,%ecx
  804309:	d3 ea                	shr    %cl,%edx
  80430b:	09 d0                	or     %edx,%eax
  80430d:	89 e9                	mov    %ebp,%ecx
  80430f:	d3 eb                	shr    %cl,%ebx
  804311:	89 da                	mov    %ebx,%edx
  804313:	83 c4 1c             	add    $0x1c,%esp
  804316:	5b                   	pop    %ebx
  804317:	5e                   	pop    %esi
  804318:	5f                   	pop    %edi
  804319:	5d                   	pop    %ebp
  80431a:	c3                   	ret    
  80431b:	90                   	nop
  80431c:	89 fd                	mov    %edi,%ebp
  80431e:	85 ff                	test   %edi,%edi
  804320:	75 0b                	jne    80432d <__umoddi3+0xe9>
  804322:	b8 01 00 00 00       	mov    $0x1,%eax
  804327:	31 d2                	xor    %edx,%edx
  804329:	f7 f7                	div    %edi
  80432b:	89 c5                	mov    %eax,%ebp
  80432d:	89 f0                	mov    %esi,%eax
  80432f:	31 d2                	xor    %edx,%edx
  804331:	f7 f5                	div    %ebp
  804333:	89 c8                	mov    %ecx,%eax
  804335:	f7 f5                	div    %ebp
  804337:	89 d0                	mov    %edx,%eax
  804339:	e9 44 ff ff ff       	jmp    804282 <__umoddi3+0x3e>
  80433e:	66 90                	xchg   %ax,%ax
  804340:	89 c8                	mov    %ecx,%eax
  804342:	89 f2                	mov    %esi,%edx
  804344:	83 c4 1c             	add    $0x1c,%esp
  804347:	5b                   	pop    %ebx
  804348:	5e                   	pop    %esi
  804349:	5f                   	pop    %edi
  80434a:	5d                   	pop    %ebp
  80434b:	c3                   	ret    
  80434c:	3b 04 24             	cmp    (%esp),%eax
  80434f:	72 06                	jb     804357 <__umoddi3+0x113>
  804351:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804355:	77 0f                	ja     804366 <__umoddi3+0x122>
  804357:	89 f2                	mov    %esi,%edx
  804359:	29 f9                	sub    %edi,%ecx
  80435b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80435f:	89 14 24             	mov    %edx,(%esp)
  804362:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804366:	8b 44 24 04          	mov    0x4(%esp),%eax
  80436a:	8b 14 24             	mov    (%esp),%edx
  80436d:	83 c4 1c             	add    $0x1c,%esp
  804370:	5b                   	pop    %ebx
  804371:	5e                   	pop    %esi
  804372:	5f                   	pop    %edi
  804373:	5d                   	pop    %ebp
  804374:	c3                   	ret    
  804375:	8d 76 00             	lea    0x0(%esi),%esi
  804378:	2b 04 24             	sub    (%esp),%eax
  80437b:	19 fa                	sbb    %edi,%edx
  80437d:	89 d1                	mov    %edx,%ecx
  80437f:	89 c6                	mov    %eax,%esi
  804381:	e9 71 ff ff ff       	jmp    8042f7 <__umoddi3+0xb3>
  804386:	66 90                	xchg   %ax,%ax
  804388:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80438c:	72 ea                	jb     804378 <__umoddi3+0x134>
  80438e:	89 d9                	mov    %ebx,%ecx
  804390:	e9 62 ff ff ff       	jmp    8042f7 <__umoddi3+0xb3>
