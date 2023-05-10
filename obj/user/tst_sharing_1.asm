
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 27 03 00 00       	call   80035d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
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
_main(void)
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
  80008d:	68 20 34 80 00       	push   $0x803420
  800092:	6a 12                	push   $0x12
  800094:	68 3c 34 80 00       	push   $0x80343c
  800099:	e8 fb 03 00 00       	call   800499 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 d1 15 00 00       	call   801679 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;
	uint32 expected ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 54 34 80 00       	push   $0x803454
  8000b3:	e8 95 06 00 00       	call   80074d <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000bb:	e8 e7 19 00 00       	call   801aa7 <sys_calculate_free_frames>
  8000c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	6a 01                	push   $0x1
  8000c8:	68 00 10 00 00       	push   $0x1000
  8000cd:	68 8b 34 80 00       	push   $0x80348b
  8000d2:	e8 f1 16 00 00       	call   8017c8 <smalloc>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000dd:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 90 34 80 00       	push   $0x803490
  8000ee:	6a 1e                	push   $0x1e
  8000f0:	68 3c 34 80 00       	push   $0x80343c
  8000f5:	e8 9f 03 00 00       	call   800499 <_panic>
		expected = 1+1+2 ;
  8000fa:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) !=  expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800101:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800104:	e8 9e 19 00 00       	call   801aa7 <sys_calculate_free_frames>
  800109:	29 c3                	sub    %eax,%ebx
  80010b:	89 d8                	mov    %ebx,%eax
  80010d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800110:	74 24                	je     800136 <_main+0xfe>
  800112:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800115:	e8 8d 19 00 00       	call   801aa7 <sys_calculate_free_frames>
  80011a:	29 c3                	sub    %eax,%ebx
  80011c:	89 d8                	mov    %ebx,%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	ff 75 e0             	pushl  -0x20(%ebp)
  800124:	50                   	push   %eax
  800125:	68 fc 34 80 00       	push   $0x8034fc
  80012a:	6a 20                	push   $0x20
  80012c:	68 3c 34 80 00       	push   $0x80343c
  800131:	e8 63 03 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800136:	e8 6c 19 00 00       	call   801aa7 <sys_calculate_free_frames>
  80013b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	6a 01                	push   $0x1
  800143:	68 04 10 00 00       	push   $0x1004
  800148:	68 94 35 80 00       	push   $0x803594
  80014d:	e8 76 16 00 00       	call   8017c8 <smalloc>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800158:	81 7d dc 00 10 00 80 	cmpl   $0x80001000,-0x24(%ebp)
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 90 34 80 00       	push   $0x803490
  800169:	6a 24                	push   $0x24
  80016b:	68 3c 34 80 00       	push   $0x80343c
  800170:	e8 24 03 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800175:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800178:	e8 2a 19 00 00       	call   801aa7 <sys_calculate_free_frames>
  80017d:	29 c3                	sub    %eax,%ebx
  80017f:	89 d8                	mov    %ebx,%eax
  800181:	83 f8 04             	cmp    $0x4,%eax
  800184:	74 14                	je     80019a <_main+0x162>
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	68 98 35 80 00       	push   $0x803598
  80018e:	6a 25                	push   $0x25
  800190:	68 3c 34 80 00       	push   $0x80343c
  800195:	e8 ff 02 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 08 19 00 00       	call   801aa7 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	6a 01                	push   $0x1
  8001a7:	6a 04                	push   $0x4
  8001a9:	68 16 36 80 00       	push   $0x803616
  8001ae:	e8 15 16 00 00       	call   8017c8 <smalloc>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001b9:	81 7d d8 00 30 00 80 	cmpl   $0x80003000,-0x28(%ebp)
  8001c0:	74 14                	je     8001d6 <_main+0x19e>
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	68 90 34 80 00       	push   $0x803490
  8001ca:	6a 29                	push   $0x29
  8001cc:	68 3c 34 80 00       	push   $0x80343c
  8001d1:	e8 c3 02 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001d6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001d9:	e8 c9 18 00 00       	call   801aa7 <sys_calculate_free_frames>
  8001de:	29 c3                	sub    %eax,%ebx
  8001e0:	89 d8                	mov    %ebx,%eax
  8001e2:	83 f8 03             	cmp    $0x3,%eax
  8001e5:	74 14                	je     8001fb <_main+0x1c3>
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 98 35 80 00       	push   $0x803598
  8001ef:	6a 2a                	push   $0x2a
  8001f1:	68 3c 34 80 00       	push   $0x80343c
  8001f6:	e8 9e 02 00 00       	call   800499 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 18 36 80 00       	push   $0x803618
  800203:	e8 45 05 00 00       	call   80074d <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 40 36 80 00       	push   $0x803640
  800213:	e8 35 05 00 00       	call   80074d <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800222:	eb 2d                	jmp    800251 <_main+0x219>
		{
			x[i] = -1;
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80022e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800231:	01 d0                	add    %edx,%eax
  800233:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800243:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  80024e:	ff 45 ec             	incl   -0x14(%ebp)
  800251:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  800258:	7e ca                	jle    800224 <_main+0x1ec>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800261:	eb 18                	jmp    80027b <_main+0x243>
		{
			z[i] = -1;
  800263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800270:	01 d0                	add    %edx,%eax
  800272:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800278:	ff 45 ec             	incl   -0x14(%ebp)
  80027b:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800282:	7e df                	jle    800263 <_main+0x22b>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	83 f8 ff             	cmp    $0xffffffff,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 68 36 80 00       	push   $0x803668
  800296:	6a 3e                	push   $0x3e
  800298:	68 3c 34 80 00       	push   $0x80343c
  80029d:	e8 f7 01 00 00       	call   800499 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 68 36 80 00       	push   $0x803668
  8002b9:	6a 3f                	push   $0x3f
  8002bb:	68 3c 34 80 00       	push   $0x80343c
  8002c0:	e8 d4 01 00 00       	call   800499 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cd:	74 14                	je     8002e3 <_main+0x2ab>
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 68 36 80 00       	push   $0x803668
  8002d7:	6a 41                	push   $0x41
  8002d9:	68 3c 34 80 00       	push   $0x80343c
  8002de:	e8 b6 01 00 00       	call   800499 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e6:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f0:	74 14                	je     800306 <_main+0x2ce>
  8002f2:	83 ec 04             	sub    $0x4,%esp
  8002f5:	68 68 36 80 00       	push   $0x803668
  8002fa:	6a 42                	push   $0x42
  8002fc:	68 3c 34 80 00       	push   $0x80343c
  800301:	e8 93 01 00 00       	call   800499 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 68 36 80 00       	push   $0x803668
  800318:	6a 44                	push   $0x44
  80031a:	68 3c 34 80 00       	push   $0x80343c
  80031f:	e8 75 01 00 00       	call   800499 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800324:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800327:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	83 f8 ff             	cmp    $0xffffffff,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 68 36 80 00       	push   $0x803668
  80033b:	6a 45                	push   $0x45
  80033d:	68 3c 34 80 00       	push   $0x80343c
  800342:	e8 52 01 00 00       	call   800499 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 94 36 80 00       	push   $0x803694
  80034f:	e8 f9 03 00 00       	call   80074d <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp

	return;
  800357:	90                   	nop
}
  800358:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800363:	e8 1f 1a 00 00       	call   801d87 <sys_getenvindex>
  800368:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80036b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80036e:	89 d0                	mov    %edx,%eax
  800370:	c1 e0 03             	shl    $0x3,%eax
  800373:	01 d0                	add    %edx,%eax
  800375:	01 c0                	add    %eax,%eax
  800377:	01 d0                	add    %edx,%eax
  800379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800380:	01 d0                	add    %edx,%eax
  800382:	c1 e0 04             	shl    $0x4,%eax
  800385:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80038a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80038f:	a1 20 40 80 00       	mov    0x804020,%eax
  800394:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80039a:	84 c0                	test   %al,%al
  80039c:	74 0f                	je     8003ad <libmain+0x50>
		binaryname = myEnv->prog_name;
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003b1:	7e 0a                	jle    8003bd <libmain+0x60>
		binaryname = argv[0];
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 6d fc ff ff       	call   800038 <_main>
  8003cb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003ce:	e8 c1 17 00 00       	call   801b94 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	68 00 37 80 00       	push   $0x803700
  8003db:	e8 6d 03 00 00       	call   80074d <cprintf>
  8003e0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f9:	83 ec 04             	sub    $0x4,%esp
  8003fc:	52                   	push   %edx
  8003fd:	50                   	push   %eax
  8003fe:	68 28 37 80 00       	push   $0x803728
  800403:	e8 45 03 00 00       	call   80074d <cprintf>
  800408:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80040b:	a1 20 40 80 00       	mov    0x804020,%eax
  800410:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800416:	a1 20 40 80 00       	mov    0x804020,%eax
  80041b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800421:	a1 20 40 80 00       	mov    0x804020,%eax
  800426:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80042c:	51                   	push   %ecx
  80042d:	52                   	push   %edx
  80042e:	50                   	push   %eax
  80042f:	68 50 37 80 00       	push   $0x803750
  800434:	e8 14 03 00 00       	call   80074d <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043c:	a1 20 40 80 00       	mov    0x804020,%eax
  800441:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	50                   	push   %eax
  80044b:	68 a8 37 80 00       	push   $0x8037a8
  800450:	e8 f8 02 00 00       	call   80074d <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	68 00 37 80 00       	push   $0x803700
  800460:	e8 e8 02 00 00       	call   80074d <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800468:	e8 41 17 00 00       	call   801bae <sys_enable_interrupt>

	// exit gracefully
	exit();
  80046d:	e8 19 00 00 00       	call   80048b <exit>
}
  800472:	90                   	nop
  800473:	c9                   	leave  
  800474:	c3                   	ret    

00800475 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80047b:	83 ec 0c             	sub    $0xc,%esp
  80047e:	6a 00                	push   $0x0
  800480:	e8 ce 18 00 00       	call   801d53 <sys_destroy_env>
  800485:	83 c4 10             	add    $0x10,%esp
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <exit>:

void
exit(void)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800491:	e8 23 19 00 00       	call   801db9 <sys_exit_env>
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80049f:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a2:	83 c0 04             	add    $0x4,%eax
  8004a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004ad:	85 c0                	test   %eax,%eax
  8004af:	74 16                	je     8004c7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b1:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	50                   	push   %eax
  8004ba:	68 bc 37 80 00       	push   $0x8037bc
  8004bf:	e8 89 02 00 00       	call   80074d <cprintf>
  8004c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004c7:	a1 00 40 80 00       	mov    0x804000,%eax
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	68 c1 37 80 00       	push   $0x8037c1
  8004d8:	e8 70 02 00 00       	call   80074d <cprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e9:	50                   	push   %eax
  8004ea:	e8 f3 01 00 00       	call   8006e2 <vcprintf>
  8004ef:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	6a 00                	push   $0x0
  8004f7:	68 dd 37 80 00       	push   $0x8037dd
  8004fc:	e8 e1 01 00 00       	call   8006e2 <vcprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800504:	e8 82 ff ff ff       	call   80048b <exit>

	// should not return here
	while (1) ;
  800509:	eb fe                	jmp    800509 <_panic+0x70>

0080050b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800511:	a1 20 40 80 00       	mov    0x804020,%eax
  800516:	8b 50 74             	mov    0x74(%eax),%edx
  800519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 e0 37 80 00       	push   $0x8037e0
  800528:	6a 26                	push   $0x26
  80052a:	68 2c 38 80 00       	push   $0x80382c
  80052f:	e8 65 ff ff ff       	call   800499 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800534:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80053b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800542:	e9 c2 00 00 00       	jmp    800609 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	01 d0                	add    %edx,%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	85 c0                	test   %eax,%eax
  80055a:	75 08                	jne    800564 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80055c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80055f:	e9 a2 00 00 00       	jmp    800606 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800564:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800572:	eb 69                	jmp    8005dd <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800574:	a1 20 40 80 00       	mov    0x804020,%eax
  800579:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80057f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800582:	89 d0                	mov    %edx,%eax
  800584:	01 c0                	add    %eax,%eax
  800586:	01 d0                	add    %edx,%eax
  800588:	c1 e0 03             	shl    $0x3,%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8a 40 04             	mov    0x4(%eax),%al
  800590:	84 c0                	test   %al,%al
  800592:	75 46                	jne    8005da <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800594:	a1 20 40 80 00       	mov    0x804020,%eax
  800599:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80059f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a2:	89 d0                	mov    %edx,%eax
  8005a4:	01 c0                	add    %eax,%eax
  8005a6:	01 d0                	add    %edx,%eax
  8005a8:	c1 e0 03             	shl    $0x3,%eax
  8005ab:	01 c8                	add    %ecx,%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ba:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	01 c8                	add    %ecx,%eax
  8005cb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	75 09                	jne    8005da <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005d1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d8:	eb 12                	jmp    8005ec <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e2:	8b 50 74             	mov    0x74(%eax),%edx
  8005e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e8:	39 c2                	cmp    %eax,%edx
  8005ea:	77 88                	ja     800574 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f0:	75 14                	jne    800606 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 38 38 80 00       	push   $0x803838
  8005fa:	6a 3a                	push   $0x3a
  8005fc:	68 2c 38 80 00       	push   $0x80382c
  800601:	e8 93 fe ff ff       	call   800499 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800606:	ff 45 f0             	incl   -0x10(%ebp)
  800609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80060f:	0f 8c 32 ff ff ff    	jl     800547 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800615:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800623:	eb 26                	jmp    80064b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800625:	a1 20 40 80 00       	mov    0x804020,%eax
  80062a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800630:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	3c 01                	cmp    $0x1,%al
  800643:	75 03                	jne    800648 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800645:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800648:	ff 45 e0             	incl   -0x20(%ebp)
  80064b:	a1 20 40 80 00       	mov    0x804020,%eax
  800650:	8b 50 74             	mov    0x74(%eax),%edx
  800653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	77 cb                	ja     800625 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80065a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80065d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800660:	74 14                	je     800676 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 8c 38 80 00       	push   $0x80388c
  80066a:	6a 44                	push   $0x44
  80066c:	68 2c 38 80 00       	push   $0x80382c
  800671:	e8 23 fe ff ff       	call   800499 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800676:	90                   	nop
  800677:	c9                   	leave  
  800678:	c3                   	ret    

00800679 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800679:	55                   	push   %ebp
  80067a:	89 e5                	mov    %esp,%ebp
  80067c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	8d 48 01             	lea    0x1(%eax),%ecx
  800687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068a:	89 0a                	mov    %ecx,(%edx)
  80068c:	8b 55 08             	mov    0x8(%ebp),%edx
  80068f:	88 d1                	mov    %dl,%cl
  800691:	8b 55 0c             	mov    0xc(%ebp),%edx
  800694:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a2:	75 2c                	jne    8006d0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006a4:	a0 24 40 80 00       	mov    0x804024,%al
  8006a9:	0f b6 c0             	movzbl %al,%eax
  8006ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006af:	8b 12                	mov    (%edx),%edx
  8006b1:	89 d1                	mov    %edx,%ecx
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	83 c2 08             	add    $0x8,%edx
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	50                   	push   %eax
  8006bd:	51                   	push   %ecx
  8006be:	52                   	push   %edx
  8006bf:	e8 22 13 00 00       	call   8019e6 <sys_cputs>
  8006c4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d3:	8b 40 04             	mov    0x4(%eax),%eax
  8006d6:	8d 50 01             	lea    0x1(%eax),%edx
  8006d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006df:	90                   	nop
  8006e0:	c9                   	leave  
  8006e1:	c3                   	ret    

008006e2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
  8006e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f2:	00 00 00 
	b.cnt = 0;
  8006f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006fc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ff:	ff 75 0c             	pushl  0xc(%ebp)
  800702:	ff 75 08             	pushl  0x8(%ebp)
  800705:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	68 79 06 80 00       	push   $0x800679
  800711:	e8 11 02 00 00       	call   800927 <vprintfmt>
  800716:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800719:	a0 24 40 80 00       	mov    0x804024,%al
  80071e:	0f b6 c0             	movzbl %al,%eax
  800721:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800727:	83 ec 04             	sub    $0x4,%esp
  80072a:	50                   	push   %eax
  80072b:	52                   	push   %edx
  80072c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800732:	83 c0 08             	add    $0x8,%eax
  800735:	50                   	push   %eax
  800736:	e8 ab 12 00 00       	call   8019e6 <sys_cputs>
  80073b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80073e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800745:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <cprintf>:

int cprintf(const char *fmt, ...) {
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800753:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80075a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 f4             	pushl  -0xc(%ebp)
  800769:	50                   	push   %eax
  80076a:	e8 73 ff ff ff       	call   8006e2 <vcprintf>
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800778:	c9                   	leave  
  800779:	c3                   	ret    

0080077a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800780:	e8 0f 14 00 00       	call   801b94 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800785:	8d 45 0c             	lea    0xc(%ebp),%eax
  800788:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 f4             	pushl  -0xc(%ebp)
  800794:	50                   	push   %eax
  800795:	e8 48 ff ff ff       	call   8006e2 <vcprintf>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007a0:	e8 09 14 00 00       	call   801bae <sys_enable_interrupt>
	return cnt;
  8007a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	53                   	push   %ebx
  8007ae:	83 ec 14             	sub    $0x14,%esp
  8007b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007bd:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c8:	77 55                	ja     80081f <printnum+0x75>
  8007ca:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007cd:	72 05                	jb     8007d4 <printnum+0x2a>
  8007cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007d2:	77 4b                	ja     80081f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007d7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007da:	8b 45 18             	mov    0x18(%ebp),%eax
  8007dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e2:	52                   	push   %edx
  8007e3:	50                   	push   %eax
  8007e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ea:	e8 b5 29 00 00       	call   8031a4 <__udivdi3>
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	83 ec 04             	sub    $0x4,%esp
  8007f5:	ff 75 20             	pushl  0x20(%ebp)
  8007f8:	53                   	push   %ebx
  8007f9:	ff 75 18             	pushl  0x18(%ebp)
  8007fc:	52                   	push   %edx
  8007fd:	50                   	push   %eax
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 a1 ff ff ff       	call   8007aa <printnum>
  800809:	83 c4 20             	add    $0x20,%esp
  80080c:	eb 1a                	jmp    800828 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	ff 75 20             	pushl  0x20(%ebp)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	ff d0                	call   *%eax
  80081c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80081f:	ff 4d 1c             	decl   0x1c(%ebp)
  800822:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800826:	7f e6                	jg     80080e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800828:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80082b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800836:	53                   	push   %ebx
  800837:	51                   	push   %ecx
  800838:	52                   	push   %edx
  800839:	50                   	push   %eax
  80083a:	e8 75 2a 00 00       	call   8032b4 <__umoddi3>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	05 f4 3a 80 00       	add    $0x803af4,%eax
  800847:	8a 00                	mov    (%eax),%al
  800849:	0f be c0             	movsbl %al,%eax
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	50                   	push   %eax
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
}
  80085b:	90                   	nop
  80085c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085f:	c9                   	leave  
  800860:	c3                   	ret    

00800861 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800864:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800868:	7e 1c                	jle    800886 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	8d 50 08             	lea    0x8(%eax),%edx
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	89 10                	mov    %edx,(%eax)
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	83 e8 08             	sub    $0x8,%eax
  80087f:	8b 50 04             	mov    0x4(%eax),%edx
  800882:	8b 00                	mov    (%eax),%eax
  800884:	eb 40                	jmp    8008c6 <getuint+0x65>
	else if (lflag)
  800886:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088a:	74 1e                	je     8008aa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 04             	lea    0x4(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a8:	eb 1c                	jmp    8008c6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8d 50 04             	lea    0x4(%eax),%edx
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	89 10                	mov    %edx,(%eax)
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	83 e8 04             	sub    $0x4,%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cf:	7e 1c                	jle    8008ed <getint+0x25>
		return va_arg(*ap, long long);
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	8d 50 08             	lea    0x8(%eax),%edx
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	89 10                	mov    %edx,(%eax)
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	83 e8 08             	sub    $0x8,%eax
  8008e6:	8b 50 04             	mov    0x4(%eax),%edx
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	eb 38                	jmp    800925 <getint+0x5d>
	else if (lflag)
  8008ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f1:	74 1a                	je     80090d <getint+0x45>
		return va_arg(*ap, long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 04             	lea    0x4(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 04             	sub    $0x4,%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	99                   	cltd   
  80090b:	eb 18                	jmp    800925 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 04             	sub    $0x4,%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	99                   	cltd   
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	56                   	push   %esi
  80092b:	53                   	push   %ebx
  80092c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092f:	eb 17                	jmp    800948 <vprintfmt+0x21>
			if (ch == '\0')
  800931:	85 db                	test   %ebx,%ebx
  800933:	0f 84 af 03 00 00    	je     800ce8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	53                   	push   %ebx
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	8d 50 01             	lea    0x1(%eax),%edx
  80094e:	89 55 10             	mov    %edx,0x10(%ebp)
  800951:	8a 00                	mov    (%eax),%al
  800953:	0f b6 d8             	movzbl %al,%ebx
  800956:	83 fb 25             	cmp    $0x25,%ebx
  800959:	75 d6                	jne    800931 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80095f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800966:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80096d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800974:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097b:	8b 45 10             	mov    0x10(%ebp),%eax
  80097e:	8d 50 01             	lea    0x1(%eax),%edx
  800981:	89 55 10             	mov    %edx,0x10(%ebp)
  800984:	8a 00                	mov    (%eax),%al
  800986:	0f b6 d8             	movzbl %al,%ebx
  800989:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80098c:	83 f8 55             	cmp    $0x55,%eax
  80098f:	0f 87 2b 03 00 00    	ja     800cc0 <vprintfmt+0x399>
  800995:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
  80099c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80099e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009a2:	eb d7                	jmp    80097b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009a8:	eb d1                	jmp    80097b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b4:	89 d0                	mov    %edx,%eax
  8009b6:	c1 e0 02             	shl    $0x2,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	01 c0                	add    %eax,%eax
  8009bd:	01 d8                	add    %ebx,%eax
  8009bf:	83 e8 30             	sub    $0x30,%eax
  8009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c8:	8a 00                	mov    (%eax),%al
  8009ca:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009cd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d0:	7e 3e                	jle    800a10 <vprintfmt+0xe9>
  8009d2:	83 fb 39             	cmp    $0x39,%ebx
  8009d5:	7f 39                	jg     800a10 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009da:	eb d5                	jmp    8009b1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009df:	83 c0 04             	add    $0x4,%eax
  8009e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e8:	83 e8 04             	sub    $0x4,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f0:	eb 1f                	jmp    800a11 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f6:	79 83                	jns    80097b <vprintfmt+0x54>
				width = 0;
  8009f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ff:	e9 77 ff ff ff       	jmp    80097b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a04:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a0b:	e9 6b ff ff ff       	jmp    80097b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a10:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a15:	0f 89 60 ff ff ff    	jns    80097b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a21:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a28:	e9 4e ff ff ff       	jmp    80097b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a2d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a30:	e9 46 ff ff ff       	jmp    80097b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	ff 75 0c             	pushl  0xc(%ebp)
  800a4c:	50                   	push   %eax
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
			break;
  800a55:	e9 89 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5d:	83 c0 04             	add    $0x4,%eax
  800a60:	89 45 14             	mov    %eax,0x14(%ebp)
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 e8 04             	sub    $0x4,%eax
  800a69:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a6b:	85 db                	test   %ebx,%ebx
  800a6d:	79 02                	jns    800a71 <vprintfmt+0x14a>
				err = -err;
  800a6f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a71:	83 fb 64             	cmp    $0x64,%ebx
  800a74:	7f 0b                	jg     800a81 <vprintfmt+0x15a>
  800a76:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  800a7d:	85 f6                	test   %esi,%esi
  800a7f:	75 19                	jne    800a9a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a81:	53                   	push   %ebx
  800a82:	68 05 3b 80 00       	push   $0x803b05
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	ff 75 08             	pushl  0x8(%ebp)
  800a8d:	e8 5e 02 00 00       	call   800cf0 <printfmt>
  800a92:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a95:	e9 49 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9a:	56                   	push   %esi
  800a9b:	68 0e 3b 80 00       	push   $0x803b0e
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	ff 75 08             	pushl  0x8(%ebp)
  800aa6:	e8 45 02 00 00       	call   800cf0 <printfmt>
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 30 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 30                	mov    (%eax),%esi
  800ac4:	85 f6                	test   %esi,%esi
  800ac6:	75 05                	jne    800acd <vprintfmt+0x1a6>
				p = "(null)";
  800ac8:	be 11 3b 80 00       	mov    $0x803b11,%esi
			if (width > 0 && padc != '-')
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7e 6d                	jle    800b40 <vprintfmt+0x219>
  800ad3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ad7:	74 67                	je     800b40 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	50                   	push   %eax
  800ae0:	56                   	push   %esi
  800ae1:	e8 0c 03 00 00       	call   800df2 <strnlen>
  800ae6:	83 c4 10             	add    $0x10,%esp
  800ae9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aec:	eb 16                	jmp    800b04 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aee:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	50                   	push   %eax
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b01:	ff 4d e4             	decl   -0x1c(%ebp)
  800b04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b08:	7f e4                	jg     800aee <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0a:	eb 34                	jmp    800b40 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b10:	74 1c                	je     800b2e <vprintfmt+0x207>
  800b12:	83 fb 1f             	cmp    $0x1f,%ebx
  800b15:	7e 05                	jle    800b1c <vprintfmt+0x1f5>
  800b17:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1a:	7e 12                	jle    800b2e <vprintfmt+0x207>
					putch('?', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 3f                	push   $0x3f
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	eb 0f                	jmp    800b3d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	53                   	push   %ebx
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	ff d0                	call   *%eax
  800b3a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b40:	89 f0                	mov    %esi,%eax
  800b42:	8d 70 01             	lea    0x1(%eax),%esi
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	0f be d8             	movsbl %al,%ebx
  800b4a:	85 db                	test   %ebx,%ebx
  800b4c:	74 24                	je     800b72 <vprintfmt+0x24b>
  800b4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b52:	78 b8                	js     800b0c <vprintfmt+0x1e5>
  800b54:	ff 4d e0             	decl   -0x20(%ebp)
  800b57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5b:	79 af                	jns    800b0c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5d:	eb 13                	jmp    800b72 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	6a 20                	push   $0x20
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b76:	7f e7                	jg     800b5f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b78:	e9 66 01 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 e8             	pushl  -0x18(%ebp)
  800b83:	8d 45 14             	lea    0x14(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	e8 3c fd ff ff       	call   8008c8 <getint>
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9b:	85 d2                	test   %edx,%edx
  800b9d:	79 23                	jns    800bc2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	6a 2d                	push   $0x2d
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	ff d0                	call   *%eax
  800bac:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb5:	f7 d8                	neg    %eax
  800bb7:	83 d2 00             	adc    $0x0,%edx
  800bba:	f7 da                	neg    %edx
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bc2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc9:	e9 bc 00 00 00       	jmp    800c8a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 84 fc ff ff       	call   800861 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800be6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bed:	e9 98 00 00 00       	jmp    800c8a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	6a 58                	push   $0x58
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	ff d0                	call   *%eax
  800c1f:	83 c4 10             	add    $0x10,%esp
			break;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 30                	push   $0x30
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	6a 78                	push   $0x78
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	ff d0                	call   *%eax
  800c44:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c47:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4a:	83 c0 04             	add    $0x4,%eax
  800c4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c50:	8b 45 14             	mov    0x14(%ebp),%eax
  800c53:	83 e8 04             	sub    $0x4,%eax
  800c56:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c62:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c69:	eb 1f                	jmp    800c8a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c71:	8d 45 14             	lea    0x14(%ebp),%eax
  800c74:	50                   	push   %eax
  800c75:	e8 e7 fb ff ff       	call   800861 <getuint>
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c83:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c91:	83 ec 04             	sub    $0x4,%esp
  800c94:	52                   	push   %edx
  800c95:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c98:	50                   	push   %eax
  800c99:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	ff 75 08             	pushl  0x8(%ebp)
  800ca5:	e8 00 fb ff ff       	call   8007aa <printnum>
  800caa:	83 c4 20             	add    $0x20,%esp
			break;
  800cad:	eb 34                	jmp    800ce3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	53                   	push   %ebx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			break;
  800cbe:	eb 23                	jmp    800ce3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc0:	83 ec 08             	sub    $0x8,%esp
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	6a 25                	push   $0x25
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	ff d0                	call   *%eax
  800ccd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	eb 03                	jmp    800cd8 <vprintfmt+0x3b1>
  800cd5:	ff 4d 10             	decl   0x10(%ebp)
  800cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdb:	48                   	dec    %eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	3c 25                	cmp    $0x25,%al
  800ce0:	75 f3                	jne    800cd5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ce2:	90                   	nop
		}
	}
  800ce3:	e9 47 fc ff ff       	jmp    80092f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cf6:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf9:	83 c0 04             	add    $0x4,%eax
  800cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cff:	8b 45 10             	mov    0x10(%ebp),%eax
  800d02:	ff 75 f4             	pushl  -0xc(%ebp)
  800d05:	50                   	push   %eax
  800d06:	ff 75 0c             	pushl  0xc(%ebp)
  800d09:	ff 75 08             	pushl  0x8(%ebp)
  800d0c:	e8 16 fc ff ff       	call   800927 <vprintfmt>
  800d11:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d14:	90                   	nop
  800d15:	c9                   	leave  
  800d16:	c3                   	ret    

00800d17 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	8b 40 08             	mov    0x8(%eax),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8b 10                	mov    (%eax),%edx
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8b 40 04             	mov    0x4(%eax),%eax
  800d34:	39 c2                	cmp    %eax,%edx
  800d36:	73 12                	jae    800d4a <sprintputch+0x33>
		*b->buf++ = ch;
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d43:	89 0a                	mov    %ecx,(%edx)
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	88 10                	mov    %dl,(%eax)
}
  800d4a:	90                   	nop
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	01 d0                	add    %edx,%eax
  800d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d72:	74 06                	je     800d7a <vsnprintf+0x2d>
  800d74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d78:	7f 07                	jg     800d81 <vsnprintf+0x34>
		return -E_INVAL;
  800d7a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d7f:	eb 20                	jmp    800da1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d81:	ff 75 14             	pushl  0x14(%ebp)
  800d84:	ff 75 10             	pushl  0x10(%ebp)
  800d87:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	68 17 0d 80 00       	push   $0x800d17
  800d90:	e8 92 fb ff ff       	call   800927 <vprintfmt>
  800d95:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dac:	83 c0 04             	add    $0x4,%eax
  800daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	ff 75 f4             	pushl  -0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	ff 75 0c             	pushl  0xc(%ebp)
  800dbc:	ff 75 08             	pushl  0x8(%ebp)
  800dbf:	e8 89 ff ff ff       	call   800d4d <vsnprintf>
  800dc4:	83 c4 10             	add    $0x10,%esp
  800dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddc:	eb 06                	jmp    800de4 <strlen+0x15>
		n++;
  800dde:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 f1                	jne    800dde <strlen+0xf>
		n++;
	return n;
  800ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dff:	eb 09                	jmp    800e0a <strnlen+0x18>
		n++;
  800e01:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e04:	ff 45 08             	incl   0x8(%ebp)
  800e07:	ff 4d 0c             	decl   0xc(%ebp)
  800e0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0e:	74 09                	je     800e19 <strnlen+0x27>
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	84 c0                	test   %al,%al
  800e17:	75 e8                	jne    800e01 <strnlen+0xf>
		n++;
	return n;
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e2a:	90                   	nop
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8d 50 01             	lea    0x1(%eax),%edx
  800e31:	89 55 08             	mov    %edx,0x8(%ebp)
  800e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e37:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e3d:	8a 12                	mov    (%edx),%dl
  800e3f:	88 10                	mov    %dl,(%eax)
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	75 e4                	jne    800e2b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5f:	eb 1f                	jmp    800e80 <strncpy+0x34>
		*dst++ = *src;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8d 50 01             	lea    0x1(%eax),%edx
  800e67:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	84 c0                	test   %al,%al
  800e78:	74 03                	je     800e7d <strncpy+0x31>
			src++;
  800e7a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e7d:	ff 45 fc             	incl   -0x4(%ebp)
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e83:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e86:	72 d9                	jb     800e61 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e88:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	74 30                	je     800ecf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e9f:	eb 16                	jmp    800eb7 <strlcpy+0x2a>
			*dst++ = *src++;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb7:	ff 4d 10             	decl   0x10(%ebp)
  800eba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebe:	74 09                	je     800ec9 <strlcpy+0x3c>
  800ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	84 c0                	test   %al,%al
  800ec7:	75 d8                	jne    800ea1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ede:	eb 06                	jmp    800ee6 <strcmp+0xb>
		p++, q++;
  800ee0:	ff 45 08             	incl   0x8(%ebp)
  800ee3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	84 c0                	test   %al,%al
  800eed:	74 0e                	je     800efd <strcmp+0x22>
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 10                	mov    (%eax),%dl
  800ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	38 c2                	cmp    %al,%dl
  800efb:	74 e3                	je     800ee0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	0f b6 d0             	movzbl %al,%edx
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	0f b6 c0             	movzbl %al,%eax
  800f0d:	29 c2                	sub    %eax,%edx
  800f0f:	89 d0                	mov    %edx,%eax
}
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f16:	eb 09                	jmp    800f21 <strncmp+0xe>
		n--, p++, q++;
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f25:	74 17                	je     800f3e <strncmp+0x2b>
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	84 c0                	test   %al,%al
  800f2e:	74 0e                	je     800f3e <strncmp+0x2b>
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 10                	mov    (%eax),%dl
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	38 c2                	cmp    %al,%dl
  800f3c:	74 da                	je     800f18 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f42:	75 07                	jne    800f4b <strncmp+0x38>
		return 0;
  800f44:	b8 00 00 00 00       	mov    $0x0,%eax
  800f49:	eb 14                	jmp    800f5f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 d0             	movzbl %al,%edx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f b6 c0             	movzbl %al,%eax
  800f5b:	29 c2                	sub    %eax,%edx
  800f5d:	89 d0                	mov    %edx,%eax
}
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 04             	sub    $0x4,%esp
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6d:	eb 12                	jmp    800f81 <strchr+0x20>
		if (*s == c)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f77:	75 05                	jne    800f7e <strchr+0x1d>
			return (char *) s;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	eb 11                	jmp    800f8f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	84 c0                	test   %al,%al
  800f88:	75 e5                	jne    800f6f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 04             	sub    $0x4,%esp
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9d:	eb 0d                	jmp    800fac <strfind+0x1b>
		if (*s == c)
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa7:	74 0e                	je     800fb7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	84 c0                	test   %al,%al
  800fb3:	75 ea                	jne    800f9f <strfind+0xe>
  800fb5:	eb 01                	jmp    800fb8 <strfind+0x27>
		if (*s == c)
			break;
  800fb7:	90                   	nop
	return (char *) s;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fcf:	eb 0e                	jmp    800fdf <memset+0x22>
		*p++ = c;
  800fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd4:	8d 50 01             	lea    0x1(%eax),%edx
  800fd7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fdd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fdf:	ff 4d f8             	decl   -0x8(%ebp)
  800fe2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fe6:	79 e9                	jns    800fd1 <memset+0x14>
		*p++ = c;

	return v;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fff:	eb 16                	jmp    801017 <memcpy+0x2a>
		*d++ = *s++;
  801001:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801004:	8d 50 01             	lea    0x1(%eax),%edx
  801007:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801010:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801013:	8a 12                	mov    (%edx),%dl
  801015:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101d:	89 55 10             	mov    %edx,0x10(%ebp)
  801020:	85 c0                	test   %eax,%eax
  801022:	75 dd                	jne    801001 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80103b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801041:	73 50                	jae    801093 <memmove+0x6a>
  801043:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104e:	76 43                	jbe    801093 <memmove+0x6a>
		s += n;
  801050:	8b 45 10             	mov    0x10(%ebp),%eax
  801053:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80105c:	eb 10                	jmp    80106e <memmove+0x45>
			*--d = *--s;
  80105e:	ff 4d f8             	decl   -0x8(%ebp)
  801061:	ff 4d fc             	decl   -0x4(%ebp)
  801064:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801067:	8a 10                	mov    (%eax),%dl
  801069:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80106e:	8b 45 10             	mov    0x10(%ebp),%eax
  801071:	8d 50 ff             	lea    -0x1(%eax),%edx
  801074:	89 55 10             	mov    %edx,0x10(%ebp)
  801077:	85 c0                	test   %eax,%eax
  801079:	75 e3                	jne    80105e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80107b:	eb 23                	jmp    8010a0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80107d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801080:	8d 50 01             	lea    0x1(%eax),%edx
  801083:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801086:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801089:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80108f:	8a 12                	mov    (%edx),%dl
  801091:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	8d 50 ff             	lea    -0x1(%eax),%edx
  801099:	89 55 10             	mov    %edx,0x10(%ebp)
  80109c:	85 c0                	test   %eax,%eax
  80109e:	75 dd                	jne    80107d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010b7:	eb 2a                	jmp    8010e3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bc:	8a 10                	mov    (%eax),%dl
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	38 c2                	cmp    %al,%dl
  8010c5:	74 16                	je     8010dd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	0f b6 d0             	movzbl %al,%edx
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	0f b6 c0             	movzbl %al,%eax
  8010d7:	29 c2                	sub    %eax,%edx
  8010d9:	89 d0                	mov    %edx,%eax
  8010db:	eb 18                	jmp    8010f5 <memcmp+0x50>
		s1++, s2++;
  8010dd:	ff 45 fc             	incl   -0x4(%ebp)
  8010e0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	75 c9                	jne    8010b9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	01 d0                	add    %edx,%eax
  801105:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801108:	eb 15                	jmp    80111f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f b6 d0             	movzbl %al,%edx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	0f b6 c0             	movzbl %al,%eax
  801118:	39 c2                	cmp    %eax,%edx
  80111a:	74 0d                	je     801129 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80111c:	ff 45 08             	incl   0x8(%ebp)
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801125:	72 e3                	jb     80110a <memfind+0x13>
  801127:	eb 01                	jmp    80112a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801129:	90                   	nop
	return (void *) s;
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80113c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801143:	eb 03                	jmp    801148 <strtol+0x19>
		s++;
  801145:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 20                	cmp    $0x20,%al
  80114f:	74 f4                	je     801145 <strtol+0x16>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 09                	cmp    $0x9,%al
  801158:	74 eb                	je     801145 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	3c 2b                	cmp    $0x2b,%al
  801161:	75 05                	jne    801168 <strtol+0x39>
		s++;
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	eb 13                	jmp    80117b <strtol+0x4c>
	else if (*s == '-')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2d                	cmp    $0x2d,%al
  80116f:	75 0a                	jne    80117b <strtol+0x4c>
		s++, neg = 1;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80117b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117f:	74 06                	je     801187 <strtol+0x58>
  801181:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801185:	75 20                	jne    8011a7 <strtol+0x78>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	3c 30                	cmp    $0x30,%al
  80118e:	75 17                	jne    8011a7 <strtol+0x78>
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	40                   	inc    %eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	3c 78                	cmp    $0x78,%al
  801198:	75 0d                	jne    8011a7 <strtol+0x78>
		s += 2, base = 16;
  80119a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80119e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011a5:	eb 28                	jmp    8011cf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ab:	75 15                	jne    8011c2 <strtol+0x93>
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	3c 30                	cmp    $0x30,%al
  8011b4:	75 0c                	jne    8011c2 <strtol+0x93>
		s++, base = 8;
  8011b6:	ff 45 08             	incl   0x8(%ebp)
  8011b9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011c0:	eb 0d                	jmp    8011cf <strtol+0xa0>
	else if (base == 0)
  8011c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c6:	75 07                	jne    8011cf <strtol+0xa0>
		base = 10;
  8011c8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 2f                	cmp    $0x2f,%al
  8011d6:	7e 19                	jle    8011f1 <strtol+0xc2>
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 39                	cmp    $0x39,%al
  8011df:	7f 10                	jg     8011f1 <strtol+0xc2>
			dig = *s - '0';
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f be c0             	movsbl %al,%eax
  8011e9:	83 e8 30             	sub    $0x30,%eax
  8011ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ef:	eb 42                	jmp    801233 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 60                	cmp    $0x60,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xe4>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 7a                	cmp    $0x7a,%al
  801201:	7f 10                	jg     801213 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 57             	sub    $0x57,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 20                	jmp    801233 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 40                	cmp    $0x40,%al
  80121a:	7e 39                	jle    801255 <strtol+0x126>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 5a                	cmp    $0x5a,%al
  801223:	7f 30                	jg     801255 <strtol+0x126>
			dig = *s - 'A' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 37             	sub    $0x37,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801236:	3b 45 10             	cmp    0x10(%ebp),%eax
  801239:	7d 19                	jge    801254 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801241:	0f af 45 10          	imul   0x10(%ebp),%eax
  801245:	89 c2                	mov    %eax,%edx
  801247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80124f:	e9 7b ff ff ff       	jmp    8011cf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801254:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801255:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801259:	74 08                	je     801263 <strtol+0x134>
		*endptr = (char *) s;
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801263:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801267:	74 07                	je     801270 <strtol+0x141>
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	f7 d8                	neg    %eax
  80126e:	eb 03                	jmp    801273 <strtol+0x144>
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <ltostr>:

void
ltostr(long value, char *str)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801282:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128d:	79 13                	jns    8012a2 <ltostr+0x2d>
	{
		neg = 1;
  80128f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80129c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80129f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012aa:	99                   	cltd   
  8012ab:	f7 f9                	idiv   %ecx
  8012ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b3:	8d 50 01             	lea    0x1(%eax),%edx
  8012b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012b9:	89 c2                	mov    %eax,%edx
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012c3:	83 c2 30             	add    $0x30,%edx
  8012c6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012cb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d0:	f7 e9                	imul   %ecx
  8012d2:	c1 fa 02             	sar    $0x2,%edx
  8012d5:	89 c8                	mov    %ecx,%eax
  8012d7:	c1 f8 1f             	sar    $0x1f,%eax
  8012da:	29 c2                	sub    %eax,%edx
  8012dc:	89 d0                	mov    %edx,%eax
  8012de:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e9:	f7 e9                	imul   %ecx
  8012eb:	c1 fa 02             	sar    $0x2,%edx
  8012ee:	89 c8                	mov    %ecx,%eax
  8012f0:	c1 f8 1f             	sar    $0x1f,%eax
  8012f3:	29 c2                	sub    %eax,%edx
  8012f5:	89 d0                	mov    %edx,%eax
  8012f7:	c1 e0 02             	shl    $0x2,%eax
  8012fa:	01 d0                	add    %edx,%eax
  8012fc:	01 c0                	add    %eax,%eax
  8012fe:	29 c1                	sub    %eax,%ecx
  801300:	89 ca                	mov    %ecx,%edx
  801302:	85 d2                	test   %edx,%edx
  801304:	75 9c                	jne    8012a2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80130d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801310:	48                   	dec    %eax
  801311:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 3d                	je     801357 <ltostr+0xe2>
		start = 1 ;
  80131a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801321:	eb 34                	jmp    801357 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801323:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	01 d0                	add    %edx,%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	01 c2                	add    %eax,%edx
  801338:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c8                	add    %ecx,%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801344:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	01 c2                	add    %eax,%edx
  80134c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80134f:	88 02                	mov    %al,(%edx)
		start++ ;
  801351:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801354:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80135d:	7c c4                	jl     801323 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80135f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80136a:	90                   	nop
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801373:	ff 75 08             	pushl  0x8(%ebp)
  801376:	e8 54 fa ff ff       	call   800dcf <strlen>
  80137b:	83 c4 04             	add    $0x4,%esp
  80137e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801381:	ff 75 0c             	pushl  0xc(%ebp)
  801384:	e8 46 fa ff ff       	call   800dcf <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80139d:	eb 17                	jmp    8013b6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80139f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	01 c2                	add    %eax,%edx
  8013a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	01 c8                	add    %ecx,%eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013b3:	ff 45 fc             	incl   -0x4(%ebp)
  8013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013bc:	7c e1                	jl     80139f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013cc:	eb 1f                	jmp    8013ed <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d1:	8d 50 01             	lea    0x1(%eax),%edx
  8013d4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013d7:	89 c2                	mov    %eax,%edx
  8013d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dc:	01 c2                	add    %eax,%edx
  8013de:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	01 c8                	add    %ecx,%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013ea:	ff 45 f8             	incl   -0x8(%ebp)
  8013ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f3:	7c d9                	jl     8013ce <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fb:	01 d0                	add    %edx,%eax
  8013fd:	c6 00 00             	movb   $0x0,(%eax)
}
  801400:	90                   	nop
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801406:	8b 45 14             	mov    0x14(%ebp),%eax
  801409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80140f:	8b 45 14             	mov    0x14(%ebp),%eax
  801412:	8b 00                	mov    (%eax),%eax
  801414:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141b:	8b 45 10             	mov    0x10(%ebp),%eax
  80141e:	01 d0                	add    %edx,%eax
  801420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801426:	eb 0c                	jmp    801434 <strsplit+0x31>
			*string++ = 0;
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8d 50 01             	lea    0x1(%eax),%edx
  80142e:	89 55 08             	mov    %edx,0x8(%ebp)
  801431:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	84 c0                	test   %al,%al
  80143b:	74 18                	je     801455 <strsplit+0x52>
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	0f be c0             	movsbl %al,%eax
  801445:	50                   	push   %eax
  801446:	ff 75 0c             	pushl  0xc(%ebp)
  801449:	e8 13 fb ff ff       	call   800f61 <strchr>
  80144e:	83 c4 08             	add    $0x8,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	75 d3                	jne    801428 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	84 c0                	test   %al,%al
  80145c:	74 5a                	je     8014b8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	8b 00                	mov    (%eax),%eax
  801463:	83 f8 0f             	cmp    $0xf,%eax
  801466:	75 07                	jne    80146f <strsplit+0x6c>
		{
			return 0;
  801468:	b8 00 00 00 00       	mov    $0x0,%eax
  80146d:	eb 66                	jmp    8014d5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	8d 48 01             	lea    0x1(%eax),%ecx
  801477:	8b 55 14             	mov    0x14(%ebp),%edx
  80147a:	89 0a                	mov    %ecx,(%edx)
  80147c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	01 c2                	add    %eax,%edx
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80148d:	eb 03                	jmp    801492 <strsplit+0x8f>
			string++;
  80148f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 8b                	je     801426 <strsplit+0x23>
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	0f be c0             	movsbl %al,%eax
  8014a3:	50                   	push   %eax
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	e8 b5 fa ff ff       	call   800f61 <strchr>
  8014ac:	83 c4 08             	add    $0x8,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	74 dc                	je     80148f <strsplit+0x8c>
			string++;
	}
  8014b3:	e9 6e ff ff ff       	jmp    801426 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014b8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bc:	8b 00                	mov    (%eax),%eax
  8014be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c8:	01 d0                	add    %edx,%eax
  8014ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014dd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	74 1f                	je     801505 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014e6:	e8 1d 00 00 00       	call   801508 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	68 70 3c 80 00       	push   $0x803c70
  8014f3:	e8 55 f2 ff ff       	call   80074d <cprintf>
  8014f8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014fb:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801502:	00 00 00 
	}
}
  801505:	90                   	nop
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80150e:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801515:	00 00 00 
  801518:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80151f:	00 00 00 
  801522:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801529:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80152c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801533:	00 00 00 
  801536:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80153d:	00 00 00 
  801540:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801547:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80154a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801551:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801554:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801563:	2d 00 10 00 00       	sub    $0x1000,%eax
  801568:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80156d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801574:	a1 20 41 80 00       	mov    0x804120,%eax
  801579:	c1 e0 04             	shl    $0x4,%eax
  80157c:	89 c2                	mov    %eax,%edx
  80157e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801581:	01 d0                	add    %edx,%eax
  801583:	48                   	dec    %eax
  801584:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158a:	ba 00 00 00 00       	mov    $0x0,%edx
  80158f:	f7 75 f0             	divl   -0x10(%ebp)
  801592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801595:	29 d0                	sub    %edx,%eax
  801597:	89 c2                	mov    %eax,%edx
  801599:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8015a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	6a 06                	push   $0x6
  8015b2:	52                   	push   %edx
  8015b3:	50                   	push   %eax
  8015b4:	e8 71 05 00 00       	call   801b2a <sys_allocate_chunk>
  8015b9:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015bc:	a1 20 41 80 00       	mov    0x804120,%eax
  8015c1:	83 ec 0c             	sub    $0xc,%esp
  8015c4:	50                   	push   %eax
  8015c5:	e8 e6 0b 00 00       	call   8021b0 <initialize_MemBlocksList>
  8015ca:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8015cd:	a1 48 41 80 00       	mov    0x804148,%eax
  8015d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8015d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015d9:	75 14                	jne    8015ef <initialize_dyn_block_system+0xe7>
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	68 95 3c 80 00       	push   $0x803c95
  8015e3:	6a 2b                	push   $0x2b
  8015e5:	68 b3 3c 80 00       	push   $0x803cb3
  8015ea:	e8 aa ee ff ff       	call   800499 <_panic>
  8015ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015f2:	8b 00                	mov    (%eax),%eax
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	74 10                	je     801608 <initialize_dyn_block_system+0x100>
  8015f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015fb:	8b 00                	mov    (%eax),%eax
  8015fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801600:	8b 52 04             	mov    0x4(%edx),%edx
  801603:	89 50 04             	mov    %edx,0x4(%eax)
  801606:	eb 0b                	jmp    801613 <initialize_dyn_block_system+0x10b>
  801608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80160b:	8b 40 04             	mov    0x4(%eax),%eax
  80160e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801616:	8b 40 04             	mov    0x4(%eax),%eax
  801619:	85 c0                	test   %eax,%eax
  80161b:	74 0f                	je     80162c <initialize_dyn_block_system+0x124>
  80161d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801620:	8b 40 04             	mov    0x4(%eax),%eax
  801623:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801626:	8b 12                	mov    (%edx),%edx
  801628:	89 10                	mov    %edx,(%eax)
  80162a:	eb 0a                	jmp    801636 <initialize_dyn_block_system+0x12e>
  80162c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80162f:	8b 00                	mov    (%eax),%eax
  801631:	a3 48 41 80 00       	mov    %eax,0x804148
  801636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801639:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80163f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801642:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801649:	a1 54 41 80 00       	mov    0x804154,%eax
  80164e:	48                   	dec    %eax
  80164f:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801657:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80165e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801661:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801668:	83 ec 0c             	sub    $0xc,%esp
  80166b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80166e:	e8 d2 13 00 00       	call   802a45 <insert_sorted_with_merge_freeList>
  801673:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801676:	90                   	nop
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80167f:	e8 53 fe ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801684:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801688:	75 07                	jne    801691 <malloc+0x18>
  80168a:	b8 00 00 00 00       	mov    $0x0,%eax
  80168f:	eb 61                	jmp    8016f2 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801691:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801698:	8b 55 08             	mov    0x8(%ebp),%edx
  80169b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169e:	01 d0                	add    %edx,%eax
  8016a0:	48                   	dec    %eax
  8016a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	f7 75 f4             	divl   -0xc(%ebp)
  8016af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b2:	29 d0                	sub    %edx,%eax
  8016b4:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016b7:	e8 3c 08 00 00       	call   801ef8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	74 2d                	je     8016ed <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8016c0:	83 ec 0c             	sub    $0xc,%esp
  8016c3:	ff 75 08             	pushl  0x8(%ebp)
  8016c6:	e8 3e 0f 00 00       	call   802609 <alloc_block_FF>
  8016cb:	83 c4 10             	add    $0x10,%esp
  8016ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8016d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016d5:	74 16                	je     8016ed <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8016d7:	83 ec 0c             	sub    $0xc,%esp
  8016da:	ff 75 ec             	pushl  -0x14(%ebp)
  8016dd:	e8 48 0c 00 00       	call   80232a <insert_sorted_allocList>
  8016e2:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8016e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e8:	8b 40 08             	mov    0x8(%eax),%eax
  8016eb:	eb 05                	jmp    8016f2 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801703:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801708:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	83 ec 08             	sub    $0x8,%esp
  801711:	50                   	push   %eax
  801712:	68 40 40 80 00       	push   $0x804040
  801717:	e8 71 0b 00 00       	call   80228d <find_block>
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801725:	8b 50 0c             	mov    0xc(%eax),%edx
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	83 ec 08             	sub    $0x8,%esp
  80172e:	52                   	push   %edx
  80172f:	50                   	push   %eax
  801730:	e8 bd 03 00 00       	call   801af2 <sys_free_user_mem>
  801735:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801738:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80173c:	75 14                	jne    801752 <free+0x5e>
  80173e:	83 ec 04             	sub    $0x4,%esp
  801741:	68 95 3c 80 00       	push   $0x803c95
  801746:	6a 71                	push   $0x71
  801748:	68 b3 3c 80 00       	push   $0x803cb3
  80174d:	e8 47 ed ff ff       	call   800499 <_panic>
  801752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801755:	8b 00                	mov    (%eax),%eax
  801757:	85 c0                	test   %eax,%eax
  801759:	74 10                	je     80176b <free+0x77>
  80175b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175e:	8b 00                	mov    (%eax),%eax
  801760:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801763:	8b 52 04             	mov    0x4(%edx),%edx
  801766:	89 50 04             	mov    %edx,0x4(%eax)
  801769:	eb 0b                	jmp    801776 <free+0x82>
  80176b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176e:	8b 40 04             	mov    0x4(%eax),%eax
  801771:	a3 44 40 80 00       	mov    %eax,0x804044
  801776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801779:	8b 40 04             	mov    0x4(%eax),%eax
  80177c:	85 c0                	test   %eax,%eax
  80177e:	74 0f                	je     80178f <free+0x9b>
  801780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801783:	8b 40 04             	mov    0x4(%eax),%eax
  801786:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801789:	8b 12                	mov    (%edx),%edx
  80178b:	89 10                	mov    %edx,(%eax)
  80178d:	eb 0a                	jmp    801799 <free+0xa5>
  80178f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801792:	8b 00                	mov    (%eax),%eax
  801794:	a3 40 40 80 00       	mov    %eax,0x804040
  801799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017ac:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017b1:	48                   	dec    %eax
  8017b2:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8017b7:	83 ec 0c             	sub    $0xc,%esp
  8017ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8017bd:	e8 83 12 00 00       	call   802a45 <insert_sorted_with_merge_freeList>
  8017c2:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8017c5:	90                   	nop
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 28             	sub    $0x28,%esp
  8017ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d1:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017d4:	e8 fe fc ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017dd:	75 0a                	jne    8017e9 <smalloc+0x21>
  8017df:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e4:	e9 86 00 00 00       	jmp    80186f <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8017e9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8017f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f6:	01 d0                	add    %edx,%eax
  8017f8:	48                   	dec    %eax
  8017f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801804:	f7 75 f4             	divl   -0xc(%ebp)
  801807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180a:	29 d0                	sub    %edx,%eax
  80180c:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80180f:	e8 e4 06 00 00       	call   801ef8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801814:	85 c0                	test   %eax,%eax
  801816:	74 52                	je     80186a <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801818:	83 ec 0c             	sub    $0xc,%esp
  80181b:	ff 75 0c             	pushl  0xc(%ebp)
  80181e:	e8 e6 0d 00 00       	call   802609 <alloc_block_FF>
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801829:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80182d:	75 07                	jne    801836 <smalloc+0x6e>
			return NULL ;
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
  801834:	eb 39                	jmp    80186f <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801836:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801839:	8b 40 08             	mov    0x8(%eax),%eax
  80183c:	89 c2                	mov    %eax,%edx
  80183e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801842:	52                   	push   %edx
  801843:	50                   	push   %eax
  801844:	ff 75 0c             	pushl  0xc(%ebp)
  801847:	ff 75 08             	pushl  0x8(%ebp)
  80184a:	e8 2e 04 00 00       	call   801c7d <sys_createSharedObject>
  80184f:	83 c4 10             	add    $0x10,%esp
  801852:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801855:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801859:	79 07                	jns    801862 <smalloc+0x9a>
			return (void*)NULL ;
  80185b:	b8 00 00 00 00       	mov    $0x0,%eax
  801860:	eb 0d                	jmp    80186f <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801865:	8b 40 08             	mov    0x8(%eax),%eax
  801868:	eb 05                	jmp    80186f <smalloc+0xa7>
		}
		return (void*)NULL ;
  80186a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801877:	e8 5b fc ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80187c:	83 ec 08             	sub    $0x8,%esp
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	ff 75 08             	pushl  0x8(%ebp)
  801885:	e8 1d 04 00 00       	call   801ca7 <sys_getSizeOfSharedObject>
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801894:	75 0a                	jne    8018a0 <sget+0x2f>
			return NULL ;
  801896:	b8 00 00 00 00       	mov    $0x0,%eax
  80189b:	e9 83 00 00 00       	jmp    801923 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8018a0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ad:	01 d0                	add    %edx,%eax
  8018af:	48                   	dec    %eax
  8018b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bb:	f7 75 f0             	divl   -0x10(%ebp)
  8018be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c1:	29 d0                	sub    %edx,%eax
  8018c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018c6:	e8 2d 06 00 00       	call   801ef8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	74 4f                	je     80191e <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8018cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d2:	83 ec 0c             	sub    $0xc,%esp
  8018d5:	50                   	push   %eax
  8018d6:	e8 2e 0d 00 00       	call   802609 <alloc_block_FF>
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8018e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018e5:	75 07                	jne    8018ee <sget+0x7d>
					return (void*)NULL ;
  8018e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ec:	eb 35                	jmp    801923 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8018ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f1:	8b 40 08             	mov    0x8(%eax),%eax
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	50                   	push   %eax
  8018f8:	ff 75 0c             	pushl  0xc(%ebp)
  8018fb:	ff 75 08             	pushl  0x8(%ebp)
  8018fe:	e8 c1 03 00 00       	call   801cc4 <sys_getSharedObject>
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801909:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80190d:	79 07                	jns    801916 <sget+0xa5>
				return (void*)NULL ;
  80190f:	b8 00 00 00 00       	mov    $0x0,%eax
  801914:	eb 0d                	jmp    801923 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801916:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801919:	8b 40 08             	mov    0x8(%eax),%eax
  80191c:	eb 05                	jmp    801923 <sget+0xb2>


		}
	return (void*)NULL ;
  80191e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80192b:	e8 a7 fb ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801930:	83 ec 04             	sub    $0x4,%esp
  801933:	68 c0 3c 80 00       	push   $0x803cc0
  801938:	68 f9 00 00 00       	push   $0xf9
  80193d:	68 b3 3c 80 00       	push   $0x803cb3
  801942:	e8 52 eb ff ff       	call   800499 <_panic>

00801947 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	68 e8 3c 80 00       	push   $0x803ce8
  801955:	68 0d 01 00 00       	push   $0x10d
  80195a:	68 b3 3c 80 00       	push   $0x803cb3
  80195f:	e8 35 eb ff ff       	call   800499 <_panic>

00801964 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80196a:	83 ec 04             	sub    $0x4,%esp
  80196d:	68 0c 3d 80 00       	push   $0x803d0c
  801972:	68 18 01 00 00       	push   $0x118
  801977:	68 b3 3c 80 00       	push   $0x803cb3
  80197c:	e8 18 eb ff ff       	call   800499 <_panic>

00801981 <shrink>:

}
void shrink(uint32 newSize)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801987:	83 ec 04             	sub    $0x4,%esp
  80198a:	68 0c 3d 80 00       	push   $0x803d0c
  80198f:	68 1d 01 00 00       	push   $0x11d
  801994:	68 b3 3c 80 00       	push   $0x803cb3
  801999:	e8 fb ea ff ff       	call   800499 <_panic>

0080199e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019a4:	83 ec 04             	sub    $0x4,%esp
  8019a7:	68 0c 3d 80 00       	push   $0x803d0c
  8019ac:	68 22 01 00 00       	push   $0x122
  8019b1:	68 b3 3c 80 00       	push   $0x803cb3
  8019b6:	e8 de ea ff ff       	call   800499 <_panic>

008019bb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	57                   	push   %edi
  8019bf:	56                   	push   %esi
  8019c0:	53                   	push   %ebx
  8019c1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019d0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019d3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019d6:	cd 30                	int    $0x30
  8019d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019de:	83 c4 10             	add    $0x10,%esp
  8019e1:	5b                   	pop    %ebx
  8019e2:	5e                   	pop    %esi
  8019e3:	5f                   	pop    %edi
  8019e4:	5d                   	pop    %ebp
  8019e5:	c3                   	ret    

008019e6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019f2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	52                   	push   %edx
  8019fe:	ff 75 0c             	pushl  0xc(%ebp)
  801a01:	50                   	push   %eax
  801a02:	6a 00                	push   $0x0
  801a04:	e8 b2 ff ff ff       	call   8019bb <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	90                   	nop
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_cgetc>:

int
sys_cgetc(void)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 01                	push   $0x1
  801a1e:	e8 98 ff ff ff       	call   8019bb <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	52                   	push   %edx
  801a38:	50                   	push   %eax
  801a39:	6a 05                	push   $0x5
  801a3b:	e8 7b ff ff ff       	call   8019bb <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	56                   	push   %esi
  801a49:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a4a:	8b 75 18             	mov    0x18(%ebp),%esi
  801a4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a50:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	56                   	push   %esi
  801a5a:	53                   	push   %ebx
  801a5b:	51                   	push   %ecx
  801a5c:	52                   	push   %edx
  801a5d:	50                   	push   %eax
  801a5e:	6a 06                	push   $0x6
  801a60:	e8 56 ff ff ff       	call   8019bb <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a6b:	5b                   	pop    %ebx
  801a6c:	5e                   	pop    %esi
  801a6d:	5d                   	pop    %ebp
  801a6e:	c3                   	ret    

00801a6f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	52                   	push   %edx
  801a7f:	50                   	push   %eax
  801a80:	6a 07                	push   $0x7
  801a82:	e8 34 ff ff ff       	call   8019bb <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	ff 75 0c             	pushl  0xc(%ebp)
  801a98:	ff 75 08             	pushl  0x8(%ebp)
  801a9b:	6a 08                	push   $0x8
  801a9d:	e8 19 ff ff ff       	call   8019bb <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 09                	push   $0x9
  801ab6:	e8 00 ff ff ff       	call   8019bb <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 0a                	push   $0xa
  801acf:	e8 e7 fe ff ff       	call   8019bb <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 0b                	push   $0xb
  801ae8:	e8 ce fe ff ff       	call   8019bb <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	ff 75 08             	pushl  0x8(%ebp)
  801b01:	6a 0f                	push   $0xf
  801b03:	e8 b3 fe ff ff       	call   8019bb <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
	return;
  801b0b:	90                   	nop
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	6a 10                	push   $0x10
  801b1f:	e8 97 fe ff ff       	call   8019bb <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
	return ;
  801b27:	90                   	nop
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	ff 75 10             	pushl  0x10(%ebp)
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	6a 11                	push   $0x11
  801b3c:	e8 7a fe ff ff       	call   8019bb <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
	return ;
  801b44:	90                   	nop
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 0c                	push   $0xc
  801b56:	e8 60 fe ff ff       	call   8019bb <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	ff 75 08             	pushl  0x8(%ebp)
  801b6e:	6a 0d                	push   $0xd
  801b70:	e8 46 fe ff ff       	call   8019bb <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 0e                	push   $0xe
  801b89:	e8 2d fe ff ff       	call   8019bb <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	90                   	nop
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 13                	push   $0x13
  801ba3:	e8 13 fe ff ff       	call   8019bb <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 14                	push   $0x14
  801bbd:	e8 f9 fd ff ff       	call   8019bb <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	90                   	nop
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 04             	sub    $0x4,%esp
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bd4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	50                   	push   %eax
  801be1:	6a 15                	push   $0x15
  801be3:	e8 d3 fd ff ff       	call   8019bb <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	90                   	nop
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 16                	push   $0x16
  801bfd:	e8 b9 fd ff ff       	call   8019bb <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	90                   	nop
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	ff 75 0c             	pushl  0xc(%ebp)
  801c17:	50                   	push   %eax
  801c18:	6a 17                	push   $0x17
  801c1a:	e8 9c fd ff ff       	call   8019bb <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	52                   	push   %edx
  801c34:	50                   	push   %eax
  801c35:	6a 1a                	push   $0x1a
  801c37:	e8 7f fd ff ff       	call   8019bb <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	52                   	push   %edx
  801c51:	50                   	push   %eax
  801c52:	6a 18                	push   $0x18
  801c54:	e8 62 fd ff ff       	call   8019bb <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	90                   	nop
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	52                   	push   %edx
  801c6f:	50                   	push   %eax
  801c70:	6a 19                	push   $0x19
  801c72:	e8 44 fd ff ff       	call   8019bb <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	90                   	nop
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	8b 45 10             	mov    0x10(%ebp),%eax
  801c86:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c89:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c8c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	6a 00                	push   $0x0
  801c95:	51                   	push   %ecx
  801c96:	52                   	push   %edx
  801c97:	ff 75 0c             	pushl  0xc(%ebp)
  801c9a:	50                   	push   %eax
  801c9b:	6a 1b                	push   $0x1b
  801c9d:	e8 19 fd ff ff       	call   8019bb <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801caa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	52                   	push   %edx
  801cb7:	50                   	push   %eax
  801cb8:	6a 1c                	push   $0x1c
  801cba:	e8 fc fc ff ff       	call   8019bb <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	51                   	push   %ecx
  801cd5:	52                   	push   %edx
  801cd6:	50                   	push   %eax
  801cd7:	6a 1d                	push   $0x1d
  801cd9:	e8 dd fc ff ff       	call   8019bb <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	52                   	push   %edx
  801cf3:	50                   	push   %eax
  801cf4:	6a 1e                	push   $0x1e
  801cf6:	e8 c0 fc ff ff       	call   8019bb <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 1f                	push   $0x1f
  801d0f:	e8 a7 fc ff ff       	call   8019bb <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	6a 00                	push   $0x0
  801d21:	ff 75 14             	pushl  0x14(%ebp)
  801d24:	ff 75 10             	pushl  0x10(%ebp)
  801d27:	ff 75 0c             	pushl  0xc(%ebp)
  801d2a:	50                   	push   %eax
  801d2b:	6a 20                	push   $0x20
  801d2d:	e8 89 fc ff ff       	call   8019bb <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	50                   	push   %eax
  801d46:	6a 21                	push   $0x21
  801d48:	e8 6e fc ff ff       	call   8019bb <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	90                   	nop
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	50                   	push   %eax
  801d62:	6a 22                	push   $0x22
  801d64:	e8 52 fc ff ff       	call   8019bb <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 02                	push   $0x2
  801d7d:	e8 39 fc ff ff       	call   8019bb <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 03                	push   $0x3
  801d96:	e8 20 fc ff ff       	call   8019bb <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 04                	push   $0x4
  801daf:	e8 07 fc ff ff       	call   8019bb <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_exit_env>:


void sys_exit_env(void)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 23                	push   $0x23
  801dc8:	e8 ee fb ff ff       	call   8019bb <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	90                   	nop
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dd9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ddc:	8d 50 04             	lea    0x4(%eax),%edx
  801ddf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	52                   	push   %edx
  801de9:	50                   	push   %eax
  801dea:	6a 24                	push   $0x24
  801dec:	e8 ca fb ff ff       	call   8019bb <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
	return result;
  801df4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dfa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dfd:	89 01                	mov    %eax,(%ecx)
  801dff:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e02:	8b 45 08             	mov    0x8(%ebp),%eax
  801e05:	c9                   	leave  
  801e06:	c2 04 00             	ret    $0x4

00801e09 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	ff 75 10             	pushl  0x10(%ebp)
  801e13:	ff 75 0c             	pushl  0xc(%ebp)
  801e16:	ff 75 08             	pushl  0x8(%ebp)
  801e19:	6a 12                	push   $0x12
  801e1b:	e8 9b fb ff ff       	call   8019bb <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
	return ;
  801e23:	90                   	nop
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 25                	push   $0x25
  801e35:	e8 81 fb ff ff       	call   8019bb <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	83 ec 04             	sub    $0x4,%esp
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e4b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	50                   	push   %eax
  801e58:	6a 26                	push   $0x26
  801e5a:	e8 5c fb ff ff       	call   8019bb <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e62:	90                   	nop
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <rsttst>:
void rsttst()
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 28                	push   $0x28
  801e74:	e8 42 fb ff ff       	call   8019bb <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7c:	90                   	nop
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 04             	sub    $0x4,%esp
  801e85:	8b 45 14             	mov    0x14(%ebp),%eax
  801e88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e8b:	8b 55 18             	mov    0x18(%ebp),%edx
  801e8e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e92:	52                   	push   %edx
  801e93:	50                   	push   %eax
  801e94:	ff 75 10             	pushl  0x10(%ebp)
  801e97:	ff 75 0c             	pushl  0xc(%ebp)
  801e9a:	ff 75 08             	pushl  0x8(%ebp)
  801e9d:	6a 27                	push   $0x27
  801e9f:	e8 17 fb ff ff       	call   8019bb <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea7:	90                   	nop
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <chktst>:
void chktst(uint32 n)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	ff 75 08             	pushl  0x8(%ebp)
  801eb8:	6a 29                	push   $0x29
  801eba:	e8 fc fa ff ff       	call   8019bb <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec2:	90                   	nop
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <inctst>:

void inctst()
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 2a                	push   $0x2a
  801ed4:	e8 e2 fa ff ff       	call   8019bb <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
	return ;
  801edc:	90                   	nop
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <gettst>:
uint32 gettst()
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 2b                	push   $0x2b
  801eee:	e8 c8 fa ff ff       	call   8019bb <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 2c                	push   $0x2c
  801f0a:	e8 ac fa ff ff       	call   8019bb <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
  801f12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f15:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f19:	75 07                	jne    801f22 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f1b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f20:	eb 05                	jmp    801f27 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 2c                	push   $0x2c
  801f3b:	e8 7b fa ff ff       	call   8019bb <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
  801f43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f46:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f4a:	75 07                	jne    801f53 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f4c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f51:	eb 05                	jmp    801f58 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 2c                	push   $0x2c
  801f6c:	e8 4a fa ff ff       	call   8019bb <syscall>
  801f71:	83 c4 18             	add    $0x18,%esp
  801f74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f77:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f7b:	75 07                	jne    801f84 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f82:	eb 05                	jmp    801f89 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 2c                	push   $0x2c
  801f9d:	e8 19 fa ff ff       	call   8019bb <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
  801fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fa8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fac:	75 07                	jne    801fb5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fae:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb3:	eb 05                	jmp    801fba <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	ff 75 08             	pushl  0x8(%ebp)
  801fca:	6a 2d                	push   $0x2d
  801fcc:	e8 ea f9 ff ff       	call   8019bb <syscall>
  801fd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd4:	90                   	nop
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fdb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fde:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	6a 00                	push   $0x0
  801fe9:	53                   	push   %ebx
  801fea:	51                   	push   %ecx
  801feb:	52                   	push   %edx
  801fec:	50                   	push   %eax
  801fed:	6a 2e                	push   $0x2e
  801fef:	e8 c7 f9 ff ff       	call   8019bb <syscall>
  801ff4:	83 c4 18             	add    $0x18,%esp
}
  801ff7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	52                   	push   %edx
  80200c:	50                   	push   %eax
  80200d:	6a 2f                	push   $0x2f
  80200f:	e8 a7 f9 ff ff       	call   8019bb <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80201f:	83 ec 0c             	sub    $0xc,%esp
  802022:	68 1c 3d 80 00       	push   $0x803d1c
  802027:	e8 21 e7 ff ff       	call   80074d <cprintf>
  80202c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80202f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802036:	83 ec 0c             	sub    $0xc,%esp
  802039:	68 48 3d 80 00       	push   $0x803d48
  80203e:	e8 0a e7 ff ff       	call   80074d <cprintf>
  802043:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802046:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80204a:	a1 38 41 80 00       	mov    0x804138,%eax
  80204f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802052:	eb 56                	jmp    8020aa <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802054:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802058:	74 1c                	je     802076 <print_mem_block_lists+0x5d>
  80205a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205d:	8b 50 08             	mov    0x8(%eax),%edx
  802060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802063:	8b 48 08             	mov    0x8(%eax),%ecx
  802066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802069:	8b 40 0c             	mov    0xc(%eax),%eax
  80206c:	01 c8                	add    %ecx,%eax
  80206e:	39 c2                	cmp    %eax,%edx
  802070:	73 04                	jae    802076 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802072:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802079:	8b 50 08             	mov    0x8(%eax),%edx
  80207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207f:	8b 40 0c             	mov    0xc(%eax),%eax
  802082:	01 c2                	add    %eax,%edx
  802084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802087:	8b 40 08             	mov    0x8(%eax),%eax
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	52                   	push   %edx
  80208e:	50                   	push   %eax
  80208f:	68 5d 3d 80 00       	push   $0x803d5d
  802094:	e8 b4 e6 ff ff       	call   80074d <cprintf>
  802099:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020a2:	a1 40 41 80 00       	mov    0x804140,%eax
  8020a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ae:	74 07                	je     8020b7 <print_mem_block_lists+0x9e>
  8020b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b3:	8b 00                	mov    (%eax),%eax
  8020b5:	eb 05                	jmp    8020bc <print_mem_block_lists+0xa3>
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bc:	a3 40 41 80 00       	mov    %eax,0x804140
  8020c1:	a1 40 41 80 00       	mov    0x804140,%eax
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	75 8a                	jne    802054 <print_mem_block_lists+0x3b>
  8020ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ce:	75 84                	jne    802054 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8020d0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020d4:	75 10                	jne    8020e6 <print_mem_block_lists+0xcd>
  8020d6:	83 ec 0c             	sub    $0xc,%esp
  8020d9:	68 6c 3d 80 00       	push   $0x803d6c
  8020de:	e8 6a e6 ff ff       	call   80074d <cprintf>
  8020e3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020ed:	83 ec 0c             	sub    $0xc,%esp
  8020f0:	68 90 3d 80 00       	push   $0x803d90
  8020f5:	e8 53 e6 ff ff       	call   80074d <cprintf>
  8020fa:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020fd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802101:	a1 40 40 80 00       	mov    0x804040,%eax
  802106:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802109:	eb 56                	jmp    802161 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80210b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80210f:	74 1c                	je     80212d <print_mem_block_lists+0x114>
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	8b 50 08             	mov    0x8(%eax),%edx
  802117:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211a:	8b 48 08             	mov    0x8(%eax),%ecx
  80211d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802120:	8b 40 0c             	mov    0xc(%eax),%eax
  802123:	01 c8                	add    %ecx,%eax
  802125:	39 c2                	cmp    %eax,%edx
  802127:	73 04                	jae    80212d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802129:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	8b 50 08             	mov    0x8(%eax),%edx
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	8b 40 0c             	mov    0xc(%eax),%eax
  802139:	01 c2                	add    %eax,%edx
  80213b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213e:	8b 40 08             	mov    0x8(%eax),%eax
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	52                   	push   %edx
  802145:	50                   	push   %eax
  802146:	68 5d 3d 80 00       	push   $0x803d5d
  80214b:	e8 fd e5 ff ff       	call   80074d <cprintf>
  802150:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802156:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802159:	a1 48 40 80 00       	mov    0x804048,%eax
  80215e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802161:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802165:	74 07                	je     80216e <print_mem_block_lists+0x155>
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	8b 00                	mov    (%eax),%eax
  80216c:	eb 05                	jmp    802173 <print_mem_block_lists+0x15a>
  80216e:	b8 00 00 00 00       	mov    $0x0,%eax
  802173:	a3 48 40 80 00       	mov    %eax,0x804048
  802178:	a1 48 40 80 00       	mov    0x804048,%eax
  80217d:	85 c0                	test   %eax,%eax
  80217f:	75 8a                	jne    80210b <print_mem_block_lists+0xf2>
  802181:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802185:	75 84                	jne    80210b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802187:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80218b:	75 10                	jne    80219d <print_mem_block_lists+0x184>
  80218d:	83 ec 0c             	sub    $0xc,%esp
  802190:	68 a8 3d 80 00       	push   $0x803da8
  802195:	e8 b3 e5 ff ff       	call   80074d <cprintf>
  80219a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80219d:	83 ec 0c             	sub    $0xc,%esp
  8021a0:	68 1c 3d 80 00       	push   $0x803d1c
  8021a5:	e8 a3 e5 ff ff       	call   80074d <cprintf>
  8021aa:	83 c4 10             	add    $0x10,%esp

}
  8021ad:	90                   	nop
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8021b6:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8021bd:	00 00 00 
  8021c0:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8021c7:	00 00 00 
  8021ca:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8021d1:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8021d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021db:	e9 9e 00 00 00       	jmp    80227e <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8021e0:	a1 50 40 80 00       	mov    0x804050,%eax
  8021e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e8:	c1 e2 04             	shl    $0x4,%edx
  8021eb:	01 d0                	add    %edx,%eax
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	75 14                	jne    802205 <initialize_MemBlocksList+0x55>
  8021f1:	83 ec 04             	sub    $0x4,%esp
  8021f4:	68 d0 3d 80 00       	push   $0x803dd0
  8021f9:	6a 43                	push   $0x43
  8021fb:	68 f3 3d 80 00       	push   $0x803df3
  802200:	e8 94 e2 ff ff       	call   800499 <_panic>
  802205:	a1 50 40 80 00       	mov    0x804050,%eax
  80220a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220d:	c1 e2 04             	shl    $0x4,%edx
  802210:	01 d0                	add    %edx,%eax
  802212:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802218:	89 10                	mov    %edx,(%eax)
  80221a:	8b 00                	mov    (%eax),%eax
  80221c:	85 c0                	test   %eax,%eax
  80221e:	74 18                	je     802238 <initialize_MemBlocksList+0x88>
  802220:	a1 48 41 80 00       	mov    0x804148,%eax
  802225:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80222b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80222e:	c1 e1 04             	shl    $0x4,%ecx
  802231:	01 ca                	add    %ecx,%edx
  802233:	89 50 04             	mov    %edx,0x4(%eax)
  802236:	eb 12                	jmp    80224a <initialize_MemBlocksList+0x9a>
  802238:	a1 50 40 80 00       	mov    0x804050,%eax
  80223d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802240:	c1 e2 04             	shl    $0x4,%edx
  802243:	01 d0                	add    %edx,%eax
  802245:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80224a:	a1 50 40 80 00       	mov    0x804050,%eax
  80224f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802252:	c1 e2 04             	shl    $0x4,%edx
  802255:	01 d0                	add    %edx,%eax
  802257:	a3 48 41 80 00       	mov    %eax,0x804148
  80225c:	a1 50 40 80 00       	mov    0x804050,%eax
  802261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802264:	c1 e2 04             	shl    $0x4,%edx
  802267:	01 d0                	add    %edx,%eax
  802269:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802270:	a1 54 41 80 00       	mov    0x804154,%eax
  802275:	40                   	inc    %eax
  802276:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80227b:	ff 45 f4             	incl   -0xc(%ebp)
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	3b 45 08             	cmp    0x8(%ebp),%eax
  802284:	0f 82 56 ff ff ff    	jb     8021e0 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80228a:	90                   	nop
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802293:	a1 38 41 80 00       	mov    0x804138,%eax
  802298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80229b:	eb 18                	jmp    8022b5 <find_block+0x28>
	{
		if (ele->sva==va)
  80229d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022a0:	8b 40 08             	mov    0x8(%eax),%eax
  8022a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022a6:	75 05                	jne    8022ad <find_block+0x20>
			return ele;
  8022a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ab:	eb 7b                	jmp    802328 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8022ad:	a1 40 41 80 00       	mov    0x804140,%eax
  8022b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022b9:	74 07                	je     8022c2 <find_block+0x35>
  8022bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022be:	8b 00                	mov    (%eax),%eax
  8022c0:	eb 05                	jmp    8022c7 <find_block+0x3a>
  8022c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c7:	a3 40 41 80 00       	mov    %eax,0x804140
  8022cc:	a1 40 41 80 00       	mov    0x804140,%eax
  8022d1:	85 c0                	test   %eax,%eax
  8022d3:	75 c8                	jne    80229d <find_block+0x10>
  8022d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022d9:	75 c2                	jne    80229d <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8022db:	a1 40 40 80 00       	mov    0x804040,%eax
  8022e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022e3:	eb 18                	jmp    8022fd <find_block+0x70>
	{
		if (ele->sva==va)
  8022e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e8:	8b 40 08             	mov    0x8(%eax),%eax
  8022eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022ee:	75 05                	jne    8022f5 <find_block+0x68>
					return ele;
  8022f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f3:	eb 33                	jmp    802328 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8022f5:	a1 48 40 80 00       	mov    0x804048,%eax
  8022fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802301:	74 07                	je     80230a <find_block+0x7d>
  802303:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802306:	8b 00                	mov    (%eax),%eax
  802308:	eb 05                	jmp    80230f <find_block+0x82>
  80230a:	b8 00 00 00 00       	mov    $0x0,%eax
  80230f:	a3 48 40 80 00       	mov    %eax,0x804048
  802314:	a1 48 40 80 00       	mov    0x804048,%eax
  802319:	85 c0                	test   %eax,%eax
  80231b:	75 c8                	jne    8022e5 <find_block+0x58>
  80231d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802321:	75 c2                	jne    8022e5 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802323:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802330:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802335:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802338:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80233c:	75 62                	jne    8023a0 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80233e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802342:	75 14                	jne    802358 <insert_sorted_allocList+0x2e>
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	68 d0 3d 80 00       	push   $0x803dd0
  80234c:	6a 69                	push   $0x69
  80234e:	68 f3 3d 80 00       	push   $0x803df3
  802353:	e8 41 e1 ff ff       	call   800499 <_panic>
  802358:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	89 10                	mov    %edx,(%eax)
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	8b 00                	mov    (%eax),%eax
  802368:	85 c0                	test   %eax,%eax
  80236a:	74 0d                	je     802379 <insert_sorted_allocList+0x4f>
  80236c:	a1 40 40 80 00       	mov    0x804040,%eax
  802371:	8b 55 08             	mov    0x8(%ebp),%edx
  802374:	89 50 04             	mov    %edx,0x4(%eax)
  802377:	eb 08                	jmp    802381 <insert_sorted_allocList+0x57>
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	a3 44 40 80 00       	mov    %eax,0x804044
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	a3 40 40 80 00       	mov    %eax,0x804040
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802393:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802398:	40                   	inc    %eax
  802399:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80239e:	eb 72                	jmp    802412 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8023a0:	a1 40 40 80 00       	mov    0x804040,%eax
  8023a5:	8b 50 08             	mov    0x8(%eax),%edx
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	8b 40 08             	mov    0x8(%eax),%eax
  8023ae:	39 c2                	cmp    %eax,%edx
  8023b0:	76 60                	jbe    802412 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8023b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023b6:	75 14                	jne    8023cc <insert_sorted_allocList+0xa2>
  8023b8:	83 ec 04             	sub    $0x4,%esp
  8023bb:	68 d0 3d 80 00       	push   $0x803dd0
  8023c0:	6a 6d                	push   $0x6d
  8023c2:	68 f3 3d 80 00       	push   $0x803df3
  8023c7:	e8 cd e0 ff ff       	call   800499 <_panic>
  8023cc:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	89 10                	mov    %edx,(%eax)
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	8b 00                	mov    (%eax),%eax
  8023dc:	85 c0                	test   %eax,%eax
  8023de:	74 0d                	je     8023ed <insert_sorted_allocList+0xc3>
  8023e0:	a1 40 40 80 00       	mov    0x804040,%eax
  8023e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e8:	89 50 04             	mov    %edx,0x4(%eax)
  8023eb:	eb 08                	jmp    8023f5 <insert_sorted_allocList+0xcb>
  8023ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f0:	a3 44 40 80 00       	mov    %eax,0x804044
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	a3 40 40 80 00       	mov    %eax,0x804040
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802407:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80240c:	40                   	inc    %eax
  80240d:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802412:	a1 40 40 80 00       	mov    0x804040,%eax
  802417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80241a:	e9 b9 01 00 00       	jmp    8025d8 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	8b 50 08             	mov    0x8(%eax),%edx
  802425:	a1 40 40 80 00       	mov    0x804040,%eax
  80242a:	8b 40 08             	mov    0x8(%eax),%eax
  80242d:	39 c2                	cmp    %eax,%edx
  80242f:	76 7c                	jbe    8024ad <insert_sorted_allocList+0x183>
  802431:	8b 45 08             	mov    0x8(%ebp),%eax
  802434:	8b 50 08             	mov    0x8(%eax),%edx
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 40 08             	mov    0x8(%eax),%eax
  80243d:	39 c2                	cmp    %eax,%edx
  80243f:	73 6c                	jae    8024ad <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802445:	74 06                	je     80244d <insert_sorted_allocList+0x123>
  802447:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80244b:	75 14                	jne    802461 <insert_sorted_allocList+0x137>
  80244d:	83 ec 04             	sub    $0x4,%esp
  802450:	68 0c 3e 80 00       	push   $0x803e0c
  802455:	6a 75                	push   $0x75
  802457:	68 f3 3d 80 00       	push   $0x803df3
  80245c:	e8 38 e0 ff ff       	call   800499 <_panic>
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 50 04             	mov    0x4(%eax),%edx
  802467:	8b 45 08             	mov    0x8(%ebp),%eax
  80246a:	89 50 04             	mov    %edx,0x4(%eax)
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802473:	89 10                	mov    %edx,(%eax)
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 40 04             	mov    0x4(%eax),%eax
  80247b:	85 c0                	test   %eax,%eax
  80247d:	74 0d                	je     80248c <insert_sorted_allocList+0x162>
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 40 04             	mov    0x4(%eax),%eax
  802485:	8b 55 08             	mov    0x8(%ebp),%edx
  802488:	89 10                	mov    %edx,(%eax)
  80248a:	eb 08                	jmp    802494 <insert_sorted_allocList+0x16a>
  80248c:	8b 45 08             	mov    0x8(%ebp),%eax
  80248f:	a3 40 40 80 00       	mov    %eax,0x804040
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 55 08             	mov    0x8(%ebp),%edx
  80249a:	89 50 04             	mov    %edx,0x4(%eax)
  80249d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024a2:	40                   	inc    %eax
  8024a3:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8024a8:	e9 59 01 00 00       	jmp    802606 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	8b 50 08             	mov    0x8(%eax),%edx
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 40 08             	mov    0x8(%eax),%eax
  8024b9:	39 c2                	cmp    %eax,%edx
  8024bb:	0f 86 98 00 00 00    	jbe    802559 <insert_sorted_allocList+0x22f>
  8024c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c4:	8b 50 08             	mov    0x8(%eax),%edx
  8024c7:	a1 44 40 80 00       	mov    0x804044,%eax
  8024cc:	8b 40 08             	mov    0x8(%eax),%eax
  8024cf:	39 c2                	cmp    %eax,%edx
  8024d1:	0f 83 82 00 00 00    	jae    802559 <insert_sorted_allocList+0x22f>
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	8b 50 08             	mov    0x8(%eax),%edx
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	8b 00                	mov    (%eax),%eax
  8024e2:	8b 40 08             	mov    0x8(%eax),%eax
  8024e5:	39 c2                	cmp    %eax,%edx
  8024e7:	73 70                	jae    802559 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8024e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ed:	74 06                	je     8024f5 <insert_sorted_allocList+0x1cb>
  8024ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024f3:	75 14                	jne    802509 <insert_sorted_allocList+0x1df>
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	68 44 3e 80 00       	push   $0x803e44
  8024fd:	6a 7c                	push   $0x7c
  8024ff:	68 f3 3d 80 00       	push   $0x803df3
  802504:	e8 90 df ff ff       	call   800499 <_panic>
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 10                	mov    (%eax),%edx
  80250e:	8b 45 08             	mov    0x8(%ebp),%eax
  802511:	89 10                	mov    %edx,(%eax)
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	8b 00                	mov    (%eax),%eax
  802518:	85 c0                	test   %eax,%eax
  80251a:	74 0b                	je     802527 <insert_sorted_allocList+0x1fd>
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 00                	mov    (%eax),%eax
  802521:	8b 55 08             	mov    0x8(%ebp),%edx
  802524:	89 50 04             	mov    %edx,0x4(%eax)
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 55 08             	mov    0x8(%ebp),%edx
  80252d:	89 10                	mov    %edx,(%eax)
  80252f:	8b 45 08             	mov    0x8(%ebp),%eax
  802532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802535:	89 50 04             	mov    %edx,0x4(%eax)
  802538:	8b 45 08             	mov    0x8(%ebp),%eax
  80253b:	8b 00                	mov    (%eax),%eax
  80253d:	85 c0                	test   %eax,%eax
  80253f:	75 08                	jne    802549 <insert_sorted_allocList+0x21f>
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	a3 44 40 80 00       	mov    %eax,0x804044
  802549:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80254e:	40                   	inc    %eax
  80254f:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802554:	e9 ad 00 00 00       	jmp    802606 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802559:	8b 45 08             	mov    0x8(%ebp),%eax
  80255c:	8b 50 08             	mov    0x8(%eax),%edx
  80255f:	a1 44 40 80 00       	mov    0x804044,%eax
  802564:	8b 40 08             	mov    0x8(%eax),%eax
  802567:	39 c2                	cmp    %eax,%edx
  802569:	76 65                	jbe    8025d0 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80256b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80256f:	75 17                	jne    802588 <insert_sorted_allocList+0x25e>
  802571:	83 ec 04             	sub    $0x4,%esp
  802574:	68 78 3e 80 00       	push   $0x803e78
  802579:	68 80 00 00 00       	push   $0x80
  80257e:	68 f3 3d 80 00       	push   $0x803df3
  802583:	e8 11 df ff ff       	call   800499 <_panic>
  802588:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80258e:	8b 45 08             	mov    0x8(%ebp),%eax
  802591:	89 50 04             	mov    %edx,0x4(%eax)
  802594:	8b 45 08             	mov    0x8(%ebp),%eax
  802597:	8b 40 04             	mov    0x4(%eax),%eax
  80259a:	85 c0                	test   %eax,%eax
  80259c:	74 0c                	je     8025aa <insert_sorted_allocList+0x280>
  80259e:	a1 44 40 80 00       	mov    0x804044,%eax
  8025a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a6:	89 10                	mov    %edx,(%eax)
  8025a8:	eb 08                	jmp    8025b2 <insert_sorted_allocList+0x288>
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	a3 40 40 80 00       	mov    %eax,0x804040
  8025b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b5:	a3 44 40 80 00       	mov    %eax,0x804044
  8025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8025c8:	40                   	inc    %eax
  8025c9:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8025ce:	eb 36                	jmp    802606 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8025d0:	a1 48 40 80 00       	mov    0x804048,%eax
  8025d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025dc:	74 07                	je     8025e5 <insert_sorted_allocList+0x2bb>
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 00                	mov    (%eax),%eax
  8025e3:	eb 05                	jmp    8025ea <insert_sorted_allocList+0x2c0>
  8025e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ea:	a3 48 40 80 00       	mov    %eax,0x804048
  8025ef:	a1 48 40 80 00       	mov    0x804048,%eax
  8025f4:	85 c0                	test   %eax,%eax
  8025f6:	0f 85 23 fe ff ff    	jne    80241f <insert_sorted_allocList+0xf5>
  8025fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802600:	0f 85 19 fe ff ff    	jne    80241f <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802606:	90                   	nop
  802607:	c9                   	leave  
  802608:	c3                   	ret    

00802609 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
  80260c:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80260f:	a1 38 41 80 00       	mov    0x804138,%eax
  802614:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802617:	e9 7c 01 00 00       	jmp    802798 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 40 0c             	mov    0xc(%eax),%eax
  802622:	3b 45 08             	cmp    0x8(%ebp),%eax
  802625:	0f 85 90 00 00 00    	jne    8026bb <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802635:	75 17                	jne    80264e <alloc_block_FF+0x45>
  802637:	83 ec 04             	sub    $0x4,%esp
  80263a:	68 9b 3e 80 00       	push   $0x803e9b
  80263f:	68 ba 00 00 00       	push   $0xba
  802644:	68 f3 3d 80 00       	push   $0x803df3
  802649:	e8 4b de ff ff       	call   800499 <_panic>
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 00                	mov    (%eax),%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	74 10                	je     802667 <alloc_block_FF+0x5e>
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 00                	mov    (%eax),%eax
  80265c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265f:	8b 52 04             	mov    0x4(%edx),%edx
  802662:	89 50 04             	mov    %edx,0x4(%eax)
  802665:	eb 0b                	jmp    802672 <alloc_block_FF+0x69>
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 40 04             	mov    0x4(%eax),%eax
  80266d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 40 04             	mov    0x4(%eax),%eax
  802678:	85 c0                	test   %eax,%eax
  80267a:	74 0f                	je     80268b <alloc_block_FF+0x82>
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 40 04             	mov    0x4(%eax),%eax
  802682:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802685:	8b 12                	mov    (%edx),%edx
  802687:	89 10                	mov    %edx,(%eax)
  802689:	eb 0a                	jmp    802695 <alloc_block_FF+0x8c>
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 00                	mov    (%eax),%eax
  802690:	a3 38 41 80 00       	mov    %eax,0x804138
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a8:	a1 44 41 80 00       	mov    0x804144,%eax
  8026ad:	48                   	dec    %eax
  8026ae:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8026b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b6:	e9 10 01 00 00       	jmp    8027cb <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c4:	0f 86 c6 00 00 00    	jbe    802790 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8026ca:	a1 48 41 80 00       	mov    0x804148,%eax
  8026cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8026d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026d6:	75 17                	jne    8026ef <alloc_block_FF+0xe6>
  8026d8:	83 ec 04             	sub    $0x4,%esp
  8026db:	68 9b 3e 80 00       	push   $0x803e9b
  8026e0:	68 c2 00 00 00       	push   $0xc2
  8026e5:	68 f3 3d 80 00       	push   $0x803df3
  8026ea:	e8 aa dd ff ff       	call   800499 <_panic>
  8026ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f2:	8b 00                	mov    (%eax),%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	74 10                	je     802708 <alloc_block_FF+0xff>
  8026f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fb:	8b 00                	mov    (%eax),%eax
  8026fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802700:	8b 52 04             	mov    0x4(%edx),%edx
  802703:	89 50 04             	mov    %edx,0x4(%eax)
  802706:	eb 0b                	jmp    802713 <alloc_block_FF+0x10a>
  802708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270b:	8b 40 04             	mov    0x4(%eax),%eax
  80270e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802716:	8b 40 04             	mov    0x4(%eax),%eax
  802719:	85 c0                	test   %eax,%eax
  80271b:	74 0f                	je     80272c <alloc_block_FF+0x123>
  80271d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802720:	8b 40 04             	mov    0x4(%eax),%eax
  802723:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802726:	8b 12                	mov    (%edx),%edx
  802728:	89 10                	mov    %edx,(%eax)
  80272a:	eb 0a                	jmp    802736 <alloc_block_FF+0x12d>
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	8b 00                	mov    (%eax),%eax
  802731:	a3 48 41 80 00       	mov    %eax,0x804148
  802736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802739:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802749:	a1 54 41 80 00       	mov    0x804154,%eax
  80274e:	48                   	dec    %eax
  80274f:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 50 08             	mov    0x8(%eax),%edx
  80275a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275d:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802763:	8b 55 08             	mov    0x8(%ebp),%edx
  802766:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 40 0c             	mov    0xc(%eax),%eax
  80276f:	2b 45 08             	sub    0x8(%ebp),%eax
  802772:	89 c2                	mov    %eax,%edx
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	8b 50 08             	mov    0x8(%eax),%edx
  802780:	8b 45 08             	mov    0x8(%ebp),%eax
  802783:	01 c2                	add    %eax,%edx
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  80278b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278e:	eb 3b                	jmp    8027cb <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802790:	a1 40 41 80 00       	mov    0x804140,%eax
  802795:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802798:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279c:	74 07                	je     8027a5 <alloc_block_FF+0x19c>
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 00                	mov    (%eax),%eax
  8027a3:	eb 05                	jmp    8027aa <alloc_block_FF+0x1a1>
  8027a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027aa:	a3 40 41 80 00       	mov    %eax,0x804140
  8027af:	a1 40 41 80 00       	mov    0x804140,%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	0f 85 60 fe ff ff    	jne    80261c <alloc_block_FF+0x13>
  8027bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c0:	0f 85 56 fe ff ff    	jne    80261c <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8027c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cb:	c9                   	leave  
  8027cc:	c3                   	ret    

008027cd <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8027cd:	55                   	push   %ebp
  8027ce:	89 e5                	mov    %esp,%ebp
  8027d0:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8027d3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8027da:	a1 38 41 80 00       	mov    0x804138,%eax
  8027df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e2:	eb 3a                	jmp    80281e <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ed:	72 27                	jb     802816 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8027ef:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8027f3:	75 0b                	jne    802800 <alloc_block_BF+0x33>
					best_size= element->size;
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8027fe:	eb 16                	jmp    802816 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 50 0c             	mov    0xc(%eax),%edx
  802806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802809:	39 c2                	cmp    %eax,%edx
  80280b:	77 09                	ja     802816 <alloc_block_BF+0x49>
					best_size=element->size;
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 40 0c             	mov    0xc(%eax),%eax
  802813:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802816:	a1 40 41 80 00       	mov    0x804140,%eax
  80281b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802822:	74 07                	je     80282b <alloc_block_BF+0x5e>
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	eb 05                	jmp    802830 <alloc_block_BF+0x63>
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
  802830:	a3 40 41 80 00       	mov    %eax,0x804140
  802835:	a1 40 41 80 00       	mov    0x804140,%eax
  80283a:	85 c0                	test   %eax,%eax
  80283c:	75 a6                	jne    8027e4 <alloc_block_BF+0x17>
  80283e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802842:	75 a0                	jne    8027e4 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802844:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802848:	0f 84 d3 01 00 00    	je     802a21 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80284e:	a1 38 41 80 00       	mov    0x804138,%eax
  802853:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802856:	e9 98 01 00 00       	jmp    8029f3 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  80285b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802861:	0f 86 da 00 00 00    	jbe    802941 <alloc_block_BF+0x174>
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 50 0c             	mov    0xc(%eax),%edx
  80286d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802870:	39 c2                	cmp    %eax,%edx
  802872:	0f 85 c9 00 00 00    	jne    802941 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802878:	a1 48 41 80 00       	mov    0x804148,%eax
  80287d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802880:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802884:	75 17                	jne    80289d <alloc_block_BF+0xd0>
  802886:	83 ec 04             	sub    $0x4,%esp
  802889:	68 9b 3e 80 00       	push   $0x803e9b
  80288e:	68 ea 00 00 00       	push   $0xea
  802893:	68 f3 3d 80 00       	push   $0x803df3
  802898:	e8 fc db ff ff       	call   800499 <_panic>
  80289d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 10                	je     8028b6 <alloc_block_BF+0xe9>
  8028a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a9:	8b 00                	mov    (%eax),%eax
  8028ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ae:	8b 52 04             	mov    0x4(%edx),%edx
  8028b1:	89 50 04             	mov    %edx,0x4(%eax)
  8028b4:	eb 0b                	jmp    8028c1 <alloc_block_BF+0xf4>
  8028b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b9:	8b 40 04             	mov    0x4(%eax),%eax
  8028bc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c4:	8b 40 04             	mov    0x4(%eax),%eax
  8028c7:	85 c0                	test   %eax,%eax
  8028c9:	74 0f                	je     8028da <alloc_block_BF+0x10d>
  8028cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ce:	8b 40 04             	mov    0x4(%eax),%eax
  8028d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d4:	8b 12                	mov    (%edx),%edx
  8028d6:	89 10                	mov    %edx,(%eax)
  8028d8:	eb 0a                	jmp    8028e4 <alloc_block_BF+0x117>
  8028da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dd:	8b 00                	mov    (%eax),%eax
  8028df:	a3 48 41 80 00       	mov    %eax,0x804148
  8028e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f7:	a1 54 41 80 00       	mov    0x804154,%eax
  8028fc:	48                   	dec    %eax
  8028fd:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	8b 50 08             	mov    0x8(%eax),%edx
  802908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290b:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80290e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802911:	8b 55 08             	mov    0x8(%ebp),%edx
  802914:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	8b 40 0c             	mov    0xc(%eax),%eax
  80291d:	2b 45 08             	sub    0x8(%ebp),%eax
  802920:	89 c2                	mov    %eax,%edx
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 50 08             	mov    0x8(%eax),%edx
  80292e:	8b 45 08             	mov    0x8(%ebp),%eax
  802931:	01 c2                	add    %eax,%edx
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293c:	e9 e5 00 00 00       	jmp    802a26 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 50 0c             	mov    0xc(%eax),%edx
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	39 c2                	cmp    %eax,%edx
  80294c:	0f 85 99 00 00 00    	jne    8029eb <alloc_block_BF+0x21e>
  802952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802955:	3b 45 08             	cmp    0x8(%ebp),%eax
  802958:	0f 85 8d 00 00 00    	jne    8029eb <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802964:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802968:	75 17                	jne    802981 <alloc_block_BF+0x1b4>
  80296a:	83 ec 04             	sub    $0x4,%esp
  80296d:	68 9b 3e 80 00       	push   $0x803e9b
  802972:	68 f7 00 00 00       	push   $0xf7
  802977:	68 f3 3d 80 00       	push   $0x803df3
  80297c:	e8 18 db ff ff       	call   800499 <_panic>
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	74 10                	je     80299a <alloc_block_BF+0x1cd>
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802992:	8b 52 04             	mov    0x4(%edx),%edx
  802995:	89 50 04             	mov    %edx,0x4(%eax)
  802998:	eb 0b                	jmp    8029a5 <alloc_block_BF+0x1d8>
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	8b 40 04             	mov    0x4(%eax),%eax
  8029a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	8b 40 04             	mov    0x4(%eax),%eax
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	74 0f                	je     8029be <alloc_block_BF+0x1f1>
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 40 04             	mov    0x4(%eax),%eax
  8029b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b8:	8b 12                	mov    (%edx),%edx
  8029ba:	89 10                	mov    %edx,(%eax)
  8029bc:	eb 0a                	jmp    8029c8 <alloc_block_BF+0x1fb>
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	a3 38 41 80 00       	mov    %eax,0x804138
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029db:	a1 44 41 80 00       	mov    0x804144,%eax
  8029e0:	48                   	dec    %eax
  8029e1:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8029e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e9:	eb 3b                	jmp    802a26 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8029eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8029f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f7:	74 07                	je     802a00 <alloc_block_BF+0x233>
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	eb 05                	jmp    802a05 <alloc_block_BF+0x238>
  802a00:	b8 00 00 00 00       	mov    $0x0,%eax
  802a05:	a3 40 41 80 00       	mov    %eax,0x804140
  802a0a:	a1 40 41 80 00       	mov    0x804140,%eax
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	0f 85 44 fe ff ff    	jne    80285b <alloc_block_BF+0x8e>
  802a17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1b:	0f 85 3a fe ff ff    	jne    80285b <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802a21:	b8 00 00 00 00       	mov    $0x0,%eax
  802a26:	c9                   	leave  
  802a27:	c3                   	ret    

00802a28 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a28:	55                   	push   %ebp
  802a29:	89 e5                	mov    %esp,%ebp
  802a2b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802a2e:	83 ec 04             	sub    $0x4,%esp
  802a31:	68 bc 3e 80 00       	push   $0x803ebc
  802a36:	68 04 01 00 00       	push   $0x104
  802a3b:	68 f3 3d 80 00       	push   $0x803df3
  802a40:	e8 54 da ff ff       	call   800499 <_panic>

00802a45 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802a45:	55                   	push   %ebp
  802a46:	89 e5                	mov    %esp,%ebp
  802a48:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802a4b:	a1 38 41 80 00       	mov    0x804138,%eax
  802a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802a53:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a58:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802a5b:	a1 38 41 80 00       	mov    0x804138,%eax
  802a60:	85 c0                	test   %eax,%eax
  802a62:	75 68                	jne    802acc <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802a64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a68:	75 17                	jne    802a81 <insert_sorted_with_merge_freeList+0x3c>
  802a6a:	83 ec 04             	sub    $0x4,%esp
  802a6d:	68 d0 3d 80 00       	push   $0x803dd0
  802a72:	68 14 01 00 00       	push   $0x114
  802a77:	68 f3 3d 80 00       	push   $0x803df3
  802a7c:	e8 18 da ff ff       	call   800499 <_panic>
  802a81:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	89 10                	mov    %edx,(%eax)
  802a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8f:	8b 00                	mov    (%eax),%eax
  802a91:	85 c0                	test   %eax,%eax
  802a93:	74 0d                	je     802aa2 <insert_sorted_with_merge_freeList+0x5d>
  802a95:	a1 38 41 80 00       	mov    0x804138,%eax
  802a9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9d:	89 50 04             	mov    %edx,0x4(%eax)
  802aa0:	eb 08                	jmp    802aaa <insert_sorted_with_merge_freeList+0x65>
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802aad:	a3 38 41 80 00       	mov    %eax,0x804138
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abc:	a1 44 41 80 00       	mov    0x804144,%eax
  802ac1:	40                   	inc    %eax
  802ac2:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802ac7:	e9 d2 06 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	8b 50 08             	mov    0x8(%eax),%edx
  802ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad5:	8b 40 08             	mov    0x8(%eax),%eax
  802ad8:	39 c2                	cmp    %eax,%edx
  802ada:	0f 83 22 01 00 00    	jae    802c02 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae3:	8b 50 08             	mov    0x8(%eax),%edx
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	8b 40 0c             	mov    0xc(%eax),%eax
  802aec:	01 c2                	add    %eax,%edx
  802aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af1:	8b 40 08             	mov    0x8(%eax),%eax
  802af4:	39 c2                	cmp    %eax,%edx
  802af6:	0f 85 9e 00 00 00    	jne    802b9a <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	8b 50 08             	mov    0x8(%eax),%edx
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b05:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0b:	8b 50 0c             	mov    0xc(%eax),%edx
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	8b 40 0c             	mov    0xc(%eax),%eax
  802b14:	01 c2                	add    %eax,%edx
  802b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b19:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	8b 50 08             	mov    0x8(%eax),%edx
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b36:	75 17                	jne    802b4f <insert_sorted_with_merge_freeList+0x10a>
  802b38:	83 ec 04             	sub    $0x4,%esp
  802b3b:	68 d0 3d 80 00       	push   $0x803dd0
  802b40:	68 21 01 00 00       	push   $0x121
  802b45:	68 f3 3d 80 00       	push   $0x803df3
  802b4a:	e8 4a d9 ff ff       	call   800499 <_panic>
  802b4f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	89 10                	mov    %edx,(%eax)
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	8b 00                	mov    (%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	74 0d                	je     802b70 <insert_sorted_with_merge_freeList+0x12b>
  802b63:	a1 48 41 80 00       	mov    0x804148,%eax
  802b68:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6b:	89 50 04             	mov    %edx,0x4(%eax)
  802b6e:	eb 08                	jmp    802b78 <insert_sorted_with_merge_freeList+0x133>
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	a3 48 41 80 00       	mov    %eax,0x804148
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8a:	a1 54 41 80 00       	mov    0x804154,%eax
  802b8f:	40                   	inc    %eax
  802b90:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802b95:	e9 04 06 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802b9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b9e:	75 17                	jne    802bb7 <insert_sorted_with_merge_freeList+0x172>
  802ba0:	83 ec 04             	sub    $0x4,%esp
  802ba3:	68 d0 3d 80 00       	push   $0x803dd0
  802ba8:	68 26 01 00 00       	push   $0x126
  802bad:	68 f3 3d 80 00       	push   $0x803df3
  802bb2:	e8 e2 d8 ff ff       	call   800499 <_panic>
  802bb7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	89 10                	mov    %edx,(%eax)
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	8b 00                	mov    (%eax),%eax
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	74 0d                	je     802bd8 <insert_sorted_with_merge_freeList+0x193>
  802bcb:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd3:	89 50 04             	mov    %edx,0x4(%eax)
  802bd6:	eb 08                	jmp    802be0 <insert_sorted_with_merge_freeList+0x19b>
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	a3 38 41 80 00       	mov    %eax,0x804138
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf2:	a1 44 41 80 00       	mov    0x804144,%eax
  802bf7:	40                   	inc    %eax
  802bf8:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802bfd:	e9 9c 05 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	8b 50 08             	mov    0x8(%eax),%edx
  802c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0b:	8b 40 08             	mov    0x8(%eax),%eax
  802c0e:	39 c2                	cmp    %eax,%edx
  802c10:	0f 86 16 01 00 00    	jbe    802d2c <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c19:	8b 50 08             	mov    0x8(%eax),%edx
  802c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c22:	01 c2                	add    %eax,%edx
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	8b 40 08             	mov    0x8(%eax),%eax
  802c2a:	39 c2                	cmp    %eax,%edx
  802c2c:	0f 85 92 00 00 00    	jne    802cc4 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c35:	8b 50 0c             	mov    0xc(%eax),%edx
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3e:	01 c2                	add    %eax,%edx
  802c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c43:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c50:	8b 45 08             	mov    0x8(%ebp),%eax
  802c53:	8b 50 08             	mov    0x8(%eax),%edx
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c60:	75 17                	jne    802c79 <insert_sorted_with_merge_freeList+0x234>
  802c62:	83 ec 04             	sub    $0x4,%esp
  802c65:	68 d0 3d 80 00       	push   $0x803dd0
  802c6a:	68 31 01 00 00       	push   $0x131
  802c6f:	68 f3 3d 80 00       	push   $0x803df3
  802c74:	e8 20 d8 ff ff       	call   800499 <_panic>
  802c79:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	89 10                	mov    %edx,(%eax)
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	85 c0                	test   %eax,%eax
  802c8b:	74 0d                	je     802c9a <insert_sorted_with_merge_freeList+0x255>
  802c8d:	a1 48 41 80 00       	mov    0x804148,%eax
  802c92:	8b 55 08             	mov    0x8(%ebp),%edx
  802c95:	89 50 04             	mov    %edx,0x4(%eax)
  802c98:	eb 08                	jmp    802ca2 <insert_sorted_with_merge_freeList+0x25d>
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	a3 48 41 80 00       	mov    %eax,0x804148
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb4:	a1 54 41 80 00       	mov    0x804154,%eax
  802cb9:	40                   	inc    %eax
  802cba:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802cbf:	e9 da 04 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802cc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc8:	75 17                	jne    802ce1 <insert_sorted_with_merge_freeList+0x29c>
  802cca:	83 ec 04             	sub    $0x4,%esp
  802ccd:	68 78 3e 80 00       	push   $0x803e78
  802cd2:	68 37 01 00 00       	push   $0x137
  802cd7:	68 f3 3d 80 00       	push   $0x803df3
  802cdc:	e8 b8 d7 ff ff       	call   800499 <_panic>
  802ce1:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	89 50 04             	mov    %edx,0x4(%eax)
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	74 0c                	je     802d03 <insert_sorted_with_merge_freeList+0x2be>
  802cf7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  802cff:	89 10                	mov    %edx,(%eax)
  802d01:	eb 08                	jmp    802d0b <insert_sorted_with_merge_freeList+0x2c6>
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	a3 38 41 80 00       	mov    %eax,0x804138
  802d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1c:	a1 44 41 80 00       	mov    0x804144,%eax
  802d21:	40                   	inc    %eax
  802d22:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802d27:	e9 72 04 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802d2c:	a1 38 41 80 00       	mov    0x804138,%eax
  802d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d34:	e9 35 04 00 00       	jmp    80316e <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	8b 50 08             	mov    0x8(%eax),%edx
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 08             	mov    0x8(%eax),%eax
  802d4d:	39 c2                	cmp    %eax,%edx
  802d4f:	0f 86 11 04 00 00    	jbe    803166 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	8b 50 08             	mov    0x8(%eax),%edx
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d61:	01 c2                	add    %eax,%edx
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	8b 40 08             	mov    0x8(%eax),%eax
  802d69:	39 c2                	cmp    %eax,%edx
  802d6b:	0f 83 8b 00 00 00    	jae    802dfc <insert_sorted_with_merge_freeList+0x3b7>
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	8b 50 08             	mov    0x8(%eax),%edx
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7d:	01 c2                	add    %eax,%edx
  802d7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d82:	8b 40 08             	mov    0x8(%eax),%eax
  802d85:	39 c2                	cmp    %eax,%edx
  802d87:	73 73                	jae    802dfc <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8d:	74 06                	je     802d95 <insert_sorted_with_merge_freeList+0x350>
  802d8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d93:	75 17                	jne    802dac <insert_sorted_with_merge_freeList+0x367>
  802d95:	83 ec 04             	sub    $0x4,%esp
  802d98:	68 44 3e 80 00       	push   $0x803e44
  802d9d:	68 48 01 00 00       	push   $0x148
  802da2:	68 f3 3d 80 00       	push   $0x803df3
  802da7:	e8 ed d6 ff ff       	call   800499 <_panic>
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 10                	mov    (%eax),%edx
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	89 10                	mov    %edx,(%eax)
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	74 0b                	je     802dca <insert_sorted_with_merge_freeList+0x385>
  802dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc2:	8b 00                	mov    (%eax),%eax
  802dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc7:	89 50 04             	mov    %edx,0x4(%eax)
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd0:	89 10                	mov    %edx,(%eax)
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd8:	89 50 04             	mov    %edx,0x4(%eax)
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	8b 00                	mov    (%eax),%eax
  802de0:	85 c0                	test   %eax,%eax
  802de2:	75 08                	jne    802dec <insert_sorted_with_merge_freeList+0x3a7>
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dec:	a1 44 41 80 00       	mov    0x804144,%eax
  802df1:	40                   	inc    %eax
  802df2:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802df7:	e9 a2 03 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	8b 50 08             	mov    0x8(%eax),%edx
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	8b 40 0c             	mov    0xc(%eax),%eax
  802e08:	01 c2                	add    %eax,%edx
  802e0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0d:	8b 40 08             	mov    0x8(%eax),%eax
  802e10:	39 c2                	cmp    %eax,%edx
  802e12:	0f 83 ae 00 00 00    	jae    802ec6 <insert_sorted_with_merge_freeList+0x481>
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	8b 50 08             	mov    0x8(%eax),%edx
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 48 08             	mov    0x8(%eax),%ecx
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2a:	01 c8                	add    %ecx,%eax
  802e2c:	39 c2                	cmp    %eax,%edx
  802e2e:	0f 85 92 00 00 00    	jne    802ec6 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e37:	8b 50 0c             	mov    0xc(%eax),%edx
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e40:	01 c2                	add    %eax,%edx
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	8b 50 08             	mov    0x8(%eax),%edx
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e62:	75 17                	jne    802e7b <insert_sorted_with_merge_freeList+0x436>
  802e64:	83 ec 04             	sub    $0x4,%esp
  802e67:	68 d0 3d 80 00       	push   $0x803dd0
  802e6c:	68 51 01 00 00       	push   $0x151
  802e71:	68 f3 3d 80 00       	push   $0x803df3
  802e76:	e8 1e d6 ff ff       	call   800499 <_panic>
  802e7b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	89 10                	mov    %edx,(%eax)
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	85 c0                	test   %eax,%eax
  802e8d:	74 0d                	je     802e9c <insert_sorted_with_merge_freeList+0x457>
  802e8f:	a1 48 41 80 00       	mov    0x804148,%eax
  802e94:	8b 55 08             	mov    0x8(%ebp),%edx
  802e97:	89 50 04             	mov    %edx,0x4(%eax)
  802e9a:	eb 08                	jmp    802ea4 <insert_sorted_with_merge_freeList+0x45f>
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	a3 48 41 80 00       	mov    %eax,0x804148
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb6:	a1 54 41 80 00       	mov    0x804154,%eax
  802ebb:	40                   	inc    %eax
  802ebc:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802ec1:	e9 d8 02 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	8b 50 08             	mov    0x8(%eax),%edx
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed2:	01 c2                	add    %eax,%edx
  802ed4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed7:	8b 40 08             	mov    0x8(%eax),%eax
  802eda:	39 c2                	cmp    %eax,%edx
  802edc:	0f 85 ba 00 00 00    	jne    802f9c <insert_sorted_with_merge_freeList+0x557>
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	8b 50 08             	mov    0x8(%eax),%edx
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 48 08             	mov    0x8(%eax),%ecx
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef4:	01 c8                	add    %ecx,%eax
  802ef6:	39 c2                	cmp    %eax,%edx
  802ef8:	0f 86 9e 00 00 00    	jbe    802f9c <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802efe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f01:	8b 50 0c             	mov    0xc(%eax),%edx
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0a:	01 c2                	add    %eax,%edx
  802f0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0f:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	8b 50 08             	mov    0x8(%eax),%edx
  802f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1b:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	8b 50 08             	mov    0x8(%eax),%edx
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f38:	75 17                	jne    802f51 <insert_sorted_with_merge_freeList+0x50c>
  802f3a:	83 ec 04             	sub    $0x4,%esp
  802f3d:	68 d0 3d 80 00       	push   $0x803dd0
  802f42:	68 5b 01 00 00       	push   $0x15b
  802f47:	68 f3 3d 80 00       	push   $0x803df3
  802f4c:	e8 48 d5 ff ff       	call   800499 <_panic>
  802f51:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	89 10                	mov    %edx,(%eax)
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	8b 00                	mov    (%eax),%eax
  802f61:	85 c0                	test   %eax,%eax
  802f63:	74 0d                	je     802f72 <insert_sorted_with_merge_freeList+0x52d>
  802f65:	a1 48 41 80 00       	mov    0x804148,%eax
  802f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6d:	89 50 04             	mov    %edx,0x4(%eax)
  802f70:	eb 08                	jmp    802f7a <insert_sorted_with_merge_freeList+0x535>
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	a3 48 41 80 00       	mov    %eax,0x804148
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8c:	a1 54 41 80 00       	mov    0x804154,%eax
  802f91:	40                   	inc    %eax
  802f92:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f97:	e9 02 02 00 00       	jmp    80319e <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	8b 50 08             	mov    0x8(%eax),%edx
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa8:	01 c2                	add    %eax,%edx
  802faa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fad:	8b 40 08             	mov    0x8(%eax),%eax
  802fb0:	39 c2                	cmp    %eax,%edx
  802fb2:	0f 85 ae 01 00 00    	jne    803166 <insert_sorted_with_merge_freeList+0x721>
  802fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbb:	8b 50 08             	mov    0x8(%eax),%edx
  802fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc1:	8b 48 08             	mov    0x8(%eax),%ecx
  802fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fca:	01 c8                	add    %ecx,%eax
  802fcc:	39 c2                	cmp    %eax,%edx
  802fce:	0f 85 92 01 00 00    	jne    803166 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	8b 50 0c             	mov    0xc(%eax),%edx
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe0:	01 c2                	add    %eax,%edx
  802fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe8:	01 c2                	add    %eax,%edx
  802fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fed:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	8b 50 08             	mov    0x8(%eax),%edx
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803009:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803010:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803013:	8b 50 08             	mov    0x8(%eax),%edx
  803016:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803019:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  80301c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803020:	75 17                	jne    803039 <insert_sorted_with_merge_freeList+0x5f4>
  803022:	83 ec 04             	sub    $0x4,%esp
  803025:	68 9b 3e 80 00       	push   $0x803e9b
  80302a:	68 63 01 00 00       	push   $0x163
  80302f:	68 f3 3d 80 00       	push   $0x803df3
  803034:	e8 60 d4 ff ff       	call   800499 <_panic>
  803039:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	85 c0                	test   %eax,%eax
  803040:	74 10                	je     803052 <insert_sorted_with_merge_freeList+0x60d>
  803042:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80304a:	8b 52 04             	mov    0x4(%edx),%edx
  80304d:	89 50 04             	mov    %edx,0x4(%eax)
  803050:	eb 0b                	jmp    80305d <insert_sorted_with_merge_freeList+0x618>
  803052:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803055:	8b 40 04             	mov    0x4(%eax),%eax
  803058:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80305d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803060:	8b 40 04             	mov    0x4(%eax),%eax
  803063:	85 c0                	test   %eax,%eax
  803065:	74 0f                	je     803076 <insert_sorted_with_merge_freeList+0x631>
  803067:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306a:	8b 40 04             	mov    0x4(%eax),%eax
  80306d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803070:	8b 12                	mov    (%edx),%edx
  803072:	89 10                	mov    %edx,(%eax)
  803074:	eb 0a                	jmp    803080 <insert_sorted_with_merge_freeList+0x63b>
  803076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803079:	8b 00                	mov    (%eax),%eax
  80307b:	a3 38 41 80 00       	mov    %eax,0x804138
  803080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803083:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803089:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803093:	a1 44 41 80 00       	mov    0x804144,%eax
  803098:	48                   	dec    %eax
  803099:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  80309e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030a2:	75 17                	jne    8030bb <insert_sorted_with_merge_freeList+0x676>
  8030a4:	83 ec 04             	sub    $0x4,%esp
  8030a7:	68 d0 3d 80 00       	push   $0x803dd0
  8030ac:	68 64 01 00 00       	push   $0x164
  8030b1:	68 f3 3d 80 00       	push   $0x803df3
  8030b6:	e8 de d3 ff ff       	call   800499 <_panic>
  8030bb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c4:	89 10                	mov    %edx,(%eax)
  8030c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c9:	8b 00                	mov    (%eax),%eax
  8030cb:	85 c0                	test   %eax,%eax
  8030cd:	74 0d                	je     8030dc <insert_sorted_with_merge_freeList+0x697>
  8030cf:	a1 48 41 80 00       	mov    0x804148,%eax
  8030d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d7:	89 50 04             	mov    %edx,0x4(%eax)
  8030da:	eb 08                	jmp    8030e4 <insert_sorted_with_merge_freeList+0x69f>
  8030dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030df:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e7:	a3 48 41 80 00       	mov    %eax,0x804148
  8030ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f6:	a1 54 41 80 00       	mov    0x804154,%eax
  8030fb:	40                   	inc    %eax
  8030fc:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803101:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803105:	75 17                	jne    80311e <insert_sorted_with_merge_freeList+0x6d9>
  803107:	83 ec 04             	sub    $0x4,%esp
  80310a:	68 d0 3d 80 00       	push   $0x803dd0
  80310f:	68 65 01 00 00       	push   $0x165
  803114:	68 f3 3d 80 00       	push   $0x803df3
  803119:	e8 7b d3 ff ff       	call   800499 <_panic>
  80311e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	89 10                	mov    %edx,(%eax)
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	8b 00                	mov    (%eax),%eax
  80312e:	85 c0                	test   %eax,%eax
  803130:	74 0d                	je     80313f <insert_sorted_with_merge_freeList+0x6fa>
  803132:	a1 48 41 80 00       	mov    0x804148,%eax
  803137:	8b 55 08             	mov    0x8(%ebp),%edx
  80313a:	89 50 04             	mov    %edx,0x4(%eax)
  80313d:	eb 08                	jmp    803147 <insert_sorted_with_merge_freeList+0x702>
  80313f:	8b 45 08             	mov    0x8(%ebp),%eax
  803142:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	a3 48 41 80 00       	mov    %eax,0x804148
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803159:	a1 54 41 80 00       	mov    0x804154,%eax
  80315e:	40                   	inc    %eax
  80315f:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  803164:	eb 38                	jmp    80319e <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803166:	a1 40 41 80 00       	mov    0x804140,%eax
  80316b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80316e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803172:	74 07                	je     80317b <insert_sorted_with_merge_freeList+0x736>
  803174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803177:	8b 00                	mov    (%eax),%eax
  803179:	eb 05                	jmp    803180 <insert_sorted_with_merge_freeList+0x73b>
  80317b:	b8 00 00 00 00       	mov    $0x0,%eax
  803180:	a3 40 41 80 00       	mov    %eax,0x804140
  803185:	a1 40 41 80 00       	mov    0x804140,%eax
  80318a:	85 c0                	test   %eax,%eax
  80318c:	0f 85 a7 fb ff ff    	jne    802d39 <insert_sorted_with_merge_freeList+0x2f4>
  803192:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803196:	0f 85 9d fb ff ff    	jne    802d39 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80319c:	eb 00                	jmp    80319e <insert_sorted_with_merge_freeList+0x759>
  80319e:	90                   	nop
  80319f:	c9                   	leave  
  8031a0:	c3                   	ret    
  8031a1:	66 90                	xchg   %ax,%ax
  8031a3:	90                   	nop

008031a4 <__udivdi3>:
  8031a4:	55                   	push   %ebp
  8031a5:	57                   	push   %edi
  8031a6:	56                   	push   %esi
  8031a7:	53                   	push   %ebx
  8031a8:	83 ec 1c             	sub    $0x1c,%esp
  8031ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031bb:	89 ca                	mov    %ecx,%edx
  8031bd:	89 f8                	mov    %edi,%eax
  8031bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031c3:	85 f6                	test   %esi,%esi
  8031c5:	75 2d                	jne    8031f4 <__udivdi3+0x50>
  8031c7:	39 cf                	cmp    %ecx,%edi
  8031c9:	77 65                	ja     803230 <__udivdi3+0x8c>
  8031cb:	89 fd                	mov    %edi,%ebp
  8031cd:	85 ff                	test   %edi,%edi
  8031cf:	75 0b                	jne    8031dc <__udivdi3+0x38>
  8031d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8031d6:	31 d2                	xor    %edx,%edx
  8031d8:	f7 f7                	div    %edi
  8031da:	89 c5                	mov    %eax,%ebp
  8031dc:	31 d2                	xor    %edx,%edx
  8031de:	89 c8                	mov    %ecx,%eax
  8031e0:	f7 f5                	div    %ebp
  8031e2:	89 c1                	mov    %eax,%ecx
  8031e4:	89 d8                	mov    %ebx,%eax
  8031e6:	f7 f5                	div    %ebp
  8031e8:	89 cf                	mov    %ecx,%edi
  8031ea:	89 fa                	mov    %edi,%edx
  8031ec:	83 c4 1c             	add    $0x1c,%esp
  8031ef:	5b                   	pop    %ebx
  8031f0:	5e                   	pop    %esi
  8031f1:	5f                   	pop    %edi
  8031f2:	5d                   	pop    %ebp
  8031f3:	c3                   	ret    
  8031f4:	39 ce                	cmp    %ecx,%esi
  8031f6:	77 28                	ja     803220 <__udivdi3+0x7c>
  8031f8:	0f bd fe             	bsr    %esi,%edi
  8031fb:	83 f7 1f             	xor    $0x1f,%edi
  8031fe:	75 40                	jne    803240 <__udivdi3+0x9c>
  803200:	39 ce                	cmp    %ecx,%esi
  803202:	72 0a                	jb     80320e <__udivdi3+0x6a>
  803204:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803208:	0f 87 9e 00 00 00    	ja     8032ac <__udivdi3+0x108>
  80320e:	b8 01 00 00 00       	mov    $0x1,%eax
  803213:	89 fa                	mov    %edi,%edx
  803215:	83 c4 1c             	add    $0x1c,%esp
  803218:	5b                   	pop    %ebx
  803219:	5e                   	pop    %esi
  80321a:	5f                   	pop    %edi
  80321b:	5d                   	pop    %ebp
  80321c:	c3                   	ret    
  80321d:	8d 76 00             	lea    0x0(%esi),%esi
  803220:	31 ff                	xor    %edi,%edi
  803222:	31 c0                	xor    %eax,%eax
  803224:	89 fa                	mov    %edi,%edx
  803226:	83 c4 1c             	add    $0x1c,%esp
  803229:	5b                   	pop    %ebx
  80322a:	5e                   	pop    %esi
  80322b:	5f                   	pop    %edi
  80322c:	5d                   	pop    %ebp
  80322d:	c3                   	ret    
  80322e:	66 90                	xchg   %ax,%ax
  803230:	89 d8                	mov    %ebx,%eax
  803232:	f7 f7                	div    %edi
  803234:	31 ff                	xor    %edi,%edi
  803236:	89 fa                	mov    %edi,%edx
  803238:	83 c4 1c             	add    $0x1c,%esp
  80323b:	5b                   	pop    %ebx
  80323c:	5e                   	pop    %esi
  80323d:	5f                   	pop    %edi
  80323e:	5d                   	pop    %ebp
  80323f:	c3                   	ret    
  803240:	bd 20 00 00 00       	mov    $0x20,%ebp
  803245:	89 eb                	mov    %ebp,%ebx
  803247:	29 fb                	sub    %edi,%ebx
  803249:	89 f9                	mov    %edi,%ecx
  80324b:	d3 e6                	shl    %cl,%esi
  80324d:	89 c5                	mov    %eax,%ebp
  80324f:	88 d9                	mov    %bl,%cl
  803251:	d3 ed                	shr    %cl,%ebp
  803253:	89 e9                	mov    %ebp,%ecx
  803255:	09 f1                	or     %esi,%ecx
  803257:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80325b:	89 f9                	mov    %edi,%ecx
  80325d:	d3 e0                	shl    %cl,%eax
  80325f:	89 c5                	mov    %eax,%ebp
  803261:	89 d6                	mov    %edx,%esi
  803263:	88 d9                	mov    %bl,%cl
  803265:	d3 ee                	shr    %cl,%esi
  803267:	89 f9                	mov    %edi,%ecx
  803269:	d3 e2                	shl    %cl,%edx
  80326b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80326f:	88 d9                	mov    %bl,%cl
  803271:	d3 e8                	shr    %cl,%eax
  803273:	09 c2                	or     %eax,%edx
  803275:	89 d0                	mov    %edx,%eax
  803277:	89 f2                	mov    %esi,%edx
  803279:	f7 74 24 0c          	divl   0xc(%esp)
  80327d:	89 d6                	mov    %edx,%esi
  80327f:	89 c3                	mov    %eax,%ebx
  803281:	f7 e5                	mul    %ebp
  803283:	39 d6                	cmp    %edx,%esi
  803285:	72 19                	jb     8032a0 <__udivdi3+0xfc>
  803287:	74 0b                	je     803294 <__udivdi3+0xf0>
  803289:	89 d8                	mov    %ebx,%eax
  80328b:	31 ff                	xor    %edi,%edi
  80328d:	e9 58 ff ff ff       	jmp    8031ea <__udivdi3+0x46>
  803292:	66 90                	xchg   %ax,%ax
  803294:	8b 54 24 08          	mov    0x8(%esp),%edx
  803298:	89 f9                	mov    %edi,%ecx
  80329a:	d3 e2                	shl    %cl,%edx
  80329c:	39 c2                	cmp    %eax,%edx
  80329e:	73 e9                	jae    803289 <__udivdi3+0xe5>
  8032a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032a3:	31 ff                	xor    %edi,%edi
  8032a5:	e9 40 ff ff ff       	jmp    8031ea <__udivdi3+0x46>
  8032aa:	66 90                	xchg   %ax,%ax
  8032ac:	31 c0                	xor    %eax,%eax
  8032ae:	e9 37 ff ff ff       	jmp    8031ea <__udivdi3+0x46>
  8032b3:	90                   	nop

008032b4 <__umoddi3>:
  8032b4:	55                   	push   %ebp
  8032b5:	57                   	push   %edi
  8032b6:	56                   	push   %esi
  8032b7:	53                   	push   %ebx
  8032b8:	83 ec 1c             	sub    $0x1c,%esp
  8032bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032d3:	89 f3                	mov    %esi,%ebx
  8032d5:	89 fa                	mov    %edi,%edx
  8032d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032db:	89 34 24             	mov    %esi,(%esp)
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	75 1a                	jne    8032fc <__umoddi3+0x48>
  8032e2:	39 f7                	cmp    %esi,%edi
  8032e4:	0f 86 a2 00 00 00    	jbe    80338c <__umoddi3+0xd8>
  8032ea:	89 c8                	mov    %ecx,%eax
  8032ec:	89 f2                	mov    %esi,%edx
  8032ee:	f7 f7                	div    %edi
  8032f0:	89 d0                	mov    %edx,%eax
  8032f2:	31 d2                	xor    %edx,%edx
  8032f4:	83 c4 1c             	add    $0x1c,%esp
  8032f7:	5b                   	pop    %ebx
  8032f8:	5e                   	pop    %esi
  8032f9:	5f                   	pop    %edi
  8032fa:	5d                   	pop    %ebp
  8032fb:	c3                   	ret    
  8032fc:	39 f0                	cmp    %esi,%eax
  8032fe:	0f 87 ac 00 00 00    	ja     8033b0 <__umoddi3+0xfc>
  803304:	0f bd e8             	bsr    %eax,%ebp
  803307:	83 f5 1f             	xor    $0x1f,%ebp
  80330a:	0f 84 ac 00 00 00    	je     8033bc <__umoddi3+0x108>
  803310:	bf 20 00 00 00       	mov    $0x20,%edi
  803315:	29 ef                	sub    %ebp,%edi
  803317:	89 fe                	mov    %edi,%esi
  803319:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80331d:	89 e9                	mov    %ebp,%ecx
  80331f:	d3 e0                	shl    %cl,%eax
  803321:	89 d7                	mov    %edx,%edi
  803323:	89 f1                	mov    %esi,%ecx
  803325:	d3 ef                	shr    %cl,%edi
  803327:	09 c7                	or     %eax,%edi
  803329:	89 e9                	mov    %ebp,%ecx
  80332b:	d3 e2                	shl    %cl,%edx
  80332d:	89 14 24             	mov    %edx,(%esp)
  803330:	89 d8                	mov    %ebx,%eax
  803332:	d3 e0                	shl    %cl,%eax
  803334:	89 c2                	mov    %eax,%edx
  803336:	8b 44 24 08          	mov    0x8(%esp),%eax
  80333a:	d3 e0                	shl    %cl,%eax
  80333c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803340:	8b 44 24 08          	mov    0x8(%esp),%eax
  803344:	89 f1                	mov    %esi,%ecx
  803346:	d3 e8                	shr    %cl,%eax
  803348:	09 d0                	or     %edx,%eax
  80334a:	d3 eb                	shr    %cl,%ebx
  80334c:	89 da                	mov    %ebx,%edx
  80334e:	f7 f7                	div    %edi
  803350:	89 d3                	mov    %edx,%ebx
  803352:	f7 24 24             	mull   (%esp)
  803355:	89 c6                	mov    %eax,%esi
  803357:	89 d1                	mov    %edx,%ecx
  803359:	39 d3                	cmp    %edx,%ebx
  80335b:	0f 82 87 00 00 00    	jb     8033e8 <__umoddi3+0x134>
  803361:	0f 84 91 00 00 00    	je     8033f8 <__umoddi3+0x144>
  803367:	8b 54 24 04          	mov    0x4(%esp),%edx
  80336b:	29 f2                	sub    %esi,%edx
  80336d:	19 cb                	sbb    %ecx,%ebx
  80336f:	89 d8                	mov    %ebx,%eax
  803371:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803375:	d3 e0                	shl    %cl,%eax
  803377:	89 e9                	mov    %ebp,%ecx
  803379:	d3 ea                	shr    %cl,%edx
  80337b:	09 d0                	or     %edx,%eax
  80337d:	89 e9                	mov    %ebp,%ecx
  80337f:	d3 eb                	shr    %cl,%ebx
  803381:	89 da                	mov    %ebx,%edx
  803383:	83 c4 1c             	add    $0x1c,%esp
  803386:	5b                   	pop    %ebx
  803387:	5e                   	pop    %esi
  803388:	5f                   	pop    %edi
  803389:	5d                   	pop    %ebp
  80338a:	c3                   	ret    
  80338b:	90                   	nop
  80338c:	89 fd                	mov    %edi,%ebp
  80338e:	85 ff                	test   %edi,%edi
  803390:	75 0b                	jne    80339d <__umoddi3+0xe9>
  803392:	b8 01 00 00 00       	mov    $0x1,%eax
  803397:	31 d2                	xor    %edx,%edx
  803399:	f7 f7                	div    %edi
  80339b:	89 c5                	mov    %eax,%ebp
  80339d:	89 f0                	mov    %esi,%eax
  80339f:	31 d2                	xor    %edx,%edx
  8033a1:	f7 f5                	div    %ebp
  8033a3:	89 c8                	mov    %ecx,%eax
  8033a5:	f7 f5                	div    %ebp
  8033a7:	89 d0                	mov    %edx,%eax
  8033a9:	e9 44 ff ff ff       	jmp    8032f2 <__umoddi3+0x3e>
  8033ae:	66 90                	xchg   %ax,%ax
  8033b0:	89 c8                	mov    %ecx,%eax
  8033b2:	89 f2                	mov    %esi,%edx
  8033b4:	83 c4 1c             	add    $0x1c,%esp
  8033b7:	5b                   	pop    %ebx
  8033b8:	5e                   	pop    %esi
  8033b9:	5f                   	pop    %edi
  8033ba:	5d                   	pop    %ebp
  8033bb:	c3                   	ret    
  8033bc:	3b 04 24             	cmp    (%esp),%eax
  8033bf:	72 06                	jb     8033c7 <__umoddi3+0x113>
  8033c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033c5:	77 0f                	ja     8033d6 <__umoddi3+0x122>
  8033c7:	89 f2                	mov    %esi,%edx
  8033c9:	29 f9                	sub    %edi,%ecx
  8033cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033cf:	89 14 24             	mov    %edx,(%esp)
  8033d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033da:	8b 14 24             	mov    (%esp),%edx
  8033dd:	83 c4 1c             	add    $0x1c,%esp
  8033e0:	5b                   	pop    %ebx
  8033e1:	5e                   	pop    %esi
  8033e2:	5f                   	pop    %edi
  8033e3:	5d                   	pop    %ebp
  8033e4:	c3                   	ret    
  8033e5:	8d 76 00             	lea    0x0(%esi),%esi
  8033e8:	2b 04 24             	sub    (%esp),%eax
  8033eb:	19 fa                	sbb    %edi,%edx
  8033ed:	89 d1                	mov    %edx,%ecx
  8033ef:	89 c6                	mov    %eax,%esi
  8033f1:	e9 71 ff ff ff       	jmp    803367 <__umoddi3+0xb3>
  8033f6:	66 90                	xchg   %ax,%ax
  8033f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033fc:	72 ea                	jb     8033e8 <__umoddi3+0x134>
  8033fe:	89 d9                	mov    %ebx,%ecx
  803400:	e9 62 ff ff ff       	jmp    803367 <__umoddi3+0xb3>
