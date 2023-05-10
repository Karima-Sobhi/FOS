
obj/user/tst_realloc_1:     file format elf32-i386


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
  800031:	e8 38 11 00 00       	call   80116e <libmain>
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
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 55 80             	lea    -0x80(%ebp),%edx
  800051:	b9 14 00 00 00       	mov    $0x14,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 20 42 80 00       	push   $0x804220
  800067:	e8 f2 14 00 00       	call   80155e <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 44 28 00 00       	call   8028b8 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 dc 28 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  80007f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800082:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800085:	83 ec 0c             	sub    $0xc,%esp
  800088:	50                   	push   %eax
  800089:	e8 fc 23 00 00       	call   80248a <malloc>
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800094:	8b 45 80             	mov    -0x80(%ebp),%eax
  800097:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80009c:	74 14                	je     8000b2 <_main+0x7a>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	68 44 42 80 00       	push   $0x804244
  8000a6:	6a 11                	push   $0x11
  8000a8:	68 74 42 80 00       	push   $0x804274
  8000ad:	e8 f8 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000b5:	e8 fe 27 00 00       	call   8028b8 <sys_calculate_free_frames>
  8000ba:	29 c3                	sub    %eax,%ebx
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 8c 42 80 00       	push   $0x80428c
  8000cb:	6a 13                	push   $0x13
  8000cd:	68 74 42 80 00       	push   $0x804274
  8000d2:	e8 d3 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256)panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 7c 28 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  8000dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 f8 42 80 00       	push   $0x8042f8
  8000ee:	6a 14                	push   $0x14
  8000f0:	68 74 42 80 00       	push   $0x804274
  8000f5:	e8 b0 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000fa:	e8 b9 27 00 00       	call   8028b8 <sys_calculate_free_frames>
  8000ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800102:	e8 51 28 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80010a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 71 23 00 00       	call   80248a <malloc>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80011f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800122:	89 c2                	mov    %eax,%edx
  800124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800127:	05 00 00 00 80       	add    $0x80000000,%eax
  80012c:	39 c2                	cmp    %eax,%edx
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 44 42 80 00       	push   $0x804244
  800138:	6a 19                	push   $0x19
  80013a:	68 74 42 80 00       	push   $0x804274
  80013f:	e8 66 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800144:	e8 6f 27 00 00       	call   8028b8 <sys_calculate_free_frames>
  800149:	89 c2                	mov    %eax,%edx
  80014b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014e:	39 c2                	cmp    %eax,%edx
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 8c 42 80 00       	push   $0x80428c
  80015a:	6a 1b                	push   $0x1b
  80015c:	68 74 42 80 00       	push   $0x804274
  800161:	e8 44 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800166:	e8 ed 27 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  80016b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80016e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 f8 42 80 00       	push   $0x8042f8
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 74 42 80 00       	push   $0x804274
  800184:	e8 21 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800189:	e8 2a 27 00 00       	call   8028b8 <sys_calculate_free_frames>
  80018e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800191:	e8 c2 27 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80019c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	50                   	push   %eax
  8001a3:	e8 e2 22 00 00       	call   80248a <malloc>
  8001a8:	83 c4 10             	add    $0x10,%esp
  8001ab:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001ae:	8b 45 88             	mov    -0x78(%ebp),%eax
  8001b1:	89 c2                	mov    %eax,%edx
  8001b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b6:	01 c0                	add    %eax,%eax
  8001b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 44 42 80 00       	push   $0x804244
  8001c9:	6a 21                	push   $0x21
  8001cb:	68 74 42 80 00       	push   $0x804274
  8001d0:	e8 d5 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001d5:	e8 de 26 00 00       	call   8028b8 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 8c 42 80 00       	push   $0x80428c
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 74 42 80 00       	push   $0x804274
  8001f2:	e8 b3 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8001f7:	e8 5c 27 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  8001fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 f8 42 80 00       	push   $0x8042f8
  80020e:	6a 24                	push   $0x24
  800210:	68 74 42 80 00       	push   $0x804274
  800215:	e8 90 10 00 00       	call   8012aa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80021a:	e8 99 26 00 00       	call   8028b8 <sys_calculate_free_frames>
  80021f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800222:	e8 31 27 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  80022a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80022d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	50                   	push   %eax
  800234:	e8 51 22 00 00       	call   80248a <malloc>
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80023f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800242:	89 c1                	mov    %eax,%ecx
  800244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800247:	89 c2                	mov    %eax,%edx
  800249:	01 d2                	add    %edx,%edx
  80024b:	01 d0                	add    %edx,%eax
  80024d:	05 00 00 00 80       	add    $0x80000000,%eax
  800252:	39 c1                	cmp    %eax,%ecx
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 44 42 80 00       	push   $0x804244
  80025e:	6a 2a                	push   $0x2a
  800260:	68 74 42 80 00       	push   $0x804274
  800265:	e8 40 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026a:	e8 49 26 00 00       	call   8028b8 <sys_calculate_free_frames>
  80026f:	89 c2                	mov    %eax,%edx
  800271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 8c 42 80 00       	push   $0x80428c
  800280:	6a 2c                	push   $0x2c
  800282:	68 74 42 80 00       	push   $0x804274
  800287:	e8 1e 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80028c:	e8 c7 26 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	3d 00 01 00 00       	cmp    $0x100,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 f8 42 80 00       	push   $0x8042f8
  8002a3:	6a 2d                	push   $0x2d
  8002a5:	68 74 42 80 00       	push   $0x804274
  8002aa:	e8 fb 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 04 26 00 00       	call   8028b8 <sys_calculate_free_frames>
  8002b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 9c 26 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  8002bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	50                   	push   %eax
  8002cb:	e8 ba 21 00 00       	call   80248a <malloc>
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002d6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002d9:	89 c2                	mov    %eax,%edx
  8002db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002de:	c1 e0 02             	shl    $0x2,%eax
  8002e1:	05 00 00 00 80       	add    $0x80000000,%eax
  8002e6:	39 c2                	cmp    %eax,%edx
  8002e8:	74 14                	je     8002fe <_main+0x2c6>
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	68 44 42 80 00       	push   $0x804244
  8002f2:	6a 33                	push   $0x33
  8002f4:	68 74 42 80 00       	push   $0x804274
  8002f9:	e8 ac 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800301:	e8 b2 25 00 00       	call   8028b8 <sys_calculate_free_frames>
  800306:	29 c3                	sub    %eax,%ebx
  800308:	89 d8                	mov    %ebx,%eax
  80030a:	83 f8 01             	cmp    $0x1,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 8c 42 80 00       	push   $0x80428c
  800317:	6a 35                	push   $0x35
  800319:	68 74 42 80 00       	push   $0x804274
  80031e:	e8 87 0f 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800323:	e8 30 26 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800328:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 f8 42 80 00       	push   $0x8042f8
  80033a:	6a 36                	push   $0x36
  80033c:	68 74 42 80 00       	push   $0x804274
  800341:	e8 64 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800346:	e8 6d 25 00 00       	call   8028b8 <sys_calculate_free_frames>
  80034b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80034e:	e8 05 26 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800359:	01 c0                	add    %eax,%eax
  80035b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80035e:	83 ec 0c             	sub    $0xc,%esp
  800361:	50                   	push   %eax
  800362:	e8 23 21 00 00       	call   80248a <malloc>
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80036d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800370:	89 c1                	mov    %eax,%ecx
  800372:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800375:	89 d0                	mov    %edx,%eax
  800377:	01 c0                	add    %eax,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	05 00 00 00 80       	add    $0x80000000,%eax
  800382:	39 c1                	cmp    %eax,%ecx
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 44 42 80 00       	push   $0x804244
  80038e:	6a 3c                	push   $0x3c
  800390:	68 74 42 80 00       	push   $0x804274
  800395:	e8 10 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039a:	e8 19 25 00 00       	call   8028b8 <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 8c 42 80 00       	push   $0x80428c
  8003b0:	6a 3e                	push   $0x3e
  8003b2:	68 74 42 80 00       	push   $0x804274
  8003b7:	e8 ee 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003bc:	e8 97 25 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  8003c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 f8 42 80 00       	push   $0x8042f8
  8003d3:	6a 3f                	push   $0x3f
  8003d5:	68 74 42 80 00       	push   $0x804274
  8003da:	e8 cb 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 d4 24 00 00       	call   8028b8 <sys_calculate_free_frames>
  8003e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 6c 25 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	01 d2                	add    %edx,%edx
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003fb:	83 ec 0c             	sub    $0xc,%esp
  8003fe:	50                   	push   %eax
  8003ff:	e8 86 20 00 00       	call   80248a <malloc>
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80040a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800412:	c1 e0 03             	shl    $0x3,%eax
  800415:	05 00 00 00 80       	add    $0x80000000,%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	74 14                	je     800432 <_main+0x3fa>
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	68 44 42 80 00       	push   $0x804244
  800426:	6a 45                	push   $0x45
  800428:	68 74 42 80 00       	push   $0x804274
  80042d:	e8 78 0e 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800432:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800435:	e8 7e 24 00 00       	call   8028b8 <sys_calculate_free_frames>
  80043a:	29 c3                	sub    %eax,%ebx
  80043c:	89 d8                	mov    %ebx,%eax
  80043e:	83 f8 01             	cmp    $0x1,%eax
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 8c 42 80 00       	push   $0x80428c
  80044b:	6a 47                	push   $0x47
  80044d:	68 74 42 80 00       	push   $0x804274
  800452:	e8 53 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800457:	e8 fc 24 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  80045c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80045f:	3d 00 03 00 00       	cmp    $0x300,%eax
  800464:	74 14                	je     80047a <_main+0x442>
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 f8 42 80 00       	push   $0x8042f8
  80046e:	6a 48                	push   $0x48
  800470:	68 74 42 80 00       	push   $0x804274
  800475:	e8 30 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80047a:	e8 39 24 00 00       	call   8028b8 <sys_calculate_free_frames>
  80047f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800482:	e8 d1 24 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048d:	89 c2                	mov    %eax,%edx
  80048f:	01 d2                	add    %edx,%edx
  800491:	01 d0                	add    %edx,%eax
  800493:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 eb 1f 00 00       	call   80248a <malloc>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004a5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004a8:	89 c1                	mov    %eax,%ecx
  8004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8004ad:	89 d0                	mov    %edx,%eax
  8004af:	c1 e0 02             	shl    $0x2,%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	01 c0                	add    %eax,%eax
  8004b6:	01 d0                	add    %edx,%eax
  8004b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8004bd:	39 c1                	cmp    %eax,%ecx
  8004bf:	74 14                	je     8004d5 <_main+0x49d>
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	68 44 42 80 00       	push   $0x804244
  8004c9:	6a 4e                	push   $0x4e
  8004cb:	68 74 42 80 00       	push   $0x804274
  8004d0:	e8 d5 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8004d8:	e8 db 23 00 00       	call   8028b8 <sys_calculate_free_frames>
  8004dd:	29 c3                	sub    %eax,%ebx
  8004df:	89 d8                	mov    %ebx,%eax
  8004e1:	83 f8 01             	cmp    $0x1,%eax
  8004e4:	74 14                	je     8004fa <_main+0x4c2>
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 8c 42 80 00       	push   $0x80428c
  8004ee:	6a 50                	push   $0x50
  8004f0:	68 74 42 80 00       	push   $0x804274
  8004f5:	e8 b0 0d 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8004fa:	e8 59 24 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  8004ff:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800502:	3d 00 03 00 00       	cmp    $0x300,%eax
  800507:	74 14                	je     80051d <_main+0x4e5>
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 f8 42 80 00       	push   $0x8042f8
  800511:	6a 51                	push   $0x51
  800513:	68 74 42 80 00       	push   $0x804274
  800518:	e8 8d 0d 00 00       	call   8012aa <_panic>


		//NEW
		//Filling the remaining size of user heap
		freeFrames = sys_calculate_free_frames() ;
  80051d:	e8 96 23 00 00       	call   8028b8 <sys_calculate_free_frames>
  800522:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800525:	e8 2e 24 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  80052a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		uint32 remainingSpaceInUHeap = (USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega;
  80052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d0                	add    %edx,%eax
  80053a:	01 c0                	add    %eax,%eax
  80053c:	f7 d8                	neg    %eax
  80053e:	05 00 00 00 20       	add    $0x20000000,%eax
  800543:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(remainingSpaceInUHeap - kilo);
  800546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800549:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054c:	29 c2                	sub    %eax,%edx
  80054e:	89 d0                	mov    %edx,%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 31 1f 00 00       	call   80248a <malloc>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80055f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800562:	89 c1                	mov    %eax,%ecx
  800564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800567:	89 d0                	mov    %edx,%eax
  800569:	01 c0                	add    %eax,%eax
  80056b:	01 d0                	add    %edx,%eax
  80056d:	01 c0                	add    %eax,%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	01 c0                	add    %eax,%eax
  800573:	05 00 00 00 80       	add    $0x80000000,%eax
  800578:	39 c1                	cmp    %eax,%ecx
  80057a:	74 14                	je     800590 <_main+0x558>
  80057c:	83 ec 04             	sub    $0x4,%esp
  80057f:	68 44 42 80 00       	push   $0x804244
  800584:	6a 5a                	push   $0x5a
  800586:	68 74 42 80 00       	push   $0x804274
  80058b:	e8 1a 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800590:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800593:	e8 20 23 00 00       	call   8028b8 <sys_calculate_free_frames>
  800598:	29 c3                	sub    %eax,%ebx
  80059a:	89 d8                	mov    %ebx,%eax
  80059c:	83 f8 7c             	cmp    $0x7c,%eax
  80059f:	74 14                	je     8005b5 <_main+0x57d>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 8c 42 80 00       	push   $0x80428c
  8005a9:	6a 5c                	push   $0x5c
  8005ab:	68 74 42 80 00       	push   $0x804274
  8005b0:	e8 f5 0c 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005b5:	e8 9e 23 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  8005ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8005bd:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 f8 42 80 00       	push   $0x8042f8
  8005cc:	6a 5d                	push   $0x5d
  8005ce:	68 74 42 80 00       	push   $0x804274
  8005d3:	e8 d2 0c 00 00       	call   8012aa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 db 22 00 00       	call   8028b8 <sys_calculate_free_frames>
  8005dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e0:	e8 73 23 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8005e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	50                   	push   %eax
  8005ef:	e8 11 1f 00 00       	call   802505 <free>
  8005f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005f7:	e8 5c 23 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  8005fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
  800601:	89 d0                	mov    %edx,%eax
  800603:	3d 00 01 00 00       	cmp    $0x100,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 28 43 80 00       	push   $0x804328
  800612:	6a 68                	push   $0x68
  800614:	68 74 42 80 00       	push   $0x804274
  800619:	e8 8c 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80061e:	e8 95 22 00 00       	call   8028b8 <sys_calculate_free_frames>
  800623:	89 c2                	mov    %eax,%edx
  800625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	74 14                	je     800640 <_main+0x608>
  80062c:	83 ec 04             	sub    $0x4,%esp
  80062f:	68 64 43 80 00       	push   $0x804364
  800634:	6a 69                	push   $0x69
  800636:	68 74 42 80 00       	push   $0x804274
  80063b:	e8 6a 0c 00 00       	call   8012aa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800640:	e8 73 22 00 00       	call   8028b8 <sys_calculate_free_frames>
  800645:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800648:	e8 0b 23 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800650:	8b 45 90             	mov    -0x70(%ebp),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	50                   	push   %eax
  800657:	e8 a9 1e 00 00       	call   802505 <free>
  80065c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80065f:	e8 f4 22 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800667:	29 c2                	sub    %eax,%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800670:	74 14                	je     800686 <_main+0x64e>
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	68 28 43 80 00       	push   $0x804328
  80067a:	6a 70                	push   $0x70
  80067c:	68 74 42 80 00       	push   $0x804274
  800681:	e8 24 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800686:	e8 2d 22 00 00       	call   8028b8 <sys_calculate_free_frames>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 64 43 80 00       	push   $0x804364
  80069c:	6a 71                	push   $0x71
  80069e:	68 74 42 80 00       	push   $0x804274
  8006a3:	e8 02 0c 00 00       	call   8012aa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006a8:	e8 0b 22 00 00       	call   8028b8 <sys_calculate_free_frames>
  8006ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006b0:	e8 a3 22 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8006b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	50                   	push   %eax
  8006bf:	e8 41 1e 00 00       	call   802505 <free>
  8006c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006c7:	e8 8c 22 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  8006cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cf:	29 c2                	sub    %eax,%edx
  8006d1:	89 d0                	mov    %edx,%eax
  8006d3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006d8:	74 14                	je     8006ee <_main+0x6b6>
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	68 28 43 80 00       	push   $0x804328
  8006e2:	6a 78                	push   $0x78
  8006e4:	68 74 42 80 00       	push   $0x804274
  8006e9:	e8 bc 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006ee:	e8 c5 21 00 00       	call   8028b8 <sys_calculate_free_frames>
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f8:	39 c2                	cmp    %eax,%edx
  8006fa:	74 14                	je     800710 <_main+0x6d8>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 64 43 80 00       	push   $0x804364
  800704:	6a 79                	push   $0x79
  800706:	68 74 42 80 00       	push   $0x804274
  80070b:	e8 9a 0b 00 00       	call   8012aa <_panic>

		//NEW
		//free the latest Hole (the big one)
		freeFrames = sys_calculate_free_frames() ;
  800710:	e8 a3 21 00 00       	call   8028b8 <sys_calculate_free_frames>
  800715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800718:	e8 3b 22 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  800720:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	50                   	push   %eax
  800727:	e8 d9 1d 00 00       	call   802505 <free>
  80072c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
  80072f:	e8 24 22 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
  800739:	89 d0                	mov    %edx,%eax
  80073b:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  800740:	74 17                	je     800759 <_main+0x721>
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	68 28 43 80 00       	push   $0x804328
  80074a:	68 81 00 00 00       	push   $0x81
  80074f:	68 74 42 80 00       	push   $0x804274
  800754:	e8 51 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800759:	e8 5a 21 00 00       	call   8028b8 <sys_calculate_free_frames>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800763:	39 c2                	cmp    %eax,%edx
  800765:	74 17                	je     80077e <_main+0x746>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 64 43 80 00       	push   $0x804364
  80076f:	68 82 00 00 00       	push   $0x82
  800774:	68 74 42 80 00       	push   $0x804274
  800779:	e8 2c 0b 00 00       	call   8012aa <_panic>
	}
	int cnt = 0;
  80077e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800785:	e8 2e 21 00 00       	call   8028b8 <sys_calculate_free_frames>
  80078a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80078d:	e8 c6 21 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(512*kilo - kilo);
  800795:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800798:	89 d0                	mov    %edx,%eax
  80079a:	c1 e0 09             	shl    $0x9,%eax
  80079d:	29 d0                	sub    %edx,%eax
  80079f:	83 ec 0c             	sub    $0xc,%esp
  8007a2:	50                   	push   %eax
  8007a3:	e8 e2 1c 00 00       	call   80248a <malloc>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8007ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8007b1:	89 c2                	mov    %eax,%edx
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 44 42 80 00       	push   $0x804244
  8007c7:	68 8e 00 00 00       	push   $0x8e
  8007cc:	68 74 42 80 00       	push   $0x804274
  8007d1:	e8 d4 0a 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8007d6:	e8 dd 20 00 00       	call   8028b8 <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 8c 42 80 00       	push   $0x80428c
  8007ec:	68 90 00 00 00       	push   $0x90
  8007f1:	68 74 42 80 00       	push   $0x804274
  8007f6:	e8 af 0a 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  8007fb:	e8 58 21 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800800:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800803:	3d 80 00 00 00       	cmp    $0x80,%eax
  800808:	74 17                	je     800821 <_main+0x7e9>
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 f8 42 80 00       	push   $0x8042f8
  800812:	68 91 00 00 00       	push   $0x91
  800817:	68 74 42 80 00       	push   $0x804274
  80081c:	e8 89 0a 00 00       	call   8012aa <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[9];
  800821:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800824:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int lastIndexOfInt1 = ((512)*kilo)/sizeof(int) - 1;
  800827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082a:	c1 e0 09             	shl    $0x9,%eax
  80082d:	c1 e8 02             	shr    $0x2,%eax
  800830:	48                   	dec    %eax
  800831:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		int i = 0;
  800834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800842:	eb 17                	jmp    80085b <_main+0x823>
		{
			intArr[i] = i ;
  800844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800847:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80084e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800851:	01 c2                	add    %eax,%edx
  800853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800856:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800858:	ff 45 f4             	incl   -0xc(%ebp)
  80085b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80085f:	7e e3                	jle    800844 <_main+0x80c>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800861:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800867:	eb 17                	jmp    800880 <_main+0x848>
		{
			intArr[i] = i ;
  800869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800873:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800876:	01 c2                	add    %eax,%edx
  800878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  80087d:	ff 4d f4             	decl   -0xc(%ebp)
  800880:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800883:	83 e8 64             	sub    $0x64,%eax
  800886:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800889:	7c de                	jl     800869 <_main+0x831>
		{
			intArr[i] = i ;
		}

		//Reallocate it [expanded in the same place]
		freeFrames = sys_calculate_free_frames() ;
  80088b:	e8 28 20 00 00       	call   8028b8 <sys_calculate_free_frames>
  800890:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800893:	e8 c0 20 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 512*kilo + 256*kilo - kilo);
  80089b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80089e:	89 d0                	mov    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d0                	add    %edx,%eax
  8008a4:	c1 e0 08             	shl    $0x8,%eax
  8008a7:	29 d0                	sub    %edx,%eax
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	52                   	push   %edx
  8008b2:	50                   	push   %eax
  8008b3:	e8 7e 1e 00 00       	call   802736 <realloc>
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the re-allocated space... ");
  8008be:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008c1:	89 c2                	mov    %eax,%edx
  8008c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 b0 43 80 00       	push   $0x8043b0
  8008d7:	68 ae 00 00 00       	push   $0xae
  8008dc:	68 74 42 80 00       	push   $0x804274
  8008e1:	e8 c4 09 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008e6:	e8 cd 1f 00 00       	call   8028b8 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 e4 43 80 00       	push   $0x8043e4
  8008fc:	68 b0 00 00 00       	push   $0xb0
  800901:	68 74 42 80 00       	push   $0x804274
  800906:	e8 9f 09 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are re-allocated in PageFile");
  80090b:	e8 48 20 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800910:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800913:	83 f8 40             	cmp    $0x40,%eax
  800916:	74 17                	je     80092f <_main+0x8f7>
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 54 44 80 00       	push   $0x804454
  800920:	68 b1 00 00 00       	push   $0xb1
  800925:	68 74 42 80 00       	push   $0x804274
  80092a:	e8 7b 09 00 00       	call   8012aa <_panic>


		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;
  80092f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800932:	89 d0                	mov    %edx,%eax
  800934:	01 c0                	add    %eax,%eax
  800936:	01 d0                	add    %edx,%eax
  800938:	c1 e0 08             	shl    $0x8,%eax
  80093b:	c1 e8 02             	shr    $0x2,%eax
  80093e:	48                   	dec    %eax
  80093f:	89 45 d0             	mov    %eax,-0x30(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800945:	40                   	inc    %eax
  800946:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800949:	eb 17                	jmp    800962 <_main+0x92a>
		{
			intArr[i] = i;
  80094b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800958:	01 c2                	add    %eax,%edx
  80095a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095d:	89 02                	mov    %eax,(%edx)
		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  80095f:	ff 45 f4             	incl   -0xc(%ebp)
  800962:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800965:	83 c0 65             	add    $0x65,%eax
  800968:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80096b:	7f de                	jg     80094b <_main+0x913>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80096d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800970:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800973:	eb 17                	jmp    80098c <_main+0x954>
		{
			intArr[i] = i;
  800975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800978:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800982:	01 c2                	add    %eax,%edx
  800984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800987:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800989:	ff 4d f4             	decl   -0xc(%ebp)
  80098c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80098f:	83 e8 64             	sub    $0x64,%eax
  800992:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800995:	7c de                	jl     800975 <_main+0x93d>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80099e:	eb 30                	jmp    8009d0 <_main+0x998>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ad:	01 d0                	add    %edx,%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009b4:	74 17                	je     8009cd <_main+0x995>
  8009b6:	83 ec 04             	sub    $0x4,%esp
  8009b9:	68 88 44 80 00       	push   $0x804488
  8009be:	68 c6 00 00 00       	push   $0xc6
  8009c3:	68 74 42 80 00       	push   $0x804274
  8009c8:	e8 dd 08 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  8009cd:	ff 45 f4             	incl   -0xc(%ebp)
  8009d0:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  8009d4:	7e ca                	jle    8009a0 <_main+0x968>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  8009d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8009dc:	eb 30                	jmp    800a0e <_main+0x9d6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009eb:	01 d0                	add    %edx,%eax
  8009ed:	8b 00                	mov    (%eax),%eax
  8009ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009f2:	74 17                	je     800a0b <_main+0x9d3>
  8009f4:	83 ec 04             	sub    $0x4,%esp
  8009f7:	68 88 44 80 00       	push   $0x804488
  8009fc:	68 cc 00 00 00       	push   $0xcc
  800a01:	68 74 42 80 00       	push   $0x804274
  800a06:	e8 9f 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800a0b:	ff 4d f4             	decl   -0xc(%ebp)
  800a0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a11:	83 e8 64             	sub    $0x64,%eax
  800a14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a17:	7c c5                	jl     8009de <_main+0x9a6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1c:	40                   	inc    %eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a20:	eb 30                	jmp    800a52 <_main+0xa1a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a2f:	01 d0                	add    %edx,%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 88 44 80 00       	push   $0x804488
  800a40:	68 d2 00 00 00       	push   $0xd2
  800a45:	68 74 42 80 00       	push   $0x804274
  800a4a:	e8 5b 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a4f:	ff 45 f4             	incl   -0xc(%ebp)
  800a52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a55:	83 c0 65             	add    $0x65,%eax
  800a58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a5b:	7f c5                	jg     800a22 <_main+0x9ea>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a63:	eb 30                	jmp    800a95 <_main+0xa5d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a72:	01 d0                	add    %edx,%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a79:	74 17                	je     800a92 <_main+0xa5a>
  800a7b:	83 ec 04             	sub    $0x4,%esp
  800a7e:	68 88 44 80 00       	push   $0x804488
  800a83:	68 d8 00 00 00       	push   $0xd8
  800a88:	68 74 42 80 00       	push   $0x804274
  800a8d:	e8 18 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a92:	ff 4d f4             	decl   -0xc(%ebp)
  800a95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a98:	83 e8 64             	sub    $0x64,%eax
  800a9b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a9e:	7c c5                	jl     800a65 <_main+0xa2d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800aa0:	e8 13 1e 00 00       	call   8028b8 <sys_calculate_free_frames>
  800aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800aa8:	e8 ab 1e 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800ab0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	50                   	push   %eax
  800ab7:	e8 49 1a 00 00       	call   802505 <free>
  800abc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800abf:	e8 94 1e 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800ad0:	74 17                	je     800ae9 <_main+0xab1>
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	68 c0 44 80 00       	push   $0x8044c0
  800ada:	68 e0 00 00 00       	push   $0xe0
  800adf:	68 74 42 80 00       	push   $0x804274
  800ae4:	e8 c1 07 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ae9:	e8 ca 1d 00 00       	call   8028b8 <sys_calculate_free_frames>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	83 f8 05             	cmp    $0x5,%eax
  800afa:	74 17                	je     800b13 <_main+0xadb>
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	68 64 43 80 00       	push   $0x804364
  800b04:	68 e1 00 00 00       	push   $0xe1
  800b09:	68 74 42 80 00       	push   $0x804274
  800b0e:	e8 97 07 00 00       	call   8012aa <_panic>

		vcprintf("\b\b\b40%", NULL);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	6a 00                	push   $0x0
  800b18:	68 14 45 80 00       	push   $0x804514
  800b1d:	e8 d1 09 00 00       	call   8014f3 <vcprintf>
  800b22:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800b25:	e8 8e 1d 00 00       	call   8028b8 <sys_calculate_free_frames>
  800b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b2d:	e8 26 1e 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(1*Mega + 512*kilo - kilo);
  800b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b38:	c1 e0 09             	shl    $0x9,%eax
  800b3b:	89 c2                	mov    %eax,%edx
  800b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800b45:	83 ec 0c             	sub    $0xc,%esp
  800b48:	50                   	push   %eax
  800b49:	e8 3c 19 00 00       	call   80248a <malloc>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800b54:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5c:	c1 e0 02             	shl    $0x2,%eax
  800b5f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b64:	39 c2                	cmp    %eax,%edx
  800b66:	74 17                	je     800b7f <_main+0xb47>
  800b68:	83 ec 04             	sub    $0x4,%esp
  800b6b:	68 44 42 80 00       	push   $0x804244
  800b70:	68 eb 00 00 00       	push   $0xeb
  800b75:	68 74 42 80 00       	push   $0x804274
  800b7a:	e8 2b 07 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b7f:	e8 34 1d 00 00       	call   8028b8 <sys_calculate_free_frames>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	74 17                	je     800ba4 <_main+0xb6c>
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	68 8c 42 80 00       	push   $0x80428c
  800b95:	68 ed 00 00 00       	push   $0xed
  800b9a:	68 74 42 80 00       	push   $0x804274
  800b9f:	e8 06 07 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800ba4:	e8 af 1d 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800ba9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800bac:	3d 80 01 00 00       	cmp    $0x180,%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 f8 42 80 00       	push   $0x8042f8
  800bbb:	68 ee 00 00 00       	push   $0xee
  800bc0:	68 74 42 80 00       	push   $0x804274
  800bc5:	e8 e0 06 00 00       	call   8012aa <_panic>

		//Fill it with data
		intArr = (int*) ptr_allocations[9];
  800bca:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800bcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c1 e0 09             	shl    $0x9,%eax
  800bd6:	89 c2                	mov    %eax,%edx
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	01 d0                	add    %edx,%eax
  800bdd:	c1 e8 02             	shr    $0x2,%eax
  800be0:	48                   	dec    %eax
  800be1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		i = 0;
  800be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800bf2:	eb 17                	jmp    800c0b <_main+0xbd3>
		{
			intArr[i] = i ;
  800bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c01:	01 c2                	add    %eax,%edx
  800c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c06:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800c08:	ff 45 f4             	incl   -0xc(%ebp)
  800c0b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800c0f:	7e e3                	jle    800bf4 <_main+0xbbc>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c17:	eb 17                	jmp    800c30 <_main+0xbf8>
		{
			intArr[i] = i ;
  800c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c26:	01 c2                	add    %eax,%edx
  800c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c2d:	ff 4d f4             	decl   -0xc(%ebp)
  800c30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c33:	83 e8 64             	sub    $0x64,%eax
  800c36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800c39:	7c de                	jl     800c19 <_main+0xbe1>
		{
			intArr[i] = i ;
		}

		//Reallocate it to 2.5 MB [should be moved to next hole]
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 78 1c 00 00       	call   8028b8 <sys_calculate_free_frames>
  800c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 10 1d 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 1*Mega + 512*kilo + 1*Mega - kilo);
  800c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4e:	c1 e0 09             	shl    $0x9,%eax
  800c51:	89 c2                	mov    %eax,%edx
  800c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c56:	01 c2                	add    %eax,%edx
  800c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5b:	01 d0                	add    %edx,%eax
  800c5d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800c60:	89 c2                	mov    %eax,%edx
  800c62:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	52                   	push   %edx
  800c69:	50                   	push   %eax
  800c6a:	e8 c7 1a 00 00       	call   802736 <realloc>
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800c75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7d:	c1 e0 03             	shl    $0x3,%eax
  800c80:	05 00 00 00 80       	add    $0x80000000,%eax
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 b0 43 80 00       	push   $0x8043b0
  800c91:	68 07 01 00 00       	push   $0x107
  800c96:	68 74 42 80 00       	push   $0x804274
  800c9b:	e8 0a 06 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");

		//if((sys_calculate_free_frames() - freeFrames) != 3) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  800ca0:	e8 b3 1c 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800ca5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cad:	74 17                	je     800cc6 <_main+0xc8e>
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	68 54 44 80 00       	push   $0x804454
  800cb7:	68 0b 01 00 00       	push   $0x10b
  800cbc:	68 74 42 80 00       	push   $0x804274
  800cc1:	e8 e4 05 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (2*Mega + 512*kilo)/sizeof(int) - 1;
  800cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc9:	c1 e0 08             	shl    $0x8,%eax
  800ccc:	89 c2                	mov    %eax,%edx
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	c1 e8 02             	shr    $0x2,%eax
  800cd8:	48                   	dec    %eax
  800cd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[9];
  800cdc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800cdf:	89 45 d8             	mov    %eax,-0x28(%ebp)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ce5:	40                   	inc    %eax
  800ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ce9:	eb 17                	jmp    800d02 <_main+0xcca>
		{
			intArr[i] = i;
  800ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cf5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cf8:	01 c2                	add    %eax,%edx
  800cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfd:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800cff:	ff 45 f4             	incl   -0xc(%ebp)
  800d02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d05:	83 c0 65             	add    $0x65,%eax
  800d08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d0b:	7f de                	jg     800ceb <_main+0xcb3>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d13:	eb 17                	jmp    800d2c <_main+0xcf4>
		{
			intArr[i] = i;
  800d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d22:	01 c2                	add    %eax,%edx
  800d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d27:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d29:	ff 4d f4             	decl   -0xc(%ebp)
  800d2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d2f:	83 e8 64             	sub    $0x64,%eax
  800d32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d35:	7c de                	jl     800d15 <_main+0xcdd>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800d3e:	eb 30                	jmp    800d70 <_main+0xd38>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d54:	74 17                	je     800d6d <_main+0xd35>
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	68 88 44 80 00       	push   $0x804488
  800d5e:	68 22 01 00 00       	push   $0x122
  800d63:	68 74 42 80 00       	push   $0x804274
  800d68:	e8 3d 05 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
  800d70:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800d74:	7e ca                	jle    800d40 <_main+0xd08>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7c:	eb 30                	jmp    800dae <_main+0xd76>
		{
			if (intArr[i] != i)
  800d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d8b:	01 d0                	add    %edx,%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d92:	74 17                	je     800dab <_main+0xd73>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800d94:	83 ec 04             	sub    $0x4,%esp
  800d97:	68 88 44 80 00       	push   $0x804488
  800d9c:	68 2a 01 00 00       	push   $0x12a
  800da1:	68 74 42 80 00       	push   $0x804274
  800da6:	e8 ff 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800dab:	ff 4d f4             	decl   -0xc(%ebp)
  800dae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db1:	83 e8 64             	sub    $0x64,%eax
  800db4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800db7:	7c c5                	jl     800d7e <_main+0xd46>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dbc:	40                   	inc    %eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dc0:	eb 30                	jmp    800df2 <_main+0xdba>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dcc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dcf:	01 d0                	add    %edx,%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dd6:	74 17                	je     800def <_main+0xdb7>
  800dd8:	83 ec 04             	sub    $0x4,%esp
  800ddb:	68 88 44 80 00       	push   $0x804488
  800de0:	68 31 01 00 00       	push   $0x131
  800de5:	68 74 42 80 00       	push   $0x804274
  800dea:	e8 bb 04 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800def:	ff 45 f4             	incl   -0xc(%ebp)
  800df2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800df5:	83 c0 65             	add    $0x65,%eax
  800df8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dfb:	7f c5                	jg     800dc2 <_main+0xd8a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800dfd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e03:	eb 30                	jmp    800e35 <_main+0xdfd>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e12:	01 d0                	add    %edx,%eax
  800e14:	8b 00                	mov    (%eax),%eax
  800e16:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e19:	74 17                	je     800e32 <_main+0xdfa>
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	68 88 44 80 00       	push   $0x804488
  800e23:	68 37 01 00 00       	push   $0x137
  800e28:	68 74 42 80 00       	push   $0x804274
  800e2d:	e8 78 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800e32:	ff 4d f4             	decl   -0xc(%ebp)
  800e35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e38:	83 e8 64             	sub    $0x64,%eax
  800e3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e3e:	7c c5                	jl     800e05 <_main+0xdcd>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800e40:	e8 73 1a 00 00       	call   8028b8 <sys_calculate_free_frames>
  800e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e48:	e8 0b 1b 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800e50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	e8 a9 16 00 00       	call   802505 <free>
  800e5c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e5f:	e8 f4 1a 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	3d 80 02 00 00       	cmp    $0x280,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 c0 44 80 00       	push   $0x8044c0
  800e7a:	68 40 01 00 00       	push   $0x140
  800e7f:	68 74 42 80 00       	push   $0x804274
  800e84:	e8 21 04 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b70%", NULL);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	6a 00                	push   $0x0
  800e8e:	68 1b 45 80 00       	push   $0x80451b
  800e93:	e8 5b 06 00 00       	call   8014f3 <vcprintf>
  800e98:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate that's not fit in the same location*/

		//Fill it with data
		intArr = (int*) ptr_allocations[0];
  800e9b:	8b 45 80             	mov    -0x80(%ebp),%eax
  800e9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	c1 e8 02             	shr    $0x2,%eax
  800ea7:	48                   	dec    %eax
  800ea8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		i = 0;
  800eab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800eb9:	eb 17                	jmp    800ed2 <_main+0xe9a>
		{
			intArr[i] = i ;
  800ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ec5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ec8:	01 c2                	add    %eax,%edx
  800eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecd:	89 02                	mov    %eax,(%edx)

		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800ecf:	ff 45 f4             	incl   -0xc(%ebp)
  800ed2:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800ed6:	7e e3                	jle    800ebb <_main+0xe83>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ed8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ede:	eb 17                	jmp    800ef7 <_main+0xebf>
		{
			intArr[i] = i ;
  800ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800eed:	01 c2                	add    %eax,%edx
  800eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ef4:	ff 4d f4             	decl   -0xc(%ebp)
  800ef7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800efa:	83 e8 64             	sub    $0x64,%eax
  800efd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f00:	7c de                	jl     800ee0 <_main+0xea8>
			intArr[i] = i ;
		}


		//Reallocate it to 4 MB [should be moved to last hole]
		freeFrames = sys_calculate_free_frames() ;
  800f02:	e8 b1 19 00 00       	call   8028b8 <sys_calculate_free_frames>
  800f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f0a:	e8 49 1a 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 1*Mega + 3*Mega - kilo);
  800f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f15:	c1 e0 02             	shl    $0x2,%eax
  800f18:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800f1b:	89 c2                	mov    %eax,%edx
  800f1d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	52                   	push   %edx
  800f24:	50                   	push   %eax
  800f25:	e8 0c 18 00 00       	call   802736 <realloc>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	89 45 80             	mov    %eax,-0x80(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the re-allocated space... ");
  800f30:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f33:	89 c1                	mov    %eax,%ecx
  800f35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f38:	89 d0                	mov    %edx,%eax
  800f3a:	01 c0                	add    %eax,%eax
  800f3c:	01 d0                	add    %edx,%eax
  800f3e:	01 c0                	add    %eax,%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	01 c0                	add    %eax,%eax
  800f44:	05 00 00 00 80       	add    $0x80000000,%eax
  800f49:	39 c1                	cmp    %eax,%ecx
  800f4b:	74 17                	je     800f64 <_main+0xf2c>
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	68 b0 43 80 00       	push   $0x8043b0
  800f55:	68 60 01 00 00       	push   $0x160
  800f5a:	68 74 42 80 00       	push   $0x804274
  800f5f:	e8 46 03 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are re-allocated in PageFile");
  800f64:	e8 ef 19 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  800f69:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f6c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800f71:	74 17                	je     800f8a <_main+0xf52>
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 54 44 80 00       	push   $0x804454
  800f7b:	68 63 01 00 00       	push   $0x163
  800f80:	68 74 42 80 00       	push   $0x804274
  800f85:	e8 20 03 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
  800f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8d:	c1 e0 02             	shl    $0x2,%eax
  800f90:	c1 e8 02             	shr    $0x2,%eax
  800f93:	48                   	dec    %eax
  800f94:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[0];
  800f97:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f9a:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fa0:	40                   	inc    %eax
  800fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa4:	eb 17                	jmp    800fbd <_main+0xf85>
		{
			intArr[i] = i;
  800fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fb3:	01 c2                	add    %eax,%edx
  800fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb8:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[0];

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800fba:	ff 45 f4             	incl   -0xc(%ebp)
  800fbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fc0:	83 c0 65             	add    $0x65,%eax
  800fc3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fc6:	7f de                	jg     800fa6 <_main+0xf6e>
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fce:	eb 17                	jmp    800fe7 <_main+0xfaf>
		{
			intArr[i] = i;
  800fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fdd:	01 c2                	add    %eax,%edx
  800fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fe4:	ff 4d f4             	decl   -0xc(%ebp)
  800fe7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fea:	83 e8 64             	sub    $0x64,%eax
  800fed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff0:	7c de                	jl     800fd0 <_main+0xf98>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800ff9:	eb 30                	jmp    80102b <_main+0xff3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801005:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80100f:	74 17                	je     801028 <_main+0xff0>
  801011:	83 ec 04             	sub    $0x4,%esp
  801014:	68 88 44 80 00       	push   $0x804488
  801019:	68 79 01 00 00       	push   $0x179
  80101e:	68 74 42 80 00       	push   $0x804274
  801023:	e8 82 02 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  801028:	ff 45 f4             	incl   -0xc(%ebp)
  80102b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80102f:	7e ca                	jle    800ffb <_main+0xfc3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801031:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801037:	eb 30                	jmp    801069 <_main+0x1031>
		{
			if (intArr[i] != i)
  801039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801043:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	8b 00                	mov    (%eax),%eax
  80104a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80104d:	74 17                	je     801066 <_main+0x102e>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  80104f:	83 ec 04             	sub    $0x4,%esp
  801052:	68 88 44 80 00       	push   $0x804488
  801057:	68 81 01 00 00       	push   $0x181
  80105c:	68 74 42 80 00       	push   $0x804274
  801061:	e8 44 02 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801066:	ff 4d f4             	decl   -0xc(%ebp)
  801069:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80106c:	83 e8 64             	sub    $0x64,%eax
  80106f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801072:	7c c5                	jl     801039 <_main+0x1001>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  801074:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801077:	40                   	inc    %eax
  801078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107b:	eb 30                	jmp    8010ad <_main+0x1075>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80107d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801080:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801087:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80108a:	01 d0                	add    %edx,%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801091:	74 17                	je     8010aa <_main+0x1072>
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	68 88 44 80 00       	push   $0x804488
  80109b:	68 88 01 00 00       	push   $0x188
  8010a0:	68 74 42 80 00       	push   $0x804274
  8010a5:	e8 00 02 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  8010aa:	ff 45 f4             	incl   -0xc(%ebp)
  8010ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010b0:	83 c0 65             	add    $0x65,%eax
  8010b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010b6:	7f c5                	jg     80107d <_main+0x1045>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010be:	eb 30                	jmp    8010f0 <_main+0x10b8>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d4:	74 17                	je     8010ed <_main+0x10b5>
  8010d6:	83 ec 04             	sub    $0x4,%esp
  8010d9:	68 88 44 80 00       	push   $0x804488
  8010de:	68 8e 01 00 00       	push   $0x18e
  8010e3:	68 74 42 80 00       	push   $0x804274
  8010e8:	e8 bd 01 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010ed:	ff 4d f4             	decl   -0xc(%ebp)
  8010f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010f3:	83 e8 64             	sub    $0x64,%eax
  8010f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010f9:	7c c5                	jl     8010c0 <_main+0x1088>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  8010fb:	e8 b8 17 00 00       	call   8028b8 <sys_calculate_free_frames>
  801100:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801103:	e8 50 18 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  801108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[0]);
  80110b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	e8 ee 13 00 00       	call   802505 <free>
  801117:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  80111a:	e8 39 18 00 00       	call   802958 <sys_pf_calculate_allocated_pages>
  80111f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112b:	74 17                	je     801144 <_main+0x110c>
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 c0 44 80 00       	push   $0x8044c0
  801135:	68 96 01 00 00       	push   $0x196
  80113a:	68 74 42 80 00       	push   $0x804274
  80113f:	e8 66 01 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 2) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 00                	push   $0x0
  801149:	68 22 45 80 00       	push   $0x804522
  80114e:	e8 a0 03 00 00       	call   8014f3 <vcprintf>
  801153:	83 c4 10             	add    $0x10,%esp
	}

	cprintf("Congratulations!! test realloc [1] completed successfully.\n");
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 2c 45 80 00       	push   $0x80452c
  80115e:	e8 fb 03 00 00       	call   80155e <cprintf>
  801163:	83 c4 10             	add    $0x10,%esp

	return;
  801166:	90                   	nop
}
  801167:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116a:	5b                   	pop    %ebx
  80116b:	5f                   	pop    %edi
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801174:	e8 1f 1a 00 00       	call   802b98 <sys_getenvindex>
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80117c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	c1 e0 03             	shl    $0x3,%eax
  801184:	01 d0                	add    %edx,%eax
  801186:	01 c0                	add    %eax,%eax
  801188:	01 d0                	add    %edx,%eax
  80118a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801191:	01 d0                	add    %edx,%eax
  801193:	c1 e0 04             	shl    $0x4,%eax
  801196:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80119b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8011a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8011a5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0f                	je     8011be <libmain+0x50>
		binaryname = myEnv->prog_name;
  8011af:	a1 20 50 80 00       	mov    0x805020,%eax
  8011b4:	05 5c 05 00 00       	add    $0x55c,%eax
  8011b9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c2:	7e 0a                	jle    8011ce <libmain+0x60>
		binaryname = argv[0];
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8011ce:	83 ec 08             	sub    $0x8,%esp
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	ff 75 08             	pushl  0x8(%ebp)
  8011d7:	e8 5c ee ff ff       	call   800038 <_main>
  8011dc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8011df:	e8 c1 17 00 00       	call   8029a5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	68 80 45 80 00       	push   $0x804580
  8011ec:	e8 6d 03 00 00       	call   80155e <cprintf>
  8011f1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8011f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8011f9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8011ff:	a1 20 50 80 00       	mov    0x805020,%eax
  801204:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	52                   	push   %edx
  80120e:	50                   	push   %eax
  80120f:	68 a8 45 80 00       	push   $0x8045a8
  801214:	e8 45 03 00 00       	call   80155e <cprintf>
  801219:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80121c:	a1 20 50 80 00       	mov    0x805020,%eax
  801221:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  801227:	a1 20 50 80 00       	mov    0x805020,%eax
  80122c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  801232:	a1 20 50 80 00       	mov    0x805020,%eax
  801237:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80123d:	51                   	push   %ecx
  80123e:	52                   	push   %edx
  80123f:	50                   	push   %eax
  801240:	68 d0 45 80 00       	push   $0x8045d0
  801245:	e8 14 03 00 00       	call   80155e <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80124d:	a1 20 50 80 00       	mov    0x805020,%eax
  801252:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	50                   	push   %eax
  80125c:	68 28 46 80 00       	push   $0x804628
  801261:	e8 f8 02 00 00       	call   80155e <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	68 80 45 80 00       	push   $0x804580
  801271:	e8 e8 02 00 00       	call   80155e <cprintf>
  801276:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801279:	e8 41 17 00 00       	call   8029bf <sys_enable_interrupt>

	// exit gracefully
	exit();
  80127e:	e8 19 00 00 00       	call   80129c <exit>
}
  801283:	90                   	nop
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	6a 00                	push   $0x0
  801291:	e8 ce 18 00 00       	call   802b64 <sys_destroy_env>
  801296:	83 c4 10             	add    $0x10,%esp
}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <exit>:

void
exit(void)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012a2:	e8 23 19 00 00       	call   802bca <sys_exit_env>
}
  8012a7:	90                   	nop
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012b0:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b3:	83 c0 04             	add    $0x4,%eax
  8012b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012b9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	74 16                	je     8012d8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8012c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	50                   	push   %eax
  8012cb:	68 3c 46 80 00       	push   $0x80463c
  8012d0:	e8 89 02 00 00       	call   80155e <cprintf>
  8012d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8012d8:	a1 00 50 80 00       	mov    0x805000,%eax
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	50                   	push   %eax
  8012e4:	68 41 46 80 00       	push   $0x804641
  8012e9:	e8 70 02 00 00       	call   80155e <cprintf>
  8012ee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8012f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012fa:	50                   	push   %eax
  8012fb:	e8 f3 01 00 00       	call   8014f3 <vcprintf>
  801300:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	6a 00                	push   $0x0
  801308:	68 5d 46 80 00       	push   $0x80465d
  80130d:	e8 e1 01 00 00       	call   8014f3 <vcprintf>
  801312:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801315:	e8 82 ff ff ff       	call   80129c <exit>

	// should not return here
	while (1) ;
  80131a:	eb fe                	jmp    80131a <_panic+0x70>

0080131c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801322:	a1 20 50 80 00       	mov    0x805020,%eax
  801327:	8b 50 74             	mov    0x74(%eax),%edx
  80132a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132d:	39 c2                	cmp    %eax,%edx
  80132f:	74 14                	je     801345 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	68 60 46 80 00       	push   $0x804660
  801339:	6a 26                	push   $0x26
  80133b:	68 ac 46 80 00       	push   $0x8046ac
  801340:	e8 65 ff ff ff       	call   8012aa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80134c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801353:	e9 c2 00 00 00       	jmp    80141a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	8b 00                	mov    (%eax),%eax
  801369:	85 c0                	test   %eax,%eax
  80136b:	75 08                	jne    801375 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80136d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801370:	e9 a2 00 00 00       	jmp    801417 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801375:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80137c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801383:	eb 69                	jmp    8013ee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801385:	a1 20 50 80 00       	mov    0x805020,%eax
  80138a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	01 c0                	add    %eax,%eax
  801397:	01 d0                	add    %edx,%eax
  801399:	c1 e0 03             	shl    $0x3,%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8a 40 04             	mov    0x4(%eax),%al
  8013a1:	84 c0                	test   %al,%al
  8013a3:	75 46                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8013aa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013b3:	89 d0                	mov    %edx,%eax
  8013b5:	01 c0                	add    %eax,%eax
  8013b7:	01 d0                	add    %edx,%eax
  8013b9:	c1 e0 03             	shl    $0x3,%eax
  8013bc:	01 c8                	add    %ecx,%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8013cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	01 c8                	add    %ecx,%eax
  8013dc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013de:	39 c2                	cmp    %eax,%edx
  8013e0:	75 09                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8013e2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8013e9:	eb 12                	jmp    8013fd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013eb:	ff 45 e8             	incl   -0x18(%ebp)
  8013ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8013f3:	8b 50 74             	mov    0x74(%eax),%edx
  8013f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f9:	39 c2                	cmp    %eax,%edx
  8013fb:	77 88                	ja     801385 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8013fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801401:	75 14                	jne    801417 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	68 b8 46 80 00       	push   $0x8046b8
  80140b:	6a 3a                	push   $0x3a
  80140d:	68 ac 46 80 00       	push   $0x8046ac
  801412:	e8 93 fe ff ff       	call   8012aa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801417:	ff 45 f0             	incl   -0x10(%ebp)
  80141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801420:	0f 8c 32 ff ff ff    	jl     801358 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801426:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80142d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801434:	eb 26                	jmp    80145c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801436:	a1 20 50 80 00       	mov    0x805020,%eax
  80143b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801441:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801444:	89 d0                	mov    %edx,%eax
  801446:	01 c0                	add    %eax,%eax
  801448:	01 d0                	add    %edx,%eax
  80144a:	c1 e0 03             	shl    $0x3,%eax
  80144d:	01 c8                	add    %ecx,%eax
  80144f:	8a 40 04             	mov    0x4(%eax),%al
  801452:	3c 01                	cmp    $0x1,%al
  801454:	75 03                	jne    801459 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801456:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801459:	ff 45 e0             	incl   -0x20(%ebp)
  80145c:	a1 20 50 80 00       	mov    0x805020,%eax
  801461:	8b 50 74             	mov    0x74(%eax),%edx
  801464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801467:	39 c2                	cmp    %eax,%edx
  801469:	77 cb                	ja     801436 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801471:	74 14                	je     801487 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	68 0c 47 80 00       	push   $0x80470c
  80147b:	6a 44                	push   $0x44
  80147d:	68 ac 46 80 00       	push   $0x8046ac
  801482:	e8 23 fe ff ff       	call   8012aa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801487:	90                   	nop
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801490:	8b 45 0c             	mov    0xc(%ebp),%eax
  801493:	8b 00                	mov    (%eax),%eax
  801495:	8d 48 01             	lea    0x1(%eax),%ecx
  801498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149b:	89 0a                	mov    %ecx,(%edx)
  80149d:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a0:	88 d1                	mov    %dl,%cl
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014b3:	75 2c                	jne    8014e1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8014b5:	a0 24 50 80 00       	mov    0x805024,%al
  8014ba:	0f b6 c0             	movzbl %al,%eax
  8014bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c0:	8b 12                	mov    (%edx),%edx
  8014c2:	89 d1                	mov    %edx,%ecx
  8014c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c7:	83 c2 08             	add    $0x8,%edx
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	50                   	push   %eax
  8014ce:	51                   	push   %ecx
  8014cf:	52                   	push   %edx
  8014d0:	e8 22 13 00 00       	call   8027f7 <sys_cputs>
  8014d5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8b 40 04             	mov    0x4(%eax),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	89 50 04             	mov    %edx,0x4(%eax)
}
  8014f0:	90                   	nop
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8014fc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801503:	00 00 00 
	b.cnt = 0;
  801506:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80150d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	ff 75 08             	pushl  0x8(%ebp)
  801516:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	68 8a 14 80 00       	push   $0x80148a
  801522:	e8 11 02 00 00       	call   801738 <vprintfmt>
  801527:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80152a:	a0 24 50 80 00       	mov    0x805024,%al
  80152f:	0f b6 c0             	movzbl %al,%eax
  801532:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801538:	83 ec 04             	sub    $0x4,%esp
  80153b:	50                   	push   %eax
  80153c:	52                   	push   %edx
  80153d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801543:	83 c0 08             	add    $0x8,%eax
  801546:	50                   	push   %eax
  801547:	e8 ab 12 00 00       	call   8027f7 <sys_cputs>
  80154c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80154f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801556:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <cprintf>:

int cprintf(const char *fmt, ...) {
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801564:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80156b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	ff 75 f4             	pushl  -0xc(%ebp)
  80157a:	50                   	push   %eax
  80157b:	e8 73 ff ff ff       	call   8014f3 <vcprintf>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801591:	e8 0f 14 00 00       	call   8029a5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801596:	8d 45 0c             	lea    0xc(%ebp),%eax
  801599:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a5:	50                   	push   %eax
  8015a6:	e8 48 ff ff ff       	call   8014f3 <vcprintf>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8015b1:	e8 09 14 00 00       	call   8029bf <sys_enable_interrupt>
	return cnt;
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	53                   	push   %ebx
  8015bf:	83 ec 14             	sub    $0x14,%esp
  8015c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015ce:	8b 45 18             	mov    0x18(%ebp),%eax
  8015d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015d9:	77 55                	ja     801630 <printnum+0x75>
  8015db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015de:	72 05                	jb     8015e5 <printnum+0x2a>
  8015e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e3:	77 4b                	ja     801630 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015e5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8015e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8015ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f3:	52                   	push   %edx
  8015f4:	50                   	push   %eax
  8015f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8015fb:	e8 b4 29 00 00       	call   803fb4 <__udivdi3>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	ff 75 20             	pushl  0x20(%ebp)
  801609:	53                   	push   %ebx
  80160a:	ff 75 18             	pushl  0x18(%ebp)
  80160d:	52                   	push   %edx
  80160e:	50                   	push   %eax
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	ff 75 08             	pushl  0x8(%ebp)
  801615:	e8 a1 ff ff ff       	call   8015bb <printnum>
  80161a:	83 c4 20             	add    $0x20,%esp
  80161d:	eb 1a                	jmp    801639 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	ff 75 0c             	pushl  0xc(%ebp)
  801625:	ff 75 20             	pushl  0x20(%ebp)
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	ff d0                	call   *%eax
  80162d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801630:	ff 4d 1c             	decl   0x1c(%ebp)
  801633:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801637:	7f e6                	jg     80161f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801639:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80163c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801647:	53                   	push   %ebx
  801648:	51                   	push   %ecx
  801649:	52                   	push   %edx
  80164a:	50                   	push   %eax
  80164b:	e8 74 2a 00 00       	call   8040c4 <__umoddi3>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	05 74 49 80 00       	add    $0x804974,%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f be c0             	movsbl %al,%eax
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	50                   	push   %eax
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	ff d0                	call   *%eax
  801669:	83 c4 10             	add    $0x10,%esp
}
  80166c:	90                   	nop
  80166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801675:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801679:	7e 1c                	jle    801697 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	8b 00                	mov    (%eax),%eax
  801680:	8d 50 08             	lea    0x8(%eax),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	89 10                	mov    %edx,(%eax)
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	83 e8 08             	sub    $0x8,%eax
  801690:	8b 50 04             	mov    0x4(%eax),%edx
  801693:	8b 00                	mov    (%eax),%eax
  801695:	eb 40                	jmp    8016d7 <getuint+0x65>
	else if (lflag)
  801697:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169b:	74 1e                	je     8016bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8b 00                	mov    (%eax),%eax
  8016a2:	8d 50 04             	lea    0x4(%eax),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	89 10                	mov    %edx,(%eax)
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	83 e8 04             	sub    $0x4,%eax
  8016b2:	8b 00                	mov    (%eax),%eax
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	eb 1c                	jmp    8016d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8b 00                	mov    (%eax),%eax
  8016c0:	8d 50 04             	lea    0x4(%eax),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	89 10                	mov    %edx,(%eax)
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8b 00                	mov    (%eax),%eax
  8016cd:	83 e8 04             	sub    $0x4,%eax
  8016d0:	8b 00                	mov    (%eax),%eax
  8016d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8016d7:	5d                   	pop    %ebp
  8016d8:	c3                   	ret    

008016d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8016dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016e0:	7e 1c                	jle    8016fe <getint+0x25>
		return va_arg(*ap, long long);
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8b 00                	mov    (%eax),%eax
  8016e7:	8d 50 08             	lea    0x8(%eax),%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	89 10                	mov    %edx,(%eax)
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	83 e8 08             	sub    $0x8,%eax
  8016f7:	8b 50 04             	mov    0x4(%eax),%edx
  8016fa:	8b 00                	mov    (%eax),%eax
  8016fc:	eb 38                	jmp    801736 <getint+0x5d>
	else if (lflag)
  8016fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801702:	74 1a                	je     80171e <getint+0x45>
		return va_arg(*ap, long);
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8b 00                	mov    (%eax),%eax
  801709:	8d 50 04             	lea    0x4(%eax),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	89 10                	mov    %edx,(%eax)
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	83 e8 04             	sub    $0x4,%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	99                   	cltd   
  80171c:	eb 18                	jmp    801736 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	8d 50 04             	lea    0x4(%eax),%edx
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	89 10                	mov    %edx,(%eax)
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8b 00                	mov    (%eax),%eax
  801730:	83 e8 04             	sub    $0x4,%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	99                   	cltd   
}
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801740:	eb 17                	jmp    801759 <vprintfmt+0x21>
			if (ch == '\0')
  801742:	85 db                	test   %ebx,%ebx
  801744:	0f 84 af 03 00 00    	je     801af9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	53                   	push   %ebx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	ff d0                	call   *%eax
  801756:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	8d 50 01             	lea    0x1(%eax),%edx
  80175f:	89 55 10             	mov    %edx,0x10(%ebp)
  801762:	8a 00                	mov    (%eax),%al
  801764:	0f b6 d8             	movzbl %al,%ebx
  801767:	83 fb 25             	cmp    $0x25,%ebx
  80176a:	75 d6                	jne    801742 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80176c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801770:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801777:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80177e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801785:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80178c:	8b 45 10             	mov    0x10(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 10             	mov    %edx,0x10(%ebp)
  801795:	8a 00                	mov    (%eax),%al
  801797:	0f b6 d8             	movzbl %al,%ebx
  80179a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80179d:	83 f8 55             	cmp    $0x55,%eax
  8017a0:	0f 87 2b 03 00 00    	ja     801ad1 <vprintfmt+0x399>
  8017a6:	8b 04 85 98 49 80 00 	mov    0x804998(,%eax,4),%eax
  8017ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8017af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8017b3:	eb d7                	jmp    80178c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8017b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8017b9:	eb d1                	jmp    80178c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8017c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017c5:	89 d0                	mov    %edx,%eax
  8017c7:	c1 e0 02             	shl    $0x2,%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	01 c0                	add    %eax,%eax
  8017ce:	01 d8                	add    %ebx,%eax
  8017d0:	83 e8 30             	sub    $0x30,%eax
  8017d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8017d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8017de:	83 fb 2f             	cmp    $0x2f,%ebx
  8017e1:	7e 3e                	jle    801821 <vprintfmt+0xe9>
  8017e3:	83 fb 39             	cmp    $0x39,%ebx
  8017e6:	7f 39                	jg     801821 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8017eb:	eb d5                	jmp    8017c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8017ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f0:	83 c0 04             	add    $0x4,%eax
  8017f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8017f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f9:	83 e8 04             	sub    $0x4,%eax
  8017fc:	8b 00                	mov    (%eax),%eax
  8017fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801801:	eb 1f                	jmp    801822 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801807:	79 83                	jns    80178c <vprintfmt+0x54>
				width = 0;
  801809:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801810:	e9 77 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801815:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80181c:	e9 6b ff ff ff       	jmp    80178c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801821:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801826:	0f 89 60 ff ff ff    	jns    80178c <vprintfmt+0x54>
				width = precision, precision = -1;
  80182c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801832:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801839:	e9 4e ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80183e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801841:	e9 46 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	83 c0 04             	add    $0x4,%eax
  80184c:	89 45 14             	mov    %eax,0x14(%ebp)
  80184f:	8b 45 14             	mov    0x14(%ebp),%eax
  801852:	83 e8 04             	sub    $0x4,%eax
  801855:	8b 00                	mov    (%eax),%eax
  801857:	83 ec 08             	sub    $0x8,%esp
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	50                   	push   %eax
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	ff d0                	call   *%eax
  801863:	83 c4 10             	add    $0x10,%esp
			break;
  801866:	e9 89 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80186b:	8b 45 14             	mov    0x14(%ebp),%eax
  80186e:	83 c0 04             	add    $0x4,%eax
  801871:	89 45 14             	mov    %eax,0x14(%ebp)
  801874:	8b 45 14             	mov    0x14(%ebp),%eax
  801877:	83 e8 04             	sub    $0x4,%eax
  80187a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80187c:	85 db                	test   %ebx,%ebx
  80187e:	79 02                	jns    801882 <vprintfmt+0x14a>
				err = -err;
  801880:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801882:	83 fb 64             	cmp    $0x64,%ebx
  801885:	7f 0b                	jg     801892 <vprintfmt+0x15a>
  801887:	8b 34 9d e0 47 80 00 	mov    0x8047e0(,%ebx,4),%esi
  80188e:	85 f6                	test   %esi,%esi
  801890:	75 19                	jne    8018ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801892:	53                   	push   %ebx
  801893:	68 85 49 80 00       	push   $0x804985
  801898:	ff 75 0c             	pushl  0xc(%ebp)
  80189b:	ff 75 08             	pushl  0x8(%ebp)
  80189e:	e8 5e 02 00 00       	call   801b01 <printfmt>
  8018a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8018a6:	e9 49 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8018ab:	56                   	push   %esi
  8018ac:	68 8e 49 80 00       	push   $0x80498e
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	e8 45 02 00 00       	call   801b01 <printfmt>
  8018bc:	83 c4 10             	add    $0x10,%esp
			break;
  8018bf:	e9 30 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8018c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c7:	83 c0 04             	add    $0x4,%eax
  8018ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8018cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d0:	83 e8 04             	sub    $0x4,%eax
  8018d3:	8b 30                	mov    (%eax),%esi
  8018d5:	85 f6                	test   %esi,%esi
  8018d7:	75 05                	jne    8018de <vprintfmt+0x1a6>
				p = "(null)";
  8018d9:	be 91 49 80 00       	mov    $0x804991,%esi
			if (width > 0 && padc != '-')
  8018de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018e2:	7e 6d                	jle    801951 <vprintfmt+0x219>
  8018e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8018e8:	74 67                	je     801951 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8018ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ed:	83 ec 08             	sub    $0x8,%esp
  8018f0:	50                   	push   %eax
  8018f1:	56                   	push   %esi
  8018f2:	e8 0c 03 00 00       	call   801c03 <strnlen>
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8018fd:	eb 16                	jmp    801915 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8018ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	50                   	push   %eax
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	ff d0                	call   *%eax
  80190f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801912:	ff 4d e4             	decl   -0x1c(%ebp)
  801915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801919:	7f e4                	jg     8018ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80191b:	eb 34                	jmp    801951 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80191d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801921:	74 1c                	je     80193f <vprintfmt+0x207>
  801923:	83 fb 1f             	cmp    $0x1f,%ebx
  801926:	7e 05                	jle    80192d <vprintfmt+0x1f5>
  801928:	83 fb 7e             	cmp    $0x7e,%ebx
  80192b:	7e 12                	jle    80193f <vprintfmt+0x207>
					putch('?', putdat);
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	6a 3f                	push   $0x3f
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	ff d0                	call   *%eax
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	eb 0f                	jmp    80194e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	53                   	push   %ebx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	ff d0                	call   *%eax
  80194b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80194e:	ff 4d e4             	decl   -0x1c(%ebp)
  801951:	89 f0                	mov    %esi,%eax
  801953:	8d 70 01             	lea    0x1(%eax),%esi
  801956:	8a 00                	mov    (%eax),%al
  801958:	0f be d8             	movsbl %al,%ebx
  80195b:	85 db                	test   %ebx,%ebx
  80195d:	74 24                	je     801983 <vprintfmt+0x24b>
  80195f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801963:	78 b8                	js     80191d <vprintfmt+0x1e5>
  801965:	ff 4d e0             	decl   -0x20(%ebp)
  801968:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80196c:	79 af                	jns    80191d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80196e:	eb 13                	jmp    801983 <vprintfmt+0x24b>
				putch(' ', putdat);
  801970:	83 ec 08             	sub    $0x8,%esp
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	6a 20                	push   $0x20
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	ff d0                	call   *%eax
  80197d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801980:	ff 4d e4             	decl   -0x1c(%ebp)
  801983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801987:	7f e7                	jg     801970 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801989:	e9 66 01 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80198e:	83 ec 08             	sub    $0x8,%esp
  801991:	ff 75 e8             	pushl  -0x18(%ebp)
  801994:	8d 45 14             	lea    0x14(%ebp),%eax
  801997:	50                   	push   %eax
  801998:	e8 3c fd ff ff       	call   8016d9 <getint>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ac:	85 d2                	test   %edx,%edx
  8019ae:	79 23                	jns    8019d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	6a 2d                	push   $0x2d
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	ff d0                	call   *%eax
  8019bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c6:	f7 d8                	neg    %eax
  8019c8:	83 d2 00             	adc    $0x0,%edx
  8019cb:	f7 da                	neg    %edx
  8019cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8019d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019da:	e9 bc 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8019e8:	50                   	push   %eax
  8019e9:	e8 84 fc ff ff       	call   801672 <getuint>
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8019f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019fe:	e9 98 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801a03:	83 ec 08             	sub    $0x8,%esp
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	6a 58                	push   $0x58
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	ff d0                	call   *%eax
  801a10:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a13:	83 ec 08             	sub    $0x8,%esp
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	6a 58                	push   $0x58
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	ff d0                	call   *%eax
  801a20:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	6a 58                	push   $0x58
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	ff d0                	call   *%eax
  801a30:	83 c4 10             	add    $0x10,%esp
			break;
  801a33:	e9 bc 00 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801a38:	83 ec 08             	sub    $0x8,%esp
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	6a 30                	push   $0x30
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	ff d0                	call   *%eax
  801a45:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801a48:	83 ec 08             	sub    $0x8,%esp
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	6a 78                	push   $0x78
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	ff d0                	call   *%eax
  801a55:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801a58:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5b:	83 c0 04             	add    $0x4,%eax
  801a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  801a61:	8b 45 14             	mov    0x14(%ebp),%eax
  801a64:	83 e8 04             	sub    $0x4,%eax
  801a67:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801a73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801a7a:	eb 1f                	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  801a82:	8d 45 14             	lea    0x14(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	e8 e7 fb ff ff       	call   801672 <getuint>
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801a94:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801a9b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	52                   	push   %edx
  801aa6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	ff 75 f4             	pushl  -0xc(%ebp)
  801aad:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	e8 00 fb ff ff       	call   8015bb <printnum>
  801abb:	83 c4 20             	add    $0x20,%esp
			break;
  801abe:	eb 34                	jmp    801af4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ac0:	83 ec 08             	sub    $0x8,%esp
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	53                   	push   %ebx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	ff d0                	call   *%eax
  801acc:	83 c4 10             	add    $0x10,%esp
			break;
  801acf:	eb 23                	jmp    801af4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ad1:	83 ec 08             	sub    $0x8,%esp
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	6a 25                	push   $0x25
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	ff d0                	call   *%eax
  801ade:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ae1:	ff 4d 10             	decl   0x10(%ebp)
  801ae4:	eb 03                	jmp    801ae9 <vprintfmt+0x3b1>
  801ae6:	ff 4d 10             	decl   0x10(%ebp)
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	48                   	dec    %eax
  801aed:	8a 00                	mov    (%eax),%al
  801aef:	3c 25                	cmp    $0x25,%al
  801af1:	75 f3                	jne    801ae6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801af3:	90                   	nop
		}
	}
  801af4:	e9 47 fc ff ff       	jmp    801740 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801af9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801afa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afd:	5b                   	pop    %ebx
  801afe:	5e                   	pop    %esi
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801b07:	8d 45 10             	lea    0x10(%ebp),%eax
  801b0a:	83 c0 04             	add    $0x4,%eax
  801b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801b10:	8b 45 10             	mov    0x10(%ebp),%eax
  801b13:	ff 75 f4             	pushl  -0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	e8 16 fc ff ff       	call   801738 <vprintfmt>
  801b22:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2e:	8b 40 08             	mov    0x8(%eax),%eax
  801b31:	8d 50 01             	lea    0x1(%eax),%edx
  801b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b37:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3d:	8b 10                	mov    (%eax),%edx
  801b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b42:	8b 40 04             	mov    0x4(%eax),%eax
  801b45:	39 c2                	cmp    %eax,%edx
  801b47:	73 12                	jae    801b5b <sprintputch+0x33>
		*b->buf++ = ch;
  801b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4c:	8b 00                	mov    (%eax),%eax
  801b4e:	8d 48 01             	lea    0x1(%eax),%ecx
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	89 0a                	mov    %ecx,(%edx)
  801b56:	8b 55 08             	mov    0x8(%ebp),%edx
  801b59:	88 10                	mov    %dl,(%eax)
}
  801b5b:	90                   	nop
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    

00801b5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	01 d0                	add    %edx,%eax
  801b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b83:	74 06                	je     801b8b <vsnprintf+0x2d>
  801b85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b89:	7f 07                	jg     801b92 <vsnprintf+0x34>
		return -E_INVAL;
  801b8b:	b8 03 00 00 00       	mov    $0x3,%eax
  801b90:	eb 20                	jmp    801bb2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b92:	ff 75 14             	pushl  0x14(%ebp)
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b9b:	50                   	push   %eax
  801b9c:	68 28 1b 80 00       	push   $0x801b28
  801ba1:	e8 92 fb ff ff       	call   801738 <vprintfmt>
  801ba6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bba:	8d 45 10             	lea    0x10(%ebp),%eax
  801bbd:	83 c0 04             	add    $0x4,%eax
  801bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc9:	50                   	push   %eax
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	e8 89 ff ff ff       	call   801b5e <vsnprintf>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801be6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bed:	eb 06                	jmp    801bf5 <strlen+0x15>
		n++;
  801bef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801bf2:	ff 45 08             	incl   0x8(%ebp)
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	8a 00                	mov    (%eax),%al
  801bfa:	84 c0                	test   %al,%al
  801bfc:	75 f1                	jne    801bef <strlen+0xf>
		n++;
	return n;
  801bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c10:	eb 09                	jmp    801c1b <strnlen+0x18>
		n++;
  801c12:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c15:	ff 45 08             	incl   0x8(%ebp)
  801c18:	ff 4d 0c             	decl   0xc(%ebp)
  801c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c1f:	74 09                	je     801c2a <strnlen+0x27>
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	8a 00                	mov    (%eax),%al
  801c26:	84 c0                	test   %al,%al
  801c28:	75 e8                	jne    801c12 <strnlen+0xf>
		n++;
	return n;
  801c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801c3b:	90                   	nop
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8d 50 01             	lea    0x1(%eax),%edx
  801c42:	89 55 08             	mov    %edx,0x8(%ebp)
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c48:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c4b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c4e:	8a 12                	mov    (%edx),%dl
  801c50:	88 10                	mov    %dl,(%eax)
  801c52:	8a 00                	mov    (%eax),%al
  801c54:	84 c0                	test   %al,%al
  801c56:	75 e4                	jne    801c3c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801c69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c70:	eb 1f                	jmp    801c91 <strncpy+0x34>
		*dst++ = *src;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	8d 50 01             	lea    0x1(%eax),%edx
  801c78:	89 55 08             	mov    %edx,0x8(%ebp)
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7e:	8a 12                	mov    (%edx),%dl
  801c80:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	84 c0                	test   %al,%al
  801c89:	74 03                	je     801c8e <strncpy+0x31>
			src++;
  801c8b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c8e:	ff 45 fc             	incl   -0x4(%ebp)
  801c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c94:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c97:	72 d9                	jb     801c72 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801caa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cae:	74 30                	je     801ce0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801cb0:	eb 16                	jmp    801cc8 <strlcpy+0x2a>
			*dst++ = *src++;
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	8d 50 01             	lea    0x1(%eax),%edx
  801cb8:	89 55 08             	mov    %edx,0x8(%ebp)
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cc1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801cc4:	8a 12                	mov    (%edx),%dl
  801cc6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801cc8:	ff 4d 10             	decl   0x10(%ebp)
  801ccb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ccf:	74 09                	je     801cda <strlcpy+0x3c>
  801cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd4:	8a 00                	mov    (%eax),%al
  801cd6:	84 c0                	test   %al,%al
  801cd8:	75 d8                	jne    801cb2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ce6:	29 c2                	sub    %eax,%edx
  801ce8:	89 d0                	mov    %edx,%eax
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801cef:	eb 06                	jmp    801cf7 <strcmp+0xb>
		p++, q++;
  801cf1:	ff 45 08             	incl   0x8(%ebp)
  801cf4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	8a 00                	mov    (%eax),%al
  801cfc:	84 c0                	test   %al,%al
  801cfe:	74 0e                	je     801d0e <strcmp+0x22>
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	8a 10                	mov    (%eax),%dl
  801d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d08:	8a 00                	mov    (%eax),%al
  801d0a:	38 c2                	cmp    %al,%dl
  801d0c:	74 e3                	je     801cf1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	8a 00                	mov    (%eax),%al
  801d13:	0f b6 d0             	movzbl %al,%edx
  801d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d19:	8a 00                	mov    (%eax),%al
  801d1b:	0f b6 c0             	movzbl %al,%eax
  801d1e:	29 c2                	sub    %eax,%edx
  801d20:	89 d0                	mov    %edx,%eax
}
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    

00801d24 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801d27:	eb 09                	jmp    801d32 <strncmp+0xe>
		n--, p++, q++;
  801d29:	ff 4d 10             	decl   0x10(%ebp)
  801d2c:	ff 45 08             	incl   0x8(%ebp)
  801d2f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801d32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d36:	74 17                	je     801d4f <strncmp+0x2b>
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	8a 00                	mov    (%eax),%al
  801d3d:	84 c0                	test   %al,%al
  801d3f:	74 0e                	je     801d4f <strncmp+0x2b>
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	8a 10                	mov    (%eax),%dl
  801d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d49:	8a 00                	mov    (%eax),%al
  801d4b:	38 c2                	cmp    %al,%dl
  801d4d:	74 da                	je     801d29 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d53:	75 07                	jne    801d5c <strncmp+0x38>
		return 0;
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	eb 14                	jmp    801d70 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	8a 00                	mov    (%eax),%al
  801d61:	0f b6 d0             	movzbl %al,%edx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	8a 00                	mov    (%eax),%al
  801d69:	0f b6 c0             	movzbl %al,%eax
  801d6c:	29 c2                	sub    %eax,%edx
  801d6e:	89 d0                	mov    %edx,%eax
}
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    

00801d72 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d7e:	eb 12                	jmp    801d92 <strchr+0x20>
		if (*s == c)
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	8a 00                	mov    (%eax),%al
  801d85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d88:	75 05                	jne    801d8f <strchr+0x1d>
			return (char *) s;
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	eb 11                	jmp    801da0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d8f:	ff 45 08             	incl   0x8(%ebp)
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	8a 00                	mov    (%eax),%al
  801d97:	84 c0                	test   %al,%al
  801d99:	75 e5                	jne    801d80 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801dae:	eb 0d                	jmp    801dbd <strfind+0x1b>
		if (*s == c)
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	8a 00                	mov    (%eax),%al
  801db5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801db8:	74 0e                	je     801dc8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801dba:	ff 45 08             	incl   0x8(%ebp)
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8a 00                	mov    (%eax),%al
  801dc2:	84 c0                	test   %al,%al
  801dc4:	75 ea                	jne    801db0 <strfind+0xe>
  801dc6:	eb 01                	jmp    801dc9 <strfind+0x27>
		if (*s == c)
			break;
  801dc8:	90                   	nop
	return (char *) s;
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801dda:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801de0:	eb 0e                	jmp    801df0 <memset+0x22>
		*p++ = c;
  801de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de5:	8d 50 01             	lea    0x1(%eax),%edx
  801de8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801df0:	ff 4d f8             	decl   -0x8(%ebp)
  801df3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801df7:	79 e9                	jns    801de2 <memset+0x14>
		*p++ = c;

	return v;
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801e10:	eb 16                	jmp    801e28 <memcpy+0x2a>
		*d++ = *s++;
  801e12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e15:	8d 50 01             	lea    0x1(%eax),%edx
  801e18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e21:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801e24:	8a 12                	mov    (%edx),%dl
  801e26:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801e28:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e2e:	89 55 10             	mov    %edx,0x10(%ebp)
  801e31:	85 c0                	test   %eax,%eax
  801e33:	75 dd                	jne    801e12 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e52:	73 50                	jae    801ea4 <memmove+0x6a>
  801e54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e57:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5a:	01 d0                	add    %edx,%eax
  801e5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e5f:	76 43                	jbe    801ea4 <memmove+0x6a>
		s += n;
  801e61:	8b 45 10             	mov    0x10(%ebp),%eax
  801e64:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801e67:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801e6d:	eb 10                	jmp    801e7f <memmove+0x45>
			*--d = *--s;
  801e6f:	ff 4d f8             	decl   -0x8(%ebp)
  801e72:	ff 4d fc             	decl   -0x4(%ebp)
  801e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e78:	8a 10                	mov    (%eax),%dl
  801e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e7d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e82:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e85:	89 55 10             	mov    %edx,0x10(%ebp)
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	75 e3                	jne    801e6f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e8c:	eb 23                	jmp    801eb1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e91:	8d 50 01             	lea    0x1(%eax),%edx
  801e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ea0:	8a 12                	mov    (%edx),%dl
  801ea2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	75 dd                	jne    801e8e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ec8:	eb 2a                	jmp    801ef4 <memcmp+0x3e>
		if (*s1 != *s2)
  801eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecd:	8a 10                	mov    (%eax),%dl
  801ecf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed2:	8a 00                	mov    (%eax),%al
  801ed4:	38 c2                	cmp    %al,%dl
  801ed6:	74 16                	je     801eee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	0f b6 d0             	movzbl %al,%edx
  801ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ee3:	8a 00                	mov    (%eax),%al
  801ee5:	0f b6 c0             	movzbl %al,%eax
  801ee8:	29 c2                	sub    %eax,%edx
  801eea:	89 d0                	mov    %edx,%eax
  801eec:	eb 18                	jmp    801f06 <memcmp+0x50>
		s1++, s2++;
  801eee:	ff 45 fc             	incl   -0x4(%ebp)
  801ef1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801efa:	89 55 10             	mov    %edx,0x10(%ebp)
  801efd:	85 c0                	test   %eax,%eax
  801eff:	75 c9                	jne    801eca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f11:	8b 45 10             	mov    0x10(%ebp),%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801f19:	eb 15                	jmp    801f30 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	8a 00                	mov    (%eax),%al
  801f20:	0f b6 d0             	movzbl %al,%edx
  801f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f26:	0f b6 c0             	movzbl %al,%eax
  801f29:	39 c2                	cmp    %eax,%edx
  801f2b:	74 0d                	je     801f3a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801f2d:	ff 45 08             	incl   0x8(%ebp)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801f36:	72 e3                	jb     801f1b <memfind+0x13>
  801f38:	eb 01                	jmp    801f3b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801f3a:	90                   	nop
	return (void *) s;
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801f4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f54:	eb 03                	jmp    801f59 <strtol+0x19>
		s++;
  801f56:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	8a 00                	mov    (%eax),%al
  801f5e:	3c 20                	cmp    $0x20,%al
  801f60:	74 f4                	je     801f56 <strtol+0x16>
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	8a 00                	mov    (%eax),%al
  801f67:	3c 09                	cmp    $0x9,%al
  801f69:	74 eb                	je     801f56 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	8a 00                	mov    (%eax),%al
  801f70:	3c 2b                	cmp    $0x2b,%al
  801f72:	75 05                	jne    801f79 <strtol+0x39>
		s++;
  801f74:	ff 45 08             	incl   0x8(%ebp)
  801f77:	eb 13                	jmp    801f8c <strtol+0x4c>
	else if (*s == '-')
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	8a 00                	mov    (%eax),%al
  801f7e:	3c 2d                	cmp    $0x2d,%al
  801f80:	75 0a                	jne    801f8c <strtol+0x4c>
		s++, neg = 1;
  801f82:	ff 45 08             	incl   0x8(%ebp)
  801f85:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f90:	74 06                	je     801f98 <strtol+0x58>
  801f92:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801f96:	75 20                	jne    801fb8 <strtol+0x78>
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	8a 00                	mov    (%eax),%al
  801f9d:	3c 30                	cmp    $0x30,%al
  801f9f:	75 17                	jne    801fb8 <strtol+0x78>
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	40                   	inc    %eax
  801fa5:	8a 00                	mov    (%eax),%al
  801fa7:	3c 78                	cmp    $0x78,%al
  801fa9:	75 0d                	jne    801fb8 <strtol+0x78>
		s += 2, base = 16;
  801fab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801faf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801fb6:	eb 28                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801fb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fbc:	75 15                	jne    801fd3 <strtol+0x93>
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8a 00                	mov    (%eax),%al
  801fc3:	3c 30                	cmp    $0x30,%al
  801fc5:	75 0c                	jne    801fd3 <strtol+0x93>
		s++, base = 8;
  801fc7:	ff 45 08             	incl   0x8(%ebp)
  801fca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801fd1:	eb 0d                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0)
  801fd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fd7:	75 07                	jne    801fe0 <strtol+0xa0>
		base = 10;
  801fd9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	8a 00                	mov    (%eax),%al
  801fe5:	3c 2f                	cmp    $0x2f,%al
  801fe7:	7e 19                	jle    802002 <strtol+0xc2>
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	8a 00                	mov    (%eax),%al
  801fee:	3c 39                	cmp    $0x39,%al
  801ff0:	7f 10                	jg     802002 <strtol+0xc2>
			dig = *s - '0';
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	8a 00                	mov    (%eax),%al
  801ff7:	0f be c0             	movsbl %al,%eax
  801ffa:	83 e8 30             	sub    $0x30,%eax
  801ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802000:	eb 42                	jmp    802044 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8a 00                	mov    (%eax),%al
  802007:	3c 60                	cmp    $0x60,%al
  802009:	7e 19                	jle    802024 <strtol+0xe4>
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	8a 00                	mov    (%eax),%al
  802010:	3c 7a                	cmp    $0x7a,%al
  802012:	7f 10                	jg     802024 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	8a 00                	mov    (%eax),%al
  802019:	0f be c0             	movsbl %al,%eax
  80201c:	83 e8 57             	sub    $0x57,%eax
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802022:	eb 20                	jmp    802044 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8a 00                	mov    (%eax),%al
  802029:	3c 40                	cmp    $0x40,%al
  80202b:	7e 39                	jle    802066 <strtol+0x126>
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8a 00                	mov    (%eax),%al
  802032:	3c 5a                	cmp    $0x5a,%al
  802034:	7f 30                	jg     802066 <strtol+0x126>
			dig = *s - 'A' + 10;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8a 00                	mov    (%eax),%al
  80203b:	0f be c0             	movsbl %al,%eax
  80203e:	83 e8 37             	sub    $0x37,%eax
  802041:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	3b 45 10             	cmp    0x10(%ebp),%eax
  80204a:	7d 19                	jge    802065 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80204c:	ff 45 08             	incl   0x8(%ebp)
  80204f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802052:	0f af 45 10          	imul   0x10(%ebp),%eax
  802056:	89 c2                	mov    %eax,%edx
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	01 d0                	add    %edx,%eax
  80205d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802060:	e9 7b ff ff ff       	jmp    801fe0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802065:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802066:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80206a:	74 08                	je     802074 <strtol+0x134>
		*endptr = (char *) s;
  80206c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206f:	8b 55 08             	mov    0x8(%ebp),%edx
  802072:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802074:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802078:	74 07                	je     802081 <strtol+0x141>
  80207a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207d:	f7 d8                	neg    %eax
  80207f:	eb 03                	jmp    802084 <strtol+0x144>
  802081:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <ltostr>:

void
ltostr(long value, char *str)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80208c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802093:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80209a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80209e:	79 13                	jns    8020b3 <ltostr+0x2d>
	{
		neg = 1;
  8020a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8020ad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8020b0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8020bb:	99                   	cltd   
  8020bc:	f7 f9                	idiv   %ecx
  8020be:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8020c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c4:	8d 50 01             	lea    0x1(%eax),%edx
  8020c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8020ca:	89 c2                	mov    %eax,%edx
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020d4:	83 c2 30             	add    $0x30,%edx
  8020d7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8020d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020dc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020e1:	f7 e9                	imul   %ecx
  8020e3:	c1 fa 02             	sar    $0x2,%edx
  8020e6:	89 c8                	mov    %ecx,%eax
  8020e8:	c1 f8 1f             	sar    $0x1f,%eax
  8020eb:	29 c2                	sub    %eax,%edx
  8020ed:	89 d0                	mov    %edx,%eax
  8020ef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8020f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020fa:	f7 e9                	imul   %ecx
  8020fc:	c1 fa 02             	sar    $0x2,%edx
  8020ff:	89 c8                	mov    %ecx,%eax
  802101:	c1 f8 1f             	sar    $0x1f,%eax
  802104:	29 c2                	sub    %eax,%edx
  802106:	89 d0                	mov    %edx,%eax
  802108:	c1 e0 02             	shl    $0x2,%eax
  80210b:	01 d0                	add    %edx,%eax
  80210d:	01 c0                	add    %eax,%eax
  80210f:	29 c1                	sub    %eax,%ecx
  802111:	89 ca                	mov    %ecx,%edx
  802113:	85 d2                	test   %edx,%edx
  802115:	75 9c                	jne    8020b3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80211e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802121:	48                   	dec    %eax
  802122:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802125:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802129:	74 3d                	je     802168 <ltostr+0xe2>
		start = 1 ;
  80212b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802132:	eb 34                	jmp    802168 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	01 d0                	add    %edx,%eax
  80213c:	8a 00                	mov    (%eax),%al
  80213e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	8b 45 0c             	mov    0xc(%ebp),%eax
  802147:	01 c2                	add    %eax,%edx
  802149:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80214c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214f:	01 c8                	add    %ecx,%eax
  802151:	8a 00                	mov    (%eax),%al
  802153:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802155:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215b:	01 c2                	add    %eax,%edx
  80215d:	8a 45 eb             	mov    -0x15(%ebp),%al
  802160:	88 02                	mov    %al,(%edx)
		start++ ;
  802162:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802165:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80216e:	7c c4                	jl     802134 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802170:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802173:	8b 45 0c             	mov    0xc(%ebp),%eax
  802176:	01 d0                	add    %edx,%eax
  802178:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	e8 54 fa ff ff       	call   801be0 <strlen>
  80218c:	83 c4 04             	add    $0x4,%esp
  80218f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802192:	ff 75 0c             	pushl  0xc(%ebp)
  802195:	e8 46 fa ff ff       	call   801be0 <strlen>
  80219a:	83 c4 04             	add    $0x4,%esp
  80219d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8021a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8021a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021ae:	eb 17                	jmp    8021c7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8021b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b6:	01 c2                	add    %eax,%edx
  8021b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	01 c8                	add    %ecx,%eax
  8021c0:	8a 00                	mov    (%eax),%al
  8021c2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8021c4:	ff 45 fc             	incl   -0x4(%ebp)
  8021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021cd:	7c e1                	jl     8021b0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8021cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8021d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8021dd:	eb 1f                	jmp    8021fe <strcconcat+0x80>
		final[s++] = str2[i] ;
  8021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e2:	8d 50 01             	lea    0x1(%eax),%edx
  8021e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8021e8:	89 c2                	mov    %eax,%edx
  8021ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ed:	01 c2                	add    %eax,%edx
  8021ef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8021f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f5:	01 c8                	add    %ecx,%eax
  8021f7:	8a 00                	mov    (%eax),%al
  8021f9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8021fb:	ff 45 f8             	incl   -0x8(%ebp)
  8021fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802201:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802204:	7c d9                	jl     8021df <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802206:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	c6 00 00             	movb   $0x0,(%eax)
}
  802211:	90                   	nop
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802217:	8b 45 14             	mov    0x14(%ebp),%eax
  80221a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802220:	8b 45 14             	mov    0x14(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80222c:	8b 45 10             	mov    0x10(%ebp),%eax
  80222f:	01 d0                	add    %edx,%eax
  802231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802237:	eb 0c                	jmp    802245 <strsplit+0x31>
			*string++ = 0;
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8d 50 01             	lea    0x1(%eax),%edx
  80223f:	89 55 08             	mov    %edx,0x8(%ebp)
  802242:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8a 00                	mov    (%eax),%al
  80224a:	84 c0                	test   %al,%al
  80224c:	74 18                	je     802266 <strsplit+0x52>
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	8a 00                	mov    (%eax),%al
  802253:	0f be c0             	movsbl %al,%eax
  802256:	50                   	push   %eax
  802257:	ff 75 0c             	pushl  0xc(%ebp)
  80225a:	e8 13 fb ff ff       	call   801d72 <strchr>
  80225f:	83 c4 08             	add    $0x8,%esp
  802262:	85 c0                	test   %eax,%eax
  802264:	75 d3                	jne    802239 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8a 00                	mov    (%eax),%al
  80226b:	84 c0                	test   %al,%al
  80226d:	74 5a                	je     8022c9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80226f:	8b 45 14             	mov    0x14(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	83 f8 0f             	cmp    $0xf,%eax
  802277:	75 07                	jne    802280 <strsplit+0x6c>
		{
			return 0;
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	eb 66                	jmp    8022e6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802280:	8b 45 14             	mov    0x14(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	8d 48 01             	lea    0x1(%eax),%ecx
  802288:	8b 55 14             	mov    0x14(%ebp),%edx
  80228b:	89 0a                	mov    %ecx,(%edx)
  80228d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802294:	8b 45 10             	mov    0x10(%ebp),%eax
  802297:	01 c2                	add    %eax,%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80229e:	eb 03                	jmp    8022a3 <strsplit+0x8f>
			string++;
  8022a0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8a 00                	mov    (%eax),%al
  8022a8:	84 c0                	test   %al,%al
  8022aa:	74 8b                	je     802237 <strsplit+0x23>
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8a 00                	mov    (%eax),%al
  8022b1:	0f be c0             	movsbl %al,%eax
  8022b4:	50                   	push   %eax
  8022b5:	ff 75 0c             	pushl  0xc(%ebp)
  8022b8:	e8 b5 fa ff ff       	call   801d72 <strchr>
  8022bd:	83 c4 08             	add    $0x8,%esp
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	74 dc                	je     8022a0 <strsplit+0x8c>
			string++;
	}
  8022c4:	e9 6e ff ff ff       	jmp    802237 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8022c9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8022ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8022e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8022ee:	a1 04 50 80 00       	mov    0x805004,%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	74 1f                	je     802316 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8022f7:	e8 1d 00 00 00       	call   802319 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	68 f0 4a 80 00       	push   $0x804af0
  802304:	e8 55 f2 ff ff       	call   80155e <cprintf>
  802309:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80230c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  802313:	00 00 00 
	}
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80231f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802326:	00 00 00 
  802329:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802330:	00 00 00 
  802333:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80233a:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80233d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802344:	00 00 00 
  802347:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80234e:	00 00 00 
  802351:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802358:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80235b:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802362:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  802365:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802374:	2d 00 10 00 00       	sub    $0x1000,%eax
  802379:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80237e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802385:	a1 20 51 80 00       	mov    0x805120,%eax
  80238a:	c1 e0 04             	shl    $0x4,%eax
  80238d:	89 c2                	mov    %eax,%edx
  80238f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802392:	01 d0                	add    %edx,%eax
  802394:	48                   	dec    %eax
  802395:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802398:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239b:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a0:	f7 75 f0             	divl   -0x10(%ebp)
  8023a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a6:	29 d0                	sub    %edx,%eax
  8023a8:	89 c2                	mov    %eax,%edx
  8023aa:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8023b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8023b9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023be:	83 ec 04             	sub    $0x4,%esp
  8023c1:	6a 06                	push   $0x6
  8023c3:	52                   	push   %edx
  8023c4:	50                   	push   %eax
  8023c5:	e8 71 05 00 00       	call   80293b <sys_allocate_chunk>
  8023ca:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8023cd:	a1 20 51 80 00       	mov    0x805120,%eax
  8023d2:	83 ec 0c             	sub    $0xc,%esp
  8023d5:	50                   	push   %eax
  8023d6:	e8 e6 0b 00 00       	call   802fc1 <initialize_MemBlocksList>
  8023db:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8023de:	a1 48 51 80 00       	mov    0x805148,%eax
  8023e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8023e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023ea:	75 14                	jne    802400 <initialize_dyn_block_system+0xe7>
  8023ec:	83 ec 04             	sub    $0x4,%esp
  8023ef:	68 15 4b 80 00       	push   $0x804b15
  8023f4:	6a 2b                	push   $0x2b
  8023f6:	68 33 4b 80 00       	push   $0x804b33
  8023fb:	e8 aa ee ff ff       	call   8012aa <_panic>
  802400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802403:	8b 00                	mov    (%eax),%eax
  802405:	85 c0                	test   %eax,%eax
  802407:	74 10                	je     802419 <initialize_dyn_block_system+0x100>
  802409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240c:	8b 00                	mov    (%eax),%eax
  80240e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802411:	8b 52 04             	mov    0x4(%edx),%edx
  802414:	89 50 04             	mov    %edx,0x4(%eax)
  802417:	eb 0b                	jmp    802424 <initialize_dyn_block_system+0x10b>
  802419:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80241c:	8b 40 04             	mov    0x4(%eax),%eax
  80241f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802427:	8b 40 04             	mov    0x4(%eax),%eax
  80242a:	85 c0                	test   %eax,%eax
  80242c:	74 0f                	je     80243d <initialize_dyn_block_system+0x124>
  80242e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802431:	8b 40 04             	mov    0x4(%eax),%eax
  802434:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802437:	8b 12                	mov    (%edx),%edx
  802439:	89 10                	mov    %edx,(%eax)
  80243b:	eb 0a                	jmp    802447 <initialize_dyn_block_system+0x12e>
  80243d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802440:	8b 00                	mov    (%eax),%eax
  802442:	a3 48 51 80 00       	mov    %eax,0x805148
  802447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80244a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802453:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245a:	a1 54 51 80 00       	mov    0x805154,%eax
  80245f:	48                   	dec    %eax
  802460:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  802465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802468:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80246f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802472:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  802479:	83 ec 0c             	sub    $0xc,%esp
  80247c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80247f:	e8 d2 13 00 00       	call   803856 <insert_sorted_with_merge_freeList>
  802484:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  802487:	90                   	nop
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802490:	e8 53 fe ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  802495:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802499:	75 07                	jne    8024a2 <malloc+0x18>
  80249b:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a0:	eb 61                	jmp    802503 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8024a2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8024a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	01 d0                	add    %edx,%eax
  8024b1:	48                   	dec    %eax
  8024b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8024b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8024bd:	f7 75 f4             	divl   -0xc(%ebp)
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	29 d0                	sub    %edx,%eax
  8024c5:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8024c8:	e8 3c 08 00 00       	call   802d09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	74 2d                	je     8024fe <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8024d1:	83 ec 0c             	sub    $0xc,%esp
  8024d4:	ff 75 08             	pushl  0x8(%ebp)
  8024d7:	e8 3e 0f 00 00       	call   80341a <alloc_block_FF>
  8024dc:	83 c4 10             	add    $0x10,%esp
  8024df:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8024e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024e6:	74 16                	je     8024fe <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8024e8:	83 ec 0c             	sub    $0xc,%esp
  8024eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8024ee:	e8 48 0c 00 00       	call   80313b <insert_sorted_allocList>
  8024f3:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8024f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f9:	8b 40 08             	mov    0x8(%eax),%eax
  8024fc:	eb 05                	jmp    802503 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8024fe:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
  802508:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802519:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80251c:	8b 45 08             	mov    0x8(%ebp),%eax
  80251f:	83 ec 08             	sub    $0x8,%esp
  802522:	50                   	push   %eax
  802523:	68 40 50 80 00       	push   $0x805040
  802528:	e8 71 0b 00 00       	call   80309e <find_block>
  80252d:	83 c4 10             	add    $0x10,%esp
  802530:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802536:	8b 50 0c             	mov    0xc(%eax),%edx
  802539:	8b 45 08             	mov    0x8(%ebp),%eax
  80253c:	83 ec 08             	sub    $0x8,%esp
  80253f:	52                   	push   %edx
  802540:	50                   	push   %eax
  802541:	e8 bd 03 00 00       	call   802903 <sys_free_user_mem>
  802546:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  802549:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80254d:	75 14                	jne    802563 <free+0x5e>
  80254f:	83 ec 04             	sub    $0x4,%esp
  802552:	68 15 4b 80 00       	push   $0x804b15
  802557:	6a 71                	push   $0x71
  802559:	68 33 4b 80 00       	push   $0x804b33
  80255e:	e8 47 ed ff ff       	call   8012aa <_panic>
  802563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802566:	8b 00                	mov    (%eax),%eax
  802568:	85 c0                	test   %eax,%eax
  80256a:	74 10                	je     80257c <free+0x77>
  80256c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802574:	8b 52 04             	mov    0x4(%edx),%edx
  802577:	89 50 04             	mov    %edx,0x4(%eax)
  80257a:	eb 0b                	jmp    802587 <free+0x82>
  80257c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257f:	8b 40 04             	mov    0x4(%eax),%eax
  802582:	a3 44 50 80 00       	mov    %eax,0x805044
  802587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	85 c0                	test   %eax,%eax
  80258f:	74 0f                	je     8025a0 <free+0x9b>
  802591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802594:	8b 40 04             	mov    0x4(%eax),%eax
  802597:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80259a:	8b 12                	mov    (%edx),%edx
  80259c:	89 10                	mov    %edx,(%eax)
  80259e:	eb 0a                	jmp    8025aa <free+0xa5>
  8025a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a3:	8b 00                	mov    (%eax),%eax
  8025a5:	a3 40 50 80 00       	mov    %eax,0x805040
  8025aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025bd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025c2:	48                   	dec    %eax
  8025c3:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  8025c8:	83 ec 0c             	sub    $0xc,%esp
  8025cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ce:	e8 83 12 00 00       	call   803856 <insert_sorted_with_merge_freeList>
  8025d3:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8025d6:	90                   	nop
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	83 ec 28             	sub    $0x28,%esp
  8025df:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e2:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8025e5:	e8 fe fc ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8025ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025ee:	75 0a                	jne    8025fa <smalloc+0x21>
  8025f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f5:	e9 86 00 00 00       	jmp    802680 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8025fa:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802601:	8b 55 0c             	mov    0xc(%ebp),%edx
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	01 d0                	add    %edx,%eax
  802609:	48                   	dec    %eax
  80260a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80260d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802610:	ba 00 00 00 00       	mov    $0x0,%edx
  802615:	f7 75 f4             	divl   -0xc(%ebp)
  802618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261b:	29 d0                	sub    %edx,%eax
  80261d:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802620:	e8 e4 06 00 00       	call   802d09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802625:	85 c0                	test   %eax,%eax
  802627:	74 52                	je     80267b <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  802629:	83 ec 0c             	sub    $0xc,%esp
  80262c:	ff 75 0c             	pushl  0xc(%ebp)
  80262f:	e8 e6 0d 00 00       	call   80341a <alloc_block_FF>
  802634:	83 c4 10             	add    $0x10,%esp
  802637:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  80263a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80263e:	75 07                	jne    802647 <smalloc+0x6e>
			return NULL ;
  802640:	b8 00 00 00 00       	mov    $0x0,%eax
  802645:	eb 39                	jmp    802680 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  802647:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264a:	8b 40 08             	mov    0x8(%eax),%eax
  80264d:	89 c2                	mov    %eax,%edx
  80264f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802653:	52                   	push   %edx
  802654:	50                   	push   %eax
  802655:	ff 75 0c             	pushl  0xc(%ebp)
  802658:	ff 75 08             	pushl  0x8(%ebp)
  80265b:	e8 2e 04 00 00       	call   802a8e <sys_createSharedObject>
  802660:	83 c4 10             	add    $0x10,%esp
  802663:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  802666:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80266a:	79 07                	jns    802673 <smalloc+0x9a>
			return (void*)NULL ;
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
  802671:	eb 0d                	jmp    802680 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  802673:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802676:	8b 40 08             	mov    0x8(%eax),%eax
  802679:	eb 05                	jmp    802680 <smalloc+0xa7>
		}
		return (void*)NULL ;
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802680:	c9                   	leave  
  802681:	c3                   	ret    

00802682 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
  802685:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802688:	e8 5b fc ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80268d:	83 ec 08             	sub    $0x8,%esp
  802690:	ff 75 0c             	pushl  0xc(%ebp)
  802693:	ff 75 08             	pushl  0x8(%ebp)
  802696:	e8 1d 04 00 00       	call   802ab8 <sys_getSizeOfSharedObject>
  80269b:	83 c4 10             	add    $0x10,%esp
  80269e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8026a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a5:	75 0a                	jne    8026b1 <sget+0x2f>
			return NULL ;
  8026a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ac:	e9 83 00 00 00       	jmp    802734 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8026b1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8026b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026be:	01 d0                	add    %edx,%eax
  8026c0:	48                   	dec    %eax
  8026c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026cc:	f7 75 f0             	divl   -0x10(%ebp)
  8026cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d2:	29 d0                	sub    %edx,%eax
  8026d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8026d7:	e8 2d 06 00 00       	call   802d09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	74 4f                	je     80272f <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	83 ec 0c             	sub    $0xc,%esp
  8026e6:	50                   	push   %eax
  8026e7:	e8 2e 0d 00 00       	call   80341a <alloc_block_FF>
  8026ec:	83 c4 10             	add    $0x10,%esp
  8026ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8026f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026f6:	75 07                	jne    8026ff <sget+0x7d>
					return (void*)NULL ;
  8026f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026fd:	eb 35                	jmp    802734 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8026ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802702:	8b 40 08             	mov    0x8(%eax),%eax
  802705:	83 ec 04             	sub    $0x4,%esp
  802708:	50                   	push   %eax
  802709:	ff 75 0c             	pushl  0xc(%ebp)
  80270c:	ff 75 08             	pushl  0x8(%ebp)
  80270f:	e8 c1 03 00 00       	call   802ad5 <sys_getSharedObject>
  802714:	83 c4 10             	add    $0x10,%esp
  802717:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  80271a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80271e:	79 07                	jns    802727 <sget+0xa5>
				return (void*)NULL ;
  802720:	b8 00 00 00 00       	mov    $0x0,%eax
  802725:	eb 0d                	jmp    802734 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  802727:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272a:	8b 40 08             	mov    0x8(%eax),%eax
  80272d:	eb 05                	jmp    802734 <sget+0xb2>


		}
	return (void*)NULL ;
  80272f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802734:	c9                   	leave  
  802735:	c3                   	ret    

00802736 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80273c:	e8 a7 fb ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802741:	83 ec 04             	sub    $0x4,%esp
  802744:	68 40 4b 80 00       	push   $0x804b40
  802749:	68 f9 00 00 00       	push   $0xf9
  80274e:	68 33 4b 80 00       	push   $0x804b33
  802753:	e8 52 eb ff ff       	call   8012aa <_panic>

00802758 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802758:	55                   	push   %ebp
  802759:	89 e5                	mov    %esp,%ebp
  80275b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80275e:	83 ec 04             	sub    $0x4,%esp
  802761:	68 68 4b 80 00       	push   $0x804b68
  802766:	68 0d 01 00 00       	push   $0x10d
  80276b:	68 33 4b 80 00       	push   $0x804b33
  802770:	e8 35 eb ff ff       	call   8012aa <_panic>

00802775 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802775:	55                   	push   %ebp
  802776:	89 e5                	mov    %esp,%ebp
  802778:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80277b:	83 ec 04             	sub    $0x4,%esp
  80277e:	68 8c 4b 80 00       	push   $0x804b8c
  802783:	68 18 01 00 00       	push   $0x118
  802788:	68 33 4b 80 00       	push   $0x804b33
  80278d:	e8 18 eb ff ff       	call   8012aa <_panic>

00802792 <shrink>:

}
void shrink(uint32 newSize)
{
  802792:	55                   	push   %ebp
  802793:	89 e5                	mov    %esp,%ebp
  802795:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802798:	83 ec 04             	sub    $0x4,%esp
  80279b:	68 8c 4b 80 00       	push   $0x804b8c
  8027a0:	68 1d 01 00 00       	push   $0x11d
  8027a5:	68 33 4b 80 00       	push   $0x804b33
  8027aa:	e8 fb ea ff ff       	call   8012aa <_panic>

008027af <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
  8027b2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027b5:	83 ec 04             	sub    $0x4,%esp
  8027b8:	68 8c 4b 80 00       	push   $0x804b8c
  8027bd:	68 22 01 00 00       	push   $0x122
  8027c2:	68 33 4b 80 00       	push   $0x804b33
  8027c7:	e8 de ea ff ff       	call   8012aa <_panic>

008027cc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
  8027cf:	57                   	push   %edi
  8027d0:	56                   	push   %esi
  8027d1:	53                   	push   %ebx
  8027d2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8027d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027e1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8027e4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8027e7:	cd 30                	int    $0x30
  8027e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8027ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8027ef:	83 c4 10             	add    $0x10,%esp
  8027f2:	5b                   	pop    %ebx
  8027f3:	5e                   	pop    %esi
  8027f4:	5f                   	pop    %edi
  8027f5:	5d                   	pop    %ebp
  8027f6:	c3                   	ret    

008027f7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8027f7:	55                   	push   %ebp
  8027f8:	89 e5                	mov    %esp,%ebp
  8027fa:	83 ec 04             	sub    $0x4,%esp
  8027fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802800:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802803:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802807:	8b 45 08             	mov    0x8(%ebp),%eax
  80280a:	6a 00                	push   $0x0
  80280c:	6a 00                	push   $0x0
  80280e:	52                   	push   %edx
  80280f:	ff 75 0c             	pushl  0xc(%ebp)
  802812:	50                   	push   %eax
  802813:	6a 00                	push   $0x0
  802815:	e8 b2 ff ff ff       	call   8027cc <syscall>
  80281a:	83 c4 18             	add    $0x18,%esp
}
  80281d:	90                   	nop
  80281e:	c9                   	leave  
  80281f:	c3                   	ret    

00802820 <sys_cgetc>:

int
sys_cgetc(void)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802823:	6a 00                	push   $0x0
  802825:	6a 00                	push   $0x0
  802827:	6a 00                	push   $0x0
  802829:	6a 00                	push   $0x0
  80282b:	6a 00                	push   $0x0
  80282d:	6a 01                	push   $0x1
  80282f:	e8 98 ff ff ff       	call   8027cc <syscall>
  802834:	83 c4 18             	add    $0x18,%esp
}
  802837:	c9                   	leave  
  802838:	c3                   	ret    

00802839 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80283c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	6a 00                	push   $0x0
  802844:	6a 00                	push   $0x0
  802846:	6a 00                	push   $0x0
  802848:	52                   	push   %edx
  802849:	50                   	push   %eax
  80284a:	6a 05                	push   $0x5
  80284c:	e8 7b ff ff ff       	call   8027cc <syscall>
  802851:	83 c4 18             	add    $0x18,%esp
}
  802854:	c9                   	leave  
  802855:	c3                   	ret    

00802856 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	56                   	push   %esi
  80285a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80285b:	8b 75 18             	mov    0x18(%ebp),%esi
  80285e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802861:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802864:	8b 55 0c             	mov    0xc(%ebp),%edx
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	56                   	push   %esi
  80286b:	53                   	push   %ebx
  80286c:	51                   	push   %ecx
  80286d:	52                   	push   %edx
  80286e:	50                   	push   %eax
  80286f:	6a 06                	push   $0x6
  802871:	e8 56 ff ff ff       	call   8027cc <syscall>
  802876:	83 c4 18             	add    $0x18,%esp
}
  802879:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80287c:	5b                   	pop    %ebx
  80287d:	5e                   	pop    %esi
  80287e:	5d                   	pop    %ebp
  80287f:	c3                   	ret    

00802880 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802883:	8b 55 0c             	mov    0xc(%ebp),%edx
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	52                   	push   %edx
  802890:	50                   	push   %eax
  802891:	6a 07                	push   $0x7
  802893:	e8 34 ff ff ff       	call   8027cc <syscall>
  802898:	83 c4 18             	add    $0x18,%esp
}
  80289b:	c9                   	leave  
  80289c:	c3                   	ret    

0080289d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80289d:	55                   	push   %ebp
  80289e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	ff 75 0c             	pushl  0xc(%ebp)
  8028a9:	ff 75 08             	pushl  0x8(%ebp)
  8028ac:	6a 08                	push   $0x8
  8028ae:	e8 19 ff ff ff       	call   8027cc <syscall>
  8028b3:	83 c4 18             	add    $0x18,%esp
}
  8028b6:	c9                   	leave  
  8028b7:	c3                   	ret    

008028b8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8028b8:	55                   	push   %ebp
  8028b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8028bb:	6a 00                	push   $0x0
  8028bd:	6a 00                	push   $0x0
  8028bf:	6a 00                	push   $0x0
  8028c1:	6a 00                	push   $0x0
  8028c3:	6a 00                	push   $0x0
  8028c5:	6a 09                	push   $0x9
  8028c7:	e8 00 ff ff ff       	call   8027cc <syscall>
  8028cc:	83 c4 18             	add    $0x18,%esp
}
  8028cf:	c9                   	leave  
  8028d0:	c3                   	ret    

008028d1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8028d1:	55                   	push   %ebp
  8028d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 00                	push   $0x0
  8028de:	6a 0a                	push   $0xa
  8028e0:	e8 e7 fe ff ff       	call   8027cc <syscall>
  8028e5:	83 c4 18             	add    $0x18,%esp
}
  8028e8:	c9                   	leave  
  8028e9:	c3                   	ret    

008028ea <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 00                	push   $0x0
  8028f1:	6a 00                	push   $0x0
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 0b                	push   $0xb
  8028f9:	e8 ce fe ff ff       	call   8027cc <syscall>
  8028fe:	83 c4 18             	add    $0x18,%esp
}
  802901:	c9                   	leave  
  802902:	c3                   	ret    

00802903 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802903:	55                   	push   %ebp
  802904:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802906:	6a 00                	push   $0x0
  802908:	6a 00                	push   $0x0
  80290a:	6a 00                	push   $0x0
  80290c:	ff 75 0c             	pushl  0xc(%ebp)
  80290f:	ff 75 08             	pushl  0x8(%ebp)
  802912:	6a 0f                	push   $0xf
  802914:	e8 b3 fe ff ff       	call   8027cc <syscall>
  802919:	83 c4 18             	add    $0x18,%esp
	return;
  80291c:	90                   	nop
}
  80291d:	c9                   	leave  
  80291e:	c3                   	ret    

0080291f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80291f:	55                   	push   %ebp
  802920:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802922:	6a 00                	push   $0x0
  802924:	6a 00                	push   $0x0
  802926:	6a 00                	push   $0x0
  802928:	ff 75 0c             	pushl  0xc(%ebp)
  80292b:	ff 75 08             	pushl  0x8(%ebp)
  80292e:	6a 10                	push   $0x10
  802930:	e8 97 fe ff ff       	call   8027cc <syscall>
  802935:	83 c4 18             	add    $0x18,%esp
	return ;
  802938:	90                   	nop
}
  802939:	c9                   	leave  
  80293a:	c3                   	ret    

0080293b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80293b:	55                   	push   %ebp
  80293c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	ff 75 10             	pushl  0x10(%ebp)
  802945:	ff 75 0c             	pushl  0xc(%ebp)
  802948:	ff 75 08             	pushl  0x8(%ebp)
  80294b:	6a 11                	push   $0x11
  80294d:	e8 7a fe ff ff       	call   8027cc <syscall>
  802952:	83 c4 18             	add    $0x18,%esp
	return ;
  802955:	90                   	nop
}
  802956:	c9                   	leave  
  802957:	c3                   	ret    

00802958 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802958:	55                   	push   %ebp
  802959:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	6a 0c                	push   $0xc
  802967:	e8 60 fe ff ff       	call   8027cc <syscall>
  80296c:	83 c4 18             	add    $0x18,%esp
}
  80296f:	c9                   	leave  
  802970:	c3                   	ret    

00802971 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802971:	55                   	push   %ebp
  802972:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802974:	6a 00                	push   $0x0
  802976:	6a 00                	push   $0x0
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	ff 75 08             	pushl  0x8(%ebp)
  80297f:	6a 0d                	push   $0xd
  802981:	e8 46 fe ff ff       	call   8027cc <syscall>
  802986:	83 c4 18             	add    $0x18,%esp
}
  802989:	c9                   	leave  
  80298a:	c3                   	ret    

0080298b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80298e:	6a 00                	push   $0x0
  802990:	6a 00                	push   $0x0
  802992:	6a 00                	push   $0x0
  802994:	6a 00                	push   $0x0
  802996:	6a 00                	push   $0x0
  802998:	6a 0e                	push   $0xe
  80299a:	e8 2d fe ff ff       	call   8027cc <syscall>
  80299f:	83 c4 18             	add    $0x18,%esp
}
  8029a2:	90                   	nop
  8029a3:	c9                   	leave  
  8029a4:	c3                   	ret    

008029a5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8029a5:	55                   	push   %ebp
  8029a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8029a8:	6a 00                	push   $0x0
  8029aa:	6a 00                	push   $0x0
  8029ac:	6a 00                	push   $0x0
  8029ae:	6a 00                	push   $0x0
  8029b0:	6a 00                	push   $0x0
  8029b2:	6a 13                	push   $0x13
  8029b4:	e8 13 fe ff ff       	call   8027cc <syscall>
  8029b9:	83 c4 18             	add    $0x18,%esp
}
  8029bc:	90                   	nop
  8029bd:	c9                   	leave  
  8029be:	c3                   	ret    

008029bf <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8029bf:	55                   	push   %ebp
  8029c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8029c2:	6a 00                	push   $0x0
  8029c4:	6a 00                	push   $0x0
  8029c6:	6a 00                	push   $0x0
  8029c8:	6a 00                	push   $0x0
  8029ca:	6a 00                	push   $0x0
  8029cc:	6a 14                	push   $0x14
  8029ce:	e8 f9 fd ff ff       	call   8027cc <syscall>
  8029d3:	83 c4 18             	add    $0x18,%esp
}
  8029d6:	90                   	nop
  8029d7:	c9                   	leave  
  8029d8:	c3                   	ret    

008029d9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8029d9:	55                   	push   %ebp
  8029da:	89 e5                	mov    %esp,%ebp
  8029dc:	83 ec 04             	sub    $0x4,%esp
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8029e5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029e9:	6a 00                	push   $0x0
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 00                	push   $0x0
  8029f1:	50                   	push   %eax
  8029f2:	6a 15                	push   $0x15
  8029f4:	e8 d3 fd ff ff       	call   8027cc <syscall>
  8029f9:	83 c4 18             	add    $0x18,%esp
}
  8029fc:	90                   	nop
  8029fd:	c9                   	leave  
  8029fe:	c3                   	ret    

008029ff <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8029ff:	55                   	push   %ebp
  802a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 16                	push   $0x16
  802a0e:	e8 b9 fd ff ff       	call   8027cc <syscall>
  802a13:	83 c4 18             	add    $0x18,%esp
}
  802a16:	90                   	nop
  802a17:	c9                   	leave  
  802a18:	c3                   	ret    

00802a19 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802a19:	55                   	push   %ebp
  802a1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	6a 00                	push   $0x0
  802a21:	6a 00                	push   $0x0
  802a23:	6a 00                	push   $0x0
  802a25:	ff 75 0c             	pushl  0xc(%ebp)
  802a28:	50                   	push   %eax
  802a29:	6a 17                	push   $0x17
  802a2b:	e8 9c fd ff ff       	call   8027cc <syscall>
  802a30:	83 c4 18             	add    $0x18,%esp
}
  802a33:	c9                   	leave  
  802a34:	c3                   	ret    

00802a35 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802a35:	55                   	push   %ebp
  802a36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	6a 00                	push   $0x0
  802a40:	6a 00                	push   $0x0
  802a42:	6a 00                	push   $0x0
  802a44:	52                   	push   %edx
  802a45:	50                   	push   %eax
  802a46:	6a 1a                	push   $0x1a
  802a48:	e8 7f fd ff ff       	call   8027cc <syscall>
  802a4d:	83 c4 18             	add    $0x18,%esp
}
  802a50:	c9                   	leave  
  802a51:	c3                   	ret    

00802a52 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802a52:	55                   	push   %ebp
  802a53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a58:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5b:	6a 00                	push   $0x0
  802a5d:	6a 00                	push   $0x0
  802a5f:	6a 00                	push   $0x0
  802a61:	52                   	push   %edx
  802a62:	50                   	push   %eax
  802a63:	6a 18                	push   $0x18
  802a65:	e8 62 fd ff ff       	call   8027cc <syscall>
  802a6a:	83 c4 18             	add    $0x18,%esp
}
  802a6d:	90                   	nop
  802a6e:	c9                   	leave  
  802a6f:	c3                   	ret    

00802a70 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802a70:	55                   	push   %ebp
  802a71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 00                	push   $0x0
  802a7d:	6a 00                	push   $0x0
  802a7f:	52                   	push   %edx
  802a80:	50                   	push   %eax
  802a81:	6a 19                	push   $0x19
  802a83:	e8 44 fd ff ff       	call   8027cc <syscall>
  802a88:	83 c4 18             	add    $0x18,%esp
}
  802a8b:	90                   	nop
  802a8c:	c9                   	leave  
  802a8d:	c3                   	ret    

00802a8e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802a8e:	55                   	push   %ebp
  802a8f:	89 e5                	mov    %esp,%ebp
  802a91:	83 ec 04             	sub    $0x4,%esp
  802a94:	8b 45 10             	mov    0x10(%ebp),%eax
  802a97:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802a9a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802a9d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	6a 00                	push   $0x0
  802aa6:	51                   	push   %ecx
  802aa7:	52                   	push   %edx
  802aa8:	ff 75 0c             	pushl  0xc(%ebp)
  802aab:	50                   	push   %eax
  802aac:	6a 1b                	push   $0x1b
  802aae:	e8 19 fd ff ff       	call   8027cc <syscall>
  802ab3:	83 c4 18             	add    $0x18,%esp
}
  802ab6:	c9                   	leave  
  802ab7:	c3                   	ret    

00802ab8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802ab8:	55                   	push   %ebp
  802ab9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	6a 00                	push   $0x0
  802ac3:	6a 00                	push   $0x0
  802ac5:	6a 00                	push   $0x0
  802ac7:	52                   	push   %edx
  802ac8:	50                   	push   %eax
  802ac9:	6a 1c                	push   $0x1c
  802acb:	e8 fc fc ff ff       	call   8027cc <syscall>
  802ad0:	83 c4 18             	add    $0x18,%esp
}
  802ad3:	c9                   	leave  
  802ad4:	c3                   	ret    

00802ad5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802ad5:	55                   	push   %ebp
  802ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802ad8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	51                   	push   %ecx
  802ae6:	52                   	push   %edx
  802ae7:	50                   	push   %eax
  802ae8:	6a 1d                	push   $0x1d
  802aea:	e8 dd fc ff ff       	call   8027cc <syscall>
  802aef:	83 c4 18             	add    $0x18,%esp
}
  802af2:	c9                   	leave  
  802af3:	c3                   	ret    

00802af4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802af4:	55                   	push   %ebp
  802af5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802af7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	6a 00                	push   $0x0
  802aff:	6a 00                	push   $0x0
  802b01:	6a 00                	push   $0x0
  802b03:	52                   	push   %edx
  802b04:	50                   	push   %eax
  802b05:	6a 1e                	push   $0x1e
  802b07:	e8 c0 fc ff ff       	call   8027cc <syscall>
  802b0c:	83 c4 18             	add    $0x18,%esp
}
  802b0f:	c9                   	leave  
  802b10:	c3                   	ret    

00802b11 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802b11:	55                   	push   %ebp
  802b12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802b14:	6a 00                	push   $0x0
  802b16:	6a 00                	push   $0x0
  802b18:	6a 00                	push   $0x0
  802b1a:	6a 00                	push   $0x0
  802b1c:	6a 00                	push   $0x0
  802b1e:	6a 1f                	push   $0x1f
  802b20:	e8 a7 fc ff ff       	call   8027cc <syscall>
  802b25:	83 c4 18             	add    $0x18,%esp
}
  802b28:	c9                   	leave  
  802b29:	c3                   	ret    

00802b2a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802b2a:	55                   	push   %ebp
  802b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	6a 00                	push   $0x0
  802b32:	ff 75 14             	pushl  0x14(%ebp)
  802b35:	ff 75 10             	pushl  0x10(%ebp)
  802b38:	ff 75 0c             	pushl  0xc(%ebp)
  802b3b:	50                   	push   %eax
  802b3c:	6a 20                	push   $0x20
  802b3e:	e8 89 fc ff ff       	call   8027cc <syscall>
  802b43:	83 c4 18             	add    $0x18,%esp
}
  802b46:	c9                   	leave  
  802b47:	c3                   	ret    

00802b48 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802b48:	55                   	push   %ebp
  802b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	6a 00                	push   $0x0
  802b50:	6a 00                	push   $0x0
  802b52:	6a 00                	push   $0x0
  802b54:	6a 00                	push   $0x0
  802b56:	50                   	push   %eax
  802b57:	6a 21                	push   $0x21
  802b59:	e8 6e fc ff ff       	call   8027cc <syscall>
  802b5e:	83 c4 18             	add    $0x18,%esp
}
  802b61:	90                   	nop
  802b62:	c9                   	leave  
  802b63:	c3                   	ret    

00802b64 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802b64:	55                   	push   %ebp
  802b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802b67:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	50                   	push   %eax
  802b73:	6a 22                	push   $0x22
  802b75:	e8 52 fc ff ff       	call   8027cc <syscall>
  802b7a:	83 c4 18             	add    $0x18,%esp
}
  802b7d:	c9                   	leave  
  802b7e:	c3                   	ret    

00802b7f <sys_getenvid>:

int32 sys_getenvid(void)
{
  802b7f:	55                   	push   %ebp
  802b80:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802b82:	6a 00                	push   $0x0
  802b84:	6a 00                	push   $0x0
  802b86:	6a 00                	push   $0x0
  802b88:	6a 00                	push   $0x0
  802b8a:	6a 00                	push   $0x0
  802b8c:	6a 02                	push   $0x2
  802b8e:	e8 39 fc ff ff       	call   8027cc <syscall>
  802b93:	83 c4 18             	add    $0x18,%esp
}
  802b96:	c9                   	leave  
  802b97:	c3                   	ret    

00802b98 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802b98:	55                   	push   %ebp
  802b99:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802b9b:	6a 00                	push   $0x0
  802b9d:	6a 00                	push   $0x0
  802b9f:	6a 00                	push   $0x0
  802ba1:	6a 00                	push   $0x0
  802ba3:	6a 00                	push   $0x0
  802ba5:	6a 03                	push   $0x3
  802ba7:	e8 20 fc ff ff       	call   8027cc <syscall>
  802bac:	83 c4 18             	add    $0x18,%esp
}
  802baf:	c9                   	leave  
  802bb0:	c3                   	ret    

00802bb1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802bb1:	55                   	push   %ebp
  802bb2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802bb4:	6a 00                	push   $0x0
  802bb6:	6a 00                	push   $0x0
  802bb8:	6a 00                	push   $0x0
  802bba:	6a 00                	push   $0x0
  802bbc:	6a 00                	push   $0x0
  802bbe:	6a 04                	push   $0x4
  802bc0:	e8 07 fc ff ff       	call   8027cc <syscall>
  802bc5:	83 c4 18             	add    $0x18,%esp
}
  802bc8:	c9                   	leave  
  802bc9:	c3                   	ret    

00802bca <sys_exit_env>:


void sys_exit_env(void)
{
  802bca:	55                   	push   %ebp
  802bcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802bcd:	6a 00                	push   $0x0
  802bcf:	6a 00                	push   $0x0
  802bd1:	6a 00                	push   $0x0
  802bd3:	6a 00                	push   $0x0
  802bd5:	6a 00                	push   $0x0
  802bd7:	6a 23                	push   $0x23
  802bd9:	e8 ee fb ff ff       	call   8027cc <syscall>
  802bde:	83 c4 18             	add    $0x18,%esp
}
  802be1:	90                   	nop
  802be2:	c9                   	leave  
  802be3:	c3                   	ret    

00802be4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802be4:	55                   	push   %ebp
  802be5:	89 e5                	mov    %esp,%ebp
  802be7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802bea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802bed:	8d 50 04             	lea    0x4(%eax),%edx
  802bf0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802bf3:	6a 00                	push   $0x0
  802bf5:	6a 00                	push   $0x0
  802bf7:	6a 00                	push   $0x0
  802bf9:	52                   	push   %edx
  802bfa:	50                   	push   %eax
  802bfb:	6a 24                	push   $0x24
  802bfd:	e8 ca fb ff ff       	call   8027cc <syscall>
  802c02:	83 c4 18             	add    $0x18,%esp
	return result;
  802c05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802c0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c0e:	89 01                	mov    %eax,(%ecx)
  802c10:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	c9                   	leave  
  802c17:	c2 04 00             	ret    $0x4

00802c1a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802c1a:	55                   	push   %ebp
  802c1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802c1d:	6a 00                	push   $0x0
  802c1f:	6a 00                	push   $0x0
  802c21:	ff 75 10             	pushl  0x10(%ebp)
  802c24:	ff 75 0c             	pushl  0xc(%ebp)
  802c27:	ff 75 08             	pushl  0x8(%ebp)
  802c2a:	6a 12                	push   $0x12
  802c2c:	e8 9b fb ff ff       	call   8027cc <syscall>
  802c31:	83 c4 18             	add    $0x18,%esp
	return ;
  802c34:	90                   	nop
}
  802c35:	c9                   	leave  
  802c36:	c3                   	ret    

00802c37 <sys_rcr2>:
uint32 sys_rcr2()
{
  802c37:	55                   	push   %ebp
  802c38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802c3a:	6a 00                	push   $0x0
  802c3c:	6a 00                	push   $0x0
  802c3e:	6a 00                	push   $0x0
  802c40:	6a 00                	push   $0x0
  802c42:	6a 00                	push   $0x0
  802c44:	6a 25                	push   $0x25
  802c46:	e8 81 fb ff ff       	call   8027cc <syscall>
  802c4b:	83 c4 18             	add    $0x18,%esp
}
  802c4e:	c9                   	leave  
  802c4f:	c3                   	ret    

00802c50 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802c50:	55                   	push   %ebp
  802c51:	89 e5                	mov    %esp,%ebp
  802c53:	83 ec 04             	sub    $0x4,%esp
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802c5c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802c60:	6a 00                	push   $0x0
  802c62:	6a 00                	push   $0x0
  802c64:	6a 00                	push   $0x0
  802c66:	6a 00                	push   $0x0
  802c68:	50                   	push   %eax
  802c69:	6a 26                	push   $0x26
  802c6b:	e8 5c fb ff ff       	call   8027cc <syscall>
  802c70:	83 c4 18             	add    $0x18,%esp
	return ;
  802c73:	90                   	nop
}
  802c74:	c9                   	leave  
  802c75:	c3                   	ret    

00802c76 <rsttst>:
void rsttst()
{
  802c76:	55                   	push   %ebp
  802c77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802c79:	6a 00                	push   $0x0
  802c7b:	6a 00                	push   $0x0
  802c7d:	6a 00                	push   $0x0
  802c7f:	6a 00                	push   $0x0
  802c81:	6a 00                	push   $0x0
  802c83:	6a 28                	push   $0x28
  802c85:	e8 42 fb ff ff       	call   8027cc <syscall>
  802c8a:	83 c4 18             	add    $0x18,%esp
	return ;
  802c8d:	90                   	nop
}
  802c8e:	c9                   	leave  
  802c8f:	c3                   	ret    

00802c90 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802c90:	55                   	push   %ebp
  802c91:	89 e5                	mov    %esp,%ebp
  802c93:	83 ec 04             	sub    $0x4,%esp
  802c96:	8b 45 14             	mov    0x14(%ebp),%eax
  802c99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802c9c:	8b 55 18             	mov    0x18(%ebp),%edx
  802c9f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ca3:	52                   	push   %edx
  802ca4:	50                   	push   %eax
  802ca5:	ff 75 10             	pushl  0x10(%ebp)
  802ca8:	ff 75 0c             	pushl  0xc(%ebp)
  802cab:	ff 75 08             	pushl  0x8(%ebp)
  802cae:	6a 27                	push   $0x27
  802cb0:	e8 17 fb ff ff       	call   8027cc <syscall>
  802cb5:	83 c4 18             	add    $0x18,%esp
	return ;
  802cb8:	90                   	nop
}
  802cb9:	c9                   	leave  
  802cba:	c3                   	ret    

00802cbb <chktst>:
void chktst(uint32 n)
{
  802cbb:	55                   	push   %ebp
  802cbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802cbe:	6a 00                	push   $0x0
  802cc0:	6a 00                	push   $0x0
  802cc2:	6a 00                	push   $0x0
  802cc4:	6a 00                	push   $0x0
  802cc6:	ff 75 08             	pushl  0x8(%ebp)
  802cc9:	6a 29                	push   $0x29
  802ccb:	e8 fc fa ff ff       	call   8027cc <syscall>
  802cd0:	83 c4 18             	add    $0x18,%esp
	return ;
  802cd3:	90                   	nop
}
  802cd4:	c9                   	leave  
  802cd5:	c3                   	ret    

00802cd6 <inctst>:

void inctst()
{
  802cd6:	55                   	push   %ebp
  802cd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802cd9:	6a 00                	push   $0x0
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 00                	push   $0x0
  802cdf:	6a 00                	push   $0x0
  802ce1:	6a 00                	push   $0x0
  802ce3:	6a 2a                	push   $0x2a
  802ce5:	e8 e2 fa ff ff       	call   8027cc <syscall>
  802cea:	83 c4 18             	add    $0x18,%esp
	return ;
  802ced:	90                   	nop
}
  802cee:	c9                   	leave  
  802cef:	c3                   	ret    

00802cf0 <gettst>:
uint32 gettst()
{
  802cf0:	55                   	push   %ebp
  802cf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	6a 00                	push   $0x0
  802cf9:	6a 00                	push   $0x0
  802cfb:	6a 00                	push   $0x0
  802cfd:	6a 2b                	push   $0x2b
  802cff:	e8 c8 fa ff ff       	call   8027cc <syscall>
  802d04:	83 c4 18             	add    $0x18,%esp
}
  802d07:	c9                   	leave  
  802d08:	c3                   	ret    

00802d09 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802d09:	55                   	push   %ebp
  802d0a:	89 e5                	mov    %esp,%ebp
  802d0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d0f:	6a 00                	push   $0x0
  802d11:	6a 00                	push   $0x0
  802d13:	6a 00                	push   $0x0
  802d15:	6a 00                	push   $0x0
  802d17:	6a 00                	push   $0x0
  802d19:	6a 2c                	push   $0x2c
  802d1b:	e8 ac fa ff ff       	call   8027cc <syscall>
  802d20:	83 c4 18             	add    $0x18,%esp
  802d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802d26:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802d2a:	75 07                	jne    802d33 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802d2c:	b8 01 00 00 00       	mov    $0x1,%eax
  802d31:	eb 05                	jmp    802d38 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d38:	c9                   	leave  
  802d39:	c3                   	ret    

00802d3a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802d3a:	55                   	push   %ebp
  802d3b:	89 e5                	mov    %esp,%ebp
  802d3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d40:	6a 00                	push   $0x0
  802d42:	6a 00                	push   $0x0
  802d44:	6a 00                	push   $0x0
  802d46:	6a 00                	push   $0x0
  802d48:	6a 00                	push   $0x0
  802d4a:	6a 2c                	push   $0x2c
  802d4c:	e8 7b fa ff ff       	call   8027cc <syscall>
  802d51:	83 c4 18             	add    $0x18,%esp
  802d54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802d57:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802d5b:	75 07                	jne    802d64 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802d5d:	b8 01 00 00 00       	mov    $0x1,%eax
  802d62:	eb 05                	jmp    802d69 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d69:	c9                   	leave  
  802d6a:	c3                   	ret    

00802d6b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802d6b:	55                   	push   %ebp
  802d6c:	89 e5                	mov    %esp,%ebp
  802d6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d71:	6a 00                	push   $0x0
  802d73:	6a 00                	push   $0x0
  802d75:	6a 00                	push   $0x0
  802d77:	6a 00                	push   $0x0
  802d79:	6a 00                	push   $0x0
  802d7b:	6a 2c                	push   $0x2c
  802d7d:	e8 4a fa ff ff       	call   8027cc <syscall>
  802d82:	83 c4 18             	add    $0x18,%esp
  802d85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802d88:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802d8c:	75 07                	jne    802d95 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802d93:	eb 05                	jmp    802d9a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d9a:	c9                   	leave  
  802d9b:	c3                   	ret    

00802d9c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802d9c:	55                   	push   %ebp
  802d9d:	89 e5                	mov    %esp,%ebp
  802d9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802da2:	6a 00                	push   $0x0
  802da4:	6a 00                	push   $0x0
  802da6:	6a 00                	push   $0x0
  802da8:	6a 00                	push   $0x0
  802daa:	6a 00                	push   $0x0
  802dac:	6a 2c                	push   $0x2c
  802dae:	e8 19 fa ff ff       	call   8027cc <syscall>
  802db3:	83 c4 18             	add    $0x18,%esp
  802db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802db9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802dbd:	75 07                	jne    802dc6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802dbf:	b8 01 00 00 00       	mov    $0x1,%eax
  802dc4:	eb 05                	jmp    802dcb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dcb:	c9                   	leave  
  802dcc:	c3                   	ret    

00802dcd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802dcd:	55                   	push   %ebp
  802dce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802dd0:	6a 00                	push   $0x0
  802dd2:	6a 00                	push   $0x0
  802dd4:	6a 00                	push   $0x0
  802dd6:	6a 00                	push   $0x0
  802dd8:	ff 75 08             	pushl  0x8(%ebp)
  802ddb:	6a 2d                	push   $0x2d
  802ddd:	e8 ea f9 ff ff       	call   8027cc <syscall>
  802de2:	83 c4 18             	add    $0x18,%esp
	return ;
  802de5:	90                   	nop
}
  802de6:	c9                   	leave  
  802de7:	c3                   	ret    

00802de8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802de8:	55                   	push   %ebp
  802de9:	89 e5                	mov    %esp,%ebp
  802deb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802dec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802def:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802df2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df5:	8b 45 08             	mov    0x8(%ebp),%eax
  802df8:	6a 00                	push   $0x0
  802dfa:	53                   	push   %ebx
  802dfb:	51                   	push   %ecx
  802dfc:	52                   	push   %edx
  802dfd:	50                   	push   %eax
  802dfe:	6a 2e                	push   $0x2e
  802e00:	e8 c7 f9 ff ff       	call   8027cc <syscall>
  802e05:	83 c4 18             	add    $0x18,%esp
}
  802e08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e0b:	c9                   	leave  
  802e0c:	c3                   	ret    

00802e0d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802e0d:	55                   	push   %ebp
  802e0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	6a 00                	push   $0x0
  802e18:	6a 00                	push   $0x0
  802e1a:	6a 00                	push   $0x0
  802e1c:	52                   	push   %edx
  802e1d:	50                   	push   %eax
  802e1e:	6a 2f                	push   $0x2f
  802e20:	e8 a7 f9 ff ff       	call   8027cc <syscall>
  802e25:	83 c4 18             	add    $0x18,%esp
}
  802e28:	c9                   	leave  
  802e29:	c3                   	ret    

00802e2a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802e2a:	55                   	push   %ebp
  802e2b:	89 e5                	mov    %esp,%ebp
  802e2d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802e30:	83 ec 0c             	sub    $0xc,%esp
  802e33:	68 9c 4b 80 00       	push   $0x804b9c
  802e38:	e8 21 e7 ff ff       	call   80155e <cprintf>
  802e3d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802e40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802e47:	83 ec 0c             	sub    $0xc,%esp
  802e4a:	68 c8 4b 80 00       	push   $0x804bc8
  802e4f:	e8 0a e7 ff ff       	call   80155e <cprintf>
  802e54:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802e57:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e5b:	a1 38 51 80 00       	mov    0x805138,%eax
  802e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e63:	eb 56                	jmp    802ebb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802e65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e69:	74 1c                	je     802e87 <print_mem_block_lists+0x5d>
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 50 08             	mov    0x8(%eax),%edx
  802e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e74:	8b 48 08             	mov    0x8(%eax),%ecx
  802e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7d:	01 c8                	add    %ecx,%eax
  802e7f:	39 c2                	cmp    %eax,%edx
  802e81:	73 04                	jae    802e87 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802e83:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 50 08             	mov    0x8(%eax),%edx
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 40 0c             	mov    0xc(%eax),%eax
  802e93:	01 c2                	add    %eax,%edx
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 40 08             	mov    0x8(%eax),%eax
  802e9b:	83 ec 04             	sub    $0x4,%esp
  802e9e:	52                   	push   %edx
  802e9f:	50                   	push   %eax
  802ea0:	68 dd 4b 80 00       	push   $0x804bdd
  802ea5:	e8 b4 e6 ff ff       	call   80155e <cprintf>
  802eaa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802eb3:	a1 40 51 80 00       	mov    0x805140,%eax
  802eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebf:	74 07                	je     802ec8 <print_mem_block_lists+0x9e>
  802ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec4:	8b 00                	mov    (%eax),%eax
  802ec6:	eb 05                	jmp    802ecd <print_mem_block_lists+0xa3>
  802ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ecd:	a3 40 51 80 00       	mov    %eax,0x805140
  802ed2:	a1 40 51 80 00       	mov    0x805140,%eax
  802ed7:	85 c0                	test   %eax,%eax
  802ed9:	75 8a                	jne    802e65 <print_mem_block_lists+0x3b>
  802edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edf:	75 84                	jne    802e65 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802ee1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802ee5:	75 10                	jne    802ef7 <print_mem_block_lists+0xcd>
  802ee7:	83 ec 0c             	sub    $0xc,%esp
  802eea:	68 ec 4b 80 00       	push   $0x804bec
  802eef:	e8 6a e6 ff ff       	call   80155e <cprintf>
  802ef4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802ef7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802efe:	83 ec 0c             	sub    $0xc,%esp
  802f01:	68 10 4c 80 00       	push   $0x804c10
  802f06:	e8 53 e6 ff ff       	call   80155e <cprintf>
  802f0b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802f0e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802f12:	a1 40 50 80 00       	mov    0x805040,%eax
  802f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f1a:	eb 56                	jmp    802f72 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802f1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f20:	74 1c                	je     802f3e <print_mem_block_lists+0x114>
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 50 08             	mov    0x8(%eax),%edx
  802f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2b:	8b 48 08             	mov    0x8(%eax),%ecx
  802f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f31:	8b 40 0c             	mov    0xc(%eax),%eax
  802f34:	01 c8                	add    %ecx,%eax
  802f36:	39 c2                	cmp    %eax,%edx
  802f38:	73 04                	jae    802f3e <print_mem_block_lists+0x114>
			sorted = 0 ;
  802f3a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 50 08             	mov    0x8(%eax),%edx
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4a:	01 c2                	add    %eax,%edx
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	8b 40 08             	mov    0x8(%eax),%eax
  802f52:	83 ec 04             	sub    $0x4,%esp
  802f55:	52                   	push   %edx
  802f56:	50                   	push   %eax
  802f57:	68 dd 4b 80 00       	push   $0x804bdd
  802f5c:	e8 fd e5 ff ff       	call   80155e <cprintf>
  802f61:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802f6a:	a1 48 50 80 00       	mov    0x805048,%eax
  802f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f76:	74 07                	je     802f7f <print_mem_block_lists+0x155>
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	eb 05                	jmp    802f84 <print_mem_block_lists+0x15a>
  802f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f84:	a3 48 50 80 00       	mov    %eax,0x805048
  802f89:	a1 48 50 80 00       	mov    0x805048,%eax
  802f8e:	85 c0                	test   %eax,%eax
  802f90:	75 8a                	jne    802f1c <print_mem_block_lists+0xf2>
  802f92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f96:	75 84                	jne    802f1c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802f98:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802f9c:	75 10                	jne    802fae <print_mem_block_lists+0x184>
  802f9e:	83 ec 0c             	sub    $0xc,%esp
  802fa1:	68 28 4c 80 00       	push   $0x804c28
  802fa6:	e8 b3 e5 ff ff       	call   80155e <cprintf>
  802fab:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802fae:	83 ec 0c             	sub    $0xc,%esp
  802fb1:	68 9c 4b 80 00       	push   $0x804b9c
  802fb6:	e8 a3 e5 ff ff       	call   80155e <cprintf>
  802fbb:	83 c4 10             	add    $0x10,%esp

}
  802fbe:	90                   	nop
  802fbf:	c9                   	leave  
  802fc0:	c3                   	ret    

00802fc1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802fc1:	55                   	push   %ebp
  802fc2:	89 e5                	mov    %esp,%ebp
  802fc4:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802fc7:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802fce:	00 00 00 
  802fd1:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802fd8:	00 00 00 
  802fdb:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802fe2:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802fe5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802fec:	e9 9e 00 00 00       	jmp    80308f <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802ff1:	a1 50 50 80 00       	mov    0x805050,%eax
  802ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff9:	c1 e2 04             	shl    $0x4,%edx
  802ffc:	01 d0                	add    %edx,%eax
  802ffe:	85 c0                	test   %eax,%eax
  803000:	75 14                	jne    803016 <initialize_MemBlocksList+0x55>
  803002:	83 ec 04             	sub    $0x4,%esp
  803005:	68 50 4c 80 00       	push   $0x804c50
  80300a:	6a 43                	push   $0x43
  80300c:	68 73 4c 80 00       	push   $0x804c73
  803011:	e8 94 e2 ff ff       	call   8012aa <_panic>
  803016:	a1 50 50 80 00       	mov    0x805050,%eax
  80301b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80301e:	c1 e2 04             	shl    $0x4,%edx
  803021:	01 d0                	add    %edx,%eax
  803023:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803029:	89 10                	mov    %edx,(%eax)
  80302b:	8b 00                	mov    (%eax),%eax
  80302d:	85 c0                	test   %eax,%eax
  80302f:	74 18                	je     803049 <initialize_MemBlocksList+0x88>
  803031:	a1 48 51 80 00       	mov    0x805148,%eax
  803036:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80303c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80303f:	c1 e1 04             	shl    $0x4,%ecx
  803042:	01 ca                	add    %ecx,%edx
  803044:	89 50 04             	mov    %edx,0x4(%eax)
  803047:	eb 12                	jmp    80305b <initialize_MemBlocksList+0x9a>
  803049:	a1 50 50 80 00       	mov    0x805050,%eax
  80304e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803051:	c1 e2 04             	shl    $0x4,%edx
  803054:	01 d0                	add    %edx,%eax
  803056:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80305b:	a1 50 50 80 00       	mov    0x805050,%eax
  803060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803063:	c1 e2 04             	shl    $0x4,%edx
  803066:	01 d0                	add    %edx,%eax
  803068:	a3 48 51 80 00       	mov    %eax,0x805148
  80306d:	a1 50 50 80 00       	mov    0x805050,%eax
  803072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803075:	c1 e2 04             	shl    $0x4,%edx
  803078:	01 d0                	add    %edx,%eax
  80307a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803081:	a1 54 51 80 00       	mov    0x805154,%eax
  803086:	40                   	inc    %eax
  803087:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80308c:	ff 45 f4             	incl   -0xc(%ebp)
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	3b 45 08             	cmp    0x8(%ebp),%eax
  803095:	0f 82 56 ff ff ff    	jb     802ff1 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80309b:	90                   	nop
  80309c:	c9                   	leave  
  80309d:	c3                   	ret    

0080309e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80309e:	55                   	push   %ebp
  80309f:	89 e5                	mov    %esp,%ebp
  8030a1:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8030a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8030ac:	eb 18                	jmp    8030c6 <find_block+0x28>
	{
		if (ele->sva==va)
  8030ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030b1:	8b 40 08             	mov    0x8(%eax),%eax
  8030b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030b7:	75 05                	jne    8030be <find_block+0x20>
			return ele;
  8030b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030bc:	eb 7b                	jmp    803139 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8030be:	a1 40 51 80 00       	mov    0x805140,%eax
  8030c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8030c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8030ca:	74 07                	je     8030d3 <find_block+0x35>
  8030cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030cf:	8b 00                	mov    (%eax),%eax
  8030d1:	eb 05                	jmp    8030d8 <find_block+0x3a>
  8030d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d8:	a3 40 51 80 00       	mov    %eax,0x805140
  8030dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8030e2:	85 c0                	test   %eax,%eax
  8030e4:	75 c8                	jne    8030ae <find_block+0x10>
  8030e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8030ea:	75 c2                	jne    8030ae <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8030ec:	a1 40 50 80 00       	mov    0x805040,%eax
  8030f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8030f4:	eb 18                	jmp    80310e <find_block+0x70>
	{
		if (ele->sva==va)
  8030f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030f9:	8b 40 08             	mov    0x8(%eax),%eax
  8030fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030ff:	75 05                	jne    803106 <find_block+0x68>
					return ele;
  803101:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803104:	eb 33                	jmp    803139 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  803106:	a1 48 50 80 00       	mov    0x805048,%eax
  80310b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80310e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803112:	74 07                	je     80311b <find_block+0x7d>
  803114:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803117:	8b 00                	mov    (%eax),%eax
  803119:	eb 05                	jmp    803120 <find_block+0x82>
  80311b:	b8 00 00 00 00       	mov    $0x0,%eax
  803120:	a3 48 50 80 00       	mov    %eax,0x805048
  803125:	a1 48 50 80 00       	mov    0x805048,%eax
  80312a:	85 c0                	test   %eax,%eax
  80312c:	75 c8                	jne    8030f6 <find_block+0x58>
  80312e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803132:	75 c2                	jne    8030f6 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  803134:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803139:	c9                   	leave  
  80313a:	c3                   	ret    

0080313b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80313b:	55                   	push   %ebp
  80313c:	89 e5                	mov    %esp,%ebp
  80313e:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  803141:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803146:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  803149:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80314d:	75 62                	jne    8031b1 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80314f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803153:	75 14                	jne    803169 <insert_sorted_allocList+0x2e>
  803155:	83 ec 04             	sub    $0x4,%esp
  803158:	68 50 4c 80 00       	push   $0x804c50
  80315d:	6a 69                	push   $0x69
  80315f:	68 73 4c 80 00       	push   $0x804c73
  803164:	e8 41 e1 ff ff       	call   8012aa <_panic>
  803169:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	89 10                	mov    %edx,(%eax)
  803174:	8b 45 08             	mov    0x8(%ebp),%eax
  803177:	8b 00                	mov    (%eax),%eax
  803179:	85 c0                	test   %eax,%eax
  80317b:	74 0d                	je     80318a <insert_sorted_allocList+0x4f>
  80317d:	a1 40 50 80 00       	mov    0x805040,%eax
  803182:	8b 55 08             	mov    0x8(%ebp),%edx
  803185:	89 50 04             	mov    %edx,0x4(%eax)
  803188:	eb 08                	jmp    803192 <insert_sorted_allocList+0x57>
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	a3 44 50 80 00       	mov    %eax,0x805044
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	a3 40 50 80 00       	mov    %eax,0x805040
  80319a:	8b 45 08             	mov    0x8(%ebp),%eax
  80319d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8031a9:	40                   	inc    %eax
  8031aa:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8031af:	eb 72                	jmp    803223 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8031b1:	a1 40 50 80 00       	mov    0x805040,%eax
  8031b6:	8b 50 08             	mov    0x8(%eax),%edx
  8031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bc:	8b 40 08             	mov    0x8(%eax),%eax
  8031bf:	39 c2                	cmp    %eax,%edx
  8031c1:	76 60                	jbe    803223 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8031c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031c7:	75 14                	jne    8031dd <insert_sorted_allocList+0xa2>
  8031c9:	83 ec 04             	sub    $0x4,%esp
  8031cc:	68 50 4c 80 00       	push   $0x804c50
  8031d1:	6a 6d                	push   $0x6d
  8031d3:	68 73 4c 80 00       	push   $0x804c73
  8031d8:	e8 cd e0 ff ff       	call   8012aa <_panic>
  8031dd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	89 10                	mov    %edx,(%eax)
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	85 c0                	test   %eax,%eax
  8031ef:	74 0d                	je     8031fe <insert_sorted_allocList+0xc3>
  8031f1:	a1 40 50 80 00       	mov    0x805040,%eax
  8031f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f9:	89 50 04             	mov    %edx,0x4(%eax)
  8031fc:	eb 08                	jmp    803206 <insert_sorted_allocList+0xcb>
  8031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803201:	a3 44 50 80 00       	mov    %eax,0x805044
  803206:	8b 45 08             	mov    0x8(%ebp),%eax
  803209:	a3 40 50 80 00       	mov    %eax,0x805040
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803218:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80321d:	40                   	inc    %eax
  80321e:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  803223:	a1 40 50 80 00       	mov    0x805040,%eax
  803228:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80322b:	e9 b9 01 00 00       	jmp    8033e9 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 50 08             	mov    0x8(%eax),%edx
  803236:	a1 40 50 80 00       	mov    0x805040,%eax
  80323b:	8b 40 08             	mov    0x8(%eax),%eax
  80323e:	39 c2                	cmp    %eax,%edx
  803240:	76 7c                	jbe    8032be <insert_sorted_allocList+0x183>
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	8b 50 08             	mov    0x8(%eax),%edx
  803248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324b:	8b 40 08             	mov    0x8(%eax),%eax
  80324e:	39 c2                	cmp    %eax,%edx
  803250:	73 6c                	jae    8032be <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  803252:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803256:	74 06                	je     80325e <insert_sorted_allocList+0x123>
  803258:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325c:	75 14                	jne    803272 <insert_sorted_allocList+0x137>
  80325e:	83 ec 04             	sub    $0x4,%esp
  803261:	68 8c 4c 80 00       	push   $0x804c8c
  803266:	6a 75                	push   $0x75
  803268:	68 73 4c 80 00       	push   $0x804c73
  80326d:	e8 38 e0 ff ff       	call   8012aa <_panic>
  803272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803275:	8b 50 04             	mov    0x4(%eax),%edx
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	89 50 04             	mov    %edx,0x4(%eax)
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803284:	89 10                	mov    %edx,(%eax)
  803286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803289:	8b 40 04             	mov    0x4(%eax),%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	74 0d                	je     80329d <insert_sorted_allocList+0x162>
  803290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803293:	8b 40 04             	mov    0x4(%eax),%eax
  803296:	8b 55 08             	mov    0x8(%ebp),%edx
  803299:	89 10                	mov    %edx,(%eax)
  80329b:	eb 08                	jmp    8032a5 <insert_sorted_allocList+0x16a>
  80329d:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a0:	a3 40 50 80 00       	mov    %eax,0x805040
  8032a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ab:	89 50 04             	mov    %edx,0x4(%eax)
  8032ae:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8032b3:	40                   	inc    %eax
  8032b4:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  8032b9:	e9 59 01 00 00       	jmp    803417 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	8b 50 08             	mov    0x8(%eax),%edx
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	8b 40 08             	mov    0x8(%eax),%eax
  8032ca:	39 c2                	cmp    %eax,%edx
  8032cc:	0f 86 98 00 00 00    	jbe    80336a <insert_sorted_allocList+0x22f>
  8032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d5:	8b 50 08             	mov    0x8(%eax),%edx
  8032d8:	a1 44 50 80 00       	mov    0x805044,%eax
  8032dd:	8b 40 08             	mov    0x8(%eax),%eax
  8032e0:	39 c2                	cmp    %eax,%edx
  8032e2:	0f 83 82 00 00 00    	jae    80336a <insert_sorted_allocList+0x22f>
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	8b 50 08             	mov    0x8(%eax),%edx
  8032ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	8b 40 08             	mov    0x8(%eax),%eax
  8032f6:	39 c2                	cmp    %eax,%edx
  8032f8:	73 70                	jae    80336a <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8032fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fe:	74 06                	je     803306 <insert_sorted_allocList+0x1cb>
  803300:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803304:	75 14                	jne    80331a <insert_sorted_allocList+0x1df>
  803306:	83 ec 04             	sub    $0x4,%esp
  803309:	68 c4 4c 80 00       	push   $0x804cc4
  80330e:	6a 7c                	push   $0x7c
  803310:	68 73 4c 80 00       	push   $0x804c73
  803315:	e8 90 df ff ff       	call   8012aa <_panic>
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	8b 10                	mov    (%eax),%edx
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	89 10                	mov    %edx,(%eax)
  803324:	8b 45 08             	mov    0x8(%ebp),%eax
  803327:	8b 00                	mov    (%eax),%eax
  803329:	85 c0                	test   %eax,%eax
  80332b:	74 0b                	je     803338 <insert_sorted_allocList+0x1fd>
  80332d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803330:	8b 00                	mov    (%eax),%eax
  803332:	8b 55 08             	mov    0x8(%ebp),%edx
  803335:	89 50 04             	mov    %edx,0x4(%eax)
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	8b 55 08             	mov    0x8(%ebp),%edx
  80333e:	89 10                	mov    %edx,(%eax)
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803346:	89 50 04             	mov    %edx,0x4(%eax)
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	75 08                	jne    80335a <insert_sorted_allocList+0x21f>
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	a3 44 50 80 00       	mov    %eax,0x805044
  80335a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80335f:	40                   	inc    %eax
  803360:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  803365:	e9 ad 00 00 00       	jmp    803417 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	8b 50 08             	mov    0x8(%eax),%edx
  803370:	a1 44 50 80 00       	mov    0x805044,%eax
  803375:	8b 40 08             	mov    0x8(%eax),%eax
  803378:	39 c2                	cmp    %eax,%edx
  80337a:	76 65                	jbe    8033e1 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80337c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803380:	75 17                	jne    803399 <insert_sorted_allocList+0x25e>
  803382:	83 ec 04             	sub    $0x4,%esp
  803385:	68 f8 4c 80 00       	push   $0x804cf8
  80338a:	68 80 00 00 00       	push   $0x80
  80338f:	68 73 4c 80 00       	push   $0x804c73
  803394:	e8 11 df ff ff       	call   8012aa <_panic>
  803399:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	89 50 04             	mov    %edx,0x4(%eax)
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	8b 40 04             	mov    0x4(%eax),%eax
  8033ab:	85 c0                	test   %eax,%eax
  8033ad:	74 0c                	je     8033bb <insert_sorted_allocList+0x280>
  8033af:	a1 44 50 80 00       	mov    0x805044,%eax
  8033b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b7:	89 10                	mov    %edx,(%eax)
  8033b9:	eb 08                	jmp    8033c3 <insert_sorted_allocList+0x288>
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	a3 40 50 80 00       	mov    %eax,0x805040
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	a3 44 50 80 00       	mov    %eax,0x805044
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8033d9:	40                   	inc    %eax
  8033da:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  8033df:	eb 36                	jmp    803417 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8033e1:	a1 48 50 80 00       	mov    0x805048,%eax
  8033e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ed:	74 07                	je     8033f6 <insert_sorted_allocList+0x2bb>
  8033ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	eb 05                	jmp    8033fb <insert_sorted_allocList+0x2c0>
  8033f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033fb:	a3 48 50 80 00       	mov    %eax,0x805048
  803400:	a1 48 50 80 00       	mov    0x805048,%eax
  803405:	85 c0                	test   %eax,%eax
  803407:	0f 85 23 fe ff ff    	jne    803230 <insert_sorted_allocList+0xf5>
  80340d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803411:	0f 85 19 fe ff ff    	jne    803230 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  803417:	90                   	nop
  803418:	c9                   	leave  
  803419:	c3                   	ret    

0080341a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80341a:	55                   	push   %ebp
  80341b:	89 e5                	mov    %esp,%ebp
  80341d:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803420:	a1 38 51 80 00       	mov    0x805138,%eax
  803425:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803428:	e9 7c 01 00 00       	jmp    8035a9 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  80342d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803430:	8b 40 0c             	mov    0xc(%eax),%eax
  803433:	3b 45 08             	cmp    0x8(%ebp),%eax
  803436:	0f 85 90 00 00 00    	jne    8034cc <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  80343c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  803442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803446:	75 17                	jne    80345f <alloc_block_FF+0x45>
  803448:	83 ec 04             	sub    $0x4,%esp
  80344b:	68 1b 4d 80 00       	push   $0x804d1b
  803450:	68 ba 00 00 00       	push   $0xba
  803455:	68 73 4c 80 00       	push   $0x804c73
  80345a:	e8 4b de ff ff       	call   8012aa <_panic>
  80345f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	85 c0                	test   %eax,%eax
  803466:	74 10                	je     803478 <alloc_block_FF+0x5e>
  803468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346b:	8b 00                	mov    (%eax),%eax
  80346d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803470:	8b 52 04             	mov    0x4(%edx),%edx
  803473:	89 50 04             	mov    %edx,0x4(%eax)
  803476:	eb 0b                	jmp    803483 <alloc_block_FF+0x69>
  803478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347b:	8b 40 04             	mov    0x4(%eax),%eax
  80347e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803486:	8b 40 04             	mov    0x4(%eax),%eax
  803489:	85 c0                	test   %eax,%eax
  80348b:	74 0f                	je     80349c <alloc_block_FF+0x82>
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 40 04             	mov    0x4(%eax),%eax
  803493:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803496:	8b 12                	mov    (%edx),%edx
  803498:	89 10                	mov    %edx,(%eax)
  80349a:	eb 0a                	jmp    8034a6 <alloc_block_FF+0x8c>
  80349c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8034a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8034be:	48                   	dec    %eax
  8034bf:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  8034c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c7:	e9 10 01 00 00       	jmp    8035dc <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8034cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034d5:	0f 86 c6 00 00 00    	jbe    8035a1 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8034db:	a1 48 51 80 00       	mov    0x805148,%eax
  8034e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8034e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034e7:	75 17                	jne    803500 <alloc_block_FF+0xe6>
  8034e9:	83 ec 04             	sub    $0x4,%esp
  8034ec:	68 1b 4d 80 00       	push   $0x804d1b
  8034f1:	68 c2 00 00 00       	push   $0xc2
  8034f6:	68 73 4c 80 00       	push   $0x804c73
  8034fb:	e8 aa dd ff ff       	call   8012aa <_panic>
  803500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803503:	8b 00                	mov    (%eax),%eax
  803505:	85 c0                	test   %eax,%eax
  803507:	74 10                	je     803519 <alloc_block_FF+0xff>
  803509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350c:	8b 00                	mov    (%eax),%eax
  80350e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803511:	8b 52 04             	mov    0x4(%edx),%edx
  803514:	89 50 04             	mov    %edx,0x4(%eax)
  803517:	eb 0b                	jmp    803524 <alloc_block_FF+0x10a>
  803519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351c:	8b 40 04             	mov    0x4(%eax),%eax
  80351f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803527:	8b 40 04             	mov    0x4(%eax),%eax
  80352a:	85 c0                	test   %eax,%eax
  80352c:	74 0f                	je     80353d <alloc_block_FF+0x123>
  80352e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803531:	8b 40 04             	mov    0x4(%eax),%eax
  803534:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803537:	8b 12                	mov    (%edx),%edx
  803539:	89 10                	mov    %edx,(%eax)
  80353b:	eb 0a                	jmp    803547 <alloc_block_FF+0x12d>
  80353d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803540:	8b 00                	mov    (%eax),%eax
  803542:	a3 48 51 80 00       	mov    %eax,0x805148
  803547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803553:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80355a:	a1 54 51 80 00       	mov    0x805154,%eax
  80355f:	48                   	dec    %eax
  803560:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  803565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803568:	8b 50 08             	mov    0x8(%eax),%edx
  80356b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356e:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  803571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803574:	8b 55 08             	mov    0x8(%ebp),%edx
  803577:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80357a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357d:	8b 40 0c             	mov    0xc(%eax),%eax
  803580:	2b 45 08             	sub    0x8(%ebp),%eax
  803583:	89 c2                	mov    %eax,%edx
  803585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803588:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  80358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358e:	8b 50 08             	mov    0x8(%eax),%edx
  803591:	8b 45 08             	mov    0x8(%ebp),%eax
  803594:	01 c2                	add    %eax,%edx
  803596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803599:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  80359c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359f:	eb 3b                	jmp    8035dc <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8035a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8035a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ad:	74 07                	je     8035b6 <alloc_block_FF+0x19c>
  8035af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b2:	8b 00                	mov    (%eax),%eax
  8035b4:	eb 05                	jmp    8035bb <alloc_block_FF+0x1a1>
  8035b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035bb:	a3 40 51 80 00       	mov    %eax,0x805140
  8035c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8035c5:	85 c0                	test   %eax,%eax
  8035c7:	0f 85 60 fe ff ff    	jne    80342d <alloc_block_FF+0x13>
  8035cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035d1:	0f 85 56 fe ff ff    	jne    80342d <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8035d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035dc:	c9                   	leave  
  8035dd:	c3                   	ret    

008035de <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8035de:	55                   	push   %ebp
  8035df:	89 e5                	mov    %esp,%ebp
  8035e1:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8035e4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8035eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8035f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035f3:	eb 3a                	jmp    80362f <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8035f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8035fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035fe:	72 27                	jb     803627 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  803600:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803604:	75 0b                	jne    803611 <alloc_block_BF+0x33>
					best_size= element->size;
  803606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803609:	8b 40 0c             	mov    0xc(%eax),%eax
  80360c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80360f:	eb 16                	jmp    803627 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  803611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803614:	8b 50 0c             	mov    0xc(%eax),%edx
  803617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361a:	39 c2                	cmp    %eax,%edx
  80361c:	77 09                	ja     803627 <alloc_block_BF+0x49>
					best_size=element->size;
  80361e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803621:	8b 40 0c             	mov    0xc(%eax),%eax
  803624:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803627:	a1 40 51 80 00       	mov    0x805140,%eax
  80362c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80362f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803633:	74 07                	je     80363c <alloc_block_BF+0x5e>
  803635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803638:	8b 00                	mov    (%eax),%eax
  80363a:	eb 05                	jmp    803641 <alloc_block_BF+0x63>
  80363c:	b8 00 00 00 00       	mov    $0x0,%eax
  803641:	a3 40 51 80 00       	mov    %eax,0x805140
  803646:	a1 40 51 80 00       	mov    0x805140,%eax
  80364b:	85 c0                	test   %eax,%eax
  80364d:	75 a6                	jne    8035f5 <alloc_block_BF+0x17>
  80364f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803653:	75 a0                	jne    8035f5 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  803655:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803659:	0f 84 d3 01 00 00    	je     803832 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80365f:	a1 38 51 80 00       	mov    0x805138,%eax
  803664:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803667:	e9 98 01 00 00       	jmp    803804 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  80366c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803672:	0f 86 da 00 00 00    	jbe    803752 <alloc_block_BF+0x174>
  803678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367b:	8b 50 0c             	mov    0xc(%eax),%edx
  80367e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803681:	39 c2                	cmp    %eax,%edx
  803683:	0f 85 c9 00 00 00    	jne    803752 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  803689:	a1 48 51 80 00       	mov    0x805148,%eax
  80368e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  803691:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803695:	75 17                	jne    8036ae <alloc_block_BF+0xd0>
  803697:	83 ec 04             	sub    $0x4,%esp
  80369a:	68 1b 4d 80 00       	push   $0x804d1b
  80369f:	68 ea 00 00 00       	push   $0xea
  8036a4:	68 73 4c 80 00       	push   $0x804c73
  8036a9:	e8 fc db ff ff       	call   8012aa <_panic>
  8036ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b1:	8b 00                	mov    (%eax),%eax
  8036b3:	85 c0                	test   %eax,%eax
  8036b5:	74 10                	je     8036c7 <alloc_block_BF+0xe9>
  8036b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ba:	8b 00                	mov    (%eax),%eax
  8036bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036bf:	8b 52 04             	mov    0x4(%edx),%edx
  8036c2:	89 50 04             	mov    %edx,0x4(%eax)
  8036c5:	eb 0b                	jmp    8036d2 <alloc_block_BF+0xf4>
  8036c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ca:	8b 40 04             	mov    0x4(%eax),%eax
  8036cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d5:	8b 40 04             	mov    0x4(%eax),%eax
  8036d8:	85 c0                	test   %eax,%eax
  8036da:	74 0f                	je     8036eb <alloc_block_BF+0x10d>
  8036dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036df:	8b 40 04             	mov    0x4(%eax),%eax
  8036e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036e5:	8b 12                	mov    (%edx),%edx
  8036e7:	89 10                	mov    %edx,(%eax)
  8036e9:	eb 0a                	jmp    8036f5 <alloc_block_BF+0x117>
  8036eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ee:	8b 00                	mov    (%eax),%eax
  8036f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8036f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803701:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803708:	a1 54 51 80 00       	mov    0x805154,%eax
  80370d:	48                   	dec    %eax
  80370e:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  803713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803716:	8b 50 08             	mov    0x8(%eax),%edx
  803719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80371c:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80371f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803722:	8b 55 08             	mov    0x8(%ebp),%edx
  803725:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  803728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372b:	8b 40 0c             	mov    0xc(%eax),%eax
  80372e:	2b 45 08             	sub    0x8(%ebp),%eax
  803731:	89 c2                	mov    %eax,%edx
  803733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803736:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  803739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373c:	8b 50 08             	mov    0x8(%eax),%edx
  80373f:	8b 45 08             	mov    0x8(%ebp),%eax
  803742:	01 c2                	add    %eax,%edx
  803744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803747:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  80374a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80374d:	e9 e5 00 00 00       	jmp    803837 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  803752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803755:	8b 50 0c             	mov    0xc(%eax),%edx
  803758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375b:	39 c2                	cmp    %eax,%edx
  80375d:	0f 85 99 00 00 00    	jne    8037fc <alloc_block_BF+0x21e>
  803763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803766:	3b 45 08             	cmp    0x8(%ebp),%eax
  803769:	0f 85 8d 00 00 00    	jne    8037fc <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  803775:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803779:	75 17                	jne    803792 <alloc_block_BF+0x1b4>
  80377b:	83 ec 04             	sub    $0x4,%esp
  80377e:	68 1b 4d 80 00       	push   $0x804d1b
  803783:	68 f7 00 00 00       	push   $0xf7
  803788:	68 73 4c 80 00       	push   $0x804c73
  80378d:	e8 18 db ff ff       	call   8012aa <_panic>
  803792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803795:	8b 00                	mov    (%eax),%eax
  803797:	85 c0                	test   %eax,%eax
  803799:	74 10                	je     8037ab <alloc_block_BF+0x1cd>
  80379b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379e:	8b 00                	mov    (%eax),%eax
  8037a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037a3:	8b 52 04             	mov    0x4(%edx),%edx
  8037a6:	89 50 04             	mov    %edx,0x4(%eax)
  8037a9:	eb 0b                	jmp    8037b6 <alloc_block_BF+0x1d8>
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	8b 40 04             	mov    0x4(%eax),%eax
  8037b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b9:	8b 40 04             	mov    0x4(%eax),%eax
  8037bc:	85 c0                	test   %eax,%eax
  8037be:	74 0f                	je     8037cf <alloc_block_BF+0x1f1>
  8037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c3:	8b 40 04             	mov    0x4(%eax),%eax
  8037c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037c9:	8b 12                	mov    (%edx),%edx
  8037cb:	89 10                	mov    %edx,(%eax)
  8037cd:	eb 0a                	jmp    8037d9 <alloc_block_BF+0x1fb>
  8037cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d2:	8b 00                	mov    (%eax),%eax
  8037d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8037d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8037f1:	48                   	dec    %eax
  8037f2:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  8037f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037fa:	eb 3b                	jmp    803837 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8037fc:	a1 40 51 80 00       	mov    0x805140,%eax
  803801:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803804:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803808:	74 07                	je     803811 <alloc_block_BF+0x233>
  80380a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380d:	8b 00                	mov    (%eax),%eax
  80380f:	eb 05                	jmp    803816 <alloc_block_BF+0x238>
  803811:	b8 00 00 00 00       	mov    $0x0,%eax
  803816:	a3 40 51 80 00       	mov    %eax,0x805140
  80381b:	a1 40 51 80 00       	mov    0x805140,%eax
  803820:	85 c0                	test   %eax,%eax
  803822:	0f 85 44 fe ff ff    	jne    80366c <alloc_block_BF+0x8e>
  803828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80382c:	0f 85 3a fe ff ff    	jne    80366c <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  803832:	b8 00 00 00 00       	mov    $0x0,%eax
  803837:	c9                   	leave  
  803838:	c3                   	ret    

00803839 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803839:	55                   	push   %ebp
  80383a:	89 e5                	mov    %esp,%ebp
  80383c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80383f:	83 ec 04             	sub    $0x4,%esp
  803842:	68 3c 4d 80 00       	push   $0x804d3c
  803847:	68 04 01 00 00       	push   $0x104
  80384c:	68 73 4c 80 00       	push   $0x804c73
  803851:	e8 54 da ff ff       	call   8012aa <_panic>

00803856 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  803856:	55                   	push   %ebp
  803857:	89 e5                	mov    %esp,%ebp
  803859:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  80385c:	a1 38 51 80 00       	mov    0x805138,%eax
  803861:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  803864:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803869:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  80386c:	a1 38 51 80 00       	mov    0x805138,%eax
  803871:	85 c0                	test   %eax,%eax
  803873:	75 68                	jne    8038dd <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803875:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803879:	75 17                	jne    803892 <insert_sorted_with_merge_freeList+0x3c>
  80387b:	83 ec 04             	sub    $0x4,%esp
  80387e:	68 50 4c 80 00       	push   $0x804c50
  803883:	68 14 01 00 00       	push   $0x114
  803888:	68 73 4c 80 00       	push   $0x804c73
  80388d:	e8 18 da ff ff       	call   8012aa <_panic>
  803892:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803898:	8b 45 08             	mov    0x8(%ebp),%eax
  80389b:	89 10                	mov    %edx,(%eax)
  80389d:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a0:	8b 00                	mov    (%eax),%eax
  8038a2:	85 c0                	test   %eax,%eax
  8038a4:	74 0d                	je     8038b3 <insert_sorted_with_merge_freeList+0x5d>
  8038a6:	a1 38 51 80 00       	mov    0x805138,%eax
  8038ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ae:	89 50 04             	mov    %edx,0x4(%eax)
  8038b1:	eb 08                	jmp    8038bb <insert_sorted_with_merge_freeList+0x65>
  8038b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038be:	a3 38 51 80 00       	mov    %eax,0x805138
  8038c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038cd:	a1 44 51 80 00       	mov    0x805144,%eax
  8038d2:	40                   	inc    %eax
  8038d3:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8038d8:	e9 d2 06 00 00       	jmp    803faf <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8038dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e0:	8b 50 08             	mov    0x8(%eax),%edx
  8038e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e6:	8b 40 08             	mov    0x8(%eax),%eax
  8038e9:	39 c2                	cmp    %eax,%edx
  8038eb:	0f 83 22 01 00 00    	jae    803a13 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8038f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f4:	8b 50 08             	mov    0x8(%eax),%edx
  8038f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8038fd:	01 c2                	add    %eax,%edx
  8038ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803902:	8b 40 08             	mov    0x8(%eax),%eax
  803905:	39 c2                	cmp    %eax,%edx
  803907:	0f 85 9e 00 00 00    	jne    8039ab <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  80390d:	8b 45 08             	mov    0x8(%ebp),%eax
  803910:	8b 50 08             	mov    0x8(%eax),%edx
  803913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803916:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391c:	8b 50 0c             	mov    0xc(%eax),%edx
  80391f:	8b 45 08             	mov    0x8(%ebp),%eax
  803922:	8b 40 0c             	mov    0xc(%eax),%eax
  803925:	01 c2                	add    %eax,%edx
  803927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392a:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  80392d:	8b 45 08             	mov    0x8(%ebp),%eax
  803930:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803937:	8b 45 08             	mov    0x8(%ebp),%eax
  80393a:	8b 50 08             	mov    0x8(%eax),%edx
  80393d:	8b 45 08             	mov    0x8(%ebp),%eax
  803940:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803943:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803947:	75 17                	jne    803960 <insert_sorted_with_merge_freeList+0x10a>
  803949:	83 ec 04             	sub    $0x4,%esp
  80394c:	68 50 4c 80 00       	push   $0x804c50
  803951:	68 21 01 00 00       	push   $0x121
  803956:	68 73 4c 80 00       	push   $0x804c73
  80395b:	e8 4a d9 ff ff       	call   8012aa <_panic>
  803960:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803966:	8b 45 08             	mov    0x8(%ebp),%eax
  803969:	89 10                	mov    %edx,(%eax)
  80396b:	8b 45 08             	mov    0x8(%ebp),%eax
  80396e:	8b 00                	mov    (%eax),%eax
  803970:	85 c0                	test   %eax,%eax
  803972:	74 0d                	je     803981 <insert_sorted_with_merge_freeList+0x12b>
  803974:	a1 48 51 80 00       	mov    0x805148,%eax
  803979:	8b 55 08             	mov    0x8(%ebp),%edx
  80397c:	89 50 04             	mov    %edx,0x4(%eax)
  80397f:	eb 08                	jmp    803989 <insert_sorted_with_merge_freeList+0x133>
  803981:	8b 45 08             	mov    0x8(%ebp),%eax
  803984:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803989:	8b 45 08             	mov    0x8(%ebp),%eax
  80398c:	a3 48 51 80 00       	mov    %eax,0x805148
  803991:	8b 45 08             	mov    0x8(%ebp),%eax
  803994:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399b:	a1 54 51 80 00       	mov    0x805154,%eax
  8039a0:	40                   	inc    %eax
  8039a1:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8039a6:	e9 04 06 00 00       	jmp    803faf <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8039ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039af:	75 17                	jne    8039c8 <insert_sorted_with_merge_freeList+0x172>
  8039b1:	83 ec 04             	sub    $0x4,%esp
  8039b4:	68 50 4c 80 00       	push   $0x804c50
  8039b9:	68 26 01 00 00       	push   $0x126
  8039be:	68 73 4c 80 00       	push   $0x804c73
  8039c3:	e8 e2 d8 ff ff       	call   8012aa <_panic>
  8039c8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8039ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d1:	89 10                	mov    %edx,(%eax)
  8039d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d6:	8b 00                	mov    (%eax),%eax
  8039d8:	85 c0                	test   %eax,%eax
  8039da:	74 0d                	je     8039e9 <insert_sorted_with_merge_freeList+0x193>
  8039dc:	a1 38 51 80 00       	mov    0x805138,%eax
  8039e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8039e4:	89 50 04             	mov    %edx,0x4(%eax)
  8039e7:	eb 08                	jmp    8039f1 <insert_sorted_with_merge_freeList+0x19b>
  8039e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f4:	a3 38 51 80 00       	mov    %eax,0x805138
  8039f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a03:	a1 44 51 80 00       	mov    0x805144,%eax
  803a08:	40                   	inc    %eax
  803a09:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803a0e:	e9 9c 05 00 00       	jmp    803faf <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  803a13:	8b 45 08             	mov    0x8(%ebp),%eax
  803a16:	8b 50 08             	mov    0x8(%eax),%edx
  803a19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a1c:	8b 40 08             	mov    0x8(%eax),%eax
  803a1f:	39 c2                	cmp    %eax,%edx
  803a21:	0f 86 16 01 00 00    	jbe    803b3d <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a2a:	8b 50 08             	mov    0x8(%eax),%edx
  803a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a30:	8b 40 0c             	mov    0xc(%eax),%eax
  803a33:	01 c2                	add    %eax,%edx
  803a35:	8b 45 08             	mov    0x8(%ebp),%eax
  803a38:	8b 40 08             	mov    0x8(%eax),%eax
  803a3b:	39 c2                	cmp    %eax,%edx
  803a3d:	0f 85 92 00 00 00    	jne    803ad5 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  803a43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a46:	8b 50 0c             	mov    0xc(%eax),%edx
  803a49:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4c:	8b 40 0c             	mov    0xc(%eax),%eax
  803a4f:	01 c2                	add    %eax,%edx
  803a51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a54:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  803a57:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803a61:	8b 45 08             	mov    0x8(%ebp),%eax
  803a64:	8b 50 08             	mov    0x8(%eax),%edx
  803a67:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803a6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a71:	75 17                	jne    803a8a <insert_sorted_with_merge_freeList+0x234>
  803a73:	83 ec 04             	sub    $0x4,%esp
  803a76:	68 50 4c 80 00       	push   $0x804c50
  803a7b:	68 31 01 00 00       	push   $0x131
  803a80:	68 73 4c 80 00       	push   $0x804c73
  803a85:	e8 20 d8 ff ff       	call   8012aa <_panic>
  803a8a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a90:	8b 45 08             	mov    0x8(%ebp),%eax
  803a93:	89 10                	mov    %edx,(%eax)
  803a95:	8b 45 08             	mov    0x8(%ebp),%eax
  803a98:	8b 00                	mov    (%eax),%eax
  803a9a:	85 c0                	test   %eax,%eax
  803a9c:	74 0d                	je     803aab <insert_sorted_with_merge_freeList+0x255>
  803a9e:	a1 48 51 80 00       	mov    0x805148,%eax
  803aa3:	8b 55 08             	mov    0x8(%ebp),%edx
  803aa6:	89 50 04             	mov    %edx,0x4(%eax)
  803aa9:	eb 08                	jmp    803ab3 <insert_sorted_with_merge_freeList+0x25d>
  803aab:	8b 45 08             	mov    0x8(%ebp),%eax
  803aae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab6:	a3 48 51 80 00       	mov    %eax,0x805148
  803abb:	8b 45 08             	mov    0x8(%ebp),%eax
  803abe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ac5:	a1 54 51 80 00       	mov    0x805154,%eax
  803aca:	40                   	inc    %eax
  803acb:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803ad0:	e9 da 04 00 00       	jmp    803faf <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  803ad5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ad9:	75 17                	jne    803af2 <insert_sorted_with_merge_freeList+0x29c>
  803adb:	83 ec 04             	sub    $0x4,%esp
  803ade:	68 f8 4c 80 00       	push   $0x804cf8
  803ae3:	68 37 01 00 00       	push   $0x137
  803ae8:	68 73 4c 80 00       	push   $0x804c73
  803aed:	e8 b8 d7 ff ff       	call   8012aa <_panic>
  803af2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803af8:	8b 45 08             	mov    0x8(%ebp),%eax
  803afb:	89 50 04             	mov    %edx,0x4(%eax)
  803afe:	8b 45 08             	mov    0x8(%ebp),%eax
  803b01:	8b 40 04             	mov    0x4(%eax),%eax
  803b04:	85 c0                	test   %eax,%eax
  803b06:	74 0c                	je     803b14 <insert_sorted_with_merge_freeList+0x2be>
  803b08:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803b0d:	8b 55 08             	mov    0x8(%ebp),%edx
  803b10:	89 10                	mov    %edx,(%eax)
  803b12:	eb 08                	jmp    803b1c <insert_sorted_with_merge_freeList+0x2c6>
  803b14:	8b 45 08             	mov    0x8(%ebp),%eax
  803b17:	a3 38 51 80 00       	mov    %eax,0x805138
  803b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b24:	8b 45 08             	mov    0x8(%ebp),%eax
  803b27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b2d:	a1 44 51 80 00       	mov    0x805144,%eax
  803b32:	40                   	inc    %eax
  803b33:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803b38:	e9 72 04 00 00       	jmp    803faf <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803b3d:	a1 38 51 80 00       	mov    0x805138,%eax
  803b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b45:	e9 35 04 00 00       	jmp    803f7f <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4d:	8b 00                	mov    (%eax),%eax
  803b4f:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  803b52:	8b 45 08             	mov    0x8(%ebp),%eax
  803b55:	8b 50 08             	mov    0x8(%eax),%edx
  803b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5b:	8b 40 08             	mov    0x8(%eax),%eax
  803b5e:	39 c2                	cmp    %eax,%edx
  803b60:	0f 86 11 04 00 00    	jbe    803f77 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b69:	8b 50 08             	mov    0x8(%eax),%edx
  803b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6f:	8b 40 0c             	mov    0xc(%eax),%eax
  803b72:	01 c2                	add    %eax,%edx
  803b74:	8b 45 08             	mov    0x8(%ebp),%eax
  803b77:	8b 40 08             	mov    0x8(%eax),%eax
  803b7a:	39 c2                	cmp    %eax,%edx
  803b7c:	0f 83 8b 00 00 00    	jae    803c0d <insert_sorted_with_merge_freeList+0x3b7>
  803b82:	8b 45 08             	mov    0x8(%ebp),%eax
  803b85:	8b 50 08             	mov    0x8(%eax),%edx
  803b88:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8b:	8b 40 0c             	mov    0xc(%eax),%eax
  803b8e:	01 c2                	add    %eax,%edx
  803b90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b93:	8b 40 08             	mov    0x8(%eax),%eax
  803b96:	39 c2                	cmp    %eax,%edx
  803b98:	73 73                	jae    803c0d <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803b9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b9e:	74 06                	je     803ba6 <insert_sorted_with_merge_freeList+0x350>
  803ba0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ba4:	75 17                	jne    803bbd <insert_sorted_with_merge_freeList+0x367>
  803ba6:	83 ec 04             	sub    $0x4,%esp
  803ba9:	68 c4 4c 80 00       	push   $0x804cc4
  803bae:	68 48 01 00 00       	push   $0x148
  803bb3:	68 73 4c 80 00       	push   $0x804c73
  803bb8:	e8 ed d6 ff ff       	call   8012aa <_panic>
  803bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc0:	8b 10                	mov    (%eax),%edx
  803bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc5:	89 10                	mov    %edx,(%eax)
  803bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bca:	8b 00                	mov    (%eax),%eax
  803bcc:	85 c0                	test   %eax,%eax
  803bce:	74 0b                	je     803bdb <insert_sorted_with_merge_freeList+0x385>
  803bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd3:	8b 00                	mov    (%eax),%eax
  803bd5:	8b 55 08             	mov    0x8(%ebp),%edx
  803bd8:	89 50 04             	mov    %edx,0x4(%eax)
  803bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bde:	8b 55 08             	mov    0x8(%ebp),%edx
  803be1:	89 10                	mov    %edx,(%eax)
  803be3:	8b 45 08             	mov    0x8(%ebp),%eax
  803be6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803be9:	89 50 04             	mov    %edx,0x4(%eax)
  803bec:	8b 45 08             	mov    0x8(%ebp),%eax
  803bef:	8b 00                	mov    (%eax),%eax
  803bf1:	85 c0                	test   %eax,%eax
  803bf3:	75 08                	jne    803bfd <insert_sorted_with_merge_freeList+0x3a7>
  803bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bfd:	a1 44 51 80 00       	mov    0x805144,%eax
  803c02:	40                   	inc    %eax
  803c03:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803c08:	e9 a2 03 00 00       	jmp    803faf <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c10:	8b 50 08             	mov    0x8(%eax),%edx
  803c13:	8b 45 08             	mov    0x8(%ebp),%eax
  803c16:	8b 40 0c             	mov    0xc(%eax),%eax
  803c19:	01 c2                	add    %eax,%edx
  803c1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c1e:	8b 40 08             	mov    0x8(%eax),%eax
  803c21:	39 c2                	cmp    %eax,%edx
  803c23:	0f 83 ae 00 00 00    	jae    803cd7 <insert_sorted_with_merge_freeList+0x481>
  803c29:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2c:	8b 50 08             	mov    0x8(%eax),%edx
  803c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c32:	8b 48 08             	mov    0x8(%eax),%ecx
  803c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c38:	8b 40 0c             	mov    0xc(%eax),%eax
  803c3b:	01 c8                	add    %ecx,%eax
  803c3d:	39 c2                	cmp    %eax,%edx
  803c3f:	0f 85 92 00 00 00    	jne    803cd7 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c48:	8b 50 0c             	mov    0xc(%eax),%edx
  803c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4e:	8b 40 0c             	mov    0xc(%eax),%eax
  803c51:	01 c2                	add    %eax,%edx
  803c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c56:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803c59:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803c63:	8b 45 08             	mov    0x8(%ebp),%eax
  803c66:	8b 50 08             	mov    0x8(%eax),%edx
  803c69:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6c:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803c6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c73:	75 17                	jne    803c8c <insert_sorted_with_merge_freeList+0x436>
  803c75:	83 ec 04             	sub    $0x4,%esp
  803c78:	68 50 4c 80 00       	push   $0x804c50
  803c7d:	68 51 01 00 00       	push   $0x151
  803c82:	68 73 4c 80 00       	push   $0x804c73
  803c87:	e8 1e d6 ff ff       	call   8012aa <_panic>
  803c8c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c92:	8b 45 08             	mov    0x8(%ebp),%eax
  803c95:	89 10                	mov    %edx,(%eax)
  803c97:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9a:	8b 00                	mov    (%eax),%eax
  803c9c:	85 c0                	test   %eax,%eax
  803c9e:	74 0d                	je     803cad <insert_sorted_with_merge_freeList+0x457>
  803ca0:	a1 48 51 80 00       	mov    0x805148,%eax
  803ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  803ca8:	89 50 04             	mov    %edx,0x4(%eax)
  803cab:	eb 08                	jmp    803cb5 <insert_sorted_with_merge_freeList+0x45f>
  803cad:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb8:	a3 48 51 80 00       	mov    %eax,0x805148
  803cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cc7:	a1 54 51 80 00       	mov    0x805154,%eax
  803ccc:	40                   	inc    %eax
  803ccd:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  803cd2:	e9 d8 02 00 00       	jmp    803faf <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cda:	8b 50 08             	mov    0x8(%eax),%edx
  803cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce0:	8b 40 0c             	mov    0xc(%eax),%eax
  803ce3:	01 c2                	add    %eax,%edx
  803ce5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ce8:	8b 40 08             	mov    0x8(%eax),%eax
  803ceb:	39 c2                	cmp    %eax,%edx
  803ced:	0f 85 ba 00 00 00    	jne    803dad <insert_sorted_with_merge_freeList+0x557>
  803cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf6:	8b 50 08             	mov    0x8(%eax),%edx
  803cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfc:	8b 48 08             	mov    0x8(%eax),%ecx
  803cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d02:	8b 40 0c             	mov    0xc(%eax),%eax
  803d05:	01 c8                	add    %ecx,%eax
  803d07:	39 c2                	cmp    %eax,%edx
  803d09:	0f 86 9e 00 00 00    	jbe    803dad <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d12:	8b 50 0c             	mov    0xc(%eax),%edx
  803d15:	8b 45 08             	mov    0x8(%ebp),%eax
  803d18:	8b 40 0c             	mov    0xc(%eax),%eax
  803d1b:	01 c2                	add    %eax,%edx
  803d1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d20:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803d23:	8b 45 08             	mov    0x8(%ebp),%eax
  803d26:	8b 50 08             	mov    0x8(%eax),%edx
  803d29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d2c:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803d39:	8b 45 08             	mov    0x8(%ebp),%eax
  803d3c:	8b 50 08             	mov    0x8(%eax),%edx
  803d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d42:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803d45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d49:	75 17                	jne    803d62 <insert_sorted_with_merge_freeList+0x50c>
  803d4b:	83 ec 04             	sub    $0x4,%esp
  803d4e:	68 50 4c 80 00       	push   $0x804c50
  803d53:	68 5b 01 00 00       	push   $0x15b
  803d58:	68 73 4c 80 00       	push   $0x804c73
  803d5d:	e8 48 d5 ff ff       	call   8012aa <_panic>
  803d62:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d68:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6b:	89 10                	mov    %edx,(%eax)
  803d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d70:	8b 00                	mov    (%eax),%eax
  803d72:	85 c0                	test   %eax,%eax
  803d74:	74 0d                	je     803d83 <insert_sorted_with_merge_freeList+0x52d>
  803d76:	a1 48 51 80 00       	mov    0x805148,%eax
  803d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  803d7e:	89 50 04             	mov    %edx,0x4(%eax)
  803d81:	eb 08                	jmp    803d8b <insert_sorted_with_merge_freeList+0x535>
  803d83:	8b 45 08             	mov    0x8(%ebp),%eax
  803d86:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8e:	a3 48 51 80 00       	mov    %eax,0x805148
  803d93:	8b 45 08             	mov    0x8(%ebp),%eax
  803d96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d9d:	a1 54 51 80 00       	mov    0x805154,%eax
  803da2:	40                   	inc    %eax
  803da3:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803da8:	e9 02 02 00 00       	jmp    803faf <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803dad:	8b 45 08             	mov    0x8(%ebp),%eax
  803db0:	8b 50 08             	mov    0x8(%eax),%edx
  803db3:	8b 45 08             	mov    0x8(%ebp),%eax
  803db6:	8b 40 0c             	mov    0xc(%eax),%eax
  803db9:	01 c2                	add    %eax,%edx
  803dbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dbe:	8b 40 08             	mov    0x8(%eax),%eax
  803dc1:	39 c2                	cmp    %eax,%edx
  803dc3:	0f 85 ae 01 00 00    	jne    803f77 <insert_sorted_with_merge_freeList+0x721>
  803dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  803dcc:	8b 50 08             	mov    0x8(%eax),%edx
  803dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd2:	8b 48 08             	mov    0x8(%eax),%ecx
  803dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd8:	8b 40 0c             	mov    0xc(%eax),%eax
  803ddb:	01 c8                	add    %ecx,%eax
  803ddd:	39 c2                	cmp    %eax,%edx
  803ddf:	0f 85 92 01 00 00    	jne    803f77 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de8:	8b 50 0c             	mov    0xc(%eax),%edx
  803deb:	8b 45 08             	mov    0x8(%ebp),%eax
  803dee:	8b 40 0c             	mov    0xc(%eax),%eax
  803df1:	01 c2                	add    %eax,%edx
  803df3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803df6:	8b 40 0c             	mov    0xc(%eax),%eax
  803df9:	01 c2                	add    %eax,%edx
  803dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfe:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803e01:	8b 45 08             	mov    0x8(%ebp),%eax
  803e04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e0e:	8b 50 08             	mov    0x8(%eax),%edx
  803e11:	8b 45 08             	mov    0x8(%ebp),%eax
  803e14:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803e17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e1a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803e21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e24:	8b 50 08             	mov    0x8(%eax),%edx
  803e27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e2a:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803e2d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803e31:	75 17                	jne    803e4a <insert_sorted_with_merge_freeList+0x5f4>
  803e33:	83 ec 04             	sub    $0x4,%esp
  803e36:	68 1b 4d 80 00       	push   $0x804d1b
  803e3b:	68 63 01 00 00       	push   $0x163
  803e40:	68 73 4c 80 00       	push   $0x804c73
  803e45:	e8 60 d4 ff ff       	call   8012aa <_panic>
  803e4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e4d:	8b 00                	mov    (%eax),%eax
  803e4f:	85 c0                	test   %eax,%eax
  803e51:	74 10                	je     803e63 <insert_sorted_with_merge_freeList+0x60d>
  803e53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e56:	8b 00                	mov    (%eax),%eax
  803e58:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e5b:	8b 52 04             	mov    0x4(%edx),%edx
  803e5e:	89 50 04             	mov    %edx,0x4(%eax)
  803e61:	eb 0b                	jmp    803e6e <insert_sorted_with_merge_freeList+0x618>
  803e63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e66:	8b 40 04             	mov    0x4(%eax),%eax
  803e69:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803e6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e71:	8b 40 04             	mov    0x4(%eax),%eax
  803e74:	85 c0                	test   %eax,%eax
  803e76:	74 0f                	je     803e87 <insert_sorted_with_merge_freeList+0x631>
  803e78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e7b:	8b 40 04             	mov    0x4(%eax),%eax
  803e7e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e81:	8b 12                	mov    (%edx),%edx
  803e83:	89 10                	mov    %edx,(%eax)
  803e85:	eb 0a                	jmp    803e91 <insert_sorted_with_merge_freeList+0x63b>
  803e87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e8a:	8b 00                	mov    (%eax),%eax
  803e8c:	a3 38 51 80 00       	mov    %eax,0x805138
  803e91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ea4:	a1 44 51 80 00       	mov    0x805144,%eax
  803ea9:	48                   	dec    %eax
  803eaa:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  803eaf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803eb3:	75 17                	jne    803ecc <insert_sorted_with_merge_freeList+0x676>
  803eb5:	83 ec 04             	sub    $0x4,%esp
  803eb8:	68 50 4c 80 00       	push   $0x804c50
  803ebd:	68 64 01 00 00       	push   $0x164
  803ec2:	68 73 4c 80 00       	push   $0x804c73
  803ec7:	e8 de d3 ff ff       	call   8012aa <_panic>
  803ecc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ed2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ed5:	89 10                	mov    %edx,(%eax)
  803ed7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eda:	8b 00                	mov    (%eax),%eax
  803edc:	85 c0                	test   %eax,%eax
  803ede:	74 0d                	je     803eed <insert_sorted_with_merge_freeList+0x697>
  803ee0:	a1 48 51 80 00       	mov    0x805148,%eax
  803ee5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ee8:	89 50 04             	mov    %edx,0x4(%eax)
  803eeb:	eb 08                	jmp    803ef5 <insert_sorted_with_merge_freeList+0x69f>
  803eed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ef0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ef8:	a3 48 51 80 00       	mov    %eax,0x805148
  803efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f07:	a1 54 51 80 00       	mov    0x805154,%eax
  803f0c:	40                   	inc    %eax
  803f0d:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803f12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f16:	75 17                	jne    803f2f <insert_sorted_with_merge_freeList+0x6d9>
  803f18:	83 ec 04             	sub    $0x4,%esp
  803f1b:	68 50 4c 80 00       	push   $0x804c50
  803f20:	68 65 01 00 00       	push   $0x165
  803f25:	68 73 4c 80 00       	push   $0x804c73
  803f2a:	e8 7b d3 ff ff       	call   8012aa <_panic>
  803f2f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803f35:	8b 45 08             	mov    0x8(%ebp),%eax
  803f38:	89 10                	mov    %edx,(%eax)
  803f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3d:	8b 00                	mov    (%eax),%eax
  803f3f:	85 c0                	test   %eax,%eax
  803f41:	74 0d                	je     803f50 <insert_sorted_with_merge_freeList+0x6fa>
  803f43:	a1 48 51 80 00       	mov    0x805148,%eax
  803f48:	8b 55 08             	mov    0x8(%ebp),%edx
  803f4b:	89 50 04             	mov    %edx,0x4(%eax)
  803f4e:	eb 08                	jmp    803f58 <insert_sorted_with_merge_freeList+0x702>
  803f50:	8b 45 08             	mov    0x8(%ebp),%eax
  803f53:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803f58:	8b 45 08             	mov    0x8(%ebp),%eax
  803f5b:	a3 48 51 80 00       	mov    %eax,0x805148
  803f60:	8b 45 08             	mov    0x8(%ebp),%eax
  803f63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f6a:	a1 54 51 80 00       	mov    0x805154,%eax
  803f6f:	40                   	inc    %eax
  803f70:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803f75:	eb 38                	jmp    803faf <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803f77:	a1 40 51 80 00       	mov    0x805140,%eax
  803f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f83:	74 07                	je     803f8c <insert_sorted_with_merge_freeList+0x736>
  803f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f88:	8b 00                	mov    (%eax),%eax
  803f8a:	eb 05                	jmp    803f91 <insert_sorted_with_merge_freeList+0x73b>
  803f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  803f91:	a3 40 51 80 00       	mov    %eax,0x805140
  803f96:	a1 40 51 80 00       	mov    0x805140,%eax
  803f9b:	85 c0                	test   %eax,%eax
  803f9d:	0f 85 a7 fb ff ff    	jne    803b4a <insert_sorted_with_merge_freeList+0x2f4>
  803fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fa7:	0f 85 9d fb ff ff    	jne    803b4a <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803fad:	eb 00                	jmp    803faf <insert_sorted_with_merge_freeList+0x759>
  803faf:	90                   	nop
  803fb0:	c9                   	leave  
  803fb1:	c3                   	ret    
  803fb2:	66 90                	xchg   %ax,%ax

00803fb4 <__udivdi3>:
  803fb4:	55                   	push   %ebp
  803fb5:	57                   	push   %edi
  803fb6:	56                   	push   %esi
  803fb7:	53                   	push   %ebx
  803fb8:	83 ec 1c             	sub    $0x1c,%esp
  803fbb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803fbf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803fc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fc7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fcb:	89 ca                	mov    %ecx,%edx
  803fcd:	89 f8                	mov    %edi,%eax
  803fcf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803fd3:	85 f6                	test   %esi,%esi
  803fd5:	75 2d                	jne    804004 <__udivdi3+0x50>
  803fd7:	39 cf                	cmp    %ecx,%edi
  803fd9:	77 65                	ja     804040 <__udivdi3+0x8c>
  803fdb:	89 fd                	mov    %edi,%ebp
  803fdd:	85 ff                	test   %edi,%edi
  803fdf:	75 0b                	jne    803fec <__udivdi3+0x38>
  803fe1:	b8 01 00 00 00       	mov    $0x1,%eax
  803fe6:	31 d2                	xor    %edx,%edx
  803fe8:	f7 f7                	div    %edi
  803fea:	89 c5                	mov    %eax,%ebp
  803fec:	31 d2                	xor    %edx,%edx
  803fee:	89 c8                	mov    %ecx,%eax
  803ff0:	f7 f5                	div    %ebp
  803ff2:	89 c1                	mov    %eax,%ecx
  803ff4:	89 d8                	mov    %ebx,%eax
  803ff6:	f7 f5                	div    %ebp
  803ff8:	89 cf                	mov    %ecx,%edi
  803ffa:	89 fa                	mov    %edi,%edx
  803ffc:	83 c4 1c             	add    $0x1c,%esp
  803fff:	5b                   	pop    %ebx
  804000:	5e                   	pop    %esi
  804001:	5f                   	pop    %edi
  804002:	5d                   	pop    %ebp
  804003:	c3                   	ret    
  804004:	39 ce                	cmp    %ecx,%esi
  804006:	77 28                	ja     804030 <__udivdi3+0x7c>
  804008:	0f bd fe             	bsr    %esi,%edi
  80400b:	83 f7 1f             	xor    $0x1f,%edi
  80400e:	75 40                	jne    804050 <__udivdi3+0x9c>
  804010:	39 ce                	cmp    %ecx,%esi
  804012:	72 0a                	jb     80401e <__udivdi3+0x6a>
  804014:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804018:	0f 87 9e 00 00 00    	ja     8040bc <__udivdi3+0x108>
  80401e:	b8 01 00 00 00       	mov    $0x1,%eax
  804023:	89 fa                	mov    %edi,%edx
  804025:	83 c4 1c             	add    $0x1c,%esp
  804028:	5b                   	pop    %ebx
  804029:	5e                   	pop    %esi
  80402a:	5f                   	pop    %edi
  80402b:	5d                   	pop    %ebp
  80402c:	c3                   	ret    
  80402d:	8d 76 00             	lea    0x0(%esi),%esi
  804030:	31 ff                	xor    %edi,%edi
  804032:	31 c0                	xor    %eax,%eax
  804034:	89 fa                	mov    %edi,%edx
  804036:	83 c4 1c             	add    $0x1c,%esp
  804039:	5b                   	pop    %ebx
  80403a:	5e                   	pop    %esi
  80403b:	5f                   	pop    %edi
  80403c:	5d                   	pop    %ebp
  80403d:	c3                   	ret    
  80403e:	66 90                	xchg   %ax,%ax
  804040:	89 d8                	mov    %ebx,%eax
  804042:	f7 f7                	div    %edi
  804044:	31 ff                	xor    %edi,%edi
  804046:	89 fa                	mov    %edi,%edx
  804048:	83 c4 1c             	add    $0x1c,%esp
  80404b:	5b                   	pop    %ebx
  80404c:	5e                   	pop    %esi
  80404d:	5f                   	pop    %edi
  80404e:	5d                   	pop    %ebp
  80404f:	c3                   	ret    
  804050:	bd 20 00 00 00       	mov    $0x20,%ebp
  804055:	89 eb                	mov    %ebp,%ebx
  804057:	29 fb                	sub    %edi,%ebx
  804059:	89 f9                	mov    %edi,%ecx
  80405b:	d3 e6                	shl    %cl,%esi
  80405d:	89 c5                	mov    %eax,%ebp
  80405f:	88 d9                	mov    %bl,%cl
  804061:	d3 ed                	shr    %cl,%ebp
  804063:	89 e9                	mov    %ebp,%ecx
  804065:	09 f1                	or     %esi,%ecx
  804067:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80406b:	89 f9                	mov    %edi,%ecx
  80406d:	d3 e0                	shl    %cl,%eax
  80406f:	89 c5                	mov    %eax,%ebp
  804071:	89 d6                	mov    %edx,%esi
  804073:	88 d9                	mov    %bl,%cl
  804075:	d3 ee                	shr    %cl,%esi
  804077:	89 f9                	mov    %edi,%ecx
  804079:	d3 e2                	shl    %cl,%edx
  80407b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80407f:	88 d9                	mov    %bl,%cl
  804081:	d3 e8                	shr    %cl,%eax
  804083:	09 c2                	or     %eax,%edx
  804085:	89 d0                	mov    %edx,%eax
  804087:	89 f2                	mov    %esi,%edx
  804089:	f7 74 24 0c          	divl   0xc(%esp)
  80408d:	89 d6                	mov    %edx,%esi
  80408f:	89 c3                	mov    %eax,%ebx
  804091:	f7 e5                	mul    %ebp
  804093:	39 d6                	cmp    %edx,%esi
  804095:	72 19                	jb     8040b0 <__udivdi3+0xfc>
  804097:	74 0b                	je     8040a4 <__udivdi3+0xf0>
  804099:	89 d8                	mov    %ebx,%eax
  80409b:	31 ff                	xor    %edi,%edi
  80409d:	e9 58 ff ff ff       	jmp    803ffa <__udivdi3+0x46>
  8040a2:	66 90                	xchg   %ax,%ax
  8040a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040a8:	89 f9                	mov    %edi,%ecx
  8040aa:	d3 e2                	shl    %cl,%edx
  8040ac:	39 c2                	cmp    %eax,%edx
  8040ae:	73 e9                	jae    804099 <__udivdi3+0xe5>
  8040b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8040b3:	31 ff                	xor    %edi,%edi
  8040b5:	e9 40 ff ff ff       	jmp    803ffa <__udivdi3+0x46>
  8040ba:	66 90                	xchg   %ax,%ax
  8040bc:	31 c0                	xor    %eax,%eax
  8040be:	e9 37 ff ff ff       	jmp    803ffa <__udivdi3+0x46>
  8040c3:	90                   	nop

008040c4 <__umoddi3>:
  8040c4:	55                   	push   %ebp
  8040c5:	57                   	push   %edi
  8040c6:	56                   	push   %esi
  8040c7:	53                   	push   %ebx
  8040c8:	83 ec 1c             	sub    $0x1c,%esp
  8040cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8040cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8040d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040e3:	89 f3                	mov    %esi,%ebx
  8040e5:	89 fa                	mov    %edi,%edx
  8040e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040eb:	89 34 24             	mov    %esi,(%esp)
  8040ee:	85 c0                	test   %eax,%eax
  8040f0:	75 1a                	jne    80410c <__umoddi3+0x48>
  8040f2:	39 f7                	cmp    %esi,%edi
  8040f4:	0f 86 a2 00 00 00    	jbe    80419c <__umoddi3+0xd8>
  8040fa:	89 c8                	mov    %ecx,%eax
  8040fc:	89 f2                	mov    %esi,%edx
  8040fe:	f7 f7                	div    %edi
  804100:	89 d0                	mov    %edx,%eax
  804102:	31 d2                	xor    %edx,%edx
  804104:	83 c4 1c             	add    $0x1c,%esp
  804107:	5b                   	pop    %ebx
  804108:	5e                   	pop    %esi
  804109:	5f                   	pop    %edi
  80410a:	5d                   	pop    %ebp
  80410b:	c3                   	ret    
  80410c:	39 f0                	cmp    %esi,%eax
  80410e:	0f 87 ac 00 00 00    	ja     8041c0 <__umoddi3+0xfc>
  804114:	0f bd e8             	bsr    %eax,%ebp
  804117:	83 f5 1f             	xor    $0x1f,%ebp
  80411a:	0f 84 ac 00 00 00    	je     8041cc <__umoddi3+0x108>
  804120:	bf 20 00 00 00       	mov    $0x20,%edi
  804125:	29 ef                	sub    %ebp,%edi
  804127:	89 fe                	mov    %edi,%esi
  804129:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80412d:	89 e9                	mov    %ebp,%ecx
  80412f:	d3 e0                	shl    %cl,%eax
  804131:	89 d7                	mov    %edx,%edi
  804133:	89 f1                	mov    %esi,%ecx
  804135:	d3 ef                	shr    %cl,%edi
  804137:	09 c7                	or     %eax,%edi
  804139:	89 e9                	mov    %ebp,%ecx
  80413b:	d3 e2                	shl    %cl,%edx
  80413d:	89 14 24             	mov    %edx,(%esp)
  804140:	89 d8                	mov    %ebx,%eax
  804142:	d3 e0                	shl    %cl,%eax
  804144:	89 c2                	mov    %eax,%edx
  804146:	8b 44 24 08          	mov    0x8(%esp),%eax
  80414a:	d3 e0                	shl    %cl,%eax
  80414c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804150:	8b 44 24 08          	mov    0x8(%esp),%eax
  804154:	89 f1                	mov    %esi,%ecx
  804156:	d3 e8                	shr    %cl,%eax
  804158:	09 d0                	or     %edx,%eax
  80415a:	d3 eb                	shr    %cl,%ebx
  80415c:	89 da                	mov    %ebx,%edx
  80415e:	f7 f7                	div    %edi
  804160:	89 d3                	mov    %edx,%ebx
  804162:	f7 24 24             	mull   (%esp)
  804165:	89 c6                	mov    %eax,%esi
  804167:	89 d1                	mov    %edx,%ecx
  804169:	39 d3                	cmp    %edx,%ebx
  80416b:	0f 82 87 00 00 00    	jb     8041f8 <__umoddi3+0x134>
  804171:	0f 84 91 00 00 00    	je     804208 <__umoddi3+0x144>
  804177:	8b 54 24 04          	mov    0x4(%esp),%edx
  80417b:	29 f2                	sub    %esi,%edx
  80417d:	19 cb                	sbb    %ecx,%ebx
  80417f:	89 d8                	mov    %ebx,%eax
  804181:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804185:	d3 e0                	shl    %cl,%eax
  804187:	89 e9                	mov    %ebp,%ecx
  804189:	d3 ea                	shr    %cl,%edx
  80418b:	09 d0                	or     %edx,%eax
  80418d:	89 e9                	mov    %ebp,%ecx
  80418f:	d3 eb                	shr    %cl,%ebx
  804191:	89 da                	mov    %ebx,%edx
  804193:	83 c4 1c             	add    $0x1c,%esp
  804196:	5b                   	pop    %ebx
  804197:	5e                   	pop    %esi
  804198:	5f                   	pop    %edi
  804199:	5d                   	pop    %ebp
  80419a:	c3                   	ret    
  80419b:	90                   	nop
  80419c:	89 fd                	mov    %edi,%ebp
  80419e:	85 ff                	test   %edi,%edi
  8041a0:	75 0b                	jne    8041ad <__umoddi3+0xe9>
  8041a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8041a7:	31 d2                	xor    %edx,%edx
  8041a9:	f7 f7                	div    %edi
  8041ab:	89 c5                	mov    %eax,%ebp
  8041ad:	89 f0                	mov    %esi,%eax
  8041af:	31 d2                	xor    %edx,%edx
  8041b1:	f7 f5                	div    %ebp
  8041b3:	89 c8                	mov    %ecx,%eax
  8041b5:	f7 f5                	div    %ebp
  8041b7:	89 d0                	mov    %edx,%eax
  8041b9:	e9 44 ff ff ff       	jmp    804102 <__umoddi3+0x3e>
  8041be:	66 90                	xchg   %ax,%ax
  8041c0:	89 c8                	mov    %ecx,%eax
  8041c2:	89 f2                	mov    %esi,%edx
  8041c4:	83 c4 1c             	add    $0x1c,%esp
  8041c7:	5b                   	pop    %ebx
  8041c8:	5e                   	pop    %esi
  8041c9:	5f                   	pop    %edi
  8041ca:	5d                   	pop    %ebp
  8041cb:	c3                   	ret    
  8041cc:	3b 04 24             	cmp    (%esp),%eax
  8041cf:	72 06                	jb     8041d7 <__umoddi3+0x113>
  8041d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041d5:	77 0f                	ja     8041e6 <__umoddi3+0x122>
  8041d7:	89 f2                	mov    %esi,%edx
  8041d9:	29 f9                	sub    %edi,%ecx
  8041db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041df:	89 14 24             	mov    %edx,(%esp)
  8041e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041ea:	8b 14 24             	mov    (%esp),%edx
  8041ed:	83 c4 1c             	add    $0x1c,%esp
  8041f0:	5b                   	pop    %ebx
  8041f1:	5e                   	pop    %esi
  8041f2:	5f                   	pop    %edi
  8041f3:	5d                   	pop    %ebp
  8041f4:	c3                   	ret    
  8041f5:	8d 76 00             	lea    0x0(%esi),%esi
  8041f8:	2b 04 24             	sub    (%esp),%eax
  8041fb:	19 fa                	sbb    %edi,%edx
  8041fd:	89 d1                	mov    %edx,%ecx
  8041ff:	89 c6                	mov    %eax,%esi
  804201:	e9 71 ff ff ff       	jmp    804177 <__umoddi3+0xb3>
  804206:	66 90                	xchg   %ax,%ax
  804208:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80420c:	72 ea                	jb     8041f8 <__umoddi3+0x134>
  80420e:	89 d9                	mov    %ebx,%ecx
  804210:	e9 62 ff ff ff       	jmp    804177 <__umoddi3+0xb3>
