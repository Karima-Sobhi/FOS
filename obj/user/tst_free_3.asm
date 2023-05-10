
obj/user/tst_free_3:     file format elf32-i386


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
  800031:	e8 1d 14 00 00       	call   801453 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

#define numOfAccessesFor3MB 7
#define numOfAccessesFor8MB 4
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 7c 01 00 00    	sub    $0x17c,%esp



	int Mega = 1024*1024;
  800044:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)
	int kilo = 1024;
  80004b:	c7 45 d0 00 04 00 00 	movl   $0x400,-0x30(%ebp)
	char minByte = 1<<7;
  800052:	c6 45 cf 80          	movb   $0x80,-0x31(%ebp)
	char maxByte = 0x7F;
  800056:	c6 45 ce 7f          	movb   $0x7f,-0x32(%ebp)
	short minShort = 1<<15 ;
  80005a:	66 c7 45 cc 00 80    	movw   $0x8000,-0x34(%ebp)
	short maxShort = 0x7FFF;
  800060:	66 c7 45 ca ff 7f    	movw   $0x7fff,-0x36(%ebp)
	int minInt = 1<<31 ;
  800066:	c7 45 c4 00 00 00 80 	movl   $0x80000000,-0x3c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006d:	c7 45 c0 ff ff ff 7f 	movl   $0x7fffffff,-0x40(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	6a 00                	push   $0x0
  800079:	e8 f1 26 00 00       	call   80276f <malloc>
  80007e:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80008c:	8b 00                	mov    (%eax),%eax
  80008e:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800091:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800099:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80009e:	74 14                	je     8000b4 <_main+0x7c>
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 00 45 80 00       	push   $0x804500
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 41 45 80 00       	push   $0x804541
  8000af:	e8 db 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000b9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000bf:	83 c0 18             	add    $0x18,%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8000c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8000ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000cf:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 00 45 80 00       	push   $0x804500
  8000de:	6a 21                	push   $0x21
  8000e0:	68 41 45 80 00       	push   $0x804541
  8000e5:	e8 a5 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ef:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000f5:	83 c0 30             	add    $0x30,%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000fd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800105:	3d 00 20 20 00       	cmp    $0x202000,%eax
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 00 45 80 00       	push   $0x804500
  800114:	6a 22                	push   $0x22
  800116:	68 41 45 80 00       	push   $0x804541
  80011b:	e8 6f 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800120:	a1 20 50 80 00       	mov    0x805020,%eax
  800125:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80012b:	83 c0 48             	add    $0x48,%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800133:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800136:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80013b:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 00 45 80 00       	push   $0x804500
  80014a:	6a 23                	push   $0x23
  80014c:	68 41 45 80 00       	push   $0x804541
  800151:	e8 39 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800156:	a1 20 50 80 00       	mov    0x805020,%eax
  80015b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800161:	83 c0 60             	add    $0x60,%eax
  800164:	8b 00                	mov    (%eax),%eax
  800166:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800169:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80016c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800171:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800176:	74 14                	je     80018c <_main+0x154>
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	68 00 45 80 00       	push   $0x804500
  800180:	6a 24                	push   $0x24
  800182:	68 41 45 80 00       	push   $0x804541
  800187:	e8 03 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80018c:	a1 20 50 80 00       	mov    0x805020,%eax
  800191:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800197:	83 c0 78             	add    $0x78,%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80019f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a7:	3d 00 50 20 00       	cmp    $0x205000,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 00 45 80 00       	push   $0x804500
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 41 45 80 00       	push   $0x804541
  8001bd:	e8 cd 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c7:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001cd:	05 90 00 00 00       	add    $0x90,%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8001d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001df:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001e4:	74 14                	je     8001fa <_main+0x1c2>
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	68 00 45 80 00       	push   $0x804500
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 41 45 80 00       	push   $0x804541
  8001f5:	e8 95 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8001ff:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800205:	05 a8 00 00 00       	add    $0xa8,%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80020f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800212:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800217:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80021c:	74 14                	je     800232 <_main+0x1fa>
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 00 45 80 00       	push   $0x804500
  800226:	6a 27                	push   $0x27
  800228:	68 41 45 80 00       	push   $0x804541
  80022d:	e8 5d 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800232:	a1 20 50 80 00       	mov    0x805020,%eax
  800237:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80023d:	05 c0 00 00 00       	add    $0xc0,%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800247:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80024a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 00 45 80 00       	push   $0x804500
  80025e:	6a 28                	push   $0x28
  800260:	68 41 45 80 00       	push   $0x804541
  800265:	e8 25 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026a:	a1 20 50 80 00       	mov    0x805020,%eax
  80026f:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800275:	05 d8 00 00 00       	add    $0xd8,%eax
  80027a:	8b 00                	mov    (%eax),%eax
  80027c:	89 45 98             	mov    %eax,-0x68(%ebp)
  80027f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800282:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800287:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 00 45 80 00       	push   $0x804500
  800296:	6a 29                	push   $0x29
  800298:	68 41 45 80 00       	push   $0x804541
  80029d:	e8 ed 12 00 00       	call   80158f <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a7:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 54 45 80 00       	push   $0x804554
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 41 45 80 00       	push   $0x804541
  8002c0:	e8 ca 12 00 00       	call   80158f <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 d3 28 00 00       	call   802b9d <sys_calculate_free_frames>
  8002ca:	89 45 94             	mov    %eax,-0x6c(%ebp)

	int indicesOf3MB[numOfAccessesFor3MB];
	int indicesOf8MB[numOfAccessesFor8MB];
	int var, i, j;

	void* ptr_allocations[20] = {0};
  8002cd:	8d 95 80 fe ff ff    	lea    -0x180(%ebp),%edx
  8002d3:	b9 14 00 00 00       	mov    $0x14,%ecx
  8002d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dd:	89 d7                	mov    %edx,%edi
  8002df:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		/*ALLOCATE 2 MB*/
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002e1:	e8 57 29 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  8002e6:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8002e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	50                   	push   %eax
  8002f5:	e8 75 24 00 00       	call   80276f <malloc>
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800303:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	79 0d                	jns    80031a <_main+0x2e2>
  80030d:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800313:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800318:	76 14                	jbe    80032e <_main+0x2f6>
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	68 9c 45 80 00       	push   $0x80459c
  800322:	6a 39                	push   $0x39
  800324:	68 41 45 80 00       	push   $0x804541
  800329:	e8 61 12 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 0a 29 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 04 46 80 00       	push   $0x804604
  800345:	6a 3a                	push   $0x3a
  800347:	68 41 45 80 00       	push   $0x804541
  80034c:	e8 3e 12 00 00       	call   80158f <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 e7 28 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800356:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035c:	89 c2                	mov    %eax,%edx
  80035e:	01 d2                	add    %edx,%edx
  800360:	01 d0                	add    %edx,%eax
  800362:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	50                   	push   %eax
  800369:	e8 01 24 00 00       	call   80276f <malloc>
  80036e:	83 c4 10             	add    $0x10,%esp
  800371:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800377:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80037d:	89 c2                	mov    %eax,%edx
  80037f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	05 00 00 00 80       	add    $0x80000000,%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	72 16                	jb     8003a3 <_main+0x36b>
  80038d:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800393:	89 c2                	mov    %eax,%edx
  800395:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80039f:	39 c2                	cmp    %eax,%edx
  8003a1:	76 14                	jbe    8003b7 <_main+0x37f>
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	68 9c 45 80 00       	push   $0x80459c
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 41 45 80 00       	push   $0x804541
  8003b2:	e8 d8 11 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 81 28 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  8003bc:	2b 45 90             	sub    -0x70(%ebp),%eax
  8003bf:	89 c2                	mov    %eax,%edx
  8003c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c4:	89 c1                	mov    %eax,%ecx
  8003c6:	01 c9                	add    %ecx,%ecx
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	79 05                	jns    8003d3 <_main+0x39b>
  8003ce:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003d3:	c1 f8 0c             	sar    $0xc,%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 04 46 80 00       	push   $0x804604
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 41 45 80 00       	push   $0x804541
  8003e9:	e8 a1 11 00 00       	call   80158f <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 4a 28 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  8003f3:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(8*Mega-kilo);
  8003f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f9:	c1 e0 03             	shl    $0x3,%eax
  8003fc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8003ff:	83 ec 0c             	sub    $0xc,%esp
  800402:	50                   	push   %eax
  800403:	e8 67 23 00 00       	call   80276f <malloc>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 5*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 5*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800411:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800417:	89 c1                	mov    %eax,%ecx
  800419:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	c1 e0 02             	shl    $0x2,%eax
  800421:	01 d0                	add    %edx,%eax
  800423:	05 00 00 00 80       	add    $0x80000000,%eax
  800428:	39 c1                	cmp    %eax,%ecx
  80042a:	72 1b                	jb     800447 <_main+0x40f>
  80042c:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800432:	89 c1                	mov    %eax,%ecx
  800434:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800437:	89 d0                	mov    %edx,%eax
  800439:	c1 e0 02             	shl    $0x2,%eax
  80043c:	01 d0                	add    %edx,%eax
  80043e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800443:	39 c1                	cmp    %eax,%ecx
  800445:	76 14                	jbe    80045b <_main+0x423>
  800447:	83 ec 04             	sub    $0x4,%esp
  80044a:	68 9c 45 80 00       	push   $0x80459c
  80044f:	6a 47                	push   $0x47
  800451:	68 41 45 80 00       	push   $0x804541
  800456:	e8 34 11 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 dd 27 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800460:	2b 45 90             	sub    -0x70(%ebp),%eax
  800463:	89 c2                	mov    %eax,%edx
  800465:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800468:	c1 e0 03             	shl    $0x3,%eax
  80046b:	85 c0                	test   %eax,%eax
  80046d:	79 05                	jns    800474 <_main+0x43c>
  80046f:	05 ff 0f 00 00       	add    $0xfff,%eax
  800474:	c1 f8 0c             	sar    $0xc,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 04 46 80 00       	push   $0x804604
  800483:	6a 48                	push   $0x48
  800485:	68 41 45 80 00       	push   $0x804541
  80048a:	e8 00 11 00 00       	call   80158f <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 a9 27 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800494:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(7*Mega-kilo);
  800497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80049a:	89 d0                	mov    %edx,%eax
  80049c:	01 c0                	add    %eax,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	01 c0                	add    %eax,%eax
  8004a2:	01 d0                	add    %edx,%eax
  8004a4:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8004a7:	83 ec 0c             	sub    $0xc,%esp
  8004aa:	50                   	push   %eax
  8004ab:	e8 bf 22 00 00       	call   80276f <malloc>
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 13*Mega) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 13*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8004b9:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004bf:	89 c1                	mov    %eax,%ecx
  8004c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004c4:	89 d0                	mov    %edx,%eax
  8004c6:	01 c0                	add    %eax,%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	c1 e0 02             	shl    $0x2,%eax
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	05 00 00 00 80       	add    $0x80000000,%eax
  8004d4:	39 c1                	cmp    %eax,%ecx
  8004d6:	72 1f                	jb     8004f7 <_main+0x4bf>
  8004d8:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004de:	89 c1                	mov    %eax,%ecx
  8004e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004e3:	89 d0                	mov    %edx,%eax
  8004e5:	01 c0                	add    %eax,%eax
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	c1 e0 02             	shl    $0x2,%eax
  8004ec:	01 d0                	add    %edx,%eax
  8004ee:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8004f3:	39 c1                	cmp    %eax,%ecx
  8004f5:	76 14                	jbe    80050b <_main+0x4d3>
  8004f7:	83 ec 04             	sub    $0x4,%esp
  8004fa:	68 9c 45 80 00       	push   $0x80459c
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 41 45 80 00       	push   $0x804541
  800506:	e8 84 10 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 2d 27 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800510:	2b 45 90             	sub    -0x70(%ebp),%eax
  800513:	89 c1                	mov    %eax,%ecx
  800515:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	01 c0                	add    %eax,%eax
  800520:	01 d0                	add    %edx,%eax
  800522:	85 c0                	test   %eax,%eax
  800524:	79 05                	jns    80052b <_main+0x4f3>
  800526:	05 ff 0f 00 00       	add    $0xfff,%eax
  80052b:	c1 f8 0c             	sar    $0xc,%eax
  80052e:	39 c1                	cmp    %eax,%ecx
  800530:	74 14                	je     800546 <_main+0x50e>
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	68 04 46 80 00       	push   $0x804604
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 41 45 80 00       	push   $0x804541
  800541:	e8 49 10 00 00       	call   80158f <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 52 26 00 00       	call   802b9d <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 63 26 00 00       	call   802bb6 <sys_calculate_modified_frames>
  800553:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
  800556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800559:	89 c2                	mov    %eax,%edx
  80055b:	01 d2                	add    %edx,%edx
  80055d:	01 d0                	add    %edx,%eax
  80055f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800562:	48                   	dec    %eax
  800563:	89 45 84             	mov    %eax,-0x7c(%ebp)
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
  800566:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800569:	bf 07 00 00 00       	mov    $0x7,%edi
  80056e:	99                   	cltd   
  80056f:	f7 ff                	idiv   %edi
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800574:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80057b:	eb 16                	jmp    800593 <_main+0x55b>
		{
			indicesOf3MB[var] = var * inc ;
  80057d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800580:	0f af 45 80          	imul   -0x80(%ebp),%eax
  800584:	89 c2                	mov    %eax,%edx
  800586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800589:	89 94 85 e0 fe ff ff 	mov    %edx,-0x120(%ebp,%eax,4)
		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
		int modFrames = sys_calculate_modified_frames();
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800590:	ff 45 e4             	incl   -0x1c(%ebp)
  800593:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800597:	7e e4                	jle    80057d <_main+0x545>
		{
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
  800599:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80059f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		//3 reads
		int sum = 0;
  8005a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005b3:	eb 1f                	jmp    8005d4 <_main+0x59c>
		{
			sum += byteArr[indicesOf3MB[var]] ;
  8005b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b8:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005bf:	89 c2                	mov    %eax,%edx
  8005c1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005c7:	01 d0                	add    %edx,%eax
  8005c9:	8a 00                	mov    (%eax),%al
  8005cb:	0f be c0             	movsbl %al,%eax
  8005ce:	01 45 dc             	add    %eax,-0x24(%ebp)
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
		//3 reads
		int sum = 0;
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005d1:	ff 45 e4             	incl   -0x1c(%ebp)
  8005d4:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  8005d8:	7e db                	jle    8005b5 <_main+0x57d>
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005da:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  8005e1:	eb 1c                	jmp    8005ff <_main+0x5c7>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
  8005e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005e6:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005ed:	89 c2                	mov    %eax,%edx
  8005ef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f5:	01 c2                	add    %eax,%edx
  8005f7:	8a 45 ce             	mov    -0x32(%ebp),%al
  8005fa:	88 02                	mov    %al,(%edx)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005fc:	ff 45 e4             	incl   -0x1c(%ebp)
  8005ff:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800603:	7e de                	jle    8005e3 <_main+0x5ab>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800605:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800608:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	89 c6                	mov    %eax,%esi
  80060f:	e8 89 25 00 00       	call   802b9d <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 9b 25 00 00       	call   802bb6 <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 34 46 80 00       	push   $0x804634
  80062e:	6a 67                	push   $0x67
  800630:	68 41 45 80 00       	push   $0x804541
  800635:	e8 55 0f 00 00       	call   80158f <_panic>
		int found = 0;
  80063a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800641:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800648:	eb 78                	jmp    8006c2 <_main+0x68a>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80064a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800651:	eb 5d                	jmp    8006b0 <_main+0x678>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  800653:	a1 20 50 80 00       	mov    0x805020,%eax
  800658:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80065e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800661:	89 d0                	mov    %edx,%eax
  800663:	01 c0                	add    %eax,%eax
  800665:	01 d0                	add    %edx,%eax
  800667:	c1 e0 03             	shl    $0x3,%eax
  80066a:	01 c8                	add    %ecx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800674:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80067a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80067f:	89 c2                	mov    %eax,%edx
  800681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800684:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  80068b:	89 c1                	mov    %eax,%ecx
  80068d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800693:	01 c8                	add    %ecx,%eax
  800695:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  80069b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	75 03                	jne    8006ad <_main+0x675>
				{
					found++;
  8006aa:	ff 45 d8             	incl   -0x28(%ebp)
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8006ad:	ff 45 e0             	incl   -0x20(%ebp)
  8006b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b5:	8b 50 74             	mov    0x74(%eax),%edx
  8006b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006bb:	39 c2                	cmp    %eax,%edx
  8006bd:	77 94                	ja     800653 <_main+0x61b>
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  8006bf:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c2:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8006c6:	7e 82                	jle    80064a <_main+0x612>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor3MB) panic("malloc: page is not added to WS");
  8006c8:	83 7d d8 07          	cmpl   $0x7,-0x28(%ebp)
  8006cc:	74 14                	je     8006e2 <_main+0x6aa>
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 78 46 80 00       	push   $0x804678
  8006d6:	6a 73                	push   $0x73
  8006d8:	68 41 45 80 00       	push   $0x804541
  8006dd:	e8 ad 0e 00 00       	call   80158f <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e2:	e8 b6 24 00 00       	call   802b9d <sys_calculate_free_frames>
  8006e7:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006ea:	e8 c7 24 00 00       	call   802bb6 <sys_calculate_modified_frames>
  8006ef:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfShort = (8*Mega-kilo)/sizeof(short) - 1;
  8006f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f5:	c1 e0 03             	shl    $0x3,%eax
  8006f8:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8006fb:	d1 e8                	shr    %eax
  8006fd:	48                   	dec    %eax
  8006fe:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		indicesOf8MB[0] = lastIndexOfShort * 1 / 2;
  800704:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80070a:	89 c2                	mov    %eax,%edx
  80070c:	c1 ea 1f             	shr    $0x1f,%edx
  80070f:	01 d0                	add    %edx,%eax
  800711:	d1 f8                	sar    %eax
  800713:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
		indicesOf8MB[1] = lastIndexOfShort * 2 / 3;
  800719:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80071f:	01 c0                	add    %eax,%eax
  800721:	89 c1                	mov    %eax,%ecx
  800723:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800728:	f7 e9                	imul   %ecx
  80072a:	c1 f9 1f             	sar    $0x1f,%ecx
  80072d:	89 d0                	mov    %edx,%eax
  80072f:	29 c8                	sub    %ecx,%eax
  800731:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
		indicesOf8MB[2] = lastIndexOfShort * 3 / 4;
  800737:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80073d:	89 c2                	mov    %eax,%edx
  80073f:	01 d2                	add    %edx,%edx
  800741:	01 d0                	add    %edx,%eax
  800743:	85 c0                	test   %eax,%eax
  800745:	79 03                	jns    80074a <_main+0x712>
  800747:	83 c0 03             	add    $0x3,%eax
  80074a:	c1 f8 02             	sar    $0x2,%eax
  80074d:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
		indicesOf8MB[3] = lastIndexOfShort ;
  800753:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800759:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)

		//use one of the read pages from 3 MB to avoid victimizing it
		sum += byteArr[indicesOf3MB[0]] ;
  80075f:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800765:	89 c2                	mov    %eax,%edx
  800767:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80076d:	01 d0                	add    %edx,%eax
  80076f:	8a 00                	mov    (%eax),%al
  800771:	0f be c0             	movsbl %al,%eax
  800774:	01 45 dc             	add    %eax,-0x24(%ebp)

		shortArr = (short *) ptr_allocations[2];
  800777:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  80077d:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		//2 reads
		sum = 0;
  800783:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  80078a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800791:	eb 20                	jmp    8007b3 <_main+0x77b>
		{
			sum += shortArr[indicesOf8MB[var]] ;
  800793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800796:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  80079d:	01 c0                	add    %eax,%eax
  80079f:	89 c2                	mov    %eax,%edx
  8007a1:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007a7:	01 d0                	add    %edx,%eax
  8007a9:	66 8b 00             	mov    (%eax),%ax
  8007ac:	98                   	cwtl   
  8007ad:	01 45 dc             	add    %eax,-0x24(%ebp)
		sum += byteArr[indicesOf3MB[0]] ;

		shortArr = (short *) ptr_allocations[2];
		//2 reads
		sum = 0;
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  8007b0:	ff 45 e4             	incl   -0x1c(%ebp)
  8007b3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8007b7:	7e da                	jle    800793 <_main+0x75b>
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007b9:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  8007c0:	eb 20                	jmp    8007e2 <_main+0x7aa>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
  8007c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007c5:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	89 c2                	mov    %eax,%edx
  8007d0:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007d6:	01 c2                	add    %eax,%edx
  8007d8:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  8007dc:	66 89 02             	mov    %ax,(%edx)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007df:	ff 45 e4             	incl   -0x1c(%ebp)
  8007e2:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8007e6:	7e da                	jle    8007c2 <_main+0x78a>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007e8:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8007eb:	e8 ad 23 00 00       	call   802b9d <sys_calculate_free_frames>
  8007f0:	29 c3                	sub    %eax,%ebx
  8007f2:	89 d8                	mov    %ebx,%eax
  8007f4:	83 f8 04             	cmp    $0x4,%eax
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 34 46 80 00       	push   $0x804634
  800801:	68 8e 00 00 00       	push   $0x8e
  800806:	68 41 45 80 00       	push   $0x804541
  80080b:	e8 7f 0d 00 00       	call   80158f <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800810:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  800813:	e8 9e 23 00 00       	call   802bb6 <sys_calculate_modified_frames>
  800818:	29 c3                	sub    %eax,%ebx
  80081a:	89 d8                	mov    %ebx,%eax
  80081c:	83 f8 fe             	cmp    $0xfffffffe,%eax
  80081f:	74 17                	je     800838 <_main+0x800>
  800821:	83 ec 04             	sub    $0x4,%esp
  800824:	68 34 46 80 00       	push   $0x804634
  800829:	68 8f 00 00 00       	push   $0x8f
  80082e:	68 41 45 80 00       	push   $0x804541
  800833:	e8 57 0d 00 00       	call   80158f <_panic>
		found = 0;
  800838:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  80083f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800846:	eb 7a                	jmp    8008c2 <_main+0x88a>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800848:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80084f:	eb 5f                	jmp    8008b0 <_main+0x878>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[indicesOf8MB[var]])), PAGE_SIZE))
  800851:	a1 20 50 80 00       	mov    0x805020,%eax
  800856:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80085c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80085f:	89 d0                	mov    %edx,%eax
  800861:	01 c0                	add    %eax,%eax
  800863:	01 d0                	add    %edx,%eax
  800865:	c1 e0 03             	shl    $0x3,%eax
  800868:	01 c8                	add    %ecx,%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800872:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800878:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087d:	89 c2                	mov    %eax,%edx
  80087f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800882:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	89 c1                	mov    %eax,%ecx
  80088d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800893:	01 c8                	add    %ecx,%eax
  800895:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80089b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8008a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	75 03                	jne    8008ad <_main+0x875>
				{
					found++;
  8008aa:	ff 45 d8             	incl   -0x28(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8008ad:	ff 45 e0             	incl   -0x20(%ebp)
  8008b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8008b5:	8b 50 74             	mov    0x74(%eax),%edx
  8008b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008bb:	39 c2                	cmp    %eax,%edx
  8008bd:	77 92                	ja     800851 <_main+0x819>
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  8008bf:	ff 45 e4             	incl   -0x1c(%ebp)
  8008c2:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8008c6:	7e 80                	jle    800848 <_main+0x810>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor8MB) panic("malloc: page is not added to WS");
  8008c8:	83 7d d8 04          	cmpl   $0x4,-0x28(%ebp)
  8008cc:	74 17                	je     8008e5 <_main+0x8ad>
  8008ce:	83 ec 04             	sub    $0x4,%esp
  8008d1:	68 78 46 80 00       	push   $0x804678
  8008d6:	68 9b 00 00 00       	push   $0x9b
  8008db:	68 41 45 80 00       	push   $0x804541
  8008e0:	e8 aa 0c 00 00       	call   80158f <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008e5:	e8 b3 22 00 00       	call   802b9d <sys_calculate_free_frames>
  8008ea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008ed:	e8 c4 22 00 00       	call   802bb6 <sys_calculate_modified_frames>
  8008f2:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008f5:	e8 43 23 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  8008fa:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  8008fd:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	50                   	push   %eax
  800907:	e8 de 1e 00 00       	call   8027ea <free>
  80090c:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80090f:	e8 29 23 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800914:	8b 55 90             	mov    -0x70(%ebp),%edx
  800917:	89 d1                	mov    %edx,%ecx
  800919:	29 c1                	sub    %eax,%ecx
  80091b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80091e:	89 c2                	mov    %eax,%edx
  800920:	01 d2                	add    %edx,%edx
  800922:	01 d0                	add    %edx,%eax
  800924:	85 c0                	test   %eax,%eax
  800926:	79 05                	jns    80092d <_main+0x8f5>
  800928:	05 ff 0f 00 00       	add    $0xfff,%eax
  80092d:	c1 f8 0c             	sar    $0xc,%eax
  800930:	39 c1                	cmp    %eax,%ecx
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 98 46 80 00       	push   $0x804698
  80093c:	68 a5 00 00 00       	push   $0xa5
  800941:	68 41 45 80 00       	push   $0x804541
  800946:	e8 44 0c 00 00       	call   80158f <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  80094b:	e8 4d 22 00 00       	call   802b9d <sys_calculate_free_frames>
  800950:	89 c2                	mov    %eax,%edx
  800952:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800955:	29 c2                	sub    %eax,%edx
  800957:	89 d0                	mov    %edx,%eax
  800959:	83 f8 07             	cmp    $0x7,%eax
  80095c:	74 17                	je     800975 <_main+0x93d>
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 d4 46 80 00       	push   $0x8046d4
  800966:	68 a7 00 00 00       	push   $0xa7
  80096b:	68 41 45 80 00       	push   $0x804541
  800970:	e8 1a 0c 00 00       	call   80158f <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800975:	e8 3c 22 00 00       	call   802bb6 <sys_calculate_modified_frames>
  80097a:	89 c2                	mov    %eax,%edx
  80097c:	8b 45 88             	mov    -0x78(%ebp),%eax
  80097f:	29 c2                	sub    %eax,%edx
  800981:	89 d0                	mov    %edx,%eax
  800983:	83 f8 02             	cmp    $0x2,%eax
  800986:	74 17                	je     80099f <_main+0x967>
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 28 47 80 00       	push   $0x804728
  800990:	68 a8 00 00 00       	push   $0xa8
  800995:	68 41 45 80 00       	push   $0x804541
  80099a:	e8 f0 0b 00 00       	call   80158f <_panic>
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  80099f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8009a6:	e9 8c 00 00 00       	jmp    800a37 <_main+0x9ff>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8009ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009b2:	eb 71                	jmp    800a25 <_main+0x9ed>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  8009b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	01 c0                	add    %eax,%eax
  8009c6:	01 d0                	add    %edx,%eax
  8009c8:	c1 e0 03             	shl    $0x3,%eax
  8009cb:	01 c8                	add    %ecx,%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8009d5:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8009db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009e0:	89 c2                	mov    %eax,%edx
  8009e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009e5:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8009ec:	89 c1                	mov    %eax,%ecx
  8009ee:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8009f4:	01 c8                	add    %ecx,%eax
  8009f6:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  8009fc:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a07:	39 c2                	cmp    %eax,%edx
  800a09:	75 17                	jne    800a22 <_main+0x9ea>
				{
					panic("free: page is not removed from WS");
  800a0b:	83 ec 04             	sub    $0x4,%esp
  800a0e:	68 60 47 80 00       	push   $0x804760
  800a13:	68 b0 00 00 00       	push   $0xb0
  800a18:	68 41 45 80 00       	push   $0x804541
  800a1d:	e8 6d 0b 00 00       	call   80158f <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800a22:	ff 45 e0             	incl   -0x20(%ebp)
  800a25:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2a:	8b 50 74             	mov    0x74(%eax),%edx
  800a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a30:	39 c2                	cmp    %eax,%edx
  800a32:	77 80                	ja     8009b4 <_main+0x97c>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800a34:	ff 45 e4             	incl   -0x1c(%ebp)
  800a37:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800a3b:	0f 8e 6a ff ff ff    	jle    8009ab <_main+0x973>
			}
		}



		freeFrames = sys_calculate_free_frames() ;
  800a41:	e8 57 21 00 00       	call   802b9d <sys_calculate_free_frames>
  800a46:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr = (short *) ptr_allocations[2];
  800a49:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800a4f:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800a55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a58:	01 c0                	add    %eax,%eax
  800a5a:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800a5d:	d1 e8                	shr    %eax
  800a5f:	48                   	dec    %eax
  800a60:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		shortArr[0] = minShort;
  800a66:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  800a6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a6f:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800a72:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a78:	01 c0                	add    %eax,%eax
  800a7a:	89 c2                	mov    %eax,%edx
  800a7c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a82:	01 c2                	add    %eax,%edx
  800a84:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  800a88:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a8b:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800a8e:	e8 0a 21 00 00       	call   802b9d <sys_calculate_free_frames>
  800a93:	29 c3                	sub    %eax,%ebx
  800a95:	89 d8                	mov    %ebx,%eax
  800a97:	83 f8 02             	cmp    $0x2,%eax
  800a9a:	74 17                	je     800ab3 <_main+0xa7b>
  800a9c:	83 ec 04             	sub    $0x4,%esp
  800a9f:	68 34 46 80 00       	push   $0x804634
  800aa4:	68 bc 00 00 00       	push   $0xbc
  800aa9:	68 41 45 80 00       	push   $0x804541
  800aae:	e8 dc 0a 00 00       	call   80158f <_panic>
		found = 0;
  800ab3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800aba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ac1:	e9 a7 00 00 00       	jmp    800b6d <_main+0xb35>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800ac6:	a1 20 50 80 00       	mov    0x805020,%eax
  800acb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ad4:	89 d0                	mov    %edx,%eax
  800ad6:	01 c0                	add    %eax,%eax
  800ad8:	01 d0                	add    %edx,%eax
  800ada:	c1 e0 03             	shl    $0x3,%eax
  800add:	01 c8                	add    %ecx,%eax
  800adf:	8b 00                	mov    (%eax),%eax
  800ae1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800ae7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800aed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af2:	89 c2                	mov    %eax,%edx
  800af4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800afa:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b00:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	75 03                	jne    800b12 <_main+0xada>
				found++;
  800b0f:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  800b12:	a1 20 50 80 00       	mov    0x805020,%eax
  800b17:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b20:	89 d0                	mov    %edx,%eax
  800b22:	01 c0                	add    %eax,%eax
  800b24:	01 d0                	add    %edx,%eax
  800b26:	c1 e0 03             	shl    $0x3,%eax
  800b29:	01 c8                	add    %ecx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b33:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b3e:	89 c2                	mov    %eax,%edx
  800b40:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b46:	01 c0                	add    %eax,%eax
  800b48:	89 c1                	mov    %eax,%ecx
  800b4a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b50:	01 c8                	add    %ecx,%eax
  800b52:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b58:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b63:	39 c2                	cmp    %eax,%edx
  800b65:	75 03                	jne    800b6a <_main+0xb32>
				found++;
  800b67:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b6a:	ff 45 e4             	incl   -0x1c(%ebp)
  800b6d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b72:	8b 50 74             	mov    0x74(%eax),%edx
  800b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b78:	39 c2                	cmp    %eax,%edx
  800b7a:	0f 87 46 ff ff ff    	ja     800ac6 <_main+0xa8e>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800b80:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800b84:	74 17                	je     800b9d <_main+0xb65>
  800b86:	83 ec 04             	sub    $0x4,%esp
  800b89:	68 78 46 80 00       	push   $0x804678
  800b8e:	68 c5 00 00 00       	push   $0xc5
  800b93:	68 41 45 80 00       	push   $0x804541
  800b98:	e8 f2 09 00 00       	call   80158f <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b9d:	e8 9b 20 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800ba5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ba8:	01 c0                	add    %eax,%eax
  800baa:	83 ec 0c             	sub    $0xc,%esp
  800bad:	50                   	push   %eax
  800bae:	e8 bc 1b 00 00       	call   80276f <malloc>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800bbc:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bc2:	89 c2                	mov    %eax,%edx
  800bc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bc7:	c1 e0 02             	shl    $0x2,%eax
  800bca:	05 00 00 00 80       	add    $0x80000000,%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	72 17                	jb     800bea <_main+0xbb2>
  800bd3:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bd9:	89 c2                	mov    %eax,%edx
  800bdb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bde:	c1 e0 02             	shl    $0x2,%eax
  800be1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800be6:	39 c2                	cmp    %eax,%edx
  800be8:	76 17                	jbe    800c01 <_main+0xbc9>
  800bea:	83 ec 04             	sub    $0x4,%esp
  800bed:	68 9c 45 80 00       	push   $0x80459c
  800bf2:	68 ca 00 00 00       	push   $0xca
  800bf7:	68 41 45 80 00       	push   $0x804541
  800bfc:	e8 8e 09 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c01:	e8 37 20 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800c06:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c09:	83 f8 01             	cmp    $0x1,%eax
  800c0c:	74 17                	je     800c25 <_main+0xbed>
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 04 46 80 00       	push   $0x804604
  800c16:	68 cb 00 00 00       	push   $0xcb
  800c1b:	68 41 45 80 00       	push   $0x804541
  800c20:	e8 6a 09 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c25:	e8 73 1f 00 00       	call   802b9d <sys_calculate_free_frames>
  800c2a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr = (int *) ptr_allocations[2];
  800c2d:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800c33:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800c39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c3c:	01 c0                	add    %eax,%eax
  800c3e:	c1 e8 02             	shr    $0x2,%eax
  800c41:	48                   	dec    %eax
  800c42:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
		intArr[0] = minInt;
  800c48:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c4e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800c51:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  800c53:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c60:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c66:	01 c2                	add    %eax,%edx
  800c68:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6b:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800c6d:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800c70:	e8 28 1f 00 00       	call   802b9d <sys_calculate_free_frames>
  800c75:	29 c3                	sub    %eax,%ebx
  800c77:	89 d8                	mov    %ebx,%eax
  800c79:	83 f8 02             	cmp    $0x2,%eax
  800c7c:	74 17                	je     800c95 <_main+0xc5d>
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 34 46 80 00       	push   $0x804634
  800c86:	68 d2 00 00 00       	push   $0xd2
  800c8b:	68 41 45 80 00       	push   $0x804541
  800c90:	e8 fa 08 00 00       	call   80158f <_panic>
		found = 0;
  800c95:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800c9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ca3:	e9 aa 00 00 00       	jmp    800d52 <_main+0xd1a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800ca8:	a1 20 50 80 00       	mov    0x805020,%eax
  800cad:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800cb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800cb6:	89 d0                	mov    %edx,%eax
  800cb8:	01 c0                	add    %eax,%eax
  800cba:	01 d0                	add    %edx,%eax
  800cbc:	c1 e0 03             	shl    $0x3,%eax
  800cbf:	01 c8                	add    %ecx,%eax
  800cc1:	8b 00                	mov    (%eax),%eax
  800cc3:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800cc9:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800ccf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cd4:	89 c2                	mov    %eax,%edx
  800cd6:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800cdc:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800ce2:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800ce8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ced:	39 c2                	cmp    %eax,%edx
  800cef:	75 03                	jne    800cf4 <_main+0xcbc>
				found++;
  800cf1:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800cf4:	a1 20 50 80 00       	mov    0x805020,%eax
  800cf9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800cff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d02:	89 d0                	mov    %edx,%eax
  800d04:	01 c0                	add    %eax,%eax
  800d06:	01 d0                	add    %edx,%eax
  800d08:	c1 e0 03             	shl    $0x3,%eax
  800d0b:	01 c8                	add    %ecx,%eax
  800d0d:	8b 00                	mov    (%eax),%eax
  800d0f:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d15:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d20:	89 c2                	mov    %eax,%edx
  800d22:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d28:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d2f:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800d35:	01 c8                	add    %ecx,%eax
  800d37:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d3d:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d48:	39 c2                	cmp    %eax,%edx
  800d4a:	75 03                	jne    800d4f <_main+0xd17>
				found++;
  800d4c:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d4f:	ff 45 e4             	incl   -0x1c(%ebp)
  800d52:	a1 20 50 80 00       	mov    0x805020,%eax
  800d57:	8b 50 74             	mov    0x74(%eax),%edx
  800d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d5d:	39 c2                	cmp    %eax,%edx
  800d5f:	0f 87 43 ff ff ff    	ja     800ca8 <_main+0xc70>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800d65:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800d69:	74 17                	je     800d82 <_main+0xd4a>
  800d6b:	83 ec 04             	sub    $0x4,%esp
  800d6e:	68 78 46 80 00       	push   $0x804678
  800d73:	68 db 00 00 00       	push   $0xdb
  800d78:	68 41 45 80 00       	push   $0x804541
  800d7d:	e8 0d 08 00 00       	call   80158f <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d82:	e8 16 1e 00 00       	call   802b9d <sys_calculate_free_frames>
  800d87:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d8a:	e8 ae 1e 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800d8f:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800d92:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	83 ec 0c             	sub    $0xc,%esp
  800d9a:	50                   	push   %eax
  800d9b:	e8 cf 19 00 00       	call   80276f <malloc>
  800da0:	83 c4 10             	add    $0x10,%esp
  800da3:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800da9:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800daf:	89 c2                	mov    %eax,%edx
  800db1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db4:	c1 e0 02             	shl    $0x2,%eax
  800db7:	89 c1                	mov    %eax,%ecx
  800db9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800dbc:	c1 e0 02             	shl    $0x2,%eax
  800dbf:	01 c8                	add    %ecx,%eax
  800dc1:	05 00 00 00 80       	add    $0x80000000,%eax
  800dc6:	39 c2                	cmp    %eax,%edx
  800dc8:	72 21                	jb     800deb <_main+0xdb3>
  800dca:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800dd0:	89 c2                	mov    %eax,%edx
  800dd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dd5:	c1 e0 02             	shl    $0x2,%eax
  800dd8:	89 c1                	mov    %eax,%ecx
  800dda:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ddd:	c1 e0 02             	shl    $0x2,%eax
  800de0:	01 c8                	add    %ecx,%eax
  800de2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800de7:	39 c2                	cmp    %eax,%edx
  800de9:	76 17                	jbe    800e02 <_main+0xdca>
  800deb:	83 ec 04             	sub    $0x4,%esp
  800dee:	68 9c 45 80 00       	push   $0x80459c
  800df3:	68 e1 00 00 00       	push   $0xe1
  800df8:	68 41 45 80 00       	push   $0x804541
  800dfd:	e8 8d 07 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e02:	e8 36 1e 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800e07:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e0a:	83 f8 01             	cmp    $0x1,%eax
  800e0d:	74 17                	je     800e26 <_main+0xdee>
  800e0f:	83 ec 04             	sub    $0x4,%esp
  800e12:	68 04 46 80 00       	push   $0x804604
  800e17:	68 e2 00 00 00       	push   $0xe2
  800e1c:	68 41 45 80 00       	push   $0x804541
  800e21:	e8 69 07 00 00       	call   80158f <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e26:	e8 12 1e 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800e2b:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800e2e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	01 c0                	add    %eax,%eax
  800e39:	01 d0                	add    %edx,%eax
  800e3b:	83 ec 0c             	sub    $0xc,%esp
  800e3e:	50                   	push   %eax
  800e3f:	e8 2b 19 00 00       	call   80276f <malloc>
  800e44:	83 c4 10             	add    $0x10,%esp
  800e47:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800e4d:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e53:	89 c2                	mov    %eax,%edx
  800e55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e58:	c1 e0 02             	shl    $0x2,%eax
  800e5b:	89 c1                	mov    %eax,%ecx
  800e5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e60:	c1 e0 03             	shl    $0x3,%eax
  800e63:	01 c8                	add    %ecx,%eax
  800e65:	05 00 00 00 80       	add    $0x80000000,%eax
  800e6a:	39 c2                	cmp    %eax,%edx
  800e6c:	72 21                	jb     800e8f <_main+0xe57>
  800e6e:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e79:	c1 e0 02             	shl    $0x2,%eax
  800e7c:	89 c1                	mov    %eax,%ecx
  800e7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e81:	c1 e0 03             	shl    $0x3,%eax
  800e84:	01 c8                	add    %ecx,%eax
  800e86:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800e8b:	39 c2                	cmp    %eax,%edx
  800e8d:	76 17                	jbe    800ea6 <_main+0xe6e>
  800e8f:	83 ec 04             	sub    $0x4,%esp
  800e92:	68 9c 45 80 00       	push   $0x80459c
  800e97:	68 e8 00 00 00       	push   $0xe8
  800e9c:	68 41 45 80 00       	push   $0x804541
  800ea1:	e8 e9 06 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ea6:	e8 92 1d 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800eab:	2b 45 90             	sub    -0x70(%ebp),%eax
  800eae:	83 f8 02             	cmp    $0x2,%eax
  800eb1:	74 17                	je     800eca <_main+0xe92>
  800eb3:	83 ec 04             	sub    $0x4,%esp
  800eb6:	68 04 46 80 00       	push   $0x804604
  800ebb:	68 e9 00 00 00       	push   $0xe9
  800ec0:	68 41 45 80 00       	push   $0x804541
  800ec5:	e8 c5 06 00 00       	call   80158f <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800eca:	e8 ce 1c 00 00       	call   802b9d <sys_calculate_free_frames>
  800ecf:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800ed2:	e8 66 1d 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800ed7:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800eda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edd:	89 c2                	mov    %eax,%edx
  800edf:	01 d2                	add    %edx,%edx
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800ee6:	83 ec 0c             	sub    $0xc,%esp
  800ee9:	50                   	push   %eax
  800eea:	e8 80 18 00 00       	call   80276f <malloc>
  800eef:	83 c4 10             	add    $0x10,%esp
  800ef2:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800ef8:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800efe:	89 c2                	mov    %eax,%edx
  800f00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f03:	c1 e0 02             	shl    $0x2,%eax
  800f06:	89 c1                	mov    %eax,%ecx
  800f08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f0b:	c1 e0 04             	shl    $0x4,%eax
  800f0e:	01 c8                	add    %ecx,%eax
  800f10:	05 00 00 00 80       	add    $0x80000000,%eax
  800f15:	39 c2                	cmp    %eax,%edx
  800f17:	72 21                	jb     800f3a <_main+0xf02>
  800f19:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800f1f:	89 c2                	mov    %eax,%edx
  800f21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f24:	c1 e0 02             	shl    $0x2,%eax
  800f27:	89 c1                	mov    %eax,%ecx
  800f29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f2c:	c1 e0 04             	shl    $0x4,%eax
  800f2f:	01 c8                	add    %ecx,%eax
  800f31:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800f36:	39 c2                	cmp    %eax,%edx
  800f38:	76 17                	jbe    800f51 <_main+0xf19>
  800f3a:	83 ec 04             	sub    $0x4,%esp
  800f3d:	68 9c 45 80 00       	push   $0x80459c
  800f42:	68 f0 00 00 00       	push   $0xf0
  800f47:	68 41 45 80 00       	push   $0x804541
  800f4c:	e8 3e 06 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f51:	e8 e7 1c 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800f56:	2b 45 90             	sub    -0x70(%ebp),%eax
  800f59:	89 c2                	mov    %eax,%edx
  800f5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f5e:	89 c1                	mov    %eax,%ecx
  800f60:	01 c9                	add    %ecx,%ecx
  800f62:	01 c8                	add    %ecx,%eax
  800f64:	85 c0                	test   %eax,%eax
  800f66:	79 05                	jns    800f6d <_main+0xf35>
  800f68:	05 ff 0f 00 00       	add    $0xfff,%eax
  800f6d:	c1 f8 0c             	sar    $0xc,%eax
  800f70:	39 c2                	cmp    %eax,%edx
  800f72:	74 17                	je     800f8b <_main+0xf53>
  800f74:	83 ec 04             	sub    $0x4,%esp
  800f77:	68 04 46 80 00       	push   $0x804604
  800f7c:	68 f1 00 00 00       	push   $0xf1
  800f81:	68 41 45 80 00       	push   $0x804541
  800f86:	e8 04 06 00 00       	call   80158f <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8b:	e8 ad 1c 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800f90:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800f93:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f96:	89 d0                	mov    %edx,%eax
  800f98:	01 c0                	add    %eax,%eax
  800f9a:	01 d0                	add    %edx,%eax
  800f9c:	01 c0                	add    %eax,%eax
  800f9e:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800fa1:	83 ec 0c             	sub    $0xc,%esp
  800fa4:	50                   	push   %eax
  800fa5:	e8 c5 17 00 00       	call   80276f <malloc>
  800faa:	83 c4 10             	add    $0x10,%esp
  800fad:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800fb3:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800fb9:	89 c1                	mov    %eax,%ecx
  800fbb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	01 c0                	add    %eax,%eax
  800fc2:	01 d0                	add    %edx,%eax
  800fc4:	01 c0                	add    %eax,%eax
  800fc6:	01 d0                	add    %edx,%eax
  800fc8:	89 c2                	mov    %eax,%edx
  800fca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcd:	c1 e0 04             	shl    $0x4,%eax
  800fd0:	01 d0                	add    %edx,%eax
  800fd2:	05 00 00 00 80       	add    $0x80000000,%eax
  800fd7:	39 c1                	cmp    %eax,%ecx
  800fd9:	72 28                	jb     801003 <_main+0xfcb>
  800fdb:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800fe1:	89 c1                	mov    %eax,%ecx
  800fe3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fe6:	89 d0                	mov    %edx,%eax
  800fe8:	01 c0                	add    %eax,%eax
  800fea:	01 d0                	add    %edx,%eax
  800fec:	01 c0                	add    %eax,%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	89 c2                	mov    %eax,%edx
  800ff2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ff5:	c1 e0 04             	shl    $0x4,%eax
  800ff8:	01 d0                	add    %edx,%eax
  800ffa:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800fff:	39 c1                	cmp    %eax,%ecx
  801001:	76 17                	jbe    80101a <_main+0xfe2>
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	68 9c 45 80 00       	push   $0x80459c
  80100b:	68 f7 00 00 00       	push   $0xf7
  801010:	68 41 45 80 00       	push   $0x804541
  801015:	e8 75 05 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  80101a:	e8 1e 1c 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  80101f:	2b 45 90             	sub    -0x70(%ebp),%eax
  801022:	89 c1                	mov    %eax,%ecx
  801024:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801027:	89 d0                	mov    %edx,%eax
  801029:	01 c0                	add    %eax,%eax
  80102b:	01 d0                	add    %edx,%eax
  80102d:	01 c0                	add    %eax,%eax
  80102f:	85 c0                	test   %eax,%eax
  801031:	79 05                	jns    801038 <_main+0x1000>
  801033:	05 ff 0f 00 00       	add    $0xfff,%eax
  801038:	c1 f8 0c             	sar    $0xc,%eax
  80103b:	39 c1                	cmp    %eax,%ecx
  80103d:	74 17                	je     801056 <_main+0x101e>
  80103f:	83 ec 04             	sub    $0x4,%esp
  801042:	68 04 46 80 00       	push   $0x804604
  801047:	68 f8 00 00 00       	push   $0xf8
  80104c:	68 41 45 80 00       	push   $0x804541
  801051:	e8 39 05 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801056:	e8 42 1b 00 00       	call   802b9d <sys_calculate_free_frames>
  80105b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  80105e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801061:	89 d0                	mov    %edx,%eax
  801063:	01 c0                	add    %eax,%eax
  801065:	01 d0                	add    %edx,%eax
  801067:	01 c0                	add    %eax,%eax
  801069:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80106c:	48                   	dec    %eax
  80106d:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  801073:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  801079:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
		byteArr2[0] = minByte ;
  80107f:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801085:	8a 55 cf             	mov    -0x31(%ebp),%dl
  801088:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  80108a:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  801090:	89 c2                	mov    %eax,%edx
  801092:	c1 ea 1f             	shr    $0x1f,%edx
  801095:	01 d0                	add    %edx,%eax
  801097:	d1 f8                	sar    %eax
  801099:	89 c2                	mov    %eax,%edx
  80109b:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010a1:	01 c2                	add    %eax,%edx
  8010a3:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010a6:	88 c1                	mov    %al,%cl
  8010a8:	c0 e9 07             	shr    $0x7,%cl
  8010ab:	01 c8                	add    %ecx,%eax
  8010ad:	d0 f8                	sar    %al
  8010af:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  8010b1:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8010b7:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010bd:	01 c2                	add    %eax,%edx
  8010bf:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010c2:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8010c4:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8010c7:	e8 d1 1a 00 00       	call   802b9d <sys_calculate_free_frames>
  8010cc:	29 c3                	sub    %eax,%ebx
  8010ce:	89 d8                	mov    %ebx,%eax
  8010d0:	83 f8 05             	cmp    $0x5,%eax
  8010d3:	74 17                	je     8010ec <_main+0x10b4>
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	68 34 46 80 00       	push   $0x804634
  8010dd:	68 00 01 00 00       	push   $0x100
  8010e2:	68 41 45 80 00       	push   $0x804541
  8010e7:	e8 a3 04 00 00       	call   80158f <_panic>
		found = 0;
  8010ec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8010f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8010fa:	e9 02 01 00 00       	jmp    801201 <_main+0x11c9>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  8010ff:	a1 20 50 80 00       	mov    0x805020,%eax
  801104:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80110a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80110d:	89 d0                	mov    %edx,%eax
  80110f:	01 c0                	add    %eax,%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	c1 e0 03             	shl    $0x3,%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8b 00                	mov    (%eax),%eax
  80111a:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  801120:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801126:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80112b:	89 c2                	mov    %eax,%edx
  80112d:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801133:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801139:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80113f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801144:	39 c2                	cmp    %eax,%edx
  801146:	75 03                	jne    80114b <_main+0x1113>
				found++;
  801148:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  80114b:	a1 20 50 80 00       	mov    0x805020,%eax
  801150:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801156:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801159:	89 d0                	mov    %edx,%eax
  80115b:	01 c0                	add    %eax,%eax
  80115d:	01 d0                	add    %edx,%eax
  80115f:	c1 e0 03             	shl    $0x3,%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8b 00                	mov    (%eax),%eax
  801166:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  80116c:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801172:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801177:	89 c2                	mov    %eax,%edx
  801179:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  80117f:	89 c1                	mov    %eax,%ecx
  801181:	c1 e9 1f             	shr    $0x1f,%ecx
  801184:	01 c8                	add    %ecx,%eax
  801186:	d1 f8                	sar    %eax
  801188:	89 c1                	mov    %eax,%ecx
  80118a:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801190:	01 c8                	add    %ecx,%eax
  801192:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  801198:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  80119e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a3:	39 c2                	cmp    %eax,%edx
  8011a5:	75 03                	jne    8011aa <_main+0x1172>
				found++;
  8011a7:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  8011aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8011af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8011b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011b8:	89 d0                	mov    %edx,%eax
  8011ba:	01 c0                	add    %eax,%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	c1 e0 03             	shl    $0x3,%eax
  8011c1:	01 c8                	add    %ecx,%eax
  8011c3:	8b 00                	mov    (%eax),%eax
  8011c5:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  8011cb:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  8011d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d6:	89 c1                	mov    %eax,%ecx
  8011d8:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8011de:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  8011ec:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8011f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f7:	39 c1                	cmp    %eax,%ecx
  8011f9:	75 03                	jne    8011fe <_main+0x11c6>
				found++;
  8011fb:	ff 45 d8             	incl   -0x28(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8011fe:	ff 45 e4             	incl   -0x1c(%ebp)
  801201:	a1 20 50 80 00       	mov    0x805020,%eax
  801206:	8b 50 74             	mov    0x74(%eax),%edx
  801209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80120c:	39 c2                	cmp    %eax,%edx
  80120e:	0f 87 eb fe ff ff    	ja     8010ff <_main+0x10c7>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  801214:	83 7d d8 03          	cmpl   $0x3,-0x28(%ebp)
  801218:	74 17                	je     801231 <_main+0x11f9>
  80121a:	83 ec 04             	sub    $0x4,%esp
  80121d:	68 78 46 80 00       	push   $0x804678
  801222:	68 0b 01 00 00       	push   $0x10b
  801227:	68 41 45 80 00       	push   $0x804541
  80122c:	e8 5e 03 00 00       	call   80158f <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801231:	e8 07 1a 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  801236:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  801239:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80123c:	89 d0                	mov    %edx,%eax
  80123e:	01 c0                	add    %eax,%eax
  801240:	01 d0                	add    %edx,%eax
  801242:	01 c0                	add    %eax,%eax
  801244:	01 d0                	add    %edx,%eax
  801246:	01 c0                	add    %eax,%eax
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	50                   	push   %eax
  80124c:	e8 1e 15 00 00       	call   80276f <malloc>
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80125a:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  801260:	89 c1                	mov    %eax,%ecx
  801262:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801265:	89 d0                	mov    %edx,%eax
  801267:	01 c0                	add    %eax,%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c1 e0 02             	shl    $0x2,%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	89 c2                	mov    %eax,%edx
  801272:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801275:	c1 e0 04             	shl    $0x4,%eax
  801278:	01 d0                	add    %edx,%eax
  80127a:	05 00 00 00 80       	add    $0x80000000,%eax
  80127f:	39 c1                	cmp    %eax,%ecx
  801281:	72 29                	jb     8012ac <_main+0x1274>
  801283:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  801289:	89 c1                	mov    %eax,%ecx
  80128b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80128e:	89 d0                	mov    %edx,%eax
  801290:	01 c0                	add    %eax,%eax
  801292:	01 d0                	add    %edx,%eax
  801294:	c1 e0 02             	shl    $0x2,%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	89 c2                	mov    %eax,%edx
  80129b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80129e:	c1 e0 04             	shl    $0x4,%eax
  8012a1:	01 d0                	add    %edx,%eax
  8012a3:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8012a8:	39 c1                	cmp    %eax,%ecx
  8012aa:	76 17                	jbe    8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 9c 45 80 00       	push   $0x80459c
  8012b4:	68 10 01 00 00       	push   $0x110
  8012b9:	68 41 45 80 00       	push   $0x804541
  8012be:	e8 cc 02 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012c3:	e8 75 19 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  8012c8:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012cb:	83 f8 04             	cmp    $0x4,%eax
  8012ce:	74 17                	je     8012e7 <_main+0x12af>
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 04 46 80 00       	push   $0x804604
  8012d8:	68 11 01 00 00       	push   $0x111
  8012dd:	68 41 45 80 00       	push   $0x804541
  8012e2:	e8 a8 02 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8012e7:	e8 b1 18 00 00       	call   802b9d <sys_calculate_free_frames>
  8012ec:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  8012ef:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  8012f5:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  8012fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	01 c0                	add    %eax,%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	01 c0                	add    %eax,%eax
  801306:	01 d0                	add    %edx,%eax
  801308:	01 c0                	add    %eax,%eax
  80130a:	d1 e8                	shr    %eax
  80130c:	48                   	dec    %eax
  80130d:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		shortArr2[0] = minShort;
  801313:	8b 95 10 ff ff ff    	mov    -0xf0(%ebp),%edx
  801319:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80131c:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  80131f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801325:	01 c0                	add    %eax,%eax
  801327:	89 c2                	mov    %eax,%edx
  801329:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  80132f:	01 c2                	add    %eax,%edx
  801331:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  801335:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  801338:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  80133b:	e8 5d 18 00 00       	call   802b9d <sys_calculate_free_frames>
  801340:	29 c3                	sub    %eax,%ebx
  801342:	89 d8                	mov    %ebx,%eax
  801344:	83 f8 02             	cmp    $0x2,%eax
  801347:	74 17                	je     801360 <_main+0x1328>
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	68 34 46 80 00       	push   $0x804634
  801351:	68 18 01 00 00       	push   $0x118
  801356:	68 41 45 80 00       	push   $0x804541
  80135b:	e8 2f 02 00 00       	call   80158f <_panic>
		found = 0;
  801360:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801367:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80136e:	e9 a7 00 00 00       	jmp    80141a <_main+0x13e2>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  801373:	a1 20 50 80 00       	mov    0x805020,%eax
  801378:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80137e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801381:	89 d0                	mov    %edx,%eax
  801383:	01 c0                	add    %eax,%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	c1 e0 03             	shl    $0x3,%eax
  80138a:	01 c8                	add    %ecx,%eax
  80138c:	8b 00                	mov    (%eax),%eax
  80138e:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801394:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80139a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139f:	89 c2                	mov    %eax,%edx
  8013a1:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8013a7:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  8013ad:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8013b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b8:	39 c2                	cmp    %eax,%edx
  8013ba:	75 03                	jne    8013bf <_main+0x1387>
				found++;
  8013bc:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  8013bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8013c4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013cd:	89 d0                	mov    %edx,%eax
  8013cf:	01 c0                	add    %eax,%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	c1 e0 03             	shl    $0x3,%eax
  8013d6:	01 c8                	add    %ecx,%eax
  8013d8:	8b 00                	mov    (%eax),%eax
  8013da:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  8013e0:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  8013e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013eb:	89 c2                	mov    %eax,%edx
  8013ed:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8013f3:	01 c0                	add    %eax,%eax
  8013f5:	89 c1                	mov    %eax,%ecx
  8013f7:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8013fd:	01 c8                	add    %ecx,%eax
  8013ff:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801405:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  80140b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801410:	39 c2                	cmp    %eax,%edx
  801412:	75 03                	jne    801417 <_main+0x13df>
				found++;
  801414:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801417:	ff 45 e4             	incl   -0x1c(%ebp)
  80141a:	a1 20 50 80 00       	mov    0x805020,%eax
  80141f:	8b 50 74             	mov    0x74(%eax),%edx
  801422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801425:	39 c2                	cmp    %eax,%edx
  801427:	0f 87 46 ff ff ff    	ja     801373 <_main+0x133b>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80142d:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  801431:	74 17                	je     80144a <_main+0x1412>
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	68 78 46 80 00       	push   $0x804678
  80143b:	68 21 01 00 00       	push   $0x121
  801440:	68 41 45 80 00       	push   $0x804541
  801445:	e8 45 01 00 00       	call   80158f <_panic>
		if(start_freeFrames != (sys_calculate_free_frames() + 4)) {panic("Wrong free: not all pages removed correctly at end");}
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
	 */
	return;
  80144a:	90                   	nop
}
  80144b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144e:	5b                   	pop    %ebx
  80144f:	5e                   	pop    %esi
  801450:	5f                   	pop    %edi
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801459:	e8 1f 1a 00 00       	call   802e7d <sys_getenvindex>
  80145e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  801461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801464:	89 d0                	mov    %edx,%eax
  801466:	c1 e0 03             	shl    $0x3,%eax
  801469:	01 d0                	add    %edx,%eax
  80146b:	01 c0                	add    %eax,%eax
  80146d:	01 d0                	add    %edx,%eax
  80146f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801476:	01 d0                	add    %edx,%eax
  801478:	c1 e0 04             	shl    $0x4,%eax
  80147b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801480:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801485:	a1 20 50 80 00       	mov    0x805020,%eax
  80148a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  801490:	84 c0                	test   %al,%al
  801492:	74 0f                	je     8014a3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  801494:	a1 20 50 80 00       	mov    0x805020,%eax
  801499:	05 5c 05 00 00       	add    $0x55c,%eax
  80149e:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8014a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a7:	7e 0a                	jle    8014b3 <libmain+0x60>
		binaryname = argv[0];
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8014b3:	83 ec 08             	sub    $0x8,%esp
  8014b6:	ff 75 0c             	pushl  0xc(%ebp)
  8014b9:	ff 75 08             	pushl  0x8(%ebp)
  8014bc:	e8 77 eb ff ff       	call   800038 <_main>
  8014c1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8014c4:	e8 c1 17 00 00       	call   802c8a <sys_disable_interrupt>
	cprintf("**************************************\n");
  8014c9:	83 ec 0c             	sub    $0xc,%esp
  8014cc:	68 9c 47 80 00       	push   $0x80479c
  8014d1:	e8 6d 03 00 00       	call   801843 <cprintf>
  8014d6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8014de:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8014e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8014e9:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	52                   	push   %edx
  8014f3:	50                   	push   %eax
  8014f4:	68 c4 47 80 00       	push   $0x8047c4
  8014f9:	e8 45 03 00 00       	call   801843 <cprintf>
  8014fe:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801501:	a1 20 50 80 00       	mov    0x805020,%eax
  801506:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80150c:	a1 20 50 80 00       	mov    0x805020,%eax
  801511:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  801517:	a1 20 50 80 00       	mov    0x805020,%eax
  80151c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  801522:	51                   	push   %ecx
  801523:	52                   	push   %edx
  801524:	50                   	push   %eax
  801525:	68 ec 47 80 00       	push   $0x8047ec
  80152a:	e8 14 03 00 00       	call   801843 <cprintf>
  80152f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801532:	a1 20 50 80 00       	mov    0x805020,%eax
  801537:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80153d:	83 ec 08             	sub    $0x8,%esp
  801540:	50                   	push   %eax
  801541:	68 44 48 80 00       	push   $0x804844
  801546:	e8 f8 02 00 00       	call   801843 <cprintf>
  80154b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80154e:	83 ec 0c             	sub    $0xc,%esp
  801551:	68 9c 47 80 00       	push   $0x80479c
  801556:	e8 e8 02 00 00       	call   801843 <cprintf>
  80155b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80155e:	e8 41 17 00 00       	call   802ca4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  801563:	e8 19 00 00 00       	call   801581 <exit>
}
  801568:	90                   	nop
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	6a 00                	push   $0x0
  801576:	e8 ce 18 00 00       	call   802e49 <sys_destroy_env>
  80157b:	83 c4 10             	add    $0x10,%esp
}
  80157e:	90                   	nop
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <exit>:

void
exit(void)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801587:	e8 23 19 00 00       	call   802eaf <sys_exit_env>
}
  80158c:	90                   	nop
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801595:	8d 45 10             	lea    0x10(%ebp),%eax
  801598:	83 c0 04             	add    $0x4,%eax
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80159e:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	74 16                	je     8015bd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015a7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8015ac:	83 ec 08             	sub    $0x8,%esp
  8015af:	50                   	push   %eax
  8015b0:	68 58 48 80 00       	push   $0x804858
  8015b5:	e8 89 02 00 00       	call   801843 <cprintf>
  8015ba:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015bd:	a1 00 50 80 00       	mov    0x805000,%eax
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	ff 75 08             	pushl  0x8(%ebp)
  8015c8:	50                   	push   %eax
  8015c9:	68 5d 48 80 00       	push   $0x80485d
  8015ce:	e8 70 02 00 00       	call   801843 <cprintf>
  8015d3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8015d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015df:	50                   	push   %eax
  8015e0:	e8 f3 01 00 00       	call   8017d8 <vcprintf>
  8015e5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8015e8:	83 ec 08             	sub    $0x8,%esp
  8015eb:	6a 00                	push   $0x0
  8015ed:	68 79 48 80 00       	push   $0x804879
  8015f2:	e8 e1 01 00 00       	call   8017d8 <vcprintf>
  8015f7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8015fa:	e8 82 ff ff ff       	call   801581 <exit>

	// should not return here
	while (1) ;
  8015ff:	eb fe                	jmp    8015ff <_panic+0x70>

00801601 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801607:	a1 20 50 80 00       	mov    0x805020,%eax
  80160c:	8b 50 74             	mov    0x74(%eax),%edx
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	39 c2                	cmp    %eax,%edx
  801614:	74 14                	je     80162a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801616:	83 ec 04             	sub    $0x4,%esp
  801619:	68 7c 48 80 00       	push   $0x80487c
  80161e:	6a 26                	push   $0x26
  801620:	68 c8 48 80 00       	push   $0x8048c8
  801625:	e8 65 ff ff ff       	call   80158f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80162a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801631:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801638:	e9 c2 00 00 00       	jmp    8016ff <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80163d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801640:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	01 d0                	add    %edx,%eax
  80164c:	8b 00                	mov    (%eax),%eax
  80164e:	85 c0                	test   %eax,%eax
  801650:	75 08                	jne    80165a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801652:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801655:	e9 a2 00 00 00       	jmp    8016fc <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80165a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801661:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801668:	eb 69                	jmp    8016d3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80166a:	a1 20 50 80 00       	mov    0x805020,%eax
  80166f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801675:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801678:	89 d0                	mov    %edx,%eax
  80167a:	01 c0                	add    %eax,%eax
  80167c:	01 d0                	add    %edx,%eax
  80167e:	c1 e0 03             	shl    $0x3,%eax
  801681:	01 c8                	add    %ecx,%eax
  801683:	8a 40 04             	mov    0x4(%eax),%al
  801686:	84 c0                	test   %al,%al
  801688:	75 46                	jne    8016d0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80168a:	a1 20 50 80 00       	mov    0x805020,%eax
  80168f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801695:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801698:	89 d0                	mov    %edx,%eax
  80169a:	01 c0                	add    %eax,%eax
  80169c:	01 d0                	add    %edx,%eax
  80169e:	c1 e0 03             	shl    $0x3,%eax
  8016a1:	01 c8                	add    %ecx,%eax
  8016a3:	8b 00                	mov    (%eax),%eax
  8016a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	01 c8                	add    %ecx,%eax
  8016c1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016c3:	39 c2                	cmp    %eax,%edx
  8016c5:	75 09                	jne    8016d0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8016c7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016ce:	eb 12                	jmp    8016e2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016d0:	ff 45 e8             	incl   -0x18(%ebp)
  8016d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8016d8:	8b 50 74             	mov    0x74(%eax),%edx
  8016db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016de:	39 c2                	cmp    %eax,%edx
  8016e0:	77 88                	ja     80166a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8016e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e6:	75 14                	jne    8016fc <CheckWSWithoutLastIndex+0xfb>
			panic(
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	68 d4 48 80 00       	push   $0x8048d4
  8016f0:	6a 3a                	push   $0x3a
  8016f2:	68 c8 48 80 00       	push   $0x8048c8
  8016f7:	e8 93 fe ff ff       	call   80158f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8016fc:	ff 45 f0             	incl   -0x10(%ebp)
  8016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801702:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801705:	0f 8c 32 ff ff ff    	jl     80163d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80170b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801712:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801719:	eb 26                	jmp    801741 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80171b:	a1 20 50 80 00       	mov    0x805020,%eax
  801720:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801726:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801729:	89 d0                	mov    %edx,%eax
  80172b:	01 c0                	add    %eax,%eax
  80172d:	01 d0                	add    %edx,%eax
  80172f:	c1 e0 03             	shl    $0x3,%eax
  801732:	01 c8                	add    %ecx,%eax
  801734:	8a 40 04             	mov    0x4(%eax),%al
  801737:	3c 01                	cmp    $0x1,%al
  801739:	75 03                	jne    80173e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80173b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80173e:	ff 45 e0             	incl   -0x20(%ebp)
  801741:	a1 20 50 80 00       	mov    0x805020,%eax
  801746:	8b 50 74             	mov    0x74(%eax),%edx
  801749:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80174c:	39 c2                	cmp    %eax,%edx
  80174e:	77 cb                	ja     80171b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801753:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801756:	74 14                	je     80176c <CheckWSWithoutLastIndex+0x16b>
		panic(
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	68 28 49 80 00       	push   $0x804928
  801760:	6a 44                	push   $0x44
  801762:	68 c8 48 80 00       	push   $0x8048c8
  801767:	e8 23 fe ff ff       	call   80158f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80176c:	90                   	nop
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801775:	8b 45 0c             	mov    0xc(%ebp),%eax
  801778:	8b 00                	mov    (%eax),%eax
  80177a:	8d 48 01             	lea    0x1(%eax),%ecx
  80177d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801780:	89 0a                	mov    %ecx,(%edx)
  801782:	8b 55 08             	mov    0x8(%ebp),%edx
  801785:	88 d1                	mov    %dl,%cl
  801787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80178e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801791:	8b 00                	mov    (%eax),%eax
  801793:	3d ff 00 00 00       	cmp    $0xff,%eax
  801798:	75 2c                	jne    8017c6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80179a:	a0 24 50 80 00       	mov    0x805024,%al
  80179f:	0f b6 c0             	movzbl %al,%eax
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	8b 12                	mov    (%edx),%edx
  8017a7:	89 d1                	mov    %edx,%ecx
  8017a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ac:	83 c2 08             	add    $0x8,%edx
  8017af:	83 ec 04             	sub    $0x4,%esp
  8017b2:	50                   	push   %eax
  8017b3:	51                   	push   %ecx
  8017b4:	52                   	push   %edx
  8017b5:	e8 22 13 00 00       	call   802adc <sys_cputs>
  8017ba:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	8b 40 04             	mov    0x4(%eax),%eax
  8017cc:	8d 50 01             	lea    0x1(%eax),%edx
  8017cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8017d5:	90                   	nop
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8017e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017e8:	00 00 00 
	b.cnt = 0;
  8017eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8017f2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	ff 75 08             	pushl  0x8(%ebp)
  8017fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801801:	50                   	push   %eax
  801802:	68 6f 17 80 00       	push   $0x80176f
  801807:	e8 11 02 00 00       	call   801a1d <vprintfmt>
  80180c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80180f:	a0 24 50 80 00       	mov    0x805024,%al
  801814:	0f b6 c0             	movzbl %al,%eax
  801817:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	50                   	push   %eax
  801821:	52                   	push   %edx
  801822:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801828:	83 c0 08             	add    $0x8,%eax
  80182b:	50                   	push   %eax
  80182c:	e8 ab 12 00 00       	call   802adc <sys_cputs>
  801831:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801834:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80183b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <cprintf>:

int cprintf(const char *fmt, ...) {
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801849:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801850:	8d 45 0c             	lea    0xc(%ebp),%eax
  801853:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	ff 75 f4             	pushl  -0xc(%ebp)
  80185f:	50                   	push   %eax
  801860:	e8 73 ff ff ff       	call   8017d8 <vcprintf>
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801876:	e8 0f 14 00 00       	call   802c8a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80187b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	83 ec 08             	sub    $0x8,%esp
  801887:	ff 75 f4             	pushl  -0xc(%ebp)
  80188a:	50                   	push   %eax
  80188b:	e8 48 ff ff ff       	call   8017d8 <vcprintf>
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801896:	e8 09 14 00 00       	call   802ca4 <sys_enable_interrupt>
	return cnt;
  80189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 14             	sub    $0x14,%esp
  8018a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018b3:	8b 45 18             	mov    0x18(%ebp),%eax
  8018b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018be:	77 55                	ja     801915 <printnum+0x75>
  8018c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018c3:	72 05                	jb     8018ca <printnum+0x2a>
  8018c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018c8:	77 4b                	ja     801915 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8018ca:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8018cd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8018d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	ff 75 f4             	pushl  -0xc(%ebp)
  8018dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e0:	e8 b3 29 00 00       	call   804298 <__udivdi3>
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	ff 75 20             	pushl  0x20(%ebp)
  8018ee:	53                   	push   %ebx
  8018ef:	ff 75 18             	pushl  0x18(%ebp)
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	e8 a1 ff ff ff       	call   8018a0 <printnum>
  8018ff:	83 c4 20             	add    $0x20,%esp
  801902:	eb 1a                	jmp    80191e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	ff 75 20             	pushl  0x20(%ebp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	ff d0                	call   *%eax
  801912:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801915:	ff 4d 1c             	decl   0x1c(%ebp)
  801918:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80191c:	7f e6                	jg     801904 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80191e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801921:	bb 00 00 00 00       	mov    $0x0,%ebx
  801926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192c:	53                   	push   %ebx
  80192d:	51                   	push   %ecx
  80192e:	52                   	push   %edx
  80192f:	50                   	push   %eax
  801930:	e8 73 2a 00 00       	call   8043a8 <__umoddi3>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	05 94 4b 80 00       	add    $0x804b94,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	0f be c0             	movsbl %al,%eax
  801942:	83 ec 08             	sub    $0x8,%esp
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	50                   	push   %eax
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	ff d0                	call   *%eax
  80194e:	83 c4 10             	add    $0x10,%esp
}
  801951:	90                   	nop
  801952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80195a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80195e:	7e 1c                	jle    80197c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	8b 00                	mov    (%eax),%eax
  801965:	8d 50 08             	lea    0x8(%eax),%edx
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	89 10                	mov    %edx,(%eax)
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	83 e8 08             	sub    $0x8,%eax
  801975:	8b 50 04             	mov    0x4(%eax),%edx
  801978:	8b 00                	mov    (%eax),%eax
  80197a:	eb 40                	jmp    8019bc <getuint+0x65>
	else if (lflag)
  80197c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801980:	74 1e                	je     8019a0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	8b 00                	mov    (%eax),%eax
  801987:	8d 50 04             	lea    0x4(%eax),%edx
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	89 10                	mov    %edx,(%eax)
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	8b 00                	mov    (%eax),%eax
  801994:	83 e8 04             	sub    $0x4,%eax
  801997:	8b 00                	mov    (%eax),%eax
  801999:	ba 00 00 00 00       	mov    $0x0,%edx
  80199e:	eb 1c                	jmp    8019bc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	8b 00                	mov    (%eax),%eax
  8019a5:	8d 50 04             	lea    0x4(%eax),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	89 10                	mov    %edx,(%eax)
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8b 00                	mov    (%eax),%eax
  8019b2:	83 e8 04             	sub    $0x4,%eax
  8019b5:	8b 00                	mov    (%eax),%eax
  8019b7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019bc:	5d                   	pop    %ebp
  8019bd:	c3                   	ret    

008019be <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019c5:	7e 1c                	jle    8019e3 <getint+0x25>
		return va_arg(*ap, long long);
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8b 00                	mov    (%eax),%eax
  8019cc:	8d 50 08             	lea    0x8(%eax),%edx
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	89 10                	mov    %edx,(%eax)
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	8b 00                	mov    (%eax),%eax
  8019d9:	83 e8 08             	sub    $0x8,%eax
  8019dc:	8b 50 04             	mov    0x4(%eax),%edx
  8019df:	8b 00                	mov    (%eax),%eax
  8019e1:	eb 38                	jmp    801a1b <getint+0x5d>
	else if (lflag)
  8019e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019e7:	74 1a                	je     801a03 <getint+0x45>
		return va_arg(*ap, long);
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8b 00                	mov    (%eax),%eax
  8019ee:	8d 50 04             	lea    0x4(%eax),%edx
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	89 10                	mov    %edx,(%eax)
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8b 00                	mov    (%eax),%eax
  8019fb:	83 e8 04             	sub    $0x4,%eax
  8019fe:	8b 00                	mov    (%eax),%eax
  801a00:	99                   	cltd   
  801a01:	eb 18                	jmp    801a1b <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	8b 00                	mov    (%eax),%eax
  801a08:	8d 50 04             	lea    0x4(%eax),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	89 10                	mov    %edx,(%eax)
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	8b 00                	mov    (%eax),%eax
  801a15:	83 e8 04             	sub    $0x4,%eax
  801a18:	8b 00                	mov    (%eax),%eax
  801a1a:	99                   	cltd   
}
  801a1b:	5d                   	pop    %ebp
  801a1c:	c3                   	ret    

00801a1d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	56                   	push   %esi
  801a21:	53                   	push   %ebx
  801a22:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a25:	eb 17                	jmp    801a3e <vprintfmt+0x21>
			if (ch == '\0')
  801a27:	85 db                	test   %ebx,%ebx
  801a29:	0f 84 af 03 00 00    	je     801dde <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	53                   	push   %ebx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	ff d0                	call   *%eax
  801a3b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a41:	8d 50 01             	lea    0x1(%eax),%edx
  801a44:	89 55 10             	mov    %edx,0x10(%ebp)
  801a47:	8a 00                	mov    (%eax),%al
  801a49:	0f b6 d8             	movzbl %al,%ebx
  801a4c:	83 fb 25             	cmp    $0x25,%ebx
  801a4f:	75 d6                	jne    801a27 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a51:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a55:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a5c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a63:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801a6a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a71:	8b 45 10             	mov    0x10(%ebp),%eax
  801a74:	8d 50 01             	lea    0x1(%eax),%edx
  801a77:	89 55 10             	mov    %edx,0x10(%ebp)
  801a7a:	8a 00                	mov    (%eax),%al
  801a7c:	0f b6 d8             	movzbl %al,%ebx
  801a7f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801a82:	83 f8 55             	cmp    $0x55,%eax
  801a85:	0f 87 2b 03 00 00    	ja     801db6 <vprintfmt+0x399>
  801a8b:	8b 04 85 b8 4b 80 00 	mov    0x804bb8(,%eax,4),%eax
  801a92:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801a94:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801a98:	eb d7                	jmp    801a71 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801a9a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801a9e:	eb d1                	jmp    801a71 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801aa0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801aa7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aaa:	89 d0                	mov    %edx,%eax
  801aac:	c1 e0 02             	shl    $0x2,%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	01 c0                	add    %eax,%eax
  801ab3:	01 d8                	add    %ebx,%eax
  801ab5:	83 e8 30             	sub    $0x30,%eax
  801ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801abb:	8b 45 10             	mov    0x10(%ebp),%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801ac3:	83 fb 2f             	cmp    $0x2f,%ebx
  801ac6:	7e 3e                	jle    801b06 <vprintfmt+0xe9>
  801ac8:	83 fb 39             	cmp    $0x39,%ebx
  801acb:	7f 39                	jg     801b06 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801acd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801ad0:	eb d5                	jmp    801aa7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801ad2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad5:	83 c0 04             	add    $0x4,%eax
  801ad8:	89 45 14             	mov    %eax,0x14(%ebp)
  801adb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ade:	83 e8 04             	sub    $0x4,%eax
  801ae1:	8b 00                	mov    (%eax),%eax
  801ae3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801ae6:	eb 1f                	jmp    801b07 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801ae8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aec:	79 83                	jns    801a71 <vprintfmt+0x54>
				width = 0;
  801aee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801af5:	e9 77 ff ff ff       	jmp    801a71 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801afa:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b01:	e9 6b ff ff ff       	jmp    801a71 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b06:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b0b:	0f 89 60 ff ff ff    	jns    801a71 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b17:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b1e:	e9 4e ff ff ff       	jmp    801a71 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b23:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b26:	e9 46 ff ff ff       	jmp    801a71 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2e:	83 c0 04             	add    $0x4,%eax
  801b31:	89 45 14             	mov    %eax,0x14(%ebp)
  801b34:	8b 45 14             	mov    0x14(%ebp),%eax
  801b37:	83 e8 04             	sub    $0x4,%eax
  801b3a:	8b 00                	mov    (%eax),%eax
  801b3c:	83 ec 08             	sub    $0x8,%esp
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	50                   	push   %eax
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	ff d0                	call   *%eax
  801b48:	83 c4 10             	add    $0x10,%esp
			break;
  801b4b:	e9 89 02 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b50:	8b 45 14             	mov    0x14(%ebp),%eax
  801b53:	83 c0 04             	add    $0x4,%eax
  801b56:	89 45 14             	mov    %eax,0x14(%ebp)
  801b59:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5c:	83 e8 04             	sub    $0x4,%eax
  801b5f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b61:	85 db                	test   %ebx,%ebx
  801b63:	79 02                	jns    801b67 <vprintfmt+0x14a>
				err = -err;
  801b65:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801b67:	83 fb 64             	cmp    $0x64,%ebx
  801b6a:	7f 0b                	jg     801b77 <vprintfmt+0x15a>
  801b6c:	8b 34 9d 00 4a 80 00 	mov    0x804a00(,%ebx,4),%esi
  801b73:	85 f6                	test   %esi,%esi
  801b75:	75 19                	jne    801b90 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801b77:	53                   	push   %ebx
  801b78:	68 a5 4b 80 00       	push   $0x804ba5
  801b7d:	ff 75 0c             	pushl  0xc(%ebp)
  801b80:	ff 75 08             	pushl  0x8(%ebp)
  801b83:	e8 5e 02 00 00       	call   801de6 <printfmt>
  801b88:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801b8b:	e9 49 02 00 00       	jmp    801dd9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801b90:	56                   	push   %esi
  801b91:	68 ae 4b 80 00       	push   $0x804bae
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	e8 45 02 00 00       	call   801de6 <printfmt>
  801ba1:	83 c4 10             	add    $0x10,%esp
			break;
  801ba4:	e9 30 02 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bac:	83 c0 04             	add    $0x4,%eax
  801baf:	89 45 14             	mov    %eax,0x14(%ebp)
  801bb2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb5:	83 e8 04             	sub    $0x4,%eax
  801bb8:	8b 30                	mov    (%eax),%esi
  801bba:	85 f6                	test   %esi,%esi
  801bbc:	75 05                	jne    801bc3 <vprintfmt+0x1a6>
				p = "(null)";
  801bbe:	be b1 4b 80 00       	mov    $0x804bb1,%esi
			if (width > 0 && padc != '-')
  801bc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bc7:	7e 6d                	jle    801c36 <vprintfmt+0x219>
  801bc9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801bcd:	74 67                	je     801c36 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd2:	83 ec 08             	sub    $0x8,%esp
  801bd5:	50                   	push   %eax
  801bd6:	56                   	push   %esi
  801bd7:	e8 0c 03 00 00       	call   801ee8 <strnlen>
  801bdc:	83 c4 10             	add    $0x10,%esp
  801bdf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801be2:	eb 16                	jmp    801bfa <vprintfmt+0x1dd>
					putch(padc, putdat);
  801be4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801be8:	83 ec 08             	sub    $0x8,%esp
  801beb:	ff 75 0c             	pushl  0xc(%ebp)
  801bee:	50                   	push   %eax
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	ff d0                	call   *%eax
  801bf4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801bf7:	ff 4d e4             	decl   -0x1c(%ebp)
  801bfa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bfe:	7f e4                	jg     801be4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c00:	eb 34                	jmp    801c36 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c02:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c06:	74 1c                	je     801c24 <vprintfmt+0x207>
  801c08:	83 fb 1f             	cmp    $0x1f,%ebx
  801c0b:	7e 05                	jle    801c12 <vprintfmt+0x1f5>
  801c0d:	83 fb 7e             	cmp    $0x7e,%ebx
  801c10:	7e 12                	jle    801c24 <vprintfmt+0x207>
					putch('?', putdat);
  801c12:	83 ec 08             	sub    $0x8,%esp
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	6a 3f                	push   $0x3f
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	ff d0                	call   *%eax
  801c1f:	83 c4 10             	add    $0x10,%esp
  801c22:	eb 0f                	jmp    801c33 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c24:	83 ec 08             	sub    $0x8,%esp
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	53                   	push   %ebx
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	ff d0                	call   *%eax
  801c30:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c33:	ff 4d e4             	decl   -0x1c(%ebp)
  801c36:	89 f0                	mov    %esi,%eax
  801c38:	8d 70 01             	lea    0x1(%eax),%esi
  801c3b:	8a 00                	mov    (%eax),%al
  801c3d:	0f be d8             	movsbl %al,%ebx
  801c40:	85 db                	test   %ebx,%ebx
  801c42:	74 24                	je     801c68 <vprintfmt+0x24b>
  801c44:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c48:	78 b8                	js     801c02 <vprintfmt+0x1e5>
  801c4a:	ff 4d e0             	decl   -0x20(%ebp)
  801c4d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c51:	79 af                	jns    801c02 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c53:	eb 13                	jmp    801c68 <vprintfmt+0x24b>
				putch(' ', putdat);
  801c55:	83 ec 08             	sub    $0x8,%esp
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	6a 20                	push   $0x20
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	ff d0                	call   *%eax
  801c62:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c65:	ff 4d e4             	decl   -0x1c(%ebp)
  801c68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c6c:	7f e7                	jg     801c55 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801c6e:	e9 66 01 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801c73:	83 ec 08             	sub    $0x8,%esp
  801c76:	ff 75 e8             	pushl  -0x18(%ebp)
  801c79:	8d 45 14             	lea    0x14(%ebp),%eax
  801c7c:	50                   	push   %eax
  801c7d:	e8 3c fd ff ff       	call   8019be <getint>
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c91:	85 d2                	test   %edx,%edx
  801c93:	79 23                	jns    801cb8 <vprintfmt+0x29b>
				putch('-', putdat);
  801c95:	83 ec 08             	sub    $0x8,%esp
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	6a 2d                	push   $0x2d
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	ff d0                	call   *%eax
  801ca2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cab:	f7 d8                	neg    %eax
  801cad:	83 d2 00             	adc    $0x0,%edx
  801cb0:	f7 da                	neg    %edx
  801cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801cb8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cbf:	e9 bc 00 00 00       	jmp    801d80 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801cc4:	83 ec 08             	sub    $0x8,%esp
  801cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  801cca:	8d 45 14             	lea    0x14(%ebp),%eax
  801ccd:	50                   	push   %eax
  801cce:	e8 84 fc ff ff       	call   801957 <getuint>
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801cdc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ce3:	e9 98 00 00 00       	jmp    801d80 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801ce8:	83 ec 08             	sub    $0x8,%esp
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	6a 58                	push   $0x58
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	ff d0                	call   *%eax
  801cf5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801cf8:	83 ec 08             	sub    $0x8,%esp
  801cfb:	ff 75 0c             	pushl  0xc(%ebp)
  801cfe:	6a 58                	push   $0x58
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	ff d0                	call   *%eax
  801d05:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d08:	83 ec 08             	sub    $0x8,%esp
  801d0b:	ff 75 0c             	pushl  0xc(%ebp)
  801d0e:	6a 58                	push   $0x58
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	ff d0                	call   *%eax
  801d15:	83 c4 10             	add    $0x10,%esp
			break;
  801d18:	e9 bc 00 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801d1d:	83 ec 08             	sub    $0x8,%esp
  801d20:	ff 75 0c             	pushl  0xc(%ebp)
  801d23:	6a 30                	push   $0x30
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	ff d0                	call   *%eax
  801d2a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d2d:	83 ec 08             	sub    $0x8,%esp
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	6a 78                	push   $0x78
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	ff d0                	call   *%eax
  801d3a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d40:	83 c0 04             	add    $0x4,%eax
  801d43:	89 45 14             	mov    %eax,0x14(%ebp)
  801d46:	8b 45 14             	mov    0x14(%ebp),%eax
  801d49:	83 e8 04             	sub    $0x4,%eax
  801d4c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d5f:	eb 1f                	jmp    801d80 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d61:	83 ec 08             	sub    $0x8,%esp
  801d64:	ff 75 e8             	pushl  -0x18(%ebp)
  801d67:	8d 45 14             	lea    0x14(%ebp),%eax
  801d6a:	50                   	push   %eax
  801d6b:	e8 e7 fb ff ff       	call   801957 <getuint>
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d76:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801d79:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d80:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801d84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d87:	83 ec 04             	sub    $0x4,%esp
  801d8a:	52                   	push   %edx
  801d8b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d8e:	50                   	push   %eax
  801d8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d92:	ff 75 f0             	pushl  -0x10(%ebp)
  801d95:	ff 75 0c             	pushl  0xc(%ebp)
  801d98:	ff 75 08             	pushl  0x8(%ebp)
  801d9b:	e8 00 fb ff ff       	call   8018a0 <printnum>
  801da0:	83 c4 20             	add    $0x20,%esp
			break;
  801da3:	eb 34                	jmp    801dd9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801da5:	83 ec 08             	sub    $0x8,%esp
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	53                   	push   %ebx
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	ff d0                	call   *%eax
  801db1:	83 c4 10             	add    $0x10,%esp
			break;
  801db4:	eb 23                	jmp    801dd9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801db6:	83 ec 08             	sub    $0x8,%esp
  801db9:	ff 75 0c             	pushl  0xc(%ebp)
  801dbc:	6a 25                	push   $0x25
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	ff d0                	call   *%eax
  801dc3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801dc6:	ff 4d 10             	decl   0x10(%ebp)
  801dc9:	eb 03                	jmp    801dce <vprintfmt+0x3b1>
  801dcb:	ff 4d 10             	decl   0x10(%ebp)
  801dce:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd1:	48                   	dec    %eax
  801dd2:	8a 00                	mov    (%eax),%al
  801dd4:	3c 25                	cmp    $0x25,%al
  801dd6:	75 f3                	jne    801dcb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801dd8:	90                   	nop
		}
	}
  801dd9:	e9 47 fc ff ff       	jmp    801a25 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801dde:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    

00801de6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801dec:	8d 45 10             	lea    0x10(%ebp),%eax
  801def:	83 c0 04             	add    $0x4,%eax
  801df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801df5:	8b 45 10             	mov    0x10(%ebp),%eax
  801df8:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfb:	50                   	push   %eax
  801dfc:	ff 75 0c             	pushl  0xc(%ebp)
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	e8 16 fc ff ff       	call   801a1d <vprintfmt>
  801e07:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e0a:	90                   	nop
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e13:	8b 40 08             	mov    0x8(%eax),%eax
  801e16:	8d 50 01             	lea    0x1(%eax),%edx
  801e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e22:	8b 10                	mov    (%eax),%edx
  801e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e27:	8b 40 04             	mov    0x4(%eax),%eax
  801e2a:	39 c2                	cmp    %eax,%edx
  801e2c:	73 12                	jae    801e40 <sprintputch+0x33>
		*b->buf++ = ch;
  801e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e31:	8b 00                	mov    (%eax),%eax
  801e33:	8d 48 01             	lea    0x1(%eax),%ecx
  801e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e39:	89 0a                	mov    %ecx,(%edx)
  801e3b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e3e:	88 10                	mov    %dl,(%eax)
}
  801e40:	90                   	nop
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    

00801e43 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e52:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	01 d0                	add    %edx,%eax
  801e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e68:	74 06                	je     801e70 <vsnprintf+0x2d>
  801e6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e6e:	7f 07                	jg     801e77 <vsnprintf+0x34>
		return -E_INVAL;
  801e70:	b8 03 00 00 00       	mov    $0x3,%eax
  801e75:	eb 20                	jmp    801e97 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801e77:	ff 75 14             	pushl  0x14(%ebp)
  801e7a:	ff 75 10             	pushl  0x10(%ebp)
  801e7d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e80:	50                   	push   %eax
  801e81:	68 0d 1e 80 00       	push   $0x801e0d
  801e86:	e8 92 fb ff ff       	call   801a1d <vprintfmt>
  801e8b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e91:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e9f:	8d 45 10             	lea    0x10(%ebp),%eax
  801ea2:	83 c0 04             	add    $0x4,%eax
  801ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	ff 75 f4             	pushl  -0xc(%ebp)
  801eae:	50                   	push   %eax
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	ff 75 08             	pushl  0x8(%ebp)
  801eb5:	e8 89 ff ff ff       	call   801e43 <vsnprintf>
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ecb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ed2:	eb 06                	jmp    801eda <strlen+0x15>
		n++;
  801ed4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ed7:	ff 45 08             	incl   0x8(%ebp)
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	8a 00                	mov    (%eax),%al
  801edf:	84 c0                	test   %al,%al
  801ee1:	75 f1                	jne    801ed4 <strlen+0xf>
		n++;
	return n;
  801ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801eee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ef5:	eb 09                	jmp    801f00 <strnlen+0x18>
		n++;
  801ef7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801efa:	ff 45 08             	incl   0x8(%ebp)
  801efd:	ff 4d 0c             	decl   0xc(%ebp)
  801f00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f04:	74 09                	je     801f0f <strnlen+0x27>
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	8a 00                	mov    (%eax),%al
  801f0b:	84 c0                	test   %al,%al
  801f0d:	75 e8                	jne    801ef7 <strnlen+0xf>
		n++;
	return n;
  801f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f20:	90                   	nop
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	8d 50 01             	lea    0x1(%eax),%edx
  801f27:	89 55 08             	mov    %edx,0x8(%ebp)
  801f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f33:	8a 12                	mov    (%edx),%dl
  801f35:	88 10                	mov    %dl,(%eax)
  801f37:	8a 00                	mov    (%eax),%al
  801f39:	84 c0                	test   %al,%al
  801f3b:	75 e4                	jne    801f21 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f55:	eb 1f                	jmp    801f76 <strncpy+0x34>
		*dst++ = *src;
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	8d 50 01             	lea    0x1(%eax),%edx
  801f5d:	89 55 08             	mov    %edx,0x8(%ebp)
  801f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f63:	8a 12                	mov    (%edx),%dl
  801f65:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6a:	8a 00                	mov    (%eax),%al
  801f6c:	84 c0                	test   %al,%al
  801f6e:	74 03                	je     801f73 <strncpy+0x31>
			src++;
  801f70:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f73:	ff 45 fc             	incl   -0x4(%ebp)
  801f76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f79:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f7c:	72 d9                	jb     801f57 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801f8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f93:	74 30                	je     801fc5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801f95:	eb 16                	jmp    801fad <strlcpy+0x2a>
			*dst++ = *src++;
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	8d 50 01             	lea    0x1(%eax),%edx
  801f9d:	89 55 08             	mov    %edx,0x8(%ebp)
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fa6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fa9:	8a 12                	mov    (%edx),%dl
  801fab:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801fad:	ff 4d 10             	decl   0x10(%ebp)
  801fb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fb4:	74 09                	je     801fbf <strlcpy+0x3c>
  801fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb9:	8a 00                	mov    (%eax),%al
  801fbb:	84 c0                	test   %al,%al
  801fbd:	75 d8                	jne    801f97 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fcb:	29 c2                	sub    %eax,%edx
  801fcd:	89 d0                	mov    %edx,%eax
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801fd4:	eb 06                	jmp    801fdc <strcmp+0xb>
		p++, q++;
  801fd6:	ff 45 08             	incl   0x8(%ebp)
  801fd9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	8a 00                	mov    (%eax),%al
  801fe1:	84 c0                	test   %al,%al
  801fe3:	74 0e                	je     801ff3 <strcmp+0x22>
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	8a 10                	mov    (%eax),%dl
  801fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fed:	8a 00                	mov    (%eax),%al
  801fef:	38 c2                	cmp    %al,%dl
  801ff1:	74 e3                	je     801fd6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	8a 00                	mov    (%eax),%al
  801ff8:	0f b6 d0             	movzbl %al,%edx
  801ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffe:	8a 00                	mov    (%eax),%al
  802000:	0f b6 c0             	movzbl %al,%eax
  802003:	29 c2                	sub    %eax,%edx
  802005:	89 d0                	mov    %edx,%eax
}
  802007:	5d                   	pop    %ebp
  802008:	c3                   	ret    

00802009 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80200c:	eb 09                	jmp    802017 <strncmp+0xe>
		n--, p++, q++;
  80200e:	ff 4d 10             	decl   0x10(%ebp)
  802011:	ff 45 08             	incl   0x8(%ebp)
  802014:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802017:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80201b:	74 17                	je     802034 <strncmp+0x2b>
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	8a 00                	mov    (%eax),%al
  802022:	84 c0                	test   %al,%al
  802024:	74 0e                	je     802034 <strncmp+0x2b>
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	8a 10                	mov    (%eax),%dl
  80202b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202e:	8a 00                	mov    (%eax),%al
  802030:	38 c2                	cmp    %al,%dl
  802032:	74 da                	je     80200e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802038:	75 07                	jne    802041 <strncmp+0x38>
		return 0;
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	eb 14                	jmp    802055 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	8a 00                	mov    (%eax),%al
  802046:	0f b6 d0             	movzbl %al,%edx
  802049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204c:	8a 00                	mov    (%eax),%al
  80204e:	0f b6 c0             	movzbl %al,%eax
  802051:	29 c2                	sub    %eax,%edx
  802053:	89 d0                	mov    %edx,%eax
}
  802055:	5d                   	pop    %ebp
  802056:	c3                   	ret    

00802057 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802060:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802063:	eb 12                	jmp    802077 <strchr+0x20>
		if (*s == c)
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	8a 00                	mov    (%eax),%al
  80206a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80206d:	75 05                	jne    802074 <strchr+0x1d>
			return (char *) s;
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	eb 11                	jmp    802085 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802074:	ff 45 08             	incl   0x8(%ebp)
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	8a 00                	mov    (%eax),%al
  80207c:	84 c0                	test   %al,%al
  80207e:	75 e5                	jne    802065 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802090:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802093:	eb 0d                	jmp    8020a2 <strfind+0x1b>
		if (*s == c)
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	8a 00                	mov    (%eax),%al
  80209a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80209d:	74 0e                	je     8020ad <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80209f:	ff 45 08             	incl   0x8(%ebp)
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	8a 00                	mov    (%eax),%al
  8020a7:	84 c0                	test   %al,%al
  8020a9:	75 ea                	jne    802095 <strfind+0xe>
  8020ab:	eb 01                	jmp    8020ae <strfind+0x27>
		if (*s == c)
			break;
  8020ad:	90                   	nop
	return (char *) s;
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8020bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8020c5:	eb 0e                	jmp    8020d5 <memset+0x22>
		*p++ = c;
  8020c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ca:	8d 50 01             	lea    0x1(%eax),%edx
  8020cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8020d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8020d5:	ff 4d f8             	decl   -0x8(%ebp)
  8020d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8020dc:	79 e9                	jns    8020c7 <memset+0x14>
		*p++ = c;

	return v;
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8020e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8020f5:	eb 16                	jmp    80210d <memcpy+0x2a>
		*d++ = *s++;
  8020f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020fa:	8d 50 01             	lea    0x1(%eax),%edx
  8020fd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802100:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802103:	8d 4a 01             	lea    0x1(%edx),%ecx
  802106:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802109:	8a 12                	mov    (%edx),%dl
  80210b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80210d:	8b 45 10             	mov    0x10(%ebp),%eax
  802110:	8d 50 ff             	lea    -0x1(%eax),%edx
  802113:	89 55 10             	mov    %edx,0x10(%ebp)
  802116:	85 c0                	test   %eax,%eax
  802118:	75 dd                	jne    8020f7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802125:	8b 45 0c             	mov    0xc(%ebp),%eax
  802128:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802131:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802134:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802137:	73 50                	jae    802189 <memmove+0x6a>
  802139:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80213c:	8b 45 10             	mov    0x10(%ebp),%eax
  80213f:	01 d0                	add    %edx,%eax
  802141:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802144:	76 43                	jbe    802189 <memmove+0x6a>
		s += n;
  802146:	8b 45 10             	mov    0x10(%ebp),%eax
  802149:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80214c:	8b 45 10             	mov    0x10(%ebp),%eax
  80214f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802152:	eb 10                	jmp    802164 <memmove+0x45>
			*--d = *--s;
  802154:	ff 4d f8             	decl   -0x8(%ebp)
  802157:	ff 4d fc             	decl   -0x4(%ebp)
  80215a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215d:	8a 10                	mov    (%eax),%dl
  80215f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802162:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802164:	8b 45 10             	mov    0x10(%ebp),%eax
  802167:	8d 50 ff             	lea    -0x1(%eax),%edx
  80216a:	89 55 10             	mov    %edx,0x10(%ebp)
  80216d:	85 c0                	test   %eax,%eax
  80216f:	75 e3                	jne    802154 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802171:	eb 23                	jmp    802196 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802173:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802176:	8d 50 01             	lea    0x1(%eax),%edx
  802179:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80217c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80217f:	8d 4a 01             	lea    0x1(%edx),%ecx
  802182:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802185:	8a 12                	mov    (%edx),%dl
  802187:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802189:	8b 45 10             	mov    0x10(%ebp),%eax
  80218c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80218f:	89 55 10             	mov    %edx,0x10(%ebp)
  802192:	85 c0                	test   %eax,%eax
  802194:	75 dd                	jne    802173 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8021a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021aa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8021ad:	eb 2a                	jmp    8021d9 <memcmp+0x3e>
		if (*s1 != *s2)
  8021af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b2:	8a 10                	mov    (%eax),%dl
  8021b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021b7:	8a 00                	mov    (%eax),%al
  8021b9:	38 c2                	cmp    %al,%dl
  8021bb:	74 16                	je     8021d3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8021bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c0:	8a 00                	mov    (%eax),%al
  8021c2:	0f b6 d0             	movzbl %al,%edx
  8021c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021c8:	8a 00                	mov    (%eax),%al
  8021ca:	0f b6 c0             	movzbl %al,%eax
  8021cd:	29 c2                	sub    %eax,%edx
  8021cf:	89 d0                	mov    %edx,%eax
  8021d1:	eb 18                	jmp    8021eb <memcmp+0x50>
		s1++, s2++;
  8021d3:	ff 45 fc             	incl   -0x4(%ebp)
  8021d6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8021d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021df:	89 55 10             	mov    %edx,0x10(%ebp)
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	75 c9                	jne    8021af <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8021f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f9:	01 d0                	add    %edx,%eax
  8021fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8021fe:	eb 15                	jmp    802215 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	8a 00                	mov    (%eax),%al
  802205:	0f b6 d0             	movzbl %al,%edx
  802208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220b:	0f b6 c0             	movzbl %al,%eax
  80220e:	39 c2                	cmp    %eax,%edx
  802210:	74 0d                	je     80221f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802212:	ff 45 08             	incl   0x8(%ebp)
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80221b:	72 e3                	jb     802200 <memfind+0x13>
  80221d:	eb 01                	jmp    802220 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80221f:	90                   	nop
	return (void *) s;
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80222b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802232:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802239:	eb 03                	jmp    80223e <strtol+0x19>
		s++;
  80223b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	8a 00                	mov    (%eax),%al
  802243:	3c 20                	cmp    $0x20,%al
  802245:	74 f4                	je     80223b <strtol+0x16>
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8a 00                	mov    (%eax),%al
  80224c:	3c 09                	cmp    $0x9,%al
  80224e:	74 eb                	je     80223b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	8a 00                	mov    (%eax),%al
  802255:	3c 2b                	cmp    $0x2b,%al
  802257:	75 05                	jne    80225e <strtol+0x39>
		s++;
  802259:	ff 45 08             	incl   0x8(%ebp)
  80225c:	eb 13                	jmp    802271 <strtol+0x4c>
	else if (*s == '-')
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	8a 00                	mov    (%eax),%al
  802263:	3c 2d                	cmp    $0x2d,%al
  802265:	75 0a                	jne    802271 <strtol+0x4c>
		s++, neg = 1;
  802267:	ff 45 08             	incl   0x8(%ebp)
  80226a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802271:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802275:	74 06                	je     80227d <strtol+0x58>
  802277:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80227b:	75 20                	jne    80229d <strtol+0x78>
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	8a 00                	mov    (%eax),%al
  802282:	3c 30                	cmp    $0x30,%al
  802284:	75 17                	jne    80229d <strtol+0x78>
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	40                   	inc    %eax
  80228a:	8a 00                	mov    (%eax),%al
  80228c:	3c 78                	cmp    $0x78,%al
  80228e:	75 0d                	jne    80229d <strtol+0x78>
		s += 2, base = 16;
  802290:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802294:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80229b:	eb 28                	jmp    8022c5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80229d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022a1:	75 15                	jne    8022b8 <strtol+0x93>
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8a 00                	mov    (%eax),%al
  8022a8:	3c 30                	cmp    $0x30,%al
  8022aa:	75 0c                	jne    8022b8 <strtol+0x93>
		s++, base = 8;
  8022ac:	ff 45 08             	incl   0x8(%ebp)
  8022af:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8022b6:	eb 0d                	jmp    8022c5 <strtol+0xa0>
	else if (base == 0)
  8022b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022bc:	75 07                	jne    8022c5 <strtol+0xa0>
		base = 10;
  8022be:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	8a 00                	mov    (%eax),%al
  8022ca:	3c 2f                	cmp    $0x2f,%al
  8022cc:	7e 19                	jle    8022e7 <strtol+0xc2>
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	8a 00                	mov    (%eax),%al
  8022d3:	3c 39                	cmp    $0x39,%al
  8022d5:	7f 10                	jg     8022e7 <strtol+0xc2>
			dig = *s - '0';
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	8a 00                	mov    (%eax),%al
  8022dc:	0f be c0             	movsbl %al,%eax
  8022df:	83 e8 30             	sub    $0x30,%eax
  8022e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e5:	eb 42                	jmp    802329 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	8a 00                	mov    (%eax),%al
  8022ec:	3c 60                	cmp    $0x60,%al
  8022ee:	7e 19                	jle    802309 <strtol+0xe4>
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	8a 00                	mov    (%eax),%al
  8022f5:	3c 7a                	cmp    $0x7a,%al
  8022f7:	7f 10                	jg     802309 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	8a 00                	mov    (%eax),%al
  8022fe:	0f be c0             	movsbl %al,%eax
  802301:	83 e8 57             	sub    $0x57,%eax
  802304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802307:	eb 20                	jmp    802329 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8a 00                	mov    (%eax),%al
  80230e:	3c 40                	cmp    $0x40,%al
  802310:	7e 39                	jle    80234b <strtol+0x126>
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	8a 00                	mov    (%eax),%al
  802317:	3c 5a                	cmp    $0x5a,%al
  802319:	7f 30                	jg     80234b <strtol+0x126>
			dig = *s - 'A' + 10;
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8a 00                	mov    (%eax),%al
  802320:	0f be c0             	movsbl %al,%eax
  802323:	83 e8 37             	sub    $0x37,%eax
  802326:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80232f:	7d 19                	jge    80234a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802331:	ff 45 08             	incl   0x8(%ebp)
  802334:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802337:	0f af 45 10          	imul   0x10(%ebp),%eax
  80233b:	89 c2                	mov    %eax,%edx
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	01 d0                	add    %edx,%eax
  802342:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802345:	e9 7b ff ff ff       	jmp    8022c5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80234a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80234b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80234f:	74 08                	je     802359 <strtol+0x134>
		*endptr = (char *) s;
  802351:	8b 45 0c             	mov    0xc(%ebp),%eax
  802354:	8b 55 08             	mov    0x8(%ebp),%edx
  802357:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802359:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80235d:	74 07                	je     802366 <strtol+0x141>
  80235f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802362:	f7 d8                	neg    %eax
  802364:	eb 03                	jmp    802369 <strtol+0x144>
  802366:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <ltostr>:

void
ltostr(long value, char *str)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802378:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80237f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802383:	79 13                	jns    802398 <ltostr+0x2d>
	{
		neg = 1;
  802385:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80238c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802392:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802395:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8023a0:	99                   	cltd   
  8023a1:	f7 f9                	idiv   %ecx
  8023a3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8023a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023a9:	8d 50 01             	lea    0x1(%eax),%edx
  8023ac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023af:	89 c2                	mov    %eax,%edx
  8023b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b4:	01 d0                	add    %edx,%eax
  8023b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023b9:	83 c2 30             	add    $0x30,%edx
  8023bc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8023be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023c1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023c6:	f7 e9                	imul   %ecx
  8023c8:	c1 fa 02             	sar    $0x2,%edx
  8023cb:	89 c8                	mov    %ecx,%eax
  8023cd:	c1 f8 1f             	sar    $0x1f,%eax
  8023d0:	29 c2                	sub    %eax,%edx
  8023d2:	89 d0                	mov    %edx,%eax
  8023d4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8023d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023df:	f7 e9                	imul   %ecx
  8023e1:	c1 fa 02             	sar    $0x2,%edx
  8023e4:	89 c8                	mov    %ecx,%eax
  8023e6:	c1 f8 1f             	sar    $0x1f,%eax
  8023e9:	29 c2                	sub    %eax,%edx
  8023eb:	89 d0                	mov    %edx,%eax
  8023ed:	c1 e0 02             	shl    $0x2,%eax
  8023f0:	01 d0                	add    %edx,%eax
  8023f2:	01 c0                	add    %eax,%eax
  8023f4:	29 c1                	sub    %eax,%ecx
  8023f6:	89 ca                	mov    %ecx,%edx
  8023f8:	85 d2                	test   %edx,%edx
  8023fa:	75 9c                	jne    802398 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8023fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802403:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802406:	48                   	dec    %eax
  802407:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80240a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80240e:	74 3d                	je     80244d <ltostr+0xe2>
		start = 1 ;
  802410:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802417:	eb 34                	jmp    80244d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802419:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241f:	01 d0                	add    %edx,%eax
  802421:	8a 00                	mov    (%eax),%al
  802423:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802426:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242c:	01 c2                	add    %eax,%edx
  80242e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802431:	8b 45 0c             	mov    0xc(%ebp),%eax
  802434:	01 c8                	add    %ecx,%eax
  802436:	8a 00                	mov    (%eax),%al
  802438:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80243a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80243d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802440:	01 c2                	add    %eax,%edx
  802442:	8a 45 eb             	mov    -0x15(%ebp),%al
  802445:	88 02                	mov    %al,(%edx)
		start++ ;
  802447:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80244a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802453:	7c c4                	jl     802419 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802455:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245b:	01 d0                	add    %edx,%eax
  80245d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802460:	90                   	nop
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802469:	ff 75 08             	pushl  0x8(%ebp)
  80246c:	e8 54 fa ff ff       	call   801ec5 <strlen>
  802471:	83 c4 04             	add    $0x4,%esp
  802474:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802477:	ff 75 0c             	pushl  0xc(%ebp)
  80247a:	e8 46 fa ff ff       	call   801ec5 <strlen>
  80247f:	83 c4 04             	add    $0x4,%esp
  802482:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802485:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80248c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802493:	eb 17                	jmp    8024ac <strcconcat+0x49>
		final[s] = str1[s] ;
  802495:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802498:	8b 45 10             	mov    0x10(%ebp),%eax
  80249b:	01 c2                	add    %eax,%edx
  80249d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	01 c8                	add    %ecx,%eax
  8024a5:	8a 00                	mov    (%eax),%al
  8024a7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8024a9:	ff 45 fc             	incl   -0x4(%ebp)
  8024ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024b2:	7c e1                	jl     802495 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8024b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8024bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8024c2:	eb 1f                	jmp    8024e3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8024c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c7:	8d 50 01             	lea    0x1(%eax),%edx
  8024ca:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8024cd:	89 c2                	mov    %eax,%edx
  8024cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d2:	01 c2                	add    %eax,%edx
  8024d4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	01 c8                	add    %ecx,%eax
  8024dc:	8a 00                	mov    (%eax),%al
  8024de:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8024e0:	ff 45 f8             	incl   -0x8(%ebp)
  8024e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024e9:	7c d9                	jl     8024c4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8024eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	c6 00 00             	movb   $0x0,(%eax)
}
  8024f6:	90                   	nop
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8024fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802505:	8b 45 14             	mov    0x14(%ebp),%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802511:	8b 45 10             	mov    0x10(%ebp),%eax
  802514:	01 d0                	add    %edx,%eax
  802516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80251c:	eb 0c                	jmp    80252a <strsplit+0x31>
			*string++ = 0;
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	8d 50 01             	lea    0x1(%eax),%edx
  802524:	89 55 08             	mov    %edx,0x8(%ebp)
  802527:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	8a 00                	mov    (%eax),%al
  80252f:	84 c0                	test   %al,%al
  802531:	74 18                	je     80254b <strsplit+0x52>
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	8a 00                	mov    (%eax),%al
  802538:	0f be c0             	movsbl %al,%eax
  80253b:	50                   	push   %eax
  80253c:	ff 75 0c             	pushl  0xc(%ebp)
  80253f:	e8 13 fb ff ff       	call   802057 <strchr>
  802544:	83 c4 08             	add    $0x8,%esp
  802547:	85 c0                	test   %eax,%eax
  802549:	75 d3                	jne    80251e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	8a 00                	mov    (%eax),%al
  802550:	84 c0                	test   %al,%al
  802552:	74 5a                	je     8025ae <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802554:	8b 45 14             	mov    0x14(%ebp),%eax
  802557:	8b 00                	mov    (%eax),%eax
  802559:	83 f8 0f             	cmp    $0xf,%eax
  80255c:	75 07                	jne    802565 <strsplit+0x6c>
		{
			return 0;
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
  802563:	eb 66                	jmp    8025cb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802565:	8b 45 14             	mov    0x14(%ebp),%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	8d 48 01             	lea    0x1(%eax),%ecx
  80256d:	8b 55 14             	mov    0x14(%ebp),%edx
  802570:	89 0a                	mov    %ecx,(%edx)
  802572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802579:	8b 45 10             	mov    0x10(%ebp),%eax
  80257c:	01 c2                	add    %eax,%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802583:	eb 03                	jmp    802588 <strsplit+0x8f>
			string++;
  802585:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	8a 00                	mov    (%eax),%al
  80258d:	84 c0                	test   %al,%al
  80258f:	74 8b                	je     80251c <strsplit+0x23>
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	8a 00                	mov    (%eax),%al
  802596:	0f be c0             	movsbl %al,%eax
  802599:	50                   	push   %eax
  80259a:	ff 75 0c             	pushl  0xc(%ebp)
  80259d:	e8 b5 fa ff ff       	call   802057 <strchr>
  8025a2:	83 c4 08             	add    $0x8,%esp
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	74 dc                	je     802585 <strsplit+0x8c>
			string++;
	}
  8025a9:	e9 6e ff ff ff       	jmp    80251c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8025ae:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8025af:	8b 45 14             	mov    0x14(%ebp),%eax
  8025b2:	8b 00                	mov    (%eax),%eax
  8025b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8025be:	01 d0                	add    %edx,%eax
  8025c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8025c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
  8025d0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8025d3:	a1 04 50 80 00       	mov    0x805004,%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	74 1f                	je     8025fb <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8025dc:	e8 1d 00 00 00       	call   8025fe <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8025e1:	83 ec 0c             	sub    $0xc,%esp
  8025e4:	68 10 4d 80 00       	push   $0x804d10
  8025e9:	e8 55 f2 ff ff       	call   801843 <cprintf>
  8025ee:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8025f1:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8025f8:	00 00 00 
	}
}
  8025fb:	90                   	nop
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  802604:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80260b:	00 00 00 
  80260e:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802615:	00 00 00 
  802618:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80261f:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  802622:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802629:	00 00 00 
  80262c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802633:	00 00 00 
  802636:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80263d:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  802640:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802647:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80264a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802659:	2d 00 10 00 00       	sub    $0x1000,%eax
  80265e:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  802663:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80266a:	a1 20 51 80 00       	mov    0x805120,%eax
  80266f:	c1 e0 04             	shl    $0x4,%eax
  802672:	89 c2                	mov    %eax,%edx
  802674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802677:	01 d0                	add    %edx,%eax
  802679:	48                   	dec    %eax
  80267a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80267d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802680:	ba 00 00 00 00       	mov    $0x0,%edx
  802685:	f7 75 f0             	divl   -0x10(%ebp)
  802688:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268b:	29 d0                	sub    %edx,%eax
  80268d:	89 c2                	mov    %eax,%edx
  80268f:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  802696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802699:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80269e:	2d 00 10 00 00       	sub    $0x1000,%eax
  8026a3:	83 ec 04             	sub    $0x4,%esp
  8026a6:	6a 06                	push   $0x6
  8026a8:	52                   	push   %edx
  8026a9:	50                   	push   %eax
  8026aa:	e8 71 05 00 00       	call   802c20 <sys_allocate_chunk>
  8026af:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8026b2:	a1 20 51 80 00       	mov    0x805120,%eax
  8026b7:	83 ec 0c             	sub    $0xc,%esp
  8026ba:	50                   	push   %eax
  8026bb:	e8 e6 0b 00 00       	call   8032a6 <initialize_MemBlocksList>
  8026c0:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8026c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8026c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8026cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026cf:	75 14                	jne    8026e5 <initialize_dyn_block_system+0xe7>
  8026d1:	83 ec 04             	sub    $0x4,%esp
  8026d4:	68 35 4d 80 00       	push   $0x804d35
  8026d9:	6a 2b                	push   $0x2b
  8026db:	68 53 4d 80 00       	push   $0x804d53
  8026e0:	e8 aa ee ff ff       	call   80158f <_panic>
  8026e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e8:	8b 00                	mov    (%eax),%eax
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	74 10                	je     8026fe <initialize_dyn_block_system+0x100>
  8026ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f6:	8b 52 04             	mov    0x4(%edx),%edx
  8026f9:	89 50 04             	mov    %edx,0x4(%eax)
  8026fc:	eb 0b                	jmp    802709 <initialize_dyn_block_system+0x10b>
  8026fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802701:	8b 40 04             	mov    0x4(%eax),%eax
  802704:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270c:	8b 40 04             	mov    0x4(%eax),%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	74 0f                	je     802722 <initialize_dyn_block_system+0x124>
  802713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802716:	8b 40 04             	mov    0x4(%eax),%eax
  802719:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80271c:	8b 12                	mov    (%edx),%edx
  80271e:	89 10                	mov    %edx,(%eax)
  802720:	eb 0a                	jmp    80272c <initialize_dyn_block_system+0x12e>
  802722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	a3 48 51 80 00       	mov    %eax,0x805148
  80272c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802738:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273f:	a1 54 51 80 00       	mov    0x805154,%eax
  802744:	48                   	dec    %eax
  802745:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  80274a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  802754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802757:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80275e:	83 ec 0c             	sub    $0xc,%esp
  802761:	ff 75 e4             	pushl  -0x1c(%ebp)
  802764:	e8 d2 13 00 00       	call   803b3b <insert_sorted_with_merge_freeList>
  802769:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80276c:	90                   	nop
  80276d:	c9                   	leave  
  80276e:	c3                   	ret    

0080276f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802775:	e8 53 fe ff ff       	call   8025cd <InitializeUHeap>
	if (size == 0) return NULL ;
  80277a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80277e:	75 07                	jne    802787 <malloc+0x18>
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
  802785:	eb 61                	jmp    8027e8 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  802787:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80278e:	8b 55 08             	mov    0x8(%ebp),%edx
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	01 d0                	add    %edx,%eax
  802796:	48                   	dec    %eax
  802797:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80279a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279d:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a2:	f7 75 f4             	divl   -0xc(%ebp)
  8027a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a8:	29 d0                	sub    %edx,%eax
  8027aa:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8027ad:	e8 3c 08 00 00       	call   802fee <sys_isUHeapPlacementStrategyFIRSTFIT>
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	74 2d                	je     8027e3 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8027b6:	83 ec 0c             	sub    $0xc,%esp
  8027b9:	ff 75 08             	pushl  0x8(%ebp)
  8027bc:	e8 3e 0f 00 00       	call   8036ff <alloc_block_FF>
  8027c1:	83 c4 10             	add    $0x10,%esp
  8027c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8027c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027cb:	74 16                	je     8027e3 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8027cd:	83 ec 0c             	sub    $0xc,%esp
  8027d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8027d3:	e8 48 0c 00 00       	call   803420 <insert_sorted_allocList>
  8027d8:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8027db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027de:	8b 40 08             	mov    0x8(%eax),%eax
  8027e1:	eb 05                	jmp    8027e8 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8027e3:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8027f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8027fe:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	83 ec 08             	sub    $0x8,%esp
  802807:	50                   	push   %eax
  802808:	68 40 50 80 00       	push   $0x805040
  80280d:	e8 71 0b 00 00       	call   803383 <find_block>
  802812:	83 c4 10             	add    $0x10,%esp
  802815:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  802818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281b:	8b 50 0c             	mov    0xc(%eax),%edx
  80281e:	8b 45 08             	mov    0x8(%ebp),%eax
  802821:	83 ec 08             	sub    $0x8,%esp
  802824:	52                   	push   %edx
  802825:	50                   	push   %eax
  802826:	e8 bd 03 00 00       	call   802be8 <sys_free_user_mem>
  80282b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80282e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802832:	75 14                	jne    802848 <free+0x5e>
  802834:	83 ec 04             	sub    $0x4,%esp
  802837:	68 35 4d 80 00       	push   $0x804d35
  80283c:	6a 71                	push   $0x71
  80283e:	68 53 4d 80 00       	push   $0x804d53
  802843:	e8 47 ed ff ff       	call   80158f <_panic>
  802848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	74 10                	je     802861 <free+0x77>
  802851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802854:	8b 00                	mov    (%eax),%eax
  802856:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802859:	8b 52 04             	mov    0x4(%edx),%edx
  80285c:	89 50 04             	mov    %edx,0x4(%eax)
  80285f:	eb 0b                	jmp    80286c <free+0x82>
  802861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802864:	8b 40 04             	mov    0x4(%eax),%eax
  802867:	a3 44 50 80 00       	mov    %eax,0x805044
  80286c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286f:	8b 40 04             	mov    0x4(%eax),%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	74 0f                	je     802885 <free+0x9b>
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	8b 40 04             	mov    0x4(%eax),%eax
  80287c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80287f:	8b 12                	mov    (%edx),%edx
  802881:	89 10                	mov    %edx,(%eax)
  802883:	eb 0a                	jmp    80288f <free+0xa5>
  802885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802888:	8b 00                	mov    (%eax),%eax
  80288a:	a3 40 50 80 00       	mov    %eax,0x805040
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028a7:	48                   	dec    %eax
  8028a8:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  8028ad:	83 ec 0c             	sub    $0xc,%esp
  8028b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8028b3:	e8 83 12 00 00       	call   803b3b <insert_sorted_with_merge_freeList>
  8028b8:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8028bb:	90                   	nop
  8028bc:	c9                   	leave  
  8028bd:	c3                   	ret    

008028be <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8028be:	55                   	push   %ebp
  8028bf:	89 e5                	mov    %esp,%ebp
  8028c1:	83 ec 28             	sub    $0x28,%esp
  8028c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c7:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8028ca:	e8 fe fc ff ff       	call   8025cd <InitializeUHeap>
	if (size == 0) return NULL ;
  8028cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028d3:	75 0a                	jne    8028df <smalloc+0x21>
  8028d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028da:	e9 86 00 00 00       	jmp    802965 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8028df:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8028e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	01 d0                	add    %edx,%eax
  8028ee:	48                   	dec    %eax
  8028ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8028f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8028fa:	f7 75 f4             	divl   -0xc(%ebp)
  8028fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802900:	29 d0                	sub    %edx,%eax
  802902:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802905:	e8 e4 06 00 00       	call   802fee <sys_isUHeapPlacementStrategyFIRSTFIT>
  80290a:	85 c0                	test   %eax,%eax
  80290c:	74 52                	je     802960 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  80290e:	83 ec 0c             	sub    $0xc,%esp
  802911:	ff 75 0c             	pushl  0xc(%ebp)
  802914:	e8 e6 0d 00 00       	call   8036ff <alloc_block_FF>
  802919:	83 c4 10             	add    $0x10,%esp
  80291c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  80291f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802923:	75 07                	jne    80292c <smalloc+0x6e>
			return NULL ;
  802925:	b8 00 00 00 00       	mov    $0x0,%eax
  80292a:	eb 39                	jmp    802965 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80292c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292f:	8b 40 08             	mov    0x8(%eax),%eax
  802932:	89 c2                	mov    %eax,%edx
  802934:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802938:	52                   	push   %edx
  802939:	50                   	push   %eax
  80293a:	ff 75 0c             	pushl  0xc(%ebp)
  80293d:	ff 75 08             	pushl  0x8(%ebp)
  802940:	e8 2e 04 00 00       	call   802d73 <sys_createSharedObject>
  802945:	83 c4 10             	add    $0x10,%esp
  802948:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80294b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80294f:	79 07                	jns    802958 <smalloc+0x9a>
			return (void*)NULL ;
  802951:	b8 00 00 00 00       	mov    $0x0,%eax
  802956:	eb 0d                	jmp    802965 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  802958:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295b:	8b 40 08             	mov    0x8(%eax),%eax
  80295e:	eb 05                	jmp    802965 <smalloc+0xa7>
		}
		return (void*)NULL ;
  802960:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802965:	c9                   	leave  
  802966:	c3                   	ret    

00802967 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802967:	55                   	push   %ebp
  802968:	89 e5                	mov    %esp,%ebp
  80296a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80296d:	e8 5b fc ff ff       	call   8025cd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802972:	83 ec 08             	sub    $0x8,%esp
  802975:	ff 75 0c             	pushl  0xc(%ebp)
  802978:	ff 75 08             	pushl  0x8(%ebp)
  80297b:	e8 1d 04 00 00       	call   802d9d <sys_getSizeOfSharedObject>
  802980:	83 c4 10             	add    $0x10,%esp
  802983:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  802986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298a:	75 0a                	jne    802996 <sget+0x2f>
			return NULL ;
  80298c:	b8 00 00 00 00       	mov    $0x0,%eax
  802991:	e9 83 00 00 00       	jmp    802a19 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  802996:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80299d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a3:	01 d0                	add    %edx,%eax
  8029a5:	48                   	dec    %eax
  8029a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b1:	f7 75 f0             	divl   -0x10(%ebp)
  8029b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b7:	29 d0                	sub    %edx,%eax
  8029b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8029bc:	e8 2d 06 00 00       	call   802fee <sys_isUHeapPlacementStrategyFIRSTFIT>
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	74 4f                	je     802a14 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	83 ec 0c             	sub    $0xc,%esp
  8029cb:	50                   	push   %eax
  8029cc:	e8 2e 0d 00 00       	call   8036ff <alloc_block_FF>
  8029d1:	83 c4 10             	add    $0x10,%esp
  8029d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8029d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029db:	75 07                	jne    8029e4 <sget+0x7d>
					return (void*)NULL ;
  8029dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e2:	eb 35                	jmp    802a19 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8029e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e7:	8b 40 08             	mov    0x8(%eax),%eax
  8029ea:	83 ec 04             	sub    $0x4,%esp
  8029ed:	50                   	push   %eax
  8029ee:	ff 75 0c             	pushl  0xc(%ebp)
  8029f1:	ff 75 08             	pushl  0x8(%ebp)
  8029f4:	e8 c1 03 00 00       	call   802dba <sys_getSharedObject>
  8029f9:	83 c4 10             	add    $0x10,%esp
  8029fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8029ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a03:	79 07                	jns    802a0c <sget+0xa5>
				return (void*)NULL ;
  802a05:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0a:	eb 0d                	jmp    802a19 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  802a0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0f:	8b 40 08             	mov    0x8(%eax),%eax
  802a12:	eb 05                	jmp    802a19 <sget+0xb2>


		}
	return (void*)NULL ;
  802a14:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802a19:	c9                   	leave  
  802a1a:	c3                   	ret    

00802a1b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802a1b:	55                   	push   %ebp
  802a1c:	89 e5                	mov    %esp,%ebp
  802a1e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802a21:	e8 a7 fb ff ff       	call   8025cd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802a26:	83 ec 04             	sub    $0x4,%esp
  802a29:	68 60 4d 80 00       	push   $0x804d60
  802a2e:	68 f9 00 00 00       	push   $0xf9
  802a33:	68 53 4d 80 00       	push   $0x804d53
  802a38:	e8 52 eb ff ff       	call   80158f <_panic>

00802a3d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802a3d:	55                   	push   %ebp
  802a3e:	89 e5                	mov    %esp,%ebp
  802a40:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802a43:	83 ec 04             	sub    $0x4,%esp
  802a46:	68 88 4d 80 00       	push   $0x804d88
  802a4b:	68 0d 01 00 00       	push   $0x10d
  802a50:	68 53 4d 80 00       	push   $0x804d53
  802a55:	e8 35 eb ff ff       	call   80158f <_panic>

00802a5a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802a5a:	55                   	push   %ebp
  802a5b:	89 e5                	mov    %esp,%ebp
  802a5d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802a60:	83 ec 04             	sub    $0x4,%esp
  802a63:	68 ac 4d 80 00       	push   $0x804dac
  802a68:	68 18 01 00 00       	push   $0x118
  802a6d:	68 53 4d 80 00       	push   $0x804d53
  802a72:	e8 18 eb ff ff       	call   80158f <_panic>

00802a77 <shrink>:

}
void shrink(uint32 newSize)
{
  802a77:	55                   	push   %ebp
  802a78:	89 e5                	mov    %esp,%ebp
  802a7a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802a7d:	83 ec 04             	sub    $0x4,%esp
  802a80:	68 ac 4d 80 00       	push   $0x804dac
  802a85:	68 1d 01 00 00       	push   $0x11d
  802a8a:	68 53 4d 80 00       	push   $0x804d53
  802a8f:	e8 fb ea ff ff       	call   80158f <_panic>

00802a94 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802a94:	55                   	push   %ebp
  802a95:	89 e5                	mov    %esp,%ebp
  802a97:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802a9a:	83 ec 04             	sub    $0x4,%esp
  802a9d:	68 ac 4d 80 00       	push   $0x804dac
  802aa2:	68 22 01 00 00       	push   $0x122
  802aa7:	68 53 4d 80 00       	push   $0x804d53
  802aac:	e8 de ea ff ff       	call   80158f <_panic>

00802ab1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802ab1:	55                   	push   %ebp
  802ab2:	89 e5                	mov    %esp,%ebp
  802ab4:	57                   	push   %edi
  802ab5:	56                   	push   %esi
  802ab6:	53                   	push   %ebx
  802ab7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ac0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ac3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ac6:	8b 7d 18             	mov    0x18(%ebp),%edi
  802ac9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802acc:	cd 30                	int    $0x30
  802ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802ad4:	83 c4 10             	add    $0x10,%esp
  802ad7:	5b                   	pop    %ebx
  802ad8:	5e                   	pop    %esi
  802ad9:	5f                   	pop    %edi
  802ada:	5d                   	pop    %ebp
  802adb:	c3                   	ret    

00802adc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802adc:	55                   	push   %ebp
  802add:	89 e5                	mov    %esp,%ebp
  802adf:	83 ec 04             	sub    $0x4,%esp
  802ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  802ae5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802ae8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	6a 00                	push   $0x0
  802af1:	6a 00                	push   $0x0
  802af3:	52                   	push   %edx
  802af4:	ff 75 0c             	pushl  0xc(%ebp)
  802af7:	50                   	push   %eax
  802af8:	6a 00                	push   $0x0
  802afa:	e8 b2 ff ff ff       	call   802ab1 <syscall>
  802aff:	83 c4 18             	add    $0x18,%esp
}
  802b02:	90                   	nop
  802b03:	c9                   	leave  
  802b04:	c3                   	ret    

00802b05 <sys_cgetc>:

int
sys_cgetc(void)
{
  802b05:	55                   	push   %ebp
  802b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802b08:	6a 00                	push   $0x0
  802b0a:	6a 00                	push   $0x0
  802b0c:	6a 00                	push   $0x0
  802b0e:	6a 00                	push   $0x0
  802b10:	6a 00                	push   $0x0
  802b12:	6a 01                	push   $0x1
  802b14:	e8 98 ff ff ff       	call   802ab1 <syscall>
  802b19:	83 c4 18             	add    $0x18,%esp
}
  802b1c:	c9                   	leave  
  802b1d:	c3                   	ret    

00802b1e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802b1e:	55                   	push   %ebp
  802b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 00                	push   $0x0
  802b2d:	52                   	push   %edx
  802b2e:	50                   	push   %eax
  802b2f:	6a 05                	push   $0x5
  802b31:	e8 7b ff ff ff       	call   802ab1 <syscall>
  802b36:	83 c4 18             	add    $0x18,%esp
}
  802b39:	c9                   	leave  
  802b3a:	c3                   	ret    

00802b3b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
  802b3e:	56                   	push   %esi
  802b3f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802b40:	8b 75 18             	mov    0x18(%ebp),%esi
  802b43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	56                   	push   %esi
  802b50:	53                   	push   %ebx
  802b51:	51                   	push   %ecx
  802b52:	52                   	push   %edx
  802b53:	50                   	push   %eax
  802b54:	6a 06                	push   $0x6
  802b56:	e8 56 ff ff ff       	call   802ab1 <syscall>
  802b5b:	83 c4 18             	add    $0x18,%esp
}
  802b5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b61:	5b                   	pop    %ebx
  802b62:	5e                   	pop    %esi
  802b63:	5d                   	pop    %ebp
  802b64:	c3                   	ret    

00802b65 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802b65:	55                   	push   %ebp
  802b66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802b68:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	52                   	push   %edx
  802b75:	50                   	push   %eax
  802b76:	6a 07                	push   $0x7
  802b78:	e8 34 ff ff ff       	call   802ab1 <syscall>
  802b7d:	83 c4 18             	add    $0x18,%esp
}
  802b80:	c9                   	leave  
  802b81:	c3                   	ret    

00802b82 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802b82:	55                   	push   %ebp
  802b83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	ff 75 0c             	pushl  0xc(%ebp)
  802b8e:	ff 75 08             	pushl  0x8(%ebp)
  802b91:	6a 08                	push   $0x8
  802b93:	e8 19 ff ff ff       	call   802ab1 <syscall>
  802b98:	83 c4 18             	add    $0x18,%esp
}
  802b9b:	c9                   	leave  
  802b9c:	c3                   	ret    

00802b9d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802b9d:	55                   	push   %ebp
  802b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802ba0:	6a 00                	push   $0x0
  802ba2:	6a 00                	push   $0x0
  802ba4:	6a 00                	push   $0x0
  802ba6:	6a 00                	push   $0x0
  802ba8:	6a 00                	push   $0x0
  802baa:	6a 09                	push   $0x9
  802bac:	e8 00 ff ff ff       	call   802ab1 <syscall>
  802bb1:	83 c4 18             	add    $0x18,%esp
}
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802bb9:	6a 00                	push   $0x0
  802bbb:	6a 00                	push   $0x0
  802bbd:	6a 00                	push   $0x0
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 0a                	push   $0xa
  802bc5:	e8 e7 fe ff ff       	call   802ab1 <syscall>
  802bca:	83 c4 18             	add    $0x18,%esp
}
  802bcd:	c9                   	leave  
  802bce:	c3                   	ret    

00802bcf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802bcf:	55                   	push   %ebp
  802bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802bd2:	6a 00                	push   $0x0
  802bd4:	6a 00                	push   $0x0
  802bd6:	6a 00                	push   $0x0
  802bd8:	6a 00                	push   $0x0
  802bda:	6a 00                	push   $0x0
  802bdc:	6a 0b                	push   $0xb
  802bde:	e8 ce fe ff ff       	call   802ab1 <syscall>
  802be3:	83 c4 18             	add    $0x18,%esp
}
  802be6:	c9                   	leave  
  802be7:	c3                   	ret    

00802be8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802be8:	55                   	push   %ebp
  802be9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802beb:	6a 00                	push   $0x0
  802bed:	6a 00                	push   $0x0
  802bef:	6a 00                	push   $0x0
  802bf1:	ff 75 0c             	pushl  0xc(%ebp)
  802bf4:	ff 75 08             	pushl  0x8(%ebp)
  802bf7:	6a 0f                	push   $0xf
  802bf9:	e8 b3 fe ff ff       	call   802ab1 <syscall>
  802bfe:	83 c4 18             	add    $0x18,%esp
	return;
  802c01:	90                   	nop
}
  802c02:	c9                   	leave  
  802c03:	c3                   	ret    

00802c04 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802c04:	55                   	push   %ebp
  802c05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802c07:	6a 00                	push   $0x0
  802c09:	6a 00                	push   $0x0
  802c0b:	6a 00                	push   $0x0
  802c0d:	ff 75 0c             	pushl  0xc(%ebp)
  802c10:	ff 75 08             	pushl  0x8(%ebp)
  802c13:	6a 10                	push   $0x10
  802c15:	e8 97 fe ff ff       	call   802ab1 <syscall>
  802c1a:	83 c4 18             	add    $0x18,%esp
	return ;
  802c1d:	90                   	nop
}
  802c1e:	c9                   	leave  
  802c1f:	c3                   	ret    

00802c20 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802c20:	55                   	push   %ebp
  802c21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802c23:	6a 00                	push   $0x0
  802c25:	6a 00                	push   $0x0
  802c27:	ff 75 10             	pushl  0x10(%ebp)
  802c2a:	ff 75 0c             	pushl  0xc(%ebp)
  802c2d:	ff 75 08             	pushl  0x8(%ebp)
  802c30:	6a 11                	push   $0x11
  802c32:	e8 7a fe ff ff       	call   802ab1 <syscall>
  802c37:	83 c4 18             	add    $0x18,%esp
	return ;
  802c3a:	90                   	nop
}
  802c3b:	c9                   	leave  
  802c3c:	c3                   	ret    

00802c3d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802c3d:	55                   	push   %ebp
  802c3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802c40:	6a 00                	push   $0x0
  802c42:	6a 00                	push   $0x0
  802c44:	6a 00                	push   $0x0
  802c46:	6a 00                	push   $0x0
  802c48:	6a 00                	push   $0x0
  802c4a:	6a 0c                	push   $0xc
  802c4c:	e8 60 fe ff ff       	call   802ab1 <syscall>
  802c51:	83 c4 18             	add    $0x18,%esp
}
  802c54:	c9                   	leave  
  802c55:	c3                   	ret    

00802c56 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802c56:	55                   	push   %ebp
  802c57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802c59:	6a 00                	push   $0x0
  802c5b:	6a 00                	push   $0x0
  802c5d:	6a 00                	push   $0x0
  802c5f:	6a 00                	push   $0x0
  802c61:	ff 75 08             	pushl  0x8(%ebp)
  802c64:	6a 0d                	push   $0xd
  802c66:	e8 46 fe ff ff       	call   802ab1 <syscall>
  802c6b:	83 c4 18             	add    $0x18,%esp
}
  802c6e:	c9                   	leave  
  802c6f:	c3                   	ret    

00802c70 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802c70:	55                   	push   %ebp
  802c71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802c73:	6a 00                	push   $0x0
  802c75:	6a 00                	push   $0x0
  802c77:	6a 00                	push   $0x0
  802c79:	6a 00                	push   $0x0
  802c7b:	6a 00                	push   $0x0
  802c7d:	6a 0e                	push   $0xe
  802c7f:	e8 2d fe ff ff       	call   802ab1 <syscall>
  802c84:	83 c4 18             	add    $0x18,%esp
}
  802c87:	90                   	nop
  802c88:	c9                   	leave  
  802c89:	c3                   	ret    

00802c8a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802c8a:	55                   	push   %ebp
  802c8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802c8d:	6a 00                	push   $0x0
  802c8f:	6a 00                	push   $0x0
  802c91:	6a 00                	push   $0x0
  802c93:	6a 00                	push   $0x0
  802c95:	6a 00                	push   $0x0
  802c97:	6a 13                	push   $0x13
  802c99:	e8 13 fe ff ff       	call   802ab1 <syscall>
  802c9e:	83 c4 18             	add    $0x18,%esp
}
  802ca1:	90                   	nop
  802ca2:	c9                   	leave  
  802ca3:	c3                   	ret    

00802ca4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802ca4:	55                   	push   %ebp
  802ca5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802ca7:	6a 00                	push   $0x0
  802ca9:	6a 00                	push   $0x0
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	6a 00                	push   $0x0
  802cb1:	6a 14                	push   $0x14
  802cb3:	e8 f9 fd ff ff       	call   802ab1 <syscall>
  802cb8:	83 c4 18             	add    $0x18,%esp
}
  802cbb:	90                   	nop
  802cbc:	c9                   	leave  
  802cbd:	c3                   	ret    

00802cbe <sys_cputc>:


void
sys_cputc(const char c)
{
  802cbe:	55                   	push   %ebp
  802cbf:	89 e5                	mov    %esp,%ebp
  802cc1:	83 ec 04             	sub    $0x4,%esp
  802cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802cca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802cce:	6a 00                	push   $0x0
  802cd0:	6a 00                	push   $0x0
  802cd2:	6a 00                	push   $0x0
  802cd4:	6a 00                	push   $0x0
  802cd6:	50                   	push   %eax
  802cd7:	6a 15                	push   $0x15
  802cd9:	e8 d3 fd ff ff       	call   802ab1 <syscall>
  802cde:	83 c4 18             	add    $0x18,%esp
}
  802ce1:	90                   	nop
  802ce2:	c9                   	leave  
  802ce3:	c3                   	ret    

00802ce4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802ce4:	55                   	push   %ebp
  802ce5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802ce7:	6a 00                	push   $0x0
  802ce9:	6a 00                	push   $0x0
  802ceb:	6a 00                	push   $0x0
  802ced:	6a 00                	push   $0x0
  802cef:	6a 00                	push   $0x0
  802cf1:	6a 16                	push   $0x16
  802cf3:	e8 b9 fd ff ff       	call   802ab1 <syscall>
  802cf8:	83 c4 18             	add    $0x18,%esp
}
  802cfb:	90                   	nop
  802cfc:	c9                   	leave  
  802cfd:	c3                   	ret    

00802cfe <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802cfe:	55                   	push   %ebp
  802cff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	6a 00                	push   $0x0
  802d06:	6a 00                	push   $0x0
  802d08:	6a 00                	push   $0x0
  802d0a:	ff 75 0c             	pushl  0xc(%ebp)
  802d0d:	50                   	push   %eax
  802d0e:	6a 17                	push   $0x17
  802d10:	e8 9c fd ff ff       	call   802ab1 <syscall>
  802d15:	83 c4 18             	add    $0x18,%esp
}
  802d18:	c9                   	leave  
  802d19:	c3                   	ret    

00802d1a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802d1a:	55                   	push   %ebp
  802d1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	6a 00                	push   $0x0
  802d25:	6a 00                	push   $0x0
  802d27:	6a 00                	push   $0x0
  802d29:	52                   	push   %edx
  802d2a:	50                   	push   %eax
  802d2b:	6a 1a                	push   $0x1a
  802d2d:	e8 7f fd ff ff       	call   802ab1 <syscall>
  802d32:	83 c4 18             	add    $0x18,%esp
}
  802d35:	c9                   	leave  
  802d36:	c3                   	ret    

00802d37 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802d37:	55                   	push   %ebp
  802d38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d40:	6a 00                	push   $0x0
  802d42:	6a 00                	push   $0x0
  802d44:	6a 00                	push   $0x0
  802d46:	52                   	push   %edx
  802d47:	50                   	push   %eax
  802d48:	6a 18                	push   $0x18
  802d4a:	e8 62 fd ff ff       	call   802ab1 <syscall>
  802d4f:	83 c4 18             	add    $0x18,%esp
}
  802d52:	90                   	nop
  802d53:	c9                   	leave  
  802d54:	c3                   	ret    

00802d55 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802d55:	55                   	push   %ebp
  802d56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802d58:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	6a 00                	push   $0x0
  802d60:	6a 00                	push   $0x0
  802d62:	6a 00                	push   $0x0
  802d64:	52                   	push   %edx
  802d65:	50                   	push   %eax
  802d66:	6a 19                	push   $0x19
  802d68:	e8 44 fd ff ff       	call   802ab1 <syscall>
  802d6d:	83 c4 18             	add    $0x18,%esp
}
  802d70:	90                   	nop
  802d71:	c9                   	leave  
  802d72:	c3                   	ret    

00802d73 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802d73:	55                   	push   %ebp
  802d74:	89 e5                	mov    %esp,%ebp
  802d76:	83 ec 04             	sub    $0x4,%esp
  802d79:	8b 45 10             	mov    0x10(%ebp),%eax
  802d7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802d7f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d82:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	6a 00                	push   $0x0
  802d8b:	51                   	push   %ecx
  802d8c:	52                   	push   %edx
  802d8d:	ff 75 0c             	pushl  0xc(%ebp)
  802d90:	50                   	push   %eax
  802d91:	6a 1b                	push   $0x1b
  802d93:	e8 19 fd ff ff       	call   802ab1 <syscall>
  802d98:	83 c4 18             	add    $0x18,%esp
}
  802d9b:	c9                   	leave  
  802d9c:	c3                   	ret    

00802d9d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802d9d:	55                   	push   %ebp
  802d9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	6a 00                	push   $0x0
  802da8:	6a 00                	push   $0x0
  802daa:	6a 00                	push   $0x0
  802dac:	52                   	push   %edx
  802dad:	50                   	push   %eax
  802dae:	6a 1c                	push   $0x1c
  802db0:	e8 fc fc ff ff       	call   802ab1 <syscall>
  802db5:	83 c4 18             	add    $0x18,%esp
}
  802db8:	c9                   	leave  
  802db9:	c3                   	ret    

00802dba <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802dba:	55                   	push   %ebp
  802dbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802dbd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	6a 00                	push   $0x0
  802dc8:	6a 00                	push   $0x0
  802dca:	51                   	push   %ecx
  802dcb:	52                   	push   %edx
  802dcc:	50                   	push   %eax
  802dcd:	6a 1d                	push   $0x1d
  802dcf:	e8 dd fc ff ff       	call   802ab1 <syscall>
  802dd4:	83 c4 18             	add    $0x18,%esp
}
  802dd7:	c9                   	leave  
  802dd8:	c3                   	ret    

00802dd9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802dd9:	55                   	push   %ebp
  802dda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802ddc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	6a 00                	push   $0x0
  802de4:	6a 00                	push   $0x0
  802de6:	6a 00                	push   $0x0
  802de8:	52                   	push   %edx
  802de9:	50                   	push   %eax
  802dea:	6a 1e                	push   $0x1e
  802dec:	e8 c0 fc ff ff       	call   802ab1 <syscall>
  802df1:	83 c4 18             	add    $0x18,%esp
}
  802df4:	c9                   	leave  
  802df5:	c3                   	ret    

00802df6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802df6:	55                   	push   %ebp
  802df7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802df9:	6a 00                	push   $0x0
  802dfb:	6a 00                	push   $0x0
  802dfd:	6a 00                	push   $0x0
  802dff:	6a 00                	push   $0x0
  802e01:	6a 00                	push   $0x0
  802e03:	6a 1f                	push   $0x1f
  802e05:	e8 a7 fc ff ff       	call   802ab1 <syscall>
  802e0a:	83 c4 18             	add    $0x18,%esp
}
  802e0d:	c9                   	leave  
  802e0e:	c3                   	ret    

00802e0f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802e0f:	55                   	push   %ebp
  802e10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	6a 00                	push   $0x0
  802e17:	ff 75 14             	pushl  0x14(%ebp)
  802e1a:	ff 75 10             	pushl  0x10(%ebp)
  802e1d:	ff 75 0c             	pushl  0xc(%ebp)
  802e20:	50                   	push   %eax
  802e21:	6a 20                	push   $0x20
  802e23:	e8 89 fc ff ff       	call   802ab1 <syscall>
  802e28:	83 c4 18             	add    $0x18,%esp
}
  802e2b:	c9                   	leave  
  802e2c:	c3                   	ret    

00802e2d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802e2d:	55                   	push   %ebp
  802e2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	6a 00                	push   $0x0
  802e35:	6a 00                	push   $0x0
  802e37:	6a 00                	push   $0x0
  802e39:	6a 00                	push   $0x0
  802e3b:	50                   	push   %eax
  802e3c:	6a 21                	push   $0x21
  802e3e:	e8 6e fc ff ff       	call   802ab1 <syscall>
  802e43:	83 c4 18             	add    $0x18,%esp
}
  802e46:	90                   	nop
  802e47:	c9                   	leave  
  802e48:	c3                   	ret    

00802e49 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802e49:	55                   	push   %ebp
  802e4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	6a 00                	push   $0x0
  802e51:	6a 00                	push   $0x0
  802e53:	6a 00                	push   $0x0
  802e55:	6a 00                	push   $0x0
  802e57:	50                   	push   %eax
  802e58:	6a 22                	push   $0x22
  802e5a:	e8 52 fc ff ff       	call   802ab1 <syscall>
  802e5f:	83 c4 18             	add    $0x18,%esp
}
  802e62:	c9                   	leave  
  802e63:	c3                   	ret    

00802e64 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802e64:	55                   	push   %ebp
  802e65:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802e67:	6a 00                	push   $0x0
  802e69:	6a 00                	push   $0x0
  802e6b:	6a 00                	push   $0x0
  802e6d:	6a 00                	push   $0x0
  802e6f:	6a 00                	push   $0x0
  802e71:	6a 02                	push   $0x2
  802e73:	e8 39 fc ff ff       	call   802ab1 <syscall>
  802e78:	83 c4 18             	add    $0x18,%esp
}
  802e7b:	c9                   	leave  
  802e7c:	c3                   	ret    

00802e7d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802e7d:	55                   	push   %ebp
  802e7e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802e80:	6a 00                	push   $0x0
  802e82:	6a 00                	push   $0x0
  802e84:	6a 00                	push   $0x0
  802e86:	6a 00                	push   $0x0
  802e88:	6a 00                	push   $0x0
  802e8a:	6a 03                	push   $0x3
  802e8c:	e8 20 fc ff ff       	call   802ab1 <syscall>
  802e91:	83 c4 18             	add    $0x18,%esp
}
  802e94:	c9                   	leave  
  802e95:	c3                   	ret    

00802e96 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802e96:	55                   	push   %ebp
  802e97:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 00                	push   $0x0
  802e9d:	6a 00                	push   $0x0
  802e9f:	6a 00                	push   $0x0
  802ea1:	6a 00                	push   $0x0
  802ea3:	6a 04                	push   $0x4
  802ea5:	e8 07 fc ff ff       	call   802ab1 <syscall>
  802eaa:	83 c4 18             	add    $0x18,%esp
}
  802ead:	c9                   	leave  
  802eae:	c3                   	ret    

00802eaf <sys_exit_env>:


void sys_exit_env(void)
{
  802eaf:	55                   	push   %ebp
  802eb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802eb2:	6a 00                	push   $0x0
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 23                	push   $0x23
  802ebe:	e8 ee fb ff ff       	call   802ab1 <syscall>
  802ec3:	83 c4 18             	add    $0x18,%esp
}
  802ec6:	90                   	nop
  802ec7:	c9                   	leave  
  802ec8:	c3                   	ret    

00802ec9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802ec9:	55                   	push   %ebp
  802eca:	89 e5                	mov    %esp,%ebp
  802ecc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802ecf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802ed2:	8d 50 04             	lea    0x4(%eax),%edx
  802ed5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802ed8:	6a 00                	push   $0x0
  802eda:	6a 00                	push   $0x0
  802edc:	6a 00                	push   $0x0
  802ede:	52                   	push   %edx
  802edf:	50                   	push   %eax
  802ee0:	6a 24                	push   $0x24
  802ee2:	e8 ca fb ff ff       	call   802ab1 <syscall>
  802ee7:	83 c4 18             	add    $0x18,%esp
	return result;
  802eea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802eed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802ef0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ef3:	89 01                	mov    %eax,(%ecx)
  802ef5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	c9                   	leave  
  802efc:	c2 04 00             	ret    $0x4

00802eff <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802eff:	55                   	push   %ebp
  802f00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802f02:	6a 00                	push   $0x0
  802f04:	6a 00                	push   $0x0
  802f06:	ff 75 10             	pushl  0x10(%ebp)
  802f09:	ff 75 0c             	pushl  0xc(%ebp)
  802f0c:	ff 75 08             	pushl  0x8(%ebp)
  802f0f:	6a 12                	push   $0x12
  802f11:	e8 9b fb ff ff       	call   802ab1 <syscall>
  802f16:	83 c4 18             	add    $0x18,%esp
	return ;
  802f19:	90                   	nop
}
  802f1a:	c9                   	leave  
  802f1b:	c3                   	ret    

00802f1c <sys_rcr2>:
uint32 sys_rcr2()
{
  802f1c:	55                   	push   %ebp
  802f1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802f1f:	6a 00                	push   $0x0
  802f21:	6a 00                	push   $0x0
  802f23:	6a 00                	push   $0x0
  802f25:	6a 00                	push   $0x0
  802f27:	6a 00                	push   $0x0
  802f29:	6a 25                	push   $0x25
  802f2b:	e8 81 fb ff ff       	call   802ab1 <syscall>
  802f30:	83 c4 18             	add    $0x18,%esp
}
  802f33:	c9                   	leave  
  802f34:	c3                   	ret    

00802f35 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802f35:	55                   	push   %ebp
  802f36:	89 e5                	mov    %esp,%ebp
  802f38:	83 ec 04             	sub    $0x4,%esp
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802f41:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802f45:	6a 00                	push   $0x0
  802f47:	6a 00                	push   $0x0
  802f49:	6a 00                	push   $0x0
  802f4b:	6a 00                	push   $0x0
  802f4d:	50                   	push   %eax
  802f4e:	6a 26                	push   $0x26
  802f50:	e8 5c fb ff ff       	call   802ab1 <syscall>
  802f55:	83 c4 18             	add    $0x18,%esp
	return ;
  802f58:	90                   	nop
}
  802f59:	c9                   	leave  
  802f5a:	c3                   	ret    

00802f5b <rsttst>:
void rsttst()
{
  802f5b:	55                   	push   %ebp
  802f5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802f5e:	6a 00                	push   $0x0
  802f60:	6a 00                	push   $0x0
  802f62:	6a 00                	push   $0x0
  802f64:	6a 00                	push   $0x0
  802f66:	6a 00                	push   $0x0
  802f68:	6a 28                	push   $0x28
  802f6a:	e8 42 fb ff ff       	call   802ab1 <syscall>
  802f6f:	83 c4 18             	add    $0x18,%esp
	return ;
  802f72:	90                   	nop
}
  802f73:	c9                   	leave  
  802f74:	c3                   	ret    

00802f75 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802f75:	55                   	push   %ebp
  802f76:	89 e5                	mov    %esp,%ebp
  802f78:	83 ec 04             	sub    $0x4,%esp
  802f7b:	8b 45 14             	mov    0x14(%ebp),%eax
  802f7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802f81:	8b 55 18             	mov    0x18(%ebp),%edx
  802f84:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f88:	52                   	push   %edx
  802f89:	50                   	push   %eax
  802f8a:	ff 75 10             	pushl  0x10(%ebp)
  802f8d:	ff 75 0c             	pushl  0xc(%ebp)
  802f90:	ff 75 08             	pushl  0x8(%ebp)
  802f93:	6a 27                	push   $0x27
  802f95:	e8 17 fb ff ff       	call   802ab1 <syscall>
  802f9a:	83 c4 18             	add    $0x18,%esp
	return ;
  802f9d:	90                   	nop
}
  802f9e:	c9                   	leave  
  802f9f:	c3                   	ret    

00802fa0 <chktst>:
void chktst(uint32 n)
{
  802fa0:	55                   	push   %ebp
  802fa1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802fa3:	6a 00                	push   $0x0
  802fa5:	6a 00                	push   $0x0
  802fa7:	6a 00                	push   $0x0
  802fa9:	6a 00                	push   $0x0
  802fab:	ff 75 08             	pushl  0x8(%ebp)
  802fae:	6a 29                	push   $0x29
  802fb0:	e8 fc fa ff ff       	call   802ab1 <syscall>
  802fb5:	83 c4 18             	add    $0x18,%esp
	return ;
  802fb8:	90                   	nop
}
  802fb9:	c9                   	leave  
  802fba:	c3                   	ret    

00802fbb <inctst>:

void inctst()
{
  802fbb:	55                   	push   %ebp
  802fbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802fbe:	6a 00                	push   $0x0
  802fc0:	6a 00                	push   $0x0
  802fc2:	6a 00                	push   $0x0
  802fc4:	6a 00                	push   $0x0
  802fc6:	6a 00                	push   $0x0
  802fc8:	6a 2a                	push   $0x2a
  802fca:	e8 e2 fa ff ff       	call   802ab1 <syscall>
  802fcf:	83 c4 18             	add    $0x18,%esp
	return ;
  802fd2:	90                   	nop
}
  802fd3:	c9                   	leave  
  802fd4:	c3                   	ret    

00802fd5 <gettst>:
uint32 gettst()
{
  802fd5:	55                   	push   %ebp
  802fd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802fd8:	6a 00                	push   $0x0
  802fda:	6a 00                	push   $0x0
  802fdc:	6a 00                	push   $0x0
  802fde:	6a 00                	push   $0x0
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 2b                	push   $0x2b
  802fe4:	e8 c8 fa ff ff       	call   802ab1 <syscall>
  802fe9:	83 c4 18             	add    $0x18,%esp
}
  802fec:	c9                   	leave  
  802fed:	c3                   	ret    

00802fee <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802fee:	55                   	push   %ebp
  802fef:	89 e5                	mov    %esp,%ebp
  802ff1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ff4:	6a 00                	push   $0x0
  802ff6:	6a 00                	push   $0x0
  802ff8:	6a 00                	push   $0x0
  802ffa:	6a 00                	push   $0x0
  802ffc:	6a 00                	push   $0x0
  802ffe:	6a 2c                	push   $0x2c
  803000:	e8 ac fa ff ff       	call   802ab1 <syscall>
  803005:	83 c4 18             	add    $0x18,%esp
  803008:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80300b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80300f:	75 07                	jne    803018 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  803011:	b8 01 00 00 00       	mov    $0x1,%eax
  803016:	eb 05                	jmp    80301d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  803018:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80301d:	c9                   	leave  
  80301e:	c3                   	ret    

0080301f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80301f:	55                   	push   %ebp
  803020:	89 e5                	mov    %esp,%ebp
  803022:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803025:	6a 00                	push   $0x0
  803027:	6a 00                	push   $0x0
  803029:	6a 00                	push   $0x0
  80302b:	6a 00                	push   $0x0
  80302d:	6a 00                	push   $0x0
  80302f:	6a 2c                	push   $0x2c
  803031:	e8 7b fa ff ff       	call   802ab1 <syscall>
  803036:	83 c4 18             	add    $0x18,%esp
  803039:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80303c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  803040:	75 07                	jne    803049 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  803042:	b8 01 00 00 00       	mov    $0x1,%eax
  803047:	eb 05                	jmp    80304e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  803049:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80304e:	c9                   	leave  
  80304f:	c3                   	ret    

00803050 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  803050:	55                   	push   %ebp
  803051:	89 e5                	mov    %esp,%ebp
  803053:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	6a 00                	push   $0x0
  80305e:	6a 00                	push   $0x0
  803060:	6a 2c                	push   $0x2c
  803062:	e8 4a fa ff ff       	call   802ab1 <syscall>
  803067:	83 c4 18             	add    $0x18,%esp
  80306a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80306d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803071:	75 07                	jne    80307a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803073:	b8 01 00 00 00       	mov    $0x1,%eax
  803078:	eb 05                	jmp    80307f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80307a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80307f:	c9                   	leave  
  803080:	c3                   	ret    

00803081 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803081:	55                   	push   %ebp
  803082:	89 e5                	mov    %esp,%ebp
  803084:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803087:	6a 00                	push   $0x0
  803089:	6a 00                	push   $0x0
  80308b:	6a 00                	push   $0x0
  80308d:	6a 00                	push   $0x0
  80308f:	6a 00                	push   $0x0
  803091:	6a 2c                	push   $0x2c
  803093:	e8 19 fa ff ff       	call   802ab1 <syscall>
  803098:	83 c4 18             	add    $0x18,%esp
  80309b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80309e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8030a2:	75 07                	jne    8030ab <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8030a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8030a9:	eb 05                	jmp    8030b0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8030ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b0:	c9                   	leave  
  8030b1:	c3                   	ret    

008030b2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8030b2:	55                   	push   %ebp
  8030b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 00                	push   $0x0
  8030b9:	6a 00                	push   $0x0
  8030bb:	6a 00                	push   $0x0
  8030bd:	ff 75 08             	pushl  0x8(%ebp)
  8030c0:	6a 2d                	push   $0x2d
  8030c2:	e8 ea f9 ff ff       	call   802ab1 <syscall>
  8030c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8030ca:	90                   	nop
}
  8030cb:	c9                   	leave  
  8030cc:	c3                   	ret    

008030cd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8030cd:	55                   	push   %ebp
  8030ce:	89 e5                	mov    %esp,%ebp
  8030d0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8030d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8030d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	6a 00                	push   $0x0
  8030df:	53                   	push   %ebx
  8030e0:	51                   	push   %ecx
  8030e1:	52                   	push   %edx
  8030e2:	50                   	push   %eax
  8030e3:	6a 2e                	push   $0x2e
  8030e5:	e8 c7 f9 ff ff       	call   802ab1 <syscall>
  8030ea:	83 c4 18             	add    $0x18,%esp
}
  8030ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030f0:	c9                   	leave  
  8030f1:	c3                   	ret    

008030f2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8030f2:	55                   	push   %ebp
  8030f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8030f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	6a 00                	push   $0x0
  8030fd:	6a 00                	push   $0x0
  8030ff:	6a 00                	push   $0x0
  803101:	52                   	push   %edx
  803102:	50                   	push   %eax
  803103:	6a 2f                	push   $0x2f
  803105:	e8 a7 f9 ff ff       	call   802ab1 <syscall>
  80310a:	83 c4 18             	add    $0x18,%esp
}
  80310d:	c9                   	leave  
  80310e:	c3                   	ret    

0080310f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80310f:	55                   	push   %ebp
  803110:	89 e5                	mov    %esp,%ebp
  803112:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  803115:	83 ec 0c             	sub    $0xc,%esp
  803118:	68 bc 4d 80 00       	push   $0x804dbc
  80311d:	e8 21 e7 ff ff       	call   801843 <cprintf>
  803122:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  803125:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80312c:	83 ec 0c             	sub    $0xc,%esp
  80312f:	68 e8 4d 80 00       	push   $0x804de8
  803134:	e8 0a e7 ff ff       	call   801843 <cprintf>
  803139:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80313c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803140:	a1 38 51 80 00       	mov    0x805138,%eax
  803145:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803148:	eb 56                	jmp    8031a0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80314a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80314e:	74 1c                	je     80316c <print_mem_block_lists+0x5d>
  803150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803153:	8b 50 08             	mov    0x8(%eax),%edx
  803156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803159:	8b 48 08             	mov    0x8(%eax),%ecx
  80315c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315f:	8b 40 0c             	mov    0xc(%eax),%eax
  803162:	01 c8                	add    %ecx,%eax
  803164:	39 c2                	cmp    %eax,%edx
  803166:	73 04                	jae    80316c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  803168:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316f:	8b 50 08             	mov    0x8(%eax),%edx
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	8b 40 0c             	mov    0xc(%eax),%eax
  803178:	01 c2                	add    %eax,%edx
  80317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317d:	8b 40 08             	mov    0x8(%eax),%eax
  803180:	83 ec 04             	sub    $0x4,%esp
  803183:	52                   	push   %edx
  803184:	50                   	push   %eax
  803185:	68 fd 4d 80 00       	push   $0x804dfd
  80318a:	e8 b4 e6 ff ff       	call   801843 <cprintf>
  80318f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803198:	a1 40 51 80 00       	mov    0x805140,%eax
  80319d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a4:	74 07                	je     8031ad <print_mem_block_lists+0x9e>
  8031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	eb 05                	jmp    8031b2 <print_mem_block_lists+0xa3>
  8031ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b2:	a3 40 51 80 00       	mov    %eax,0x805140
  8031b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	75 8a                	jne    80314a <print_mem_block_lists+0x3b>
  8031c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c4:	75 84                	jne    80314a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8031c6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8031ca:	75 10                	jne    8031dc <print_mem_block_lists+0xcd>
  8031cc:	83 ec 0c             	sub    $0xc,%esp
  8031cf:	68 0c 4e 80 00       	push   $0x804e0c
  8031d4:	e8 6a e6 ff ff       	call   801843 <cprintf>
  8031d9:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8031dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8031e3:	83 ec 0c             	sub    $0xc,%esp
  8031e6:	68 30 4e 80 00       	push   $0x804e30
  8031eb:	e8 53 e6 ff ff       	call   801843 <cprintf>
  8031f0:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8031f3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8031f7:	a1 40 50 80 00       	mov    0x805040,%eax
  8031fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ff:	eb 56                	jmp    803257 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803201:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803205:	74 1c                	je     803223 <print_mem_block_lists+0x114>
  803207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320a:	8b 50 08             	mov    0x8(%eax),%edx
  80320d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803210:	8b 48 08             	mov    0x8(%eax),%ecx
  803213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803216:	8b 40 0c             	mov    0xc(%eax),%eax
  803219:	01 c8                	add    %ecx,%eax
  80321b:	39 c2                	cmp    %eax,%edx
  80321d:	73 04                	jae    803223 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80321f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	8b 50 08             	mov    0x8(%eax),%edx
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 40 0c             	mov    0xc(%eax),%eax
  80322f:	01 c2                	add    %eax,%edx
  803231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803234:	8b 40 08             	mov    0x8(%eax),%eax
  803237:	83 ec 04             	sub    $0x4,%esp
  80323a:	52                   	push   %edx
  80323b:	50                   	push   %eax
  80323c:	68 fd 4d 80 00       	push   $0x804dfd
  803241:	e8 fd e5 ff ff       	call   801843 <cprintf>
  803246:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80324f:	a1 48 50 80 00       	mov    0x805048,%eax
  803254:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803257:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325b:	74 07                	je     803264 <print_mem_block_lists+0x155>
  80325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803260:	8b 00                	mov    (%eax),%eax
  803262:	eb 05                	jmp    803269 <print_mem_block_lists+0x15a>
  803264:	b8 00 00 00 00       	mov    $0x0,%eax
  803269:	a3 48 50 80 00       	mov    %eax,0x805048
  80326e:	a1 48 50 80 00       	mov    0x805048,%eax
  803273:	85 c0                	test   %eax,%eax
  803275:	75 8a                	jne    803201 <print_mem_block_lists+0xf2>
  803277:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327b:	75 84                	jne    803201 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80327d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803281:	75 10                	jne    803293 <print_mem_block_lists+0x184>
  803283:	83 ec 0c             	sub    $0xc,%esp
  803286:	68 48 4e 80 00       	push   $0x804e48
  80328b:	e8 b3 e5 ff ff       	call   801843 <cprintf>
  803290:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803293:	83 ec 0c             	sub    $0xc,%esp
  803296:	68 bc 4d 80 00       	push   $0x804dbc
  80329b:	e8 a3 e5 ff ff       	call   801843 <cprintf>
  8032a0:	83 c4 10             	add    $0x10,%esp

}
  8032a3:	90                   	nop
  8032a4:	c9                   	leave  
  8032a5:	c3                   	ret    

008032a6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8032a6:	55                   	push   %ebp
  8032a7:	89 e5                	mov    %esp,%ebp
  8032a9:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8032ac:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8032b3:	00 00 00 
  8032b6:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8032bd:	00 00 00 
  8032c0:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8032c7:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8032ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8032d1:	e9 9e 00 00 00       	jmp    803374 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8032d6:	a1 50 50 80 00       	mov    0x805050,%eax
  8032db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032de:	c1 e2 04             	shl    $0x4,%edx
  8032e1:	01 d0                	add    %edx,%eax
  8032e3:	85 c0                	test   %eax,%eax
  8032e5:	75 14                	jne    8032fb <initialize_MemBlocksList+0x55>
  8032e7:	83 ec 04             	sub    $0x4,%esp
  8032ea:	68 70 4e 80 00       	push   $0x804e70
  8032ef:	6a 43                	push   $0x43
  8032f1:	68 93 4e 80 00       	push   $0x804e93
  8032f6:	e8 94 e2 ff ff       	call   80158f <_panic>
  8032fb:	a1 50 50 80 00       	mov    0x805050,%eax
  803300:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803303:	c1 e2 04             	shl    $0x4,%edx
  803306:	01 d0                	add    %edx,%eax
  803308:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80330e:	89 10                	mov    %edx,(%eax)
  803310:	8b 00                	mov    (%eax),%eax
  803312:	85 c0                	test   %eax,%eax
  803314:	74 18                	je     80332e <initialize_MemBlocksList+0x88>
  803316:	a1 48 51 80 00       	mov    0x805148,%eax
  80331b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  803321:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803324:	c1 e1 04             	shl    $0x4,%ecx
  803327:	01 ca                	add    %ecx,%edx
  803329:	89 50 04             	mov    %edx,0x4(%eax)
  80332c:	eb 12                	jmp    803340 <initialize_MemBlocksList+0x9a>
  80332e:	a1 50 50 80 00       	mov    0x805050,%eax
  803333:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803336:	c1 e2 04             	shl    $0x4,%edx
  803339:	01 d0                	add    %edx,%eax
  80333b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803340:	a1 50 50 80 00       	mov    0x805050,%eax
  803345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803348:	c1 e2 04             	shl    $0x4,%edx
  80334b:	01 d0                	add    %edx,%eax
  80334d:	a3 48 51 80 00       	mov    %eax,0x805148
  803352:	a1 50 50 80 00       	mov    0x805050,%eax
  803357:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335a:	c1 e2 04             	shl    $0x4,%edx
  80335d:	01 d0                	add    %edx,%eax
  80335f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803366:	a1 54 51 80 00       	mov    0x805154,%eax
  80336b:	40                   	inc    %eax
  80336c:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  803371:	ff 45 f4             	incl   -0xc(%ebp)
  803374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803377:	3b 45 08             	cmp    0x8(%ebp),%eax
  80337a:	0f 82 56 ff ff ff    	jb     8032d6 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  803380:	90                   	nop
  803381:	c9                   	leave  
  803382:	c3                   	ret    

00803383 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803383:	55                   	push   %ebp
  803384:	89 e5                	mov    %esp,%ebp
  803386:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  803389:	a1 38 51 80 00       	mov    0x805138,%eax
  80338e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803391:	eb 18                	jmp    8033ab <find_block+0x28>
	{
		if (ele->sva==va)
  803393:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803396:	8b 40 08             	mov    0x8(%eax),%eax
  803399:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80339c:	75 05                	jne    8033a3 <find_block+0x20>
			return ele;
  80339e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033a1:	eb 7b                	jmp    80341e <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8033a3:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8033ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8033af:	74 07                	je     8033b8 <find_block+0x35>
  8033b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033b4:	8b 00                	mov    (%eax),%eax
  8033b6:	eb 05                	jmp    8033bd <find_block+0x3a>
  8033b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bd:	a3 40 51 80 00       	mov    %eax,0x805140
  8033c2:	a1 40 51 80 00       	mov    0x805140,%eax
  8033c7:	85 c0                	test   %eax,%eax
  8033c9:	75 c8                	jne    803393 <find_block+0x10>
  8033cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8033cf:	75 c2                	jne    803393 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8033d1:	a1 40 50 80 00       	mov    0x805040,%eax
  8033d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8033d9:	eb 18                	jmp    8033f3 <find_block+0x70>
	{
		if (ele->sva==va)
  8033db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033de:	8b 40 08             	mov    0x8(%eax),%eax
  8033e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033e4:	75 05                	jne    8033eb <find_block+0x68>
					return ele;
  8033e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033e9:	eb 33                	jmp    80341e <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8033eb:	a1 48 50 80 00       	mov    0x805048,%eax
  8033f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8033f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8033f7:	74 07                	je     803400 <find_block+0x7d>
  8033f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033fc:	8b 00                	mov    (%eax),%eax
  8033fe:	eb 05                	jmp    803405 <find_block+0x82>
  803400:	b8 00 00 00 00       	mov    $0x0,%eax
  803405:	a3 48 50 80 00       	mov    %eax,0x805048
  80340a:	a1 48 50 80 00       	mov    0x805048,%eax
  80340f:	85 c0                	test   %eax,%eax
  803411:	75 c8                	jne    8033db <find_block+0x58>
  803413:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803417:	75 c2                	jne    8033db <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  803419:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80341e:	c9                   	leave  
  80341f:	c3                   	ret    

00803420 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803420:	55                   	push   %ebp
  803421:	89 e5                	mov    %esp,%ebp
  803423:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  803426:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80342b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80342e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803432:	75 62                	jne    803496 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  803434:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803438:	75 14                	jne    80344e <insert_sorted_allocList+0x2e>
  80343a:	83 ec 04             	sub    $0x4,%esp
  80343d:	68 70 4e 80 00       	push   $0x804e70
  803442:	6a 69                	push   $0x69
  803444:	68 93 4e 80 00       	push   $0x804e93
  803449:	e8 41 e1 ff ff       	call   80158f <_panic>
  80344e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	89 10                	mov    %edx,(%eax)
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	85 c0                	test   %eax,%eax
  803460:	74 0d                	je     80346f <insert_sorted_allocList+0x4f>
  803462:	a1 40 50 80 00       	mov    0x805040,%eax
  803467:	8b 55 08             	mov    0x8(%ebp),%edx
  80346a:	89 50 04             	mov    %edx,0x4(%eax)
  80346d:	eb 08                	jmp    803477 <insert_sorted_allocList+0x57>
  80346f:	8b 45 08             	mov    0x8(%ebp),%eax
  803472:	a3 44 50 80 00       	mov    %eax,0x805044
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	a3 40 50 80 00       	mov    %eax,0x805040
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803489:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80348e:	40                   	inc    %eax
  80348f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803494:	eb 72                	jmp    803508 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  803496:	a1 40 50 80 00       	mov    0x805040,%eax
  80349b:	8b 50 08             	mov    0x8(%eax),%edx
  80349e:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a1:	8b 40 08             	mov    0x8(%eax),%eax
  8034a4:	39 c2                	cmp    %eax,%edx
  8034a6:	76 60                	jbe    803508 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8034a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ac:	75 14                	jne    8034c2 <insert_sorted_allocList+0xa2>
  8034ae:	83 ec 04             	sub    $0x4,%esp
  8034b1:	68 70 4e 80 00       	push   $0x804e70
  8034b6:	6a 6d                	push   $0x6d
  8034b8:	68 93 4e 80 00       	push   $0x804e93
  8034bd:	e8 cd e0 ff ff       	call   80158f <_panic>
  8034c2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8034c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cb:	89 10                	mov    %edx,(%eax)
  8034cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d0:	8b 00                	mov    (%eax),%eax
  8034d2:	85 c0                	test   %eax,%eax
  8034d4:	74 0d                	je     8034e3 <insert_sorted_allocList+0xc3>
  8034d6:	a1 40 50 80 00       	mov    0x805040,%eax
  8034db:	8b 55 08             	mov    0x8(%ebp),%edx
  8034de:	89 50 04             	mov    %edx,0x4(%eax)
  8034e1:	eb 08                	jmp    8034eb <insert_sorted_allocList+0xcb>
  8034e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e6:	a3 44 50 80 00       	mov    %eax,0x805044
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	a3 40 50 80 00       	mov    %eax,0x805040
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034fd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803502:	40                   	inc    %eax
  803503:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  803508:	a1 40 50 80 00       	mov    0x805040,%eax
  80350d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803510:	e9 b9 01 00 00       	jmp    8036ce <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	8b 50 08             	mov    0x8(%eax),%edx
  80351b:	a1 40 50 80 00       	mov    0x805040,%eax
  803520:	8b 40 08             	mov    0x8(%eax),%eax
  803523:	39 c2                	cmp    %eax,%edx
  803525:	76 7c                	jbe    8035a3 <insert_sorted_allocList+0x183>
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	8b 50 08             	mov    0x8(%eax),%edx
  80352d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803530:	8b 40 08             	mov    0x8(%eax),%eax
  803533:	39 c2                	cmp    %eax,%edx
  803535:	73 6c                	jae    8035a3 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  803537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80353b:	74 06                	je     803543 <insert_sorted_allocList+0x123>
  80353d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803541:	75 14                	jne    803557 <insert_sorted_allocList+0x137>
  803543:	83 ec 04             	sub    $0x4,%esp
  803546:	68 ac 4e 80 00       	push   $0x804eac
  80354b:	6a 75                	push   $0x75
  80354d:	68 93 4e 80 00       	push   $0x804e93
  803552:	e8 38 e0 ff ff       	call   80158f <_panic>
  803557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355a:	8b 50 04             	mov    0x4(%eax),%edx
  80355d:	8b 45 08             	mov    0x8(%ebp),%eax
  803560:	89 50 04             	mov    %edx,0x4(%eax)
  803563:	8b 45 08             	mov    0x8(%ebp),%eax
  803566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803569:	89 10                	mov    %edx,(%eax)
  80356b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356e:	8b 40 04             	mov    0x4(%eax),%eax
  803571:	85 c0                	test   %eax,%eax
  803573:	74 0d                	je     803582 <insert_sorted_allocList+0x162>
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	8b 40 04             	mov    0x4(%eax),%eax
  80357b:	8b 55 08             	mov    0x8(%ebp),%edx
  80357e:	89 10                	mov    %edx,(%eax)
  803580:	eb 08                	jmp    80358a <insert_sorted_allocList+0x16a>
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	a3 40 50 80 00       	mov    %eax,0x805040
  80358a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358d:	8b 55 08             	mov    0x8(%ebp),%edx
  803590:	89 50 04             	mov    %edx,0x4(%eax)
  803593:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803598:	40                   	inc    %eax
  803599:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  80359e:	e9 59 01 00 00       	jmp    8036fc <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	8b 50 08             	mov    0x8(%eax),%edx
  8035a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ac:	8b 40 08             	mov    0x8(%eax),%eax
  8035af:	39 c2                	cmp    %eax,%edx
  8035b1:	0f 86 98 00 00 00    	jbe    80364f <insert_sorted_allocList+0x22f>
  8035b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ba:	8b 50 08             	mov    0x8(%eax),%edx
  8035bd:	a1 44 50 80 00       	mov    0x805044,%eax
  8035c2:	8b 40 08             	mov    0x8(%eax),%eax
  8035c5:	39 c2                	cmp    %eax,%edx
  8035c7:	0f 83 82 00 00 00    	jae    80364f <insert_sorted_allocList+0x22f>
  8035cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d0:	8b 50 08             	mov    0x8(%eax),%edx
  8035d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d6:	8b 00                	mov    (%eax),%eax
  8035d8:	8b 40 08             	mov    0x8(%eax),%eax
  8035db:	39 c2                	cmp    %eax,%edx
  8035dd:	73 70                	jae    80364f <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8035df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e3:	74 06                	je     8035eb <insert_sorted_allocList+0x1cb>
  8035e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e9:	75 14                	jne    8035ff <insert_sorted_allocList+0x1df>
  8035eb:	83 ec 04             	sub    $0x4,%esp
  8035ee:	68 e4 4e 80 00       	push   $0x804ee4
  8035f3:	6a 7c                	push   $0x7c
  8035f5:	68 93 4e 80 00       	push   $0x804e93
  8035fa:	e8 90 df ff ff       	call   80158f <_panic>
  8035ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803602:	8b 10                	mov    (%eax),%edx
  803604:	8b 45 08             	mov    0x8(%ebp),%eax
  803607:	89 10                	mov    %edx,(%eax)
  803609:	8b 45 08             	mov    0x8(%ebp),%eax
  80360c:	8b 00                	mov    (%eax),%eax
  80360e:	85 c0                	test   %eax,%eax
  803610:	74 0b                	je     80361d <insert_sorted_allocList+0x1fd>
  803612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803615:	8b 00                	mov    (%eax),%eax
  803617:	8b 55 08             	mov    0x8(%ebp),%edx
  80361a:	89 50 04             	mov    %edx,0x4(%eax)
  80361d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803620:	8b 55 08             	mov    0x8(%ebp),%edx
  803623:	89 10                	mov    %edx,(%eax)
  803625:	8b 45 08             	mov    0x8(%ebp),%eax
  803628:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80362b:	89 50 04             	mov    %edx,0x4(%eax)
  80362e:	8b 45 08             	mov    0x8(%ebp),%eax
  803631:	8b 00                	mov    (%eax),%eax
  803633:	85 c0                	test   %eax,%eax
  803635:	75 08                	jne    80363f <insert_sorted_allocList+0x21f>
  803637:	8b 45 08             	mov    0x8(%ebp),%eax
  80363a:	a3 44 50 80 00       	mov    %eax,0x805044
  80363f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803644:	40                   	inc    %eax
  803645:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  80364a:	e9 ad 00 00 00       	jmp    8036fc <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80364f:	8b 45 08             	mov    0x8(%ebp),%eax
  803652:	8b 50 08             	mov    0x8(%eax),%edx
  803655:	a1 44 50 80 00       	mov    0x805044,%eax
  80365a:	8b 40 08             	mov    0x8(%eax),%eax
  80365d:	39 c2                	cmp    %eax,%edx
  80365f:	76 65                	jbe    8036c6 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  803661:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803665:	75 17                	jne    80367e <insert_sorted_allocList+0x25e>
  803667:	83 ec 04             	sub    $0x4,%esp
  80366a:	68 18 4f 80 00       	push   $0x804f18
  80366f:	68 80 00 00 00       	push   $0x80
  803674:	68 93 4e 80 00       	push   $0x804e93
  803679:	e8 11 df ff ff       	call   80158f <_panic>
  80367e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  803684:	8b 45 08             	mov    0x8(%ebp),%eax
  803687:	89 50 04             	mov    %edx,0x4(%eax)
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	8b 40 04             	mov    0x4(%eax),%eax
  803690:	85 c0                	test   %eax,%eax
  803692:	74 0c                	je     8036a0 <insert_sorted_allocList+0x280>
  803694:	a1 44 50 80 00       	mov    0x805044,%eax
  803699:	8b 55 08             	mov    0x8(%ebp),%edx
  80369c:	89 10                	mov    %edx,(%eax)
  80369e:	eb 08                	jmp    8036a8 <insert_sorted_allocList+0x288>
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	a3 40 50 80 00       	mov    %eax,0x805040
  8036a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ab:	a3 44 50 80 00       	mov    %eax,0x805044
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8036be:	40                   	inc    %eax
  8036bf:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  8036c4:	eb 36                	jmp    8036fc <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8036c6:	a1 48 50 80 00       	mov    0x805048,%eax
  8036cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d2:	74 07                	je     8036db <insert_sorted_allocList+0x2bb>
  8036d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d7:	8b 00                	mov    (%eax),%eax
  8036d9:	eb 05                	jmp    8036e0 <insert_sorted_allocList+0x2c0>
  8036db:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e0:	a3 48 50 80 00       	mov    %eax,0x805048
  8036e5:	a1 48 50 80 00       	mov    0x805048,%eax
  8036ea:	85 c0                	test   %eax,%eax
  8036ec:	0f 85 23 fe ff ff    	jne    803515 <insert_sorted_allocList+0xf5>
  8036f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036f6:	0f 85 19 fe ff ff    	jne    803515 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8036fc:	90                   	nop
  8036fd:	c9                   	leave  
  8036fe:	c3                   	ret    

008036ff <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8036ff:	55                   	push   %ebp
  803700:	89 e5                	mov    %esp,%ebp
  803702:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803705:	a1 38 51 80 00       	mov    0x805138,%eax
  80370a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80370d:	e9 7c 01 00 00       	jmp    80388e <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	8b 40 0c             	mov    0xc(%eax),%eax
  803718:	3b 45 08             	cmp    0x8(%ebp),%eax
  80371b:	0f 85 90 00 00 00    	jne    8037b1 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  803721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803724:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  803727:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80372b:	75 17                	jne    803744 <alloc_block_FF+0x45>
  80372d:	83 ec 04             	sub    $0x4,%esp
  803730:	68 3b 4f 80 00       	push   $0x804f3b
  803735:	68 ba 00 00 00       	push   $0xba
  80373a:	68 93 4e 80 00       	push   $0x804e93
  80373f:	e8 4b de ff ff       	call   80158f <_panic>
  803744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803747:	8b 00                	mov    (%eax),%eax
  803749:	85 c0                	test   %eax,%eax
  80374b:	74 10                	je     80375d <alloc_block_FF+0x5e>
  80374d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803750:	8b 00                	mov    (%eax),%eax
  803752:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803755:	8b 52 04             	mov    0x4(%edx),%edx
  803758:	89 50 04             	mov    %edx,0x4(%eax)
  80375b:	eb 0b                	jmp    803768 <alloc_block_FF+0x69>
  80375d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803760:	8b 40 04             	mov    0x4(%eax),%eax
  803763:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376b:	8b 40 04             	mov    0x4(%eax),%eax
  80376e:	85 c0                	test   %eax,%eax
  803770:	74 0f                	je     803781 <alloc_block_FF+0x82>
  803772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803775:	8b 40 04             	mov    0x4(%eax),%eax
  803778:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80377b:	8b 12                	mov    (%edx),%edx
  80377d:	89 10                	mov    %edx,(%eax)
  80377f:	eb 0a                	jmp    80378b <alloc_block_FF+0x8c>
  803781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803784:	8b 00                	mov    (%eax),%eax
  803786:	a3 38 51 80 00       	mov    %eax,0x805138
  80378b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803797:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80379e:	a1 44 51 80 00       	mov    0x805144,%eax
  8037a3:	48                   	dec    %eax
  8037a4:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  8037a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ac:	e9 10 01 00 00       	jmp    8038c1 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8037b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037ba:	0f 86 c6 00 00 00    	jbe    803886 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8037c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8037c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8037c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037cc:	75 17                	jne    8037e5 <alloc_block_FF+0xe6>
  8037ce:	83 ec 04             	sub    $0x4,%esp
  8037d1:	68 3b 4f 80 00       	push   $0x804f3b
  8037d6:	68 c2 00 00 00       	push   $0xc2
  8037db:	68 93 4e 80 00       	push   $0x804e93
  8037e0:	e8 aa dd ff ff       	call   80158f <_panic>
  8037e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e8:	8b 00                	mov    (%eax),%eax
  8037ea:	85 c0                	test   %eax,%eax
  8037ec:	74 10                	je     8037fe <alloc_block_FF+0xff>
  8037ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f1:	8b 00                	mov    (%eax),%eax
  8037f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037f6:	8b 52 04             	mov    0x4(%edx),%edx
  8037f9:	89 50 04             	mov    %edx,0x4(%eax)
  8037fc:	eb 0b                	jmp    803809 <alloc_block_FF+0x10a>
  8037fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803801:	8b 40 04             	mov    0x4(%eax),%eax
  803804:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80380c:	8b 40 04             	mov    0x4(%eax),%eax
  80380f:	85 c0                	test   %eax,%eax
  803811:	74 0f                	je     803822 <alloc_block_FF+0x123>
  803813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803816:	8b 40 04             	mov    0x4(%eax),%eax
  803819:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80381c:	8b 12                	mov    (%edx),%edx
  80381e:	89 10                	mov    %edx,(%eax)
  803820:	eb 0a                	jmp    80382c <alloc_block_FF+0x12d>
  803822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803825:	8b 00                	mov    (%eax),%eax
  803827:	a3 48 51 80 00       	mov    %eax,0x805148
  80382c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803838:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80383f:	a1 54 51 80 00       	mov    0x805154,%eax
  803844:	48                   	dec    %eax
  803845:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  80384a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384d:	8b 50 08             	mov    0x8(%eax),%edx
  803850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803853:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  803856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803859:	8b 55 08             	mov    0x8(%ebp),%edx
  80385c:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80385f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803862:	8b 40 0c             	mov    0xc(%eax),%eax
  803865:	2b 45 08             	sub    0x8(%ebp),%eax
  803868:	89 c2                	mov    %eax,%edx
  80386a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386d:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  803870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803873:	8b 50 08             	mov    0x8(%eax),%edx
  803876:	8b 45 08             	mov    0x8(%ebp),%eax
  803879:	01 c2                	add    %eax,%edx
  80387b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387e:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  803881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803884:	eb 3b                	jmp    8038c1 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  803886:	a1 40 51 80 00       	mov    0x805140,%eax
  80388b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80388e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803892:	74 07                	je     80389b <alloc_block_FF+0x19c>
  803894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803897:	8b 00                	mov    (%eax),%eax
  803899:	eb 05                	jmp    8038a0 <alloc_block_FF+0x1a1>
  80389b:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a0:	a3 40 51 80 00       	mov    %eax,0x805140
  8038a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8038aa:	85 c0                	test   %eax,%eax
  8038ac:	0f 85 60 fe ff ff    	jne    803712 <alloc_block_FF+0x13>
  8038b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038b6:	0f 85 56 fe ff ff    	jne    803712 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8038bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c1:	c9                   	leave  
  8038c2:	c3                   	ret    

008038c3 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8038c3:	55                   	push   %ebp
  8038c4:	89 e5                	mov    %esp,%ebp
  8038c6:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8038c9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8038d0:	a1 38 51 80 00       	mov    0x805138,%eax
  8038d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038d8:	eb 3a                	jmp    803914 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8038da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8038e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038e3:	72 27                	jb     80390c <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8038e5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8038e9:	75 0b                	jne    8038f6 <alloc_block_BF+0x33>
					best_size= element->size;
  8038eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8038f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8038f4:	eb 16                	jmp    80390c <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8038f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8038fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ff:	39 c2                	cmp    %eax,%edx
  803901:	77 09                	ja     80390c <alloc_block_BF+0x49>
					best_size=element->size;
  803903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803906:	8b 40 0c             	mov    0xc(%eax),%eax
  803909:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80390c:	a1 40 51 80 00       	mov    0x805140,%eax
  803911:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803914:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803918:	74 07                	je     803921 <alloc_block_BF+0x5e>
  80391a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391d:	8b 00                	mov    (%eax),%eax
  80391f:	eb 05                	jmp    803926 <alloc_block_BF+0x63>
  803921:	b8 00 00 00 00       	mov    $0x0,%eax
  803926:	a3 40 51 80 00       	mov    %eax,0x805140
  80392b:	a1 40 51 80 00       	mov    0x805140,%eax
  803930:	85 c0                	test   %eax,%eax
  803932:	75 a6                	jne    8038da <alloc_block_BF+0x17>
  803934:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803938:	75 a0                	jne    8038da <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80393a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80393e:	0f 84 d3 01 00 00    	je     803b17 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  803944:	a1 38 51 80 00       	mov    0x805138,%eax
  803949:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80394c:	e9 98 01 00 00       	jmp    803ae9 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  803951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803954:	3b 45 08             	cmp    0x8(%ebp),%eax
  803957:	0f 86 da 00 00 00    	jbe    803a37 <alloc_block_BF+0x174>
  80395d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803960:	8b 50 0c             	mov    0xc(%eax),%edx
  803963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803966:	39 c2                	cmp    %eax,%edx
  803968:	0f 85 c9 00 00 00    	jne    803a37 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  80396e:	a1 48 51 80 00       	mov    0x805148,%eax
  803973:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  803976:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80397a:	75 17                	jne    803993 <alloc_block_BF+0xd0>
  80397c:	83 ec 04             	sub    $0x4,%esp
  80397f:	68 3b 4f 80 00       	push   $0x804f3b
  803984:	68 ea 00 00 00       	push   $0xea
  803989:	68 93 4e 80 00       	push   $0x804e93
  80398e:	e8 fc db ff ff       	call   80158f <_panic>
  803993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803996:	8b 00                	mov    (%eax),%eax
  803998:	85 c0                	test   %eax,%eax
  80399a:	74 10                	je     8039ac <alloc_block_BF+0xe9>
  80399c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80399f:	8b 00                	mov    (%eax),%eax
  8039a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039a4:	8b 52 04             	mov    0x4(%edx),%edx
  8039a7:	89 50 04             	mov    %edx,0x4(%eax)
  8039aa:	eb 0b                	jmp    8039b7 <alloc_block_BF+0xf4>
  8039ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039af:	8b 40 04             	mov    0x4(%eax),%eax
  8039b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039ba:	8b 40 04             	mov    0x4(%eax),%eax
  8039bd:	85 c0                	test   %eax,%eax
  8039bf:	74 0f                	je     8039d0 <alloc_block_BF+0x10d>
  8039c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039c4:	8b 40 04             	mov    0x4(%eax),%eax
  8039c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039ca:	8b 12                	mov    (%edx),%edx
  8039cc:	89 10                	mov    %edx,(%eax)
  8039ce:	eb 0a                	jmp    8039da <alloc_block_BF+0x117>
  8039d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039d3:	8b 00                	mov    (%eax),%eax
  8039d5:	a3 48 51 80 00       	mov    %eax,0x805148
  8039da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ed:	a1 54 51 80 00       	mov    0x805154,%eax
  8039f2:	48                   	dec    %eax
  8039f3:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  8039f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fb:	8b 50 08             	mov    0x8(%eax),%edx
  8039fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a01:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  803a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a07:	8b 55 08             	mov    0x8(%ebp),%edx
  803a0a:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  803a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a10:	8b 40 0c             	mov    0xc(%eax),%eax
  803a13:	2b 45 08             	sub    0x8(%ebp),%eax
  803a16:	89 c2                	mov    %eax,%edx
  803a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1b:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  803a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a21:	8b 50 08             	mov    0x8(%eax),%edx
  803a24:	8b 45 08             	mov    0x8(%ebp),%eax
  803a27:	01 c2                	add    %eax,%edx
  803a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2c:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  803a2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a32:	e9 e5 00 00 00       	jmp    803b1c <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  803a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3a:	8b 50 0c             	mov    0xc(%eax),%edx
  803a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a40:	39 c2                	cmp    %eax,%edx
  803a42:	0f 85 99 00 00 00    	jne    803ae1 <alloc_block_BF+0x21e>
  803a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a4e:	0f 85 8d 00 00 00    	jne    803ae1 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  803a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a57:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  803a5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a5e:	75 17                	jne    803a77 <alloc_block_BF+0x1b4>
  803a60:	83 ec 04             	sub    $0x4,%esp
  803a63:	68 3b 4f 80 00       	push   $0x804f3b
  803a68:	68 f7 00 00 00       	push   $0xf7
  803a6d:	68 93 4e 80 00       	push   $0x804e93
  803a72:	e8 18 db ff ff       	call   80158f <_panic>
  803a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7a:	8b 00                	mov    (%eax),%eax
  803a7c:	85 c0                	test   %eax,%eax
  803a7e:	74 10                	je     803a90 <alloc_block_BF+0x1cd>
  803a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a83:	8b 00                	mov    (%eax),%eax
  803a85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a88:	8b 52 04             	mov    0x4(%edx),%edx
  803a8b:	89 50 04             	mov    %edx,0x4(%eax)
  803a8e:	eb 0b                	jmp    803a9b <alloc_block_BF+0x1d8>
  803a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a93:	8b 40 04             	mov    0x4(%eax),%eax
  803a96:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9e:	8b 40 04             	mov    0x4(%eax),%eax
  803aa1:	85 c0                	test   %eax,%eax
  803aa3:	74 0f                	je     803ab4 <alloc_block_BF+0x1f1>
  803aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa8:	8b 40 04             	mov    0x4(%eax),%eax
  803aab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aae:	8b 12                	mov    (%edx),%edx
  803ab0:	89 10                	mov    %edx,(%eax)
  803ab2:	eb 0a                	jmp    803abe <alloc_block_BF+0x1fb>
  803ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab7:	8b 00                	mov    (%eax),%eax
  803ab9:	a3 38 51 80 00       	mov    %eax,0x805138
  803abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ad1:	a1 44 51 80 00       	mov    0x805144,%eax
  803ad6:	48                   	dec    %eax
  803ad7:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  803adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803adf:	eb 3b                	jmp    803b1c <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  803ae1:	a1 40 51 80 00       	mov    0x805140,%eax
  803ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aed:	74 07                	je     803af6 <alloc_block_BF+0x233>
  803aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af2:	8b 00                	mov    (%eax),%eax
  803af4:	eb 05                	jmp    803afb <alloc_block_BF+0x238>
  803af6:	b8 00 00 00 00       	mov    $0x0,%eax
  803afb:	a3 40 51 80 00       	mov    %eax,0x805140
  803b00:	a1 40 51 80 00       	mov    0x805140,%eax
  803b05:	85 c0                	test   %eax,%eax
  803b07:	0f 85 44 fe ff ff    	jne    803951 <alloc_block_BF+0x8e>
  803b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b11:	0f 85 3a fe ff ff    	jne    803951 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  803b17:	b8 00 00 00 00       	mov    $0x0,%eax
  803b1c:	c9                   	leave  
  803b1d:	c3                   	ret    

00803b1e <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803b1e:	55                   	push   %ebp
  803b1f:	89 e5                	mov    %esp,%ebp
  803b21:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  803b24:	83 ec 04             	sub    $0x4,%esp
  803b27:	68 5c 4f 80 00       	push   $0x804f5c
  803b2c:	68 04 01 00 00       	push   $0x104
  803b31:	68 93 4e 80 00       	push   $0x804e93
  803b36:	e8 54 da ff ff       	call   80158f <_panic>

00803b3b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  803b3b:	55                   	push   %ebp
  803b3c:	89 e5                	mov    %esp,%ebp
  803b3e:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  803b41:	a1 38 51 80 00       	mov    0x805138,%eax
  803b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  803b49:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803b4e:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  803b51:	a1 38 51 80 00       	mov    0x805138,%eax
  803b56:	85 c0                	test   %eax,%eax
  803b58:	75 68                	jne    803bc2 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803b5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b5e:	75 17                	jne    803b77 <insert_sorted_with_merge_freeList+0x3c>
  803b60:	83 ec 04             	sub    $0x4,%esp
  803b63:	68 70 4e 80 00       	push   $0x804e70
  803b68:	68 14 01 00 00       	push   $0x114
  803b6d:	68 93 4e 80 00       	push   $0x804e93
  803b72:	e8 18 da ff ff       	call   80158f <_panic>
  803b77:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b80:	89 10                	mov    %edx,(%eax)
  803b82:	8b 45 08             	mov    0x8(%ebp),%eax
  803b85:	8b 00                	mov    (%eax),%eax
  803b87:	85 c0                	test   %eax,%eax
  803b89:	74 0d                	je     803b98 <insert_sorted_with_merge_freeList+0x5d>
  803b8b:	a1 38 51 80 00       	mov    0x805138,%eax
  803b90:	8b 55 08             	mov    0x8(%ebp),%edx
  803b93:	89 50 04             	mov    %edx,0x4(%eax)
  803b96:	eb 08                	jmp    803ba0 <insert_sorted_with_merge_freeList+0x65>
  803b98:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba3:	a3 38 51 80 00       	mov    %eax,0x805138
  803ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bb2:	a1 44 51 80 00       	mov    0x805144,%eax
  803bb7:	40                   	inc    %eax
  803bb8:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803bbd:	e9 d2 06 00 00       	jmp    804294 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  803bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc5:	8b 50 08             	mov    0x8(%eax),%edx
  803bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bcb:	8b 40 08             	mov    0x8(%eax),%eax
  803bce:	39 c2                	cmp    %eax,%edx
  803bd0:	0f 83 22 01 00 00    	jae    803cf8 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  803bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd9:	8b 50 08             	mov    0x8(%eax),%edx
  803bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  803bdf:	8b 40 0c             	mov    0xc(%eax),%eax
  803be2:	01 c2                	add    %eax,%edx
  803be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803be7:	8b 40 08             	mov    0x8(%eax),%eax
  803bea:	39 c2                	cmp    %eax,%edx
  803bec:	0f 85 9e 00 00 00    	jne    803c90 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  803bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf5:	8b 50 08             	mov    0x8(%eax),%edx
  803bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bfb:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c01:	8b 50 0c             	mov    0xc(%eax),%edx
  803c04:	8b 45 08             	mov    0x8(%ebp),%eax
  803c07:	8b 40 0c             	mov    0xc(%eax),%eax
  803c0a:	01 c2                	add    %eax,%edx
  803c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c0f:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  803c12:	8b 45 08             	mov    0x8(%ebp),%eax
  803c15:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1f:	8b 50 08             	mov    0x8(%eax),%edx
  803c22:	8b 45 08             	mov    0x8(%ebp),%eax
  803c25:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c2c:	75 17                	jne    803c45 <insert_sorted_with_merge_freeList+0x10a>
  803c2e:	83 ec 04             	sub    $0x4,%esp
  803c31:	68 70 4e 80 00       	push   $0x804e70
  803c36:	68 21 01 00 00       	push   $0x121
  803c3b:	68 93 4e 80 00       	push   $0x804e93
  803c40:	e8 4a d9 ff ff       	call   80158f <_panic>
  803c45:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4e:	89 10                	mov    %edx,(%eax)
  803c50:	8b 45 08             	mov    0x8(%ebp),%eax
  803c53:	8b 00                	mov    (%eax),%eax
  803c55:	85 c0                	test   %eax,%eax
  803c57:	74 0d                	je     803c66 <insert_sorted_with_merge_freeList+0x12b>
  803c59:	a1 48 51 80 00       	mov    0x805148,%eax
  803c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  803c61:	89 50 04             	mov    %edx,0x4(%eax)
  803c64:	eb 08                	jmp    803c6e <insert_sorted_with_merge_freeList+0x133>
  803c66:	8b 45 08             	mov    0x8(%ebp),%eax
  803c69:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c71:	a3 48 51 80 00       	mov    %eax,0x805148
  803c76:	8b 45 08             	mov    0x8(%ebp),%eax
  803c79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c80:	a1 54 51 80 00       	mov    0x805154,%eax
  803c85:	40                   	inc    %eax
  803c86:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803c8b:	e9 04 06 00 00       	jmp    804294 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803c90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c94:	75 17                	jne    803cad <insert_sorted_with_merge_freeList+0x172>
  803c96:	83 ec 04             	sub    $0x4,%esp
  803c99:	68 70 4e 80 00       	push   $0x804e70
  803c9e:	68 26 01 00 00       	push   $0x126
  803ca3:	68 93 4e 80 00       	push   $0x804e93
  803ca8:	e8 e2 d8 ff ff       	call   80158f <_panic>
  803cad:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb6:	89 10                	mov    %edx,(%eax)
  803cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cbb:	8b 00                	mov    (%eax),%eax
  803cbd:	85 c0                	test   %eax,%eax
  803cbf:	74 0d                	je     803cce <insert_sorted_with_merge_freeList+0x193>
  803cc1:	a1 38 51 80 00       	mov    0x805138,%eax
  803cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  803cc9:	89 50 04             	mov    %edx,0x4(%eax)
  803ccc:	eb 08                	jmp    803cd6 <insert_sorted_with_merge_freeList+0x19b>
  803cce:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd9:	a3 38 51 80 00       	mov    %eax,0x805138
  803cde:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ce8:	a1 44 51 80 00       	mov    0x805144,%eax
  803ced:	40                   	inc    %eax
  803cee:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803cf3:	e9 9c 05 00 00       	jmp    804294 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  803cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfb:	8b 50 08             	mov    0x8(%eax),%edx
  803cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d01:	8b 40 08             	mov    0x8(%eax),%eax
  803d04:	39 c2                	cmp    %eax,%edx
  803d06:	0f 86 16 01 00 00    	jbe    803e22 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d0f:	8b 50 08             	mov    0x8(%eax),%edx
  803d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d15:	8b 40 0c             	mov    0xc(%eax),%eax
  803d18:	01 c2                	add    %eax,%edx
  803d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1d:	8b 40 08             	mov    0x8(%eax),%eax
  803d20:	39 c2                	cmp    %eax,%edx
  803d22:	0f 85 92 00 00 00    	jne    803dba <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  803d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d2b:	8b 50 0c             	mov    0xc(%eax),%edx
  803d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d31:	8b 40 0c             	mov    0xc(%eax),%eax
  803d34:	01 c2                	add    %eax,%edx
  803d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d39:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  803d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d3f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803d46:	8b 45 08             	mov    0x8(%ebp),%eax
  803d49:	8b 50 08             	mov    0x8(%eax),%edx
  803d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803d52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d56:	75 17                	jne    803d6f <insert_sorted_with_merge_freeList+0x234>
  803d58:	83 ec 04             	sub    $0x4,%esp
  803d5b:	68 70 4e 80 00       	push   $0x804e70
  803d60:	68 31 01 00 00       	push   $0x131
  803d65:	68 93 4e 80 00       	push   $0x804e93
  803d6a:	e8 20 d8 ff ff       	call   80158f <_panic>
  803d6f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d75:	8b 45 08             	mov    0x8(%ebp),%eax
  803d78:	89 10                	mov    %edx,(%eax)
  803d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7d:	8b 00                	mov    (%eax),%eax
  803d7f:	85 c0                	test   %eax,%eax
  803d81:	74 0d                	je     803d90 <insert_sorted_with_merge_freeList+0x255>
  803d83:	a1 48 51 80 00       	mov    0x805148,%eax
  803d88:	8b 55 08             	mov    0x8(%ebp),%edx
  803d8b:	89 50 04             	mov    %edx,0x4(%eax)
  803d8e:	eb 08                	jmp    803d98 <insert_sorted_with_merge_freeList+0x25d>
  803d90:	8b 45 08             	mov    0x8(%ebp),%eax
  803d93:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d98:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9b:	a3 48 51 80 00       	mov    %eax,0x805148
  803da0:	8b 45 08             	mov    0x8(%ebp),%eax
  803da3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803daa:	a1 54 51 80 00       	mov    0x805154,%eax
  803daf:	40                   	inc    %eax
  803db0:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803db5:	e9 da 04 00 00       	jmp    804294 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  803dba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803dbe:	75 17                	jne    803dd7 <insert_sorted_with_merge_freeList+0x29c>
  803dc0:	83 ec 04             	sub    $0x4,%esp
  803dc3:	68 18 4f 80 00       	push   $0x804f18
  803dc8:	68 37 01 00 00       	push   $0x137
  803dcd:	68 93 4e 80 00       	push   $0x804e93
  803dd2:	e8 b8 d7 ff ff       	call   80158f <_panic>
  803dd7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  803de0:	89 50 04             	mov    %edx,0x4(%eax)
  803de3:	8b 45 08             	mov    0x8(%ebp),%eax
  803de6:	8b 40 04             	mov    0x4(%eax),%eax
  803de9:	85 c0                	test   %eax,%eax
  803deb:	74 0c                	je     803df9 <insert_sorted_with_merge_freeList+0x2be>
  803ded:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803df2:	8b 55 08             	mov    0x8(%ebp),%edx
  803df5:	89 10                	mov    %edx,(%eax)
  803df7:	eb 08                	jmp    803e01 <insert_sorted_with_merge_freeList+0x2c6>
  803df9:	8b 45 08             	mov    0x8(%ebp),%eax
  803dfc:	a3 38 51 80 00       	mov    %eax,0x805138
  803e01:	8b 45 08             	mov    0x8(%ebp),%eax
  803e04:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803e09:	8b 45 08             	mov    0x8(%ebp),%eax
  803e0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e12:	a1 44 51 80 00       	mov    0x805144,%eax
  803e17:	40                   	inc    %eax
  803e18:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803e1d:	e9 72 04 00 00       	jmp    804294 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803e22:	a1 38 51 80 00       	mov    0x805138,%eax
  803e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e2a:	e9 35 04 00 00       	jmp    804264 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e32:	8b 00                	mov    (%eax),%eax
  803e34:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  803e37:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3a:	8b 50 08             	mov    0x8(%eax),%edx
  803e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e40:	8b 40 08             	mov    0x8(%eax),%eax
  803e43:	39 c2                	cmp    %eax,%edx
  803e45:	0f 86 11 04 00 00    	jbe    80425c <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e4e:	8b 50 08             	mov    0x8(%eax),%edx
  803e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e54:	8b 40 0c             	mov    0xc(%eax),%eax
  803e57:	01 c2                	add    %eax,%edx
  803e59:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5c:	8b 40 08             	mov    0x8(%eax),%eax
  803e5f:	39 c2                	cmp    %eax,%edx
  803e61:	0f 83 8b 00 00 00    	jae    803ef2 <insert_sorted_with_merge_freeList+0x3b7>
  803e67:	8b 45 08             	mov    0x8(%ebp),%eax
  803e6a:	8b 50 08             	mov    0x8(%eax),%edx
  803e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e70:	8b 40 0c             	mov    0xc(%eax),%eax
  803e73:	01 c2                	add    %eax,%edx
  803e75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e78:	8b 40 08             	mov    0x8(%eax),%eax
  803e7b:	39 c2                	cmp    %eax,%edx
  803e7d:	73 73                	jae    803ef2 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803e7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e83:	74 06                	je     803e8b <insert_sorted_with_merge_freeList+0x350>
  803e85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e89:	75 17                	jne    803ea2 <insert_sorted_with_merge_freeList+0x367>
  803e8b:	83 ec 04             	sub    $0x4,%esp
  803e8e:	68 e4 4e 80 00       	push   $0x804ee4
  803e93:	68 48 01 00 00       	push   $0x148
  803e98:	68 93 4e 80 00       	push   $0x804e93
  803e9d:	e8 ed d6 ff ff       	call   80158f <_panic>
  803ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea5:	8b 10                	mov    (%eax),%edx
  803ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  803eaa:	89 10                	mov    %edx,(%eax)
  803eac:	8b 45 08             	mov    0x8(%ebp),%eax
  803eaf:	8b 00                	mov    (%eax),%eax
  803eb1:	85 c0                	test   %eax,%eax
  803eb3:	74 0b                	je     803ec0 <insert_sorted_with_merge_freeList+0x385>
  803eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb8:	8b 00                	mov    (%eax),%eax
  803eba:	8b 55 08             	mov    0x8(%ebp),%edx
  803ebd:	89 50 04             	mov    %edx,0x4(%eax)
  803ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  803ec6:	89 10                	mov    %edx,(%eax)
  803ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  803ecb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ece:	89 50 04             	mov    %edx,0x4(%eax)
  803ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed4:	8b 00                	mov    (%eax),%eax
  803ed6:	85 c0                	test   %eax,%eax
  803ed8:	75 08                	jne    803ee2 <insert_sorted_with_merge_freeList+0x3a7>
  803eda:	8b 45 08             	mov    0x8(%ebp),%eax
  803edd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ee2:	a1 44 51 80 00       	mov    0x805144,%eax
  803ee7:	40                   	inc    %eax
  803ee8:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803eed:	e9 a2 03 00 00       	jmp    804294 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef5:	8b 50 08             	mov    0x8(%eax),%edx
  803ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  803efb:	8b 40 0c             	mov    0xc(%eax),%eax
  803efe:	01 c2                	add    %eax,%edx
  803f00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f03:	8b 40 08             	mov    0x8(%eax),%eax
  803f06:	39 c2                	cmp    %eax,%edx
  803f08:	0f 83 ae 00 00 00    	jae    803fbc <insert_sorted_with_merge_freeList+0x481>
  803f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803f11:	8b 50 08             	mov    0x8(%eax),%edx
  803f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f17:	8b 48 08             	mov    0x8(%eax),%ecx
  803f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f1d:	8b 40 0c             	mov    0xc(%eax),%eax
  803f20:	01 c8                	add    %ecx,%eax
  803f22:	39 c2                	cmp    %eax,%edx
  803f24:	0f 85 92 00 00 00    	jne    803fbc <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f2d:	8b 50 0c             	mov    0xc(%eax),%edx
  803f30:	8b 45 08             	mov    0x8(%ebp),%eax
  803f33:	8b 40 0c             	mov    0xc(%eax),%eax
  803f36:	01 c2                	add    %eax,%edx
  803f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f3b:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  803f41:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803f48:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4b:	8b 50 08             	mov    0x8(%eax),%edx
  803f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803f51:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803f54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f58:	75 17                	jne    803f71 <insert_sorted_with_merge_freeList+0x436>
  803f5a:	83 ec 04             	sub    $0x4,%esp
  803f5d:	68 70 4e 80 00       	push   $0x804e70
  803f62:	68 51 01 00 00       	push   $0x151
  803f67:	68 93 4e 80 00       	push   $0x804e93
  803f6c:	e8 1e d6 ff ff       	call   80158f <_panic>
  803f71:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803f77:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7a:	89 10                	mov    %edx,(%eax)
  803f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7f:	8b 00                	mov    (%eax),%eax
  803f81:	85 c0                	test   %eax,%eax
  803f83:	74 0d                	je     803f92 <insert_sorted_with_merge_freeList+0x457>
  803f85:	a1 48 51 80 00       	mov    0x805148,%eax
  803f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  803f8d:	89 50 04             	mov    %edx,0x4(%eax)
  803f90:	eb 08                	jmp    803f9a <insert_sorted_with_merge_freeList+0x45f>
  803f92:	8b 45 08             	mov    0x8(%ebp),%eax
  803f95:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f9d:	a3 48 51 80 00       	mov    %eax,0x805148
  803fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fac:	a1 54 51 80 00       	mov    0x805154,%eax
  803fb1:	40                   	inc    %eax
  803fb2:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  803fb7:	e9 d8 02 00 00       	jmp    804294 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  803fbf:	8b 50 08             	mov    0x8(%eax),%edx
  803fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  803fc8:	01 c2                	add    %eax,%edx
  803fca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fcd:	8b 40 08             	mov    0x8(%eax),%eax
  803fd0:	39 c2                	cmp    %eax,%edx
  803fd2:	0f 85 ba 00 00 00    	jne    804092 <insert_sorted_with_merge_freeList+0x557>
  803fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  803fdb:	8b 50 08             	mov    0x8(%eax),%edx
  803fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe1:	8b 48 08             	mov    0x8(%eax),%ecx
  803fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe7:	8b 40 0c             	mov    0xc(%eax),%eax
  803fea:	01 c8                	add    %ecx,%eax
  803fec:	39 c2                	cmp    %eax,%edx
  803fee:	0f 86 9e 00 00 00    	jbe    804092 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803ff4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ff7:	8b 50 0c             	mov    0xc(%eax),%edx
  803ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffd:	8b 40 0c             	mov    0xc(%eax),%eax
  804000:	01 c2                	add    %eax,%edx
  804002:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804005:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  804008:	8b 45 08             	mov    0x8(%ebp),%eax
  80400b:	8b 50 08             	mov    0x8(%eax),%edx
  80400e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804011:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  804014:	8b 45 08             	mov    0x8(%ebp),%eax
  804017:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80401e:	8b 45 08             	mov    0x8(%ebp),%eax
  804021:	8b 50 08             	mov    0x8(%eax),%edx
  804024:	8b 45 08             	mov    0x8(%ebp),%eax
  804027:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80402a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80402e:	75 17                	jne    804047 <insert_sorted_with_merge_freeList+0x50c>
  804030:	83 ec 04             	sub    $0x4,%esp
  804033:	68 70 4e 80 00       	push   $0x804e70
  804038:	68 5b 01 00 00       	push   $0x15b
  80403d:	68 93 4e 80 00       	push   $0x804e93
  804042:	e8 48 d5 ff ff       	call   80158f <_panic>
  804047:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80404d:	8b 45 08             	mov    0x8(%ebp),%eax
  804050:	89 10                	mov    %edx,(%eax)
  804052:	8b 45 08             	mov    0x8(%ebp),%eax
  804055:	8b 00                	mov    (%eax),%eax
  804057:	85 c0                	test   %eax,%eax
  804059:	74 0d                	je     804068 <insert_sorted_with_merge_freeList+0x52d>
  80405b:	a1 48 51 80 00       	mov    0x805148,%eax
  804060:	8b 55 08             	mov    0x8(%ebp),%edx
  804063:	89 50 04             	mov    %edx,0x4(%eax)
  804066:	eb 08                	jmp    804070 <insert_sorted_with_merge_freeList+0x535>
  804068:	8b 45 08             	mov    0x8(%ebp),%eax
  80406b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  804070:	8b 45 08             	mov    0x8(%ebp),%eax
  804073:	a3 48 51 80 00       	mov    %eax,0x805148
  804078:	8b 45 08             	mov    0x8(%ebp),%eax
  80407b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804082:	a1 54 51 80 00       	mov    0x805154,%eax
  804087:	40                   	inc    %eax
  804088:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  80408d:	e9 02 02 00 00       	jmp    804294 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  804092:	8b 45 08             	mov    0x8(%ebp),%eax
  804095:	8b 50 08             	mov    0x8(%eax),%edx
  804098:	8b 45 08             	mov    0x8(%ebp),%eax
  80409b:	8b 40 0c             	mov    0xc(%eax),%eax
  80409e:	01 c2                	add    %eax,%edx
  8040a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040a3:	8b 40 08             	mov    0x8(%eax),%eax
  8040a6:	39 c2                	cmp    %eax,%edx
  8040a8:	0f 85 ae 01 00 00    	jne    80425c <insert_sorted_with_merge_freeList+0x721>
  8040ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b1:	8b 50 08             	mov    0x8(%eax),%edx
  8040b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b7:	8b 48 08             	mov    0x8(%eax),%ecx
  8040ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8040c0:	01 c8                	add    %ecx,%eax
  8040c2:	39 c2                	cmp    %eax,%edx
  8040c4:	0f 85 92 01 00 00    	jne    80425c <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8040ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8040d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8040d6:	01 c2                	add    %eax,%edx
  8040d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040db:	8b 40 0c             	mov    0xc(%eax),%eax
  8040de:	01 c2                	add    %eax,%edx
  8040e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040e3:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  8040e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8040f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f3:	8b 50 08             	mov    0x8(%eax),%edx
  8040f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f9:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  8040fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  804106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804109:	8b 50 08             	mov    0x8(%eax),%edx
  80410c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80410f:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  804112:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804116:	75 17                	jne    80412f <insert_sorted_with_merge_freeList+0x5f4>
  804118:	83 ec 04             	sub    $0x4,%esp
  80411b:	68 3b 4f 80 00       	push   $0x804f3b
  804120:	68 63 01 00 00       	push   $0x163
  804125:	68 93 4e 80 00       	push   $0x804e93
  80412a:	e8 60 d4 ff ff       	call   80158f <_panic>
  80412f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804132:	8b 00                	mov    (%eax),%eax
  804134:	85 c0                	test   %eax,%eax
  804136:	74 10                	je     804148 <insert_sorted_with_merge_freeList+0x60d>
  804138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80413b:	8b 00                	mov    (%eax),%eax
  80413d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804140:	8b 52 04             	mov    0x4(%edx),%edx
  804143:	89 50 04             	mov    %edx,0x4(%eax)
  804146:	eb 0b                	jmp    804153 <insert_sorted_with_merge_freeList+0x618>
  804148:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80414b:	8b 40 04             	mov    0x4(%eax),%eax
  80414e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  804153:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804156:	8b 40 04             	mov    0x4(%eax),%eax
  804159:	85 c0                	test   %eax,%eax
  80415b:	74 0f                	je     80416c <insert_sorted_with_merge_freeList+0x631>
  80415d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804160:	8b 40 04             	mov    0x4(%eax),%eax
  804163:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804166:	8b 12                	mov    (%edx),%edx
  804168:	89 10                	mov    %edx,(%eax)
  80416a:	eb 0a                	jmp    804176 <insert_sorted_with_merge_freeList+0x63b>
  80416c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80416f:	8b 00                	mov    (%eax),%eax
  804171:	a3 38 51 80 00       	mov    %eax,0x805138
  804176:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804179:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80417f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804182:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804189:	a1 44 51 80 00       	mov    0x805144,%eax
  80418e:	48                   	dec    %eax
  80418f:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  804194:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804198:	75 17                	jne    8041b1 <insert_sorted_with_merge_freeList+0x676>
  80419a:	83 ec 04             	sub    $0x4,%esp
  80419d:	68 70 4e 80 00       	push   $0x804e70
  8041a2:	68 64 01 00 00       	push   $0x164
  8041a7:	68 93 4e 80 00       	push   $0x804e93
  8041ac:	e8 de d3 ff ff       	call   80158f <_panic>
  8041b1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8041b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041ba:	89 10                	mov    %edx,(%eax)
  8041bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041bf:	8b 00                	mov    (%eax),%eax
  8041c1:	85 c0                	test   %eax,%eax
  8041c3:	74 0d                	je     8041d2 <insert_sorted_with_merge_freeList+0x697>
  8041c5:	a1 48 51 80 00       	mov    0x805148,%eax
  8041ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041cd:	89 50 04             	mov    %edx,0x4(%eax)
  8041d0:	eb 08                	jmp    8041da <insert_sorted_with_merge_freeList+0x69f>
  8041d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041d5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8041da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041dd:	a3 48 51 80 00       	mov    %eax,0x805148
  8041e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041ec:	a1 54 51 80 00       	mov    0x805154,%eax
  8041f1:	40                   	inc    %eax
  8041f2:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8041f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041fb:	75 17                	jne    804214 <insert_sorted_with_merge_freeList+0x6d9>
  8041fd:	83 ec 04             	sub    $0x4,%esp
  804200:	68 70 4e 80 00       	push   $0x804e70
  804205:	68 65 01 00 00       	push   $0x165
  80420a:	68 93 4e 80 00       	push   $0x804e93
  80420f:	e8 7b d3 ff ff       	call   80158f <_panic>
  804214:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80421a:	8b 45 08             	mov    0x8(%ebp),%eax
  80421d:	89 10                	mov    %edx,(%eax)
  80421f:	8b 45 08             	mov    0x8(%ebp),%eax
  804222:	8b 00                	mov    (%eax),%eax
  804224:	85 c0                	test   %eax,%eax
  804226:	74 0d                	je     804235 <insert_sorted_with_merge_freeList+0x6fa>
  804228:	a1 48 51 80 00       	mov    0x805148,%eax
  80422d:	8b 55 08             	mov    0x8(%ebp),%edx
  804230:	89 50 04             	mov    %edx,0x4(%eax)
  804233:	eb 08                	jmp    80423d <insert_sorted_with_merge_freeList+0x702>
  804235:	8b 45 08             	mov    0x8(%ebp),%eax
  804238:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80423d:	8b 45 08             	mov    0x8(%ebp),%eax
  804240:	a3 48 51 80 00       	mov    %eax,0x805148
  804245:	8b 45 08             	mov    0x8(%ebp),%eax
  804248:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80424f:	a1 54 51 80 00       	mov    0x805154,%eax
  804254:	40                   	inc    %eax
  804255:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  80425a:	eb 38                	jmp    804294 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80425c:	a1 40 51 80 00       	mov    0x805140,%eax
  804261:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804268:	74 07                	je     804271 <insert_sorted_with_merge_freeList+0x736>
  80426a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80426d:	8b 00                	mov    (%eax),%eax
  80426f:	eb 05                	jmp    804276 <insert_sorted_with_merge_freeList+0x73b>
  804271:	b8 00 00 00 00       	mov    $0x0,%eax
  804276:	a3 40 51 80 00       	mov    %eax,0x805140
  80427b:	a1 40 51 80 00       	mov    0x805140,%eax
  804280:	85 c0                	test   %eax,%eax
  804282:	0f 85 a7 fb ff ff    	jne    803e2f <insert_sorted_with_merge_freeList+0x2f4>
  804288:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80428c:	0f 85 9d fb ff ff    	jne    803e2f <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  804292:	eb 00                	jmp    804294 <insert_sorted_with_merge_freeList+0x759>
  804294:	90                   	nop
  804295:	c9                   	leave  
  804296:	c3                   	ret    
  804297:	90                   	nop

00804298 <__udivdi3>:
  804298:	55                   	push   %ebp
  804299:	57                   	push   %edi
  80429a:	56                   	push   %esi
  80429b:	53                   	push   %ebx
  80429c:	83 ec 1c             	sub    $0x1c,%esp
  80429f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8042a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8042a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8042af:	89 ca                	mov    %ecx,%edx
  8042b1:	89 f8                	mov    %edi,%eax
  8042b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8042b7:	85 f6                	test   %esi,%esi
  8042b9:	75 2d                	jne    8042e8 <__udivdi3+0x50>
  8042bb:	39 cf                	cmp    %ecx,%edi
  8042bd:	77 65                	ja     804324 <__udivdi3+0x8c>
  8042bf:	89 fd                	mov    %edi,%ebp
  8042c1:	85 ff                	test   %edi,%edi
  8042c3:	75 0b                	jne    8042d0 <__udivdi3+0x38>
  8042c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8042ca:	31 d2                	xor    %edx,%edx
  8042cc:	f7 f7                	div    %edi
  8042ce:	89 c5                	mov    %eax,%ebp
  8042d0:	31 d2                	xor    %edx,%edx
  8042d2:	89 c8                	mov    %ecx,%eax
  8042d4:	f7 f5                	div    %ebp
  8042d6:	89 c1                	mov    %eax,%ecx
  8042d8:	89 d8                	mov    %ebx,%eax
  8042da:	f7 f5                	div    %ebp
  8042dc:	89 cf                	mov    %ecx,%edi
  8042de:	89 fa                	mov    %edi,%edx
  8042e0:	83 c4 1c             	add    $0x1c,%esp
  8042e3:	5b                   	pop    %ebx
  8042e4:	5e                   	pop    %esi
  8042e5:	5f                   	pop    %edi
  8042e6:	5d                   	pop    %ebp
  8042e7:	c3                   	ret    
  8042e8:	39 ce                	cmp    %ecx,%esi
  8042ea:	77 28                	ja     804314 <__udivdi3+0x7c>
  8042ec:	0f bd fe             	bsr    %esi,%edi
  8042ef:	83 f7 1f             	xor    $0x1f,%edi
  8042f2:	75 40                	jne    804334 <__udivdi3+0x9c>
  8042f4:	39 ce                	cmp    %ecx,%esi
  8042f6:	72 0a                	jb     804302 <__udivdi3+0x6a>
  8042f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8042fc:	0f 87 9e 00 00 00    	ja     8043a0 <__udivdi3+0x108>
  804302:	b8 01 00 00 00       	mov    $0x1,%eax
  804307:	89 fa                	mov    %edi,%edx
  804309:	83 c4 1c             	add    $0x1c,%esp
  80430c:	5b                   	pop    %ebx
  80430d:	5e                   	pop    %esi
  80430e:	5f                   	pop    %edi
  80430f:	5d                   	pop    %ebp
  804310:	c3                   	ret    
  804311:	8d 76 00             	lea    0x0(%esi),%esi
  804314:	31 ff                	xor    %edi,%edi
  804316:	31 c0                	xor    %eax,%eax
  804318:	89 fa                	mov    %edi,%edx
  80431a:	83 c4 1c             	add    $0x1c,%esp
  80431d:	5b                   	pop    %ebx
  80431e:	5e                   	pop    %esi
  80431f:	5f                   	pop    %edi
  804320:	5d                   	pop    %ebp
  804321:	c3                   	ret    
  804322:	66 90                	xchg   %ax,%ax
  804324:	89 d8                	mov    %ebx,%eax
  804326:	f7 f7                	div    %edi
  804328:	31 ff                	xor    %edi,%edi
  80432a:	89 fa                	mov    %edi,%edx
  80432c:	83 c4 1c             	add    $0x1c,%esp
  80432f:	5b                   	pop    %ebx
  804330:	5e                   	pop    %esi
  804331:	5f                   	pop    %edi
  804332:	5d                   	pop    %ebp
  804333:	c3                   	ret    
  804334:	bd 20 00 00 00       	mov    $0x20,%ebp
  804339:	89 eb                	mov    %ebp,%ebx
  80433b:	29 fb                	sub    %edi,%ebx
  80433d:	89 f9                	mov    %edi,%ecx
  80433f:	d3 e6                	shl    %cl,%esi
  804341:	89 c5                	mov    %eax,%ebp
  804343:	88 d9                	mov    %bl,%cl
  804345:	d3 ed                	shr    %cl,%ebp
  804347:	89 e9                	mov    %ebp,%ecx
  804349:	09 f1                	or     %esi,%ecx
  80434b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80434f:	89 f9                	mov    %edi,%ecx
  804351:	d3 e0                	shl    %cl,%eax
  804353:	89 c5                	mov    %eax,%ebp
  804355:	89 d6                	mov    %edx,%esi
  804357:	88 d9                	mov    %bl,%cl
  804359:	d3 ee                	shr    %cl,%esi
  80435b:	89 f9                	mov    %edi,%ecx
  80435d:	d3 e2                	shl    %cl,%edx
  80435f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804363:	88 d9                	mov    %bl,%cl
  804365:	d3 e8                	shr    %cl,%eax
  804367:	09 c2                	or     %eax,%edx
  804369:	89 d0                	mov    %edx,%eax
  80436b:	89 f2                	mov    %esi,%edx
  80436d:	f7 74 24 0c          	divl   0xc(%esp)
  804371:	89 d6                	mov    %edx,%esi
  804373:	89 c3                	mov    %eax,%ebx
  804375:	f7 e5                	mul    %ebp
  804377:	39 d6                	cmp    %edx,%esi
  804379:	72 19                	jb     804394 <__udivdi3+0xfc>
  80437b:	74 0b                	je     804388 <__udivdi3+0xf0>
  80437d:	89 d8                	mov    %ebx,%eax
  80437f:	31 ff                	xor    %edi,%edi
  804381:	e9 58 ff ff ff       	jmp    8042de <__udivdi3+0x46>
  804386:	66 90                	xchg   %ax,%ax
  804388:	8b 54 24 08          	mov    0x8(%esp),%edx
  80438c:	89 f9                	mov    %edi,%ecx
  80438e:	d3 e2                	shl    %cl,%edx
  804390:	39 c2                	cmp    %eax,%edx
  804392:	73 e9                	jae    80437d <__udivdi3+0xe5>
  804394:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804397:	31 ff                	xor    %edi,%edi
  804399:	e9 40 ff ff ff       	jmp    8042de <__udivdi3+0x46>
  80439e:	66 90                	xchg   %ax,%ax
  8043a0:	31 c0                	xor    %eax,%eax
  8043a2:	e9 37 ff ff ff       	jmp    8042de <__udivdi3+0x46>
  8043a7:	90                   	nop

008043a8 <__umoddi3>:
  8043a8:	55                   	push   %ebp
  8043a9:	57                   	push   %edi
  8043aa:	56                   	push   %esi
  8043ab:	53                   	push   %ebx
  8043ac:	83 ec 1c             	sub    $0x1c,%esp
  8043af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8043b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8043b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8043bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8043c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8043c7:	89 f3                	mov    %esi,%ebx
  8043c9:	89 fa                	mov    %edi,%edx
  8043cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043cf:	89 34 24             	mov    %esi,(%esp)
  8043d2:	85 c0                	test   %eax,%eax
  8043d4:	75 1a                	jne    8043f0 <__umoddi3+0x48>
  8043d6:	39 f7                	cmp    %esi,%edi
  8043d8:	0f 86 a2 00 00 00    	jbe    804480 <__umoddi3+0xd8>
  8043de:	89 c8                	mov    %ecx,%eax
  8043e0:	89 f2                	mov    %esi,%edx
  8043e2:	f7 f7                	div    %edi
  8043e4:	89 d0                	mov    %edx,%eax
  8043e6:	31 d2                	xor    %edx,%edx
  8043e8:	83 c4 1c             	add    $0x1c,%esp
  8043eb:	5b                   	pop    %ebx
  8043ec:	5e                   	pop    %esi
  8043ed:	5f                   	pop    %edi
  8043ee:	5d                   	pop    %ebp
  8043ef:	c3                   	ret    
  8043f0:	39 f0                	cmp    %esi,%eax
  8043f2:	0f 87 ac 00 00 00    	ja     8044a4 <__umoddi3+0xfc>
  8043f8:	0f bd e8             	bsr    %eax,%ebp
  8043fb:	83 f5 1f             	xor    $0x1f,%ebp
  8043fe:	0f 84 ac 00 00 00    	je     8044b0 <__umoddi3+0x108>
  804404:	bf 20 00 00 00       	mov    $0x20,%edi
  804409:	29 ef                	sub    %ebp,%edi
  80440b:	89 fe                	mov    %edi,%esi
  80440d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804411:	89 e9                	mov    %ebp,%ecx
  804413:	d3 e0                	shl    %cl,%eax
  804415:	89 d7                	mov    %edx,%edi
  804417:	89 f1                	mov    %esi,%ecx
  804419:	d3 ef                	shr    %cl,%edi
  80441b:	09 c7                	or     %eax,%edi
  80441d:	89 e9                	mov    %ebp,%ecx
  80441f:	d3 e2                	shl    %cl,%edx
  804421:	89 14 24             	mov    %edx,(%esp)
  804424:	89 d8                	mov    %ebx,%eax
  804426:	d3 e0                	shl    %cl,%eax
  804428:	89 c2                	mov    %eax,%edx
  80442a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80442e:	d3 e0                	shl    %cl,%eax
  804430:	89 44 24 04          	mov    %eax,0x4(%esp)
  804434:	8b 44 24 08          	mov    0x8(%esp),%eax
  804438:	89 f1                	mov    %esi,%ecx
  80443a:	d3 e8                	shr    %cl,%eax
  80443c:	09 d0                	or     %edx,%eax
  80443e:	d3 eb                	shr    %cl,%ebx
  804440:	89 da                	mov    %ebx,%edx
  804442:	f7 f7                	div    %edi
  804444:	89 d3                	mov    %edx,%ebx
  804446:	f7 24 24             	mull   (%esp)
  804449:	89 c6                	mov    %eax,%esi
  80444b:	89 d1                	mov    %edx,%ecx
  80444d:	39 d3                	cmp    %edx,%ebx
  80444f:	0f 82 87 00 00 00    	jb     8044dc <__umoddi3+0x134>
  804455:	0f 84 91 00 00 00    	je     8044ec <__umoddi3+0x144>
  80445b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80445f:	29 f2                	sub    %esi,%edx
  804461:	19 cb                	sbb    %ecx,%ebx
  804463:	89 d8                	mov    %ebx,%eax
  804465:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804469:	d3 e0                	shl    %cl,%eax
  80446b:	89 e9                	mov    %ebp,%ecx
  80446d:	d3 ea                	shr    %cl,%edx
  80446f:	09 d0                	or     %edx,%eax
  804471:	89 e9                	mov    %ebp,%ecx
  804473:	d3 eb                	shr    %cl,%ebx
  804475:	89 da                	mov    %ebx,%edx
  804477:	83 c4 1c             	add    $0x1c,%esp
  80447a:	5b                   	pop    %ebx
  80447b:	5e                   	pop    %esi
  80447c:	5f                   	pop    %edi
  80447d:	5d                   	pop    %ebp
  80447e:	c3                   	ret    
  80447f:	90                   	nop
  804480:	89 fd                	mov    %edi,%ebp
  804482:	85 ff                	test   %edi,%edi
  804484:	75 0b                	jne    804491 <__umoddi3+0xe9>
  804486:	b8 01 00 00 00       	mov    $0x1,%eax
  80448b:	31 d2                	xor    %edx,%edx
  80448d:	f7 f7                	div    %edi
  80448f:	89 c5                	mov    %eax,%ebp
  804491:	89 f0                	mov    %esi,%eax
  804493:	31 d2                	xor    %edx,%edx
  804495:	f7 f5                	div    %ebp
  804497:	89 c8                	mov    %ecx,%eax
  804499:	f7 f5                	div    %ebp
  80449b:	89 d0                	mov    %edx,%eax
  80449d:	e9 44 ff ff ff       	jmp    8043e6 <__umoddi3+0x3e>
  8044a2:	66 90                	xchg   %ax,%ax
  8044a4:	89 c8                	mov    %ecx,%eax
  8044a6:	89 f2                	mov    %esi,%edx
  8044a8:	83 c4 1c             	add    $0x1c,%esp
  8044ab:	5b                   	pop    %ebx
  8044ac:	5e                   	pop    %esi
  8044ad:	5f                   	pop    %edi
  8044ae:	5d                   	pop    %ebp
  8044af:	c3                   	ret    
  8044b0:	3b 04 24             	cmp    (%esp),%eax
  8044b3:	72 06                	jb     8044bb <__umoddi3+0x113>
  8044b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8044b9:	77 0f                	ja     8044ca <__umoddi3+0x122>
  8044bb:	89 f2                	mov    %esi,%edx
  8044bd:	29 f9                	sub    %edi,%ecx
  8044bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8044c3:	89 14 24             	mov    %edx,(%esp)
  8044c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8044ce:	8b 14 24             	mov    (%esp),%edx
  8044d1:	83 c4 1c             	add    $0x1c,%esp
  8044d4:	5b                   	pop    %ebx
  8044d5:	5e                   	pop    %esi
  8044d6:	5f                   	pop    %edi
  8044d7:	5d                   	pop    %ebp
  8044d8:	c3                   	ret    
  8044d9:	8d 76 00             	lea    0x0(%esi),%esi
  8044dc:	2b 04 24             	sub    (%esp),%eax
  8044df:	19 fa                	sbb    %edi,%edx
  8044e1:	89 d1                	mov    %edx,%ecx
  8044e3:	89 c6                	mov    %eax,%esi
  8044e5:	e9 71 ff ff ff       	jmp    80445b <__umoddi3+0xb3>
  8044ea:	66 90                	xchg   %ax,%ax
  8044ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8044f0:	72 ea                	jb     8044dc <__umoddi3+0x134>
  8044f2:	89 d9                	mov    %ebx,%ecx
  8044f4:	e9 62 ff ff ff       	jmp    80445b <__umoddi3+0xb3>
