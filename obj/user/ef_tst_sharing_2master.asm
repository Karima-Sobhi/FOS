
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 49 03 00 00       	call   80037f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
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
  80008d:	68 e0 34 80 00       	push   $0x8034e0
  800092:	6a 13                	push   $0x13
  800094:	68 fc 34 80 00       	push   $0x8034fc
  800099:	e8 1d 04 00 00       	call   8004bb <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 26 1a 00 00       	call   801ac9 <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 1a 35 80 00       	push   $0x80351a
  8000b2:	e8 33 17 00 00       	call   8017ea <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 1c 35 80 00       	push   $0x80351c
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 fc 34 80 00       	push   $0x8034fc
  8000d5:	e8 e1 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 e7 19 00 00       	call   801ac9 <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 d6 19 00 00       	call   801ac9 <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 cf 19 00 00       	call   801ac9 <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 80 35 80 00       	push   $0x803580
  800107:	6a 1b                	push   $0x1b
  800109:	68 fc 34 80 00       	push   $0x8034fc
  80010e:	e8 a8 03 00 00       	call   8004bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 b1 19 00 00       	call   801ac9 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 11 36 80 00       	push   $0x803611
  800127:	e8 be 16 00 00       	call   8017ea <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 1c 35 80 00       	push   $0x80351c
  800143:	6a 20                	push   $0x20
  800145:	68 fc 34 80 00       	push   $0x8034fc
  80014a:	e8 6c 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 72 19 00 00       	call   801ac9 <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 61 19 00 00       	call   801ac9 <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 5a 19 00 00       	call   801ac9 <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 80 35 80 00       	push   $0x803580
  80017c:	6a 21                	push   $0x21
  80017e:	68 fc 34 80 00       	push   $0x8034fc
  800183:	e8 33 03 00 00       	call   8004bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 3c 19 00 00       	call   801ac9 <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 13 36 80 00       	push   $0x803613
  80019c:	e8 49 16 00 00       	call   8017ea <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 1c 35 80 00       	push   $0x80351c
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 fc 34 80 00       	push   $0x8034fc
  8001bf:	e8 f7 02 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 fd 18 00 00       	call   801ac9 <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 18 36 80 00       	push   $0x803618
  8001dd:	6a 27                	push   $0x27
  8001df:	68 fc 34 80 00       	push   $0x8034fc
  8001e4:	e8 d2 02 00 00       	call   8004bb <_panic>

	*x = 10 ;
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f5:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800200:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	a1 20 40 80 00       	mov    0x804020,%eax
  80020d:	8b 40 74             	mov    0x74(%eax),%eax
  800210:	6a 32                	push   $0x32
  800212:	52                   	push   %edx
  800213:	50                   	push   %eax
  800214:	68 a0 36 80 00       	push   $0x8036a0
  800219:	e8 1d 1b 00 00       	call   801d3b <sys_create_env>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800224:	a1 20 40 80 00       	mov    0x804020,%eax
  800229:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80022f:	89 c2                	mov    %eax,%edx
  800231:	a1 20 40 80 00       	mov    0x804020,%eax
  800236:	8b 40 74             	mov    0x74(%eax),%eax
  800239:	6a 32                	push   $0x32
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 a0 36 80 00       	push   $0x8036a0
  800242:	e8 f4 1a 00 00       	call   801d3b <sys_create_env>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80024d:	a1 20 40 80 00       	mov    0x804020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	a1 20 40 80 00       	mov    0x804020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	6a 32                	push   $0x32
  800264:	52                   	push   %edx
  800265:	50                   	push   %eax
  800266:	68 a0 36 80 00       	push   $0x8036a0
  80026b:	e8 cb 1a 00 00       	call   801d3b <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 0c 1c 00 00       	call   801e87 <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 ae 36 80 00       	push   $0x8036ae
  800287:	e8 5e 15 00 00       	call   8017ea <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 bc 1a 00 00       	call   801d59 <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 ae 1a 00 00       	call   801d59 <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 a0 1a 00 00       	call   801d59 <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 fa 2e 00 00       	call   8031c3 <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 30 1c 00 00       	call   801f01 <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 be 36 80 00       	push   $0x8036be
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 fc 34 80 00       	push   $0x8034fc
  8002e5:	e8 d1 01 00 00       	call   8004bb <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 cc 36 80 00       	push   $0x8036cc
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 fc 34 80 00       	push   $0x8034fc
  800303:	e8 b3 01 00 00       	call   8004bb <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 1c 37 80 00       	push   $0x80371c
  800310:	e8 5a 04 00 00       	call   80076f <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 a5 1a 00 00       	call   801dc2 <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 49 1a 00 00       	call   801d75 <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 3b 1a 00 00       	call   801d75 <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 2d 1a 00 00       	call   801d75 <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 6b 1a 00 00       	call   801dc2 <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 76 37 80 00       	push   $0x803776
  80035f:	50                   	push   %eax
  800360:	e8 2e 15 00 00       	call   801893 <sget>
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	89 45 cc             	mov    %eax,-0x34(%ebp)
		(*finishedCount)++ ;
  80036b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	8d 50 01             	lea    0x1(%eax),%edx
  800373:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800376:	89 10                	mov    %edx,(%eax)
	}
	return;
  800378:	90                   	nop
  800379:	90                   	nop
}
  80037a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800385:	e8 1f 1a 00 00       	call   801da9 <sys_getenvindex>
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80038d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800390:	89 d0                	mov    %edx,%eax
  800392:	c1 e0 03             	shl    $0x3,%eax
  800395:	01 d0                	add    %edx,%eax
  800397:	01 c0                	add    %eax,%eax
  800399:	01 d0                	add    %edx,%eax
  80039b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a2:	01 d0                	add    %edx,%eax
  8003a4:	c1 e0 04             	shl    $0x4,%eax
  8003a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003ac:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b6:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003bc:	84 c0                	test   %al,%al
  8003be:	74 0f                	je     8003cf <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c5:	05 5c 05 00 00       	add    $0x55c,%eax
  8003ca:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003d3:	7e 0a                	jle    8003df <libmain+0x60>
		binaryname = argv[0];
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 0c             	pushl  0xc(%ebp)
  8003e5:	ff 75 08             	pushl  0x8(%ebp)
  8003e8:	e8 4b fc ff ff       	call   800038 <_main>
  8003ed:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003f0:	e8 c1 17 00 00       	call   801bb6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	68 9c 37 80 00       	push   $0x80379c
  8003fd:	e8 6d 03 00 00       	call   80076f <cprintf>
  800402:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800405:	a1 20 40 80 00       	mov    0x804020,%eax
  80040a:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	52                   	push   %edx
  80041f:	50                   	push   %eax
  800420:	68 c4 37 80 00       	push   $0x8037c4
  800425:	e8 45 03 00 00       	call   80076f <cprintf>
  80042a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80042d:	a1 20 40 80 00       	mov    0x804020,%eax
  800432:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800438:	a1 20 40 80 00       	mov    0x804020,%eax
  80043d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800443:	a1 20 40 80 00       	mov    0x804020,%eax
  800448:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80044e:	51                   	push   %ecx
  80044f:	52                   	push   %edx
  800450:	50                   	push   %eax
  800451:	68 ec 37 80 00       	push   $0x8037ec
  800456:	e8 14 03 00 00       	call   80076f <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045e:	a1 20 40 80 00       	mov    0x804020,%eax
  800463:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	50                   	push   %eax
  80046d:	68 44 38 80 00       	push   $0x803844
  800472:	e8 f8 02 00 00       	call   80076f <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	68 9c 37 80 00       	push   $0x80379c
  800482:	e8 e8 02 00 00       	call   80076f <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80048a:	e8 41 17 00 00       	call   801bd0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80048f:	e8 19 00 00 00       	call   8004ad <exit>
}
  800494:	90                   	nop
  800495:	c9                   	leave  
  800496:	c3                   	ret    

00800497 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80049d:	83 ec 0c             	sub    $0xc,%esp
  8004a0:	6a 00                	push   $0x0
  8004a2:	e8 ce 18 00 00       	call   801d75 <sys_destroy_env>
  8004a7:	83 c4 10             	add    $0x10,%esp
}
  8004aa:	90                   	nop
  8004ab:	c9                   	leave  
  8004ac:	c3                   	ret    

008004ad <exit>:

void
exit(void)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
  8004b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004b3:	e8 23 19 00 00       	call   801ddb <sys_exit_env>
}
  8004b8:	90                   	nop
  8004b9:	c9                   	leave  
  8004ba:	c3                   	ret    

008004bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
  8004be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8004c4:	83 c0 04             	add    $0x4,%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ca:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	74 16                	je     8004e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004d3:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	50                   	push   %eax
  8004dc:	68 58 38 80 00       	push   $0x803858
  8004e1:	e8 89 02 00 00       	call   80076f <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e9:	a1 00 40 80 00       	mov    0x804000,%eax
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 5d 38 80 00       	push   $0x80385d
  8004fa:	e8 70 02 00 00       	call   80076f <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800502:	8b 45 10             	mov    0x10(%ebp),%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	ff 75 f4             	pushl  -0xc(%ebp)
  80050b:	50                   	push   %eax
  80050c:	e8 f3 01 00 00       	call   800704 <vcprintf>
  800511:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	6a 00                	push   $0x0
  800519:	68 79 38 80 00       	push   $0x803879
  80051e:	e8 e1 01 00 00       	call   800704 <vcprintf>
  800523:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800526:	e8 82 ff ff ff       	call   8004ad <exit>

	// should not return here
	while (1) ;
  80052b:	eb fe                	jmp    80052b <_panic+0x70>

0080052d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800533:	a1 20 40 80 00       	mov    0x804020,%eax
  800538:	8b 50 74             	mov    0x74(%eax),%edx
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 14                	je     800556 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 7c 38 80 00       	push   $0x80387c
  80054a:	6a 26                	push   $0x26
  80054c:	68 c8 38 80 00       	push   $0x8038c8
  800551:	e8 65 ff ff ff       	call   8004bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80055d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800564:	e9 c2 00 00 00       	jmp    80062b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	85 c0                	test   %eax,%eax
  80057c:	75 08                	jne    800586 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80057e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800581:	e9 a2 00 00 00       	jmp    800628 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800586:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800594:	eb 69                	jmp    8005ff <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800596:	a1 20 40 80 00       	mov    0x804020,%eax
  80059b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	01 c0                	add    %eax,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	c1 e0 03             	shl    $0x3,%eax
  8005ad:	01 c8                	add    %ecx,%eax
  8005af:	8a 40 04             	mov    0x4(%eax),%al
  8005b2:	84 c0                	test   %al,%al
  8005b4:	75 46                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005bb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c4:	89 d0                	mov    %edx,%eax
  8005c6:	01 c0                	add    %eax,%eax
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 03             	shl    $0x3,%eax
  8005cd:	01 c8                	add    %ecx,%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005dc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	01 c8                	add    %ecx,%eax
  8005ed:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ef:	39 c2                	cmp    %eax,%edx
  8005f1:	75 09                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005f3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005fa:	eb 12                	jmp    80060e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fc:	ff 45 e8             	incl   -0x18(%ebp)
  8005ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800604:	8b 50 74             	mov    0x74(%eax),%edx
  800607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	77 88                	ja     800596 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80060e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800612:	75 14                	jne    800628 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	68 d4 38 80 00       	push   $0x8038d4
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 c8 38 80 00       	push   $0x8038c8
  800623:	e8 93 fe ff ff       	call   8004bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800628:	ff 45 f0             	incl   -0x10(%ebp)
  80062b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800631:	0f 8c 32 ff ff ff    	jl     800569 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800637:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800645:	eb 26                	jmp    80066d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800647:	a1 20 40 80 00       	mov    0x804020,%eax
  80064c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800652:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	01 c0                	add    %eax,%eax
  800659:	01 d0                	add    %edx,%eax
  80065b:	c1 e0 03             	shl    $0x3,%eax
  80065e:	01 c8                	add    %ecx,%eax
  800660:	8a 40 04             	mov    0x4(%eax),%al
  800663:	3c 01                	cmp    $0x1,%al
  800665:	75 03                	jne    80066a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800667:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066a:	ff 45 e0             	incl   -0x20(%ebp)
  80066d:	a1 20 40 80 00       	mov    0x804020,%eax
  800672:	8b 50 74             	mov    0x74(%eax),%edx
  800675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800678:	39 c2                	cmp    %eax,%edx
  80067a:	77 cb                	ja     800647 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80067c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800682:	74 14                	je     800698 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800684:	83 ec 04             	sub    $0x4,%esp
  800687:	68 28 39 80 00       	push   $0x803928
  80068c:	6a 44                	push   $0x44
  80068e:	68 c8 38 80 00       	push   $0x8038c8
  800693:	e8 23 fe ff ff       	call   8004bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800698:	90                   	nop
  800699:	c9                   	leave  
  80069a:	c3                   	ret    

0080069b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80069b:	55                   	push   %ebp
  80069c:	89 e5                	mov    %esp,%ebp
  80069e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8006a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ac:	89 0a                	mov    %ecx,(%edx)
  8006ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b1:	88 d1                	mov    %dl,%cl
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c4:	75 2c                	jne    8006f2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006c6:	a0 24 40 80 00       	mov    0x804024,%al
  8006cb:	0f b6 c0             	movzbl %al,%eax
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	8b 12                	mov    (%edx),%edx
  8006d3:	89 d1                	mov    %edx,%ecx
  8006d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d8:	83 c2 08             	add    $0x8,%edx
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	50                   	push   %eax
  8006df:	51                   	push   %ecx
  8006e0:	52                   	push   %edx
  8006e1:	e8 22 13 00 00       	call   801a08 <sys_cputs>
  8006e6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f5:	8b 40 04             	mov    0x4(%eax),%eax
  8006f8:	8d 50 01             	lea    0x1(%eax),%edx
  8006fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fe:	89 50 04             	mov    %edx,0x4(%eax)
}
  800701:	90                   	nop
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800714:	00 00 00 
	b.cnt = 0;
  800717:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80071e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072d:	50                   	push   %eax
  80072e:	68 9b 06 80 00       	push   $0x80069b
  800733:	e8 11 02 00 00       	call   800949 <vprintfmt>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80073b:	a0 24 40 80 00       	mov    0x804024,%al
  800740:	0f b6 c0             	movzbl %al,%eax
  800743:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	50                   	push   %eax
  80074d:	52                   	push   %edx
  80074e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800754:	83 c0 08             	add    $0x8,%eax
  800757:	50                   	push   %eax
  800758:	e8 ab 12 00 00       	call   801a08 <sys_cputs>
  80075d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800760:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800767:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80076d:	c9                   	leave  
  80076e:	c3                   	ret    

0080076f <cprintf>:

int cprintf(const char *fmt, ...) {
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800775:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80077c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 f4             	pushl  -0xc(%ebp)
  80078b:	50                   	push   %eax
  80078c:	e8 73 ff ff ff       	call   800704 <vcprintf>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    

0080079c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a2:	e8 0f 14 00 00       	call   801bb6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007a7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b6:	50                   	push   %eax
  8007b7:	e8 48 ff ff ff       	call   800704 <vcprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007c2:	e8 09 14 00 00       	call   801bd0 <sys_enable_interrupt>
	return cnt;
  8007c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    

008007cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	53                   	push   %ebx
  8007d0:	83 ec 14             	sub    $0x14,%esp
  8007d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007df:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ea:	77 55                	ja     800841 <printnum+0x75>
  8007ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ef:	72 05                	jb     8007f6 <printnum+0x2a>
  8007f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f4:	77 4b                	ja     800841 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	52                   	push   %edx
  800805:	50                   	push   %eax
  800806:	ff 75 f4             	pushl  -0xc(%ebp)
  800809:	ff 75 f0             	pushl  -0x10(%ebp)
  80080c:	e8 67 2a 00 00       	call   803278 <__udivdi3>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	83 ec 04             	sub    $0x4,%esp
  800817:	ff 75 20             	pushl  0x20(%ebp)
  80081a:	53                   	push   %ebx
  80081b:	ff 75 18             	pushl  0x18(%ebp)
  80081e:	52                   	push   %edx
  80081f:	50                   	push   %eax
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	ff 75 08             	pushl  0x8(%ebp)
  800826:	e8 a1 ff ff ff       	call   8007cc <printnum>
  80082b:	83 c4 20             	add    $0x20,%esp
  80082e:	eb 1a                	jmp    80084a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 20             	pushl  0x20(%ebp)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800841:	ff 4d 1c             	decl   0x1c(%ebp)
  800844:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800848:	7f e6                	jg     800830 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80084d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800858:	53                   	push   %ebx
  800859:	51                   	push   %ecx
  80085a:	52                   	push   %edx
  80085b:	50                   	push   %eax
  80085c:	e8 27 2b 00 00       	call   803388 <__umoddi3>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	05 94 3b 80 00       	add    $0x803b94,%eax
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f be c0             	movsbl %al,%eax
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	50                   	push   %eax
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
}
  80087d:	90                   	nop
  80087e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800881:	c9                   	leave  
  800882:	c3                   	ret    

00800883 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800886:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088a:	7e 1c                	jle    8008a8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 08             	lea    0x8(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 08             	sub    $0x8,%eax
  8008a1:	8b 50 04             	mov    0x4(%eax),%edx
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	eb 40                	jmp    8008e8 <getuint+0x65>
	else if (lflag)
  8008a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ac:	74 1e                	je     8008cc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	8d 50 04             	lea    0x4(%eax),%edx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	89 10                	mov    %edx,(%eax)
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	83 e8 04             	sub    $0x4,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	eb 1c                	jmp    8008e8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	8d 50 04             	lea    0x4(%eax),%edx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 10                	mov    %edx,(%eax)
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	83 e8 04             	sub    $0x4,%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f1:	7e 1c                	jle    80090f <getint+0x25>
		return va_arg(*ap, long long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 08             	lea    0x8(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 08             	sub    $0x8,%eax
  800908:	8b 50 04             	mov    0x4(%eax),%edx
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	eb 38                	jmp    800947 <getint+0x5d>
	else if (lflag)
  80090f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800913:	74 1a                	je     80092f <getint+0x45>
		return va_arg(*ap, long);
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	8d 50 04             	lea    0x4(%eax),%edx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	89 10                	mov    %edx,(%eax)
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	83 e8 04             	sub    $0x4,%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	99                   	cltd   
  80092d:	eb 18                	jmp    800947 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	8d 50 04             	lea    0x4(%eax),%edx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 10                	mov    %edx,(%eax)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	99                   	cltd   
}
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
  80094e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800951:	eb 17                	jmp    80096a <vprintfmt+0x21>
			if (ch == '\0')
  800953:	85 db                	test   %ebx,%ebx
  800955:	0f 84 af 03 00 00    	je     800d0a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	53                   	push   %ebx
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	ff d0                	call   *%eax
  800967:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096a:	8b 45 10             	mov    0x10(%ebp),%eax
  80096d:	8d 50 01             	lea    0x1(%eax),%edx
  800970:	89 55 10             	mov    %edx,0x10(%ebp)
  800973:	8a 00                	mov    (%eax),%al
  800975:	0f b6 d8             	movzbl %al,%ebx
  800978:	83 fb 25             	cmp    $0x25,%ebx
  80097b:	75 d6                	jne    800953 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80097d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800981:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800988:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80098f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800996:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099d:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a0:	8d 50 01             	lea    0x1(%eax),%edx
  8009a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a6:	8a 00                	mov    (%eax),%al
  8009a8:	0f b6 d8             	movzbl %al,%ebx
  8009ab:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ae:	83 f8 55             	cmp    $0x55,%eax
  8009b1:	0f 87 2b 03 00 00    	ja     800ce2 <vprintfmt+0x399>
  8009b7:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
  8009be:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c4:	eb d7                	jmp    80099d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ca:	eb d1                	jmp    80099d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d6:	89 d0                	mov    %edx,%eax
  8009d8:	c1 e0 02             	shl    $0x2,%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	01 c0                	add    %eax,%eax
  8009df:	01 d8                	add    %ebx,%eax
  8009e1:	83 e8 30             	sub    $0x30,%eax
  8009e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ef:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f2:	7e 3e                	jle    800a32 <vprintfmt+0xe9>
  8009f4:	83 fb 39             	cmp    $0x39,%ebx
  8009f7:	7f 39                	jg     800a32 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009fc:	eb d5                	jmp    8009d3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	83 c0 04             	add    $0x4,%eax
  800a04:	89 45 14             	mov    %eax,0x14(%ebp)
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	83 e8 04             	sub    $0x4,%eax
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a12:	eb 1f                	jmp    800a33 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a18:	79 83                	jns    80099d <vprintfmt+0x54>
				width = 0;
  800a1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a21:	e9 77 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a26:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a2d:	e9 6b ff ff ff       	jmp    80099d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a32:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a37:	0f 89 60 ff ff ff    	jns    80099d <vprintfmt+0x54>
				width = precision, precision = -1;
  800a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a43:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a4a:	e9 4e ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a4f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a52:	e9 46 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	83 c0 04             	add    $0x4,%eax
  800a5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 e8 04             	sub    $0x4,%eax
  800a66:	8b 00                	mov    (%eax),%eax
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	50                   	push   %eax
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
			break;
  800a77:	e9 89 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a8d:	85 db                	test   %ebx,%ebx
  800a8f:	79 02                	jns    800a93 <vprintfmt+0x14a>
				err = -err;
  800a91:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a93:	83 fb 64             	cmp    $0x64,%ebx
  800a96:	7f 0b                	jg     800aa3 <vprintfmt+0x15a>
  800a98:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  800a9f:	85 f6                	test   %esi,%esi
  800aa1:	75 19                	jne    800abc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	53                   	push   %ebx
  800aa4:	68 a5 3b 80 00       	push   $0x803ba5
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	ff 75 08             	pushl  0x8(%ebp)
  800aaf:	e8 5e 02 00 00       	call   800d12 <printfmt>
  800ab4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab7:	e9 49 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800abc:	56                   	push   %esi
  800abd:	68 ae 3b 80 00       	push   $0x803bae
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	ff 75 08             	pushl  0x8(%ebp)
  800ac8:	e8 45 02 00 00       	call   800d12 <printfmt>
  800acd:	83 c4 10             	add    $0x10,%esp
			break;
  800ad0:	e9 30 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	83 c0 04             	add    $0x4,%eax
  800adb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	83 e8 04             	sub    $0x4,%eax
  800ae4:	8b 30                	mov    (%eax),%esi
  800ae6:	85 f6                	test   %esi,%esi
  800ae8:	75 05                	jne    800aef <vprintfmt+0x1a6>
				p = "(null)";
  800aea:	be b1 3b 80 00       	mov    $0x803bb1,%esi
			if (width > 0 && padc != '-')
  800aef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af3:	7e 6d                	jle    800b62 <vprintfmt+0x219>
  800af5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800af9:	74 67                	je     800b62 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	50                   	push   %eax
  800b02:	56                   	push   %esi
  800b03:	e8 0c 03 00 00       	call   800e14 <strnlen>
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b0e:	eb 16                	jmp    800b26 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b10:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	50                   	push   %eax
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	ff d0                	call   *%eax
  800b20:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b23:	ff 4d e4             	decl   -0x1c(%ebp)
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7f e4                	jg     800b10 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2c:	eb 34                	jmp    800b62 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b32:	74 1c                	je     800b50 <vprintfmt+0x207>
  800b34:	83 fb 1f             	cmp    $0x1f,%ebx
  800b37:	7e 05                	jle    800b3e <vprintfmt+0x1f5>
  800b39:	83 fb 7e             	cmp    $0x7e,%ebx
  800b3c:	7e 12                	jle    800b50 <vprintfmt+0x207>
					putch('?', putdat);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	6a 3f                	push   $0x3f
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	ff d0                	call   *%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	eb 0f                	jmp    800b5f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	53                   	push   %ebx
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	89 f0                	mov    %esi,%eax
  800b64:	8d 70 01             	lea    0x1(%eax),%esi
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	0f be d8             	movsbl %al,%ebx
  800b6c:	85 db                	test   %ebx,%ebx
  800b6e:	74 24                	je     800b94 <vprintfmt+0x24b>
  800b70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b74:	78 b8                	js     800b2e <vprintfmt+0x1e5>
  800b76:	ff 4d e0             	decl   -0x20(%ebp)
  800b79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7d:	79 af                	jns    800b2e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7f:	eb 13                	jmp    800b94 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 20                	push   $0x20
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b91:	ff 4d e4             	decl   -0x1c(%ebp)
  800b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b98:	7f e7                	jg     800b81 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b9a:	e9 66 01 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 3c fd ff ff       	call   8008ea <getint>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbd:	85 d2                	test   %edx,%edx
  800bbf:	79 23                	jns    800be4 <vprintfmt+0x29b>
				putch('-', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 2d                	push   $0x2d
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd7:	f7 d8                	neg    %eax
  800bd9:	83 d2 00             	adc    $0x0,%edx
  800bdc:	f7 da                	neg    %edx
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800beb:	e9 bc 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf6:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf9:	50                   	push   %eax
  800bfa:	e8 84 fc ff ff       	call   800883 <getuint>
  800bff:	83 c4 10             	add    $0x10,%esp
  800c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c0f:	e9 98 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 0c             	pushl  0xc(%ebp)
  800c1a:	6a 58                	push   $0x58
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	ff d0                	call   *%eax
  800c21:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	6a 58                	push   $0x58
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	ff d0                	call   *%eax
  800c31:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	6a 58                	push   $0x58
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	ff d0                	call   *%eax
  800c41:	83 c4 10             	add    $0x10,%esp
			break;
  800c44:	e9 bc 00 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 30                	push   $0x30
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	6a 78                	push   $0x78
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	ff d0                	call   *%eax
  800c66:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c8b:	eb 1f                	jmp    800cac <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c8d:	83 ec 08             	sub    $0x8,%esp
  800c90:	ff 75 e8             	pushl  -0x18(%ebp)
  800c93:	8d 45 14             	lea    0x14(%ebp),%eax
  800c96:	50                   	push   %eax
  800c97:	e8 e7 fb ff ff       	call   800883 <getuint>
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ca5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cac:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	52                   	push   %edx
  800cb7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbe:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	ff 75 08             	pushl  0x8(%ebp)
  800cc7:	e8 00 fb ff ff       	call   8007cc <printnum>
  800ccc:	83 c4 20             	add    $0x20,%esp
			break;
  800ccf:	eb 34                	jmp    800d05 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	53                   	push   %ebx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	ff d0                	call   *%eax
  800cdd:	83 c4 10             	add    $0x10,%esp
			break;
  800ce0:	eb 23                	jmp    800d05 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	6a 25                	push   $0x25
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	ff d0                	call   *%eax
  800cef:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf2:	ff 4d 10             	decl   0x10(%ebp)
  800cf5:	eb 03                	jmp    800cfa <vprintfmt+0x3b1>
  800cf7:	ff 4d 10             	decl   0x10(%ebp)
  800cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfd:	48                   	dec    %eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	3c 25                	cmp    $0x25,%al
  800d02:	75 f3                	jne    800cf7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d04:	90                   	nop
		}
	}
  800d05:	e9 47 fc ff ff       	jmp    800951 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d0a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d18:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1b:	83 c0 04             	add    $0x4,%eax
  800d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	ff 75 f4             	pushl  -0xc(%ebp)
  800d27:	50                   	push   %eax
  800d28:	ff 75 0c             	pushl  0xc(%ebp)
  800d2b:	ff 75 08             	pushl  0x8(%ebp)
  800d2e:	e8 16 fc ff ff       	call   800949 <vprintfmt>
  800d33:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d36:	90                   	nop
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 08             	mov    0x8(%eax),%eax
  800d42:	8d 50 01             	lea    0x1(%eax),%edx
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8b 10                	mov    (%eax),%edx
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	8b 40 04             	mov    0x4(%eax),%eax
  800d56:	39 c2                	cmp    %eax,%edx
  800d58:	73 12                	jae    800d6c <sprintputch+0x33>
		*b->buf++ = ch;
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d65:	89 0a                	mov    %ecx,(%edx)
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	88 10                	mov    %dl,(%eax)
}
  800d6c:	90                   	nop
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	01 d0                	add    %edx,%eax
  800d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d94:	74 06                	je     800d9c <vsnprintf+0x2d>
  800d96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9a:	7f 07                	jg     800da3 <vsnprintf+0x34>
		return -E_INVAL;
  800d9c:	b8 03 00 00 00       	mov    $0x3,%eax
  800da1:	eb 20                	jmp    800dc3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800da3:	ff 75 14             	pushl  0x14(%ebp)
  800da6:	ff 75 10             	pushl  0x10(%ebp)
  800da9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dac:	50                   	push   %eax
  800dad:	68 39 0d 80 00       	push   $0x800d39
  800db2:	e8 92 fb ff ff       	call   800949 <vprintfmt>
  800db7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dbd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800dce:	83 c0 04             	add    $0x4,%eax
  800dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dda:	50                   	push   %eax
  800ddb:	ff 75 0c             	pushl  0xc(%ebp)
  800dde:	ff 75 08             	pushl  0x8(%ebp)
  800de1:	e8 89 ff ff ff       	call   800d6f <vsnprintf>
  800de6:	83 c4 10             	add    $0x10,%esp
  800de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800df7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dfe:	eb 06                	jmp    800e06 <strlen+0x15>
		n++;
  800e00:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e03:	ff 45 08             	incl   0x8(%ebp)
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	84 c0                	test   %al,%al
  800e0d:	75 f1                	jne    800e00 <strlen+0xf>
		n++;
	return n;
  800e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e12:	c9                   	leave  
  800e13:	c3                   	ret    

00800e14 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e21:	eb 09                	jmp    800e2c <strnlen+0x18>
		n++;
  800e23:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e26:	ff 45 08             	incl   0x8(%ebp)
  800e29:	ff 4d 0c             	decl   0xc(%ebp)
  800e2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e30:	74 09                	je     800e3b <strnlen+0x27>
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	84 c0                	test   %al,%al
  800e39:	75 e8                	jne    800e23 <strnlen+0xf>
		n++;
	return n;
  800e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e4c:	90                   	nop
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 08             	mov    %edx,0x8(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e5f:	8a 12                	mov    (%edx),%dl
  800e61:	88 10                	mov    %dl,(%eax)
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	75 e4                	jne    800e4d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e81:	eb 1f                	jmp    800ea2 <strncpy+0x34>
		*dst++ = *src;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8d 50 01             	lea    0x1(%eax),%edx
  800e89:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	84 c0                	test   %al,%al
  800e9a:	74 03                	je     800e9f <strncpy+0x31>
			src++;
  800e9c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ea8:	72 d9                	jb     800e83 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebf:	74 30                	je     800ef1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ec1:	eb 16                	jmp    800ed9 <strlcpy+0x2a>
			*dst++ = *src++;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed5:	8a 12                	mov    (%edx),%dl
  800ed7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ed9:	ff 4d 10             	decl   0x10(%ebp)
  800edc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee0:	74 09                	je     800eeb <strlcpy+0x3c>
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 d8                	jne    800ec3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 d0                	mov    %edx,%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f00:	eb 06                	jmp    800f08 <strcmp+0xb>
		p++, q++;
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	84 c0                	test   %al,%al
  800f0f:	74 0e                	je     800f1f <strcmp+0x22>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 10                	mov    (%eax),%dl
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	38 c2                	cmp    %al,%dl
  800f1d:	74 e3                	je     800f02 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 d0             	movzbl %al,%edx
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 c0             	movzbl %al,%eax
  800f2f:	29 c2                	sub    %eax,%edx
  800f31:	89 d0                	mov    %edx,%eax
}
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f38:	eb 09                	jmp    800f43 <strncmp+0xe>
		n--, p++, q++;
  800f3a:	ff 4d 10             	decl   0x10(%ebp)
  800f3d:	ff 45 08             	incl   0x8(%ebp)
  800f40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	74 17                	je     800f60 <strncmp+0x2b>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	84 c0                	test   %al,%al
  800f50:	74 0e                	je     800f60 <strncmp+0x2b>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 10                	mov    (%eax),%dl
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	38 c2                	cmp    %al,%dl
  800f5e:	74 da                	je     800f3a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	75 07                	jne    800f6d <strncmp+0x38>
		return 0;
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	eb 14                	jmp    800f81 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 d0             	movzbl %al,%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	0f b6 c0             	movzbl %al,%eax
  800f7d:	29 c2                	sub    %eax,%edx
  800f7f:	89 d0                	mov    %edx,%eax
}
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8f:	eb 12                	jmp    800fa3 <strchr+0x20>
		if (*s == c)
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f99:	75 05                	jne    800fa0 <strchr+0x1d>
			return (char *) s;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	eb 11                	jmp    800fb1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fa0:	ff 45 08             	incl   0x8(%ebp)
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	84 c0                	test   %al,%al
  800faa:	75 e5                	jne    800f91 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbf:	eb 0d                	jmp    800fce <strfind+0x1b>
		if (*s == c)
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc9:	74 0e                	je     800fd9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fcb:	ff 45 08             	incl   0x8(%ebp)
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	84 c0                	test   %al,%al
  800fd5:	75 ea                	jne    800fc1 <strfind+0xe>
  800fd7:	eb 01                	jmp    800fda <strfind+0x27>
		if (*s == c)
			break;
  800fd9:	90                   	nop
	return (char *) s;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ff1:	eb 0e                	jmp    801001 <memset+0x22>
		*p++ = c;
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	8d 50 01             	lea    0x1(%eax),%edx
  800ff9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fff:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801001:	ff 4d f8             	decl   -0x8(%ebp)
  801004:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801008:	79 e9                	jns    800ff3 <memset+0x14>
		*p++ = c;

	return v;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801021:	eb 16                	jmp    801039 <memcpy+0x2a>
		*d++ = *s++;
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801032:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801035:	8a 12                	mov    (%edx),%dl
  801037:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103f:	89 55 10             	mov    %edx,0x10(%ebp)
  801042:	85 c0                	test   %eax,%eax
  801044:	75 dd                	jne    801023 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801060:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801063:	73 50                	jae    8010b5 <memmove+0x6a>
  801065:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801068:	8b 45 10             	mov    0x10(%ebp),%eax
  80106b:	01 d0                	add    %edx,%eax
  80106d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801070:	76 43                	jbe    8010b5 <memmove+0x6a>
		s += n;
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80107e:	eb 10                	jmp    801090 <memmove+0x45>
			*--d = *--s;
  801080:	ff 4d f8             	decl   -0x8(%ebp)
  801083:	ff 4d fc             	decl   -0x4(%ebp)
  801086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801089:	8a 10                	mov    (%eax),%dl
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801090:	8b 45 10             	mov    0x10(%ebp),%eax
  801093:	8d 50 ff             	lea    -0x1(%eax),%edx
  801096:	89 55 10             	mov    %edx,0x10(%ebp)
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 e3                	jne    801080 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80109d:	eb 23                	jmp    8010c2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80109f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a2:	8d 50 01             	lea    0x1(%eax),%edx
  8010a5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ae:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b1:	8a 12                	mov    (%edx),%dl
  8010b3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	75 dd                	jne    80109f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010d9:	eb 2a                	jmp    801105 <memcmp+0x3e>
		if (*s1 != *s2)
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8a 10                	mov    (%eax),%dl
  8010e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	38 c2                	cmp    %al,%dl
  8010e7:	74 16                	je     8010ff <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	0f b6 d0             	movzbl %al,%edx
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	0f b6 c0             	movzbl %al,%eax
  8010f9:	29 c2                	sub    %eax,%edx
  8010fb:	89 d0                	mov    %edx,%eax
  8010fd:	eb 18                	jmp    801117 <memcmp+0x50>
		s1++, s2++;
  8010ff:	ff 45 fc             	incl   -0x4(%ebp)
  801102:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110b:	89 55 10             	mov    %edx,0x10(%ebp)
  80110e:	85 c0                	test   %eax,%eax
  801110:	75 c9                	jne    8010db <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801112:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80111f:	8b 55 08             	mov    0x8(%ebp),%edx
  801122:	8b 45 10             	mov    0x10(%ebp),%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80112a:	eb 15                	jmp    801141 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d0             	movzbl %al,%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	0f b6 c0             	movzbl %al,%eax
  80113a:	39 c2                	cmp    %eax,%edx
  80113c:	74 0d                	je     80114b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80113e:	ff 45 08             	incl   0x8(%ebp)
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801147:	72 e3                	jb     80112c <memfind+0x13>
  801149:	eb 01                	jmp    80114c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80114b:	90                   	nop
	return (void *) s;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80115e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801165:	eb 03                	jmp    80116a <strtol+0x19>
		s++;
  801167:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 20                	cmp    $0x20,%al
  801171:	74 f4                	je     801167 <strtol+0x16>
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 09                	cmp    $0x9,%al
  80117a:	74 eb                	je     801167 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 2b                	cmp    $0x2b,%al
  801183:	75 05                	jne    80118a <strtol+0x39>
		s++;
  801185:	ff 45 08             	incl   0x8(%ebp)
  801188:	eb 13                	jmp    80119d <strtol+0x4c>
	else if (*s == '-')
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 2d                	cmp    $0x2d,%al
  801191:	75 0a                	jne    80119d <strtol+0x4c>
		s++, neg = 1;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80119d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a1:	74 06                	je     8011a9 <strtol+0x58>
  8011a3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011a7:	75 20                	jne    8011c9 <strtol+0x78>
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3c 30                	cmp    $0x30,%al
  8011b0:	75 17                	jne    8011c9 <strtol+0x78>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	40                   	inc    %eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 78                	cmp    $0x78,%al
  8011ba:	75 0d                	jne    8011c9 <strtol+0x78>
		s += 2, base = 16;
  8011bc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011c0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011c7:	eb 28                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cd:	75 15                	jne    8011e4 <strtol+0x93>
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 30                	cmp    $0x30,%al
  8011d6:	75 0c                	jne    8011e4 <strtol+0x93>
		s++, base = 8;
  8011d8:	ff 45 08             	incl   0x8(%ebp)
  8011db:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011e2:	eb 0d                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0)
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 07                	jne    8011f1 <strtol+0xa0>
		base = 10;
  8011ea:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 2f                	cmp    $0x2f,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xc2>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 39                	cmp    $0x39,%al
  801201:	7f 10                	jg     801213 <strtol+0xc2>
			dig = *s - '0';
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 30             	sub    $0x30,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 42                	jmp    801255 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 60                	cmp    $0x60,%al
  80121a:	7e 19                	jle    801235 <strtol+0xe4>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 7a                	cmp    $0x7a,%al
  801223:	7f 10                	jg     801235 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 57             	sub    $0x57,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801233:	eb 20                	jmp    801255 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 40                	cmp    $0x40,%al
  80123c:	7e 39                	jle    801277 <strtol+0x126>
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	3c 5a                	cmp    $0x5a,%al
  801245:	7f 30                	jg     801277 <strtol+0x126>
			dig = *s - 'A' + 10;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	0f be c0             	movsbl %al,%eax
  80124f:	83 e8 37             	sub    $0x37,%eax
  801252:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	3b 45 10             	cmp    0x10(%ebp),%eax
  80125b:	7d 19                	jge    801276 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80125d:	ff 45 08             	incl   0x8(%ebp)
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801263:	0f af 45 10          	imul   0x10(%ebp),%eax
  801267:	89 c2                	mov    %eax,%edx
  801269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801271:	e9 7b ff ff ff       	jmp    8011f1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801276:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801277:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80127b:	74 08                	je     801285 <strtol+0x134>
		*endptr = (char *) s;
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	8b 55 08             	mov    0x8(%ebp),%edx
  801283:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801285:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801289:	74 07                	je     801292 <strtol+0x141>
  80128b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128e:	f7 d8                	neg    %eax
  801290:	eb 03                	jmp    801295 <strtol+0x144>
  801292:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <ltostr>:

void
ltostr(long value, char *str)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80129d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012af:	79 13                	jns    8012c4 <ltostr+0x2d>
	{
		neg = 1;
  8012b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012be:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012c1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012cc:	99                   	cltd   
  8012cd:	f7 f9                	idiv   %ecx
  8012cf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012e5:	83 c2 30             	add    $0x30,%edx
  8012e8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ed:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f2:	f7 e9                	imul   %ecx
  8012f4:	c1 fa 02             	sar    $0x2,%edx
  8012f7:	89 c8                	mov    %ecx,%eax
  8012f9:	c1 f8 1f             	sar    $0x1f,%eax
  8012fc:	29 c2                	sub    %eax,%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801306:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130b:	f7 e9                	imul   %ecx
  80130d:	c1 fa 02             	sar    $0x2,%edx
  801310:	89 c8                	mov    %ecx,%eax
  801312:	c1 f8 1f             	sar    $0x1f,%eax
  801315:	29 c2                	sub    %eax,%edx
  801317:	89 d0                	mov    %edx,%eax
  801319:	c1 e0 02             	shl    $0x2,%eax
  80131c:	01 d0                	add    %edx,%eax
  80131e:	01 c0                	add    %eax,%eax
  801320:	29 c1                	sub    %eax,%ecx
  801322:	89 ca                	mov    %ecx,%edx
  801324:	85 d2                	test   %edx,%edx
  801326:	75 9c                	jne    8012c4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801332:	48                   	dec    %eax
  801333:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801336:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80133a:	74 3d                	je     801379 <ltostr+0xe2>
		start = 1 ;
  80133c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801343:	eb 34                	jmp    801379 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80135d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801360:	01 c8                	add    %ecx,%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	01 c2                	add    %eax,%edx
  80136e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801371:	88 02                	mov    %al,(%edx)
		start++ ;
  801373:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801376:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80137f:	7c c4                	jl     801345 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801381:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 d0                	add    %edx,%eax
  801389:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80138c:	90                   	nop
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801395:	ff 75 08             	pushl  0x8(%ebp)
  801398:	e8 54 fa ff ff       	call   800df1 <strlen>
  80139d:	83 c4 04             	add    $0x4,%esp
  8013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	e8 46 fa ff ff       	call   800df1 <strlen>
  8013ab:	83 c4 04             	add    $0x4,%esp
  8013ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013bf:	eb 17                	jmp    8013d8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	01 c2                	add    %eax,%edx
  8013c9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	01 c8                	add    %ecx,%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013d5:	ff 45 fc             	incl   -0x4(%ebp)
  8013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013de:	7c e1                	jl     8013c1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013ee:	eb 1f                	jmp    80140f <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f3:	8d 50 01             	lea    0x1(%eax),%edx
  8013f6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013f9:	89 c2                	mov    %eax,%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80140c:	ff 45 f8             	incl   -0x8(%ebp)
  80140f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801412:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801415:	7c d9                	jl     8013f0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801417:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141a:	8b 45 10             	mov    0x10(%ebp),%eax
  80141d:	01 d0                	add    %edx,%eax
  80141f:	c6 00 00             	movb   $0x0,(%eax)
}
  801422:	90                   	nop
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801428:	8b 45 14             	mov    0x14(%ebp),%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801431:	8b 45 14             	mov    0x14(%ebp),%eax
  801434:	8b 00                	mov    (%eax),%eax
  801436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80143d:	8b 45 10             	mov    0x10(%ebp),%eax
  801440:	01 d0                	add    %edx,%eax
  801442:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801448:	eb 0c                	jmp    801456 <strsplit+0x31>
			*string++ = 0;
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 08             	mov    %edx,0x8(%ebp)
  801453:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	84 c0                	test   %al,%al
  80145d:	74 18                	je     801477 <strsplit+0x52>
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	0f be c0             	movsbl %al,%eax
  801467:	50                   	push   %eax
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	e8 13 fb ff ff       	call   800f83 <strchr>
  801470:	83 c4 08             	add    $0x8,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	75 d3                	jne    80144a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	84 c0                	test   %al,%al
  80147e:	74 5a                	je     8014da <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801480:	8b 45 14             	mov    0x14(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	83 f8 0f             	cmp    $0xf,%eax
  801488:	75 07                	jne    801491 <strsplit+0x6c>
		{
			return 0;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
  80148f:	eb 66                	jmp    8014f7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801491:	8b 45 14             	mov    0x14(%ebp),%eax
  801494:	8b 00                	mov    (%eax),%eax
  801496:	8d 48 01             	lea    0x1(%eax),%ecx
  801499:	8b 55 14             	mov    0x14(%ebp),%edx
  80149c:	89 0a                	mov    %ecx,(%edx)
  80149e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a8:	01 c2                	add    %eax,%edx
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014af:	eb 03                	jmp    8014b4 <strsplit+0x8f>
			string++;
  8014b1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	84 c0                	test   %al,%al
  8014bb:	74 8b                	je     801448 <strsplit+0x23>
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	0f be c0             	movsbl %al,%eax
  8014c5:	50                   	push   %eax
  8014c6:	ff 75 0c             	pushl  0xc(%ebp)
  8014c9:	e8 b5 fa ff ff       	call   800f83 <strchr>
  8014ce:	83 c4 08             	add    $0x8,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	74 dc                	je     8014b1 <strsplit+0x8c>
			string++;
	}
  8014d5:	e9 6e ff ff ff       	jmp    801448 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014da:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014db:	8b 45 14             	mov    0x14(%ebp),%eax
  8014de:	8b 00                	mov    (%eax),%eax
  8014e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014ff:	a1 04 40 80 00       	mov    0x804004,%eax
  801504:	85 c0                	test   %eax,%eax
  801506:	74 1f                	je     801527 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801508:	e8 1d 00 00 00       	call   80152a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80150d:	83 ec 0c             	sub    $0xc,%esp
  801510:	68 10 3d 80 00       	push   $0x803d10
  801515:	e8 55 f2 ff ff       	call   80076f <cprintf>
  80151a:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80151d:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801524:	00 00 00 
	}
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801530:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801537:	00 00 00 
  80153a:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801541:	00 00 00 
  801544:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80154b:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80154e:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801555:	00 00 00 
  801558:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80155f:	00 00 00 
  801562:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801569:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80156c:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801573:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801576:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801580:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801585:	2d 00 10 00 00       	sub    $0x1000,%eax
  80158a:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80158f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801596:	a1 20 41 80 00       	mov    0x804120,%eax
  80159b:	c1 e0 04             	shl    $0x4,%eax
  80159e:	89 c2                	mov    %eax,%edx
  8015a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a3:	01 d0                	add    %edx,%eax
  8015a5:	48                   	dec    %eax
  8015a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b1:	f7 75 f0             	divl   -0x10(%ebp)
  8015b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b7:	29 d0                	sub    %edx,%eax
  8015b9:	89 c2                	mov    %eax,%edx
  8015bb:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8015c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ca:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	6a 06                	push   $0x6
  8015d4:	52                   	push   %edx
  8015d5:	50                   	push   %eax
  8015d6:	e8 71 05 00 00       	call   801b4c <sys_allocate_chunk>
  8015db:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015de:	a1 20 41 80 00       	mov    0x804120,%eax
  8015e3:	83 ec 0c             	sub    $0xc,%esp
  8015e6:	50                   	push   %eax
  8015e7:	e8 e6 0b 00 00       	call   8021d2 <initialize_MemBlocksList>
  8015ec:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8015ef:	a1 48 41 80 00       	mov    0x804148,%eax
  8015f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8015f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015fb:	75 14                	jne    801611 <initialize_dyn_block_system+0xe7>
  8015fd:	83 ec 04             	sub    $0x4,%esp
  801600:	68 35 3d 80 00       	push   $0x803d35
  801605:	6a 2b                	push   $0x2b
  801607:	68 53 3d 80 00       	push   $0x803d53
  80160c:	e8 aa ee ff ff       	call   8004bb <_panic>
  801611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801614:	8b 00                	mov    (%eax),%eax
  801616:	85 c0                	test   %eax,%eax
  801618:	74 10                	je     80162a <initialize_dyn_block_system+0x100>
  80161a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80161d:	8b 00                	mov    (%eax),%eax
  80161f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801622:	8b 52 04             	mov    0x4(%edx),%edx
  801625:	89 50 04             	mov    %edx,0x4(%eax)
  801628:	eb 0b                	jmp    801635 <initialize_dyn_block_system+0x10b>
  80162a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80162d:	8b 40 04             	mov    0x4(%eax),%eax
  801630:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801638:	8b 40 04             	mov    0x4(%eax),%eax
  80163b:	85 c0                	test   %eax,%eax
  80163d:	74 0f                	je     80164e <initialize_dyn_block_system+0x124>
  80163f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801642:	8b 40 04             	mov    0x4(%eax),%eax
  801645:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801648:	8b 12                	mov    (%edx),%edx
  80164a:	89 10                	mov    %edx,(%eax)
  80164c:	eb 0a                	jmp    801658 <initialize_dyn_block_system+0x12e>
  80164e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801651:	8b 00                	mov    (%eax),%eax
  801653:	a3 48 41 80 00       	mov    %eax,0x804148
  801658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80165b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801664:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80166b:	a1 54 41 80 00       	mov    0x804154,%eax
  801670:	48                   	dec    %eax
  801671:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801679:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801683:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80168a:	83 ec 0c             	sub    $0xc,%esp
  80168d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801690:	e8 d2 13 00 00       	call   802a67 <insert_sorted_with_merge_freeList>
  801695:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801698:	90                   	nop
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a1:	e8 53 fe ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016aa:	75 07                	jne    8016b3 <malloc+0x18>
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b1:	eb 61                	jmp    801714 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8016b3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c0:	01 d0                	add    %edx,%eax
  8016c2:	48                   	dec    %eax
  8016c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ce:	f7 75 f4             	divl   -0xc(%ebp)
  8016d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d4:	29 d0                	sub    %edx,%eax
  8016d6:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016d9:	e8 3c 08 00 00       	call   801f1a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016de:	85 c0                	test   %eax,%eax
  8016e0:	74 2d                	je     80170f <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8016e2:	83 ec 0c             	sub    $0xc,%esp
  8016e5:	ff 75 08             	pushl  0x8(%ebp)
  8016e8:	e8 3e 0f 00 00       	call   80262b <alloc_block_FF>
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8016f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016f7:	74 16                	je     80170f <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8016f9:	83 ec 0c             	sub    $0xc,%esp
  8016fc:	ff 75 ec             	pushl  -0x14(%ebp)
  8016ff:	e8 48 0c 00 00       	call   80234c <insert_sorted_allocList>
  801704:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170a:	8b 40 08             	mov    0x8(%eax),%eax
  80170d:	eb 05                	jmp    801714 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  80170f:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801725:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80172a:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	83 ec 08             	sub    $0x8,%esp
  801733:	50                   	push   %eax
  801734:	68 40 40 80 00       	push   $0x804040
  801739:	e8 71 0b 00 00       	call   8022af <find_block>
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801747:	8b 50 0c             	mov    0xc(%eax),%edx
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	83 ec 08             	sub    $0x8,%esp
  801750:	52                   	push   %edx
  801751:	50                   	push   %eax
  801752:	e8 bd 03 00 00       	call   801b14 <sys_free_user_mem>
  801757:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80175a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80175e:	75 14                	jne    801774 <free+0x5e>
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	68 35 3d 80 00       	push   $0x803d35
  801768:	6a 71                	push   $0x71
  80176a:	68 53 3d 80 00       	push   $0x803d53
  80176f:	e8 47 ed ff ff       	call   8004bb <_panic>
  801774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801777:	8b 00                	mov    (%eax),%eax
  801779:	85 c0                	test   %eax,%eax
  80177b:	74 10                	je     80178d <free+0x77>
  80177d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801780:	8b 00                	mov    (%eax),%eax
  801782:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801785:	8b 52 04             	mov    0x4(%edx),%edx
  801788:	89 50 04             	mov    %edx,0x4(%eax)
  80178b:	eb 0b                	jmp    801798 <free+0x82>
  80178d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801790:	8b 40 04             	mov    0x4(%eax),%eax
  801793:	a3 44 40 80 00       	mov    %eax,0x804044
  801798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179b:	8b 40 04             	mov    0x4(%eax),%eax
  80179e:	85 c0                	test   %eax,%eax
  8017a0:	74 0f                	je     8017b1 <free+0x9b>
  8017a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a5:	8b 40 04             	mov    0x4(%eax),%eax
  8017a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ab:	8b 12                	mov    (%edx),%edx
  8017ad:	89 10                	mov    %edx,(%eax)
  8017af:	eb 0a                	jmp    8017bb <free+0xa5>
  8017b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b4:	8b 00                	mov    (%eax),%eax
  8017b6:	a3 40 40 80 00       	mov    %eax,0x804040
  8017bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017ce:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017d3:	48                   	dec    %eax
  8017d4:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8017d9:	83 ec 0c             	sub    $0xc,%esp
  8017dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8017df:	e8 83 12 00 00       	call   802a67 <insert_sorted_with_merge_freeList>
  8017e4:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8017e7:	90                   	nop
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 28             	sub    $0x28,%esp
  8017f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f3:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017f6:	e8 fe fc ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017ff:	75 0a                	jne    80180b <smalloc+0x21>
  801801:	b8 00 00 00 00       	mov    $0x0,%eax
  801806:	e9 86 00 00 00       	jmp    801891 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  80180b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801812:	8b 55 0c             	mov    0xc(%ebp),%edx
  801815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801818:	01 d0                	add    %edx,%eax
  80181a:	48                   	dec    %eax
  80181b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80181e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801821:	ba 00 00 00 00       	mov    $0x0,%edx
  801826:	f7 75 f4             	divl   -0xc(%ebp)
  801829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182c:	29 d0                	sub    %edx,%eax
  80182e:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801831:	e8 e4 06 00 00       	call   801f1a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801836:	85 c0                	test   %eax,%eax
  801838:	74 52                	je     80188c <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  80183a:	83 ec 0c             	sub    $0xc,%esp
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	e8 e6 0d 00 00       	call   80262b <alloc_block_FF>
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  80184b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80184f:	75 07                	jne    801858 <smalloc+0x6e>
			return NULL ;
  801851:	b8 00 00 00 00       	mov    $0x0,%eax
  801856:	eb 39                	jmp    801891 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80185b:	8b 40 08             	mov    0x8(%eax),%eax
  80185e:	89 c2                	mov    %eax,%edx
  801860:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801864:	52                   	push   %edx
  801865:	50                   	push   %eax
  801866:	ff 75 0c             	pushl  0xc(%ebp)
  801869:	ff 75 08             	pushl  0x8(%ebp)
  80186c:	e8 2e 04 00 00       	call   801c9f <sys_createSharedObject>
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801877:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80187b:	79 07                	jns    801884 <smalloc+0x9a>
			return (void*)NULL ;
  80187d:	b8 00 00 00 00       	mov    $0x0,%eax
  801882:	eb 0d                	jmp    801891 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801884:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801887:	8b 40 08             	mov    0x8(%eax),%eax
  80188a:	eb 05                	jmp    801891 <smalloc+0xa7>
		}
		return (void*)NULL ;
  80188c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801899:	e8 5b fc ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80189e:	83 ec 08             	sub    $0x8,%esp
  8018a1:	ff 75 0c             	pushl  0xc(%ebp)
  8018a4:	ff 75 08             	pushl  0x8(%ebp)
  8018a7:	e8 1d 04 00 00       	call   801cc9 <sys_getSizeOfSharedObject>
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8018b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018b6:	75 0a                	jne    8018c2 <sget+0x2f>
			return NULL ;
  8018b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bd:	e9 83 00 00 00       	jmp    801945 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8018c2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cf:	01 d0                	add    %edx,%eax
  8018d1:	48                   	dec    %eax
  8018d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018dd:	f7 75 f0             	divl   -0x10(%ebp)
  8018e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e3:	29 d0                	sub    %edx,%eax
  8018e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018e8:	e8 2d 06 00 00       	call   801f1a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	74 4f                	je     801940 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8018f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f4:	83 ec 0c             	sub    $0xc,%esp
  8018f7:	50                   	push   %eax
  8018f8:	e8 2e 0d 00 00       	call   80262b <alloc_block_FF>
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801903:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801907:	75 07                	jne    801910 <sget+0x7d>
					return (void*)NULL ;
  801909:	b8 00 00 00 00       	mov    $0x0,%eax
  80190e:	eb 35                	jmp    801945 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801910:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801913:	8b 40 08             	mov    0x8(%eax),%eax
  801916:	83 ec 04             	sub    $0x4,%esp
  801919:	50                   	push   %eax
  80191a:	ff 75 0c             	pushl  0xc(%ebp)
  80191d:	ff 75 08             	pushl  0x8(%ebp)
  801920:	e8 c1 03 00 00       	call   801ce6 <sys_getSharedObject>
  801925:	83 c4 10             	add    $0x10,%esp
  801928:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  80192b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80192f:	79 07                	jns    801938 <sget+0xa5>
				return (void*)NULL ;
  801931:	b8 00 00 00 00       	mov    $0x0,%eax
  801936:	eb 0d                	jmp    801945 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801938:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80193b:	8b 40 08             	mov    0x8(%eax),%eax
  80193e:	eb 05                	jmp    801945 <sget+0xb2>


		}
	return (void*)NULL ;
  801940:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80194d:	e8 a7 fb ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	68 60 3d 80 00       	push   $0x803d60
  80195a:	68 f9 00 00 00       	push   $0xf9
  80195f:	68 53 3d 80 00       	push   $0x803d53
  801964:	e8 52 eb ff ff       	call   8004bb <_panic>

00801969 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80196f:	83 ec 04             	sub    $0x4,%esp
  801972:	68 88 3d 80 00       	push   $0x803d88
  801977:	68 0d 01 00 00       	push   $0x10d
  80197c:	68 53 3d 80 00       	push   $0x803d53
  801981:	e8 35 eb ff ff       	call   8004bb <_panic>

00801986 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	68 ac 3d 80 00       	push   $0x803dac
  801994:	68 18 01 00 00       	push   $0x118
  801999:	68 53 3d 80 00       	push   $0x803d53
  80199e:	e8 18 eb ff ff       	call   8004bb <_panic>

008019a3 <shrink>:

}
void shrink(uint32 newSize)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019a9:	83 ec 04             	sub    $0x4,%esp
  8019ac:	68 ac 3d 80 00       	push   $0x803dac
  8019b1:	68 1d 01 00 00       	push   $0x11d
  8019b6:	68 53 3d 80 00       	push   $0x803d53
  8019bb:	e8 fb ea ff ff       	call   8004bb <_panic>

008019c0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019c6:	83 ec 04             	sub    $0x4,%esp
  8019c9:	68 ac 3d 80 00       	push   $0x803dac
  8019ce:	68 22 01 00 00       	push   $0x122
  8019d3:	68 53 3d 80 00       	push   $0x803d53
  8019d8:	e8 de ea ff ff       	call   8004bb <_panic>

008019dd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	57                   	push   %edi
  8019e1:	56                   	push   %esi
  8019e2:	53                   	push   %ebx
  8019e3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019f2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019f5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019f8:	cd 30                	int    $0x30
  8019fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a00:	83 c4 10             	add    $0x10,%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5f                   	pop    %edi
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    

00801a08 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a14:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	52                   	push   %edx
  801a20:	ff 75 0c             	pushl  0xc(%ebp)
  801a23:	50                   	push   %eax
  801a24:	6a 00                	push   $0x0
  801a26:	e8 b2 ff ff ff       	call   8019dd <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	90                   	nop
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 01                	push   $0x1
  801a40:	e8 98 ff ff ff       	call   8019dd <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	52                   	push   %edx
  801a5a:	50                   	push   %eax
  801a5b:	6a 05                	push   $0x5
  801a5d:	e8 7b ff ff ff       	call   8019dd <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a6c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a6f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a72:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	56                   	push   %esi
  801a7c:	53                   	push   %ebx
  801a7d:	51                   	push   %ecx
  801a7e:	52                   	push   %edx
  801a7f:	50                   	push   %eax
  801a80:	6a 06                	push   $0x6
  801a82:	e8 56 ff ff ff       	call   8019dd <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5e                   	pop    %esi
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    

00801a91 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	52                   	push   %edx
  801aa1:	50                   	push   %eax
  801aa2:	6a 07                	push   $0x7
  801aa4:	e8 34 ff ff ff       	call   8019dd <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	ff 75 0c             	pushl  0xc(%ebp)
  801aba:	ff 75 08             	pushl  0x8(%ebp)
  801abd:	6a 08                	push   $0x8
  801abf:	e8 19 ff ff ff       	call   8019dd <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 09                	push   $0x9
  801ad8:	e8 00 ff ff ff       	call   8019dd <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 0a                	push   $0xa
  801af1:	e8 e7 fe ff ff       	call   8019dd <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 0b                	push   $0xb
  801b0a:	e8 ce fe ff ff       	call   8019dd <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	ff 75 08             	pushl  0x8(%ebp)
  801b23:	6a 0f                	push   $0xf
  801b25:	e8 b3 fe ff ff       	call   8019dd <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
	return;
  801b2d:	90                   	nop
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	ff 75 08             	pushl  0x8(%ebp)
  801b3f:	6a 10                	push   $0x10
  801b41:	e8 97 fe ff ff       	call   8019dd <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
	return ;
  801b49:	90                   	nop
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	ff 75 10             	pushl  0x10(%ebp)
  801b56:	ff 75 0c             	pushl  0xc(%ebp)
  801b59:	ff 75 08             	pushl  0x8(%ebp)
  801b5c:	6a 11                	push   $0x11
  801b5e:	e8 7a fe ff ff       	call   8019dd <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
	return ;
  801b66:	90                   	nop
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 0c                	push   $0xc
  801b78:	e8 60 fe ff ff       	call   8019dd <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	ff 75 08             	pushl  0x8(%ebp)
  801b90:	6a 0d                	push   $0xd
  801b92:	e8 46 fe ff ff       	call   8019dd <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 0e                	push   $0xe
  801bab:	e8 2d fe ff ff       	call   8019dd <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	90                   	nop
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 13                	push   $0x13
  801bc5:	e8 13 fe ff ff       	call   8019dd <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	90                   	nop
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 14                	push   $0x14
  801bdf:	e8 f9 fd ff ff       	call   8019dd <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
}
  801be7:	90                   	nop
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_cputc>:


void
sys_cputc(const char c)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 04             	sub    $0x4,%esp
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bf6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	50                   	push   %eax
  801c03:	6a 15                	push   $0x15
  801c05:	e8 d3 fd ff ff       	call   8019dd <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	90                   	nop
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 16                	push   $0x16
  801c1f:	e8 b9 fd ff ff       	call   8019dd <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	90                   	nop
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	ff 75 0c             	pushl  0xc(%ebp)
  801c39:	50                   	push   %eax
  801c3a:	6a 17                	push   $0x17
  801c3c:	e8 9c fd ff ff       	call   8019dd <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	52                   	push   %edx
  801c56:	50                   	push   %eax
  801c57:	6a 1a                	push   $0x1a
  801c59:	e8 7f fd ff ff       	call   8019dd <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	52                   	push   %edx
  801c73:	50                   	push   %eax
  801c74:	6a 18                	push   $0x18
  801c76:	e8 62 fd ff ff       	call   8019dd <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	90                   	nop
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	52                   	push   %edx
  801c91:	50                   	push   %eax
  801c92:	6a 19                	push   $0x19
  801c94:	e8 44 fd ff ff       	call   8019dd <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	90                   	nop
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	51                   	push   %ecx
  801cb8:	52                   	push   %edx
  801cb9:	ff 75 0c             	pushl  0xc(%ebp)
  801cbc:	50                   	push   %eax
  801cbd:	6a 1b                	push   $0x1b
  801cbf:	e8 19 fd ff ff       	call   8019dd <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	52                   	push   %edx
  801cd9:	50                   	push   %eax
  801cda:	6a 1c                	push   $0x1c
  801cdc:	e8 fc fc ff ff       	call   8019dd <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ce9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	51                   	push   %ecx
  801cf7:	52                   	push   %edx
  801cf8:	50                   	push   %eax
  801cf9:	6a 1d                	push   $0x1d
  801cfb:	e8 dd fc ff ff       	call   8019dd <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	52                   	push   %edx
  801d15:	50                   	push   %eax
  801d16:	6a 1e                	push   $0x1e
  801d18:	e8 c0 fc ff ff       	call   8019dd <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 1f                	push   $0x1f
  801d31:	e8 a7 fc ff ff       	call   8019dd <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	6a 00                	push   $0x0
  801d43:	ff 75 14             	pushl  0x14(%ebp)
  801d46:	ff 75 10             	pushl  0x10(%ebp)
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	50                   	push   %eax
  801d4d:	6a 20                	push   $0x20
  801d4f:	e8 89 fc ff ff       	call   8019dd <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	50                   	push   %eax
  801d68:	6a 21                	push   $0x21
  801d6a:	e8 6e fc ff ff       	call   8019dd <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	90                   	nop
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	50                   	push   %eax
  801d84:	6a 22                	push   $0x22
  801d86:	e8 52 fc ff ff       	call   8019dd <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 02                	push   $0x2
  801d9f:	e8 39 fc ff ff       	call   8019dd <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 03                	push   $0x3
  801db8:	e8 20 fc ff ff       	call   8019dd <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 04                	push   $0x4
  801dd1:	e8 07 fc ff ff       	call   8019dd <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_exit_env>:


void sys_exit_env(void)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 23                	push   $0x23
  801dea:	e8 ee fb ff ff       	call   8019dd <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	90                   	nop
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dfb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dfe:	8d 50 04             	lea    0x4(%eax),%edx
  801e01:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	52                   	push   %edx
  801e0b:	50                   	push   %eax
  801e0c:	6a 24                	push   $0x24
  801e0e:	e8 ca fb ff ff       	call   8019dd <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
	return result;
  801e16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1f:	89 01                	mov    %eax,(%ecx)
  801e21:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	c9                   	leave  
  801e28:	c2 04 00             	ret    $0x4

00801e2b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	ff 75 10             	pushl  0x10(%ebp)
  801e35:	ff 75 0c             	pushl  0xc(%ebp)
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	6a 12                	push   $0x12
  801e3d:	e8 9b fb ff ff       	call   8019dd <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
	return ;
  801e45:	90                   	nop
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 25                	push   $0x25
  801e57:	e8 81 fb ff ff       	call   8019dd <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e6d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	50                   	push   %eax
  801e7a:	6a 26                	push   $0x26
  801e7c:	e8 5c fb ff ff       	call   8019dd <syscall>
  801e81:	83 c4 18             	add    $0x18,%esp
	return ;
  801e84:	90                   	nop
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <rsttst>:
void rsttst()
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 28                	push   $0x28
  801e96:	e8 42 fb ff ff       	call   8019dd <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9e:	90                   	nop
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 04             	sub    $0x4,%esp
  801ea7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eaa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ead:	8b 55 18             	mov    0x18(%ebp),%edx
  801eb0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eb4:	52                   	push   %edx
  801eb5:	50                   	push   %eax
  801eb6:	ff 75 10             	pushl  0x10(%ebp)
  801eb9:	ff 75 0c             	pushl  0xc(%ebp)
  801ebc:	ff 75 08             	pushl  0x8(%ebp)
  801ebf:	6a 27                	push   $0x27
  801ec1:	e8 17 fb ff ff       	call   8019dd <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec9:	90                   	nop
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <chktst>:
void chktst(uint32 n)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	ff 75 08             	pushl  0x8(%ebp)
  801eda:	6a 29                	push   $0x29
  801edc:	e8 fc fa ff ff       	call   8019dd <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee4:	90                   	nop
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <inctst>:

void inctst()
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 2a                	push   $0x2a
  801ef6:	e8 e2 fa ff ff       	call   8019dd <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
	return ;
  801efe:	90                   	nop
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <gettst>:
uint32 gettst()
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 2b                	push   $0x2b
  801f10:	e8 c8 fa ff ff       	call   8019dd <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 2c                	push   $0x2c
  801f2c:	e8 ac fa ff ff       	call   8019dd <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
  801f34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f37:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f3b:	75 07                	jne    801f44 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f42:	eb 05                	jmp    801f49 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 2c                	push   $0x2c
  801f5d:	e8 7b fa ff ff       	call   8019dd <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
  801f65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f68:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f6c:	75 07                	jne    801f75 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f73:	eb 05                	jmp    801f7a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 2c                	push   $0x2c
  801f8e:	e8 4a fa ff ff       	call   8019dd <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
  801f96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f99:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f9d:	75 07                	jne    801fa6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa4:	eb 05                	jmp    801fab <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 2c                	push   $0x2c
  801fbf:	e8 19 fa ff ff       	call   8019dd <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
  801fc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fca:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fce:	75 07                	jne    801fd7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fd0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd5:	eb 05                	jmp    801fdc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	ff 75 08             	pushl  0x8(%ebp)
  801fec:	6a 2d                	push   $0x2d
  801fee:	e8 ea f9 ff ff       	call   8019dd <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff6:	90                   	nop
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ffd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802000:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802003:	8b 55 0c             	mov    0xc(%ebp),%edx
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	6a 00                	push   $0x0
  80200b:	53                   	push   %ebx
  80200c:	51                   	push   %ecx
  80200d:	52                   	push   %edx
  80200e:	50                   	push   %eax
  80200f:	6a 2e                	push   $0x2e
  802011:	e8 c7 f9 ff ff       	call   8019dd <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802021:	8b 55 0c             	mov    0xc(%ebp),%edx
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	52                   	push   %edx
  80202e:	50                   	push   %eax
  80202f:	6a 2f                	push   $0x2f
  802031:	e8 a7 f9 ff ff       	call   8019dd <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802041:	83 ec 0c             	sub    $0xc,%esp
  802044:	68 bc 3d 80 00       	push   $0x803dbc
  802049:	e8 21 e7 ff ff       	call   80076f <cprintf>
  80204e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802058:	83 ec 0c             	sub    $0xc,%esp
  80205b:	68 e8 3d 80 00       	push   $0x803de8
  802060:	e8 0a e7 ff ff       	call   80076f <cprintf>
  802065:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802068:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80206c:	a1 38 41 80 00       	mov    0x804138,%eax
  802071:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802074:	eb 56                	jmp    8020cc <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802076:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80207a:	74 1c                	je     802098 <print_mem_block_lists+0x5d>
  80207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207f:	8b 50 08             	mov    0x8(%eax),%edx
  802082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802085:	8b 48 08             	mov    0x8(%eax),%ecx
  802088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208b:	8b 40 0c             	mov    0xc(%eax),%eax
  80208e:	01 c8                	add    %ecx,%eax
  802090:	39 c2                	cmp    %eax,%edx
  802092:	73 04                	jae    802098 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802094:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209b:	8b 50 08             	mov    0x8(%eax),%edx
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a4:	01 c2                	add    %eax,%edx
  8020a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a9:	8b 40 08             	mov    0x8(%eax),%eax
  8020ac:	83 ec 04             	sub    $0x4,%esp
  8020af:	52                   	push   %edx
  8020b0:	50                   	push   %eax
  8020b1:	68 fd 3d 80 00       	push   $0x803dfd
  8020b6:	e8 b4 e6 ff ff       	call   80076f <cprintf>
  8020bb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020c4:	a1 40 41 80 00       	mov    0x804140,%eax
  8020c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d0:	74 07                	je     8020d9 <print_mem_block_lists+0x9e>
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	8b 00                	mov    (%eax),%eax
  8020d7:	eb 05                	jmp    8020de <print_mem_block_lists+0xa3>
  8020d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020de:	a3 40 41 80 00       	mov    %eax,0x804140
  8020e3:	a1 40 41 80 00       	mov    0x804140,%eax
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	75 8a                	jne    802076 <print_mem_block_lists+0x3b>
  8020ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f0:	75 84                	jne    802076 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8020f2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020f6:	75 10                	jne    802108 <print_mem_block_lists+0xcd>
  8020f8:	83 ec 0c             	sub    $0xc,%esp
  8020fb:	68 0c 3e 80 00       	push   $0x803e0c
  802100:	e8 6a e6 ff ff       	call   80076f <cprintf>
  802105:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802108:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80210f:	83 ec 0c             	sub    $0xc,%esp
  802112:	68 30 3e 80 00       	push   $0x803e30
  802117:	e8 53 e6 ff ff       	call   80076f <cprintf>
  80211c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80211f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802123:	a1 40 40 80 00       	mov    0x804040,%eax
  802128:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212b:	eb 56                	jmp    802183 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80212d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802131:	74 1c                	je     80214f <print_mem_block_lists+0x114>
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	8b 50 08             	mov    0x8(%eax),%edx
  802139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213c:	8b 48 08             	mov    0x8(%eax),%ecx
  80213f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802142:	8b 40 0c             	mov    0xc(%eax),%eax
  802145:	01 c8                	add    %ecx,%eax
  802147:	39 c2                	cmp    %eax,%edx
  802149:	73 04                	jae    80214f <print_mem_block_lists+0x114>
			sorted = 0 ;
  80214b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	8b 50 08             	mov    0x8(%eax),%edx
  802155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802158:	8b 40 0c             	mov    0xc(%eax),%eax
  80215b:	01 c2                	add    %eax,%edx
  80215d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802160:	8b 40 08             	mov    0x8(%eax),%eax
  802163:	83 ec 04             	sub    $0x4,%esp
  802166:	52                   	push   %edx
  802167:	50                   	push   %eax
  802168:	68 fd 3d 80 00       	push   $0x803dfd
  80216d:	e8 fd e5 ff ff       	call   80076f <cprintf>
  802172:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80217b:	a1 48 40 80 00       	mov    0x804048,%eax
  802180:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802183:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802187:	74 07                	je     802190 <print_mem_block_lists+0x155>
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	8b 00                	mov    (%eax),%eax
  80218e:	eb 05                	jmp    802195 <print_mem_block_lists+0x15a>
  802190:	b8 00 00 00 00       	mov    $0x0,%eax
  802195:	a3 48 40 80 00       	mov    %eax,0x804048
  80219a:	a1 48 40 80 00       	mov    0x804048,%eax
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	75 8a                	jne    80212d <print_mem_block_lists+0xf2>
  8021a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a7:	75 84                	jne    80212d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021a9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021ad:	75 10                	jne    8021bf <print_mem_block_lists+0x184>
  8021af:	83 ec 0c             	sub    $0xc,%esp
  8021b2:	68 48 3e 80 00       	push   $0x803e48
  8021b7:	e8 b3 e5 ff ff       	call   80076f <cprintf>
  8021bc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021bf:	83 ec 0c             	sub    $0xc,%esp
  8021c2:	68 bc 3d 80 00       	push   $0x803dbc
  8021c7:	e8 a3 e5 ff ff       	call   80076f <cprintf>
  8021cc:	83 c4 10             	add    $0x10,%esp

}
  8021cf:	90                   	nop
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8021d8:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8021df:	00 00 00 
  8021e2:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8021e9:	00 00 00 
  8021ec:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8021f3:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8021f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021fd:	e9 9e 00 00 00       	jmp    8022a0 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802202:	a1 50 40 80 00       	mov    0x804050,%eax
  802207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220a:	c1 e2 04             	shl    $0x4,%edx
  80220d:	01 d0                	add    %edx,%eax
  80220f:	85 c0                	test   %eax,%eax
  802211:	75 14                	jne    802227 <initialize_MemBlocksList+0x55>
  802213:	83 ec 04             	sub    $0x4,%esp
  802216:	68 70 3e 80 00       	push   $0x803e70
  80221b:	6a 43                	push   $0x43
  80221d:	68 93 3e 80 00       	push   $0x803e93
  802222:	e8 94 e2 ff ff       	call   8004bb <_panic>
  802227:	a1 50 40 80 00       	mov    0x804050,%eax
  80222c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222f:	c1 e2 04             	shl    $0x4,%edx
  802232:	01 d0                	add    %edx,%eax
  802234:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80223a:	89 10                	mov    %edx,(%eax)
  80223c:	8b 00                	mov    (%eax),%eax
  80223e:	85 c0                	test   %eax,%eax
  802240:	74 18                	je     80225a <initialize_MemBlocksList+0x88>
  802242:	a1 48 41 80 00       	mov    0x804148,%eax
  802247:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80224d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802250:	c1 e1 04             	shl    $0x4,%ecx
  802253:	01 ca                	add    %ecx,%edx
  802255:	89 50 04             	mov    %edx,0x4(%eax)
  802258:	eb 12                	jmp    80226c <initialize_MemBlocksList+0x9a>
  80225a:	a1 50 40 80 00       	mov    0x804050,%eax
  80225f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802262:	c1 e2 04             	shl    $0x4,%edx
  802265:	01 d0                	add    %edx,%eax
  802267:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80226c:	a1 50 40 80 00       	mov    0x804050,%eax
  802271:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802274:	c1 e2 04             	shl    $0x4,%edx
  802277:	01 d0                	add    %edx,%eax
  802279:	a3 48 41 80 00       	mov    %eax,0x804148
  80227e:	a1 50 40 80 00       	mov    0x804050,%eax
  802283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802286:	c1 e2 04             	shl    $0x4,%edx
  802289:	01 d0                	add    %edx,%eax
  80228b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802292:	a1 54 41 80 00       	mov    0x804154,%eax
  802297:	40                   	inc    %eax
  802298:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80229d:	ff 45 f4             	incl   -0xc(%ebp)
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022a6:	0f 82 56 ff ff ff    	jb     802202 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8022ac:	90                   	nop
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8022b5:	a1 38 41 80 00       	mov    0x804138,%eax
  8022ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022bd:	eb 18                	jmp    8022d7 <find_block+0x28>
	{
		if (ele->sva==va)
  8022bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022c2:	8b 40 08             	mov    0x8(%eax),%eax
  8022c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022c8:	75 05                	jne    8022cf <find_block+0x20>
			return ele;
  8022ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022cd:	eb 7b                	jmp    80234a <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8022cf:	a1 40 41 80 00       	mov    0x804140,%eax
  8022d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022db:	74 07                	je     8022e4 <find_block+0x35>
  8022dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e0:	8b 00                	mov    (%eax),%eax
  8022e2:	eb 05                	jmp    8022e9 <find_block+0x3a>
  8022e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e9:	a3 40 41 80 00       	mov    %eax,0x804140
  8022ee:	a1 40 41 80 00       	mov    0x804140,%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	75 c8                	jne    8022bf <find_block+0x10>
  8022f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022fb:	75 c2                	jne    8022bf <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8022fd:	a1 40 40 80 00       	mov    0x804040,%eax
  802302:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802305:	eb 18                	jmp    80231f <find_block+0x70>
	{
		if (ele->sva==va)
  802307:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80230a:	8b 40 08             	mov    0x8(%eax),%eax
  80230d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802310:	75 05                	jne    802317 <find_block+0x68>
					return ele;
  802312:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802315:	eb 33                	jmp    80234a <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802317:	a1 48 40 80 00       	mov    0x804048,%eax
  80231c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80231f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802323:	74 07                	je     80232c <find_block+0x7d>
  802325:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802328:	8b 00                	mov    (%eax),%eax
  80232a:	eb 05                	jmp    802331 <find_block+0x82>
  80232c:	b8 00 00 00 00       	mov    $0x0,%eax
  802331:	a3 48 40 80 00       	mov    %eax,0x804048
  802336:	a1 48 40 80 00       	mov    0x804048,%eax
  80233b:	85 c0                	test   %eax,%eax
  80233d:	75 c8                	jne    802307 <find_block+0x58>
  80233f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802343:	75 c2                	jne    802307 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802345:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80234a:	c9                   	leave  
  80234b:	c3                   	ret    

0080234c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802352:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802357:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80235a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80235e:	75 62                	jne    8023c2 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802360:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802364:	75 14                	jne    80237a <insert_sorted_allocList+0x2e>
  802366:	83 ec 04             	sub    $0x4,%esp
  802369:	68 70 3e 80 00       	push   $0x803e70
  80236e:	6a 69                	push   $0x69
  802370:	68 93 3e 80 00       	push   $0x803e93
  802375:	e8 41 e1 ff ff       	call   8004bb <_panic>
  80237a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	89 10                	mov    %edx,(%eax)
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	8b 00                	mov    (%eax),%eax
  80238a:	85 c0                	test   %eax,%eax
  80238c:	74 0d                	je     80239b <insert_sorted_allocList+0x4f>
  80238e:	a1 40 40 80 00       	mov    0x804040,%eax
  802393:	8b 55 08             	mov    0x8(%ebp),%edx
  802396:	89 50 04             	mov    %edx,0x4(%eax)
  802399:	eb 08                	jmp    8023a3 <insert_sorted_allocList+0x57>
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	a3 44 40 80 00       	mov    %eax,0x804044
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	a3 40 40 80 00       	mov    %eax,0x804040
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023ba:	40                   	inc    %eax
  8023bb:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023c0:	eb 72                	jmp    802434 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8023c2:	a1 40 40 80 00       	mov    0x804040,%eax
  8023c7:	8b 50 08             	mov    0x8(%eax),%edx
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	8b 40 08             	mov    0x8(%eax),%eax
  8023d0:	39 c2                	cmp    %eax,%edx
  8023d2:	76 60                	jbe    802434 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8023d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d8:	75 14                	jne    8023ee <insert_sorted_allocList+0xa2>
  8023da:	83 ec 04             	sub    $0x4,%esp
  8023dd:	68 70 3e 80 00       	push   $0x803e70
  8023e2:	6a 6d                	push   $0x6d
  8023e4:	68 93 3e 80 00       	push   $0x803e93
  8023e9:	e8 cd e0 ff ff       	call   8004bb <_panic>
  8023ee:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	89 10                	mov    %edx,(%eax)
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	8b 00                	mov    (%eax),%eax
  8023fe:	85 c0                	test   %eax,%eax
  802400:	74 0d                	je     80240f <insert_sorted_allocList+0xc3>
  802402:	a1 40 40 80 00       	mov    0x804040,%eax
  802407:	8b 55 08             	mov    0x8(%ebp),%edx
  80240a:	89 50 04             	mov    %edx,0x4(%eax)
  80240d:	eb 08                	jmp    802417 <insert_sorted_allocList+0xcb>
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	a3 44 40 80 00       	mov    %eax,0x804044
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	a3 40 40 80 00       	mov    %eax,0x804040
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802429:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80242e:	40                   	inc    %eax
  80242f:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802434:	a1 40 40 80 00       	mov    0x804040,%eax
  802439:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243c:	e9 b9 01 00 00       	jmp    8025fa <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802441:	8b 45 08             	mov    0x8(%ebp),%eax
  802444:	8b 50 08             	mov    0x8(%eax),%edx
  802447:	a1 40 40 80 00       	mov    0x804040,%eax
  80244c:	8b 40 08             	mov    0x8(%eax),%eax
  80244f:	39 c2                	cmp    %eax,%edx
  802451:	76 7c                	jbe    8024cf <insert_sorted_allocList+0x183>
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	8b 50 08             	mov    0x8(%eax),%edx
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 40 08             	mov    0x8(%eax),%eax
  80245f:	39 c2                	cmp    %eax,%edx
  802461:	73 6c                	jae    8024cf <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802467:	74 06                	je     80246f <insert_sorted_allocList+0x123>
  802469:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80246d:	75 14                	jne    802483 <insert_sorted_allocList+0x137>
  80246f:	83 ec 04             	sub    $0x4,%esp
  802472:	68 ac 3e 80 00       	push   $0x803eac
  802477:	6a 75                	push   $0x75
  802479:	68 93 3e 80 00       	push   $0x803e93
  80247e:	e8 38 e0 ff ff       	call   8004bb <_panic>
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 50 04             	mov    0x4(%eax),%edx
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	89 50 04             	mov    %edx,0x4(%eax)
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802495:	89 10                	mov    %edx,(%eax)
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 40 04             	mov    0x4(%eax),%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 0d                	je     8024ae <insert_sorted_allocList+0x162>
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8024aa:	89 10                	mov    %edx,(%eax)
  8024ac:	eb 08                	jmp    8024b6 <insert_sorted_allocList+0x16a>
  8024ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b1:	a3 40 40 80 00       	mov    %eax,0x804040
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024bc:	89 50 04             	mov    %edx,0x4(%eax)
  8024bf:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024c4:	40                   	inc    %eax
  8024c5:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8024ca:	e9 59 01 00 00       	jmp    802628 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	8b 50 08             	mov    0x8(%eax),%edx
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 40 08             	mov    0x8(%eax),%eax
  8024db:	39 c2                	cmp    %eax,%edx
  8024dd:	0f 86 98 00 00 00    	jbe    80257b <insert_sorted_allocList+0x22f>
  8024e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e6:	8b 50 08             	mov    0x8(%eax),%edx
  8024e9:	a1 44 40 80 00       	mov    0x804044,%eax
  8024ee:	8b 40 08             	mov    0x8(%eax),%eax
  8024f1:	39 c2                	cmp    %eax,%edx
  8024f3:	0f 83 82 00 00 00    	jae    80257b <insert_sorted_allocList+0x22f>
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	8b 50 08             	mov    0x8(%eax),%edx
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 00                	mov    (%eax),%eax
  802504:	8b 40 08             	mov    0x8(%eax),%eax
  802507:	39 c2                	cmp    %eax,%edx
  802509:	73 70                	jae    80257b <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80250b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250f:	74 06                	je     802517 <insert_sorted_allocList+0x1cb>
  802511:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802515:	75 14                	jne    80252b <insert_sorted_allocList+0x1df>
  802517:	83 ec 04             	sub    $0x4,%esp
  80251a:	68 e4 3e 80 00       	push   $0x803ee4
  80251f:	6a 7c                	push   $0x7c
  802521:	68 93 3e 80 00       	push   $0x803e93
  802526:	e8 90 df ff ff       	call   8004bb <_panic>
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 10                	mov    (%eax),%edx
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	89 10                	mov    %edx,(%eax)
  802535:	8b 45 08             	mov    0x8(%ebp),%eax
  802538:	8b 00                	mov    (%eax),%eax
  80253a:	85 c0                	test   %eax,%eax
  80253c:	74 0b                	je     802549 <insert_sorted_allocList+0x1fd>
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 00                	mov    (%eax),%eax
  802543:	8b 55 08             	mov    0x8(%ebp),%edx
  802546:	89 50 04             	mov    %edx,0x4(%eax)
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 55 08             	mov    0x8(%ebp),%edx
  80254f:	89 10                	mov    %edx,(%eax)
  802551:	8b 45 08             	mov    0x8(%ebp),%eax
  802554:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802557:	89 50 04             	mov    %edx,0x4(%eax)
  80255a:	8b 45 08             	mov    0x8(%ebp),%eax
  80255d:	8b 00                	mov    (%eax),%eax
  80255f:	85 c0                	test   %eax,%eax
  802561:	75 08                	jne    80256b <insert_sorted_allocList+0x21f>
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	a3 44 40 80 00       	mov    %eax,0x804044
  80256b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802570:	40                   	inc    %eax
  802571:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802576:	e9 ad 00 00 00       	jmp    802628 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80257b:	8b 45 08             	mov    0x8(%ebp),%eax
  80257e:	8b 50 08             	mov    0x8(%eax),%edx
  802581:	a1 44 40 80 00       	mov    0x804044,%eax
  802586:	8b 40 08             	mov    0x8(%eax),%eax
  802589:	39 c2                	cmp    %eax,%edx
  80258b:	76 65                	jbe    8025f2 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80258d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802591:	75 17                	jne    8025aa <insert_sorted_allocList+0x25e>
  802593:	83 ec 04             	sub    $0x4,%esp
  802596:	68 18 3f 80 00       	push   $0x803f18
  80259b:	68 80 00 00 00       	push   $0x80
  8025a0:	68 93 3e 80 00       	push   $0x803e93
  8025a5:	e8 11 df ff ff       	call   8004bb <_panic>
  8025aa:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	89 50 04             	mov    %edx,0x4(%eax)
  8025b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b9:	8b 40 04             	mov    0x4(%eax),%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	74 0c                	je     8025cc <insert_sorted_allocList+0x280>
  8025c0:	a1 44 40 80 00       	mov    0x804044,%eax
  8025c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c8:	89 10                	mov    %edx,(%eax)
  8025ca:	eb 08                	jmp    8025d4 <insert_sorted_allocList+0x288>
  8025cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cf:	a3 40 40 80 00       	mov    %eax,0x804040
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	a3 44 40 80 00       	mov    %eax,0x804044
  8025dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8025ea:	40                   	inc    %eax
  8025eb:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8025f0:	eb 36                	jmp    802628 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8025f2:	a1 48 40 80 00       	mov    0x804048,%eax
  8025f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fe:	74 07                	je     802607 <insert_sorted_allocList+0x2bb>
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	8b 00                	mov    (%eax),%eax
  802605:	eb 05                	jmp    80260c <insert_sorted_allocList+0x2c0>
  802607:	b8 00 00 00 00       	mov    $0x0,%eax
  80260c:	a3 48 40 80 00       	mov    %eax,0x804048
  802611:	a1 48 40 80 00       	mov    0x804048,%eax
  802616:	85 c0                	test   %eax,%eax
  802618:	0f 85 23 fe ff ff    	jne    802441 <insert_sorted_allocList+0xf5>
  80261e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802622:	0f 85 19 fe ff ff    	jne    802441 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802628:	90                   	nop
  802629:	c9                   	leave  
  80262a:	c3                   	ret    

0080262b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
  80262e:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802631:	a1 38 41 80 00       	mov    0x804138,%eax
  802636:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802639:	e9 7c 01 00 00       	jmp    8027ba <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	8b 40 0c             	mov    0xc(%eax),%eax
  802644:	3b 45 08             	cmp    0x8(%ebp),%eax
  802647:	0f 85 90 00 00 00    	jne    8026dd <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802653:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802657:	75 17                	jne    802670 <alloc_block_FF+0x45>
  802659:	83 ec 04             	sub    $0x4,%esp
  80265c:	68 3b 3f 80 00       	push   $0x803f3b
  802661:	68 ba 00 00 00       	push   $0xba
  802666:	68 93 3e 80 00       	push   $0x803e93
  80266b:	e8 4b de ff ff       	call   8004bb <_panic>
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	85 c0                	test   %eax,%eax
  802677:	74 10                	je     802689 <alloc_block_FF+0x5e>
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	8b 00                	mov    (%eax),%eax
  80267e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802681:	8b 52 04             	mov    0x4(%edx),%edx
  802684:	89 50 04             	mov    %edx,0x4(%eax)
  802687:	eb 0b                	jmp    802694 <alloc_block_FF+0x69>
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 40 04             	mov    0x4(%eax),%eax
  80268f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	8b 40 04             	mov    0x4(%eax),%eax
  80269a:	85 c0                	test   %eax,%eax
  80269c:	74 0f                	je     8026ad <alloc_block_FF+0x82>
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 40 04             	mov    0x4(%eax),%eax
  8026a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a7:	8b 12                	mov    (%edx),%edx
  8026a9:	89 10                	mov    %edx,(%eax)
  8026ab:	eb 0a                	jmp    8026b7 <alloc_block_FF+0x8c>
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 00                	mov    (%eax),%eax
  8026b2:	a3 38 41 80 00       	mov    %eax,0x804138
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ca:	a1 44 41 80 00       	mov    0x804144,%eax
  8026cf:	48                   	dec    %eax
  8026d0:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8026d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d8:	e9 10 01 00 00       	jmp    8027ed <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e6:	0f 86 c6 00 00 00    	jbe    8027b2 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8026ec:	a1 48 41 80 00       	mov    0x804148,%eax
  8026f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8026f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f8:	75 17                	jne    802711 <alloc_block_FF+0xe6>
  8026fa:	83 ec 04             	sub    $0x4,%esp
  8026fd:	68 3b 3f 80 00       	push   $0x803f3b
  802702:	68 c2 00 00 00       	push   $0xc2
  802707:	68 93 3e 80 00       	push   $0x803e93
  80270c:	e8 aa dd ff ff       	call   8004bb <_panic>
  802711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802714:	8b 00                	mov    (%eax),%eax
  802716:	85 c0                	test   %eax,%eax
  802718:	74 10                	je     80272a <alloc_block_FF+0xff>
  80271a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271d:	8b 00                	mov    (%eax),%eax
  80271f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802722:	8b 52 04             	mov    0x4(%edx),%edx
  802725:	89 50 04             	mov    %edx,0x4(%eax)
  802728:	eb 0b                	jmp    802735 <alloc_block_FF+0x10a>
  80272a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272d:	8b 40 04             	mov    0x4(%eax),%eax
  802730:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802738:	8b 40 04             	mov    0x4(%eax),%eax
  80273b:	85 c0                	test   %eax,%eax
  80273d:	74 0f                	je     80274e <alloc_block_FF+0x123>
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	8b 40 04             	mov    0x4(%eax),%eax
  802745:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802748:	8b 12                	mov    (%edx),%edx
  80274a:	89 10                	mov    %edx,(%eax)
  80274c:	eb 0a                	jmp    802758 <alloc_block_FF+0x12d>
  80274e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	a3 48 41 80 00       	mov    %eax,0x804148
  802758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802764:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80276b:	a1 54 41 80 00       	mov    0x804154,%eax
  802770:	48                   	dec    %eax
  802771:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 50 08             	mov    0x8(%eax),%edx
  80277c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277f:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802785:	8b 55 08             	mov    0x8(%ebp),%edx
  802788:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 40 0c             	mov    0xc(%eax),%eax
  802791:	2b 45 08             	sub    0x8(%ebp),%eax
  802794:	89 c2                	mov    %eax,%edx
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 50 08             	mov    0x8(%eax),%edx
  8027a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a5:	01 c2                	add    %eax,%edx
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8027ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b0:	eb 3b                	jmp    8027ed <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8027b2:	a1 40 41 80 00       	mov    0x804140,%eax
  8027b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027be:	74 07                	je     8027c7 <alloc_block_FF+0x19c>
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 00                	mov    (%eax),%eax
  8027c5:	eb 05                	jmp    8027cc <alloc_block_FF+0x1a1>
  8027c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cc:	a3 40 41 80 00       	mov    %eax,0x804140
  8027d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	0f 85 60 fe ff ff    	jne    80263e <alloc_block_FF+0x13>
  8027de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e2:	0f 85 56 fe ff ff    	jne    80263e <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8027e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ed:	c9                   	leave  
  8027ee:	c3                   	ret    

008027ef <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8027ef:	55                   	push   %ebp
  8027f0:	89 e5                	mov    %esp,%ebp
  8027f2:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8027f5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8027fc:	a1 38 41 80 00       	mov    0x804138,%eax
  802801:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802804:	eb 3a                	jmp    802840 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 40 0c             	mov    0xc(%eax),%eax
  80280c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280f:	72 27                	jb     802838 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802811:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802815:	75 0b                	jne    802822 <alloc_block_BF+0x33>
					best_size= element->size;
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 40 0c             	mov    0xc(%eax),%eax
  80281d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802820:	eb 16                	jmp    802838 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8b 50 0c             	mov    0xc(%eax),%edx
  802828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282b:	39 c2                	cmp    %eax,%edx
  80282d:	77 09                	ja     802838 <alloc_block_BF+0x49>
					best_size=element->size;
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 40 0c             	mov    0xc(%eax),%eax
  802835:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802838:	a1 40 41 80 00       	mov    0x804140,%eax
  80283d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802840:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802844:	74 07                	je     80284d <alloc_block_BF+0x5e>
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 00                	mov    (%eax),%eax
  80284b:	eb 05                	jmp    802852 <alloc_block_BF+0x63>
  80284d:	b8 00 00 00 00       	mov    $0x0,%eax
  802852:	a3 40 41 80 00       	mov    %eax,0x804140
  802857:	a1 40 41 80 00       	mov    0x804140,%eax
  80285c:	85 c0                	test   %eax,%eax
  80285e:	75 a6                	jne    802806 <alloc_block_BF+0x17>
  802860:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802864:	75 a0                	jne    802806 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802866:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80286a:	0f 84 d3 01 00 00    	je     802a43 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802870:	a1 38 41 80 00       	mov    0x804138,%eax
  802875:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802878:	e9 98 01 00 00       	jmp    802a15 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  80287d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802880:	3b 45 08             	cmp    0x8(%ebp),%eax
  802883:	0f 86 da 00 00 00    	jbe    802963 <alloc_block_BF+0x174>
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 50 0c             	mov    0xc(%eax),%edx
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	39 c2                	cmp    %eax,%edx
  802894:	0f 85 c9 00 00 00    	jne    802963 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  80289a:	a1 48 41 80 00       	mov    0x804148,%eax
  80289f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8028a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028a6:	75 17                	jne    8028bf <alloc_block_BF+0xd0>
  8028a8:	83 ec 04             	sub    $0x4,%esp
  8028ab:	68 3b 3f 80 00       	push   $0x803f3b
  8028b0:	68 ea 00 00 00       	push   $0xea
  8028b5:	68 93 3e 80 00       	push   $0x803e93
  8028ba:	e8 fc db ff ff       	call   8004bb <_panic>
  8028bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c2:	8b 00                	mov    (%eax),%eax
  8028c4:	85 c0                	test   %eax,%eax
  8028c6:	74 10                	je     8028d8 <alloc_block_BF+0xe9>
  8028c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d0:	8b 52 04             	mov    0x4(%edx),%edx
  8028d3:	89 50 04             	mov    %edx,0x4(%eax)
  8028d6:	eb 0b                	jmp    8028e3 <alloc_block_BF+0xf4>
  8028d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028db:	8b 40 04             	mov    0x4(%eax),%eax
  8028de:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e6:	8b 40 04             	mov    0x4(%eax),%eax
  8028e9:	85 c0                	test   %eax,%eax
  8028eb:	74 0f                	je     8028fc <alloc_block_BF+0x10d>
  8028ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f0:	8b 40 04             	mov    0x4(%eax),%eax
  8028f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028f6:	8b 12                	mov    (%edx),%edx
  8028f8:	89 10                	mov    %edx,(%eax)
  8028fa:	eb 0a                	jmp    802906 <alloc_block_BF+0x117>
  8028fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	a3 48 41 80 00       	mov    %eax,0x804148
  802906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802909:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802912:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802919:	a1 54 41 80 00       	mov    0x804154,%eax
  80291e:	48                   	dec    %eax
  80291f:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 50 08             	mov    0x8(%eax),%edx
  80292a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292d:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802930:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802933:	8b 55 08             	mov    0x8(%ebp),%edx
  802936:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 40 0c             	mov    0xc(%eax),%eax
  80293f:	2b 45 08             	sub    0x8(%ebp),%eax
  802942:	89 c2                	mov    %eax,%edx
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 50 08             	mov    0x8(%eax),%edx
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	01 c2                	add    %eax,%edx
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  80295b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295e:	e9 e5 00 00 00       	jmp    802a48 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 50 0c             	mov    0xc(%eax),%edx
  802969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296c:	39 c2                	cmp    %eax,%edx
  80296e:	0f 85 99 00 00 00    	jne    802a0d <alloc_block_BF+0x21e>
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	3b 45 08             	cmp    0x8(%ebp),%eax
  80297a:	0f 85 8d 00 00 00    	jne    802a0d <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298a:	75 17                	jne    8029a3 <alloc_block_BF+0x1b4>
  80298c:	83 ec 04             	sub    $0x4,%esp
  80298f:	68 3b 3f 80 00       	push   $0x803f3b
  802994:	68 f7 00 00 00       	push   $0xf7
  802999:	68 93 3e 80 00       	push   $0x803e93
  80299e:	e8 18 db ff ff       	call   8004bb <_panic>
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	74 10                	je     8029bc <alloc_block_BF+0x1cd>
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b4:	8b 52 04             	mov    0x4(%edx),%edx
  8029b7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ba:	eb 0b                	jmp    8029c7 <alloc_block_BF+0x1d8>
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 40 04             	mov    0x4(%eax),%eax
  8029c2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	74 0f                	je     8029e0 <alloc_block_BF+0x1f1>
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 40 04             	mov    0x4(%eax),%eax
  8029d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029da:	8b 12                	mov    (%edx),%edx
  8029dc:	89 10                	mov    %edx,(%eax)
  8029de:	eb 0a                	jmp    8029ea <alloc_block_BF+0x1fb>
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 00                	mov    (%eax),%eax
  8029e5:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fd:	a1 44 41 80 00       	mov    0x804144,%eax
  802a02:	48                   	dec    %eax
  802a03:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  802a08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0b:	eb 3b                	jmp    802a48 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802a0d:	a1 40 41 80 00       	mov    0x804140,%eax
  802a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a19:	74 07                	je     802a22 <alloc_block_BF+0x233>
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 00                	mov    (%eax),%eax
  802a20:	eb 05                	jmp    802a27 <alloc_block_BF+0x238>
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
  802a27:	a3 40 41 80 00       	mov    %eax,0x804140
  802a2c:	a1 40 41 80 00       	mov    0x804140,%eax
  802a31:	85 c0                	test   %eax,%eax
  802a33:	0f 85 44 fe ff ff    	jne    80287d <alloc_block_BF+0x8e>
  802a39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3d:	0f 85 3a fe ff ff    	jne    80287d <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802a43:	b8 00 00 00 00       	mov    $0x0,%eax
  802a48:	c9                   	leave  
  802a49:	c3                   	ret    

00802a4a <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a4a:	55                   	push   %ebp
  802a4b:	89 e5                	mov    %esp,%ebp
  802a4d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802a50:	83 ec 04             	sub    $0x4,%esp
  802a53:	68 5c 3f 80 00       	push   $0x803f5c
  802a58:	68 04 01 00 00       	push   $0x104
  802a5d:	68 93 3e 80 00       	push   $0x803e93
  802a62:	e8 54 da ff ff       	call   8004bb <_panic>

00802a67 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802a67:	55                   	push   %ebp
  802a68:	89 e5                	mov    %esp,%ebp
  802a6a:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802a6d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802a75:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a7a:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802a7d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a82:	85 c0                	test   %eax,%eax
  802a84:	75 68                	jne    802aee <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802a86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8a:	75 17                	jne    802aa3 <insert_sorted_with_merge_freeList+0x3c>
  802a8c:	83 ec 04             	sub    $0x4,%esp
  802a8f:	68 70 3e 80 00       	push   $0x803e70
  802a94:	68 14 01 00 00       	push   $0x114
  802a99:	68 93 3e 80 00       	push   $0x803e93
  802a9e:	e8 18 da ff ff       	call   8004bb <_panic>
  802aa3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	89 10                	mov    %edx,(%eax)
  802aae:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab1:	8b 00                	mov    (%eax),%eax
  802ab3:	85 c0                	test   %eax,%eax
  802ab5:	74 0d                	je     802ac4 <insert_sorted_with_merge_freeList+0x5d>
  802ab7:	a1 38 41 80 00       	mov    0x804138,%eax
  802abc:	8b 55 08             	mov    0x8(%ebp),%edx
  802abf:	89 50 04             	mov    %edx,0x4(%eax)
  802ac2:	eb 08                	jmp    802acc <insert_sorted_with_merge_freeList+0x65>
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	a3 38 41 80 00       	mov    %eax,0x804138
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ade:	a1 44 41 80 00       	mov    0x804144,%eax
  802ae3:	40                   	inc    %eax
  802ae4:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802ae9:	e9 d2 06 00 00       	jmp    8031c0 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802aee:	8b 45 08             	mov    0x8(%ebp),%eax
  802af1:	8b 50 08             	mov    0x8(%eax),%edx
  802af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af7:	8b 40 08             	mov    0x8(%eax),%eax
  802afa:	39 c2                	cmp    %eax,%edx
  802afc:	0f 83 22 01 00 00    	jae    802c24 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	8b 50 08             	mov    0x8(%eax),%edx
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0e:	01 c2                	add    %eax,%edx
  802b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b13:	8b 40 08             	mov    0x8(%eax),%eax
  802b16:	39 c2                	cmp    %eax,%edx
  802b18:	0f 85 9e 00 00 00    	jne    802bbc <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	8b 50 08             	mov    0x8(%eax),%edx
  802b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b27:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2d:	8b 50 0c             	mov    0xc(%eax),%edx
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	8b 40 0c             	mov    0xc(%eax),%eax
  802b36:	01 c2                	add    %eax,%edx
  802b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3b:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	8b 50 08             	mov    0x8(%eax),%edx
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b58:	75 17                	jne    802b71 <insert_sorted_with_merge_freeList+0x10a>
  802b5a:	83 ec 04             	sub    $0x4,%esp
  802b5d:	68 70 3e 80 00       	push   $0x803e70
  802b62:	68 21 01 00 00       	push   $0x121
  802b67:	68 93 3e 80 00       	push   $0x803e93
  802b6c:	e8 4a d9 ff ff       	call   8004bb <_panic>
  802b71:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	89 10                	mov    %edx,(%eax)
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	74 0d                	je     802b92 <insert_sorted_with_merge_freeList+0x12b>
  802b85:	a1 48 41 80 00       	mov    0x804148,%eax
  802b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8d:	89 50 04             	mov    %edx,0x4(%eax)
  802b90:	eb 08                	jmp    802b9a <insert_sorted_with_merge_freeList+0x133>
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	a3 48 41 80 00       	mov    %eax,0x804148
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bac:	a1 54 41 80 00       	mov    0x804154,%eax
  802bb1:	40                   	inc    %eax
  802bb2:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802bb7:	e9 04 06 00 00       	jmp    8031c0 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802bbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc0:	75 17                	jne    802bd9 <insert_sorted_with_merge_freeList+0x172>
  802bc2:	83 ec 04             	sub    $0x4,%esp
  802bc5:	68 70 3e 80 00       	push   $0x803e70
  802bca:	68 26 01 00 00       	push   $0x126
  802bcf:	68 93 3e 80 00       	push   $0x803e93
  802bd4:	e8 e2 d8 ff ff       	call   8004bb <_panic>
  802bd9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	89 10                	mov    %edx,(%eax)
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	85 c0                	test   %eax,%eax
  802beb:	74 0d                	je     802bfa <insert_sorted_with_merge_freeList+0x193>
  802bed:	a1 38 41 80 00       	mov    0x804138,%eax
  802bf2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf5:	89 50 04             	mov    %edx,0x4(%eax)
  802bf8:	eb 08                	jmp    802c02 <insert_sorted_with_merge_freeList+0x19b>
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	a3 38 41 80 00       	mov    %eax,0x804138
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c14:	a1 44 41 80 00       	mov    0x804144,%eax
  802c19:	40                   	inc    %eax
  802c1a:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802c1f:	e9 9c 05 00 00       	jmp    8031c0 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	8b 50 08             	mov    0x8(%eax),%edx
  802c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2d:	8b 40 08             	mov    0x8(%eax),%eax
  802c30:	39 c2                	cmp    %eax,%edx
  802c32:	0f 86 16 01 00 00    	jbe    802d4e <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3b:	8b 50 08             	mov    0x8(%eax),%edx
  802c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c41:	8b 40 0c             	mov    0xc(%eax),%eax
  802c44:	01 c2                	add    %eax,%edx
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	8b 40 08             	mov    0x8(%eax),%eax
  802c4c:	39 c2                	cmp    %eax,%edx
  802c4e:	0f 85 92 00 00 00    	jne    802ce6 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802c54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c57:	8b 50 0c             	mov    0xc(%eax),%edx
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c60:	01 c2                	add    %eax,%edx
  802c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c65:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	8b 50 08             	mov    0x8(%eax),%edx
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c82:	75 17                	jne    802c9b <insert_sorted_with_merge_freeList+0x234>
  802c84:	83 ec 04             	sub    $0x4,%esp
  802c87:	68 70 3e 80 00       	push   $0x803e70
  802c8c:	68 31 01 00 00       	push   $0x131
  802c91:	68 93 3e 80 00       	push   $0x803e93
  802c96:	e8 20 d8 ff ff       	call   8004bb <_panic>
  802c9b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca4:	89 10                	mov    %edx,(%eax)
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	8b 00                	mov    (%eax),%eax
  802cab:	85 c0                	test   %eax,%eax
  802cad:	74 0d                	je     802cbc <insert_sorted_with_merge_freeList+0x255>
  802caf:	a1 48 41 80 00       	mov    0x804148,%eax
  802cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb7:	89 50 04             	mov    %edx,0x4(%eax)
  802cba:	eb 08                	jmp    802cc4 <insert_sorted_with_merge_freeList+0x25d>
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc7:	a3 48 41 80 00       	mov    %eax,0x804148
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd6:	a1 54 41 80 00       	mov    0x804154,%eax
  802cdb:	40                   	inc    %eax
  802cdc:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802ce1:	e9 da 04 00 00       	jmp    8031c0 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802ce6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cea:	75 17                	jne    802d03 <insert_sorted_with_merge_freeList+0x29c>
  802cec:	83 ec 04             	sub    $0x4,%esp
  802cef:	68 18 3f 80 00       	push   $0x803f18
  802cf4:	68 37 01 00 00       	push   $0x137
  802cf9:	68 93 3e 80 00       	push   $0x803e93
  802cfe:	e8 b8 d7 ff ff       	call   8004bb <_panic>
  802d03:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	89 50 04             	mov    %edx,0x4(%eax)
  802d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d12:	8b 40 04             	mov    0x4(%eax),%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	74 0c                	je     802d25 <insert_sorted_with_merge_freeList+0x2be>
  802d19:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d21:	89 10                	mov    %edx,(%eax)
  802d23:	eb 08                	jmp    802d2d <insert_sorted_with_merge_freeList+0x2c6>
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	a3 38 41 80 00       	mov    %eax,0x804138
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3e:	a1 44 41 80 00       	mov    0x804144,%eax
  802d43:	40                   	inc    %eax
  802d44:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802d49:	e9 72 04 00 00       	jmp    8031c0 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802d4e:	a1 38 41 80 00       	mov    0x804138,%eax
  802d53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d56:	e9 35 04 00 00       	jmp    803190 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	8b 00                	mov    (%eax),%eax
  802d60:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	8b 50 08             	mov    0x8(%eax),%edx
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 40 08             	mov    0x8(%eax),%eax
  802d6f:	39 c2                	cmp    %eax,%edx
  802d71:	0f 86 11 04 00 00    	jbe    803188 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	8b 50 08             	mov    0x8(%eax),%edx
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	8b 40 0c             	mov    0xc(%eax),%eax
  802d83:	01 c2                	add    %eax,%edx
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	8b 40 08             	mov    0x8(%eax),%eax
  802d8b:	39 c2                	cmp    %eax,%edx
  802d8d:	0f 83 8b 00 00 00    	jae    802e1e <insert_sorted_with_merge_freeList+0x3b7>
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	8b 50 08             	mov    0x8(%eax),%edx
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9f:	01 c2                	add    %eax,%edx
  802da1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da4:	8b 40 08             	mov    0x8(%eax),%eax
  802da7:	39 c2                	cmp    %eax,%edx
  802da9:	73 73                	jae    802e1e <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802dab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802daf:	74 06                	je     802db7 <insert_sorted_with_merge_freeList+0x350>
  802db1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db5:	75 17                	jne    802dce <insert_sorted_with_merge_freeList+0x367>
  802db7:	83 ec 04             	sub    $0x4,%esp
  802dba:	68 e4 3e 80 00       	push   $0x803ee4
  802dbf:	68 48 01 00 00       	push   $0x148
  802dc4:	68 93 3e 80 00       	push   $0x803e93
  802dc9:	e8 ed d6 ff ff       	call   8004bb <_panic>
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	8b 10                	mov    (%eax),%edx
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	89 10                	mov    %edx,(%eax)
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	8b 00                	mov    (%eax),%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	74 0b                	je     802dec <insert_sorted_with_merge_freeList+0x385>
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	8b 55 08             	mov    0x8(%ebp),%edx
  802de9:	89 50 04             	mov    %edx,0x4(%eax)
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 55 08             	mov    0x8(%ebp),%edx
  802df2:	89 10                	mov    %edx,(%eax)
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dfa:	89 50 04             	mov    %edx,0x4(%eax)
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	8b 00                	mov    (%eax),%eax
  802e02:	85 c0                	test   %eax,%eax
  802e04:	75 08                	jne    802e0e <insert_sorted_with_merge_freeList+0x3a7>
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e0e:	a1 44 41 80 00       	mov    0x804144,%eax
  802e13:	40                   	inc    %eax
  802e14:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802e19:	e9 a2 03 00 00       	jmp    8031c0 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	8b 50 08             	mov    0x8(%eax),%edx
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2a:	01 c2                	add    %eax,%edx
  802e2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2f:	8b 40 08             	mov    0x8(%eax),%eax
  802e32:	39 c2                	cmp    %eax,%edx
  802e34:	0f 83 ae 00 00 00    	jae    802ee8 <insert_sorted_with_merge_freeList+0x481>
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	8b 50 08             	mov    0x8(%eax),%edx
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	8b 48 08             	mov    0x8(%eax),%ecx
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4c:	01 c8                	add    %ecx,%eax
  802e4e:	39 c2                	cmp    %eax,%edx
  802e50:	0f 85 92 00 00 00    	jne    802ee8 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 50 0c             	mov    0xc(%eax),%edx
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e62:	01 c2                	add    %eax,%edx
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	8b 50 08             	mov    0x8(%eax),%edx
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e84:	75 17                	jne    802e9d <insert_sorted_with_merge_freeList+0x436>
  802e86:	83 ec 04             	sub    $0x4,%esp
  802e89:	68 70 3e 80 00       	push   $0x803e70
  802e8e:	68 51 01 00 00       	push   $0x151
  802e93:	68 93 3e 80 00       	push   $0x803e93
  802e98:	e8 1e d6 ff ff       	call   8004bb <_panic>
  802e9d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	89 10                	mov    %edx,(%eax)
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	8b 00                	mov    (%eax),%eax
  802ead:	85 c0                	test   %eax,%eax
  802eaf:	74 0d                	je     802ebe <insert_sorted_with_merge_freeList+0x457>
  802eb1:	a1 48 41 80 00       	mov    0x804148,%eax
  802eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb9:	89 50 04             	mov    %edx,0x4(%eax)
  802ebc:	eb 08                	jmp    802ec6 <insert_sorted_with_merge_freeList+0x45f>
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	a3 48 41 80 00       	mov    %eax,0x804148
  802ece:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed8:	a1 54 41 80 00       	mov    0x804154,%eax
  802edd:	40                   	inc    %eax
  802ede:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802ee3:	e9 d8 02 00 00       	jmp    8031c0 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	8b 50 08             	mov    0x8(%eax),%edx
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef4:	01 c2                	add    %eax,%edx
  802ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef9:	8b 40 08             	mov    0x8(%eax),%eax
  802efc:	39 c2                	cmp    %eax,%edx
  802efe:	0f 85 ba 00 00 00    	jne    802fbe <insert_sorted_with_merge_freeList+0x557>
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	8b 50 08             	mov    0x8(%eax),%edx
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 48 08             	mov    0x8(%eax),%ecx
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	8b 40 0c             	mov    0xc(%eax),%eax
  802f16:	01 c8                	add    %ecx,%eax
  802f18:	39 c2                	cmp    %eax,%edx
  802f1a:	0f 86 9e 00 00 00    	jbe    802fbe <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802f20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f23:	8b 50 0c             	mov    0xc(%eax),%edx
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2c:	01 c2                	add    %eax,%edx
  802f2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f31:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802f34:	8b 45 08             	mov    0x8(%ebp),%eax
  802f37:	8b 50 08             	mov    0x8(%eax),%edx
  802f3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3d:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	8b 50 08             	mov    0x8(%eax),%edx
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5a:	75 17                	jne    802f73 <insert_sorted_with_merge_freeList+0x50c>
  802f5c:	83 ec 04             	sub    $0x4,%esp
  802f5f:	68 70 3e 80 00       	push   $0x803e70
  802f64:	68 5b 01 00 00       	push   $0x15b
  802f69:	68 93 3e 80 00       	push   $0x803e93
  802f6e:	e8 48 d5 ff ff       	call   8004bb <_panic>
  802f73:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	89 10                	mov    %edx,(%eax)
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 0d                	je     802f94 <insert_sorted_with_merge_freeList+0x52d>
  802f87:	a1 48 41 80 00       	mov    0x804148,%eax
  802f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8f:	89 50 04             	mov    %edx,0x4(%eax)
  802f92:	eb 08                	jmp    802f9c <insert_sorted_with_merge_freeList+0x535>
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	a3 48 41 80 00       	mov    %eax,0x804148
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fae:	a1 54 41 80 00       	mov    0x804154,%eax
  802fb3:	40                   	inc    %eax
  802fb4:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802fb9:	e9 02 02 00 00       	jmp    8031c0 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	8b 50 08             	mov    0x8(%eax),%edx
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fca:	01 c2                	add    %eax,%edx
  802fcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcf:	8b 40 08             	mov    0x8(%eax),%eax
  802fd2:	39 c2                	cmp    %eax,%edx
  802fd4:	0f 85 ae 01 00 00    	jne    803188 <insert_sorted_with_merge_freeList+0x721>
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	8b 50 08             	mov    0x8(%eax),%edx
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 48 08             	mov    0x8(%eax),%ecx
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fec:	01 c8                	add    %ecx,%eax
  802fee:	39 c2                	cmp    %eax,%edx
  802ff0:	0f 85 92 01 00 00    	jne    803188 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	8b 50 0c             	mov    0xc(%eax),%edx
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	8b 40 0c             	mov    0xc(%eax),%eax
  803002:	01 c2                	add    %eax,%edx
  803004:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803007:	8b 40 0c             	mov    0xc(%eax),%eax
  80300a:	01 c2                	add    %eax,%edx
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	8b 50 08             	mov    0x8(%eax),%edx
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803028:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803032:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803035:	8b 50 08             	mov    0x8(%eax),%edx
  803038:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303b:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  80303e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803042:	75 17                	jne    80305b <insert_sorted_with_merge_freeList+0x5f4>
  803044:	83 ec 04             	sub    $0x4,%esp
  803047:	68 3b 3f 80 00       	push   $0x803f3b
  80304c:	68 63 01 00 00       	push   $0x163
  803051:	68 93 3e 80 00       	push   $0x803e93
  803056:	e8 60 d4 ff ff       	call   8004bb <_panic>
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	8b 00                	mov    (%eax),%eax
  803060:	85 c0                	test   %eax,%eax
  803062:	74 10                	je     803074 <insert_sorted_with_merge_freeList+0x60d>
  803064:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803067:	8b 00                	mov    (%eax),%eax
  803069:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80306c:	8b 52 04             	mov    0x4(%edx),%edx
  80306f:	89 50 04             	mov    %edx,0x4(%eax)
  803072:	eb 0b                	jmp    80307f <insert_sorted_with_merge_freeList+0x618>
  803074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803077:	8b 40 04             	mov    0x4(%eax),%eax
  80307a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80307f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803082:	8b 40 04             	mov    0x4(%eax),%eax
  803085:	85 c0                	test   %eax,%eax
  803087:	74 0f                	je     803098 <insert_sorted_with_merge_freeList+0x631>
  803089:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308c:	8b 40 04             	mov    0x4(%eax),%eax
  80308f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803092:	8b 12                	mov    (%edx),%edx
  803094:	89 10                	mov    %edx,(%eax)
  803096:	eb 0a                	jmp    8030a2 <insert_sorted_with_merge_freeList+0x63b>
  803098:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309b:	8b 00                	mov    (%eax),%eax
  80309d:	a3 38 41 80 00       	mov    %eax,0x804138
  8030a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b5:	a1 44 41 80 00       	mov    0x804144,%eax
  8030ba:	48                   	dec    %eax
  8030bb:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8030c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030c4:	75 17                	jne    8030dd <insert_sorted_with_merge_freeList+0x676>
  8030c6:	83 ec 04             	sub    $0x4,%esp
  8030c9:	68 70 3e 80 00       	push   $0x803e70
  8030ce:	68 64 01 00 00       	push   $0x164
  8030d3:	68 93 3e 80 00       	push   $0x803e93
  8030d8:	e8 de d3 ff ff       	call   8004bb <_panic>
  8030dd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e6:	89 10                	mov    %edx,(%eax)
  8030e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030eb:	8b 00                	mov    (%eax),%eax
  8030ed:	85 c0                	test   %eax,%eax
  8030ef:	74 0d                	je     8030fe <insert_sorted_with_merge_freeList+0x697>
  8030f1:	a1 48 41 80 00       	mov    0x804148,%eax
  8030f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030f9:	89 50 04             	mov    %edx,0x4(%eax)
  8030fc:	eb 08                	jmp    803106 <insert_sorted_with_merge_freeList+0x69f>
  8030fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803101:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	a3 48 41 80 00       	mov    %eax,0x804148
  80310e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803111:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803118:	a1 54 41 80 00       	mov    0x804154,%eax
  80311d:	40                   	inc    %eax
  80311e:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803123:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803127:	75 17                	jne    803140 <insert_sorted_with_merge_freeList+0x6d9>
  803129:	83 ec 04             	sub    $0x4,%esp
  80312c:	68 70 3e 80 00       	push   $0x803e70
  803131:	68 65 01 00 00       	push   $0x165
  803136:	68 93 3e 80 00       	push   $0x803e93
  80313b:	e8 7b d3 ff ff       	call   8004bb <_panic>
  803140:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803146:	8b 45 08             	mov    0x8(%ebp),%eax
  803149:	89 10                	mov    %edx,(%eax)
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	8b 00                	mov    (%eax),%eax
  803150:	85 c0                	test   %eax,%eax
  803152:	74 0d                	je     803161 <insert_sorted_with_merge_freeList+0x6fa>
  803154:	a1 48 41 80 00       	mov    0x804148,%eax
  803159:	8b 55 08             	mov    0x8(%ebp),%edx
  80315c:	89 50 04             	mov    %edx,0x4(%eax)
  80315f:	eb 08                	jmp    803169 <insert_sorted_with_merge_freeList+0x702>
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	a3 48 41 80 00       	mov    %eax,0x804148
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317b:	a1 54 41 80 00       	mov    0x804154,%eax
  803180:	40                   	inc    %eax
  803181:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  803186:	eb 38                	jmp    8031c0 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803188:	a1 40 41 80 00       	mov    0x804140,%eax
  80318d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803190:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803194:	74 07                	je     80319d <insert_sorted_with_merge_freeList+0x736>
  803196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	eb 05                	jmp    8031a2 <insert_sorted_with_merge_freeList+0x73b>
  80319d:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a2:	a3 40 41 80 00       	mov    %eax,0x804140
  8031a7:	a1 40 41 80 00       	mov    0x804140,%eax
  8031ac:	85 c0                	test   %eax,%eax
  8031ae:	0f 85 a7 fb ff ff    	jne    802d5b <insert_sorted_with_merge_freeList+0x2f4>
  8031b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b8:	0f 85 9d fb ff ff    	jne    802d5b <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8031be:	eb 00                	jmp    8031c0 <insert_sorted_with_merge_freeList+0x759>
  8031c0:	90                   	nop
  8031c1:	c9                   	leave  
  8031c2:	c3                   	ret    

008031c3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8031c3:	55                   	push   %ebp
  8031c4:	89 e5                	mov    %esp,%ebp
  8031c6:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8031c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8031cc:	89 d0                	mov    %edx,%eax
  8031ce:	c1 e0 02             	shl    $0x2,%eax
  8031d1:	01 d0                	add    %edx,%eax
  8031d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031da:	01 d0                	add    %edx,%eax
  8031dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031e3:	01 d0                	add    %edx,%eax
  8031e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031ec:	01 d0                	add    %edx,%eax
  8031ee:	c1 e0 04             	shl    $0x4,%eax
  8031f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8031f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8031fb:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8031fe:	83 ec 0c             	sub    $0xc,%esp
  803201:	50                   	push   %eax
  803202:	e8 ee eb ff ff       	call   801df5 <sys_get_virtual_time>
  803207:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80320a:	eb 41                	jmp    80324d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80320c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80320f:	83 ec 0c             	sub    $0xc,%esp
  803212:	50                   	push   %eax
  803213:	e8 dd eb ff ff       	call   801df5 <sys_get_virtual_time>
  803218:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80321b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80321e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803221:	29 c2                	sub    %eax,%edx
  803223:	89 d0                	mov    %edx,%eax
  803225:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803228:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80322b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322e:	89 d1                	mov    %edx,%ecx
  803230:	29 c1                	sub    %eax,%ecx
  803232:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803235:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803238:	39 c2                	cmp    %eax,%edx
  80323a:	0f 97 c0             	seta   %al
  80323d:	0f b6 c0             	movzbl %al,%eax
  803240:	29 c1                	sub    %eax,%ecx
  803242:	89 c8                	mov    %ecx,%eax
  803244:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803247:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80324a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803253:	72 b7                	jb     80320c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803255:	90                   	nop
  803256:	c9                   	leave  
  803257:	c3                   	ret    

00803258 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803258:	55                   	push   %ebp
  803259:	89 e5                	mov    %esp,%ebp
  80325b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80325e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803265:	eb 03                	jmp    80326a <busy_wait+0x12>
  803267:	ff 45 fc             	incl   -0x4(%ebp)
  80326a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80326d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803270:	72 f5                	jb     803267 <busy_wait+0xf>
	return i;
  803272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803275:	c9                   	leave  
  803276:	c3                   	ret    
  803277:	90                   	nop

00803278 <__udivdi3>:
  803278:	55                   	push   %ebp
  803279:	57                   	push   %edi
  80327a:	56                   	push   %esi
  80327b:	53                   	push   %ebx
  80327c:	83 ec 1c             	sub    $0x1c,%esp
  80327f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803283:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803287:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80328b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80328f:	89 ca                	mov    %ecx,%edx
  803291:	89 f8                	mov    %edi,%eax
  803293:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803297:	85 f6                	test   %esi,%esi
  803299:	75 2d                	jne    8032c8 <__udivdi3+0x50>
  80329b:	39 cf                	cmp    %ecx,%edi
  80329d:	77 65                	ja     803304 <__udivdi3+0x8c>
  80329f:	89 fd                	mov    %edi,%ebp
  8032a1:	85 ff                	test   %edi,%edi
  8032a3:	75 0b                	jne    8032b0 <__udivdi3+0x38>
  8032a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8032aa:	31 d2                	xor    %edx,%edx
  8032ac:	f7 f7                	div    %edi
  8032ae:	89 c5                	mov    %eax,%ebp
  8032b0:	31 d2                	xor    %edx,%edx
  8032b2:	89 c8                	mov    %ecx,%eax
  8032b4:	f7 f5                	div    %ebp
  8032b6:	89 c1                	mov    %eax,%ecx
  8032b8:	89 d8                	mov    %ebx,%eax
  8032ba:	f7 f5                	div    %ebp
  8032bc:	89 cf                	mov    %ecx,%edi
  8032be:	89 fa                	mov    %edi,%edx
  8032c0:	83 c4 1c             	add    $0x1c,%esp
  8032c3:	5b                   	pop    %ebx
  8032c4:	5e                   	pop    %esi
  8032c5:	5f                   	pop    %edi
  8032c6:	5d                   	pop    %ebp
  8032c7:	c3                   	ret    
  8032c8:	39 ce                	cmp    %ecx,%esi
  8032ca:	77 28                	ja     8032f4 <__udivdi3+0x7c>
  8032cc:	0f bd fe             	bsr    %esi,%edi
  8032cf:	83 f7 1f             	xor    $0x1f,%edi
  8032d2:	75 40                	jne    803314 <__udivdi3+0x9c>
  8032d4:	39 ce                	cmp    %ecx,%esi
  8032d6:	72 0a                	jb     8032e2 <__udivdi3+0x6a>
  8032d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032dc:	0f 87 9e 00 00 00    	ja     803380 <__udivdi3+0x108>
  8032e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032e7:	89 fa                	mov    %edi,%edx
  8032e9:	83 c4 1c             	add    $0x1c,%esp
  8032ec:	5b                   	pop    %ebx
  8032ed:	5e                   	pop    %esi
  8032ee:	5f                   	pop    %edi
  8032ef:	5d                   	pop    %ebp
  8032f0:	c3                   	ret    
  8032f1:	8d 76 00             	lea    0x0(%esi),%esi
  8032f4:	31 ff                	xor    %edi,%edi
  8032f6:	31 c0                	xor    %eax,%eax
  8032f8:	89 fa                	mov    %edi,%edx
  8032fa:	83 c4 1c             	add    $0x1c,%esp
  8032fd:	5b                   	pop    %ebx
  8032fe:	5e                   	pop    %esi
  8032ff:	5f                   	pop    %edi
  803300:	5d                   	pop    %ebp
  803301:	c3                   	ret    
  803302:	66 90                	xchg   %ax,%ax
  803304:	89 d8                	mov    %ebx,%eax
  803306:	f7 f7                	div    %edi
  803308:	31 ff                	xor    %edi,%edi
  80330a:	89 fa                	mov    %edi,%edx
  80330c:	83 c4 1c             	add    $0x1c,%esp
  80330f:	5b                   	pop    %ebx
  803310:	5e                   	pop    %esi
  803311:	5f                   	pop    %edi
  803312:	5d                   	pop    %ebp
  803313:	c3                   	ret    
  803314:	bd 20 00 00 00       	mov    $0x20,%ebp
  803319:	89 eb                	mov    %ebp,%ebx
  80331b:	29 fb                	sub    %edi,%ebx
  80331d:	89 f9                	mov    %edi,%ecx
  80331f:	d3 e6                	shl    %cl,%esi
  803321:	89 c5                	mov    %eax,%ebp
  803323:	88 d9                	mov    %bl,%cl
  803325:	d3 ed                	shr    %cl,%ebp
  803327:	89 e9                	mov    %ebp,%ecx
  803329:	09 f1                	or     %esi,%ecx
  80332b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80332f:	89 f9                	mov    %edi,%ecx
  803331:	d3 e0                	shl    %cl,%eax
  803333:	89 c5                	mov    %eax,%ebp
  803335:	89 d6                	mov    %edx,%esi
  803337:	88 d9                	mov    %bl,%cl
  803339:	d3 ee                	shr    %cl,%esi
  80333b:	89 f9                	mov    %edi,%ecx
  80333d:	d3 e2                	shl    %cl,%edx
  80333f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803343:	88 d9                	mov    %bl,%cl
  803345:	d3 e8                	shr    %cl,%eax
  803347:	09 c2                	or     %eax,%edx
  803349:	89 d0                	mov    %edx,%eax
  80334b:	89 f2                	mov    %esi,%edx
  80334d:	f7 74 24 0c          	divl   0xc(%esp)
  803351:	89 d6                	mov    %edx,%esi
  803353:	89 c3                	mov    %eax,%ebx
  803355:	f7 e5                	mul    %ebp
  803357:	39 d6                	cmp    %edx,%esi
  803359:	72 19                	jb     803374 <__udivdi3+0xfc>
  80335b:	74 0b                	je     803368 <__udivdi3+0xf0>
  80335d:	89 d8                	mov    %ebx,%eax
  80335f:	31 ff                	xor    %edi,%edi
  803361:	e9 58 ff ff ff       	jmp    8032be <__udivdi3+0x46>
  803366:	66 90                	xchg   %ax,%ax
  803368:	8b 54 24 08          	mov    0x8(%esp),%edx
  80336c:	89 f9                	mov    %edi,%ecx
  80336e:	d3 e2                	shl    %cl,%edx
  803370:	39 c2                	cmp    %eax,%edx
  803372:	73 e9                	jae    80335d <__udivdi3+0xe5>
  803374:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803377:	31 ff                	xor    %edi,%edi
  803379:	e9 40 ff ff ff       	jmp    8032be <__udivdi3+0x46>
  80337e:	66 90                	xchg   %ax,%ax
  803380:	31 c0                	xor    %eax,%eax
  803382:	e9 37 ff ff ff       	jmp    8032be <__udivdi3+0x46>
  803387:	90                   	nop

00803388 <__umoddi3>:
  803388:	55                   	push   %ebp
  803389:	57                   	push   %edi
  80338a:	56                   	push   %esi
  80338b:	53                   	push   %ebx
  80338c:	83 ec 1c             	sub    $0x1c,%esp
  80338f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803393:	8b 74 24 34          	mov    0x34(%esp),%esi
  803397:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80339b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80339f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033a7:	89 f3                	mov    %esi,%ebx
  8033a9:	89 fa                	mov    %edi,%edx
  8033ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033af:	89 34 24             	mov    %esi,(%esp)
  8033b2:	85 c0                	test   %eax,%eax
  8033b4:	75 1a                	jne    8033d0 <__umoddi3+0x48>
  8033b6:	39 f7                	cmp    %esi,%edi
  8033b8:	0f 86 a2 00 00 00    	jbe    803460 <__umoddi3+0xd8>
  8033be:	89 c8                	mov    %ecx,%eax
  8033c0:	89 f2                	mov    %esi,%edx
  8033c2:	f7 f7                	div    %edi
  8033c4:	89 d0                	mov    %edx,%eax
  8033c6:	31 d2                	xor    %edx,%edx
  8033c8:	83 c4 1c             	add    $0x1c,%esp
  8033cb:	5b                   	pop    %ebx
  8033cc:	5e                   	pop    %esi
  8033cd:	5f                   	pop    %edi
  8033ce:	5d                   	pop    %ebp
  8033cf:	c3                   	ret    
  8033d0:	39 f0                	cmp    %esi,%eax
  8033d2:	0f 87 ac 00 00 00    	ja     803484 <__umoddi3+0xfc>
  8033d8:	0f bd e8             	bsr    %eax,%ebp
  8033db:	83 f5 1f             	xor    $0x1f,%ebp
  8033de:	0f 84 ac 00 00 00    	je     803490 <__umoddi3+0x108>
  8033e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8033e9:	29 ef                	sub    %ebp,%edi
  8033eb:	89 fe                	mov    %edi,%esi
  8033ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033f1:	89 e9                	mov    %ebp,%ecx
  8033f3:	d3 e0                	shl    %cl,%eax
  8033f5:	89 d7                	mov    %edx,%edi
  8033f7:	89 f1                	mov    %esi,%ecx
  8033f9:	d3 ef                	shr    %cl,%edi
  8033fb:	09 c7                	or     %eax,%edi
  8033fd:	89 e9                	mov    %ebp,%ecx
  8033ff:	d3 e2                	shl    %cl,%edx
  803401:	89 14 24             	mov    %edx,(%esp)
  803404:	89 d8                	mov    %ebx,%eax
  803406:	d3 e0                	shl    %cl,%eax
  803408:	89 c2                	mov    %eax,%edx
  80340a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80340e:	d3 e0                	shl    %cl,%eax
  803410:	89 44 24 04          	mov    %eax,0x4(%esp)
  803414:	8b 44 24 08          	mov    0x8(%esp),%eax
  803418:	89 f1                	mov    %esi,%ecx
  80341a:	d3 e8                	shr    %cl,%eax
  80341c:	09 d0                	or     %edx,%eax
  80341e:	d3 eb                	shr    %cl,%ebx
  803420:	89 da                	mov    %ebx,%edx
  803422:	f7 f7                	div    %edi
  803424:	89 d3                	mov    %edx,%ebx
  803426:	f7 24 24             	mull   (%esp)
  803429:	89 c6                	mov    %eax,%esi
  80342b:	89 d1                	mov    %edx,%ecx
  80342d:	39 d3                	cmp    %edx,%ebx
  80342f:	0f 82 87 00 00 00    	jb     8034bc <__umoddi3+0x134>
  803435:	0f 84 91 00 00 00    	je     8034cc <__umoddi3+0x144>
  80343b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80343f:	29 f2                	sub    %esi,%edx
  803441:	19 cb                	sbb    %ecx,%ebx
  803443:	89 d8                	mov    %ebx,%eax
  803445:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803449:	d3 e0                	shl    %cl,%eax
  80344b:	89 e9                	mov    %ebp,%ecx
  80344d:	d3 ea                	shr    %cl,%edx
  80344f:	09 d0                	or     %edx,%eax
  803451:	89 e9                	mov    %ebp,%ecx
  803453:	d3 eb                	shr    %cl,%ebx
  803455:	89 da                	mov    %ebx,%edx
  803457:	83 c4 1c             	add    $0x1c,%esp
  80345a:	5b                   	pop    %ebx
  80345b:	5e                   	pop    %esi
  80345c:	5f                   	pop    %edi
  80345d:	5d                   	pop    %ebp
  80345e:	c3                   	ret    
  80345f:	90                   	nop
  803460:	89 fd                	mov    %edi,%ebp
  803462:	85 ff                	test   %edi,%edi
  803464:	75 0b                	jne    803471 <__umoddi3+0xe9>
  803466:	b8 01 00 00 00       	mov    $0x1,%eax
  80346b:	31 d2                	xor    %edx,%edx
  80346d:	f7 f7                	div    %edi
  80346f:	89 c5                	mov    %eax,%ebp
  803471:	89 f0                	mov    %esi,%eax
  803473:	31 d2                	xor    %edx,%edx
  803475:	f7 f5                	div    %ebp
  803477:	89 c8                	mov    %ecx,%eax
  803479:	f7 f5                	div    %ebp
  80347b:	89 d0                	mov    %edx,%eax
  80347d:	e9 44 ff ff ff       	jmp    8033c6 <__umoddi3+0x3e>
  803482:	66 90                	xchg   %ax,%ax
  803484:	89 c8                	mov    %ecx,%eax
  803486:	89 f2                	mov    %esi,%edx
  803488:	83 c4 1c             	add    $0x1c,%esp
  80348b:	5b                   	pop    %ebx
  80348c:	5e                   	pop    %esi
  80348d:	5f                   	pop    %edi
  80348e:	5d                   	pop    %ebp
  80348f:	c3                   	ret    
  803490:	3b 04 24             	cmp    (%esp),%eax
  803493:	72 06                	jb     80349b <__umoddi3+0x113>
  803495:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803499:	77 0f                	ja     8034aa <__umoddi3+0x122>
  80349b:	89 f2                	mov    %esi,%edx
  80349d:	29 f9                	sub    %edi,%ecx
  80349f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034a3:	89 14 24             	mov    %edx,(%esp)
  8034a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034ae:	8b 14 24             	mov    (%esp),%edx
  8034b1:	83 c4 1c             	add    $0x1c,%esp
  8034b4:	5b                   	pop    %ebx
  8034b5:	5e                   	pop    %esi
  8034b6:	5f                   	pop    %edi
  8034b7:	5d                   	pop    %ebp
  8034b8:	c3                   	ret    
  8034b9:	8d 76 00             	lea    0x0(%esi),%esi
  8034bc:	2b 04 24             	sub    (%esp),%eax
  8034bf:	19 fa                	sbb    %edi,%edx
  8034c1:	89 d1                	mov    %edx,%ecx
  8034c3:	89 c6                	mov    %eax,%esi
  8034c5:	e9 71 ff ff ff       	jmp    80343b <__umoddi3+0xb3>
  8034ca:	66 90                	xchg   %ax,%ax
  8034cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034d0:	72 ea                	jb     8034bc <__umoddi3+0x134>
  8034d2:	89 d9                	mov    %ebx,%ecx
  8034d4:	e9 62 ff ff ff       	jmp    80343b <__umoddi3+0xb3>
