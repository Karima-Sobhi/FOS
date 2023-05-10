
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 6f 05 00 00       	call   8005a5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	83 ec 74             	sub    $0x74,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 60 36 80 00       	push   $0x803660
  800092:	6a 14                	push   $0x14
  800094:	68 7c 36 80 00       	push   $0x80367c
  800099:	e8 43 06 00 00       	call   8006e1 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 19 18 00 00       	call   8018c1 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	//int sizeOfMemBlocksArray = ROUNDUP(((USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE) * sizeof(struct MemBlock), PAGE_SIZE) ;
	void* ptr_allocations[20] = {0};
  8000b9:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000bc:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c6:	89 d7                	mov    %edx,%edi
  8000c8:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 20 1c 00 00       	call   801cef <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d2:	e8 b8 1c 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  8000d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000dd:	01 c0                	add    %eax,%eax
  8000df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	50                   	push   %eax
  8000e6:	e8 d6 17 00 00       	call   8018c1 <malloc>
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000f1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	79 0a                	jns    800102 <_main+0xca>
  8000f8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000fb:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800100:	76 14                	jbe    800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 90 36 80 00       	push   $0x803690
  80010a:	6a 23                	push   $0x23
  80010c:	68 7c 36 80 00       	push   $0x80367c
  800111:	e8 cb 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800116:	e8 d4 1b 00 00       	call   801cef <sys_calculate_free_frames>
  80011b:	89 c2                	mov    %eax,%edx
  80011d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800120:	39 c2                	cmp    %eax,%edx
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 c0 36 80 00       	push   $0x8036c0
  80012c:	6a 27                	push   $0x27
  80012e:	68 7c 36 80 00       	push   $0x80367c
  800133:	e8 a9 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 52 1c 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 2c 37 80 00       	push   $0x80372c
  80014a:	6a 28                	push   $0x28
  80014c:	68 7c 36 80 00       	push   $0x80367c
  800151:	e8 8b 05 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 94 1b 00 00       	call   801cef <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015e:	e8 2c 1c 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  800163:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800169:	01 c0                	add    %eax,%eax
  80016b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	50                   	push   %eax
  800172:	e8 4a 17 00 00       	call   8018c1 <malloc>
  800177:	83 c4 10             	add    $0x10,%esp
  80017a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80017d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800180:	89 c2                	mov    %eax,%edx
  800182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800185:	01 c0                	add    %eax,%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	72 13                	jb     8001a3 <_main+0x16b>
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	76 14                	jbe    8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 90 36 80 00       	push   $0x803690
  8001ab:	6a 2d                	push   $0x2d
  8001ad:	68 7c 36 80 00       	push   $0x80367c
  8001b2:	e8 2a 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001b7:	e8 33 1b 00 00       	call   801cef <sys_calculate_free_frames>
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	39 c2                	cmp    %eax,%edx
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 c0 36 80 00       	push   $0x8036c0
  8001cd:	6a 2f                	push   $0x2f
  8001cf:	68 7c 36 80 00       	push   $0x80367c
  8001d4:	e8 08 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001d9:	e8 b1 1b 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  8001de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 2c 37 80 00       	push   $0x80372c
  8001eb:	6a 30                	push   $0x30
  8001ed:	68 7c 36 80 00       	push   $0x80367c
  8001f2:	e8 ea 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f7:	e8 f3 1a 00 00       	call   801cef <sys_calculate_free_frames>
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 8b 1b 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  800204:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	01 d2                	add    %edx,%edx
  80020e:	01 d0                	add    %edx,%eax
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	50                   	push   %eax
  800214:	e8 a8 16 00 00       	call   8018c1 <malloc>
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80021f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800222:	89 c2                	mov    %eax,%edx
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	c1 e0 02             	shl    $0x2,%eax
  80022a:	05 00 00 00 80       	add    $0x80000000,%eax
  80022f:	39 c2                	cmp    %eax,%edx
  800231:	72 14                	jb     800247 <_main+0x20f>
  800233:	8b 45 98             	mov    -0x68(%ebp),%eax
  800236:	89 c2                	mov    %eax,%edx
  800238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023b:	c1 e0 02             	shl    $0x2,%eax
  80023e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800243:	39 c2                	cmp    %eax,%edx
  800245:	76 14                	jbe    80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 90 36 80 00       	push   $0x803690
  80024f:	6a 35                	push   $0x35
  800251:	68 7c 36 80 00       	push   $0x80367c
  800256:	e8 86 04 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80025b:	e8 8f 1a 00 00       	call   801cef <sys_calculate_free_frames>
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 c0 36 80 00       	push   $0x8036c0
  800271:	6a 37                	push   $0x37
  800273:	68 7c 36 80 00       	push   $0x80367c
  800278:	e8 64 04 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80027d:	e8 0d 1b 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  800282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 2c 37 80 00       	push   $0x80372c
  80028f:	6a 38                	push   $0x38
  800291:	68 7c 36 80 00       	push   $0x80367c
  800296:	e8 46 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029b:	e8 4f 1a 00 00       	call   801cef <sys_calculate_free_frames>
  8002a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a3:	e8 e7 1a 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  8002a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8002ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ae:	89 c2                	mov    %eax,%edx
  8002b0:	01 d2                	add    %edx,%edx
  8002b2:	01 d0                	add    %edx,%eax
  8002b4:	83 ec 0c             	sub    $0xc,%esp
  8002b7:	50                   	push   %eax
  8002b8:	e8 04 16 00 00       	call   8018c1 <malloc>
  8002bd:	83 c4 10             	add    $0x10,%esp
  8002c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002c3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002c6:	89 c2                	mov    %eax,%edx
  8002c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cb:	c1 e0 02             	shl    $0x2,%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d3:	c1 e0 02             	shl    $0x2,%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 00 00 00 80       	add    $0x80000000,%eax
  8002dd:	39 c2                	cmp    %eax,%edx
  8002df:	72 1e                	jb     8002ff <_main+0x2c7>
  8002e1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002e4:	89 c2                	mov    %eax,%edx
  8002e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e9:	c1 e0 02             	shl    $0x2,%eax
  8002ec:	89 c1                	mov    %eax,%ecx
  8002ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f1:	c1 e0 02             	shl    $0x2,%eax
  8002f4:	01 c8                	add    %ecx,%eax
  8002f6:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002fb:	39 c2                	cmp    %eax,%edx
  8002fd:	76 14                	jbe    800313 <_main+0x2db>
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	68 90 36 80 00       	push   $0x803690
  800307:	6a 3d                	push   $0x3d
  800309:	68 7c 36 80 00       	push   $0x80367c
  80030e:	e8 ce 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800313:	e8 d7 19 00 00       	call   801cef <sys_calculate_free_frames>
  800318:	89 c2                	mov    %eax,%edx
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	74 14                	je     800335 <_main+0x2fd>
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	68 c0 36 80 00       	push   $0x8036c0
  800329:	6a 3f                	push   $0x3f
  80032b:	68 7c 36 80 00       	push   $0x80367c
  800330:	e8 ac 03 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800335:	e8 55 1a 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  80033a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 2c 37 80 00       	push   $0x80372c
  800347:	6a 40                	push   $0x40
  800349:	68 7c 36 80 00       	push   $0x80367c
  80034e:	e8 8e 03 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800353:	e8 97 19 00 00       	call   801cef <sys_calculate_free_frames>
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035b:	e8 2f 1a 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  800360:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800363:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800366:	89 d0                	mov    %edx,%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	01 c0                	add    %eax,%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	50                   	push   %eax
  800374:	e8 48 15 00 00       	call   8018c1 <malloc>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80037f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800382:	89 c2                	mov    %eax,%edx
  800384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800387:	c1 e0 02             	shl    $0x2,%eax
  80038a:	89 c1                	mov    %eax,%ecx
  80038c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80038f:	c1 e0 03             	shl    $0x3,%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	05 00 00 00 80       	add    $0x80000000,%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	72 1e                	jb     8003bb <_main+0x383>
  80039d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a5:	c1 e0 02             	shl    $0x2,%eax
  8003a8:	89 c1                	mov    %eax,%ecx
  8003aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 c8                	add    %ecx,%eax
  8003b2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	76 14                	jbe    8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 90 36 80 00       	push   $0x803690
  8003c3:	6a 45                	push   $0x45
  8003c5:	68 7c 36 80 00       	push   $0x80367c
  8003ca:	e8 12 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003cf:	e8 1b 19 00 00       	call   801cef <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	74 14                	je     8003f1 <_main+0x3b9>
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 c0 36 80 00       	push   $0x8036c0
  8003e5:	6a 47                	push   $0x47
  8003e7:	68 7c 36 80 00       	push   $0x80367c
  8003ec:	e8 f0 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003f1:	e8 99 19 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  8003f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003f9:	74 14                	je     80040f <_main+0x3d7>
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 2c 37 80 00       	push   $0x80372c
  800403:	6a 48                	push   $0x48
  800405:	68 7c 36 80 00       	push   $0x80367c
  80040a:	e8 d2 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80040f:	e8 db 18 00 00       	call   801cef <sys_calculate_free_frames>
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800417:	e8 73 19 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  80041c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  80041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800422:	89 c2                	mov    %eax,%edx
  800424:	01 d2                	add    %edx,%edx
  800426:	01 d0                	add    %edx,%eax
  800428:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	50                   	push   %eax
  80042f:	e8 8d 14 00 00       	call   8018c1 <malloc>
  800434:	83 c4 10             	add    $0x10,%esp
  800437:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80043a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80043d:	89 c2                	mov    %eax,%edx
  80043f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800442:	c1 e0 02             	shl    $0x2,%eax
  800445:	89 c1                	mov    %eax,%ecx
  800447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044a:	c1 e0 04             	shl    $0x4,%eax
  80044d:	01 c8                	add    %ecx,%eax
  80044f:	05 00 00 00 80       	add    $0x80000000,%eax
  800454:	39 c2                	cmp    %eax,%edx
  800456:	72 1e                	jb     800476 <_main+0x43e>
  800458:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80045b:	89 c2                	mov    %eax,%edx
  80045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800460:	c1 e0 02             	shl    $0x2,%eax
  800463:	89 c1                	mov    %eax,%ecx
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	c1 e0 04             	shl    $0x4,%eax
  80046b:	01 c8                	add    %ecx,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 90 36 80 00       	push   $0x803690
  80047e:	6a 4d                	push   $0x4d
  800480:	68 7c 36 80 00       	push   $0x80367c
  800485:	e8 57 02 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80048a:	e8 60 18 00 00       	call   801cef <sys_calculate_free_frames>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <_main+0x474>
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 5a 37 80 00       	push   $0x80375a
  8004a0:	6a 4e                	push   $0x4e
  8004a2:	68 7c 36 80 00       	push   $0x80367c
  8004a7:	e8 35 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ac:	e8 de 18 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  8004b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004b4:	74 14                	je     8004ca <_main+0x492>
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 2c 37 80 00       	push   $0x80372c
  8004be:	6a 4f                	push   $0x4f
  8004c0:	68 7c 36 80 00       	push   $0x80367c
  8004c5:	e8 17 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ca:	e8 20 18 00 00       	call   801cef <sys_calculate_free_frames>
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d2:	e8 b8 18 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  8004d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004dd:	01 c0                	add    %eax,%eax
  8004df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	50                   	push   %eax
  8004e6:	e8 d6 13 00 00       	call   8018c1 <malloc>
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8004f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004f4:	89 c1                	mov    %eax,%ecx
  8004f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004f9:	89 d0                	mov    %edx,%eax
  8004fb:	01 c0                	add    %eax,%eax
  8004fd:	01 d0                	add    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	89 c2                	mov    %eax,%edx
  800505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800508:	c1 e0 04             	shl    $0x4,%eax
  80050b:	01 d0                	add    %edx,%eax
  80050d:	05 00 00 00 80       	add    $0x80000000,%eax
  800512:	39 c1                	cmp    %eax,%ecx
  800514:	72 25                	jb     80053b <_main+0x503>
  800516:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800519:	89 c1                	mov    %eax,%ecx
  80051b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051e:	89 d0                	mov    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d0                	add    %edx,%eax
  800524:	01 c0                	add    %eax,%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	89 c2                	mov    %eax,%edx
  80052a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80052d:	c1 e0 04             	shl    $0x4,%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800537:	39 c1                	cmp    %eax,%ecx
  800539:	76 14                	jbe    80054f <_main+0x517>
  80053b:	83 ec 04             	sub    $0x4,%esp
  80053e:	68 90 36 80 00       	push   $0x803690
  800543:	6a 54                	push   $0x54
  800545:	68 7c 36 80 00       	push   $0x80367c
  80054a:	e8 92 01 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80054f:	e8 9b 17 00 00       	call   801cef <sys_calculate_free_frames>
  800554:	89 c2                	mov    %eax,%edx
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 5a 37 80 00       	push   $0x80375a
  800565:	6a 55                	push   $0x55
  800567:	68 7c 36 80 00       	push   $0x80367c
  80056c:	e8 70 01 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800571:	e8 19 18 00 00       	call   801d8f <sys_pf_calculate_allocated_pages>
  800576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 2c 37 80 00       	push   $0x80372c
  800583:	6a 56                	push   $0x56
  800585:	68 7c 36 80 00       	push   $0x80367c
  80058a:	e8 52 01 00 00       	call   8006e1 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	68 70 37 80 00       	push   $0x803770
  800597:	e8 f9 03 00 00       	call   800995 <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

	return;
  80059f:	90                   	nop
}
  8005a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8005a3:	c9                   	leave  
  8005a4:	c3                   	ret    

008005a5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005ab:	e8 1f 1a 00 00       	call   801fcf <sys_getenvindex>
  8005b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005b6:	89 d0                	mov    %edx,%eax
  8005b8:	c1 e0 03             	shl    $0x3,%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	01 c0                	add    %eax,%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 04             	shl    $0x4,%eax
  8005cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005d2:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8005dc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005e2:	84 c0                	test   %al,%al
  8005e4:	74 0f                	je     8005f5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005eb:	05 5c 05 00 00       	add    $0x55c,%eax
  8005f0:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005f9:	7e 0a                	jle    800605 <libmain+0x60>
		binaryname = argv[0];
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 25 fa ff ff       	call   800038 <_main>
  800613:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800616:	e8 c1 17 00 00       	call   801ddc <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	68 c4 37 80 00       	push   $0x8037c4
  800623:	e8 6d 03 00 00       	call   800995 <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80062b:	a1 20 40 80 00       	mov    0x804020,%eax
  800630:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800636:	a1 20 40 80 00       	mov    0x804020,%eax
  80063b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	52                   	push   %edx
  800645:	50                   	push   %eax
  800646:	68 ec 37 80 00       	push   $0x8037ec
  80064b:	e8 45 03 00 00       	call   800995 <cprintf>
  800650:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800653:	a1 20 40 80 00       	mov    0x804020,%eax
  800658:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80065e:	a1 20 40 80 00       	mov    0x804020,%eax
  800663:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800669:	a1 20 40 80 00       	mov    0x804020,%eax
  80066e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800674:	51                   	push   %ecx
  800675:	52                   	push   %edx
  800676:	50                   	push   %eax
  800677:	68 14 38 80 00       	push   $0x803814
  80067c:	e8 14 03 00 00       	call   800995 <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800684:	a1 20 40 80 00       	mov    0x804020,%eax
  800689:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	68 6c 38 80 00       	push   $0x80386c
  800698:	e8 f8 02 00 00       	call   800995 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	68 c4 37 80 00       	push   $0x8037c4
  8006a8:	e8 e8 02 00 00       	call   800995 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b0:	e8 41 17 00 00       	call   801df6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006b5:	e8 19 00 00 00       	call   8006d3 <exit>
}
  8006ba:	90                   	nop
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	6a 00                	push   $0x0
  8006c8:	e8 ce 18 00 00       	call   801f9b <sys_destroy_env>
  8006cd:	83 c4 10             	add    $0x10,%esp
}
  8006d0:	90                   	nop
  8006d1:	c9                   	leave  
  8006d2:	c3                   	ret    

008006d3 <exit>:

void
exit(void)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006d9:	e8 23 19 00 00       	call   802001 <sys_exit_env>
}
  8006de:	90                   	nop
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8006ea:	83 c0 04             	add    $0x4,%eax
  8006ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006f0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	74 16                	je     80070f <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006f9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	50                   	push   %eax
  800702:	68 80 38 80 00       	push   $0x803880
  800707:	e8 89 02 00 00       	call   800995 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070f:	a1 00 40 80 00       	mov    0x804000,%eax
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	50                   	push   %eax
  80071b:	68 85 38 80 00       	push   $0x803885
  800720:	e8 70 02 00 00       	call   800995 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800728:	8b 45 10             	mov    0x10(%ebp),%eax
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 f4             	pushl  -0xc(%ebp)
  800731:	50                   	push   %eax
  800732:	e8 f3 01 00 00       	call   80092a <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	6a 00                	push   $0x0
  80073f:	68 a1 38 80 00       	push   $0x8038a1
  800744:	e8 e1 01 00 00       	call   80092a <vcprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80074c:	e8 82 ff ff ff       	call   8006d3 <exit>

	// should not return here
	while (1) ;
  800751:	eb fe                	jmp    800751 <_panic+0x70>

00800753 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800759:	a1 20 40 80 00       	mov    0x804020,%eax
  80075e:	8b 50 74             	mov    0x74(%eax),%edx
  800761:	8b 45 0c             	mov    0xc(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 14                	je     80077c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 a4 38 80 00       	push   $0x8038a4
  800770:	6a 26                	push   $0x26
  800772:	68 f0 38 80 00       	push   $0x8038f0
  800777:	e8 65 ff ff ff       	call   8006e1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80077c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800783:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80078a:	e9 c2 00 00 00       	jmp    800851 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80078f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800792:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	01 d0                	add    %edx,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	85 c0                	test   %eax,%eax
  8007a2:	75 08                	jne    8007ac <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007a4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007a7:	e9 a2 00 00 00       	jmp    80084e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ba:	eb 69                	jmp    800825 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8007c1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ca:	89 d0                	mov    %edx,%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	01 d0                	add    %edx,%eax
  8007d0:	c1 e0 03             	shl    $0x3,%eax
  8007d3:	01 c8                	add    %ecx,%eax
  8007d5:	8a 40 04             	mov    0x4(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	75 46                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8007e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ea:	89 d0                	mov    %edx,%eax
  8007ec:	01 c0                	add    %eax,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	c1 e0 03             	shl    $0x3,%eax
  8007f3:	01 c8                	add    %ecx,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800802:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800807:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	01 c8                	add    %ecx,%eax
  800813:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800815:	39 c2                	cmp    %eax,%edx
  800817:	75 09                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800819:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800820:	eb 12                	jmp    800834 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800822:	ff 45 e8             	incl   -0x18(%ebp)
  800825:	a1 20 40 80 00       	mov    0x804020,%eax
  80082a:	8b 50 74             	mov    0x74(%eax),%edx
  80082d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800830:	39 c2                	cmp    %eax,%edx
  800832:	77 88                	ja     8007bc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800834:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800838:	75 14                	jne    80084e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80083a:	83 ec 04             	sub    $0x4,%esp
  80083d:	68 fc 38 80 00       	push   $0x8038fc
  800842:	6a 3a                	push   $0x3a
  800844:	68 f0 38 80 00       	push   $0x8038f0
  800849:	e8 93 fe ff ff       	call   8006e1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80084e:	ff 45 f0             	incl   -0x10(%ebp)
  800851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800854:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800857:	0f 8c 32 ff ff ff    	jl     80078f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80085d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800864:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80086b:	eb 26                	jmp    800893 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80086d:	a1 20 40 80 00       	mov    0x804020,%eax
  800872:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800878:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80087b:	89 d0                	mov    %edx,%eax
  80087d:	01 c0                	add    %eax,%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	c1 e0 03             	shl    $0x3,%eax
  800884:	01 c8                	add    %ecx,%eax
  800886:	8a 40 04             	mov    0x4(%eax),%al
  800889:	3c 01                	cmp    $0x1,%al
  80088b:	75 03                	jne    800890 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80088d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800890:	ff 45 e0             	incl   -0x20(%ebp)
  800893:	a1 20 40 80 00       	mov    0x804020,%eax
  800898:	8b 50 74             	mov    0x74(%eax),%edx
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	39 c2                	cmp    %eax,%edx
  8008a0:	77 cb                	ja     80086d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008a8:	74 14                	je     8008be <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008aa:	83 ec 04             	sub    $0x4,%esp
  8008ad:	68 50 39 80 00       	push   $0x803950
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 f0 38 80 00       	push   $0x8038f0
  8008b9:	e8 23 fe ff ff       	call   8006e1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008be:	90                   	nop
  8008bf:	c9                   	leave  
  8008c0:	c3                   	ret    

008008c1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8008cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d2:	89 0a                	mov    %ecx,(%edx)
  8008d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d7:	88 d1                	mov    %dl,%cl
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ea:	75 2c                	jne    800918 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008ec:	a0 24 40 80 00       	mov    0x804024,%al
  8008f1:	0f b6 c0             	movzbl %al,%eax
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f7:	8b 12                	mov    (%edx),%edx
  8008f9:	89 d1                	mov    %edx,%ecx
  8008fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fe:	83 c2 08             	add    $0x8,%edx
  800901:	83 ec 04             	sub    $0x4,%esp
  800904:	50                   	push   %eax
  800905:	51                   	push   %ecx
  800906:	52                   	push   %edx
  800907:	e8 22 13 00 00       	call   801c2e <sys_cputs>
  80090c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091b:	8b 40 04             	mov    0x4(%eax),%eax
  80091e:	8d 50 01             	lea    0x1(%eax),%edx
  800921:	8b 45 0c             	mov    0xc(%ebp),%eax
  800924:	89 50 04             	mov    %edx,0x4(%eax)
}
  800927:	90                   	nop
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800933:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80093a:	00 00 00 
	b.cnt = 0;
  80093d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800944:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	68 c1 08 80 00       	push   $0x8008c1
  800959:	e8 11 02 00 00       	call   800b6f <vprintfmt>
  80095e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800961:	a0 24 40 80 00       	mov    0x804024,%al
  800966:	0f b6 c0             	movzbl %al,%eax
  800969:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	50                   	push   %eax
  800973:	52                   	push   %edx
  800974:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80097a:	83 c0 08             	add    $0x8,%eax
  80097d:	50                   	push   %eax
  80097e:	e8 ab 12 00 00       	call   801c2e <sys_cputs>
  800983:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800986:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80098d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <cprintf>:

int cprintf(const char *fmt, ...) {
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80099b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8009a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b1:	50                   	push   %eax
  8009b2:	e8 73 ff ff ff       	call   80092a <vcprintf>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    

008009c2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009c8:	e8 0f 14 00 00       	call   801ddc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dc:	50                   	push   %eax
  8009dd:	e8 48 ff ff ff       	call   80092a <vcprintf>
  8009e2:	83 c4 10             	add    $0x10,%esp
  8009e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009e8:	e8 09 14 00 00       	call   801df6 <sys_enable_interrupt>
	return cnt;
  8009ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	83 ec 14             	sub    $0x14,%esp
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a05:	8b 45 18             	mov    0x18(%ebp),%eax
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a10:	77 55                	ja     800a67 <printnum+0x75>
  800a12:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a15:	72 05                	jb     800a1c <printnum+0x2a>
  800a17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a1a:	77 4b                	ja     800a67 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a1c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a1f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a22:	8b 45 18             	mov    0x18(%ebp),%eax
  800a25:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2a:	52                   	push   %edx
  800a2b:	50                   	push   %eax
  800a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a32:	e8 b5 29 00 00       	call   8033ec <__udivdi3>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	83 ec 04             	sub    $0x4,%esp
  800a3d:	ff 75 20             	pushl  0x20(%ebp)
  800a40:	53                   	push   %ebx
  800a41:	ff 75 18             	pushl  0x18(%ebp)
  800a44:	52                   	push   %edx
  800a45:	50                   	push   %eax
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	e8 a1 ff ff ff       	call   8009f2 <printnum>
  800a51:	83 c4 20             	add    $0x20,%esp
  800a54:	eb 1a                	jmp    800a70 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	ff 75 20             	pushl  0x20(%ebp)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a67:	ff 4d 1c             	decl   0x1c(%ebp)
  800a6a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a6e:	7f e6                	jg     800a56 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a70:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7e:	53                   	push   %ebx
  800a7f:	51                   	push   %ecx
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	e8 75 2a 00 00       	call   8034fc <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 b4 3b 80 00       	add    $0x803bb4,%eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	0f be c0             	movsbl %al,%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
}
  800aa3:	90                   	nop
  800aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ab0:	7e 1c                	jle    800ace <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 00                	mov    (%eax),%eax
  800ab7:	8d 50 08             	lea    0x8(%eax),%edx
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	89 10                	mov    %edx,(%eax)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	83 e8 08             	sub    $0x8,%eax
  800ac7:	8b 50 04             	mov    0x4(%eax),%edx
  800aca:	8b 00                	mov    (%eax),%eax
  800acc:	eb 40                	jmp    800b0e <getuint+0x65>
	else if (lflag)
  800ace:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad2:	74 1e                	je     800af2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	8d 50 04             	lea    0x4(%eax),%edx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	89 10                	mov    %edx,(%eax)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	83 e8 04             	sub    $0x4,%eax
  800ae9:	8b 00                	mov    (%eax),%eax
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	eb 1c                	jmp    800b0e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 50 04             	lea    0x4(%eax),%edx
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 10                	mov    %edx,(%eax)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 00                	mov    (%eax),%eax
  800b04:	83 e8 04             	sub    $0x4,%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b13:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b17:	7e 1c                	jle    800b35 <getint+0x25>
		return va_arg(*ap, long long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 08             	lea    0x8(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 08             	sub    $0x8,%eax
  800b2e:	8b 50 04             	mov    0x4(%eax),%edx
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	eb 38                	jmp    800b6d <getint+0x5d>
	else if (lflag)
  800b35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b39:	74 1a                	je     800b55 <getint+0x45>
		return va_arg(*ap, long);
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	8d 50 04             	lea    0x4(%eax),%edx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	89 10                	mov    %edx,(%eax)
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	83 e8 04             	sub    $0x4,%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	99                   	cltd   
  800b53:	eb 18                	jmp    800b6d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 50 04             	lea    0x4(%eax),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 10                	mov    %edx,(%eax)
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	83 e8 04             	sub    $0x4,%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	99                   	cltd   
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b77:	eb 17                	jmp    800b90 <vprintfmt+0x21>
			if (ch == '\0')
  800b79:	85 db                	test   %ebx,%ebx
  800b7b:	0f 84 af 03 00 00    	je     800f30 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	53                   	push   %ebx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	8d 50 01             	lea    0x1(%eax),%edx
  800b96:	89 55 10             	mov    %edx,0x10(%ebp)
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	0f b6 d8             	movzbl %al,%ebx
  800b9e:	83 fb 25             	cmp    $0x25,%ebx
  800ba1:	75 d6                	jne    800b79 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ba3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ba7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bb5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bbc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc6:	8d 50 01             	lea    0x1(%eax),%edx
  800bc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	0f b6 d8             	movzbl %al,%ebx
  800bd1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bd4:	83 f8 55             	cmp    $0x55,%eax
  800bd7:	0f 87 2b 03 00 00    	ja     800f08 <vprintfmt+0x399>
  800bdd:	8b 04 85 d8 3b 80 00 	mov    0x803bd8(,%eax,4),%eax
  800be4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800be6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bea:	eb d7                	jmp    800bc3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bec:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bf0:	eb d1                	jmp    800bc3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bfc:	89 d0                	mov    %edx,%eax
  800bfe:	c1 e0 02             	shl    $0x2,%eax
  800c01:	01 d0                	add    %edx,%eax
  800c03:	01 c0                	add    %eax,%eax
  800c05:	01 d8                	add    %ebx,%eax
  800c07:	83 e8 30             	sub    $0x30,%eax
  800c0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c15:	83 fb 2f             	cmp    $0x2f,%ebx
  800c18:	7e 3e                	jle    800c58 <vprintfmt+0xe9>
  800c1a:	83 fb 39             	cmp    $0x39,%ebx
  800c1d:	7f 39                	jg     800c58 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c1f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c22:	eb d5                	jmp    800bf9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	83 c0 04             	add    $0x4,%eax
  800c2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c38:	eb 1f                	jmp    800c59 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3e:	79 83                	jns    800bc3 <vprintfmt+0x54>
				width = 0;
  800c40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c47:	e9 77 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c4c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c53:	e9 6b ff ff ff       	jmp    800bc3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c58:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5d:	0f 89 60 ff ff ff    	jns    800bc3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c69:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c70:	e9 4e ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c75:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c78:	e9 46 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 c0 04             	add    $0x4,%eax
  800c83:	89 45 14             	mov    %eax,0x14(%ebp)
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	83 e8 04             	sub    $0x4,%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	ff d0                	call   *%eax
  800c9a:	83 c4 10             	add    $0x10,%esp
			break;
  800c9d:	e9 89 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ca2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca5:	83 c0 04             	add    $0x4,%eax
  800ca8:	89 45 14             	mov    %eax,0x14(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 e8 04             	sub    $0x4,%eax
  800cb1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cb3:	85 db                	test   %ebx,%ebx
  800cb5:	79 02                	jns    800cb9 <vprintfmt+0x14a>
				err = -err;
  800cb7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cb9:	83 fb 64             	cmp    $0x64,%ebx
  800cbc:	7f 0b                	jg     800cc9 <vprintfmt+0x15a>
  800cbe:	8b 34 9d 20 3a 80 00 	mov    0x803a20(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 c5 3b 80 00       	push   $0x803bc5
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	ff 75 08             	pushl  0x8(%ebp)
  800cd5:	e8 5e 02 00 00       	call   800f38 <printfmt>
  800cda:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cdd:	e9 49 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ce2:	56                   	push   %esi
  800ce3:	68 ce 3b 80 00       	push   $0x803bce
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	ff 75 08             	pushl  0x8(%ebp)
  800cee:	e8 45 02 00 00       	call   800f38 <printfmt>
  800cf3:	83 c4 10             	add    $0x10,%esp
			break;
  800cf6:	e9 30 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfe:	83 c0 04             	add    $0x4,%eax
  800d01:	89 45 14             	mov    %eax,0x14(%ebp)
  800d04:	8b 45 14             	mov    0x14(%ebp),%eax
  800d07:	83 e8 04             	sub    $0x4,%eax
  800d0a:	8b 30                	mov    (%eax),%esi
  800d0c:	85 f6                	test   %esi,%esi
  800d0e:	75 05                	jne    800d15 <vprintfmt+0x1a6>
				p = "(null)";
  800d10:	be d1 3b 80 00       	mov    $0x803bd1,%esi
			if (width > 0 && padc != '-')
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	7e 6d                	jle    800d88 <vprintfmt+0x219>
  800d1b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d1f:	74 67                	je     800d88 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d24:	83 ec 08             	sub    $0x8,%esp
  800d27:	50                   	push   %eax
  800d28:	56                   	push   %esi
  800d29:	e8 0c 03 00 00       	call   80103a <strnlen>
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d34:	eb 16                	jmp    800d4c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d36:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d3a:	83 ec 08             	sub    $0x8,%esp
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	50                   	push   %eax
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	ff d0                	call   *%eax
  800d46:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d49:	ff 4d e4             	decl   -0x1c(%ebp)
  800d4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d50:	7f e4                	jg     800d36 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d52:	eb 34                	jmp    800d88 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d58:	74 1c                	je     800d76 <vprintfmt+0x207>
  800d5a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d5d:	7e 05                	jle    800d64 <vprintfmt+0x1f5>
  800d5f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d62:	7e 12                	jle    800d76 <vprintfmt+0x207>
					putch('?', putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	6a 3f                	push   $0x3f
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	ff d0                	call   *%eax
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	eb 0f                	jmp    800d85 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	53                   	push   %ebx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	ff d0                	call   *%eax
  800d82:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d85:	ff 4d e4             	decl   -0x1c(%ebp)
  800d88:	89 f0                	mov    %esi,%eax
  800d8a:	8d 70 01             	lea    0x1(%eax),%esi
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f be d8             	movsbl %al,%ebx
  800d92:	85 db                	test   %ebx,%ebx
  800d94:	74 24                	je     800dba <vprintfmt+0x24b>
  800d96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d9a:	78 b8                	js     800d54 <vprintfmt+0x1e5>
  800d9c:	ff 4d e0             	decl   -0x20(%ebp)
  800d9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da3:	79 af                	jns    800d54 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	eb 13                	jmp    800dba <vprintfmt+0x24b>
				putch(' ', putdat);
  800da7:	83 ec 08             	sub    $0x8,%esp
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	6a 20                	push   $0x20
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	ff d0                	call   *%eax
  800db4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db7:	ff 4d e4             	decl   -0x1c(%ebp)
  800dba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbe:	7f e7                	jg     800da7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dc0:	e9 66 01 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcb:	8d 45 14             	lea    0x14(%ebp),%eax
  800dce:	50                   	push   %eax
  800dcf:	e8 3c fd ff ff       	call   800b10 <getint>
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de3:	85 d2                	test   %edx,%edx
  800de5:	79 23                	jns    800e0a <vprintfmt+0x29b>
				putch('-', putdat);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	6a 2d                	push   $0x2d
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfd:	f7 d8                	neg    %eax
  800dff:	83 d2 00             	adc    $0x0,%edx
  800e02:	f7 da                	neg    %edx
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e11:	e9 bc 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 e8             	pushl  -0x18(%ebp)
  800e1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e1f:	50                   	push   %eax
  800e20:	e8 84 fc ff ff       	call   800aa9 <getuint>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e35:	e9 98 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 0c             	pushl  0xc(%ebp)
  800e40:	6a 58                	push   $0x58
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	ff d0                	call   *%eax
  800e47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	6a 58                	push   $0x58
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	ff d0                	call   *%eax
  800e57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	6a 58                	push   $0x58
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	ff d0                	call   *%eax
  800e67:	83 c4 10             	add    $0x10,%esp
			break;
  800e6a:	e9 bc 00 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e6f:	83 ec 08             	sub    $0x8,%esp
  800e72:	ff 75 0c             	pushl  0xc(%ebp)
  800e75:	6a 30                	push   $0x30
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	ff d0                	call   *%eax
  800e7c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 78                	push   $0x78
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eaa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eb1:	eb 1f                	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 e8             	pushl  -0x18(%ebp)
  800eb9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebc:	50                   	push   %eax
  800ebd:	e8 e7 fb ff ff       	call   800aa9 <getuint>
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ecb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ed2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ed9:	83 ec 04             	sub    $0x4,%esp
  800edc:	52                   	push   %edx
  800edd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ee0:	50                   	push   %eax
  800ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ee7:	ff 75 0c             	pushl  0xc(%ebp)
  800eea:	ff 75 08             	pushl  0x8(%ebp)
  800eed:	e8 00 fb ff ff       	call   8009f2 <printnum>
  800ef2:	83 c4 20             	add    $0x20,%esp
			break;
  800ef5:	eb 34                	jmp    800f2b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	53                   	push   %ebx
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			break;
  800f06:	eb 23                	jmp    800f2b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	6a 25                	push   $0x25
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	ff d0                	call   *%eax
  800f15:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	eb 03                	jmp    800f20 <vprintfmt+0x3b1>
  800f1d:	ff 4d 10             	decl   0x10(%ebp)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	48                   	dec    %eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 25                	cmp    $0x25,%al
  800f28:	75 f3                	jne    800f1d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f2a:	90                   	nop
		}
	}
  800f2b:	e9 47 fc ff ff       	jmp    800b77 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f30:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f3e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4d:	50                   	push   %eax
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	e8 16 fc ff ff       	call   800b6f <vprintfmt>
  800f59:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f5c:	90                   	nop
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	8b 40 08             	mov    0x8(%eax),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8b 10                	mov    (%eax),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	8b 40 04             	mov    0x4(%eax),%eax
  800f7c:	39 c2                	cmp    %eax,%edx
  800f7e:	73 12                	jae    800f92 <sprintputch+0x33>
		*b->buf++ = ch;
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8b 00                	mov    (%eax),%eax
  800f85:	8d 48 01             	lea    0x1(%eax),%ecx
  800f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8b:	89 0a                	mov    %ecx,(%edx)
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	88 10                	mov    %dl,(%eax)
}
  800f92:	90                   	nop
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	01 d0                	add    %edx,%eax
  800fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fba:	74 06                	je     800fc2 <vsnprintf+0x2d>
  800fbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc0:	7f 07                	jg     800fc9 <vsnprintf+0x34>
		return -E_INVAL;
  800fc2:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc7:	eb 20                	jmp    800fe9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fc9:	ff 75 14             	pushl  0x14(%ebp)
  800fcc:	ff 75 10             	pushl  0x10(%ebp)
  800fcf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	68 5f 0f 80 00       	push   $0x800f5f
  800fd8:	e8 92 fb ff ff       	call   800b6f <vprintfmt>
  800fdd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ff1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff4:	83 c0 04             	add    $0x4,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	ff 75 f4             	pushl  -0xc(%ebp)
  801000:	50                   	push   %eax
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	ff 75 08             	pushl  0x8(%ebp)
  801007:	e8 89 ff ff ff       	call   800f95 <vsnprintf>
  80100c:	83 c4 10             	add    $0x10,%esp
  80100f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801012:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80101d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801024:	eb 06                	jmp    80102c <strlen+0x15>
		n++;
  801026:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801029:	ff 45 08             	incl   0x8(%ebp)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	75 f1                	jne    801026 <strlen+0xf>
		n++;
	return n;
  801035:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801047:	eb 09                	jmp    801052 <strnlen+0x18>
		n++;
  801049:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	ff 4d 0c             	decl   0xc(%ebp)
  801052:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801056:	74 09                	je     801061 <strnlen+0x27>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e8                	jne    801049 <strnlen+0xf>
		n++;
	return n;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801072:	90                   	nop
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8d 50 01             	lea    0x1(%eax),%edx
  801079:	89 55 08             	mov    %edx,0x8(%ebp)
  80107c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801082:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801085:	8a 12                	mov    (%edx),%dl
  801087:	88 10                	mov    %dl,(%eax)
  801089:	8a 00                	mov    (%eax),%al
  80108b:	84 c0                	test   %al,%al
  80108d:	75 e4                	jne    801073 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a7:	eb 1f                	jmp    8010c8 <strncpy+0x34>
		*dst++ = *src;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8d 50 01             	lea    0x1(%eax),%edx
  8010af:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b5:	8a 12                	mov    (%edx),%dl
  8010b7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	84 c0                	test   %al,%al
  8010c0:	74 03                	je     8010c5 <strncpy+0x31>
			src++;
  8010c2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010c5:	ff 45 fc             	incl   -0x4(%ebp)
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ce:	72 d9                	jb     8010a9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e5:	74 30                	je     801117 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010e7:	eb 16                	jmp    8010ff <strlcpy+0x2a>
			*dst++ = *src++;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fb:	8a 12                	mov    (%edx),%dl
  8010fd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ff:	ff 4d 10             	decl   0x10(%ebp)
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	74 09                	je     801111 <strlcpy+0x3c>
  801108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	84 c0                	test   %al,%al
  80110f:	75 d8                	jne    8010e9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111d:	29 c2                	sub    %eax,%edx
  80111f:	89 d0                	mov    %edx,%eax
}
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801126:	eb 06                	jmp    80112e <strcmp+0xb>
		p++, q++;
  801128:	ff 45 08             	incl   0x8(%ebp)
  80112b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	84 c0                	test   %al,%al
  801135:	74 0e                	je     801145 <strcmp+0x22>
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 10                	mov    (%eax),%dl
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	38 c2                	cmp    %al,%dl
  801143:	74 e3                	je     801128 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 d0             	movzbl %al,%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	29 c2                	sub    %eax,%edx
  801157:	89 d0                	mov    %edx,%eax
}
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80115e:	eb 09                	jmp    801169 <strncmp+0xe>
		n--, p++, q++;
  801160:	ff 4d 10             	decl   0x10(%ebp)
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801169:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116d:	74 17                	je     801186 <strncmp+0x2b>
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	84 c0                	test   %al,%al
  801176:	74 0e                	je     801186 <strncmp+0x2b>
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 10                	mov    (%eax),%dl
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	38 c2                	cmp    %al,%dl
  801184:	74 da                	je     801160 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801186:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118a:	75 07                	jne    801193 <strncmp+0x38>
		return 0;
  80118c:	b8 00 00 00 00       	mov    $0x0,%eax
  801191:	eb 14                	jmp    8011a7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	0f b6 d0             	movzbl %al,%edx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	0f b6 c0             	movzbl %al,%eax
  8011a3:	29 c2                	sub    %eax,%edx
  8011a5:	89 d0                	mov    %edx,%eax
}
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    

008011a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 04             	sub    $0x4,%esp
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b5:	eb 12                	jmp    8011c9 <strchr+0x20>
		if (*s == c)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011bf:	75 05                	jne    8011c6 <strchr+0x1d>
			return (char *) s;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	eb 11                	jmp    8011d7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c6:	ff 45 08             	incl   0x8(%ebp)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	84 c0                	test   %al,%al
  8011d0:	75 e5                	jne    8011b7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e5:	eb 0d                	jmp    8011f4 <strfind+0x1b>
		if (*s == c)
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ef:	74 0e                	je     8011ff <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011f1:	ff 45 08             	incl   0x8(%ebp)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	75 ea                	jne    8011e7 <strfind+0xe>
  8011fd:	eb 01                	jmp    801200 <strfind+0x27>
		if (*s == c)
			break;
  8011ff:	90                   	nop
	return (char *) s;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801217:	eb 0e                	jmp    801227 <memset+0x22>
		*p++ = c;
  801219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121c:	8d 50 01             	lea    0x1(%eax),%edx
  80121f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801222:	8b 55 0c             	mov    0xc(%ebp),%edx
  801225:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801227:	ff 4d f8             	decl   -0x8(%ebp)
  80122a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80122e:	79 e9                	jns    801219 <memset+0x14>
		*p++ = c;

	return v;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801247:	eb 16                	jmp    80125f <memcpy+0x2a>
		*d++ = *s++;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	8d 50 01             	lea    0x1(%eax),%edx
  80124f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801255:	8d 4a 01             	lea    0x1(%edx),%ecx
  801258:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80125b:	8a 12                	mov    (%edx),%dl
  80125d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	8d 50 ff             	lea    -0x1(%eax),%edx
  801265:	89 55 10             	mov    %edx,0x10(%ebp)
  801268:	85 c0                	test   %eax,%eax
  80126a:	75 dd                	jne    801249 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801283:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801286:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801289:	73 50                	jae    8012db <memmove+0x6a>
  80128b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801296:	76 43                	jbe    8012db <memmove+0x6a>
		s += n;
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80129e:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a4:	eb 10                	jmp    8012b6 <memmove+0x45>
			*--d = *--s;
  8012a6:	ff 4d f8             	decl   -0x8(%ebp)
  8012a9:	ff 4d fc             	decl   -0x4(%ebp)
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012af:	8a 10                	mov    (%eax),%dl
  8012b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	75 e3                	jne    8012a6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c3:	eb 23                	jmp    8012e8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d7:	8a 12                	mov    (%edx),%dl
  8012d9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	75 dd                	jne    8012c5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ff:	eb 2a                	jmp    80132b <memcmp+0x3e>
		if (*s1 != *s2)
  801301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801304:	8a 10                	mov    (%eax),%dl
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	38 c2                	cmp    %al,%dl
  80130d:	74 16                	je     801325 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f b6 d0             	movzbl %al,%edx
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f b6 c0             	movzbl %al,%eax
  80131f:	29 c2                	sub    %eax,%edx
  801321:	89 d0                	mov    %edx,%eax
  801323:	eb 18                	jmp    80133d <memcmp+0x50>
		s1++, s2++;
  801325:	ff 45 fc             	incl   -0x4(%ebp)
  801328:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80132b:	8b 45 10             	mov    0x10(%ebp),%eax
  80132e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801331:	89 55 10             	mov    %edx,0x10(%ebp)
  801334:	85 c0                	test   %eax,%eax
  801336:	75 c9                	jne    801301 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801345:	8b 55 08             	mov    0x8(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801350:	eb 15                	jmp    801367 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f b6 d0             	movzbl %al,%edx
  80135a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135d:	0f b6 c0             	movzbl %al,%eax
  801360:	39 c2                	cmp    %eax,%edx
  801362:	74 0d                	je     801371 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801364:	ff 45 08             	incl   0x8(%ebp)
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80136d:	72 e3                	jb     801352 <memfind+0x13>
  80136f:	eb 01                	jmp    801372 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801371:	90                   	nop
	return (void *) s;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80137d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801384:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138b:	eb 03                	jmp    801390 <strtol+0x19>
		s++;
  80138d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 20                	cmp    $0x20,%al
  801397:	74 f4                	je     80138d <strtol+0x16>
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	3c 09                	cmp    $0x9,%al
  8013a0:	74 eb                	je     80138d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	3c 2b                	cmp    $0x2b,%al
  8013a9:	75 05                	jne    8013b0 <strtol+0x39>
		s++;
  8013ab:	ff 45 08             	incl   0x8(%ebp)
  8013ae:	eb 13                	jmp    8013c3 <strtol+0x4c>
	else if (*s == '-')
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	3c 2d                	cmp    $0x2d,%al
  8013b7:	75 0a                	jne    8013c3 <strtol+0x4c>
		s++, neg = 1;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
  8013bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c7:	74 06                	je     8013cf <strtol+0x58>
  8013c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013cd:	75 20                	jne    8013ef <strtol+0x78>
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	3c 30                	cmp    $0x30,%al
  8013d6:	75 17                	jne    8013ef <strtol+0x78>
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	40                   	inc    %eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	3c 78                	cmp    $0x78,%al
  8013e0:	75 0d                	jne    8013ef <strtol+0x78>
		s += 2, base = 16;
  8013e2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013ed:	eb 28                	jmp    801417 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f3:	75 15                	jne    80140a <strtol+0x93>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	3c 30                	cmp    $0x30,%al
  8013fc:	75 0c                	jne    80140a <strtol+0x93>
		s++, base = 8;
  8013fe:	ff 45 08             	incl   0x8(%ebp)
  801401:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801408:	eb 0d                	jmp    801417 <strtol+0xa0>
	else if (base == 0)
  80140a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140e:	75 07                	jne    801417 <strtol+0xa0>
		base = 10;
  801410:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	3c 2f                	cmp    $0x2f,%al
  80141e:	7e 19                	jle    801439 <strtol+0xc2>
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 39                	cmp    $0x39,%al
  801427:	7f 10                	jg     801439 <strtol+0xc2>
			dig = *s - '0';
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	0f be c0             	movsbl %al,%eax
  801431:	83 e8 30             	sub    $0x30,%eax
  801434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801437:	eb 42                	jmp    80147b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 60                	cmp    $0x60,%al
  801440:	7e 19                	jle    80145b <strtol+0xe4>
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	3c 7a                	cmp    $0x7a,%al
  801449:	7f 10                	jg     80145b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	83 e8 57             	sub    $0x57,%eax
  801456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801459:	eb 20                	jmp    80147b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	3c 40                	cmp    $0x40,%al
  801462:	7e 39                	jle    80149d <strtol+0x126>
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 5a                	cmp    $0x5a,%al
  80146b:	7f 30                	jg     80149d <strtol+0x126>
			dig = *s - 'A' + 10;
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	0f be c0             	movsbl %al,%eax
  801475:	83 e8 37             	sub    $0x37,%eax
  801478:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801481:	7d 19                	jge    80149c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801483:	ff 45 08             	incl   0x8(%ebp)
  801486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801489:	0f af 45 10          	imul   0x10(%ebp),%eax
  80148d:	89 c2                	mov    %eax,%edx
  80148f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801492:	01 d0                	add    %edx,%eax
  801494:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801497:	e9 7b ff ff ff       	jmp    801417 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80149c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80149d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a1:	74 08                	je     8014ab <strtol+0x134>
		*endptr = (char *) s;
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014af:	74 07                	je     8014b8 <strtol+0x141>
  8014b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b4:	f7 d8                	neg    %eax
  8014b6:	eb 03                	jmp    8014bb <strtol+0x144>
  8014b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <ltostr>:

void
ltostr(long value, char *str)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d5:	79 13                	jns    8014ea <ltostr+0x2d>
	{
		neg = 1;
  8014d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f2:	99                   	cltd   
  8014f3:	f7 f9                	idiv   %ecx
  8014f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fb:	8d 50 01             	lea    0x1(%eax),%edx
  8014fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801501:	89 c2                	mov    %eax,%edx
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	01 d0                	add    %edx,%eax
  801508:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80150b:	83 c2 30             	add    $0x30,%edx
  80150e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801510:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801513:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801518:	f7 e9                	imul   %ecx
  80151a:	c1 fa 02             	sar    $0x2,%edx
  80151d:	89 c8                	mov    %ecx,%eax
  80151f:	c1 f8 1f             	sar    $0x1f,%eax
  801522:	29 c2                	sub    %eax,%edx
  801524:	89 d0                	mov    %edx,%eax
  801526:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801531:	f7 e9                	imul   %ecx
  801533:	c1 fa 02             	sar    $0x2,%edx
  801536:	89 c8                	mov    %ecx,%eax
  801538:	c1 f8 1f             	sar    $0x1f,%eax
  80153b:	29 c2                	sub    %eax,%edx
  80153d:	89 d0                	mov    %edx,%eax
  80153f:	c1 e0 02             	shl    $0x2,%eax
  801542:	01 d0                	add    %edx,%eax
  801544:	01 c0                	add    %eax,%eax
  801546:	29 c1                	sub    %eax,%ecx
  801548:	89 ca                	mov    %ecx,%edx
  80154a:	85 d2                	test   %edx,%edx
  80154c:	75 9c                	jne    8014ea <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80154e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801555:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801558:	48                   	dec    %eax
  801559:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80155c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801560:	74 3d                	je     80159f <ltostr+0xe2>
		start = 1 ;
  801562:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801569:	eb 34                	jmp    80159f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80156b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 c2                	add    %eax,%edx
  801580:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	01 c8                	add    %ecx,%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80158c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	01 c2                	add    %eax,%edx
  801594:	8a 45 eb             	mov    -0x15(%ebp),%al
  801597:	88 02                	mov    %al,(%edx)
		start++ ;
  801599:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80159c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015a5:	7c c4                	jl     80156b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ad:	01 d0                	add    %edx,%eax
  8015af:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 54 fa ff ff       	call   801017 <strlen>
  8015c3:	83 c4 04             	add    $0x4,%esp
  8015c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	e8 46 fa ff ff       	call   801017 <strlen>
  8015d1:	83 c4 04             	add    $0x4,%esp
  8015d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e5:	eb 17                	jmp    8015fe <strcconcat+0x49>
		final[s] = str1[s] ;
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	01 c2                	add    %eax,%edx
  8015ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	01 c8                	add    %ecx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015fb:	ff 45 fc             	incl   -0x4(%ebp)
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801601:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801604:	7c e1                	jl     8015e7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801606:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80160d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801614:	eb 1f                	jmp    801635 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801616:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801619:	8d 50 01             	lea    0x1(%eax),%edx
  80161c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161f:	89 c2                	mov    %eax,%edx
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	01 c2                	add    %eax,%edx
  801626:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162c:	01 c8                	add    %ecx,%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801632:	ff 45 f8             	incl   -0x8(%ebp)
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801638:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80163b:	7c d9                	jl     801616 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80163d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	c6 00 00             	movb   $0x0,(%eax)
}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80164e:	8b 45 14             	mov    0x14(%ebp),%eax
  801651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801657:	8b 45 14             	mov    0x14(%ebp),%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166e:	eb 0c                	jmp    80167c <strsplit+0x31>
			*string++ = 0;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	8d 50 01             	lea    0x1(%eax),%edx
  801676:	89 55 08             	mov    %edx,0x8(%ebp)
  801679:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	84 c0                	test   %al,%al
  801683:	74 18                	je     80169d <strsplit+0x52>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	50                   	push   %eax
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	e8 13 fb ff ff       	call   8011a9 <strchr>
  801696:	83 c4 08             	add    $0x8,%esp
  801699:	85 c0                	test   %eax,%eax
  80169b:	75 d3                	jne    801670 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8a 00                	mov    (%eax),%al
  8016a2:	84 c0                	test   %al,%al
  8016a4:	74 5a                	je     801700 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	83 f8 0f             	cmp    $0xf,%eax
  8016ae:	75 07                	jne    8016b7 <strsplit+0x6c>
		{
			return 0;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 66                	jmp    80171d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ba:	8b 00                	mov    (%eax),%eax
  8016bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8016bf:	8b 55 14             	mov    0x14(%ebp),%edx
  8016c2:	89 0a                	mov    %ecx,(%edx)
  8016c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ce:	01 c2                	add    %eax,%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d5:	eb 03                	jmp    8016da <strsplit+0x8f>
			string++;
  8016d7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 8b                	je     80166e <strsplit+0x23>
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f be c0             	movsbl %al,%eax
  8016eb:	50                   	push   %eax
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	e8 b5 fa ff ff       	call   8011a9 <strchr>
  8016f4:	83 c4 08             	add    $0x8,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	74 dc                	je     8016d7 <strsplit+0x8c>
			string++;
	}
  8016fb:	e9 6e ff ff ff       	jmp    80166e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801700:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801701:	8b 45 14             	mov    0x14(%ebp),%eax
  801704:	8b 00                	mov    (%eax),%eax
  801706:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80170d:	8b 45 10             	mov    0x10(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801718:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801725:	a1 04 40 80 00       	mov    0x804004,%eax
  80172a:	85 c0                	test   %eax,%eax
  80172c:	74 1f                	je     80174d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80172e:	e8 1d 00 00 00       	call   801750 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	68 30 3d 80 00       	push   $0x803d30
  80173b:	e8 55 f2 ff ff       	call   800995 <cprintf>
  801740:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801743:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80174a:	00 00 00 
	}
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801756:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80175d:	00 00 00 
  801760:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801767:	00 00 00 
  80176a:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801771:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801774:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80177b:	00 00 00 
  80177e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801785:	00 00 00 
  801788:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80178f:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801792:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801799:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80179c:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017ab:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017b0:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8017b5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017bc:	a1 20 41 80 00       	mov    0x804120,%eax
  8017c1:	c1 e0 04             	shl    $0x4,%eax
  8017c4:	89 c2                	mov    %eax,%edx
  8017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c9:	01 d0                	add    %edx,%eax
  8017cb:	48                   	dec    %eax
  8017cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d7:	f7 75 f0             	divl   -0x10(%ebp)
  8017da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017dd:	29 d0                	sub    %edx,%eax
  8017df:	89 c2                	mov    %eax,%edx
  8017e1:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8017e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017f0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017f5:	83 ec 04             	sub    $0x4,%esp
  8017f8:	6a 06                	push   $0x6
  8017fa:	52                   	push   %edx
  8017fb:	50                   	push   %eax
  8017fc:	e8 71 05 00 00       	call   801d72 <sys_allocate_chunk>
  801801:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801804:	a1 20 41 80 00       	mov    0x804120,%eax
  801809:	83 ec 0c             	sub    $0xc,%esp
  80180c:	50                   	push   %eax
  80180d:	e8 e6 0b 00 00       	call   8023f8 <initialize_MemBlocksList>
  801812:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801815:	a1 48 41 80 00       	mov    0x804148,%eax
  80181a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  80181d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801821:	75 14                	jne    801837 <initialize_dyn_block_system+0xe7>
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	68 55 3d 80 00       	push   $0x803d55
  80182b:	6a 2b                	push   $0x2b
  80182d:	68 73 3d 80 00       	push   $0x803d73
  801832:	e8 aa ee ff ff       	call   8006e1 <_panic>
  801837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80183a:	8b 00                	mov    (%eax),%eax
  80183c:	85 c0                	test   %eax,%eax
  80183e:	74 10                	je     801850 <initialize_dyn_block_system+0x100>
  801840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801843:	8b 00                	mov    (%eax),%eax
  801845:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801848:	8b 52 04             	mov    0x4(%edx),%edx
  80184b:	89 50 04             	mov    %edx,0x4(%eax)
  80184e:	eb 0b                	jmp    80185b <initialize_dyn_block_system+0x10b>
  801850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801853:	8b 40 04             	mov    0x4(%eax),%eax
  801856:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80185b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80185e:	8b 40 04             	mov    0x4(%eax),%eax
  801861:	85 c0                	test   %eax,%eax
  801863:	74 0f                	je     801874 <initialize_dyn_block_system+0x124>
  801865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801868:	8b 40 04             	mov    0x4(%eax),%eax
  80186b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80186e:	8b 12                	mov    (%edx),%edx
  801870:	89 10                	mov    %edx,(%eax)
  801872:	eb 0a                	jmp    80187e <initialize_dyn_block_system+0x12e>
  801874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801877:	8b 00                	mov    (%eax),%eax
  801879:	a3 48 41 80 00       	mov    %eax,0x804148
  80187e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801881:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80188a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801891:	a1 54 41 80 00       	mov    0x804154,%eax
  801896:	48                   	dec    %eax
  801897:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  80189c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80189f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  8018a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018a9:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  8018b0:	83 ec 0c             	sub    $0xc,%esp
  8018b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018b6:	e8 d2 13 00 00       	call   802c8d <insert_sorted_with_merge_freeList>
  8018bb:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8018be:	90                   	nop
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018c7:	e8 53 fe ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  8018cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d0:	75 07                	jne    8018d9 <malloc+0x18>
  8018d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d7:	eb 61                	jmp    80193a <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8018d9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8018e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e6:	01 d0                	add    %edx,%eax
  8018e8:	48                   	dec    %eax
  8018e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f4:	f7 75 f4             	divl   -0xc(%ebp)
  8018f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fa:	29 d0                	sub    %edx,%eax
  8018fc:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018ff:	e8 3c 08 00 00       	call   802140 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801904:	85 c0                	test   %eax,%eax
  801906:	74 2d                	je     801935 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	ff 75 08             	pushl  0x8(%ebp)
  80190e:	e8 3e 0f 00 00       	call   802851 <alloc_block_FF>
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801919:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80191d:	74 16                	je     801935 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  80191f:	83 ec 0c             	sub    $0xc,%esp
  801922:	ff 75 ec             	pushl  -0x14(%ebp)
  801925:	e8 48 0c 00 00       	call   802572 <insert_sorted_allocList>
  80192a:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  80192d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801930:	8b 40 08             	mov    0x8(%eax),%eax
  801933:	eb 05                	jmp    80193a <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801935:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801950:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	83 ec 08             	sub    $0x8,%esp
  801959:	50                   	push   %eax
  80195a:	68 40 40 80 00       	push   $0x804040
  80195f:	e8 71 0b 00 00       	call   8024d5 <find_block>
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80196a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196d:	8b 50 0c             	mov    0xc(%eax),%edx
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	83 ec 08             	sub    $0x8,%esp
  801976:	52                   	push   %edx
  801977:	50                   	push   %eax
  801978:	e8 bd 03 00 00       	call   801d3a <sys_free_user_mem>
  80197d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801984:	75 14                	jne    80199a <free+0x5e>
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	68 55 3d 80 00       	push   $0x803d55
  80198e:	6a 71                	push   $0x71
  801990:	68 73 3d 80 00       	push   $0x803d73
  801995:	e8 47 ed ff ff       	call   8006e1 <_panic>
  80199a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199d:	8b 00                	mov    (%eax),%eax
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	74 10                	je     8019b3 <free+0x77>
  8019a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a6:	8b 00                	mov    (%eax),%eax
  8019a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ab:	8b 52 04             	mov    0x4(%edx),%edx
  8019ae:	89 50 04             	mov    %edx,0x4(%eax)
  8019b1:	eb 0b                	jmp    8019be <free+0x82>
  8019b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b6:	8b 40 04             	mov    0x4(%eax),%eax
  8019b9:	a3 44 40 80 00       	mov    %eax,0x804044
  8019be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c1:	8b 40 04             	mov    0x4(%eax),%eax
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	74 0f                	je     8019d7 <free+0x9b>
  8019c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cb:	8b 40 04             	mov    0x4(%eax),%eax
  8019ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019d1:	8b 12                	mov    (%edx),%edx
  8019d3:	89 10                	mov    %edx,(%eax)
  8019d5:	eb 0a                	jmp    8019e1 <free+0xa5>
  8019d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019da:	8b 00                	mov    (%eax),%eax
  8019dc:	a3 40 40 80 00       	mov    %eax,0x804040
  8019e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8019ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019f4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8019f9:	48                   	dec    %eax
  8019fa:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8019ff:	83 ec 0c             	sub    $0xc,%esp
  801a02:	ff 75 f0             	pushl  -0x10(%ebp)
  801a05:	e8 83 12 00 00       	call   802c8d <insert_sorted_with_merge_freeList>
  801a0a:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801a0d:	90                   	nop
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 28             	sub    $0x28,%esp
  801a16:	8b 45 10             	mov    0x10(%ebp),%eax
  801a19:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a1c:	e8 fe fc ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801a21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a25:	75 0a                	jne    801a31 <smalloc+0x21>
  801a27:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2c:	e9 86 00 00 00       	jmp    801ab7 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801a31:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3e:	01 d0                	add    %edx,%eax
  801a40:	48                   	dec    %eax
  801a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a47:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4c:	f7 75 f4             	divl   -0xc(%ebp)
  801a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a52:	29 d0                	sub    %edx,%eax
  801a54:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a57:	e8 e4 06 00 00       	call   802140 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	74 52                	je     801ab2 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801a60:	83 ec 0c             	sub    $0xc,%esp
  801a63:	ff 75 0c             	pushl  0xc(%ebp)
  801a66:	e8 e6 0d 00 00       	call   802851 <alloc_block_FF>
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801a71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a75:	75 07                	jne    801a7e <smalloc+0x6e>
			return NULL ;
  801a77:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7c:	eb 39                	jmp    801ab7 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a81:	8b 40 08             	mov    0x8(%eax),%eax
  801a84:	89 c2                	mov    %eax,%edx
  801a86:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801a8a:	52                   	push   %edx
  801a8b:	50                   	push   %eax
  801a8c:	ff 75 0c             	pushl  0xc(%ebp)
  801a8f:	ff 75 08             	pushl  0x8(%ebp)
  801a92:	e8 2e 04 00 00       	call   801ec5 <sys_createSharedObject>
  801a97:	83 c4 10             	add    $0x10,%esp
  801a9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801a9d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801aa1:	79 07                	jns    801aaa <smalloc+0x9a>
			return (void*)NULL ;
  801aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa8:	eb 0d                	jmp    801ab7 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801aaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aad:	8b 40 08             	mov    0x8(%eax),%eax
  801ab0:	eb 05                	jmp    801ab7 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801ab2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801abf:	e8 5b fc ff ff       	call   80171f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ac4:	83 ec 08             	sub    $0x8,%esp
  801ac7:	ff 75 0c             	pushl  0xc(%ebp)
  801aca:	ff 75 08             	pushl  0x8(%ebp)
  801acd:	e8 1d 04 00 00       	call   801eef <sys_getSizeOfSharedObject>
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801ad8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801adc:	75 0a                	jne    801ae8 <sget+0x2f>
			return NULL ;
  801ade:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae3:	e9 83 00 00 00       	jmp    801b6b <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801ae8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af5:	01 d0                	add    %edx,%eax
  801af7:	48                   	dec    %eax
  801af8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801afe:	ba 00 00 00 00       	mov    $0x0,%edx
  801b03:	f7 75 f0             	divl   -0x10(%ebp)
  801b06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b09:	29 d0                	sub    %edx,%eax
  801b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b0e:	e8 2d 06 00 00       	call   802140 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b13:	85 c0                	test   %eax,%eax
  801b15:	74 4f                	je     801b66 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1a:	83 ec 0c             	sub    $0xc,%esp
  801b1d:	50                   	push   %eax
  801b1e:	e8 2e 0d 00 00       	call   802851 <alloc_block_FF>
  801b23:	83 c4 10             	add    $0x10,%esp
  801b26:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801b29:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b2d:	75 07                	jne    801b36 <sget+0x7d>
					return (void*)NULL ;
  801b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b34:	eb 35                	jmp    801b6b <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801b36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b39:	8b 40 08             	mov    0x8(%eax),%eax
  801b3c:	83 ec 04             	sub    $0x4,%esp
  801b3f:	50                   	push   %eax
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	e8 c1 03 00 00       	call   801f0c <sys_getSharedObject>
  801b4b:	83 c4 10             	add    $0x10,%esp
  801b4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801b51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b55:	79 07                	jns    801b5e <sget+0xa5>
				return (void*)NULL ;
  801b57:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5c:	eb 0d                	jmp    801b6b <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b61:	8b 40 08             	mov    0x8(%eax),%eax
  801b64:	eb 05                	jmp    801b6b <sget+0xb2>


		}
	return (void*)NULL ;
  801b66:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b73:	e8 a7 fb ff ff       	call   80171f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b78:	83 ec 04             	sub    $0x4,%esp
  801b7b:	68 80 3d 80 00       	push   $0x803d80
  801b80:	68 f9 00 00 00       	push   $0xf9
  801b85:	68 73 3d 80 00       	push   $0x803d73
  801b8a:	e8 52 eb ff ff       	call   8006e1 <_panic>

00801b8f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	68 a8 3d 80 00       	push   $0x803da8
  801b9d:	68 0d 01 00 00       	push   $0x10d
  801ba2:	68 73 3d 80 00       	push   $0x803d73
  801ba7:	e8 35 eb ff ff       	call   8006e1 <_panic>

00801bac <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bb2:	83 ec 04             	sub    $0x4,%esp
  801bb5:	68 cc 3d 80 00       	push   $0x803dcc
  801bba:	68 18 01 00 00       	push   $0x118
  801bbf:	68 73 3d 80 00       	push   $0x803d73
  801bc4:	e8 18 eb ff ff       	call   8006e1 <_panic>

00801bc9 <shrink>:

}
void shrink(uint32 newSize)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bcf:	83 ec 04             	sub    $0x4,%esp
  801bd2:	68 cc 3d 80 00       	push   $0x803dcc
  801bd7:	68 1d 01 00 00       	push   $0x11d
  801bdc:	68 73 3d 80 00       	push   $0x803d73
  801be1:	e8 fb ea ff ff       	call   8006e1 <_panic>

00801be6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	68 cc 3d 80 00       	push   $0x803dcc
  801bf4:	68 22 01 00 00       	push   $0x122
  801bf9:	68 73 3d 80 00       	push   $0x803d73
  801bfe:	e8 de ea ff ff       	call   8006e1 <_panic>

00801c03 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	57                   	push   %edi
  801c07:	56                   	push   %esi
  801c08:	53                   	push   %ebx
  801c09:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c12:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c15:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c18:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c1b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c1e:	cd 30                	int    $0x30
  801c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	5b                   	pop    %ebx
  801c2a:	5e                   	pop    %esi
  801c2b:	5f                   	pop    %edi
  801c2c:	5d                   	pop    %ebp
  801c2d:	c3                   	ret    

00801c2e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 04             	sub    $0x4,%esp
  801c34:	8b 45 10             	mov    0x10(%ebp),%eax
  801c37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c3a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	52                   	push   %edx
  801c46:	ff 75 0c             	pushl  0xc(%ebp)
  801c49:	50                   	push   %eax
  801c4a:	6a 00                	push   $0x0
  801c4c:	e8 b2 ff ff ff       	call   801c03 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	90                   	nop
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 01                	push   $0x1
  801c66:	e8 98 ff ff ff       	call   801c03 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	52                   	push   %edx
  801c80:	50                   	push   %eax
  801c81:	6a 05                	push   $0x5
  801c83:	e8 7b ff ff ff       	call   801c03 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	56                   	push   %esi
  801c91:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c92:	8b 75 18             	mov    0x18(%ebp),%esi
  801c95:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	56                   	push   %esi
  801ca2:	53                   	push   %ebx
  801ca3:	51                   	push   %ecx
  801ca4:	52                   	push   %edx
  801ca5:	50                   	push   %eax
  801ca6:	6a 06                	push   $0x6
  801ca8:	e8 56 ff ff ff       	call   801c03 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5e                   	pop    %esi
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    

00801cb7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	52                   	push   %edx
  801cc7:	50                   	push   %eax
  801cc8:	6a 07                	push   $0x7
  801cca:	e8 34 ff ff ff       	call   801c03 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	ff 75 0c             	pushl  0xc(%ebp)
  801ce0:	ff 75 08             	pushl  0x8(%ebp)
  801ce3:	6a 08                	push   $0x8
  801ce5:	e8 19 ff ff ff       	call   801c03 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 09                	push   $0x9
  801cfe:	e8 00 ff ff ff       	call   801c03 <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 0a                	push   $0xa
  801d17:	e8 e7 fe ff ff       	call   801c03 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 0b                	push   $0xb
  801d30:	e8 ce fe ff ff       	call   801c03 <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	ff 75 0c             	pushl  0xc(%ebp)
  801d46:	ff 75 08             	pushl  0x8(%ebp)
  801d49:	6a 0f                	push   $0xf
  801d4b:	e8 b3 fe ff ff       	call   801c03 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
	return;
  801d53:	90                   	nop
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	ff 75 08             	pushl  0x8(%ebp)
  801d65:	6a 10                	push   $0x10
  801d67:	e8 97 fe ff ff       	call   801c03 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6f:	90                   	nop
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	ff 75 10             	pushl  0x10(%ebp)
  801d7c:	ff 75 0c             	pushl  0xc(%ebp)
  801d7f:	ff 75 08             	pushl  0x8(%ebp)
  801d82:	6a 11                	push   $0x11
  801d84:	e8 7a fe ff ff       	call   801c03 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8c:	90                   	nop
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 0c                	push   $0xc
  801d9e:	e8 60 fe ff ff       	call   801c03 <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	ff 75 08             	pushl  0x8(%ebp)
  801db6:	6a 0d                	push   $0xd
  801db8:	e8 46 fe ff ff       	call   801c03 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 0e                	push   $0xe
  801dd1:	e8 2d fe ff ff       	call   801c03 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	90                   	nop
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 13                	push   $0x13
  801deb:	e8 13 fe ff ff       	call   801c03 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	90                   	nop
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 14                	push   $0x14
  801e05:	e8 f9 fd ff ff       	call   801c03 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
}
  801e0d:	90                   	nop
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 04             	sub    $0x4,%esp
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e1c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	50                   	push   %eax
  801e29:	6a 15                	push   $0x15
  801e2b:	e8 d3 fd ff ff       	call   801c03 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	90                   	nop
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 16                	push   $0x16
  801e45:	e8 b9 fd ff ff       	call   801c03 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	90                   	nop
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e53:	8b 45 08             	mov    0x8(%ebp),%eax
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	ff 75 0c             	pushl  0xc(%ebp)
  801e5f:	50                   	push   %eax
  801e60:	6a 17                	push   $0x17
  801e62:	e8 9c fd ff ff       	call   801c03 <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	52                   	push   %edx
  801e7c:	50                   	push   %eax
  801e7d:	6a 1a                	push   $0x1a
  801e7f:	e8 7f fd ff ff       	call   801c03 <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	52                   	push   %edx
  801e99:	50                   	push   %eax
  801e9a:	6a 18                	push   $0x18
  801e9c:	e8 62 fd ff ff       	call   801c03 <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	90                   	nop
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	52                   	push   %edx
  801eb7:	50                   	push   %eax
  801eb8:	6a 19                	push   $0x19
  801eba:	e8 44 fd ff ff       	call   801c03 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
}
  801ec2:	90                   	nop
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 04             	sub    $0x4,%esp
  801ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ece:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ed1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ed4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	6a 00                	push   $0x0
  801edd:	51                   	push   %ecx
  801ede:	52                   	push   %edx
  801edf:	ff 75 0c             	pushl  0xc(%ebp)
  801ee2:	50                   	push   %eax
  801ee3:	6a 1b                	push   $0x1b
  801ee5:	e8 19 fd ff ff       	call   801c03 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ef2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	52                   	push   %edx
  801eff:	50                   	push   %eax
  801f00:	6a 1c                	push   $0x1c
  801f02:	e8 fc fc ff ff       	call   801c03 <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
}
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	51                   	push   %ecx
  801f1d:	52                   	push   %edx
  801f1e:	50                   	push   %eax
  801f1f:	6a 1d                	push   $0x1d
  801f21:	e8 dd fc ff ff       	call   801c03 <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	52                   	push   %edx
  801f3b:	50                   	push   %eax
  801f3c:	6a 1e                	push   $0x1e
  801f3e:	e8 c0 fc ff ff       	call   801c03 <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 1f                	push   $0x1f
  801f57:	e8 a7 fc ff ff       	call   801c03 <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	6a 00                	push   $0x0
  801f69:	ff 75 14             	pushl  0x14(%ebp)
  801f6c:	ff 75 10             	pushl  0x10(%ebp)
  801f6f:	ff 75 0c             	pushl  0xc(%ebp)
  801f72:	50                   	push   %eax
  801f73:	6a 20                	push   $0x20
  801f75:	e8 89 fc ff ff       	call   801c03 <syscall>
  801f7a:	83 c4 18             	add    $0x18,%esp
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	50                   	push   %eax
  801f8e:	6a 21                	push   $0x21
  801f90:	e8 6e fc ff ff       	call   801c03 <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	90                   	nop
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	50                   	push   %eax
  801faa:	6a 22                	push   $0x22
  801fac:	e8 52 fc ff ff       	call   801c03 <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 02                	push   $0x2
  801fc5:	e8 39 fc ff ff       	call   801c03 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 03                	push   $0x3
  801fde:	e8 20 fc ff ff       	call   801c03 <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 04                	push   $0x4
  801ff7:	e8 07 fc ff ff       	call   801c03 <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_exit_env>:


void sys_exit_env(void)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 23                	push   $0x23
  802010:	e8 ee fb ff ff       	call   801c03 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	90                   	nop
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802021:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802024:	8d 50 04             	lea    0x4(%eax),%edx
  802027:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	52                   	push   %edx
  802031:	50                   	push   %eax
  802032:	6a 24                	push   $0x24
  802034:	e8 ca fb ff ff       	call   801c03 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
	return result;
  80203c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80203f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802042:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802045:	89 01                	mov    %eax,(%ecx)
  802047:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	c9                   	leave  
  80204e:	c2 04 00             	ret    $0x4

00802051 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	ff 75 10             	pushl  0x10(%ebp)
  80205b:	ff 75 0c             	pushl  0xc(%ebp)
  80205e:	ff 75 08             	pushl  0x8(%ebp)
  802061:	6a 12                	push   $0x12
  802063:	e8 9b fb ff ff       	call   801c03 <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
	return ;
  80206b:	90                   	nop
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <sys_rcr2>:
uint32 sys_rcr2()
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 25                	push   $0x25
  80207d:	e8 81 fb ff ff       	call   801c03 <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802093:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	50                   	push   %eax
  8020a0:	6a 26                	push   $0x26
  8020a2:	e8 5c fb ff ff       	call   801c03 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020aa:	90                   	nop
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <rsttst>:
void rsttst()
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 28                	push   $0x28
  8020bc:	e8 42 fb ff ff       	call   801c03 <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c4:	90                   	nop
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 04             	sub    $0x4,%esp
  8020cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020d3:	8b 55 18             	mov    0x18(%ebp),%edx
  8020d6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020da:	52                   	push   %edx
  8020db:	50                   	push   %eax
  8020dc:	ff 75 10             	pushl  0x10(%ebp)
  8020df:	ff 75 0c             	pushl  0xc(%ebp)
  8020e2:	ff 75 08             	pushl  0x8(%ebp)
  8020e5:	6a 27                	push   $0x27
  8020e7:	e8 17 fb ff ff       	call   801c03 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ef:	90                   	nop
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <chktst>:
void chktst(uint32 n)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	ff 75 08             	pushl  0x8(%ebp)
  802100:	6a 29                	push   $0x29
  802102:	e8 fc fa ff ff       	call   801c03 <syscall>
  802107:	83 c4 18             	add    $0x18,%esp
	return ;
  80210a:	90                   	nop
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <inctst>:

void inctst()
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 2a                	push   $0x2a
  80211c:	e8 e2 fa ff ff       	call   801c03 <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
	return ;
  802124:	90                   	nop
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <gettst>:
uint32 gettst()
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 2b                	push   $0x2b
  802136:	e8 c8 fa ff ff       	call   801c03 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 2c                	push   $0x2c
  802152:	e8 ac fa ff ff       	call   801c03 <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
  80215a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80215d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802161:	75 07                	jne    80216a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802163:	b8 01 00 00 00       	mov    $0x1,%eax
  802168:	eb 05                	jmp    80216f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80216a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 2c                	push   $0x2c
  802183:	e8 7b fa ff ff       	call   801c03 <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
  80218b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80218e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802192:	75 07                	jne    80219b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802194:	b8 01 00 00 00       	mov    $0x1,%eax
  802199:	eb 05                	jmp    8021a0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80219b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 2c                	push   $0x2c
  8021b4:	e8 4a fa ff ff       	call   801c03 <syscall>
  8021b9:	83 c4 18             	add    $0x18,%esp
  8021bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021bf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021c3:	75 07                	jne    8021cc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ca:	eb 05                	jmp    8021d1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 2c                	push   $0x2c
  8021e5:	e8 19 fa ff ff       	call   801c03 <syscall>
  8021ea:	83 c4 18             	add    $0x18,%esp
  8021ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021f0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021f4:	75 07                	jne    8021fd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fb:	eb 05                	jmp    802202 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	ff 75 08             	pushl  0x8(%ebp)
  802212:	6a 2d                	push   $0x2d
  802214:	e8 ea f9 ff ff       	call   801c03 <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
	return ;
  80221c:	90                   	nop
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802223:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802226:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222c:	8b 45 08             	mov    0x8(%ebp),%eax
  80222f:	6a 00                	push   $0x0
  802231:	53                   	push   %ebx
  802232:	51                   	push   %ecx
  802233:	52                   	push   %edx
  802234:	50                   	push   %eax
  802235:	6a 2e                	push   $0x2e
  802237:	e8 c7 f9 ff ff       	call   801c03 <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
}
  80223f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	52                   	push   %edx
  802254:	50                   	push   %eax
  802255:	6a 2f                	push   $0x2f
  802257:	e8 a7 f9 ff ff       	call   801c03 <syscall>
  80225c:	83 c4 18             	add    $0x18,%esp
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802267:	83 ec 0c             	sub    $0xc,%esp
  80226a:	68 dc 3d 80 00       	push   $0x803ddc
  80226f:	e8 21 e7 ff ff       	call   800995 <cprintf>
  802274:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802277:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80227e:	83 ec 0c             	sub    $0xc,%esp
  802281:	68 08 3e 80 00       	push   $0x803e08
  802286:	e8 0a e7 ff ff       	call   800995 <cprintf>
  80228b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80228e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802292:	a1 38 41 80 00       	mov    0x804138,%eax
  802297:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80229a:	eb 56                	jmp    8022f2 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80229c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022a0:	74 1c                	je     8022be <print_mem_block_lists+0x5d>
  8022a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a5:	8b 50 08             	mov    0x8(%eax),%edx
  8022a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ab:	8b 48 08             	mov    0x8(%eax),%ecx
  8022ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b4:	01 c8                	add    %ecx,%eax
  8022b6:	39 c2                	cmp    %eax,%edx
  8022b8:	73 04                	jae    8022be <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022ba:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	8b 50 08             	mov    0x8(%eax),%edx
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ca:	01 c2                	add    %eax,%edx
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 40 08             	mov    0x8(%eax),%eax
  8022d2:	83 ec 04             	sub    $0x4,%esp
  8022d5:	52                   	push   %edx
  8022d6:	50                   	push   %eax
  8022d7:	68 1d 3e 80 00       	push   $0x803e1d
  8022dc:	e8 b4 e6 ff ff       	call   800995 <cprintf>
  8022e1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022ea:	a1 40 41 80 00       	mov    0x804140,%eax
  8022ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f6:	74 07                	je     8022ff <print_mem_block_lists+0x9e>
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	8b 00                	mov    (%eax),%eax
  8022fd:	eb 05                	jmp    802304 <print_mem_block_lists+0xa3>
  8022ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802304:	a3 40 41 80 00       	mov    %eax,0x804140
  802309:	a1 40 41 80 00       	mov    0x804140,%eax
  80230e:	85 c0                	test   %eax,%eax
  802310:	75 8a                	jne    80229c <print_mem_block_lists+0x3b>
  802312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802316:	75 84                	jne    80229c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802318:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80231c:	75 10                	jne    80232e <print_mem_block_lists+0xcd>
  80231e:	83 ec 0c             	sub    $0xc,%esp
  802321:	68 2c 3e 80 00       	push   $0x803e2c
  802326:	e8 6a e6 ff ff       	call   800995 <cprintf>
  80232b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80232e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802335:	83 ec 0c             	sub    $0xc,%esp
  802338:	68 50 3e 80 00       	push   $0x803e50
  80233d:	e8 53 e6 ff ff       	call   800995 <cprintf>
  802342:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802345:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802349:	a1 40 40 80 00       	mov    0x804040,%eax
  80234e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802351:	eb 56                	jmp    8023a9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802353:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802357:	74 1c                	je     802375 <print_mem_block_lists+0x114>
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 50 08             	mov    0x8(%eax),%edx
  80235f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802362:	8b 48 08             	mov    0x8(%eax),%ecx
  802365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802368:	8b 40 0c             	mov    0xc(%eax),%eax
  80236b:	01 c8                	add    %ecx,%eax
  80236d:	39 c2                	cmp    %eax,%edx
  80236f:	73 04                	jae    802375 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802371:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802378:	8b 50 08             	mov    0x8(%eax),%edx
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 40 0c             	mov    0xc(%eax),%eax
  802381:	01 c2                	add    %eax,%edx
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 40 08             	mov    0x8(%eax),%eax
  802389:	83 ec 04             	sub    $0x4,%esp
  80238c:	52                   	push   %edx
  80238d:	50                   	push   %eax
  80238e:	68 1d 3e 80 00       	push   $0x803e1d
  802393:	e8 fd e5 ff ff       	call   800995 <cprintf>
  802398:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023a1:	a1 48 40 80 00       	mov    0x804048,%eax
  8023a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ad:	74 07                	je     8023b6 <print_mem_block_lists+0x155>
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 00                	mov    (%eax),%eax
  8023b4:	eb 05                	jmp    8023bb <print_mem_block_lists+0x15a>
  8023b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bb:	a3 48 40 80 00       	mov    %eax,0x804048
  8023c0:	a1 48 40 80 00       	mov    0x804048,%eax
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	75 8a                	jne    802353 <print_mem_block_lists+0xf2>
  8023c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cd:	75 84                	jne    802353 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8023cf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023d3:	75 10                	jne    8023e5 <print_mem_block_lists+0x184>
  8023d5:	83 ec 0c             	sub    $0xc,%esp
  8023d8:	68 68 3e 80 00       	push   $0x803e68
  8023dd:	e8 b3 e5 ff ff       	call   800995 <cprintf>
  8023e2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8023e5:	83 ec 0c             	sub    $0xc,%esp
  8023e8:	68 dc 3d 80 00       	push   $0x803ddc
  8023ed:	e8 a3 e5 ff ff       	call   800995 <cprintf>
  8023f2:	83 c4 10             	add    $0x10,%esp

}
  8023f5:	90                   	nop
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8023fe:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802405:	00 00 00 
  802408:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80240f:	00 00 00 
  802412:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802419:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80241c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802423:	e9 9e 00 00 00       	jmp    8024c6 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802428:	a1 50 40 80 00       	mov    0x804050,%eax
  80242d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802430:	c1 e2 04             	shl    $0x4,%edx
  802433:	01 d0                	add    %edx,%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	75 14                	jne    80244d <initialize_MemBlocksList+0x55>
  802439:	83 ec 04             	sub    $0x4,%esp
  80243c:	68 90 3e 80 00       	push   $0x803e90
  802441:	6a 43                	push   $0x43
  802443:	68 b3 3e 80 00       	push   $0x803eb3
  802448:	e8 94 e2 ff ff       	call   8006e1 <_panic>
  80244d:	a1 50 40 80 00       	mov    0x804050,%eax
  802452:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802455:	c1 e2 04             	shl    $0x4,%edx
  802458:	01 d0                	add    %edx,%eax
  80245a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802460:	89 10                	mov    %edx,(%eax)
  802462:	8b 00                	mov    (%eax),%eax
  802464:	85 c0                	test   %eax,%eax
  802466:	74 18                	je     802480 <initialize_MemBlocksList+0x88>
  802468:	a1 48 41 80 00       	mov    0x804148,%eax
  80246d:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802473:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802476:	c1 e1 04             	shl    $0x4,%ecx
  802479:	01 ca                	add    %ecx,%edx
  80247b:	89 50 04             	mov    %edx,0x4(%eax)
  80247e:	eb 12                	jmp    802492 <initialize_MemBlocksList+0x9a>
  802480:	a1 50 40 80 00       	mov    0x804050,%eax
  802485:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802488:	c1 e2 04             	shl    $0x4,%edx
  80248b:	01 d0                	add    %edx,%eax
  80248d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802492:	a1 50 40 80 00       	mov    0x804050,%eax
  802497:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249a:	c1 e2 04             	shl    $0x4,%edx
  80249d:	01 d0                	add    %edx,%eax
  80249f:	a3 48 41 80 00       	mov    %eax,0x804148
  8024a4:	a1 50 40 80 00       	mov    0x804050,%eax
  8024a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ac:	c1 e2 04             	shl    $0x4,%edx
  8024af:	01 d0                	add    %edx,%eax
  8024b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b8:	a1 54 41 80 00       	mov    0x804154,%eax
  8024bd:	40                   	inc    %eax
  8024be:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8024c3:	ff 45 f4             	incl   -0xc(%ebp)
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024cc:	0f 82 56 ff ff ff    	jb     802428 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8024d2:	90                   	nop
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8024db:	a1 38 41 80 00       	mov    0x804138,%eax
  8024e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024e3:	eb 18                	jmp    8024fd <find_block+0x28>
	{
		if (ele->sva==va)
  8024e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024e8:	8b 40 08             	mov    0x8(%eax),%eax
  8024eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024ee:	75 05                	jne    8024f5 <find_block+0x20>
			return ele;
  8024f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024f3:	eb 7b                	jmp    802570 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8024f5:	a1 40 41 80 00       	mov    0x804140,%eax
  8024fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802501:	74 07                	je     80250a <find_block+0x35>
  802503:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802506:	8b 00                	mov    (%eax),%eax
  802508:	eb 05                	jmp    80250f <find_block+0x3a>
  80250a:	b8 00 00 00 00       	mov    $0x0,%eax
  80250f:	a3 40 41 80 00       	mov    %eax,0x804140
  802514:	a1 40 41 80 00       	mov    0x804140,%eax
  802519:	85 c0                	test   %eax,%eax
  80251b:	75 c8                	jne    8024e5 <find_block+0x10>
  80251d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802521:	75 c2                	jne    8024e5 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802523:	a1 40 40 80 00       	mov    0x804040,%eax
  802528:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80252b:	eb 18                	jmp    802545 <find_block+0x70>
	{
		if (ele->sva==va)
  80252d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802530:	8b 40 08             	mov    0x8(%eax),%eax
  802533:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802536:	75 05                	jne    80253d <find_block+0x68>
					return ele;
  802538:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80253b:	eb 33                	jmp    802570 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80253d:	a1 48 40 80 00       	mov    0x804048,%eax
  802542:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802545:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802549:	74 07                	je     802552 <find_block+0x7d>
  80254b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	eb 05                	jmp    802557 <find_block+0x82>
  802552:	b8 00 00 00 00       	mov    $0x0,%eax
  802557:	a3 48 40 80 00       	mov    %eax,0x804048
  80255c:	a1 48 40 80 00       	mov    0x804048,%eax
  802561:	85 c0                	test   %eax,%eax
  802563:	75 c8                	jne    80252d <find_block+0x58>
  802565:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802569:	75 c2                	jne    80252d <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80256b:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802578:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80257d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802580:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802584:	75 62                	jne    8025e8 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802586:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80258a:	75 14                	jne    8025a0 <insert_sorted_allocList+0x2e>
  80258c:	83 ec 04             	sub    $0x4,%esp
  80258f:	68 90 3e 80 00       	push   $0x803e90
  802594:	6a 69                	push   $0x69
  802596:	68 b3 3e 80 00       	push   $0x803eb3
  80259b:	e8 41 e1 ff ff       	call   8006e1 <_panic>
  8025a0:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8025a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a9:	89 10                	mov    %edx,(%eax)
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	74 0d                	je     8025c1 <insert_sorted_allocList+0x4f>
  8025b4:	a1 40 40 80 00       	mov    0x804040,%eax
  8025b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025bc:	89 50 04             	mov    %edx,0x4(%eax)
  8025bf:	eb 08                	jmp    8025c9 <insert_sorted_allocList+0x57>
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	a3 44 40 80 00       	mov    %eax,0x804044
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	a3 40 40 80 00       	mov    %eax,0x804040
  8025d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025db:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8025e0:	40                   	inc    %eax
  8025e1:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8025e6:	eb 72                	jmp    80265a <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8025e8:	a1 40 40 80 00       	mov    0x804040,%eax
  8025ed:	8b 50 08             	mov    0x8(%eax),%edx
  8025f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f3:	8b 40 08             	mov    0x8(%eax),%eax
  8025f6:	39 c2                	cmp    %eax,%edx
  8025f8:	76 60                	jbe    80265a <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8025fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025fe:	75 14                	jne    802614 <insert_sorted_allocList+0xa2>
  802600:	83 ec 04             	sub    $0x4,%esp
  802603:	68 90 3e 80 00       	push   $0x803e90
  802608:	6a 6d                	push   $0x6d
  80260a:	68 b3 3e 80 00       	push   $0x803eb3
  80260f:	e8 cd e0 ff ff       	call   8006e1 <_panic>
  802614:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80261a:	8b 45 08             	mov    0x8(%ebp),%eax
  80261d:	89 10                	mov    %edx,(%eax)
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	85 c0                	test   %eax,%eax
  802626:	74 0d                	je     802635 <insert_sorted_allocList+0xc3>
  802628:	a1 40 40 80 00       	mov    0x804040,%eax
  80262d:	8b 55 08             	mov    0x8(%ebp),%edx
  802630:	89 50 04             	mov    %edx,0x4(%eax)
  802633:	eb 08                	jmp    80263d <insert_sorted_allocList+0xcb>
  802635:	8b 45 08             	mov    0x8(%ebp),%eax
  802638:	a3 44 40 80 00       	mov    %eax,0x804044
  80263d:	8b 45 08             	mov    0x8(%ebp),%eax
  802640:	a3 40 40 80 00       	mov    %eax,0x804040
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802654:	40                   	inc    %eax
  802655:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80265a:	a1 40 40 80 00       	mov    0x804040,%eax
  80265f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802662:	e9 b9 01 00 00       	jmp    802820 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802667:	8b 45 08             	mov    0x8(%ebp),%eax
  80266a:	8b 50 08             	mov    0x8(%eax),%edx
  80266d:	a1 40 40 80 00       	mov    0x804040,%eax
  802672:	8b 40 08             	mov    0x8(%eax),%eax
  802675:	39 c2                	cmp    %eax,%edx
  802677:	76 7c                	jbe    8026f5 <insert_sorted_allocList+0x183>
  802679:	8b 45 08             	mov    0x8(%ebp),%eax
  80267c:	8b 50 08             	mov    0x8(%eax),%edx
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 40 08             	mov    0x8(%eax),%eax
  802685:	39 c2                	cmp    %eax,%edx
  802687:	73 6c                	jae    8026f5 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802689:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268d:	74 06                	je     802695 <insert_sorted_allocList+0x123>
  80268f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802693:	75 14                	jne    8026a9 <insert_sorted_allocList+0x137>
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	68 cc 3e 80 00       	push   $0x803ecc
  80269d:	6a 75                	push   $0x75
  80269f:	68 b3 3e 80 00       	push   $0x803eb3
  8026a4:	e8 38 e0 ff ff       	call   8006e1 <_panic>
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 50 04             	mov    0x4(%eax),%edx
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	89 50 04             	mov    %edx,0x4(%eax)
  8026b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bb:	89 10                	mov    %edx,(%eax)
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 40 04             	mov    0x4(%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	74 0d                	je     8026d4 <insert_sorted_allocList+0x162>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d0:	89 10                	mov    %edx,(%eax)
  8026d2:	eb 08                	jmp    8026dc <insert_sorted_allocList+0x16a>
  8026d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d7:	a3 40 40 80 00       	mov    %eax,0x804040
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e2:	89 50 04             	mov    %edx,0x4(%eax)
  8026e5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8026ea:	40                   	inc    %eax
  8026eb:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8026f0:	e9 59 01 00 00       	jmp    80284e <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8026f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f8:	8b 50 08             	mov    0x8(%eax),%edx
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 40 08             	mov    0x8(%eax),%eax
  802701:	39 c2                	cmp    %eax,%edx
  802703:	0f 86 98 00 00 00    	jbe    8027a1 <insert_sorted_allocList+0x22f>
  802709:	8b 45 08             	mov    0x8(%ebp),%eax
  80270c:	8b 50 08             	mov    0x8(%eax),%edx
  80270f:	a1 44 40 80 00       	mov    0x804044,%eax
  802714:	8b 40 08             	mov    0x8(%eax),%eax
  802717:	39 c2                	cmp    %eax,%edx
  802719:	0f 83 82 00 00 00    	jae    8027a1 <insert_sorted_allocList+0x22f>
  80271f:	8b 45 08             	mov    0x8(%ebp),%eax
  802722:	8b 50 08             	mov    0x8(%eax),%edx
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 00                	mov    (%eax),%eax
  80272a:	8b 40 08             	mov    0x8(%eax),%eax
  80272d:	39 c2                	cmp    %eax,%edx
  80272f:	73 70                	jae    8027a1 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802735:	74 06                	je     80273d <insert_sorted_allocList+0x1cb>
  802737:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80273b:	75 14                	jne    802751 <insert_sorted_allocList+0x1df>
  80273d:	83 ec 04             	sub    $0x4,%esp
  802740:	68 04 3f 80 00       	push   $0x803f04
  802745:	6a 7c                	push   $0x7c
  802747:	68 b3 3e 80 00       	push   $0x803eb3
  80274c:	e8 90 df ff ff       	call   8006e1 <_panic>
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 10                	mov    (%eax),%edx
  802756:	8b 45 08             	mov    0x8(%ebp),%eax
  802759:	89 10                	mov    %edx,(%eax)
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	8b 00                	mov    (%eax),%eax
  802760:	85 c0                	test   %eax,%eax
  802762:	74 0b                	je     80276f <insert_sorted_allocList+0x1fd>
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 00                	mov    (%eax),%eax
  802769:	8b 55 08             	mov    0x8(%ebp),%edx
  80276c:	89 50 04             	mov    %edx,0x4(%eax)
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 55 08             	mov    0x8(%ebp),%edx
  802775:	89 10                	mov    %edx,(%eax)
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277d:	89 50 04             	mov    %edx,0x4(%eax)
  802780:	8b 45 08             	mov    0x8(%ebp),%eax
  802783:	8b 00                	mov    (%eax),%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	75 08                	jne    802791 <insert_sorted_allocList+0x21f>
  802789:	8b 45 08             	mov    0x8(%ebp),%eax
  80278c:	a3 44 40 80 00       	mov    %eax,0x804044
  802791:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802796:	40                   	inc    %eax
  802797:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80279c:	e9 ad 00 00 00       	jmp    80284e <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	8b 50 08             	mov    0x8(%eax),%edx
  8027a7:	a1 44 40 80 00       	mov    0x804044,%eax
  8027ac:	8b 40 08             	mov    0x8(%eax),%eax
  8027af:	39 c2                	cmp    %eax,%edx
  8027b1:	76 65                	jbe    802818 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8027b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027b7:	75 17                	jne    8027d0 <insert_sorted_allocList+0x25e>
  8027b9:	83 ec 04             	sub    $0x4,%esp
  8027bc:	68 38 3f 80 00       	push   $0x803f38
  8027c1:	68 80 00 00 00       	push   $0x80
  8027c6:	68 b3 3e 80 00       	push   $0x803eb3
  8027cb:	e8 11 df ff ff       	call   8006e1 <_panic>
  8027d0:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	89 50 04             	mov    %edx,0x4(%eax)
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	74 0c                	je     8027f2 <insert_sorted_allocList+0x280>
  8027e6:	a1 44 40 80 00       	mov    0x804044,%eax
  8027eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ee:	89 10                	mov    %edx,(%eax)
  8027f0:	eb 08                	jmp    8027fa <insert_sorted_allocList+0x288>
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	a3 40 40 80 00       	mov    %eax,0x804040
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	a3 44 40 80 00       	mov    %eax,0x804044
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802810:	40                   	inc    %eax
  802811:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802816:	eb 36                	jmp    80284e <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802818:	a1 48 40 80 00       	mov    0x804048,%eax
  80281d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802820:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802824:	74 07                	je     80282d <insert_sorted_allocList+0x2bb>
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	eb 05                	jmp    802832 <insert_sorted_allocList+0x2c0>
  80282d:	b8 00 00 00 00       	mov    $0x0,%eax
  802832:	a3 48 40 80 00       	mov    %eax,0x804048
  802837:	a1 48 40 80 00       	mov    0x804048,%eax
  80283c:	85 c0                	test   %eax,%eax
  80283e:	0f 85 23 fe ff ff    	jne    802667 <insert_sorted_allocList+0xf5>
  802844:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802848:	0f 85 19 fe ff ff    	jne    802667 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  80284e:	90                   	nop
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802857:	a1 38 41 80 00       	mov    0x804138,%eax
  80285c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285f:	e9 7c 01 00 00       	jmp    8029e0 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 40 0c             	mov    0xc(%eax),%eax
  80286a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286d:	0f 85 90 00 00 00    	jne    802903 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287d:	75 17                	jne    802896 <alloc_block_FF+0x45>
  80287f:	83 ec 04             	sub    $0x4,%esp
  802882:	68 5b 3f 80 00       	push   $0x803f5b
  802887:	68 ba 00 00 00       	push   $0xba
  80288c:	68 b3 3e 80 00       	push   $0x803eb3
  802891:	e8 4b de ff ff       	call   8006e1 <_panic>
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 00                	mov    (%eax),%eax
  80289b:	85 c0                	test   %eax,%eax
  80289d:	74 10                	je     8028af <alloc_block_FF+0x5e>
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a7:	8b 52 04             	mov    0x4(%edx),%edx
  8028aa:	89 50 04             	mov    %edx,0x4(%eax)
  8028ad:	eb 0b                	jmp    8028ba <alloc_block_FF+0x69>
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 40 04             	mov    0x4(%eax),%eax
  8028b5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 40 04             	mov    0x4(%eax),%eax
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	74 0f                	je     8028d3 <alloc_block_FF+0x82>
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cd:	8b 12                	mov    (%edx),%edx
  8028cf:	89 10                	mov    %edx,(%eax)
  8028d1:	eb 0a                	jmp    8028dd <alloc_block_FF+0x8c>
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 00                	mov    (%eax),%eax
  8028d8:	a3 38 41 80 00       	mov    %eax,0x804138
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f0:	a1 44 41 80 00       	mov    0x804144,%eax
  8028f5:	48                   	dec    %eax
  8028f6:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8028fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fe:	e9 10 01 00 00       	jmp    802a13 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 40 0c             	mov    0xc(%eax),%eax
  802909:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290c:	0f 86 c6 00 00 00    	jbe    8029d8 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802912:	a1 48 41 80 00       	mov    0x804148,%eax
  802917:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80291a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80291e:	75 17                	jne    802937 <alloc_block_FF+0xe6>
  802920:	83 ec 04             	sub    $0x4,%esp
  802923:	68 5b 3f 80 00       	push   $0x803f5b
  802928:	68 c2 00 00 00       	push   $0xc2
  80292d:	68 b3 3e 80 00       	push   $0x803eb3
  802932:	e8 aa dd ff ff       	call   8006e1 <_panic>
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	74 10                	je     802950 <alloc_block_FF+0xff>
  802940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802948:	8b 52 04             	mov    0x4(%edx),%edx
  80294b:	89 50 04             	mov    %edx,0x4(%eax)
  80294e:	eb 0b                	jmp    80295b <alloc_block_FF+0x10a>
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80295b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295e:	8b 40 04             	mov    0x4(%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 0f                	je     802974 <alloc_block_FF+0x123>
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80296e:	8b 12                	mov    (%edx),%edx
  802970:	89 10                	mov    %edx,(%eax)
  802972:	eb 0a                	jmp    80297e <alloc_block_FF+0x12d>
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	a3 48 41 80 00       	mov    %eax,0x804148
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802991:	a1 54 41 80 00       	mov    0x804154,%eax
  802996:	48                   	dec    %eax
  802997:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 50 08             	mov    0x8(%eax),%edx
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  8029a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ae:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ba:	89 c2                	mov    %eax,%edx
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	8b 50 08             	mov    0x8(%eax),%edx
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	01 c2                	add    %eax,%edx
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8029d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d6:	eb 3b                	jmp    802a13 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8029d8:	a1 40 41 80 00       	mov    0x804140,%eax
  8029dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e4:	74 07                	je     8029ed <alloc_block_FF+0x19c>
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	eb 05                	jmp    8029f2 <alloc_block_FF+0x1a1>
  8029ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f2:	a3 40 41 80 00       	mov    %eax,0x804140
  8029f7:	a1 40 41 80 00       	mov    0x804140,%eax
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	0f 85 60 fe ff ff    	jne    802864 <alloc_block_FF+0x13>
  802a04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a08:	0f 85 56 fe ff ff    	jne    802864 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a13:	c9                   	leave  
  802a14:	c3                   	ret    

00802a15 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
  802a18:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802a1b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a22:	a1 38 41 80 00       	mov    0x804138,%eax
  802a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2a:	eb 3a                	jmp    802a66 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a32:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a35:	72 27                	jb     802a5e <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802a37:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802a3b:	75 0b                	jne    802a48 <alloc_block_BF+0x33>
					best_size= element->size;
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 40 0c             	mov    0xc(%eax),%eax
  802a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a46:	eb 16                	jmp    802a5e <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 50 0c             	mov    0xc(%eax),%edx
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	39 c2                	cmp    %eax,%edx
  802a53:	77 09                	ja     802a5e <alloc_block_BF+0x49>
					best_size=element->size;
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a5e:	a1 40 41 80 00       	mov    0x804140,%eax
  802a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6a:	74 07                	je     802a73 <alloc_block_BF+0x5e>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 00                	mov    (%eax),%eax
  802a71:	eb 05                	jmp    802a78 <alloc_block_BF+0x63>
  802a73:	b8 00 00 00 00       	mov    $0x0,%eax
  802a78:	a3 40 41 80 00       	mov    %eax,0x804140
  802a7d:	a1 40 41 80 00       	mov    0x804140,%eax
  802a82:	85 c0                	test   %eax,%eax
  802a84:	75 a6                	jne    802a2c <alloc_block_BF+0x17>
  802a86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8a:	75 a0                	jne    802a2c <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802a8c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802a90:	0f 84 d3 01 00 00    	je     802c69 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802a96:	a1 38 41 80 00       	mov    0x804138,%eax
  802a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9e:	e9 98 01 00 00       	jmp    802c3b <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa9:	0f 86 da 00 00 00    	jbe    802b89 <alloc_block_BF+0x174>
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	39 c2                	cmp    %eax,%edx
  802aba:	0f 85 c9 00 00 00    	jne    802b89 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802ac0:	a1 48 41 80 00       	mov    0x804148,%eax
  802ac5:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802ac8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802acc:	75 17                	jne    802ae5 <alloc_block_BF+0xd0>
  802ace:	83 ec 04             	sub    $0x4,%esp
  802ad1:	68 5b 3f 80 00       	push   $0x803f5b
  802ad6:	68 ea 00 00 00       	push   $0xea
  802adb:	68 b3 3e 80 00       	push   $0x803eb3
  802ae0:	e8 fc db ff ff       	call   8006e1 <_panic>
  802ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	85 c0                	test   %eax,%eax
  802aec:	74 10                	je     802afe <alloc_block_BF+0xe9>
  802aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af6:	8b 52 04             	mov    0x4(%edx),%edx
  802af9:	89 50 04             	mov    %edx,0x4(%eax)
  802afc:	eb 0b                	jmp    802b09 <alloc_block_BF+0xf4>
  802afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b01:	8b 40 04             	mov    0x4(%eax),%eax
  802b04:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0c:	8b 40 04             	mov    0x4(%eax),%eax
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	74 0f                	je     802b22 <alloc_block_BF+0x10d>
  802b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b16:	8b 40 04             	mov    0x4(%eax),%eax
  802b19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1c:	8b 12                	mov    (%edx),%edx
  802b1e:	89 10                	mov    %edx,(%eax)
  802b20:	eb 0a                	jmp    802b2c <alloc_block_BF+0x117>
  802b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	a3 48 41 80 00       	mov    %eax,0x804148
  802b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3f:	a1 54 41 80 00       	mov    0x804154,%eax
  802b44:	48                   	dec    %eax
  802b45:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 50 08             	mov    0x8(%eax),%edx
  802b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b53:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b59:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5c:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 40 0c             	mov    0xc(%eax),%eax
  802b65:	2b 45 08             	sub    0x8(%ebp),%eax
  802b68:	89 c2                	mov    %eax,%edx
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 50 08             	mov    0x8(%eax),%edx
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	01 c2                	add    %eax,%edx
  802b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7e:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b84:	e9 e5 00 00 00       	jmp    802c6e <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 50 0c             	mov    0xc(%eax),%edx
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	39 c2                	cmp    %eax,%edx
  802b94:	0f 85 99 00 00 00    	jne    802c33 <alloc_block_BF+0x21e>
  802b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba0:	0f 85 8d 00 00 00    	jne    802c33 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802bac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb0:	75 17                	jne    802bc9 <alloc_block_BF+0x1b4>
  802bb2:	83 ec 04             	sub    $0x4,%esp
  802bb5:	68 5b 3f 80 00       	push   $0x803f5b
  802bba:	68 f7 00 00 00       	push   $0xf7
  802bbf:	68 b3 3e 80 00       	push   $0x803eb3
  802bc4:	e8 18 db ff ff       	call   8006e1 <_panic>
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	85 c0                	test   %eax,%eax
  802bd0:	74 10                	je     802be2 <alloc_block_BF+0x1cd>
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bda:	8b 52 04             	mov    0x4(%edx),%edx
  802bdd:	89 50 04             	mov    %edx,0x4(%eax)
  802be0:	eb 0b                	jmp    802bed <alloc_block_BF+0x1d8>
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 40 04             	mov    0x4(%eax),%eax
  802be8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 40 04             	mov    0x4(%eax),%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	74 0f                	je     802c06 <alloc_block_BF+0x1f1>
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 40 04             	mov    0x4(%eax),%eax
  802bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c00:	8b 12                	mov    (%edx),%edx
  802c02:	89 10                	mov    %edx,(%eax)
  802c04:	eb 0a                	jmp    802c10 <alloc_block_BF+0x1fb>
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	a3 38 41 80 00       	mov    %eax,0x804138
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c23:	a1 44 41 80 00       	mov    0x804144,%eax
  802c28:	48                   	dec    %eax
  802c29:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  802c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c31:	eb 3b                	jmp    802c6e <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802c33:	a1 40 41 80 00       	mov    0x804140,%eax
  802c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3f:	74 07                	je     802c48 <alloc_block_BF+0x233>
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	eb 05                	jmp    802c4d <alloc_block_BF+0x238>
  802c48:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4d:	a3 40 41 80 00       	mov    %eax,0x804140
  802c52:	a1 40 41 80 00       	mov    0x804140,%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	0f 85 44 fe ff ff    	jne    802aa3 <alloc_block_BF+0x8e>
  802c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c63:	0f 85 3a fe ff ff    	jne    802aa3 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802c69:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6e:	c9                   	leave  
  802c6f:	c3                   	ret    

00802c70 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c70:	55                   	push   %ebp
  802c71:	89 e5                	mov    %esp,%ebp
  802c73:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802c76:	83 ec 04             	sub    $0x4,%esp
  802c79:	68 7c 3f 80 00       	push   $0x803f7c
  802c7e:	68 04 01 00 00       	push   $0x104
  802c83:	68 b3 3e 80 00       	push   $0x803eb3
  802c88:	e8 54 da ff ff       	call   8006e1 <_panic>

00802c8d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802c8d:	55                   	push   %ebp
  802c8e:	89 e5                	mov    %esp,%ebp
  802c90:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802c93:	a1 38 41 80 00       	mov    0x804138,%eax
  802c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802c9b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ca0:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802ca3:	a1 38 41 80 00       	mov    0x804138,%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	75 68                	jne    802d14 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802cac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb0:	75 17                	jne    802cc9 <insert_sorted_with_merge_freeList+0x3c>
  802cb2:	83 ec 04             	sub    $0x4,%esp
  802cb5:	68 90 3e 80 00       	push   $0x803e90
  802cba:	68 14 01 00 00       	push   $0x114
  802cbf:	68 b3 3e 80 00       	push   $0x803eb3
  802cc4:	e8 18 da ff ff       	call   8006e1 <_panic>
  802cc9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	89 10                	mov    %edx,(%eax)
  802cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd7:	8b 00                	mov    (%eax),%eax
  802cd9:	85 c0                	test   %eax,%eax
  802cdb:	74 0d                	je     802cea <insert_sorted_with_merge_freeList+0x5d>
  802cdd:	a1 38 41 80 00       	mov    0x804138,%eax
  802ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce5:	89 50 04             	mov    %edx,0x4(%eax)
  802ce8:	eb 08                	jmp    802cf2 <insert_sorted_with_merge_freeList+0x65>
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	a3 38 41 80 00       	mov    %eax,0x804138
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d04:	a1 44 41 80 00       	mov    0x804144,%eax
  802d09:	40                   	inc    %eax
  802d0a:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802d0f:	e9 d2 06 00 00       	jmp    8033e6 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	8b 50 08             	mov    0x8(%eax),%edx
  802d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1d:	8b 40 08             	mov    0x8(%eax),%eax
  802d20:	39 c2                	cmp    %eax,%edx
  802d22:	0f 83 22 01 00 00    	jae    802e4a <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	8b 50 08             	mov    0x8(%eax),%edx
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	8b 40 0c             	mov    0xc(%eax),%eax
  802d34:	01 c2                	add    %eax,%edx
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	8b 40 08             	mov    0x8(%eax),%eax
  802d3c:	39 c2                	cmp    %eax,%edx
  802d3e:	0f 85 9e 00 00 00    	jne    802de2 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	8b 50 08             	mov    0x8(%eax),%edx
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d53:	8b 50 0c             	mov    0xc(%eax),%edx
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5c:	01 c2                	add    %eax,%edx
  802d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d61:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	8b 50 08             	mov    0x8(%eax),%edx
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d7e:	75 17                	jne    802d97 <insert_sorted_with_merge_freeList+0x10a>
  802d80:	83 ec 04             	sub    $0x4,%esp
  802d83:	68 90 3e 80 00       	push   $0x803e90
  802d88:	68 21 01 00 00       	push   $0x121
  802d8d:	68 b3 3e 80 00       	push   $0x803eb3
  802d92:	e8 4a d9 ff ff       	call   8006e1 <_panic>
  802d97:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	89 10                	mov    %edx,(%eax)
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	74 0d                	je     802db8 <insert_sorted_with_merge_freeList+0x12b>
  802dab:	a1 48 41 80 00       	mov    0x804148,%eax
  802db0:	8b 55 08             	mov    0x8(%ebp),%edx
  802db3:	89 50 04             	mov    %edx,0x4(%eax)
  802db6:	eb 08                	jmp    802dc0 <insert_sorted_with_merge_freeList+0x133>
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	a3 48 41 80 00       	mov    %eax,0x804148
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd2:	a1 54 41 80 00       	mov    0x804154,%eax
  802dd7:	40                   	inc    %eax
  802dd8:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802ddd:	e9 04 06 00 00       	jmp    8033e6 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802de2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de6:	75 17                	jne    802dff <insert_sorted_with_merge_freeList+0x172>
  802de8:	83 ec 04             	sub    $0x4,%esp
  802deb:	68 90 3e 80 00       	push   $0x803e90
  802df0:	68 26 01 00 00       	push   $0x126
  802df5:	68 b3 3e 80 00       	push   $0x803eb3
  802dfa:	e8 e2 d8 ff ff       	call   8006e1 <_panic>
  802dff:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	89 10                	mov    %edx,(%eax)
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	8b 00                	mov    (%eax),%eax
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	74 0d                	je     802e20 <insert_sorted_with_merge_freeList+0x193>
  802e13:	a1 38 41 80 00       	mov    0x804138,%eax
  802e18:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1b:	89 50 04             	mov    %edx,0x4(%eax)
  802e1e:	eb 08                	jmp    802e28 <insert_sorted_with_merge_freeList+0x19b>
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	a3 38 41 80 00       	mov    %eax,0x804138
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3a:	a1 44 41 80 00       	mov    0x804144,%eax
  802e3f:	40                   	inc    %eax
  802e40:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802e45:	e9 9c 05 00 00       	jmp    8033e6 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	8b 50 08             	mov    0x8(%eax),%edx
  802e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e53:	8b 40 08             	mov    0x8(%eax),%eax
  802e56:	39 c2                	cmp    %eax,%edx
  802e58:	0f 86 16 01 00 00    	jbe    802f74 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e61:	8b 50 08             	mov    0x8(%eax),%edx
  802e64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e67:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6a:	01 c2                	add    %eax,%edx
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	8b 40 08             	mov    0x8(%eax),%eax
  802e72:	39 c2                	cmp    %eax,%edx
  802e74:	0f 85 92 00 00 00    	jne    802f0c <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802e7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	8b 40 0c             	mov    0xc(%eax),%eax
  802e86:	01 c2                	add    %eax,%edx
  802e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 50 08             	mov    0x8(%eax),%edx
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802ea4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea8:	75 17                	jne    802ec1 <insert_sorted_with_merge_freeList+0x234>
  802eaa:	83 ec 04             	sub    $0x4,%esp
  802ead:	68 90 3e 80 00       	push   $0x803e90
  802eb2:	68 31 01 00 00       	push   $0x131
  802eb7:	68 b3 3e 80 00       	push   $0x803eb3
  802ebc:	e8 20 d8 ff ff       	call   8006e1 <_panic>
  802ec1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	89 10                	mov    %edx,(%eax)
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	8b 00                	mov    (%eax),%eax
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	74 0d                	je     802ee2 <insert_sorted_with_merge_freeList+0x255>
  802ed5:	a1 48 41 80 00       	mov    0x804148,%eax
  802eda:	8b 55 08             	mov    0x8(%ebp),%edx
  802edd:	89 50 04             	mov    %edx,0x4(%eax)
  802ee0:	eb 08                	jmp    802eea <insert_sorted_with_merge_freeList+0x25d>
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	a3 48 41 80 00       	mov    %eax,0x804148
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efc:	a1 54 41 80 00       	mov    0x804154,%eax
  802f01:	40                   	inc    %eax
  802f02:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802f07:	e9 da 04 00 00       	jmp    8033e6 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802f0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f10:	75 17                	jne    802f29 <insert_sorted_with_merge_freeList+0x29c>
  802f12:	83 ec 04             	sub    $0x4,%esp
  802f15:	68 38 3f 80 00       	push   $0x803f38
  802f1a:	68 37 01 00 00       	push   $0x137
  802f1f:	68 b3 3e 80 00       	push   $0x803eb3
  802f24:	e8 b8 d7 ff ff       	call   8006e1 <_panic>
  802f29:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	89 50 04             	mov    %edx,0x4(%eax)
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	8b 40 04             	mov    0x4(%eax),%eax
  802f3b:	85 c0                	test   %eax,%eax
  802f3d:	74 0c                	je     802f4b <insert_sorted_with_merge_freeList+0x2be>
  802f3f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802f44:	8b 55 08             	mov    0x8(%ebp),%edx
  802f47:	89 10                	mov    %edx,(%eax)
  802f49:	eb 08                	jmp    802f53 <insert_sorted_with_merge_freeList+0x2c6>
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	a3 38 41 80 00       	mov    %eax,0x804138
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f64:	a1 44 41 80 00       	mov    0x804144,%eax
  802f69:	40                   	inc    %eax
  802f6a:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802f6f:	e9 72 04 00 00       	jmp    8033e6 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f74:	a1 38 41 80 00       	mov    0x804138,%eax
  802f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f7c:	e9 35 04 00 00       	jmp    8033b6 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	8b 00                	mov    (%eax),%eax
  802f86:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	8b 50 08             	mov    0x8(%eax),%edx
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 40 08             	mov    0x8(%eax),%eax
  802f95:	39 c2                	cmp    %eax,%edx
  802f97:	0f 86 11 04 00 00    	jbe    8033ae <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	8b 50 08             	mov    0x8(%eax),%edx
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa9:	01 c2                	add    %eax,%edx
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	8b 40 08             	mov    0x8(%eax),%eax
  802fb1:	39 c2                	cmp    %eax,%edx
  802fb3:	0f 83 8b 00 00 00    	jae    803044 <insert_sorted_with_merge_freeList+0x3b7>
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	8b 50 08             	mov    0x8(%eax),%edx
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc5:	01 c2                	add    %eax,%edx
  802fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fca:	8b 40 08             	mov    0x8(%eax),%eax
  802fcd:	39 c2                	cmp    %eax,%edx
  802fcf:	73 73                	jae    803044 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802fd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd5:	74 06                	je     802fdd <insert_sorted_with_merge_freeList+0x350>
  802fd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fdb:	75 17                	jne    802ff4 <insert_sorted_with_merge_freeList+0x367>
  802fdd:	83 ec 04             	sub    $0x4,%esp
  802fe0:	68 04 3f 80 00       	push   $0x803f04
  802fe5:	68 48 01 00 00       	push   $0x148
  802fea:	68 b3 3e 80 00       	push   $0x803eb3
  802fef:	e8 ed d6 ff ff       	call   8006e1 <_panic>
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	8b 10                	mov    (%eax),%edx
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	89 10                	mov    %edx,(%eax)
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	8b 00                	mov    (%eax),%eax
  803003:	85 c0                	test   %eax,%eax
  803005:	74 0b                	je     803012 <insert_sorted_with_merge_freeList+0x385>
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 00                	mov    (%eax),%eax
  80300c:	8b 55 08             	mov    0x8(%ebp),%edx
  80300f:	89 50 04             	mov    %edx,0x4(%eax)
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 55 08             	mov    0x8(%ebp),%edx
  803018:	89 10                	mov    %edx,(%eax)
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803020:	89 50 04             	mov    %edx,0x4(%eax)
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	8b 00                	mov    (%eax),%eax
  803028:	85 c0                	test   %eax,%eax
  80302a:	75 08                	jne    803034 <insert_sorted_with_merge_freeList+0x3a7>
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803034:	a1 44 41 80 00       	mov    0x804144,%eax
  803039:	40                   	inc    %eax
  80303a:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  80303f:	e9 a2 03 00 00       	jmp    8033e6 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	8b 50 08             	mov    0x8(%eax),%edx
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	8b 40 0c             	mov    0xc(%eax),%eax
  803050:	01 c2                	add    %eax,%edx
  803052:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803055:	8b 40 08             	mov    0x8(%eax),%eax
  803058:	39 c2                	cmp    %eax,%edx
  80305a:	0f 83 ae 00 00 00    	jae    80310e <insert_sorted_with_merge_freeList+0x481>
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	8b 50 08             	mov    0x8(%eax),%edx
  803066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803069:	8b 48 08             	mov    0x8(%eax),%ecx
  80306c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306f:	8b 40 0c             	mov    0xc(%eax),%eax
  803072:	01 c8                	add    %ecx,%eax
  803074:	39 c2                	cmp    %eax,%edx
  803076:	0f 85 92 00 00 00    	jne    80310e <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	8b 50 0c             	mov    0xc(%eax),%edx
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	8b 40 0c             	mov    0xc(%eax),%eax
  803088:	01 c2                	add    %eax,%edx
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	8b 50 08             	mov    0x8(%eax),%edx
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8030a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030aa:	75 17                	jne    8030c3 <insert_sorted_with_merge_freeList+0x436>
  8030ac:	83 ec 04             	sub    $0x4,%esp
  8030af:	68 90 3e 80 00       	push   $0x803e90
  8030b4:	68 51 01 00 00       	push   $0x151
  8030b9:	68 b3 3e 80 00       	push   $0x803eb3
  8030be:	e8 1e d6 ff ff       	call   8006e1 <_panic>
  8030c3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	89 10                	mov    %edx,(%eax)
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	8b 00                	mov    (%eax),%eax
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	74 0d                	je     8030e4 <insert_sorted_with_merge_freeList+0x457>
  8030d7:	a1 48 41 80 00       	mov    0x804148,%eax
  8030dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030df:	89 50 04             	mov    %edx,0x4(%eax)
  8030e2:	eb 08                	jmp    8030ec <insert_sorted_with_merge_freeList+0x45f>
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	a3 48 41 80 00       	mov    %eax,0x804148
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030fe:	a1 54 41 80 00       	mov    0x804154,%eax
  803103:	40                   	inc    %eax
  803104:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  803109:	e9 d8 02 00 00       	jmp    8033e6 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	8b 50 08             	mov    0x8(%eax),%edx
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	8b 40 0c             	mov    0xc(%eax),%eax
  80311a:	01 c2                	add    %eax,%edx
  80311c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311f:	8b 40 08             	mov    0x8(%eax),%eax
  803122:	39 c2                	cmp    %eax,%edx
  803124:	0f 85 ba 00 00 00    	jne    8031e4 <insert_sorted_with_merge_freeList+0x557>
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	8b 50 08             	mov    0x8(%eax),%edx
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	8b 48 08             	mov    0x8(%eax),%ecx
  803136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803139:	8b 40 0c             	mov    0xc(%eax),%eax
  80313c:	01 c8                	add    %ecx,%eax
  80313e:	39 c2                	cmp    %eax,%edx
  803140:	0f 86 9e 00 00 00    	jbe    8031e4 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803146:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803149:	8b 50 0c             	mov    0xc(%eax),%edx
  80314c:	8b 45 08             	mov    0x8(%ebp),%eax
  80314f:	8b 40 0c             	mov    0xc(%eax),%eax
  803152:	01 c2                	add    %eax,%edx
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	8b 50 08             	mov    0x8(%eax),%edx
  803160:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803163:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803166:	8b 45 08             	mov    0x8(%ebp),%eax
  803169:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	8b 50 08             	mov    0x8(%eax),%edx
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80317c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803180:	75 17                	jne    803199 <insert_sorted_with_merge_freeList+0x50c>
  803182:	83 ec 04             	sub    $0x4,%esp
  803185:	68 90 3e 80 00       	push   $0x803e90
  80318a:	68 5b 01 00 00       	push   $0x15b
  80318f:	68 b3 3e 80 00       	push   $0x803eb3
  803194:	e8 48 d5 ff ff       	call   8006e1 <_panic>
  803199:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80319f:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a2:	89 10                	mov    %edx,(%eax)
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	8b 00                	mov    (%eax),%eax
  8031a9:	85 c0                	test   %eax,%eax
  8031ab:	74 0d                	je     8031ba <insert_sorted_with_merge_freeList+0x52d>
  8031ad:	a1 48 41 80 00       	mov    0x804148,%eax
  8031b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b5:	89 50 04             	mov    %edx,0x4(%eax)
  8031b8:	eb 08                	jmp    8031c2 <insert_sorted_with_merge_freeList+0x535>
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	a3 48 41 80 00       	mov    %eax,0x804148
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d4:	a1 54 41 80 00       	mov    0x804154,%eax
  8031d9:	40                   	inc    %eax
  8031da:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  8031df:	e9 02 02 00 00       	jmp    8033e6 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f0:	01 c2                	add    %eax,%edx
  8031f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f5:	8b 40 08             	mov    0x8(%eax),%eax
  8031f8:	39 c2                	cmp    %eax,%edx
  8031fa:	0f 85 ae 01 00 00    	jne    8033ae <insert_sorted_with_merge_freeList+0x721>
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	8b 50 08             	mov    0x8(%eax),%edx
  803206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803209:	8b 48 08             	mov    0x8(%eax),%ecx
  80320c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320f:	8b 40 0c             	mov    0xc(%eax),%eax
  803212:	01 c8                	add    %ecx,%eax
  803214:	39 c2                	cmp    %eax,%edx
  803216:	0f 85 92 01 00 00    	jne    8033ae <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  80321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321f:	8b 50 0c             	mov    0xc(%eax),%edx
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	8b 40 0c             	mov    0xc(%eax),%eax
  803228:	01 c2                	add    %eax,%edx
  80322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322d:	8b 40 0c             	mov    0xc(%eax),%eax
  803230:	01 c2                	add    %eax,%edx
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	8b 50 08             	mov    0x8(%eax),%edx
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  80324e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803251:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325b:	8b 50 08             	mov    0x8(%eax),%edx
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803264:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803268:	75 17                	jne    803281 <insert_sorted_with_merge_freeList+0x5f4>
  80326a:	83 ec 04             	sub    $0x4,%esp
  80326d:	68 5b 3f 80 00       	push   $0x803f5b
  803272:	68 63 01 00 00       	push   $0x163
  803277:	68 b3 3e 80 00       	push   $0x803eb3
  80327c:	e8 60 d4 ff ff       	call   8006e1 <_panic>
  803281:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	85 c0                	test   %eax,%eax
  803288:	74 10                	je     80329a <insert_sorted_with_merge_freeList+0x60d>
  80328a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803292:	8b 52 04             	mov    0x4(%edx),%edx
  803295:	89 50 04             	mov    %edx,0x4(%eax)
  803298:	eb 0b                	jmp    8032a5 <insert_sorted_with_merge_freeList+0x618>
  80329a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329d:	8b 40 04             	mov    0x4(%eax),%eax
  8032a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a8:	8b 40 04             	mov    0x4(%eax),%eax
  8032ab:	85 c0                	test   %eax,%eax
  8032ad:	74 0f                	je     8032be <insert_sorted_with_merge_freeList+0x631>
  8032af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b2:	8b 40 04             	mov    0x4(%eax),%eax
  8032b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032b8:	8b 12                	mov    (%edx),%edx
  8032ba:	89 10                	mov    %edx,(%eax)
  8032bc:	eb 0a                	jmp    8032c8 <insert_sorted_with_merge_freeList+0x63b>
  8032be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c1:	8b 00                	mov    (%eax),%eax
  8032c3:	a3 38 41 80 00       	mov    %eax,0x804138
  8032c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032db:	a1 44 41 80 00       	mov    0x804144,%eax
  8032e0:	48                   	dec    %eax
  8032e1:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8032e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ea:	75 17                	jne    803303 <insert_sorted_with_merge_freeList+0x676>
  8032ec:	83 ec 04             	sub    $0x4,%esp
  8032ef:	68 90 3e 80 00       	push   $0x803e90
  8032f4:	68 64 01 00 00       	push   $0x164
  8032f9:	68 b3 3e 80 00       	push   $0x803eb3
  8032fe:	e8 de d3 ff ff       	call   8006e1 <_panic>
  803303:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803309:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330c:	89 10                	mov    %edx,(%eax)
  80330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	74 0d                	je     803324 <insert_sorted_with_merge_freeList+0x697>
  803317:	a1 48 41 80 00       	mov    0x804148,%eax
  80331c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80331f:	89 50 04             	mov    %edx,0x4(%eax)
  803322:	eb 08                	jmp    80332c <insert_sorted_with_merge_freeList+0x69f>
  803324:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803327:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80332c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332f:	a3 48 41 80 00       	mov    %eax,0x804148
  803334:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803337:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333e:	a1 54 41 80 00       	mov    0x804154,%eax
  803343:	40                   	inc    %eax
  803344:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803349:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334d:	75 17                	jne    803366 <insert_sorted_with_merge_freeList+0x6d9>
  80334f:	83 ec 04             	sub    $0x4,%esp
  803352:	68 90 3e 80 00       	push   $0x803e90
  803357:	68 65 01 00 00       	push   $0x165
  80335c:	68 b3 3e 80 00       	push   $0x803eb3
  803361:	e8 7b d3 ff ff       	call   8006e1 <_panic>
  803366:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	89 10                	mov    %edx,(%eax)
  803371:	8b 45 08             	mov    0x8(%ebp),%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	85 c0                	test   %eax,%eax
  803378:	74 0d                	je     803387 <insert_sorted_with_merge_freeList+0x6fa>
  80337a:	a1 48 41 80 00       	mov    0x804148,%eax
  80337f:	8b 55 08             	mov    0x8(%ebp),%edx
  803382:	89 50 04             	mov    %edx,0x4(%eax)
  803385:	eb 08                	jmp    80338f <insert_sorted_with_merge_freeList+0x702>
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	a3 48 41 80 00       	mov    %eax,0x804148
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a1:	a1 54 41 80 00       	mov    0x804154,%eax
  8033a6:	40                   	inc    %eax
  8033a7:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  8033ac:	eb 38                	jmp    8033e6 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8033ae:	a1 40 41 80 00       	mov    0x804140,%eax
  8033b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ba:	74 07                	je     8033c3 <insert_sorted_with_merge_freeList+0x736>
  8033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bf:	8b 00                	mov    (%eax),%eax
  8033c1:	eb 05                	jmp    8033c8 <insert_sorted_with_merge_freeList+0x73b>
  8033c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c8:	a3 40 41 80 00       	mov    %eax,0x804140
  8033cd:	a1 40 41 80 00       	mov    0x804140,%eax
  8033d2:	85 c0                	test   %eax,%eax
  8033d4:	0f 85 a7 fb ff ff    	jne    802f81 <insert_sorted_with_merge_freeList+0x2f4>
  8033da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033de:	0f 85 9d fb ff ff    	jne    802f81 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8033e4:	eb 00                	jmp    8033e6 <insert_sorted_with_merge_freeList+0x759>
  8033e6:	90                   	nop
  8033e7:	c9                   	leave  
  8033e8:	c3                   	ret    
  8033e9:	66 90                	xchg   %ax,%ax
  8033eb:	90                   	nop

008033ec <__udivdi3>:
  8033ec:	55                   	push   %ebp
  8033ed:	57                   	push   %edi
  8033ee:	56                   	push   %esi
  8033ef:	53                   	push   %ebx
  8033f0:	83 ec 1c             	sub    $0x1c,%esp
  8033f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803403:	89 ca                	mov    %ecx,%edx
  803405:	89 f8                	mov    %edi,%eax
  803407:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80340b:	85 f6                	test   %esi,%esi
  80340d:	75 2d                	jne    80343c <__udivdi3+0x50>
  80340f:	39 cf                	cmp    %ecx,%edi
  803411:	77 65                	ja     803478 <__udivdi3+0x8c>
  803413:	89 fd                	mov    %edi,%ebp
  803415:	85 ff                	test   %edi,%edi
  803417:	75 0b                	jne    803424 <__udivdi3+0x38>
  803419:	b8 01 00 00 00       	mov    $0x1,%eax
  80341e:	31 d2                	xor    %edx,%edx
  803420:	f7 f7                	div    %edi
  803422:	89 c5                	mov    %eax,%ebp
  803424:	31 d2                	xor    %edx,%edx
  803426:	89 c8                	mov    %ecx,%eax
  803428:	f7 f5                	div    %ebp
  80342a:	89 c1                	mov    %eax,%ecx
  80342c:	89 d8                	mov    %ebx,%eax
  80342e:	f7 f5                	div    %ebp
  803430:	89 cf                	mov    %ecx,%edi
  803432:	89 fa                	mov    %edi,%edx
  803434:	83 c4 1c             	add    $0x1c,%esp
  803437:	5b                   	pop    %ebx
  803438:	5e                   	pop    %esi
  803439:	5f                   	pop    %edi
  80343a:	5d                   	pop    %ebp
  80343b:	c3                   	ret    
  80343c:	39 ce                	cmp    %ecx,%esi
  80343e:	77 28                	ja     803468 <__udivdi3+0x7c>
  803440:	0f bd fe             	bsr    %esi,%edi
  803443:	83 f7 1f             	xor    $0x1f,%edi
  803446:	75 40                	jne    803488 <__udivdi3+0x9c>
  803448:	39 ce                	cmp    %ecx,%esi
  80344a:	72 0a                	jb     803456 <__udivdi3+0x6a>
  80344c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803450:	0f 87 9e 00 00 00    	ja     8034f4 <__udivdi3+0x108>
  803456:	b8 01 00 00 00       	mov    $0x1,%eax
  80345b:	89 fa                	mov    %edi,%edx
  80345d:	83 c4 1c             	add    $0x1c,%esp
  803460:	5b                   	pop    %ebx
  803461:	5e                   	pop    %esi
  803462:	5f                   	pop    %edi
  803463:	5d                   	pop    %ebp
  803464:	c3                   	ret    
  803465:	8d 76 00             	lea    0x0(%esi),%esi
  803468:	31 ff                	xor    %edi,%edi
  80346a:	31 c0                	xor    %eax,%eax
  80346c:	89 fa                	mov    %edi,%edx
  80346e:	83 c4 1c             	add    $0x1c,%esp
  803471:	5b                   	pop    %ebx
  803472:	5e                   	pop    %esi
  803473:	5f                   	pop    %edi
  803474:	5d                   	pop    %ebp
  803475:	c3                   	ret    
  803476:	66 90                	xchg   %ax,%ax
  803478:	89 d8                	mov    %ebx,%eax
  80347a:	f7 f7                	div    %edi
  80347c:	31 ff                	xor    %edi,%edi
  80347e:	89 fa                	mov    %edi,%edx
  803480:	83 c4 1c             	add    $0x1c,%esp
  803483:	5b                   	pop    %ebx
  803484:	5e                   	pop    %esi
  803485:	5f                   	pop    %edi
  803486:	5d                   	pop    %ebp
  803487:	c3                   	ret    
  803488:	bd 20 00 00 00       	mov    $0x20,%ebp
  80348d:	89 eb                	mov    %ebp,%ebx
  80348f:	29 fb                	sub    %edi,%ebx
  803491:	89 f9                	mov    %edi,%ecx
  803493:	d3 e6                	shl    %cl,%esi
  803495:	89 c5                	mov    %eax,%ebp
  803497:	88 d9                	mov    %bl,%cl
  803499:	d3 ed                	shr    %cl,%ebp
  80349b:	89 e9                	mov    %ebp,%ecx
  80349d:	09 f1                	or     %esi,%ecx
  80349f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034a3:	89 f9                	mov    %edi,%ecx
  8034a5:	d3 e0                	shl    %cl,%eax
  8034a7:	89 c5                	mov    %eax,%ebp
  8034a9:	89 d6                	mov    %edx,%esi
  8034ab:	88 d9                	mov    %bl,%cl
  8034ad:	d3 ee                	shr    %cl,%esi
  8034af:	89 f9                	mov    %edi,%ecx
  8034b1:	d3 e2                	shl    %cl,%edx
  8034b3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034b7:	88 d9                	mov    %bl,%cl
  8034b9:	d3 e8                	shr    %cl,%eax
  8034bb:	09 c2                	or     %eax,%edx
  8034bd:	89 d0                	mov    %edx,%eax
  8034bf:	89 f2                	mov    %esi,%edx
  8034c1:	f7 74 24 0c          	divl   0xc(%esp)
  8034c5:	89 d6                	mov    %edx,%esi
  8034c7:	89 c3                	mov    %eax,%ebx
  8034c9:	f7 e5                	mul    %ebp
  8034cb:	39 d6                	cmp    %edx,%esi
  8034cd:	72 19                	jb     8034e8 <__udivdi3+0xfc>
  8034cf:	74 0b                	je     8034dc <__udivdi3+0xf0>
  8034d1:	89 d8                	mov    %ebx,%eax
  8034d3:	31 ff                	xor    %edi,%edi
  8034d5:	e9 58 ff ff ff       	jmp    803432 <__udivdi3+0x46>
  8034da:	66 90                	xchg   %ax,%ax
  8034dc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034e0:	89 f9                	mov    %edi,%ecx
  8034e2:	d3 e2                	shl    %cl,%edx
  8034e4:	39 c2                	cmp    %eax,%edx
  8034e6:	73 e9                	jae    8034d1 <__udivdi3+0xe5>
  8034e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034eb:	31 ff                	xor    %edi,%edi
  8034ed:	e9 40 ff ff ff       	jmp    803432 <__udivdi3+0x46>
  8034f2:	66 90                	xchg   %ax,%ax
  8034f4:	31 c0                	xor    %eax,%eax
  8034f6:	e9 37 ff ff ff       	jmp    803432 <__udivdi3+0x46>
  8034fb:	90                   	nop

008034fc <__umoddi3>:
  8034fc:	55                   	push   %ebp
  8034fd:	57                   	push   %edi
  8034fe:	56                   	push   %esi
  8034ff:	53                   	push   %ebx
  803500:	83 ec 1c             	sub    $0x1c,%esp
  803503:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803507:	8b 74 24 34          	mov    0x34(%esp),%esi
  80350b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80350f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803513:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803517:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80351b:	89 f3                	mov    %esi,%ebx
  80351d:	89 fa                	mov    %edi,%edx
  80351f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803523:	89 34 24             	mov    %esi,(%esp)
  803526:	85 c0                	test   %eax,%eax
  803528:	75 1a                	jne    803544 <__umoddi3+0x48>
  80352a:	39 f7                	cmp    %esi,%edi
  80352c:	0f 86 a2 00 00 00    	jbe    8035d4 <__umoddi3+0xd8>
  803532:	89 c8                	mov    %ecx,%eax
  803534:	89 f2                	mov    %esi,%edx
  803536:	f7 f7                	div    %edi
  803538:	89 d0                	mov    %edx,%eax
  80353a:	31 d2                	xor    %edx,%edx
  80353c:	83 c4 1c             	add    $0x1c,%esp
  80353f:	5b                   	pop    %ebx
  803540:	5e                   	pop    %esi
  803541:	5f                   	pop    %edi
  803542:	5d                   	pop    %ebp
  803543:	c3                   	ret    
  803544:	39 f0                	cmp    %esi,%eax
  803546:	0f 87 ac 00 00 00    	ja     8035f8 <__umoddi3+0xfc>
  80354c:	0f bd e8             	bsr    %eax,%ebp
  80354f:	83 f5 1f             	xor    $0x1f,%ebp
  803552:	0f 84 ac 00 00 00    	je     803604 <__umoddi3+0x108>
  803558:	bf 20 00 00 00       	mov    $0x20,%edi
  80355d:	29 ef                	sub    %ebp,%edi
  80355f:	89 fe                	mov    %edi,%esi
  803561:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803565:	89 e9                	mov    %ebp,%ecx
  803567:	d3 e0                	shl    %cl,%eax
  803569:	89 d7                	mov    %edx,%edi
  80356b:	89 f1                	mov    %esi,%ecx
  80356d:	d3 ef                	shr    %cl,%edi
  80356f:	09 c7                	or     %eax,%edi
  803571:	89 e9                	mov    %ebp,%ecx
  803573:	d3 e2                	shl    %cl,%edx
  803575:	89 14 24             	mov    %edx,(%esp)
  803578:	89 d8                	mov    %ebx,%eax
  80357a:	d3 e0                	shl    %cl,%eax
  80357c:	89 c2                	mov    %eax,%edx
  80357e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803582:	d3 e0                	shl    %cl,%eax
  803584:	89 44 24 04          	mov    %eax,0x4(%esp)
  803588:	8b 44 24 08          	mov    0x8(%esp),%eax
  80358c:	89 f1                	mov    %esi,%ecx
  80358e:	d3 e8                	shr    %cl,%eax
  803590:	09 d0                	or     %edx,%eax
  803592:	d3 eb                	shr    %cl,%ebx
  803594:	89 da                	mov    %ebx,%edx
  803596:	f7 f7                	div    %edi
  803598:	89 d3                	mov    %edx,%ebx
  80359a:	f7 24 24             	mull   (%esp)
  80359d:	89 c6                	mov    %eax,%esi
  80359f:	89 d1                	mov    %edx,%ecx
  8035a1:	39 d3                	cmp    %edx,%ebx
  8035a3:	0f 82 87 00 00 00    	jb     803630 <__umoddi3+0x134>
  8035a9:	0f 84 91 00 00 00    	je     803640 <__umoddi3+0x144>
  8035af:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035b3:	29 f2                	sub    %esi,%edx
  8035b5:	19 cb                	sbb    %ecx,%ebx
  8035b7:	89 d8                	mov    %ebx,%eax
  8035b9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035bd:	d3 e0                	shl    %cl,%eax
  8035bf:	89 e9                	mov    %ebp,%ecx
  8035c1:	d3 ea                	shr    %cl,%edx
  8035c3:	09 d0                	or     %edx,%eax
  8035c5:	89 e9                	mov    %ebp,%ecx
  8035c7:	d3 eb                	shr    %cl,%ebx
  8035c9:	89 da                	mov    %ebx,%edx
  8035cb:	83 c4 1c             	add    $0x1c,%esp
  8035ce:	5b                   	pop    %ebx
  8035cf:	5e                   	pop    %esi
  8035d0:	5f                   	pop    %edi
  8035d1:	5d                   	pop    %ebp
  8035d2:	c3                   	ret    
  8035d3:	90                   	nop
  8035d4:	89 fd                	mov    %edi,%ebp
  8035d6:	85 ff                	test   %edi,%edi
  8035d8:	75 0b                	jne    8035e5 <__umoddi3+0xe9>
  8035da:	b8 01 00 00 00       	mov    $0x1,%eax
  8035df:	31 d2                	xor    %edx,%edx
  8035e1:	f7 f7                	div    %edi
  8035e3:	89 c5                	mov    %eax,%ebp
  8035e5:	89 f0                	mov    %esi,%eax
  8035e7:	31 d2                	xor    %edx,%edx
  8035e9:	f7 f5                	div    %ebp
  8035eb:	89 c8                	mov    %ecx,%eax
  8035ed:	f7 f5                	div    %ebp
  8035ef:	89 d0                	mov    %edx,%eax
  8035f1:	e9 44 ff ff ff       	jmp    80353a <__umoddi3+0x3e>
  8035f6:	66 90                	xchg   %ax,%ax
  8035f8:	89 c8                	mov    %ecx,%eax
  8035fa:	89 f2                	mov    %esi,%edx
  8035fc:	83 c4 1c             	add    $0x1c,%esp
  8035ff:	5b                   	pop    %ebx
  803600:	5e                   	pop    %esi
  803601:	5f                   	pop    %edi
  803602:	5d                   	pop    %ebp
  803603:	c3                   	ret    
  803604:	3b 04 24             	cmp    (%esp),%eax
  803607:	72 06                	jb     80360f <__umoddi3+0x113>
  803609:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80360d:	77 0f                	ja     80361e <__umoddi3+0x122>
  80360f:	89 f2                	mov    %esi,%edx
  803611:	29 f9                	sub    %edi,%ecx
  803613:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803617:	89 14 24             	mov    %edx,(%esp)
  80361a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80361e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803622:	8b 14 24             	mov    (%esp),%edx
  803625:	83 c4 1c             	add    $0x1c,%esp
  803628:	5b                   	pop    %ebx
  803629:	5e                   	pop    %esi
  80362a:	5f                   	pop    %edi
  80362b:	5d                   	pop    %ebp
  80362c:	c3                   	ret    
  80362d:	8d 76 00             	lea    0x0(%esi),%esi
  803630:	2b 04 24             	sub    (%esp),%eax
  803633:	19 fa                	sbb    %edi,%edx
  803635:	89 d1                	mov    %edx,%ecx
  803637:	89 c6                	mov    %eax,%esi
  803639:	e9 71 ff ff ff       	jmp    8035af <__umoddi3+0xb3>
  80363e:	66 90                	xchg   %ax,%ax
  803640:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803644:	72 ea                	jb     803630 <__umoddi3+0x134>
  803646:	89 d9                	mov    %ebx,%ecx
  803648:	e9 62 ff ff ff       	jmp    8035af <__umoddi3+0xb3>
