
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 0c 02 00 00       	call   800242 <libmain>
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
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 f3 14 00 00       	call   80155e <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 e2 14 00 00       	call   80155e <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 a5 19 00 00       	call   801a2c <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 c0 00 00 20 00 	movl   $0x200000,-0x40(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8000ec:	e8 e8 14 00 00       	call   8015d9 <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 da 14 00 00       	call   8015d9 <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 85 18 00 00       	call   80198c <sys_calculate_free_frames>
  800107:	89 45 bc             	mov    %eax,-0x44(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 d0             	pushl  -0x30(%ebp)
  800110:	e8 49 14 00 00       	call   80155e <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 cc             	mov    %eax,-0x34(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800152:	bb fc 33 80 00       	mov    $0x8033fc,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < 7; i++)
  80016b:	eb 7e                	jmp    8001eb <_main+0x1b3>
		{
			int found = 0 ;
  80016d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800174:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80017b:	eb 3d                	jmp    8001ba <_main+0x182>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  80017d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800180:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  80018f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	01 d0                	add    %edx,%eax
  800198:	c1 e0 03             	shl    $0x3,%eax
  80019b:	01 d8                	add    %ebx,%eax
  80019d:	8b 00                	mov    (%eax),%eax
  80019f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001aa:	39 c1                	cmp    %eax,%ecx
  8001ac:	75 09                	jne    8001b7 <_main+0x17f>
				{
					found = 1 ;
  8001ae:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001b5:	eb 12                	jmp    8001c9 <_main+0x191>

		int i = 0, j ;
		for (; i < 7; i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001b7:	ff 45 e0             	incl   -0x20(%ebp)
  8001ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8001bf:	8b 50 74             	mov    0x74(%eax),%edx
  8001c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c5:	39 c2                	cmp    %eax,%edx
  8001c7:	77 b4                	ja     80017d <_main+0x145>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001cd:	75 19                	jne    8001e8 <_main+0x1b0>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d2:	8b 44 85 9c          	mov    -0x64(%ebp,%eax,4),%eax
  8001d6:	50                   	push   %eax
  8001d7:	68 00 33 80 00       	push   $0x803300
  8001dc:	6a 4c                	push   $0x4c
  8001de:	68 61 33 80 00       	push   $0x803361
  8001e3:	e8 96 01 00 00       	call   80037e <_panic>
//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;
		for (; i < 7; i++)
  8001e8:	ff 45 e4             	incl   -0x1c(%ebp)
  8001eb:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001ef:	0f 8e 78 ff ff ff    	jle    80016d <_main+0x135>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  8001f5:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8001f8:	e8 8f 17 00 00       	call   80198c <sys_calculate_free_frames>
  8001fd:	29 c3                	sub    %eax,%ebx
  8001ff:	89 d8                	mov    %ebx,%eax
  800201:	83 f8 06             	cmp    $0x6,%eax
  800204:	74 23                	je     800229 <_main+0x1f1>
  800206:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800209:	e8 7e 17 00 00       	call   80198c <sys_calculate_free_frames>
  80020e:	29 c3                	sub    %eax,%ebx
  800210:	89 d8                	mov    %ebx,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 08                	push   $0x8
  800217:	50                   	push   %eax
  800218:	68 78 33 80 00       	push   $0x803378
  80021d:	6a 4f                	push   $0x4f
  80021f:	68 61 33 80 00       	push   $0x803361
  800224:	e8 55 01 00 00       	call   80037e <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	68 bc 33 80 00       	push   $0x8033bc
  800231:	e8 fc 03 00 00       	call   800632 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp


	return;
  800239:	90                   	nop
}
  80023a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023d:	5b                   	pop    %ebx
  80023e:	5e                   	pop    %esi
  80023f:	5f                   	pop    %edi
  800240:	5d                   	pop    %ebp
  800241:	c3                   	ret    

00800242 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800248:	e8 1f 1a 00 00       	call   801c6c <sys_getenvindex>
  80024d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800250:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800253:	89 d0                	mov    %edx,%eax
  800255:	c1 e0 03             	shl    $0x3,%eax
  800258:	01 d0                	add    %edx,%eax
  80025a:	01 c0                	add    %eax,%eax
  80025c:	01 d0                	add    %edx,%eax
  80025e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800265:	01 d0                	add    %edx,%eax
  800267:	c1 e0 04             	shl    $0x4,%eax
  80026a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80026f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80027f:	84 c0                	test   %al,%al
  800281:	74 0f                	je     800292 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800283:	a1 20 40 80 00       	mov    0x804020,%eax
  800288:	05 5c 05 00 00       	add    $0x55c,%eax
  80028d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800296:	7e 0a                	jle    8002a2 <libmain+0x60>
		binaryname = argv[0];
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029b:	8b 00                	mov    (%eax),%eax
  80029d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	ff 75 0c             	pushl  0xc(%ebp)
  8002a8:	ff 75 08             	pushl  0x8(%ebp)
  8002ab:	e8 88 fd ff ff       	call   800038 <_main>
  8002b0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002b3:	e8 c1 17 00 00       	call   801a79 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 30 34 80 00       	push   $0x803430
  8002c0:	e8 6d 03 00 00       	call   800632 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002cd:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	52                   	push   %edx
  8002e2:	50                   	push   %eax
  8002e3:	68 58 34 80 00       	push   $0x803458
  8002e8:	e8 45 03 00 00       	call   800632 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800300:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800306:	a1 20 40 80 00       	mov    0x804020,%eax
  80030b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800311:	51                   	push   %ecx
  800312:	52                   	push   %edx
  800313:	50                   	push   %eax
  800314:	68 80 34 80 00       	push   $0x803480
  800319:	e8 14 03 00 00       	call   800632 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 20 40 80 00       	mov    0x804020,%eax
  800326:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 d8 34 80 00       	push   $0x8034d8
  800335:	e8 f8 02 00 00       	call   800632 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 30 34 80 00       	push   $0x803430
  800345:	e8 e8 02 00 00       	call   800632 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80034d:	e8 41 17 00 00       	call   801a93 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800352:	e8 19 00 00 00       	call   800370 <exit>
}
  800357:	90                   	nop
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	6a 00                	push   $0x0
  800365:	e8 ce 18 00 00       	call   801c38 <sys_destroy_env>
  80036a:	83 c4 10             	add    $0x10,%esp
}
  80036d:	90                   	nop
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <exit>:

void
exit(void)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800376:	e8 23 19 00 00       	call   801c9e <sys_exit_env>
}
  80037b:	90                   	nop
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800384:	8d 45 10             	lea    0x10(%ebp),%eax
  800387:	83 c0 04             	add    $0x4,%eax
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80038d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800392:	85 c0                	test   %eax,%eax
  800394:	74 16                	je     8003ac <_panic+0x2e>
		cprintf("%s: ", argv0);
  800396:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	50                   	push   %eax
  80039f:	68 ec 34 80 00       	push   $0x8034ec
  8003a4:	e8 89 02 00 00       	call   800632 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ac:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	50                   	push   %eax
  8003b8:	68 f1 34 80 00       	push   $0x8034f1
  8003bd:	e8 70 02 00 00       	call   800632 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	50                   	push   %eax
  8003cf:	e8 f3 01 00 00       	call   8005c7 <vcprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	6a 00                	push   $0x0
  8003dc:	68 0d 35 80 00       	push   $0x80350d
  8003e1:	e8 e1 01 00 00       	call   8005c7 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003e9:	e8 82 ff ff ff       	call   800370 <exit>

	// should not return here
	while (1) ;
  8003ee:	eb fe                	jmp    8003ee <_panic+0x70>

008003f0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fb:	8b 50 74             	mov    0x74(%eax),%edx
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800401:	39 c2                	cmp    %eax,%edx
  800403:	74 14                	je     800419 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800405:	83 ec 04             	sub    $0x4,%esp
  800408:	68 10 35 80 00       	push   $0x803510
  80040d:	6a 26                	push   $0x26
  80040f:	68 5c 35 80 00       	push   $0x80355c
  800414:	e8 65 ff ff ff       	call   80037e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800419:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800420:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800427:	e9 c2 00 00 00       	jmp    8004ee <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	85 c0                	test   %eax,%eax
  80043f:	75 08                	jne    800449 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800441:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800444:	e9 a2 00 00 00       	jmp    8004eb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800449:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800457:	eb 69                	jmp    8004c2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800464:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800467:	89 d0                	mov    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	c1 e0 03             	shl    $0x3,%eax
  800470:	01 c8                	add    %ecx,%eax
  800472:	8a 40 04             	mov    0x4(%eax),%al
  800475:	84 c0                	test   %al,%al
  800477:	75 46                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800484:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800487:	89 d0                	mov    %edx,%eax
  800489:	01 c0                	add    %eax,%eax
  80048b:	01 d0                	add    %edx,%eax
  80048d:	c1 e0 03             	shl    $0x3,%eax
  800490:	01 c8                	add    %ecx,%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800497:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80049a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80049f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	01 c8                	add    %ecx,%eax
  8004b0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004b2:	39 c2                	cmp    %eax,%edx
  8004b4:	75 09                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004b6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004bd:	eb 12                	jmp    8004d1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004bf:	ff 45 e8             	incl   -0x18(%ebp)
  8004c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c7:	8b 50 74             	mov    0x74(%eax),%edx
  8004ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004cd:	39 c2                	cmp    %eax,%edx
  8004cf:	77 88                	ja     800459 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004d5:	75 14                	jne    8004eb <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 68 35 80 00       	push   $0x803568
  8004df:	6a 3a                	push   $0x3a
  8004e1:	68 5c 35 80 00       	push   $0x80355c
  8004e6:	e8 93 fe ff ff       	call   80037e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004eb:	ff 45 f0             	incl   -0x10(%ebp)
  8004ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	0f 8c 32 ff ff ff    	jl     80042c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800501:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800508:	eb 26                	jmp    800530 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80050a:	a1 20 40 80 00       	mov    0x804020,%eax
  80050f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800515:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	c1 e0 03             	shl    $0x3,%eax
  800521:	01 c8                	add    %ecx,%eax
  800523:	8a 40 04             	mov    0x4(%eax),%al
  800526:	3c 01                	cmp    $0x1,%al
  800528:	75 03                	jne    80052d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80052a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052d:	ff 45 e0             	incl   -0x20(%ebp)
  800530:	a1 20 40 80 00       	mov    0x804020,%eax
  800535:	8b 50 74             	mov    0x74(%eax),%edx
  800538:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053b:	39 c2                	cmp    %eax,%edx
  80053d:	77 cb                	ja     80050a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80053f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800542:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800545:	74 14                	je     80055b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800547:	83 ec 04             	sub    $0x4,%esp
  80054a:	68 bc 35 80 00       	push   $0x8035bc
  80054f:	6a 44                	push   $0x44
  800551:	68 5c 35 80 00       	push   $0x80355c
  800556:	e8 23 fe ff ff       	call   80037e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	8d 48 01             	lea    0x1(%eax),%ecx
  80056c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80056f:	89 0a                	mov    %ecx,(%edx)
  800571:	8b 55 08             	mov    0x8(%ebp),%edx
  800574:	88 d1                	mov    %dl,%cl
  800576:	8b 55 0c             	mov    0xc(%ebp),%edx
  800579:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80057d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	3d ff 00 00 00       	cmp    $0xff,%eax
  800587:	75 2c                	jne    8005b5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800589:	a0 24 40 80 00       	mov    0x804024,%al
  80058e:	0f b6 c0             	movzbl %al,%eax
  800591:	8b 55 0c             	mov    0xc(%ebp),%edx
  800594:	8b 12                	mov    (%edx),%edx
  800596:	89 d1                	mov    %edx,%ecx
  800598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059b:	83 c2 08             	add    $0x8,%edx
  80059e:	83 ec 04             	sub    $0x4,%esp
  8005a1:	50                   	push   %eax
  8005a2:	51                   	push   %ecx
  8005a3:	52                   	push   %edx
  8005a4:	e8 22 13 00 00       	call   8018cb <sys_cputs>
  8005a9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 40 04             	mov    0x4(%eax),%eax
  8005bb:	8d 50 01             	lea    0x1(%eax),%edx
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005c4:	90                   	nop
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005d7:	00 00 00 
	b.cnt = 0;
  8005da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005e1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f0:	50                   	push   %eax
  8005f1:	68 5e 05 80 00       	push   $0x80055e
  8005f6:	e8 11 02 00 00       	call   80080c <vprintfmt>
  8005fb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005fe:	a0 24 40 80 00       	mov    0x804024,%al
  800603:	0f b6 c0             	movzbl %al,%eax
  800606:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	50                   	push   %eax
  800610:	52                   	push   %edx
  800611:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800617:	83 c0 08             	add    $0x8,%eax
  80061a:	50                   	push   %eax
  80061b:	e8 ab 12 00 00       	call   8018cb <sys_cputs>
  800620:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800623:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80062a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <cprintf>:

int cprintf(const char *fmt, ...) {
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800638:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80063f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 f4             	pushl  -0xc(%ebp)
  80064e:	50                   	push   %eax
  80064f:	e8 73 ff ff ff       	call   8005c7 <vcprintf>
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80065a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80065d:	c9                   	leave  
  80065e:	c3                   	ret    

0080065f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800665:	e8 0f 14 00 00       	call   801a79 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80066a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80066d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	ff 75 f4             	pushl  -0xc(%ebp)
  800679:	50                   	push   %eax
  80067a:	e8 48 ff ff ff       	call   8005c7 <vcprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800685:	e8 09 14 00 00       	call   801a93 <sys_enable_interrupt>
	return cnt;
  80068a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	53                   	push   %ebx
  800693:	83 ec 14             	sub    $0x14,%esp
  800696:	8b 45 10             	mov    0x10(%ebp),%eax
  800699:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ad:	77 55                	ja     800704 <printnum+0x75>
  8006af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b2:	72 05                	jb     8006b9 <printnum+0x2a>
  8006b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006b7:	77 4b                	ja     800704 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c7:	52                   	push   %edx
  8006c8:	50                   	push   %eax
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006cf:	e8 b4 29 00 00       	call   803088 <__udivdi3>
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	83 ec 04             	sub    $0x4,%esp
  8006da:	ff 75 20             	pushl  0x20(%ebp)
  8006dd:	53                   	push   %ebx
  8006de:	ff 75 18             	pushl  0x18(%ebp)
  8006e1:	52                   	push   %edx
  8006e2:	50                   	push   %eax
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 a1 ff ff ff       	call   80068f <printnum>
  8006ee:	83 c4 20             	add    $0x20,%esp
  8006f1:	eb 1a                	jmp    80070d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	ff d0                	call   *%eax
  800701:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800704:	ff 4d 1c             	decl   0x1c(%ebp)
  800707:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80070b:	7f e6                	jg     8006f3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80070d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800710:	bb 00 00 00 00       	mov    $0x0,%ebx
  800715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800718:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071b:	53                   	push   %ebx
  80071c:	51                   	push   %ecx
  80071d:	52                   	push   %edx
  80071e:	50                   	push   %eax
  80071f:	e8 74 2a 00 00       	call   803198 <__umoddi3>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	05 34 38 80 00       	add    $0x803834,%eax
  80072c:	8a 00                	mov    (%eax),%al
  80072e:	0f be c0             	movsbl %al,%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	50                   	push   %eax
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	ff d0                	call   *%eax
  80073d:	83 c4 10             	add    $0x10,%esp
}
  800740:	90                   	nop
  800741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800749:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074d:	7e 1c                	jle    80076b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	8d 50 08             	lea    0x8(%eax),%edx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 10                	mov    %edx,(%eax)
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 e8 08             	sub    $0x8,%eax
  800764:	8b 50 04             	mov    0x4(%eax),%edx
  800767:	8b 00                	mov    (%eax),%eax
  800769:	eb 40                	jmp    8007ab <getuint+0x65>
	else if (lflag)
  80076b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076f:	74 1e                	je     80078f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	8d 50 04             	lea    0x4(%eax),%edx
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	89 10                	mov    %edx,(%eax)
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	83 e8 04             	sub    $0x4,%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	eb 1c                	jmp    8007ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b4:	7e 1c                	jle    8007d2 <getint+0x25>
		return va_arg(*ap, long long);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 08             	lea    0x8(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 08             	sub    $0x8,%eax
  8007cb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	eb 38                	jmp    80080a <getint+0x5d>
	else if (lflag)
  8007d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d6:	74 1a                	je     8007f2 <getint+0x45>
		return va_arg(*ap, long);
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	8d 50 04             	lea    0x4(%eax),%edx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	89 10                	mov    %edx,(%eax)
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	83 e8 04             	sub    $0x4,%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	99                   	cltd   
  8007f0:	eb 18                	jmp    80080a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	8d 50 04             	lea    0x4(%eax),%edx
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	89 10                	mov    %edx,(%eax)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	99                   	cltd   
}
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	56                   	push   %esi
  800810:	53                   	push   %ebx
  800811:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800814:	eb 17                	jmp    80082d <vprintfmt+0x21>
			if (ch == '\0')
  800816:	85 db                	test   %ebx,%ebx
  800818:	0f 84 af 03 00 00    	je     800bcd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	53                   	push   %ebx
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082d:	8b 45 10             	mov    0x10(%ebp),%eax
  800830:	8d 50 01             	lea    0x1(%eax),%edx
  800833:	89 55 10             	mov    %edx,0x10(%ebp)
  800836:	8a 00                	mov    (%eax),%al
  800838:	0f b6 d8             	movzbl %al,%ebx
  80083b:	83 fb 25             	cmp    $0x25,%ebx
  80083e:	75 d6                	jne    800816 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800840:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800844:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80084b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800859:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800860:	8b 45 10             	mov    0x10(%ebp),%eax
  800863:	8d 50 01             	lea    0x1(%eax),%edx
  800866:	89 55 10             	mov    %edx,0x10(%ebp)
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f b6 d8             	movzbl %al,%ebx
  80086e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800871:	83 f8 55             	cmp    $0x55,%eax
  800874:	0f 87 2b 03 00 00    	ja     800ba5 <vprintfmt+0x399>
  80087a:	8b 04 85 58 38 80 00 	mov    0x803858(,%eax,4),%eax
  800881:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800883:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800887:	eb d7                	jmp    800860 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800889:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80088d:	eb d1                	jmp    800860 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800896:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800899:	89 d0                	mov    %edx,%eax
  80089b:	c1 e0 02             	shl    $0x2,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d8                	add    %ebx,%eax
  8008a4:	83 e8 30             	sub    $0x30,%eax
  8008a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ad:	8a 00                	mov    (%eax),%al
  8008af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008b5:	7e 3e                	jle    8008f5 <vprintfmt+0xe9>
  8008b7:	83 fb 39             	cmp    $0x39,%ebx
  8008ba:	7f 39                	jg     8008f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008bf:	eb d5                	jmp    800896 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	83 e8 04             	sub    $0x4,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008d5:	eb 1f                	jmp    8008f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008db:	79 83                	jns    800860 <vprintfmt+0x54>
				width = 0;
  8008dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008e4:	e9 77 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008f0:	e9 6b ff ff ff       	jmp    800860 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	0f 89 60 ff ff ff    	jns    800860 <vprintfmt+0x54>
				width = precision, precision = -1;
  800900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800903:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800906:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80090d:	e9 4e ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800912:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800915:	e9 46 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	83 c0 04             	add    $0x4,%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 e8 04             	sub    $0x4,%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	50                   	push   %eax
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
			break;
  80093a:	e9 89 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800950:	85 db                	test   %ebx,%ebx
  800952:	79 02                	jns    800956 <vprintfmt+0x14a>
				err = -err;
  800954:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800956:	83 fb 64             	cmp    $0x64,%ebx
  800959:	7f 0b                	jg     800966 <vprintfmt+0x15a>
  80095b:	8b 34 9d a0 36 80 00 	mov    0x8036a0(,%ebx,4),%esi
  800962:	85 f6                	test   %esi,%esi
  800964:	75 19                	jne    80097f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800966:	53                   	push   %ebx
  800967:	68 45 38 80 00       	push   $0x803845
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	ff 75 08             	pushl  0x8(%ebp)
  800972:	e8 5e 02 00 00       	call   800bd5 <printfmt>
  800977:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80097a:	e9 49 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80097f:	56                   	push   %esi
  800980:	68 4e 38 80 00       	push   $0x80384e
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	ff 75 08             	pushl  0x8(%ebp)
  80098b:	e8 45 02 00 00       	call   800bd5 <printfmt>
  800990:	83 c4 10             	add    $0x10,%esp
			break;
  800993:	e9 30 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 30                	mov    (%eax),%esi
  8009a9:	85 f6                	test   %esi,%esi
  8009ab:	75 05                	jne    8009b2 <vprintfmt+0x1a6>
				p = "(null)";
  8009ad:	be 51 38 80 00       	mov    $0x803851,%esi
			if (width > 0 && padc != '-')
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	7e 6d                	jle    800a25 <vprintfmt+0x219>
  8009b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009bc:	74 67                	je     800a25 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	50                   	push   %eax
  8009c5:	56                   	push   %esi
  8009c6:	e8 0c 03 00 00       	call   800cd7 <strnlen>
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009d1:	eb 16                	jmp    8009e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	50                   	push   %eax
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ed:	7f e4                	jg     8009d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ef:	eb 34                	jmp    800a25 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009f5:	74 1c                	je     800a13 <vprintfmt+0x207>
  8009f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009fa:	7e 05                	jle    800a01 <vprintfmt+0x1f5>
  8009fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ff:	7e 12                	jle    800a13 <vprintfmt+0x207>
					putch('?', putdat);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 0c             	pushl  0xc(%ebp)
  800a07:	6a 3f                	push   $0x3f
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	ff d0                	call   *%eax
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	eb 0f                	jmp    800a22 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	53                   	push   %ebx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	ff d0                	call   *%eax
  800a1f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a22:	ff 4d e4             	decl   -0x1c(%ebp)
  800a25:	89 f0                	mov    %esi,%eax
  800a27:	8d 70 01             	lea    0x1(%eax),%esi
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	0f be d8             	movsbl %al,%ebx
  800a2f:	85 db                	test   %ebx,%ebx
  800a31:	74 24                	je     800a57 <vprintfmt+0x24b>
  800a33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a37:	78 b8                	js     8009f1 <vprintfmt+0x1e5>
  800a39:	ff 4d e0             	decl   -0x20(%ebp)
  800a3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a40:	79 af                	jns    8009f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a42:	eb 13                	jmp    800a57 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 20                	push   $0x20
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	ff 4d e4             	decl   -0x1c(%ebp)
  800a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5b:	7f e7                	jg     800a44 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a5d:	e9 66 01 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 3c fd ff ff       	call   8007ad <getint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a80:	85 d2                	test   %edx,%edx
  800a82:	79 23                	jns    800aa7 <vprintfmt+0x29b>
				putch('-', putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	6a 2d                	push   $0x2d
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9a:	f7 d8                	neg    %eax
  800a9c:	83 d2 00             	adc    $0x0,%edx
  800a9f:	f7 da                	neg    %edx
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aa7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aae:	e9 bc 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 84 fc ff ff       	call   800746 <getuint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800acb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad2:	e9 98 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	6a 58                	push   $0x58
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	ff d0                	call   *%eax
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 bc 00 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 30                	push   $0x30
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 78                	push   $0x78
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2f:	83 c0 04             	add    $0x4,%eax
  800b32:	89 45 14             	mov    %eax,0x14(%ebp)
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	83 e8 04             	sub    $0x4,%eax
  800b3b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b47:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b4e:	eb 1f                	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 e8             	pushl  -0x18(%ebp)
  800b56:	8d 45 14             	lea    0x14(%ebp),%eax
  800b59:	50                   	push   %eax
  800b5a:	e8 e7 fb ff ff       	call   800746 <getuint>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b68:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b76:	83 ec 04             	sub    $0x4,%esp
  800b79:	52                   	push   %edx
  800b7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b7d:	50                   	push   %eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	ff 75 f0             	pushl  -0x10(%ebp)
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	ff 75 08             	pushl  0x8(%ebp)
  800b8a:	e8 00 fb ff ff       	call   80068f <printnum>
  800b8f:	83 c4 20             	add    $0x20,%esp
			break;
  800b92:	eb 34                	jmp    800bc8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	53                   	push   %ebx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	ff d0                	call   *%eax
  800ba0:	83 c4 10             	add    $0x10,%esp
			break;
  800ba3:	eb 23                	jmp    800bc8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	6a 25                	push   $0x25
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb5:	ff 4d 10             	decl   0x10(%ebp)
  800bb8:	eb 03                	jmp    800bbd <vprintfmt+0x3b1>
  800bba:	ff 4d 10             	decl   0x10(%ebp)
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	48                   	dec    %eax
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	3c 25                	cmp    $0x25,%al
  800bc5:	75 f3                	jne    800bba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bc7:	90                   	nop
		}
	}
  800bc8:	e9 47 fc ff ff       	jmp    800814 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bcd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bdb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bde:	83 c0 04             	add    $0x4,%eax
  800be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be4:	8b 45 10             	mov    0x10(%ebp),%eax
  800be7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bea:	50                   	push   %eax
  800beb:	ff 75 0c             	pushl  0xc(%ebp)
  800bee:	ff 75 08             	pushl  0x8(%ebp)
  800bf1:	e8 16 fc ff ff       	call   80080c <vprintfmt>
  800bf6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bf9:	90                   	nop
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 08             	mov    0x8(%eax),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8b 10                	mov    (%eax),%edx
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8b 40 04             	mov    0x4(%eax),%eax
  800c19:	39 c2                	cmp    %eax,%edx
  800c1b:	73 12                	jae    800c2f <sprintputch+0x33>
		*b->buf++ = ch;
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	8b 00                	mov    (%eax),%eax
  800c22:	8d 48 01             	lea    0x1(%eax),%ecx
  800c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c28:	89 0a                	mov    %ecx,(%edx)
  800c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2d:	88 10                	mov    %dl,(%eax)
}
  800c2f:	90                   	nop
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	01 d0                	add    %edx,%eax
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c57:	74 06                	je     800c5f <vsnprintf+0x2d>
  800c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5d:	7f 07                	jg     800c66 <vsnprintf+0x34>
		return -E_INVAL;
  800c5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c64:	eb 20                	jmp    800c86 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c66:	ff 75 14             	pushl  0x14(%ebp)
  800c69:	ff 75 10             	pushl  0x10(%ebp)
  800c6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c6f:	50                   	push   %eax
  800c70:	68 fc 0b 80 00       	push   $0x800bfc
  800c75:	e8 92 fb ff ff       	call   80080c <vprintfmt>
  800c7a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c80:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c91:	83 c0 04             	add    $0x4,%eax
  800c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	ff 75 08             	pushl  0x8(%ebp)
  800ca4:	e8 89 ff ff ff       	call   800c32 <vsnprintf>
  800ca9:	83 c4 10             	add    $0x10,%esp
  800cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc1:	eb 06                	jmp    800cc9 <strlen+0x15>
		n++;
  800cc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	84 c0                	test   %al,%al
  800cd0:	75 f1                	jne    800cc3 <strlen+0xf>
		n++;
	return n;
  800cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce4:	eb 09                	jmp    800cef <strnlen+0x18>
		n++;
  800ce6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce9:	ff 45 08             	incl   0x8(%ebp)
  800cec:	ff 4d 0c             	decl   0xc(%ebp)
  800cef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf3:	74 09                	je     800cfe <strnlen+0x27>
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 e8                	jne    800ce6 <strnlen+0xf>
		n++;
	return n;
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d01:	c9                   	leave  
  800d02:	c3                   	ret    

00800d03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d0f:	90                   	nop
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8d 50 01             	lea    0x1(%eax),%edx
  800d16:	89 55 08             	mov    %edx,0x8(%ebp)
  800d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d22:	8a 12                	mov    (%edx),%dl
  800d24:	88 10                	mov    %dl,(%eax)
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	75 e4                	jne    800d10 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d44:	eb 1f                	jmp    800d65 <strncpy+0x34>
		*dst++ = *src;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8d 50 01             	lea    0x1(%eax),%edx
  800d4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d52:	8a 12                	mov    (%edx),%dl
  800d54:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	74 03                	je     800d62 <strncpy+0x31>
			src++;
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d62:	ff 45 fc             	incl   -0x4(%ebp)
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d6b:	72 d9                	jb     800d46 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d70:	c9                   	leave  
  800d71:	c3                   	ret    

00800d72 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d82:	74 30                	je     800db4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d84:	eb 16                	jmp    800d9c <strlcpy+0x2a>
			*dst++ = *src++;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d9c:	ff 4d 10             	decl   0x10(%ebp)
  800d9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da3:	74 09                	je     800dae <strlcpy+0x3c>
  800da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 d8                	jne    800d86 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	29 c2                	sub    %eax,%edx
  800dbc:	89 d0                	mov    %edx,%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dc3:	eb 06                	jmp    800dcb <strcmp+0xb>
		p++, q++;
  800dc5:	ff 45 08             	incl   0x8(%ebp)
  800dc8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	84 c0                	test   %al,%al
  800dd2:	74 0e                	je     800de2 <strcmp+0x22>
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 10                	mov    (%eax),%dl
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	38 c2                	cmp    %al,%dl
  800de0:	74 e3                	je     800dc5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 d0             	movzbl %al,%edx
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	0f b6 c0             	movzbl %al,%eax
  800df2:	29 c2                	sub    %eax,%edx
  800df4:	89 d0                	mov    %edx,%eax
}
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dfb:	eb 09                	jmp    800e06 <strncmp+0xe>
		n--, p++, q++;
  800dfd:	ff 4d 10             	decl   0x10(%ebp)
  800e00:	ff 45 08             	incl   0x8(%ebp)
  800e03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0a:	74 17                	je     800e23 <strncmp+0x2b>
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	84 c0                	test   %al,%al
  800e13:	74 0e                	je     800e23 <strncmp+0x2b>
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 10                	mov    (%eax),%dl
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	38 c2                	cmp    %al,%dl
  800e21:	74 da                	je     800dfd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e27:	75 07                	jne    800e30 <strncmp+0x38>
		return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2e:	eb 14                	jmp    800e44 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	0f b6 d0             	movzbl %al,%edx
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f b6 c0             	movzbl %al,%eax
  800e40:	29 c2                	sub    %eax,%edx
  800e42:	89 d0                	mov    %edx,%eax
}
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e52:	eb 12                	jmp    800e66 <strchr+0x20>
		if (*s == c)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5c:	75 05                	jne    800e63 <strchr+0x1d>
			return (char *) s;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	eb 11                	jmp    800e74 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e63:	ff 45 08             	incl   0x8(%ebp)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	84 c0                	test   %al,%al
  800e6d:	75 e5                	jne    800e54 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    

00800e76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 04             	sub    $0x4,%esp
  800e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e82:	eb 0d                	jmp    800e91 <strfind+0x1b>
		if (*s == c)
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8c:	74 0e                	je     800e9c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e8e:	ff 45 08             	incl   0x8(%ebp)
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	84 c0                	test   %al,%al
  800e98:	75 ea                	jne    800e84 <strfind+0xe>
  800e9a:	eb 01                	jmp    800e9d <strfind+0x27>
		if (*s == c)
			break;
  800e9c:	90                   	nop
	return (char *) s;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eae:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800eb4:	eb 0e                	jmp    800ec4 <memset+0x22>
		*p++ = c;
  800eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb9:	8d 50 01             	lea    0x1(%eax),%edx
  800ebc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ec4:	ff 4d f8             	decl   -0x8(%ebp)
  800ec7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ecb:	79 e9                	jns    800eb6 <memset+0x14>
		*p++ = c;

	return v;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ee4:	eb 16                	jmp    800efc <memcpy+0x2a>
		*d++ = *s++;
  800ee6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee9:	8d 50 01             	lea    0x1(%eax),%edx
  800eec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ef2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ef8:	8a 12                	mov    (%edx),%dl
  800efa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 dd                	jne    800ee6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f26:	73 50                	jae    800f78 <memmove+0x6a>
  800f28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 d0                	add    %edx,%eax
  800f30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f33:	76 43                	jbe    800f78 <memmove+0x6a>
		s += n;
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f41:	eb 10                	jmp    800f53 <memmove+0x45>
			*--d = *--s;
  800f43:	ff 4d f8             	decl   -0x8(%ebp)
  800f46:	ff 4d fc             	decl   -0x4(%ebp)
  800f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4c:	8a 10                	mov    (%eax),%dl
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f59:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	75 e3                	jne    800f43 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f60:	eb 23                	jmp    800f85 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f71:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f74:	8a 12                	mov    (%edx),%dl
  800f76:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 dd                	jne    800f62 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f9c:	eb 2a                	jmp    800fc8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	8a 10                	mov    (%eax),%dl
  800fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	38 c2                	cmp    %al,%dl
  800faa:	74 16                	je     800fc2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 d0             	movzbl %al,%edx
  800fb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	29 c2                	sub    %eax,%edx
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	eb 18                	jmp    800fda <memcmp+0x50>
		s1++, s2++;
  800fc2:	ff 45 fc             	incl   -0x4(%ebp)
  800fc5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fce:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	75 c9                	jne    800f9e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 d0                	add    %edx,%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fed:	eb 15                	jmp    801004 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f b6 d0             	movzbl %al,%edx
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	0f b6 c0             	movzbl %al,%eax
  800ffd:	39 c2                	cmp    %eax,%edx
  800fff:	74 0d                	je     80100e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801001:	ff 45 08             	incl   0x8(%ebp)
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80100a:	72 e3                	jb     800fef <memfind+0x13>
  80100c:	eb 01                	jmp    80100f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80100e:	90                   	nop
	return (void *) s;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801021:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801028:	eb 03                	jmp    80102d <strtol+0x19>
		s++;
  80102a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 20                	cmp    $0x20,%al
  801034:	74 f4                	je     80102a <strtol+0x16>
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 09                	cmp    $0x9,%al
  80103d:	74 eb                	je     80102a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 2b                	cmp    $0x2b,%al
  801046:	75 05                	jne    80104d <strtol+0x39>
		s++;
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	eb 13                	jmp    801060 <strtol+0x4c>
	else if (*s == '-')
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	3c 2d                	cmp    $0x2d,%al
  801054:	75 0a                	jne    801060 <strtol+0x4c>
		s++, neg = 1;
  801056:	ff 45 08             	incl   0x8(%ebp)
  801059:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801060:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801064:	74 06                	je     80106c <strtol+0x58>
  801066:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80106a:	75 20                	jne    80108c <strtol+0x78>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 30                	cmp    $0x30,%al
  801073:	75 17                	jne    80108c <strtol+0x78>
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	40                   	inc    %eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 78                	cmp    $0x78,%al
  80107d:	75 0d                	jne    80108c <strtol+0x78>
		s += 2, base = 16;
  80107f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801083:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80108a:	eb 28                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80108c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801090:	75 15                	jne    8010a7 <strtol+0x93>
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	3c 30                	cmp    $0x30,%al
  801099:	75 0c                	jne    8010a7 <strtol+0x93>
		s++, base = 8;
  80109b:	ff 45 08             	incl   0x8(%ebp)
  80109e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010a5:	eb 0d                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0)
  8010a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ab:	75 07                	jne    8010b4 <strtol+0xa0>
		base = 10;
  8010ad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 2f                	cmp    $0x2f,%al
  8010bb:	7e 19                	jle    8010d6 <strtol+0xc2>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 39                	cmp    $0x39,%al
  8010c4:	7f 10                	jg     8010d6 <strtol+0xc2>
			dig = *s - '0';
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	0f be c0             	movsbl %al,%eax
  8010ce:	83 e8 30             	sub    $0x30,%eax
  8010d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010d4:	eb 42                	jmp    801118 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 60                	cmp    $0x60,%al
  8010dd:	7e 19                	jle    8010f8 <strtol+0xe4>
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	3c 7a                	cmp    $0x7a,%al
  8010e6:	7f 10                	jg     8010f8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	0f be c0             	movsbl %al,%eax
  8010f0:	83 e8 57             	sub    $0x57,%eax
  8010f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f6:	eb 20                	jmp    801118 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 40                	cmp    $0x40,%al
  8010ff:	7e 39                	jle    80113a <strtol+0x126>
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 5a                	cmp    $0x5a,%al
  801108:	7f 30                	jg     80113a <strtol+0x126>
			dig = *s - 'A' + 10;
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f be c0             	movsbl %al,%eax
  801112:	83 e8 37             	sub    $0x37,%eax
  801115:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80111e:	7d 19                	jge    801139 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801120:	ff 45 08             	incl   0x8(%ebp)
  801123:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801126:	0f af 45 10          	imul   0x10(%ebp),%eax
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801134:	e9 7b ff ff ff       	jmp    8010b4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801139:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80113a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80113e:	74 08                	je     801148 <strtol+0x134>
		*endptr = (char *) s;
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801148:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114c:	74 07                	je     801155 <strtol+0x141>
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	f7 d8                	neg    %eax
  801153:	eb 03                	jmp    801158 <strtol+0x144>
  801155:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <ltostr>:

void
ltostr(long value, char *str)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801167:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80116e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801172:	79 13                	jns    801187 <ltostr+0x2d>
	{
		neg = 1;
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801181:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801184:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80118f:	99                   	cltd   
  801190:	f7 f9                	idiv   %ecx
  801192:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	8d 50 01             	lea    0x1(%eax),%edx
  80119b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119e:	89 c2                	mov    %eax,%edx
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	01 d0                	add    %edx,%eax
  8011a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a8:	83 c2 30             	add    $0x30,%edx
  8011ab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b5:	f7 e9                	imul   %ecx
  8011b7:	c1 fa 02             	sar    $0x2,%edx
  8011ba:	89 c8                	mov    %ecx,%eax
  8011bc:	c1 f8 1f             	sar    $0x1f,%eax
  8011bf:	29 c2                	sub    %eax,%edx
  8011c1:	89 d0                	mov    %edx,%eax
  8011c3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ce:	f7 e9                	imul   %ecx
  8011d0:	c1 fa 02             	sar    $0x2,%edx
  8011d3:	89 c8                	mov    %ecx,%eax
  8011d5:	c1 f8 1f             	sar    $0x1f,%eax
  8011d8:	29 c2                	sub    %eax,%edx
  8011da:	89 d0                	mov    %edx,%eax
  8011dc:	c1 e0 02             	shl    $0x2,%eax
  8011df:	01 d0                	add    %edx,%eax
  8011e1:	01 c0                	add    %eax,%eax
  8011e3:	29 c1                	sub    %eax,%ecx
  8011e5:	89 ca                	mov    %ecx,%edx
  8011e7:	85 d2                	test   %edx,%edx
  8011e9:	75 9c                	jne    801187 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	48                   	dec    %eax
  8011f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011fd:	74 3d                	je     80123c <ltostr+0xe2>
		start = 1 ;
  8011ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801206:	eb 34                	jmp    80123c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	01 d0                	add    %edx,%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	01 c8                	add    %ecx,%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801229:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 c2                	add    %eax,%edx
  801231:	8a 45 eb             	mov    -0x15(%ebp),%al
  801234:	88 02                	mov    %al,(%edx)
		start++ ;
  801236:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801239:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80123c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801242:	7c c4                	jl     801208 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801244:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80124f:	90                   	nop
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801258:	ff 75 08             	pushl  0x8(%ebp)
  80125b:	e8 54 fa ff ff       	call   800cb4 <strlen>
  801260:	83 c4 04             	add    $0x4,%esp
  801263:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 46 fa ff ff       	call   800cb4 <strlen>
  80126e:	83 c4 04             	add    $0x4,%esp
  801271:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801282:	eb 17                	jmp    80129b <strcconcat+0x49>
		final[s] = str1[s] ;
  801284:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 c2                	add    %eax,%edx
  80128c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	01 c8                	add    %ecx,%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801298:	ff 45 fc             	incl   -0x4(%ebp)
  80129b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012a1:	7c e1                	jl     801284 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012b1:	eb 1f                	jmp    8012d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012bc:	89 c2                	mov    %eax,%edx
  8012be:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c1:	01 c2                	add    %eax,%edx
  8012c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	01 c8                	add    %ecx,%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012cf:	ff 45 f8             	incl   -0x8(%ebp)
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d8:	7c d9                	jl     8012b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012e5:	90                   	nop
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f7:	8b 00                	mov    (%eax),%eax
  8012f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801300:	8b 45 10             	mov    0x10(%ebp),%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80130b:	eb 0c                	jmp    801319 <strsplit+0x31>
			*string++ = 0;
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8d 50 01             	lea    0x1(%eax),%edx
  801313:	89 55 08             	mov    %edx,0x8(%ebp)
  801316:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	84 c0                	test   %al,%al
  801320:	74 18                	je     80133a <strsplit+0x52>
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	0f be c0             	movsbl %al,%eax
  80132a:	50                   	push   %eax
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	e8 13 fb ff ff       	call   800e46 <strchr>
  801333:	83 c4 08             	add    $0x8,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	75 d3                	jne    80130d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	84 c0                	test   %al,%al
  801341:	74 5a                	je     80139d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801343:	8b 45 14             	mov    0x14(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 f8 0f             	cmp    $0xf,%eax
  80134b:	75 07                	jne    801354 <strsplit+0x6c>
		{
			return 0;
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
  801352:	eb 66                	jmp    8013ba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801354:	8b 45 14             	mov    0x14(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 14             	mov    0x14(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	01 c2                	add    %eax,%edx
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801372:	eb 03                	jmp    801377 <strsplit+0x8f>
			string++;
  801374:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	84 c0                	test   %al,%al
  80137e:	74 8b                	je     80130b <strsplit+0x23>
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	0f be c0             	movsbl %al,%eax
  801388:	50                   	push   %eax
  801389:	ff 75 0c             	pushl  0xc(%ebp)
  80138c:	e8 b5 fa ff ff       	call   800e46 <strchr>
  801391:	83 c4 08             	add    $0x8,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	74 dc                	je     801374 <strsplit+0x8c>
			string++;
	}
  801398:	e9 6e ff ff ff       	jmp    80130b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80139d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80139e:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a1:	8b 00                	mov    (%eax),%eax
  8013a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ad:	01 d0                	add    %edx,%eax
  8013af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013c2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	74 1f                	je     8013ea <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013cb:	e8 1d 00 00 00       	call   8013ed <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	68 b0 39 80 00       	push   $0x8039b0
  8013d8:	e8 55 f2 ff ff       	call   800632 <cprintf>
  8013dd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013e0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013e7:	00 00 00 
	}
}
  8013ea:	90                   	nop
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8013f3:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013fa:	00 00 00 
  8013fd:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801404:	00 00 00 
  801407:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80140e:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801411:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801418:	00 00 00 
  80141b:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801422:	00 00 00 
  801425:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80142c:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80142f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801436:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801439:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801443:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801448:	2d 00 10 00 00       	sub    $0x1000,%eax
  80144d:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801452:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801459:	a1 20 41 80 00       	mov    0x804120,%eax
  80145e:	c1 e0 04             	shl    $0x4,%eax
  801461:	89 c2                	mov    %eax,%edx
  801463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801466:	01 d0                	add    %edx,%eax
  801468:	48                   	dec    %eax
  801469:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80146c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80146f:	ba 00 00 00 00       	mov    $0x0,%edx
  801474:	f7 75 f0             	divl   -0x10(%ebp)
  801477:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147a:	29 d0                	sub    %edx,%eax
  80147c:	89 c2                	mov    %eax,%edx
  80147e:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801485:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801488:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80148d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	6a 06                	push   $0x6
  801497:	52                   	push   %edx
  801498:	50                   	push   %eax
  801499:	e8 71 05 00 00       	call   801a0f <sys_allocate_chunk>
  80149e:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014a1:	a1 20 41 80 00       	mov    0x804120,%eax
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	50                   	push   %eax
  8014aa:	e8 e6 0b 00 00       	call   802095 <initialize_MemBlocksList>
  8014af:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8014b2:	a1 48 41 80 00       	mov    0x804148,%eax
  8014b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8014ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014be:	75 14                	jne    8014d4 <initialize_dyn_block_system+0xe7>
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	68 d5 39 80 00       	push   $0x8039d5
  8014c8:	6a 2b                	push   $0x2b
  8014ca:	68 f3 39 80 00       	push   $0x8039f3
  8014cf:	e8 aa ee ff ff       	call   80037e <_panic>
  8014d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d7:	8b 00                	mov    (%eax),%eax
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	74 10                	je     8014ed <initialize_dyn_block_system+0x100>
  8014dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014e0:	8b 00                	mov    (%eax),%eax
  8014e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014e5:	8b 52 04             	mov    0x4(%edx),%edx
  8014e8:	89 50 04             	mov    %edx,0x4(%eax)
  8014eb:	eb 0b                	jmp    8014f8 <initialize_dyn_block_system+0x10b>
  8014ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f0:	8b 40 04             	mov    0x4(%eax),%eax
  8014f3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014fb:	8b 40 04             	mov    0x4(%eax),%eax
  8014fe:	85 c0                	test   %eax,%eax
  801500:	74 0f                	je     801511 <initialize_dyn_block_system+0x124>
  801502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801505:	8b 40 04             	mov    0x4(%eax),%eax
  801508:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80150b:	8b 12                	mov    (%edx),%edx
  80150d:	89 10                	mov    %edx,(%eax)
  80150f:	eb 0a                	jmp    80151b <initialize_dyn_block_system+0x12e>
  801511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801514:	8b 00                	mov    (%eax),%eax
  801516:	a3 48 41 80 00       	mov    %eax,0x804148
  80151b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80151e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801527:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80152e:	a1 54 41 80 00       	mov    0x804154,%eax
  801533:	48                   	dec    %eax
  801534:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80153c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801546:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80154d:	83 ec 0c             	sub    $0xc,%esp
  801550:	ff 75 e4             	pushl  -0x1c(%ebp)
  801553:	e8 d2 13 00 00       	call   80292a <insert_sorted_with_merge_freeList>
  801558:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80155b:	90                   	nop
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801564:	e8 53 fe ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  801569:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80156d:	75 07                	jne    801576 <malloc+0x18>
  80156f:	b8 00 00 00 00       	mov    $0x0,%eax
  801574:	eb 61                	jmp    8015d7 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801576:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80157d:	8b 55 08             	mov    0x8(%ebp),%edx
  801580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801583:	01 d0                	add    %edx,%eax
  801585:	48                   	dec    %eax
  801586:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158c:	ba 00 00 00 00       	mov    $0x0,%edx
  801591:	f7 75 f4             	divl   -0xc(%ebp)
  801594:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801597:	29 d0                	sub    %edx,%eax
  801599:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80159c:	e8 3c 08 00 00       	call   801ddd <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	74 2d                	je     8015d2 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8015a5:	83 ec 0c             	sub    $0xc,%esp
  8015a8:	ff 75 08             	pushl  0x8(%ebp)
  8015ab:	e8 3e 0f 00 00       	call   8024ee <alloc_block_FF>
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8015b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015ba:	74 16                	je     8015d2 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8015bc:	83 ec 0c             	sub    $0xc,%esp
  8015bf:	ff 75 ec             	pushl  -0x14(%ebp)
  8015c2:	e8 48 0c 00 00       	call   80220f <insert_sorted_allocList>
  8015c7:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8015ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015cd:	8b 40 08             	mov    0x8(%eax),%eax
  8015d0:	eb 05                	jmp    8015d7 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8015d2:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ed:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	83 ec 08             	sub    $0x8,%esp
  8015f6:	50                   	push   %eax
  8015f7:	68 40 40 80 00       	push   $0x804040
  8015fc:	e8 71 0b 00 00       	call   802172 <find_block>
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160a:	8b 50 0c             	mov    0xc(%eax),%edx
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	52                   	push   %edx
  801614:	50                   	push   %eax
  801615:	e8 bd 03 00 00       	call   8019d7 <sys_free_user_mem>
  80161a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80161d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801621:	75 14                	jne    801637 <free+0x5e>
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	68 d5 39 80 00       	push   $0x8039d5
  80162b:	6a 71                	push   $0x71
  80162d:	68 f3 39 80 00       	push   $0x8039f3
  801632:	e8 47 ed ff ff       	call   80037e <_panic>
  801637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163a:	8b 00                	mov    (%eax),%eax
  80163c:	85 c0                	test   %eax,%eax
  80163e:	74 10                	je     801650 <free+0x77>
  801640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801643:	8b 00                	mov    (%eax),%eax
  801645:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801648:	8b 52 04             	mov    0x4(%edx),%edx
  80164b:	89 50 04             	mov    %edx,0x4(%eax)
  80164e:	eb 0b                	jmp    80165b <free+0x82>
  801650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801653:	8b 40 04             	mov    0x4(%eax),%eax
  801656:	a3 44 40 80 00       	mov    %eax,0x804044
  80165b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165e:	8b 40 04             	mov    0x4(%eax),%eax
  801661:	85 c0                	test   %eax,%eax
  801663:	74 0f                	je     801674 <free+0x9b>
  801665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801668:	8b 40 04             	mov    0x4(%eax),%eax
  80166b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166e:	8b 12                	mov    (%edx),%edx
  801670:	89 10                	mov    %edx,(%eax)
  801672:	eb 0a                	jmp    80167e <free+0xa5>
  801674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801677:	8b 00                	mov    (%eax),%eax
  801679:	a3 40 40 80 00       	mov    %eax,0x804040
  80167e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801681:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801687:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801691:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801696:	48                   	dec    %eax
  801697:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	ff 75 f0             	pushl  -0x10(%ebp)
  8016a2:	e8 83 12 00 00       	call   80292a <insert_sorted_with_merge_freeList>
  8016a7:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016aa:	90                   	nop
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 28             	sub    $0x28,%esp
  8016b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b6:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b9:	e8 fe fc ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  8016be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016c2:	75 0a                	jne    8016ce <smalloc+0x21>
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c9:	e9 86 00 00 00       	jmp    801754 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8016ce:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016db:	01 d0                	add    %edx,%eax
  8016dd:	48                   	dec    %eax
  8016de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e9:	f7 75 f4             	divl   -0xc(%ebp)
  8016ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ef:	29 d0                	sub    %edx,%eax
  8016f1:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016f4:	e8 e4 06 00 00       	call   801ddd <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	74 52                	je     80174f <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8016fd:	83 ec 0c             	sub    $0xc,%esp
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	e8 e6 0d 00 00       	call   8024ee <alloc_block_FF>
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  80170e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801712:	75 07                	jne    80171b <smalloc+0x6e>
			return NULL ;
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
  801719:	eb 39                	jmp    801754 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80171b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171e:	8b 40 08             	mov    0x8(%eax),%eax
  801721:	89 c2                	mov    %eax,%edx
  801723:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801727:	52                   	push   %edx
  801728:	50                   	push   %eax
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	ff 75 08             	pushl  0x8(%ebp)
  80172f:	e8 2e 04 00 00       	call   801b62 <sys_createSharedObject>
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80173a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80173e:	79 07                	jns    801747 <smalloc+0x9a>
			return (void*)NULL ;
  801740:	b8 00 00 00 00       	mov    $0x0,%eax
  801745:	eb 0d                	jmp    801754 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801747:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174a:	8b 40 08             	mov    0x8(%eax),%eax
  80174d:	eb 05                	jmp    801754 <smalloc+0xa7>
		}
		return (void*)NULL ;
  80174f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80175c:	e8 5b fc ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	ff 75 08             	pushl  0x8(%ebp)
  80176a:	e8 1d 04 00 00       	call   801b8c <sys_getSizeOfSharedObject>
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801775:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801779:	75 0a                	jne    801785 <sget+0x2f>
			return NULL ;
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
  801780:	e9 83 00 00 00       	jmp    801808 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801785:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80178c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801792:	01 d0                	add    %edx,%eax
  801794:	48                   	dec    %eax
  801795:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801798:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179b:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a0:	f7 75 f0             	divl   -0x10(%ebp)
  8017a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a6:	29 d0                	sub    %edx,%eax
  8017a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017ab:	e8 2d 06 00 00       	call   801ddd <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	74 4f                	je     801803 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8017b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b7:	83 ec 0c             	sub    $0xc,%esp
  8017ba:	50                   	push   %eax
  8017bb:	e8 2e 0d 00 00       	call   8024ee <alloc_block_FF>
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8017c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017ca:	75 07                	jne    8017d3 <sget+0x7d>
					return (void*)NULL ;
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d1:	eb 35                	jmp    801808 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8017d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d6:	8b 40 08             	mov    0x8(%eax),%eax
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	50                   	push   %eax
  8017dd:	ff 75 0c             	pushl  0xc(%ebp)
  8017e0:	ff 75 08             	pushl  0x8(%ebp)
  8017e3:	e8 c1 03 00 00       	call   801ba9 <sys_getSharedObject>
  8017e8:	83 c4 10             	add    $0x10,%esp
  8017eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8017ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017f2:	79 07                	jns    8017fb <sget+0xa5>
				return (void*)NULL ;
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f9:	eb 0d                	jmp    801808 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8017fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017fe:	8b 40 08             	mov    0x8(%eax),%eax
  801801:	eb 05                	jmp    801808 <sget+0xb2>


		}
	return (void*)NULL ;
  801803:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801810:	e8 a7 fb ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801815:	83 ec 04             	sub    $0x4,%esp
  801818:	68 00 3a 80 00       	push   $0x803a00
  80181d:	68 f9 00 00 00       	push   $0xf9
  801822:	68 f3 39 80 00       	push   $0x8039f3
  801827:	e8 52 eb ff ff       	call   80037e <_panic>

0080182c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801832:	83 ec 04             	sub    $0x4,%esp
  801835:	68 28 3a 80 00       	push   $0x803a28
  80183a:	68 0d 01 00 00       	push   $0x10d
  80183f:	68 f3 39 80 00       	push   $0x8039f3
  801844:	e8 35 eb ff ff       	call   80037e <_panic>

00801849 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	68 4c 3a 80 00       	push   $0x803a4c
  801857:	68 18 01 00 00       	push   $0x118
  80185c:	68 f3 39 80 00       	push   $0x8039f3
  801861:	e8 18 eb ff ff       	call   80037e <_panic>

00801866 <shrink>:

}
void shrink(uint32 newSize)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80186c:	83 ec 04             	sub    $0x4,%esp
  80186f:	68 4c 3a 80 00       	push   $0x803a4c
  801874:	68 1d 01 00 00       	push   $0x11d
  801879:	68 f3 39 80 00       	push   $0x8039f3
  80187e:	e8 fb ea ff ff       	call   80037e <_panic>

00801883 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801889:	83 ec 04             	sub    $0x4,%esp
  80188c:	68 4c 3a 80 00       	push   $0x803a4c
  801891:	68 22 01 00 00       	push   $0x122
  801896:	68 f3 39 80 00       	push   $0x8039f3
  80189b:	e8 de ea ff ff       	call   80037e <_panic>

008018a0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	57                   	push   %edi
  8018a4:	56                   	push   %esi
  8018a5:	53                   	push   %ebx
  8018a6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018b8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018bb:	cd 30                	int    $0x30
  8018bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	5b                   	pop    %ebx
  8018c7:	5e                   	pop    %esi
  8018c8:	5f                   	pop    %edi
  8018c9:	5d                   	pop    %ebp
  8018ca:	c3                   	ret    

008018cb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018d7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	52                   	push   %edx
  8018e3:	ff 75 0c             	pushl  0xc(%ebp)
  8018e6:	50                   	push   %eax
  8018e7:	6a 00                	push   $0x0
  8018e9:	e8 b2 ff ff ff       	call   8018a0 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
}
  8018f1:	90                   	nop
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 01                	push   $0x1
  801903:	e8 98 ff ff ff       	call   8018a0 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801910:	8b 55 0c             	mov    0xc(%ebp),%edx
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	52                   	push   %edx
  80191d:	50                   	push   %eax
  80191e:	6a 05                	push   $0x5
  801920:	e8 7b ff ff ff       	call   8018a0 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	56                   	push   %esi
  80192e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80192f:	8b 75 18             	mov    0x18(%ebp),%esi
  801932:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801935:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	56                   	push   %esi
  80193f:	53                   	push   %ebx
  801940:	51                   	push   %ecx
  801941:	52                   	push   %edx
  801942:	50                   	push   %eax
  801943:	6a 06                	push   $0x6
  801945:	e8 56 ff ff ff       	call   8018a0 <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801950:	5b                   	pop    %ebx
  801951:	5e                   	pop    %esi
  801952:	5d                   	pop    %ebp
  801953:	c3                   	ret    

00801954 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	52                   	push   %edx
  801964:	50                   	push   %eax
  801965:	6a 07                	push   $0x7
  801967:	e8 34 ff ff ff       	call   8018a0 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	ff 75 0c             	pushl  0xc(%ebp)
  80197d:	ff 75 08             	pushl  0x8(%ebp)
  801980:	6a 08                	push   $0x8
  801982:	e8 19 ff ff ff       	call   8018a0 <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 09                	push   $0x9
  80199b:	e8 00 ff ff ff       	call   8018a0 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 0a                	push   $0xa
  8019b4:	e8 e7 fe ff ff       	call   8018a0 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 0b                	push   $0xb
  8019cd:	e8 ce fe ff ff       	call   8018a0 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	ff 75 0c             	pushl  0xc(%ebp)
  8019e3:	ff 75 08             	pushl  0x8(%ebp)
  8019e6:	6a 0f                	push   $0xf
  8019e8:	e8 b3 fe ff ff       	call   8018a0 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
	return;
  8019f0:	90                   	nop
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	ff 75 08             	pushl  0x8(%ebp)
  801a02:	6a 10                	push   $0x10
  801a04:	e8 97 fe ff ff       	call   8018a0 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0c:	90                   	nop
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	ff 75 10             	pushl  0x10(%ebp)
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	ff 75 08             	pushl  0x8(%ebp)
  801a1f:	6a 11                	push   $0x11
  801a21:	e8 7a fe ff ff       	call   8018a0 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
	return ;
  801a29:	90                   	nop
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 0c                	push   $0xc
  801a3b:	e8 60 fe ff ff       	call   8018a0 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	ff 75 08             	pushl  0x8(%ebp)
  801a53:	6a 0d                	push   $0xd
  801a55:	e8 46 fe ff ff       	call   8018a0 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 0e                	push   $0xe
  801a6e:	e8 2d fe ff ff       	call   8018a0 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	90                   	nop
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 13                	push   $0x13
  801a88:	e8 13 fe ff ff       	call   8018a0 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	90                   	nop
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 14                	push   $0x14
  801aa2:	e8 f9 fd ff ff       	call   8018a0 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	90                   	nop
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_cputc>:


void
sys_cputc(const char c)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	83 ec 04             	sub    $0x4,%esp
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ab9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	50                   	push   %eax
  801ac6:	6a 15                	push   $0x15
  801ac8:	e8 d3 fd ff ff       	call   8018a0 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	90                   	nop
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 16                	push   $0x16
  801ae2:	e8 b9 fd ff ff       	call   8018a0 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	90                   	nop
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 0c             	pushl  0xc(%ebp)
  801afc:	50                   	push   %eax
  801afd:	6a 17                	push   $0x17
  801aff:	e8 9c fd ff ff       	call   8018a0 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	52                   	push   %edx
  801b19:	50                   	push   %eax
  801b1a:	6a 1a                	push   $0x1a
  801b1c:	e8 7f fd ff ff       	call   8018a0 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	52                   	push   %edx
  801b36:	50                   	push   %eax
  801b37:	6a 18                	push   $0x18
  801b39:	e8 62 fd ff ff       	call   8018a0 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	90                   	nop
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	52                   	push   %edx
  801b54:	50                   	push   %eax
  801b55:	6a 19                	push   $0x19
  801b57:	e8 44 fd ff ff       	call   8018a0 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	90                   	nop
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 04             	sub    $0x4,%esp
  801b68:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b71:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	6a 00                	push   $0x0
  801b7a:	51                   	push   %ecx
  801b7b:	52                   	push   %edx
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	50                   	push   %eax
  801b80:	6a 1b                	push   $0x1b
  801b82:	e8 19 fd ff ff       	call   8018a0 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	52                   	push   %edx
  801b9c:	50                   	push   %eax
  801b9d:	6a 1c                	push   $0x1c
  801b9f:	e8 fc fc ff ff       	call   8018a0 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801baf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	51                   	push   %ecx
  801bba:	52                   	push   %edx
  801bbb:	50                   	push   %eax
  801bbc:	6a 1d                	push   $0x1d
  801bbe:	e8 dd fc ff ff       	call   8018a0 <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	52                   	push   %edx
  801bd8:	50                   	push   %eax
  801bd9:	6a 1e                	push   $0x1e
  801bdb:	e8 c0 fc ff ff       	call   8018a0 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 1f                	push   $0x1f
  801bf4:	e8 a7 fc ff ff       	call   8018a0 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	6a 00                	push   $0x0
  801c06:	ff 75 14             	pushl  0x14(%ebp)
  801c09:	ff 75 10             	pushl  0x10(%ebp)
  801c0c:	ff 75 0c             	pushl  0xc(%ebp)
  801c0f:	50                   	push   %eax
  801c10:	6a 20                	push   $0x20
  801c12:	e8 89 fc ff ff       	call   8018a0 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	50                   	push   %eax
  801c2b:	6a 21                	push   $0x21
  801c2d:	e8 6e fc ff ff       	call   8018a0 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
}
  801c35:	90                   	nop
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	50                   	push   %eax
  801c47:	6a 22                	push   $0x22
  801c49:	e8 52 fc ff ff       	call   8018a0 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 02                	push   $0x2
  801c62:	e8 39 fc ff ff       	call   8018a0 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 03                	push   $0x3
  801c7b:	e8 20 fc ff ff       	call   8018a0 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 04                	push   $0x4
  801c94:	e8 07 fc ff ff       	call   8018a0 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_exit_env>:


void sys_exit_env(void)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 23                	push   $0x23
  801cad:	e8 ee fb ff ff       	call   8018a0 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	90                   	nop
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cbe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cc1:	8d 50 04             	lea    0x4(%eax),%edx
  801cc4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	52                   	push   %edx
  801cce:	50                   	push   %eax
  801ccf:	6a 24                	push   $0x24
  801cd1:	e8 ca fb ff ff       	call   8018a0 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
	return result;
  801cd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cdf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ce2:	89 01                	mov    %eax,(%ecx)
  801ce4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	c9                   	leave  
  801ceb:	c2 04 00             	ret    $0x4

00801cee <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	ff 75 10             	pushl  0x10(%ebp)
  801cf8:	ff 75 0c             	pushl  0xc(%ebp)
  801cfb:	ff 75 08             	pushl  0x8(%ebp)
  801cfe:	6a 12                	push   $0x12
  801d00:	e8 9b fb ff ff       	call   8018a0 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
	return ;
  801d08:	90                   	nop
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_rcr2>:
uint32 sys_rcr2()
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 25                	push   $0x25
  801d1a:	e8 81 fb ff ff       	call   8018a0 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 04             	sub    $0x4,%esp
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d30:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	50                   	push   %eax
  801d3d:	6a 26                	push   $0x26
  801d3f:	e8 5c fb ff ff       	call   8018a0 <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
	return ;
  801d47:	90                   	nop
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <rsttst>:
void rsttst()
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 28                	push   $0x28
  801d59:	e8 42 fb ff ff       	call   8018a0 <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d61:	90                   	nop
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 04             	sub    $0x4,%esp
  801d6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d70:	8b 55 18             	mov    0x18(%ebp),%edx
  801d73:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d77:	52                   	push   %edx
  801d78:	50                   	push   %eax
  801d79:	ff 75 10             	pushl  0x10(%ebp)
  801d7c:	ff 75 0c             	pushl  0xc(%ebp)
  801d7f:	ff 75 08             	pushl  0x8(%ebp)
  801d82:	6a 27                	push   $0x27
  801d84:	e8 17 fb ff ff       	call   8018a0 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8c:	90                   	nop
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <chktst>:
void chktst(uint32 n)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	ff 75 08             	pushl  0x8(%ebp)
  801d9d:	6a 29                	push   $0x29
  801d9f:	e8 fc fa ff ff       	call   8018a0 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
	return ;
  801da7:	90                   	nop
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <inctst>:

void inctst()
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 2a                	push   $0x2a
  801db9:	e8 e2 fa ff ff       	call   8018a0 <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc1:	90                   	nop
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <gettst>:
uint32 gettst()
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 2b                	push   $0x2b
  801dd3:	e8 c8 fa ff ff       	call   8018a0 <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 2c                	push   $0x2c
  801def:	e8 ac fa ff ff       	call   8018a0 <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
  801df7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dfa:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dfe:	75 07                	jne    801e07 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e00:	b8 01 00 00 00       	mov    $0x1,%eax
  801e05:	eb 05                	jmp    801e0c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 2c                	push   $0x2c
  801e20:	e8 7b fa ff ff       	call   8018a0 <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
  801e28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e2b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e2f:	75 07                	jne    801e38 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e31:	b8 01 00 00 00       	mov    $0x1,%eax
  801e36:	eb 05                	jmp    801e3d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 2c                	push   $0x2c
  801e51:	e8 4a fa ff ff       	call   8018a0 <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
  801e59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e5c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e60:	75 07                	jne    801e69 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e62:	b8 01 00 00 00       	mov    $0x1,%eax
  801e67:	eb 05                	jmp    801e6e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 2c                	push   $0x2c
  801e82:	e8 19 fa ff ff       	call   8018a0 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
  801e8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e8d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e91:	75 07                	jne    801e9a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e93:	b8 01 00 00 00       	mov    $0x1,%eax
  801e98:	eb 05                	jmp    801e9f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	ff 75 08             	pushl  0x8(%ebp)
  801eaf:	6a 2d                	push   $0x2d
  801eb1:	e8 ea f9 ff ff       	call   8018a0 <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb9:	90                   	nop
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ec0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ec3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecc:	6a 00                	push   $0x0
  801ece:	53                   	push   %ebx
  801ecf:	51                   	push   %ecx
  801ed0:	52                   	push   %edx
  801ed1:	50                   	push   %eax
  801ed2:	6a 2e                	push   $0x2e
  801ed4:	e8 c7 f9 ff ff       	call   8018a0 <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
}
  801edc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	52                   	push   %edx
  801ef1:	50                   	push   %eax
  801ef2:	6a 2f                	push   $0x2f
  801ef4:	e8 a7 f9 ff ff       	call   8018a0 <syscall>
  801ef9:	83 c4 18             	add    $0x18,%esp
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f04:	83 ec 0c             	sub    $0xc,%esp
  801f07:	68 5c 3a 80 00       	push   $0x803a5c
  801f0c:	e8 21 e7 ff ff       	call   800632 <cprintf>
  801f11:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	68 88 3a 80 00       	push   $0x803a88
  801f23:	e8 0a e7 ff ff       	call   800632 <cprintf>
  801f28:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f2b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f2f:	a1 38 41 80 00       	mov    0x804138,%eax
  801f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f37:	eb 56                	jmp    801f8f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f3d:	74 1c                	je     801f5b <print_mem_block_lists+0x5d>
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	8b 50 08             	mov    0x8(%eax),%edx
  801f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f48:	8b 48 08             	mov    0x8(%eax),%ecx
  801f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f51:	01 c8                	add    %ecx,%eax
  801f53:	39 c2                	cmp    %eax,%edx
  801f55:	73 04                	jae    801f5b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f57:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5e:	8b 50 08             	mov    0x8(%eax),%edx
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	8b 40 0c             	mov    0xc(%eax),%eax
  801f67:	01 c2                	add    %eax,%edx
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	8b 40 08             	mov    0x8(%eax),%eax
  801f6f:	83 ec 04             	sub    $0x4,%esp
  801f72:	52                   	push   %edx
  801f73:	50                   	push   %eax
  801f74:	68 9d 3a 80 00       	push   $0x803a9d
  801f79:	e8 b4 e6 ff ff       	call   800632 <cprintf>
  801f7e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f87:	a1 40 41 80 00       	mov    0x804140,%eax
  801f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f93:	74 07                	je     801f9c <print_mem_block_lists+0x9e>
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	8b 00                	mov    (%eax),%eax
  801f9a:	eb 05                	jmp    801fa1 <print_mem_block_lists+0xa3>
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa1:	a3 40 41 80 00       	mov    %eax,0x804140
  801fa6:	a1 40 41 80 00       	mov    0x804140,%eax
  801fab:	85 c0                	test   %eax,%eax
  801fad:	75 8a                	jne    801f39 <print_mem_block_lists+0x3b>
  801faf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb3:	75 84                	jne    801f39 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fb5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fb9:	75 10                	jne    801fcb <print_mem_block_lists+0xcd>
  801fbb:	83 ec 0c             	sub    $0xc,%esp
  801fbe:	68 ac 3a 80 00       	push   $0x803aac
  801fc3:	e8 6a e6 ff ff       	call   800632 <cprintf>
  801fc8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fcb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fd2:	83 ec 0c             	sub    $0xc,%esp
  801fd5:	68 d0 3a 80 00       	push   $0x803ad0
  801fda:	e8 53 e6 ff ff       	call   800632 <cprintf>
  801fdf:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fe2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fe6:	a1 40 40 80 00       	mov    0x804040,%eax
  801feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fee:	eb 56                	jmp    802046 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ff0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ff4:	74 1c                	je     802012 <print_mem_block_lists+0x114>
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	8b 50 08             	mov    0x8(%eax),%edx
  801ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fff:	8b 48 08             	mov    0x8(%eax),%ecx
  802002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802005:	8b 40 0c             	mov    0xc(%eax),%eax
  802008:	01 c8                	add    %ecx,%eax
  80200a:	39 c2                	cmp    %eax,%edx
  80200c:	73 04                	jae    802012 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80200e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802015:	8b 50 08             	mov    0x8(%eax),%edx
  802018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201b:	8b 40 0c             	mov    0xc(%eax),%eax
  80201e:	01 c2                	add    %eax,%edx
  802020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802023:	8b 40 08             	mov    0x8(%eax),%eax
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	52                   	push   %edx
  80202a:	50                   	push   %eax
  80202b:	68 9d 3a 80 00       	push   $0x803a9d
  802030:	e8 fd e5 ff ff       	call   800632 <cprintf>
  802035:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80203e:	a1 48 40 80 00       	mov    0x804048,%eax
  802043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802046:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204a:	74 07                	je     802053 <print_mem_block_lists+0x155>
  80204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204f:	8b 00                	mov    (%eax),%eax
  802051:	eb 05                	jmp    802058 <print_mem_block_lists+0x15a>
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
  802058:	a3 48 40 80 00       	mov    %eax,0x804048
  80205d:	a1 48 40 80 00       	mov    0x804048,%eax
  802062:	85 c0                	test   %eax,%eax
  802064:	75 8a                	jne    801ff0 <print_mem_block_lists+0xf2>
  802066:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206a:	75 84                	jne    801ff0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80206c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802070:	75 10                	jne    802082 <print_mem_block_lists+0x184>
  802072:	83 ec 0c             	sub    $0xc,%esp
  802075:	68 e8 3a 80 00       	push   $0x803ae8
  80207a:	e8 b3 e5 ff ff       	call   800632 <cprintf>
  80207f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802082:	83 ec 0c             	sub    $0xc,%esp
  802085:	68 5c 3a 80 00       	push   $0x803a5c
  80208a:	e8 a3 e5 ff ff       	call   800632 <cprintf>
  80208f:	83 c4 10             	add    $0x10,%esp

}
  802092:	90                   	nop
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80209b:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020a2:	00 00 00 
  8020a5:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020ac:	00 00 00 
  8020af:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020b6:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8020b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020c0:	e9 9e 00 00 00       	jmp    802163 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8020c5:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cd:	c1 e2 04             	shl    $0x4,%edx
  8020d0:	01 d0                	add    %edx,%eax
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	75 14                	jne    8020ea <initialize_MemBlocksList+0x55>
  8020d6:	83 ec 04             	sub    $0x4,%esp
  8020d9:	68 10 3b 80 00       	push   $0x803b10
  8020de:	6a 43                	push   $0x43
  8020e0:	68 33 3b 80 00       	push   $0x803b33
  8020e5:	e8 94 e2 ff ff       	call   80037e <_panic>
  8020ea:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f2:	c1 e2 04             	shl    $0x4,%edx
  8020f5:	01 d0                	add    %edx,%eax
  8020f7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020fd:	89 10                	mov    %edx,(%eax)
  8020ff:	8b 00                	mov    (%eax),%eax
  802101:	85 c0                	test   %eax,%eax
  802103:	74 18                	je     80211d <initialize_MemBlocksList+0x88>
  802105:	a1 48 41 80 00       	mov    0x804148,%eax
  80210a:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802110:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802113:	c1 e1 04             	shl    $0x4,%ecx
  802116:	01 ca                	add    %ecx,%edx
  802118:	89 50 04             	mov    %edx,0x4(%eax)
  80211b:	eb 12                	jmp    80212f <initialize_MemBlocksList+0x9a>
  80211d:	a1 50 40 80 00       	mov    0x804050,%eax
  802122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802125:	c1 e2 04             	shl    $0x4,%edx
  802128:	01 d0                	add    %edx,%eax
  80212a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80212f:	a1 50 40 80 00       	mov    0x804050,%eax
  802134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802137:	c1 e2 04             	shl    $0x4,%edx
  80213a:	01 d0                	add    %edx,%eax
  80213c:	a3 48 41 80 00       	mov    %eax,0x804148
  802141:	a1 50 40 80 00       	mov    0x804050,%eax
  802146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802149:	c1 e2 04             	shl    $0x4,%edx
  80214c:	01 d0                	add    %edx,%eax
  80214e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802155:	a1 54 41 80 00       	mov    0x804154,%eax
  80215a:	40                   	inc    %eax
  80215b:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802160:	ff 45 f4             	incl   -0xc(%ebp)
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	3b 45 08             	cmp    0x8(%ebp),%eax
  802169:	0f 82 56 ff ff ff    	jb     8020c5 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80216f:	90                   	nop
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802178:	a1 38 41 80 00       	mov    0x804138,%eax
  80217d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802180:	eb 18                	jmp    80219a <find_block+0x28>
	{
		if (ele->sva==va)
  802182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802185:	8b 40 08             	mov    0x8(%eax),%eax
  802188:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80218b:	75 05                	jne    802192 <find_block+0x20>
			return ele;
  80218d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802190:	eb 7b                	jmp    80220d <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802192:	a1 40 41 80 00       	mov    0x804140,%eax
  802197:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80219a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80219e:	74 07                	je     8021a7 <find_block+0x35>
  8021a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a3:	8b 00                	mov    (%eax),%eax
  8021a5:	eb 05                	jmp    8021ac <find_block+0x3a>
  8021a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ac:	a3 40 41 80 00       	mov    %eax,0x804140
  8021b1:	a1 40 41 80 00       	mov    0x804140,%eax
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	75 c8                	jne    802182 <find_block+0x10>
  8021ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021be:	75 c2                	jne    802182 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8021c0:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021c8:	eb 18                	jmp    8021e2 <find_block+0x70>
	{
		if (ele->sva==va)
  8021ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021cd:	8b 40 08             	mov    0x8(%eax),%eax
  8021d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021d3:	75 05                	jne    8021da <find_block+0x68>
					return ele;
  8021d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d8:	eb 33                	jmp    80220d <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8021da:	a1 48 40 80 00       	mov    0x804048,%eax
  8021df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021e6:	74 07                	je     8021ef <find_block+0x7d>
  8021e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021eb:	8b 00                	mov    (%eax),%eax
  8021ed:	eb 05                	jmp    8021f4 <find_block+0x82>
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f4:	a3 48 40 80 00       	mov    %eax,0x804048
  8021f9:	a1 48 40 80 00       	mov    0x804048,%eax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	75 c8                	jne    8021ca <find_block+0x58>
  802202:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802206:	75 c2                	jne    8021ca <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802208:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
  802212:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802215:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80221a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80221d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802221:	75 62                	jne    802285 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802223:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802227:	75 14                	jne    80223d <insert_sorted_allocList+0x2e>
  802229:	83 ec 04             	sub    $0x4,%esp
  80222c:	68 10 3b 80 00       	push   $0x803b10
  802231:	6a 69                	push   $0x69
  802233:	68 33 3b 80 00       	push   $0x803b33
  802238:	e8 41 e1 ff ff       	call   80037e <_panic>
  80223d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	89 10                	mov    %edx,(%eax)
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	8b 00                	mov    (%eax),%eax
  80224d:	85 c0                	test   %eax,%eax
  80224f:	74 0d                	je     80225e <insert_sorted_allocList+0x4f>
  802251:	a1 40 40 80 00       	mov    0x804040,%eax
  802256:	8b 55 08             	mov    0x8(%ebp),%edx
  802259:	89 50 04             	mov    %edx,0x4(%eax)
  80225c:	eb 08                	jmp    802266 <insert_sorted_allocList+0x57>
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	a3 44 40 80 00       	mov    %eax,0x804044
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	a3 40 40 80 00       	mov    %eax,0x804040
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802278:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80227d:	40                   	inc    %eax
  80227e:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802283:	eb 72                	jmp    8022f7 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802285:	a1 40 40 80 00       	mov    0x804040,%eax
  80228a:	8b 50 08             	mov    0x8(%eax),%edx
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	8b 40 08             	mov    0x8(%eax),%eax
  802293:	39 c2                	cmp    %eax,%edx
  802295:	76 60                	jbe    8022f7 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229b:	75 14                	jne    8022b1 <insert_sorted_allocList+0xa2>
  80229d:	83 ec 04             	sub    $0x4,%esp
  8022a0:	68 10 3b 80 00       	push   $0x803b10
  8022a5:	6a 6d                	push   $0x6d
  8022a7:	68 33 3b 80 00       	push   $0x803b33
  8022ac:	e8 cd e0 ff ff       	call   80037e <_panic>
  8022b1:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	89 10                	mov    %edx,(%eax)
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	8b 00                	mov    (%eax),%eax
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	74 0d                	je     8022d2 <insert_sorted_allocList+0xc3>
  8022c5:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8022cd:	89 50 04             	mov    %edx,0x4(%eax)
  8022d0:	eb 08                	jmp    8022da <insert_sorted_allocList+0xcb>
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	a3 44 40 80 00       	mov    %eax,0x804044
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	a3 40 40 80 00       	mov    %eax,0x804040
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ec:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022f1:	40                   	inc    %eax
  8022f2:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8022f7:	a1 40 40 80 00       	mov    0x804040,%eax
  8022fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ff:	e9 b9 01 00 00       	jmp    8024bd <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	8b 50 08             	mov    0x8(%eax),%edx
  80230a:	a1 40 40 80 00       	mov    0x804040,%eax
  80230f:	8b 40 08             	mov    0x8(%eax),%eax
  802312:	39 c2                	cmp    %eax,%edx
  802314:	76 7c                	jbe    802392 <insert_sorted_allocList+0x183>
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	8b 50 08             	mov    0x8(%eax),%edx
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 40 08             	mov    0x8(%eax),%eax
  802322:	39 c2                	cmp    %eax,%edx
  802324:	73 6c                	jae    802392 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802326:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232a:	74 06                	je     802332 <insert_sorted_allocList+0x123>
  80232c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802330:	75 14                	jne    802346 <insert_sorted_allocList+0x137>
  802332:	83 ec 04             	sub    $0x4,%esp
  802335:	68 4c 3b 80 00       	push   $0x803b4c
  80233a:	6a 75                	push   $0x75
  80233c:	68 33 3b 80 00       	push   $0x803b33
  802341:	e8 38 e0 ff ff       	call   80037e <_panic>
  802346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802349:	8b 50 04             	mov    0x4(%eax),%edx
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	89 50 04             	mov    %edx,0x4(%eax)
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802358:	89 10                	mov    %edx,(%eax)
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	8b 40 04             	mov    0x4(%eax),%eax
  802360:	85 c0                	test   %eax,%eax
  802362:	74 0d                	je     802371 <insert_sorted_allocList+0x162>
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	8b 40 04             	mov    0x4(%eax),%eax
  80236a:	8b 55 08             	mov    0x8(%ebp),%edx
  80236d:	89 10                	mov    %edx,(%eax)
  80236f:	eb 08                	jmp    802379 <insert_sorted_allocList+0x16a>
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	a3 40 40 80 00       	mov    %eax,0x804040
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 55 08             	mov    0x8(%ebp),%edx
  80237f:	89 50 04             	mov    %edx,0x4(%eax)
  802382:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802387:	40                   	inc    %eax
  802388:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  80238d:	e9 59 01 00 00       	jmp    8024eb <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	8b 50 08             	mov    0x8(%eax),%edx
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 40 08             	mov    0x8(%eax),%eax
  80239e:	39 c2                	cmp    %eax,%edx
  8023a0:	0f 86 98 00 00 00    	jbe    80243e <insert_sorted_allocList+0x22f>
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	8b 50 08             	mov    0x8(%eax),%edx
  8023ac:	a1 44 40 80 00       	mov    0x804044,%eax
  8023b1:	8b 40 08             	mov    0x8(%eax),%eax
  8023b4:	39 c2                	cmp    %eax,%edx
  8023b6:	0f 83 82 00 00 00    	jae    80243e <insert_sorted_allocList+0x22f>
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	8b 50 08             	mov    0x8(%eax),%edx
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 00                	mov    (%eax),%eax
  8023c7:	8b 40 08             	mov    0x8(%eax),%eax
  8023ca:	39 c2                	cmp    %eax,%edx
  8023cc:	73 70                	jae    80243e <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8023ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d2:	74 06                	je     8023da <insert_sorted_allocList+0x1cb>
  8023d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d8:	75 14                	jne    8023ee <insert_sorted_allocList+0x1df>
  8023da:	83 ec 04             	sub    $0x4,%esp
  8023dd:	68 84 3b 80 00       	push   $0x803b84
  8023e2:	6a 7c                	push   $0x7c
  8023e4:	68 33 3b 80 00       	push   $0x803b33
  8023e9:	e8 90 df ff ff       	call   80037e <_panic>
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	8b 10                	mov    (%eax),%edx
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	89 10                	mov    %edx,(%eax)
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	8b 00                	mov    (%eax),%eax
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	74 0b                	je     80240c <insert_sorted_allocList+0x1fd>
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	8b 00                	mov    (%eax),%eax
  802406:	8b 55 08             	mov    0x8(%ebp),%edx
  802409:	89 50 04             	mov    %edx,0x4(%eax)
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	8b 55 08             	mov    0x8(%ebp),%edx
  802412:	89 10                	mov    %edx,(%eax)
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241a:	89 50 04             	mov    %edx,0x4(%eax)
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	8b 00                	mov    (%eax),%eax
  802422:	85 c0                	test   %eax,%eax
  802424:	75 08                	jne    80242e <insert_sorted_allocList+0x21f>
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	a3 44 40 80 00       	mov    %eax,0x804044
  80242e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802433:	40                   	inc    %eax
  802434:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802439:	e9 ad 00 00 00       	jmp    8024eb <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	8b 50 08             	mov    0x8(%eax),%edx
  802444:	a1 44 40 80 00       	mov    0x804044,%eax
  802449:	8b 40 08             	mov    0x8(%eax),%eax
  80244c:	39 c2                	cmp    %eax,%edx
  80244e:	76 65                	jbe    8024b5 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802450:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802454:	75 17                	jne    80246d <insert_sorted_allocList+0x25e>
  802456:	83 ec 04             	sub    $0x4,%esp
  802459:	68 b8 3b 80 00       	push   $0x803bb8
  80245e:	68 80 00 00 00       	push   $0x80
  802463:	68 33 3b 80 00       	push   $0x803b33
  802468:	e8 11 df ff ff       	call   80037e <_panic>
  80246d:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	89 50 04             	mov    %edx,0x4(%eax)
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	8b 40 04             	mov    0x4(%eax),%eax
  80247f:	85 c0                	test   %eax,%eax
  802481:	74 0c                	je     80248f <insert_sorted_allocList+0x280>
  802483:	a1 44 40 80 00       	mov    0x804044,%eax
  802488:	8b 55 08             	mov    0x8(%ebp),%edx
  80248b:	89 10                	mov    %edx,(%eax)
  80248d:	eb 08                	jmp    802497 <insert_sorted_allocList+0x288>
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	a3 40 40 80 00       	mov    %eax,0x804040
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	a3 44 40 80 00       	mov    %eax,0x804044
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024ad:	40                   	inc    %eax
  8024ae:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8024b3:	eb 36                	jmp    8024eb <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8024b5:	a1 48 40 80 00       	mov    0x804048,%eax
  8024ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c1:	74 07                	je     8024ca <insert_sorted_allocList+0x2bb>
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 00                	mov    (%eax),%eax
  8024c8:	eb 05                	jmp    8024cf <insert_sorted_allocList+0x2c0>
  8024ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cf:	a3 48 40 80 00       	mov    %eax,0x804048
  8024d4:	a1 48 40 80 00       	mov    0x804048,%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	0f 85 23 fe ff ff    	jne    802304 <insert_sorted_allocList+0xf5>
  8024e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e5:	0f 85 19 fe ff ff    	jne    802304 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8024eb:	90                   	nop
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
  8024f1:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8024f4:	a1 38 41 80 00       	mov    0x804138,%eax
  8024f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024fc:	e9 7c 01 00 00       	jmp    80267d <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 40 0c             	mov    0xc(%eax),%eax
  802507:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250a:	0f 85 90 00 00 00    	jne    8025a0 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251a:	75 17                	jne    802533 <alloc_block_FF+0x45>
  80251c:	83 ec 04             	sub    $0x4,%esp
  80251f:	68 db 3b 80 00       	push   $0x803bdb
  802524:	68 ba 00 00 00       	push   $0xba
  802529:	68 33 3b 80 00       	push   $0x803b33
  80252e:	e8 4b de ff ff       	call   80037e <_panic>
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 00                	mov    (%eax),%eax
  802538:	85 c0                	test   %eax,%eax
  80253a:	74 10                	je     80254c <alloc_block_FF+0x5e>
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 00                	mov    (%eax),%eax
  802541:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802544:	8b 52 04             	mov    0x4(%edx),%edx
  802547:	89 50 04             	mov    %edx,0x4(%eax)
  80254a:	eb 0b                	jmp    802557 <alloc_block_FF+0x69>
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 40 04             	mov    0x4(%eax),%eax
  802552:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 40 04             	mov    0x4(%eax),%eax
  80255d:	85 c0                	test   %eax,%eax
  80255f:	74 0f                	je     802570 <alloc_block_FF+0x82>
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 04             	mov    0x4(%eax),%eax
  802567:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256a:	8b 12                	mov    (%edx),%edx
  80256c:	89 10                	mov    %edx,(%eax)
  80256e:	eb 0a                	jmp    80257a <alloc_block_FF+0x8c>
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 00                	mov    (%eax),%eax
  802575:	a3 38 41 80 00       	mov    %eax,0x804138
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80258d:	a1 44 41 80 00       	mov    0x804144,%eax
  802592:	48                   	dec    %eax
  802593:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  802598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259b:	e9 10 01 00 00       	jmp    8026b0 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a9:	0f 86 c6 00 00 00    	jbe    802675 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8025af:	a1 48 41 80 00       	mov    0x804148,%eax
  8025b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8025b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025bb:	75 17                	jne    8025d4 <alloc_block_FF+0xe6>
  8025bd:	83 ec 04             	sub    $0x4,%esp
  8025c0:	68 db 3b 80 00       	push   $0x803bdb
  8025c5:	68 c2 00 00 00       	push   $0xc2
  8025ca:	68 33 3b 80 00       	push   $0x803b33
  8025cf:	e8 aa dd ff ff       	call   80037e <_panic>
  8025d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d7:	8b 00                	mov    (%eax),%eax
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	74 10                	je     8025ed <alloc_block_FF+0xff>
  8025dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e0:	8b 00                	mov    (%eax),%eax
  8025e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e5:	8b 52 04             	mov    0x4(%edx),%edx
  8025e8:	89 50 04             	mov    %edx,0x4(%eax)
  8025eb:	eb 0b                	jmp    8025f8 <alloc_block_FF+0x10a>
  8025ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f0:	8b 40 04             	mov    0x4(%eax),%eax
  8025f3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fb:	8b 40 04             	mov    0x4(%eax),%eax
  8025fe:	85 c0                	test   %eax,%eax
  802600:	74 0f                	je     802611 <alloc_block_FF+0x123>
  802602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802605:	8b 40 04             	mov    0x4(%eax),%eax
  802608:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80260b:	8b 12                	mov    (%edx),%edx
  80260d:	89 10                	mov    %edx,(%eax)
  80260f:	eb 0a                	jmp    80261b <alloc_block_FF+0x12d>
  802611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802614:	8b 00                	mov    (%eax),%eax
  802616:	a3 48 41 80 00       	mov    %eax,0x804148
  80261b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802627:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262e:	a1 54 41 80 00       	mov    0x804154,%eax
  802633:	48                   	dec    %eax
  802634:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 50 08             	mov    0x8(%eax),%edx
  80263f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802642:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802648:	8b 55 08             	mov    0x8(%ebp),%edx
  80264b:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 40 0c             	mov    0xc(%eax),%eax
  802654:	2b 45 08             	sub    0x8(%ebp),%eax
  802657:	89 c2                	mov    %eax,%edx
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 50 08             	mov    0x8(%eax),%edx
  802665:	8b 45 08             	mov    0x8(%ebp),%eax
  802668:	01 c2                	add    %eax,%edx
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802673:	eb 3b                	jmp    8026b0 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802675:	a1 40 41 80 00       	mov    0x804140,%eax
  80267a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802681:	74 07                	je     80268a <alloc_block_FF+0x19c>
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 00                	mov    (%eax),%eax
  802688:	eb 05                	jmp    80268f <alloc_block_FF+0x1a1>
  80268a:	b8 00 00 00 00       	mov    $0x0,%eax
  80268f:	a3 40 41 80 00       	mov    %eax,0x804140
  802694:	a1 40 41 80 00       	mov    0x804140,%eax
  802699:	85 c0                	test   %eax,%eax
  80269b:	0f 85 60 fe ff ff    	jne    802501 <alloc_block_FF+0x13>
  8026a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a5:	0f 85 56 fe ff ff    	jne    802501 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	c9                   	leave  
  8026b1:	c3                   	ret    

008026b2 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8026b2:	55                   	push   %ebp
  8026b3:	89 e5                	mov    %esp,%ebp
  8026b5:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8026b8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026bf:	a1 38 41 80 00       	mov    0x804138,%eax
  8026c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c7:	eb 3a                	jmp    802703 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d2:	72 27                	jb     8026fb <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8026d4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8026d8:	75 0b                	jne    8026e5 <alloc_block_BF+0x33>
					best_size= element->size;
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026e3:	eb 16                	jmp    8026fb <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 50 0c             	mov    0xc(%eax),%edx
  8026eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ee:	39 c2                	cmp    %eax,%edx
  8026f0:	77 09                	ja     8026fb <alloc_block_BF+0x49>
					best_size=element->size;
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f8:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026fb:	a1 40 41 80 00       	mov    0x804140,%eax
  802700:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802707:	74 07                	je     802710 <alloc_block_BF+0x5e>
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 00                	mov    (%eax),%eax
  80270e:	eb 05                	jmp    802715 <alloc_block_BF+0x63>
  802710:	b8 00 00 00 00       	mov    $0x0,%eax
  802715:	a3 40 41 80 00       	mov    %eax,0x804140
  80271a:	a1 40 41 80 00       	mov    0x804140,%eax
  80271f:	85 c0                	test   %eax,%eax
  802721:	75 a6                	jne    8026c9 <alloc_block_BF+0x17>
  802723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802727:	75 a0                	jne    8026c9 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802729:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80272d:	0f 84 d3 01 00 00    	je     802906 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802733:	a1 38 41 80 00       	mov    0x804138,%eax
  802738:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273b:	e9 98 01 00 00       	jmp    8028d8 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802740:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802743:	3b 45 08             	cmp    0x8(%ebp),%eax
  802746:	0f 86 da 00 00 00    	jbe    802826 <alloc_block_BF+0x174>
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 50 0c             	mov    0xc(%eax),%edx
  802752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802755:	39 c2                	cmp    %eax,%edx
  802757:	0f 85 c9 00 00 00    	jne    802826 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  80275d:	a1 48 41 80 00       	mov    0x804148,%eax
  802762:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802765:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802769:	75 17                	jne    802782 <alloc_block_BF+0xd0>
  80276b:	83 ec 04             	sub    $0x4,%esp
  80276e:	68 db 3b 80 00       	push   $0x803bdb
  802773:	68 ea 00 00 00       	push   $0xea
  802778:	68 33 3b 80 00       	push   $0x803b33
  80277d:	e8 fc db ff ff       	call   80037e <_panic>
  802782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	74 10                	je     80279b <alloc_block_BF+0xe9>
  80278b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278e:	8b 00                	mov    (%eax),%eax
  802790:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802793:	8b 52 04             	mov    0x4(%edx),%edx
  802796:	89 50 04             	mov    %edx,0x4(%eax)
  802799:	eb 0b                	jmp    8027a6 <alloc_block_BF+0xf4>
  80279b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279e:	8b 40 04             	mov    0x4(%eax),%eax
  8027a1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	74 0f                	je     8027bf <alloc_block_BF+0x10d>
  8027b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b3:	8b 40 04             	mov    0x4(%eax),%eax
  8027b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b9:	8b 12                	mov    (%edx),%edx
  8027bb:	89 10                	mov    %edx,(%eax)
  8027bd:	eb 0a                	jmp    8027c9 <alloc_block_BF+0x117>
  8027bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	a3 48 41 80 00       	mov    %eax,0x804148
  8027c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027dc:	a1 54 41 80 00       	mov    0x804154,%eax
  8027e1:	48                   	dec    %eax
  8027e2:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 50 08             	mov    0x8(%eax),%edx
  8027ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f0:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8027f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f9:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802802:	2b 45 08             	sub    0x8(%ebp),%eax
  802805:	89 c2                	mov    %eax,%edx
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 50 08             	mov    0x8(%eax),%edx
  802813:	8b 45 08             	mov    0x8(%ebp),%eax
  802816:	01 c2                	add    %eax,%edx
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  80281e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802821:	e9 e5 00 00 00       	jmp    80290b <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 50 0c             	mov    0xc(%eax),%edx
  80282c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282f:	39 c2                	cmp    %eax,%edx
  802831:	0f 85 99 00 00 00    	jne    8028d0 <alloc_block_BF+0x21e>
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283d:	0f 85 8d 00 00 00    	jne    8028d0 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802849:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284d:	75 17                	jne    802866 <alloc_block_BF+0x1b4>
  80284f:	83 ec 04             	sub    $0x4,%esp
  802852:	68 db 3b 80 00       	push   $0x803bdb
  802857:	68 f7 00 00 00       	push   $0xf7
  80285c:	68 33 3b 80 00       	push   $0x803b33
  802861:	e8 18 db ff ff       	call   80037e <_panic>
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	85 c0                	test   %eax,%eax
  80286d:	74 10                	je     80287f <alloc_block_BF+0x1cd>
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 00                	mov    (%eax),%eax
  802874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802877:	8b 52 04             	mov    0x4(%edx),%edx
  80287a:	89 50 04             	mov    %edx,0x4(%eax)
  80287d:	eb 0b                	jmp    80288a <alloc_block_BF+0x1d8>
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 04             	mov    0x4(%eax),%eax
  802885:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 40 04             	mov    0x4(%eax),%eax
  802890:	85 c0                	test   %eax,%eax
  802892:	74 0f                	je     8028a3 <alloc_block_BF+0x1f1>
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 40 04             	mov    0x4(%eax),%eax
  80289a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289d:	8b 12                	mov    (%edx),%edx
  80289f:	89 10                	mov    %edx,(%eax)
  8028a1:	eb 0a                	jmp    8028ad <alloc_block_BF+0x1fb>
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 00                	mov    (%eax),%eax
  8028a8:	a3 38 41 80 00       	mov    %eax,0x804138
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c0:	a1 44 41 80 00       	mov    0x804144,%eax
  8028c5:	48                   	dec    %eax
  8028c6:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8028cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ce:	eb 3b                	jmp    80290b <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8028d0:	a1 40 41 80 00       	mov    0x804140,%eax
  8028d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028dc:	74 07                	je     8028e5 <alloc_block_BF+0x233>
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	8b 00                	mov    (%eax),%eax
  8028e3:	eb 05                	jmp    8028ea <alloc_block_BF+0x238>
  8028e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ea:	a3 40 41 80 00       	mov    %eax,0x804140
  8028ef:	a1 40 41 80 00       	mov    0x804140,%eax
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	0f 85 44 fe ff ff    	jne    802740 <alloc_block_BF+0x8e>
  8028fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802900:	0f 85 3a fe ff ff    	jne    802740 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802906:	b8 00 00 00 00       	mov    $0x0,%eax
  80290b:	c9                   	leave  
  80290c:	c3                   	ret    

0080290d <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80290d:	55                   	push   %ebp
  80290e:	89 e5                	mov    %esp,%ebp
  802910:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802913:	83 ec 04             	sub    $0x4,%esp
  802916:	68 fc 3b 80 00       	push   $0x803bfc
  80291b:	68 04 01 00 00       	push   $0x104
  802920:	68 33 3b 80 00       	push   $0x803b33
  802925:	e8 54 da ff ff       	call   80037e <_panic>

0080292a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80292a:	55                   	push   %ebp
  80292b:	89 e5                	mov    %esp,%ebp
  80292d:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802930:	a1 38 41 80 00       	mov    0x804138,%eax
  802935:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802938:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80293d:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802940:	a1 38 41 80 00       	mov    0x804138,%eax
  802945:	85 c0                	test   %eax,%eax
  802947:	75 68                	jne    8029b1 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802949:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80294d:	75 17                	jne    802966 <insert_sorted_with_merge_freeList+0x3c>
  80294f:	83 ec 04             	sub    $0x4,%esp
  802952:	68 10 3b 80 00       	push   $0x803b10
  802957:	68 14 01 00 00       	push   $0x114
  80295c:	68 33 3b 80 00       	push   $0x803b33
  802961:	e8 18 da ff ff       	call   80037e <_panic>
  802966:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80296c:	8b 45 08             	mov    0x8(%ebp),%eax
  80296f:	89 10                	mov    %edx,(%eax)
  802971:	8b 45 08             	mov    0x8(%ebp),%eax
  802974:	8b 00                	mov    (%eax),%eax
  802976:	85 c0                	test   %eax,%eax
  802978:	74 0d                	je     802987 <insert_sorted_with_merge_freeList+0x5d>
  80297a:	a1 38 41 80 00       	mov    0x804138,%eax
  80297f:	8b 55 08             	mov    0x8(%ebp),%edx
  802982:	89 50 04             	mov    %edx,0x4(%eax)
  802985:	eb 08                	jmp    80298f <insert_sorted_with_merge_freeList+0x65>
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	a3 38 41 80 00       	mov    %eax,0x804138
  802997:	8b 45 08             	mov    0x8(%ebp),%eax
  80299a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a1:	a1 44 41 80 00       	mov    0x804144,%eax
  8029a6:	40                   	inc    %eax
  8029a7:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8029ac:	e9 d2 06 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	8b 50 08             	mov    0x8(%eax),%edx
  8029b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ba:	8b 40 08             	mov    0x8(%eax),%eax
  8029bd:	39 c2                	cmp    %eax,%edx
  8029bf:	0f 83 22 01 00 00    	jae    802ae7 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8029c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c8:	8b 50 08             	mov    0x8(%eax),%edx
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d1:	01 c2                	add    %eax,%edx
  8029d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d6:	8b 40 08             	mov    0x8(%eax),%eax
  8029d9:	39 c2                	cmp    %eax,%edx
  8029db:	0f 85 9e 00 00 00    	jne    802a7f <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	8b 50 08             	mov    0x8(%eax),%edx
  8029e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ea:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8029ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f9:	01 c2                	add    %eax,%edx
  8029fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fe:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	8b 50 08             	mov    0x8(%eax),%edx
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a1b:	75 17                	jne    802a34 <insert_sorted_with_merge_freeList+0x10a>
  802a1d:	83 ec 04             	sub    $0x4,%esp
  802a20:	68 10 3b 80 00       	push   $0x803b10
  802a25:	68 21 01 00 00       	push   $0x121
  802a2a:	68 33 3b 80 00       	push   $0x803b33
  802a2f:	e8 4a d9 ff ff       	call   80037e <_panic>
  802a34:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	89 10                	mov    %edx,(%eax)
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	8b 00                	mov    (%eax),%eax
  802a44:	85 c0                	test   %eax,%eax
  802a46:	74 0d                	je     802a55 <insert_sorted_with_merge_freeList+0x12b>
  802a48:	a1 48 41 80 00       	mov    0x804148,%eax
  802a4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a50:	89 50 04             	mov    %edx,0x4(%eax)
  802a53:	eb 08                	jmp    802a5d <insert_sorted_with_merge_freeList+0x133>
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	a3 48 41 80 00       	mov    %eax,0x804148
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6f:	a1 54 41 80 00       	mov    0x804154,%eax
  802a74:	40                   	inc    %eax
  802a75:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802a7a:	e9 04 06 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a83:	75 17                	jne    802a9c <insert_sorted_with_merge_freeList+0x172>
  802a85:	83 ec 04             	sub    $0x4,%esp
  802a88:	68 10 3b 80 00       	push   $0x803b10
  802a8d:	68 26 01 00 00       	push   $0x126
  802a92:	68 33 3b 80 00       	push   $0x803b33
  802a97:	e8 e2 d8 ff ff       	call   80037e <_panic>
  802a9c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	89 10                	mov    %edx,(%eax)
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 0d                	je     802abd <insert_sorted_with_merge_freeList+0x193>
  802ab0:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab8:	89 50 04             	mov    %edx,0x4(%eax)
  802abb:	eb 08                	jmp    802ac5 <insert_sorted_with_merge_freeList+0x19b>
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	a3 38 41 80 00       	mov    %eax,0x804138
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad7:	a1 44 41 80 00       	mov    0x804144,%eax
  802adc:	40                   	inc    %eax
  802add:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802ae2:	e9 9c 05 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	8b 50 08             	mov    0x8(%eax),%edx
  802aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af0:	8b 40 08             	mov    0x8(%eax),%eax
  802af3:	39 c2                	cmp    %eax,%edx
  802af5:	0f 86 16 01 00 00    	jbe    802c11 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afe:	8b 50 08             	mov    0x8(%eax),%edx
  802b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b04:	8b 40 0c             	mov    0xc(%eax),%eax
  802b07:	01 c2                	add    %eax,%edx
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	8b 40 08             	mov    0x8(%eax),%eax
  802b0f:	39 c2                	cmp    %eax,%edx
  802b11:	0f 85 92 00 00 00    	jne    802ba9 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1a:	8b 50 0c             	mov    0xc(%eax),%edx
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	8b 40 0c             	mov    0xc(%eax),%eax
  802b23:	01 c2                	add    %eax,%edx
  802b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b28:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	8b 50 08             	mov    0x8(%eax),%edx
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b45:	75 17                	jne    802b5e <insert_sorted_with_merge_freeList+0x234>
  802b47:	83 ec 04             	sub    $0x4,%esp
  802b4a:	68 10 3b 80 00       	push   $0x803b10
  802b4f:	68 31 01 00 00       	push   $0x131
  802b54:	68 33 3b 80 00       	push   $0x803b33
  802b59:	e8 20 d8 ff ff       	call   80037e <_panic>
  802b5e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	89 10                	mov    %edx,(%eax)
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	74 0d                	je     802b7f <insert_sorted_with_merge_freeList+0x255>
  802b72:	a1 48 41 80 00       	mov    0x804148,%eax
  802b77:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7a:	89 50 04             	mov    %edx,0x4(%eax)
  802b7d:	eb 08                	jmp    802b87 <insert_sorted_with_merge_freeList+0x25d>
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	a3 48 41 80 00       	mov    %eax,0x804148
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b99:	a1 54 41 80 00       	mov    0x804154,%eax
  802b9e:	40                   	inc    %eax
  802b9f:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802ba4:	e9 da 04 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802ba9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bad:	75 17                	jne    802bc6 <insert_sorted_with_merge_freeList+0x29c>
  802baf:	83 ec 04             	sub    $0x4,%esp
  802bb2:	68 b8 3b 80 00       	push   $0x803bb8
  802bb7:	68 37 01 00 00       	push   $0x137
  802bbc:	68 33 3b 80 00       	push   $0x803b33
  802bc1:	e8 b8 d7 ff ff       	call   80037e <_panic>
  802bc6:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcf:	89 50 04             	mov    %edx,0x4(%eax)
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	8b 40 04             	mov    0x4(%eax),%eax
  802bd8:	85 c0                	test   %eax,%eax
  802bda:	74 0c                	je     802be8 <insert_sorted_with_merge_freeList+0x2be>
  802bdc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802be1:	8b 55 08             	mov    0x8(%ebp),%edx
  802be4:	89 10                	mov    %edx,(%eax)
  802be6:	eb 08                	jmp    802bf0 <insert_sorted_with_merge_freeList+0x2c6>
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	a3 38 41 80 00       	mov    %eax,0x804138
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c01:	a1 44 41 80 00       	mov    0x804144,%eax
  802c06:	40                   	inc    %eax
  802c07:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802c0c:	e9 72 04 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802c11:	a1 38 41 80 00       	mov    0x804138,%eax
  802c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c19:	e9 35 04 00 00       	jmp    803053 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	8b 00                	mov    (%eax),%eax
  802c23:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	8b 50 08             	mov    0x8(%eax),%edx
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 40 08             	mov    0x8(%eax),%eax
  802c32:	39 c2                	cmp    %eax,%edx
  802c34:	0f 86 11 04 00 00    	jbe    80304b <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 50 08             	mov    0x8(%eax),%edx
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 40 0c             	mov    0xc(%eax),%eax
  802c46:	01 c2                	add    %eax,%edx
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	8b 40 08             	mov    0x8(%eax),%eax
  802c4e:	39 c2                	cmp    %eax,%edx
  802c50:	0f 83 8b 00 00 00    	jae    802ce1 <insert_sorted_with_merge_freeList+0x3b7>
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	8b 50 08             	mov    0x8(%eax),%edx
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c62:	01 c2                	add    %eax,%edx
  802c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c67:	8b 40 08             	mov    0x8(%eax),%eax
  802c6a:	39 c2                	cmp    %eax,%edx
  802c6c:	73 73                	jae    802ce1 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802c6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c72:	74 06                	je     802c7a <insert_sorted_with_merge_freeList+0x350>
  802c74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c78:	75 17                	jne    802c91 <insert_sorted_with_merge_freeList+0x367>
  802c7a:	83 ec 04             	sub    $0x4,%esp
  802c7d:	68 84 3b 80 00       	push   $0x803b84
  802c82:	68 48 01 00 00       	push   $0x148
  802c87:	68 33 3b 80 00       	push   $0x803b33
  802c8c:	e8 ed d6 ff ff       	call   80037e <_panic>
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 10                	mov    (%eax),%edx
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	89 10                	mov    %edx,(%eax)
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	8b 00                	mov    (%eax),%eax
  802ca0:	85 c0                	test   %eax,%eax
  802ca2:	74 0b                	je     802caf <insert_sorted_with_merge_freeList+0x385>
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 00                	mov    (%eax),%eax
  802ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cac:	89 50 04             	mov    %edx,0x4(%eax)
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb5:	89 10                	mov    %edx,(%eax)
  802cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbd:	89 50 04             	mov    %edx,0x4(%eax)
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	8b 00                	mov    (%eax),%eax
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	75 08                	jne    802cd1 <insert_sorted_with_merge_freeList+0x3a7>
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cd1:	a1 44 41 80 00       	mov    0x804144,%eax
  802cd6:	40                   	inc    %eax
  802cd7:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802cdc:	e9 a2 03 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	8b 50 08             	mov    0x8(%eax),%edx
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	8b 40 0c             	mov    0xc(%eax),%eax
  802ced:	01 c2                	add    %eax,%edx
  802cef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf2:	8b 40 08             	mov    0x8(%eax),%eax
  802cf5:	39 c2                	cmp    %eax,%edx
  802cf7:	0f 83 ae 00 00 00    	jae    802dab <insert_sorted_with_merge_freeList+0x481>
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	8b 50 08             	mov    0x8(%eax),%edx
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 48 08             	mov    0x8(%eax),%ecx
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0f:	01 c8                	add    %ecx,%eax
  802d11:	39 c2                	cmp    %eax,%edx
  802d13:	0f 85 92 00 00 00    	jne    802dab <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 50 0c             	mov    0xc(%eax),%edx
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	8b 40 0c             	mov    0xc(%eax),%eax
  802d25:	01 c2                	add    %eax,%edx
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	8b 50 08             	mov    0x8(%eax),%edx
  802d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d40:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d47:	75 17                	jne    802d60 <insert_sorted_with_merge_freeList+0x436>
  802d49:	83 ec 04             	sub    $0x4,%esp
  802d4c:	68 10 3b 80 00       	push   $0x803b10
  802d51:	68 51 01 00 00       	push   $0x151
  802d56:	68 33 3b 80 00       	push   $0x803b33
  802d5b:	e8 1e d6 ff ff       	call   80037e <_panic>
  802d60:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	89 10                	mov    %edx,(%eax)
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	85 c0                	test   %eax,%eax
  802d72:	74 0d                	je     802d81 <insert_sorted_with_merge_freeList+0x457>
  802d74:	a1 48 41 80 00       	mov    0x804148,%eax
  802d79:	8b 55 08             	mov    0x8(%ebp),%edx
  802d7c:	89 50 04             	mov    %edx,0x4(%eax)
  802d7f:	eb 08                	jmp    802d89 <insert_sorted_with_merge_freeList+0x45f>
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	a3 48 41 80 00       	mov    %eax,0x804148
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9b:	a1 54 41 80 00       	mov    0x804154,%eax
  802da0:	40                   	inc    %eax
  802da1:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802da6:	e9 d8 02 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	8b 50 08             	mov    0x8(%eax),%edx
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	8b 40 0c             	mov    0xc(%eax),%eax
  802db7:	01 c2                	add    %eax,%edx
  802db9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbc:	8b 40 08             	mov    0x8(%eax),%eax
  802dbf:	39 c2                	cmp    %eax,%edx
  802dc1:	0f 85 ba 00 00 00    	jne    802e81 <insert_sorted_with_merge_freeList+0x557>
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	8b 50 08             	mov    0x8(%eax),%edx
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	8b 48 08             	mov    0x8(%eax),%ecx
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd9:	01 c8                	add    %ecx,%eax
  802ddb:	39 c2                	cmp    %eax,%edx
  802ddd:	0f 86 9e 00 00 00    	jbe    802e81 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802de3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de6:	8b 50 0c             	mov    0xc(%eax),%edx
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	8b 40 0c             	mov    0xc(%eax),%eax
  802def:	01 c2                	add    %eax,%edx
  802df1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df4:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	8b 50 08             	mov    0x8(%eax),%edx
  802dfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e00:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	8b 50 08             	mov    0x8(%eax),%edx
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1d:	75 17                	jne    802e36 <insert_sorted_with_merge_freeList+0x50c>
  802e1f:	83 ec 04             	sub    $0x4,%esp
  802e22:	68 10 3b 80 00       	push   $0x803b10
  802e27:	68 5b 01 00 00       	push   $0x15b
  802e2c:	68 33 3b 80 00       	push   $0x803b33
  802e31:	e8 48 d5 ff ff       	call   80037e <_panic>
  802e36:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3f:	89 10                	mov    %edx,(%eax)
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	8b 00                	mov    (%eax),%eax
  802e46:	85 c0                	test   %eax,%eax
  802e48:	74 0d                	je     802e57 <insert_sorted_with_merge_freeList+0x52d>
  802e4a:	a1 48 41 80 00       	mov    0x804148,%eax
  802e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e52:	89 50 04             	mov    %edx,0x4(%eax)
  802e55:	eb 08                	jmp    802e5f <insert_sorted_with_merge_freeList+0x535>
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	a3 48 41 80 00       	mov    %eax,0x804148
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e71:	a1 54 41 80 00       	mov    0x804154,%eax
  802e76:	40                   	inc    %eax
  802e77:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802e7c:	e9 02 02 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	8b 50 08             	mov    0x8(%eax),%edx
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8d:	01 c2                	add    %eax,%edx
  802e8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e92:	8b 40 08             	mov    0x8(%eax),%eax
  802e95:	39 c2                	cmp    %eax,%edx
  802e97:	0f 85 ae 01 00 00    	jne    80304b <insert_sorted_with_merge_freeList+0x721>
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	8b 50 08             	mov    0x8(%eax),%edx
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 48 08             	mov    0x8(%eax),%ecx
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 40 0c             	mov    0xc(%eax),%eax
  802eaf:	01 c8                	add    %ecx,%eax
  802eb1:	39 c2                	cmp    %eax,%edx
  802eb3:	0f 85 92 01 00 00    	jne    80304b <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 50 0c             	mov    0xc(%eax),%edx
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec5:	01 c2                	add    %eax,%edx
  802ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eca:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecd:	01 c2                	add    %eax,%edx
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	8b 50 08             	mov    0x8(%eax),%edx
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef8:	8b 50 08             	mov    0x8(%eax),%edx
  802efb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efe:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802f01:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f05:	75 17                	jne    802f1e <insert_sorted_with_merge_freeList+0x5f4>
  802f07:	83 ec 04             	sub    $0x4,%esp
  802f0a:	68 db 3b 80 00       	push   $0x803bdb
  802f0f:	68 63 01 00 00       	push   $0x163
  802f14:	68 33 3b 80 00       	push   $0x803b33
  802f19:	e8 60 d4 ff ff       	call   80037e <_panic>
  802f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f21:	8b 00                	mov    (%eax),%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	74 10                	je     802f37 <insert_sorted_with_merge_freeList+0x60d>
  802f27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2a:	8b 00                	mov    (%eax),%eax
  802f2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f2f:	8b 52 04             	mov    0x4(%edx),%edx
  802f32:	89 50 04             	mov    %edx,0x4(%eax)
  802f35:	eb 0b                	jmp    802f42 <insert_sorted_with_merge_freeList+0x618>
  802f37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3a:	8b 40 04             	mov    0x4(%eax),%eax
  802f3d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f45:	8b 40 04             	mov    0x4(%eax),%eax
  802f48:	85 c0                	test   %eax,%eax
  802f4a:	74 0f                	je     802f5b <insert_sorted_with_merge_freeList+0x631>
  802f4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4f:	8b 40 04             	mov    0x4(%eax),%eax
  802f52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f55:	8b 12                	mov    (%edx),%edx
  802f57:	89 10                	mov    %edx,(%eax)
  802f59:	eb 0a                	jmp    802f65 <insert_sorted_with_merge_freeList+0x63b>
  802f5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5e:	8b 00                	mov    (%eax),%eax
  802f60:	a3 38 41 80 00       	mov    %eax,0x804138
  802f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f78:	a1 44 41 80 00       	mov    0x804144,%eax
  802f7d:	48                   	dec    %eax
  802f7e:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802f83:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f87:	75 17                	jne    802fa0 <insert_sorted_with_merge_freeList+0x676>
  802f89:	83 ec 04             	sub    $0x4,%esp
  802f8c:	68 10 3b 80 00       	push   $0x803b10
  802f91:	68 64 01 00 00       	push   $0x164
  802f96:	68 33 3b 80 00       	push   $0x803b33
  802f9b:	e8 de d3 ff ff       	call   80037e <_panic>
  802fa0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa9:	89 10                	mov    %edx,(%eax)
  802fab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fae:	8b 00                	mov    (%eax),%eax
  802fb0:	85 c0                	test   %eax,%eax
  802fb2:	74 0d                	je     802fc1 <insert_sorted_with_merge_freeList+0x697>
  802fb4:	a1 48 41 80 00       	mov    0x804148,%eax
  802fb9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fbc:	89 50 04             	mov    %edx,0x4(%eax)
  802fbf:	eb 08                	jmp    802fc9 <insert_sorted_with_merge_freeList+0x69f>
  802fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcc:	a3 48 41 80 00       	mov    %eax,0x804148
  802fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fdb:	a1 54 41 80 00       	mov    0x804154,%eax
  802fe0:	40                   	inc    %eax
  802fe1:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802fe6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fea:	75 17                	jne    803003 <insert_sorted_with_merge_freeList+0x6d9>
  802fec:	83 ec 04             	sub    $0x4,%esp
  802fef:	68 10 3b 80 00       	push   $0x803b10
  802ff4:	68 65 01 00 00       	push   $0x165
  802ff9:	68 33 3b 80 00       	push   $0x803b33
  802ffe:	e8 7b d3 ff ff       	call   80037e <_panic>
  803003:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	89 10                	mov    %edx,(%eax)
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	85 c0                	test   %eax,%eax
  803015:	74 0d                	je     803024 <insert_sorted_with_merge_freeList+0x6fa>
  803017:	a1 48 41 80 00       	mov    0x804148,%eax
  80301c:	8b 55 08             	mov    0x8(%ebp),%edx
  80301f:	89 50 04             	mov    %edx,0x4(%eax)
  803022:	eb 08                	jmp    80302c <insert_sorted_with_merge_freeList+0x702>
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	a3 48 41 80 00       	mov    %eax,0x804148
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303e:	a1 54 41 80 00       	mov    0x804154,%eax
  803043:	40                   	inc    %eax
  803044:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  803049:	eb 38                	jmp    803083 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80304b:	a1 40 41 80 00       	mov    0x804140,%eax
  803050:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803053:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803057:	74 07                	je     803060 <insert_sorted_with_merge_freeList+0x736>
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	eb 05                	jmp    803065 <insert_sorted_with_merge_freeList+0x73b>
  803060:	b8 00 00 00 00       	mov    $0x0,%eax
  803065:	a3 40 41 80 00       	mov    %eax,0x804140
  80306a:	a1 40 41 80 00       	mov    0x804140,%eax
  80306f:	85 c0                	test   %eax,%eax
  803071:	0f 85 a7 fb ff ff    	jne    802c1e <insert_sorted_with_merge_freeList+0x2f4>
  803077:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307b:	0f 85 9d fb ff ff    	jne    802c1e <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803081:	eb 00                	jmp    803083 <insert_sorted_with_merge_freeList+0x759>
  803083:	90                   	nop
  803084:	c9                   	leave  
  803085:	c3                   	ret    
  803086:	66 90                	xchg   %ax,%ax

00803088 <__udivdi3>:
  803088:	55                   	push   %ebp
  803089:	57                   	push   %edi
  80308a:	56                   	push   %esi
  80308b:	53                   	push   %ebx
  80308c:	83 ec 1c             	sub    $0x1c,%esp
  80308f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803093:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803097:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80309b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80309f:	89 ca                	mov    %ecx,%edx
  8030a1:	89 f8                	mov    %edi,%eax
  8030a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030a7:	85 f6                	test   %esi,%esi
  8030a9:	75 2d                	jne    8030d8 <__udivdi3+0x50>
  8030ab:	39 cf                	cmp    %ecx,%edi
  8030ad:	77 65                	ja     803114 <__udivdi3+0x8c>
  8030af:	89 fd                	mov    %edi,%ebp
  8030b1:	85 ff                	test   %edi,%edi
  8030b3:	75 0b                	jne    8030c0 <__udivdi3+0x38>
  8030b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ba:	31 d2                	xor    %edx,%edx
  8030bc:	f7 f7                	div    %edi
  8030be:	89 c5                	mov    %eax,%ebp
  8030c0:	31 d2                	xor    %edx,%edx
  8030c2:	89 c8                	mov    %ecx,%eax
  8030c4:	f7 f5                	div    %ebp
  8030c6:	89 c1                	mov    %eax,%ecx
  8030c8:	89 d8                	mov    %ebx,%eax
  8030ca:	f7 f5                	div    %ebp
  8030cc:	89 cf                	mov    %ecx,%edi
  8030ce:	89 fa                	mov    %edi,%edx
  8030d0:	83 c4 1c             	add    $0x1c,%esp
  8030d3:	5b                   	pop    %ebx
  8030d4:	5e                   	pop    %esi
  8030d5:	5f                   	pop    %edi
  8030d6:	5d                   	pop    %ebp
  8030d7:	c3                   	ret    
  8030d8:	39 ce                	cmp    %ecx,%esi
  8030da:	77 28                	ja     803104 <__udivdi3+0x7c>
  8030dc:	0f bd fe             	bsr    %esi,%edi
  8030df:	83 f7 1f             	xor    $0x1f,%edi
  8030e2:	75 40                	jne    803124 <__udivdi3+0x9c>
  8030e4:	39 ce                	cmp    %ecx,%esi
  8030e6:	72 0a                	jb     8030f2 <__udivdi3+0x6a>
  8030e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030ec:	0f 87 9e 00 00 00    	ja     803190 <__udivdi3+0x108>
  8030f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8030f7:	89 fa                	mov    %edi,%edx
  8030f9:	83 c4 1c             	add    $0x1c,%esp
  8030fc:	5b                   	pop    %ebx
  8030fd:	5e                   	pop    %esi
  8030fe:	5f                   	pop    %edi
  8030ff:	5d                   	pop    %ebp
  803100:	c3                   	ret    
  803101:	8d 76 00             	lea    0x0(%esi),%esi
  803104:	31 ff                	xor    %edi,%edi
  803106:	31 c0                	xor    %eax,%eax
  803108:	89 fa                	mov    %edi,%edx
  80310a:	83 c4 1c             	add    $0x1c,%esp
  80310d:	5b                   	pop    %ebx
  80310e:	5e                   	pop    %esi
  80310f:	5f                   	pop    %edi
  803110:	5d                   	pop    %ebp
  803111:	c3                   	ret    
  803112:	66 90                	xchg   %ax,%ax
  803114:	89 d8                	mov    %ebx,%eax
  803116:	f7 f7                	div    %edi
  803118:	31 ff                	xor    %edi,%edi
  80311a:	89 fa                	mov    %edi,%edx
  80311c:	83 c4 1c             	add    $0x1c,%esp
  80311f:	5b                   	pop    %ebx
  803120:	5e                   	pop    %esi
  803121:	5f                   	pop    %edi
  803122:	5d                   	pop    %ebp
  803123:	c3                   	ret    
  803124:	bd 20 00 00 00       	mov    $0x20,%ebp
  803129:	89 eb                	mov    %ebp,%ebx
  80312b:	29 fb                	sub    %edi,%ebx
  80312d:	89 f9                	mov    %edi,%ecx
  80312f:	d3 e6                	shl    %cl,%esi
  803131:	89 c5                	mov    %eax,%ebp
  803133:	88 d9                	mov    %bl,%cl
  803135:	d3 ed                	shr    %cl,%ebp
  803137:	89 e9                	mov    %ebp,%ecx
  803139:	09 f1                	or     %esi,%ecx
  80313b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80313f:	89 f9                	mov    %edi,%ecx
  803141:	d3 e0                	shl    %cl,%eax
  803143:	89 c5                	mov    %eax,%ebp
  803145:	89 d6                	mov    %edx,%esi
  803147:	88 d9                	mov    %bl,%cl
  803149:	d3 ee                	shr    %cl,%esi
  80314b:	89 f9                	mov    %edi,%ecx
  80314d:	d3 e2                	shl    %cl,%edx
  80314f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803153:	88 d9                	mov    %bl,%cl
  803155:	d3 e8                	shr    %cl,%eax
  803157:	09 c2                	or     %eax,%edx
  803159:	89 d0                	mov    %edx,%eax
  80315b:	89 f2                	mov    %esi,%edx
  80315d:	f7 74 24 0c          	divl   0xc(%esp)
  803161:	89 d6                	mov    %edx,%esi
  803163:	89 c3                	mov    %eax,%ebx
  803165:	f7 e5                	mul    %ebp
  803167:	39 d6                	cmp    %edx,%esi
  803169:	72 19                	jb     803184 <__udivdi3+0xfc>
  80316b:	74 0b                	je     803178 <__udivdi3+0xf0>
  80316d:	89 d8                	mov    %ebx,%eax
  80316f:	31 ff                	xor    %edi,%edi
  803171:	e9 58 ff ff ff       	jmp    8030ce <__udivdi3+0x46>
  803176:	66 90                	xchg   %ax,%ax
  803178:	8b 54 24 08          	mov    0x8(%esp),%edx
  80317c:	89 f9                	mov    %edi,%ecx
  80317e:	d3 e2                	shl    %cl,%edx
  803180:	39 c2                	cmp    %eax,%edx
  803182:	73 e9                	jae    80316d <__udivdi3+0xe5>
  803184:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803187:	31 ff                	xor    %edi,%edi
  803189:	e9 40 ff ff ff       	jmp    8030ce <__udivdi3+0x46>
  80318e:	66 90                	xchg   %ax,%ax
  803190:	31 c0                	xor    %eax,%eax
  803192:	e9 37 ff ff ff       	jmp    8030ce <__udivdi3+0x46>
  803197:	90                   	nop

00803198 <__umoddi3>:
  803198:	55                   	push   %ebp
  803199:	57                   	push   %edi
  80319a:	56                   	push   %esi
  80319b:	53                   	push   %ebx
  80319c:	83 ec 1c             	sub    $0x1c,%esp
  80319f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031b7:	89 f3                	mov    %esi,%ebx
  8031b9:	89 fa                	mov    %edi,%edx
  8031bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031bf:	89 34 24             	mov    %esi,(%esp)
  8031c2:	85 c0                	test   %eax,%eax
  8031c4:	75 1a                	jne    8031e0 <__umoddi3+0x48>
  8031c6:	39 f7                	cmp    %esi,%edi
  8031c8:	0f 86 a2 00 00 00    	jbe    803270 <__umoddi3+0xd8>
  8031ce:	89 c8                	mov    %ecx,%eax
  8031d0:	89 f2                	mov    %esi,%edx
  8031d2:	f7 f7                	div    %edi
  8031d4:	89 d0                	mov    %edx,%eax
  8031d6:	31 d2                	xor    %edx,%edx
  8031d8:	83 c4 1c             	add    $0x1c,%esp
  8031db:	5b                   	pop    %ebx
  8031dc:	5e                   	pop    %esi
  8031dd:	5f                   	pop    %edi
  8031de:	5d                   	pop    %ebp
  8031df:	c3                   	ret    
  8031e0:	39 f0                	cmp    %esi,%eax
  8031e2:	0f 87 ac 00 00 00    	ja     803294 <__umoddi3+0xfc>
  8031e8:	0f bd e8             	bsr    %eax,%ebp
  8031eb:	83 f5 1f             	xor    $0x1f,%ebp
  8031ee:	0f 84 ac 00 00 00    	je     8032a0 <__umoddi3+0x108>
  8031f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8031f9:	29 ef                	sub    %ebp,%edi
  8031fb:	89 fe                	mov    %edi,%esi
  8031fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803201:	89 e9                	mov    %ebp,%ecx
  803203:	d3 e0                	shl    %cl,%eax
  803205:	89 d7                	mov    %edx,%edi
  803207:	89 f1                	mov    %esi,%ecx
  803209:	d3 ef                	shr    %cl,%edi
  80320b:	09 c7                	or     %eax,%edi
  80320d:	89 e9                	mov    %ebp,%ecx
  80320f:	d3 e2                	shl    %cl,%edx
  803211:	89 14 24             	mov    %edx,(%esp)
  803214:	89 d8                	mov    %ebx,%eax
  803216:	d3 e0                	shl    %cl,%eax
  803218:	89 c2                	mov    %eax,%edx
  80321a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80321e:	d3 e0                	shl    %cl,%eax
  803220:	89 44 24 04          	mov    %eax,0x4(%esp)
  803224:	8b 44 24 08          	mov    0x8(%esp),%eax
  803228:	89 f1                	mov    %esi,%ecx
  80322a:	d3 e8                	shr    %cl,%eax
  80322c:	09 d0                	or     %edx,%eax
  80322e:	d3 eb                	shr    %cl,%ebx
  803230:	89 da                	mov    %ebx,%edx
  803232:	f7 f7                	div    %edi
  803234:	89 d3                	mov    %edx,%ebx
  803236:	f7 24 24             	mull   (%esp)
  803239:	89 c6                	mov    %eax,%esi
  80323b:	89 d1                	mov    %edx,%ecx
  80323d:	39 d3                	cmp    %edx,%ebx
  80323f:	0f 82 87 00 00 00    	jb     8032cc <__umoddi3+0x134>
  803245:	0f 84 91 00 00 00    	je     8032dc <__umoddi3+0x144>
  80324b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80324f:	29 f2                	sub    %esi,%edx
  803251:	19 cb                	sbb    %ecx,%ebx
  803253:	89 d8                	mov    %ebx,%eax
  803255:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803259:	d3 e0                	shl    %cl,%eax
  80325b:	89 e9                	mov    %ebp,%ecx
  80325d:	d3 ea                	shr    %cl,%edx
  80325f:	09 d0                	or     %edx,%eax
  803261:	89 e9                	mov    %ebp,%ecx
  803263:	d3 eb                	shr    %cl,%ebx
  803265:	89 da                	mov    %ebx,%edx
  803267:	83 c4 1c             	add    $0x1c,%esp
  80326a:	5b                   	pop    %ebx
  80326b:	5e                   	pop    %esi
  80326c:	5f                   	pop    %edi
  80326d:	5d                   	pop    %ebp
  80326e:	c3                   	ret    
  80326f:	90                   	nop
  803270:	89 fd                	mov    %edi,%ebp
  803272:	85 ff                	test   %edi,%edi
  803274:	75 0b                	jne    803281 <__umoddi3+0xe9>
  803276:	b8 01 00 00 00       	mov    $0x1,%eax
  80327b:	31 d2                	xor    %edx,%edx
  80327d:	f7 f7                	div    %edi
  80327f:	89 c5                	mov    %eax,%ebp
  803281:	89 f0                	mov    %esi,%eax
  803283:	31 d2                	xor    %edx,%edx
  803285:	f7 f5                	div    %ebp
  803287:	89 c8                	mov    %ecx,%eax
  803289:	f7 f5                	div    %ebp
  80328b:	89 d0                	mov    %edx,%eax
  80328d:	e9 44 ff ff ff       	jmp    8031d6 <__umoddi3+0x3e>
  803292:	66 90                	xchg   %ax,%ax
  803294:	89 c8                	mov    %ecx,%eax
  803296:	89 f2                	mov    %esi,%edx
  803298:	83 c4 1c             	add    $0x1c,%esp
  80329b:	5b                   	pop    %ebx
  80329c:	5e                   	pop    %esi
  80329d:	5f                   	pop    %edi
  80329e:	5d                   	pop    %ebp
  80329f:	c3                   	ret    
  8032a0:	3b 04 24             	cmp    (%esp),%eax
  8032a3:	72 06                	jb     8032ab <__umoddi3+0x113>
  8032a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032a9:	77 0f                	ja     8032ba <__umoddi3+0x122>
  8032ab:	89 f2                	mov    %esi,%edx
  8032ad:	29 f9                	sub    %edi,%ecx
  8032af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032b3:	89 14 24             	mov    %edx,(%esp)
  8032b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032be:	8b 14 24             	mov    (%esp),%edx
  8032c1:	83 c4 1c             	add    $0x1c,%esp
  8032c4:	5b                   	pop    %ebx
  8032c5:	5e                   	pop    %esi
  8032c6:	5f                   	pop    %edi
  8032c7:	5d                   	pop    %ebp
  8032c8:	c3                   	ret    
  8032c9:	8d 76 00             	lea    0x0(%esi),%esi
  8032cc:	2b 04 24             	sub    (%esp),%eax
  8032cf:	19 fa                	sbb    %edi,%edx
  8032d1:	89 d1                	mov    %edx,%ecx
  8032d3:	89 c6                	mov    %eax,%esi
  8032d5:	e9 71 ff ff ff       	jmp    80324b <__umoddi3+0xb3>
  8032da:	66 90                	xchg   %ax,%ax
  8032dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032e0:	72 ea                	jb     8032cc <__umoddi3+0x134>
  8032e2:	89 d9                	mov    %ebx,%ecx
  8032e4:	e9 62 ff ff ff       	jmp    80324b <__umoddi3+0xb3>
