
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 35 03 00 00       	call   80036b <libmain>
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
  800099:	e8 09 04 00 00       	call   8004a7 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 df 15 00 00       	call   801687 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 05 1a 00 00       	call   801ab5 <sys_calculate_free_frames>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 17 35 80 00       	push   $0x803517
  8000bf:	e8 12 17 00 00       	call   8017d6 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000ca:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 1c 35 80 00       	push   $0x80351c
  8000db:	6a 1e                	push   $0x1e
  8000dd:	68 fc 34 80 00       	push   $0x8034fc
  8000e2:	e8 c0 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ea:	e8 c6 19 00 00       	call   801ab5 <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 80 35 80 00       	push   $0x803580
  800100:	6a 1f                	push   $0x1f
  800102:	68 fc 34 80 00       	push   $0x8034fc
  800107:	e8 9b 03 00 00       	call   8004a7 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 a4 19 00 00       	call   801ab5 <sys_calculate_free_frames>
  800111:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 00                	push   $0x0
  800119:	6a 04                	push   $0x4
  80011b:	68 08 36 80 00       	push   $0x803608
  800120:	e8 b1 16 00 00       	call   8017d6 <smalloc>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012b:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 1c 35 80 00       	push   $0x80351c
  80013c:	6a 24                	push   $0x24
  80013e:	68 fc 34 80 00       	push   $0x8034fc
  800143:	e8 5f 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800148:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014b:	e8 65 19 00 00       	call   801ab5 <sys_calculate_free_frames>
  800150:	29 c3                	sub    %eax,%ebx
  800152:	89 d8                	mov    %ebx,%eax
  800154:	83 f8 03             	cmp    $0x3,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 80 35 80 00       	push   $0x803580
  800161:	6a 25                	push   $0x25
  800163:	68 fc 34 80 00       	push   $0x8034fc
  800168:	e8 3a 03 00 00       	call   8004a7 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80016d:	e8 43 19 00 00       	call   801ab5 <sys_calculate_free_frames>
  800172:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 04                	push   $0x4
  80017c:	68 0a 36 80 00       	push   $0x80360a
  800181:	e8 50 16 00 00       	call   8017d6 <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80018c:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 1c 35 80 00       	push   $0x80351c
  80019d:	6a 2a                	push   $0x2a
  80019f:	68 fc 34 80 00       	push   $0x8034fc
  8001a4:	e8 fe 02 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ac:	e8 04 19 00 00       	call   801ab5 <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 f8 03             	cmp    $0x3,%eax
  8001b8:	74 14                	je     8001ce <_main+0x196>
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	68 80 35 80 00       	push   $0x803580
  8001c2:	6a 2b                	push   $0x2b
  8001c4:	68 fc 34 80 00       	push   $0x8034fc
  8001c9:	e8 d9 02 00 00       	call   8004a7 <_panic>

	*x = 10 ;
  8001ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001d1:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001da:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001f6:	89 c1                	mov    %eax,%ecx
  8001f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fd:	8b 40 74             	mov    0x74(%eax),%eax
  800200:	52                   	push   %edx
  800201:	51                   	push   %ecx
  800202:	50                   	push   %eax
  800203:	68 0c 36 80 00       	push   $0x80360c
  800208:	e8 1a 1b 00 00       	call   801d27 <sys_create_env>
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800213:	a1 20 40 80 00       	mov    0x804020,%eax
  800218:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021e:	a1 20 40 80 00       	mov    0x804020,%eax
  800223:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800229:	89 c1                	mov    %eax,%ecx
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8b 40 74             	mov    0x74(%eax),%eax
  800233:	52                   	push   %edx
  800234:	51                   	push   %ecx
  800235:	50                   	push   %eax
  800236:	68 0c 36 80 00       	push   $0x80360c
  80023b:	e8 e7 1a 00 00       	call   801d27 <sys_create_env>
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800246:	a1 20 40 80 00       	mov    0x804020,%eax
  80024b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800251:	a1 20 40 80 00       	mov    0x804020,%eax
  800256:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80025c:	89 c1                	mov    %eax,%ecx
  80025e:	a1 20 40 80 00       	mov    0x804020,%eax
  800263:	8b 40 74             	mov    0x74(%eax),%eax
  800266:	52                   	push   %edx
  800267:	51                   	push   %ecx
  800268:	50                   	push   %eax
  800269:	68 0c 36 80 00       	push   $0x80360c
  80026e:	e8 b4 1a 00 00       	call   801d27 <sys_create_env>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800279:	e8 f5 1b 00 00       	call   801e73 <rsttst>

	sys_run_env(id1);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	e8 bc 1a 00 00       	call   801d45 <sys_run_env>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 ae 1a 00 00       	call   801d45 <sys_run_env>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a0:	e8 a0 1a 00 00       	call   801d45 <sys_run_env>
  8002a5:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 e0 2e 00 00       	push   $0x2ee0
  8002b0:	e8 fa 2e 00 00       	call   8031af <env_sleep>
  8002b5:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002b8:	e8 30 1c 00 00       	call   801eed <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	74 14                	je     8002d6 <_main+0x29e>
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	68 17 36 80 00       	push   $0x803617
  8002ca:	6a 3f                	push   $0x3f
  8002cc:	68 fc 34 80 00       	push   $0x8034fc
  8002d1:	e8 d1 01 00 00       	call   8004a7 <_panic>


	if (*z != 30)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	83 f8 1e             	cmp    $0x1e,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 24 36 80 00       	push   $0x803624
  8002e8:	6a 43                	push   $0x43
  8002ea:	68 fc 34 80 00       	push   $0x8034fc
  8002ef:	e8 b3 01 00 00       	call   8004a7 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 70 36 80 00       	push   $0x803670
  8002fc:	e8 5a 04 00 00       	call   80075b <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 cc 36 80 00       	push   $0x8036cc
  80030c:	e8 4a 04 00 00       	call   80075b <cprintf>
  800311:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800314:	a1 20 40 80 00       	mov    0x804020,%eax
  800319:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80031f:	a1 20 40 80 00       	mov    0x804020,%eax
  800324:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80032a:	89 c1                	mov    %eax,%ecx
  80032c:	a1 20 40 80 00       	mov    0x804020,%eax
  800331:	8b 40 74             	mov    0x74(%eax),%eax
  800334:	52                   	push   %edx
  800335:	51                   	push   %ecx
  800336:	50                   	push   %eax
  800337:	68 27 37 80 00       	push   $0x803727
  80033c:	e8 e6 19 00 00       	call   801d27 <sys_create_env>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 b8 0b 00 00       	push   $0xbb8
  80034f:	e8 5b 2e 00 00       	call   8031af <env_sleep>
  800354:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 dc             	pushl  -0x24(%ebp)
  80035d:	e8 e3 19 00 00       	call   801d45 <sys_run_env>
  800362:	83 c4 10             	add    $0x10,%esp

	return;
  800365:	90                   	nop
}
  800366:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800371:	e8 1f 1a 00 00       	call   801d95 <sys_getenvindex>
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80037c:	89 d0                	mov    %edx,%eax
  80037e:	c1 e0 03             	shl    $0x3,%eax
  800381:	01 d0                	add    %edx,%eax
  800383:	01 c0                	add    %eax,%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038e:	01 d0                	add    %edx,%eax
  800390:	c1 e0 04             	shl    $0x4,%eax
  800393:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800398:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80039d:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003a8:	84 c0                	test   %al,%al
  8003aa:	74 0f                	je     8003bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8003b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003bf:	7e 0a                	jle    8003cb <libmain+0x60>
		binaryname = argv[0];
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 5f fc ff ff       	call   800038 <_main>
  8003d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003dc:	e8 c1 17 00 00       	call   801ba2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 4c 37 80 00       	push   $0x80374c
  8003e9:	e8 6d 03 00 00       	call   80075b <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800401:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800407:	83 ec 04             	sub    $0x4,%esp
  80040a:	52                   	push   %edx
  80040b:	50                   	push   %eax
  80040c:	68 74 37 80 00       	push   $0x803774
  800411:	e8 45 03 00 00       	call   80075b <cprintf>
  800416:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800419:	a1 20 40 80 00       	mov    0x804020,%eax
  80041e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800424:	a1 20 40 80 00       	mov    0x804020,%eax
  800429:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80042f:	a1 20 40 80 00       	mov    0x804020,%eax
  800434:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80043a:	51                   	push   %ecx
  80043b:	52                   	push   %edx
  80043c:	50                   	push   %eax
  80043d:	68 9c 37 80 00       	push   $0x80379c
  800442:	e8 14 03 00 00       	call   80075b <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044a:	a1 20 40 80 00       	mov    0x804020,%eax
  80044f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	50                   	push   %eax
  800459:	68 f4 37 80 00       	push   $0x8037f4
  80045e:	e8 f8 02 00 00       	call   80075b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	68 4c 37 80 00       	push   $0x80374c
  80046e:	e8 e8 02 00 00       	call   80075b <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800476:	e8 41 17 00 00       	call   801bbc <sys_enable_interrupt>

	// exit gracefully
	exit();
  80047b:	e8 19 00 00 00       	call   800499 <exit>
}
  800480:	90                   	nop
  800481:	c9                   	leave  
  800482:	c3                   	ret    

00800483 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800489:	83 ec 0c             	sub    $0xc,%esp
  80048c:	6a 00                	push   $0x0
  80048e:	e8 ce 18 00 00       	call   801d61 <sys_destroy_env>
  800493:	83 c4 10             	add    $0x10,%esp
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <exit>:

void
exit(void)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80049f:	e8 23 19 00 00       	call   801dc7 <sys_exit_env>
}
  8004a4:	90                   	nop
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

008004a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b0:	83 c0 04             	add    $0x4,%eax
  8004b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004b6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	74 16                	je     8004d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004bf:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	50                   	push   %eax
  8004c8:	68 08 38 80 00       	push   $0x803808
  8004cd:	e8 89 02 00 00       	call   80075b <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 40 80 00       	mov    0x804000,%eax
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	68 0d 38 80 00       	push   $0x80380d
  8004e6:	e8 70 02 00 00       	call   80075b <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f7:	50                   	push   %eax
  8004f8:	e8 f3 01 00 00       	call   8006f0 <vcprintf>
  8004fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	6a 00                	push   $0x0
  800505:	68 29 38 80 00       	push   $0x803829
  80050a:	e8 e1 01 00 00       	call   8006f0 <vcprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800512:	e8 82 ff ff ff       	call   800499 <exit>

	// should not return here
	while (1) ;
  800517:	eb fe                	jmp    800517 <_panic+0x70>

00800519 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80051f:	a1 20 40 80 00       	mov    0x804020,%eax
  800524:	8b 50 74             	mov    0x74(%eax),%edx
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	39 c2                	cmp    %eax,%edx
  80052c:	74 14                	je     800542 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	68 2c 38 80 00       	push   $0x80382c
  800536:	6a 26                	push   $0x26
  800538:	68 78 38 80 00       	push   $0x803878
  80053d:	e8 65 ff ff ff       	call   8004a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800550:	e9 c2 00 00 00       	jmp    800617 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800558:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	01 d0                	add    %edx,%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	85 c0                	test   %eax,%eax
  800568:	75 08                	jne    800572 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80056a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80056d:	e9 a2 00 00 00       	jmp    800614 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800572:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800579:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800580:	eb 69                	jmp    8005eb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800582:	a1 20 40 80 00       	mov    0x804020,%eax
  800587:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800590:	89 d0                	mov    %edx,%eax
  800592:	01 c0                	add    %eax,%eax
  800594:	01 d0                	add    %edx,%eax
  800596:	c1 e0 03             	shl    $0x3,%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8a 40 04             	mov    0x4(%eax),%al
  80059e:	84 c0                	test   %al,%al
  8005a0:	75 46                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b0:	89 d0                	mov    %edx,%eax
  8005b2:	01 c0                	add    %eax,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	c1 e0 03             	shl    $0x3,%eax
  8005b9:	01 c8                	add    %ecx,%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d7:	01 c8                	add    %ecx,%eax
  8005d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005db:	39 c2                	cmp    %eax,%edx
  8005dd:	75 09                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e6:	eb 12                	jmp    8005fa <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e8:	ff 45 e8             	incl   -0x18(%ebp)
  8005eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f0:	8b 50 74             	mov    0x74(%eax),%edx
  8005f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f6:	39 c2                	cmp    %eax,%edx
  8005f8:	77 88                	ja     800582 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005fe:	75 14                	jne    800614 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 84 38 80 00       	push   $0x803884
  800608:	6a 3a                	push   $0x3a
  80060a:	68 78 38 80 00       	push   $0x803878
  80060f:	e8 93 fe ff ff       	call   8004a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800614:	ff 45 f0             	incl   -0x10(%ebp)
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80061d:	0f 8c 32 ff ff ff    	jl     800555 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800631:	eb 26                	jmp    800659 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800633:	a1 20 40 80 00       	mov    0x804020,%eax
  800638:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80063e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800641:	89 d0                	mov    %edx,%eax
  800643:	01 c0                	add    %eax,%eax
  800645:	01 d0                	add    %edx,%eax
  800647:	c1 e0 03             	shl    $0x3,%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8a 40 04             	mov    0x4(%eax),%al
  80064f:	3c 01                	cmp    $0x1,%al
  800651:	75 03                	jne    800656 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800653:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800656:	ff 45 e0             	incl   -0x20(%ebp)
  800659:	a1 20 40 80 00       	mov    0x804020,%eax
  80065e:	8b 50 74             	mov    0x74(%eax),%edx
  800661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800664:	39 c2                	cmp    %eax,%edx
  800666:	77 cb                	ja     800633 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80066e:	74 14                	je     800684 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800670:	83 ec 04             	sub    $0x4,%esp
  800673:	68 d8 38 80 00       	push   $0x8038d8
  800678:	6a 44                	push   $0x44
  80067a:	68 78 38 80 00       	push   $0x803878
  80067f:	e8 23 fe ff ff       	call   8004a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800684:	90                   	nop
  800685:	c9                   	leave  
  800686:	c3                   	ret    

00800687 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800687:	55                   	push   %ebp
  800688:	89 e5                	mov    %esp,%ebp
  80068a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	8d 48 01             	lea    0x1(%eax),%ecx
  800695:	8b 55 0c             	mov    0xc(%ebp),%edx
  800698:	89 0a                	mov    %ecx,(%edx)
  80069a:	8b 55 08             	mov    0x8(%ebp),%edx
  80069d:	88 d1                	mov    %dl,%cl
  80069f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b0:	75 2c                	jne    8006de <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006b2:	a0 24 40 80 00       	mov    0x804024,%al
  8006b7:	0f b6 c0             	movzbl %al,%eax
  8006ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bd:	8b 12                	mov    (%edx),%edx
  8006bf:	89 d1                	mov    %edx,%ecx
  8006c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c4:	83 c2 08             	add    $0x8,%edx
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	50                   	push   %eax
  8006cb:	51                   	push   %ecx
  8006cc:	52                   	push   %edx
  8006cd:	e8 22 13 00 00       	call   8019f4 <sys_cputs>
  8006d2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	8b 40 04             	mov    0x4(%eax),%eax
  8006e4:	8d 50 01             	lea    0x1(%eax),%edx
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ed:	90                   	nop
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800700:	00 00 00 
	b.cnt = 0;
  800703:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	ff 75 08             	pushl  0x8(%ebp)
  800713:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800719:	50                   	push   %eax
  80071a:	68 87 06 80 00       	push   $0x800687
  80071f:	e8 11 02 00 00       	call   800935 <vprintfmt>
  800724:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800727:	a0 24 40 80 00       	mov    0x804024,%al
  80072c:	0f b6 c0             	movzbl %al,%eax
  80072f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800735:	83 ec 04             	sub    $0x4,%esp
  800738:	50                   	push   %eax
  800739:	52                   	push   %edx
  80073a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800740:	83 c0 08             	add    $0x8,%eax
  800743:	50                   	push   %eax
  800744:	e8 ab 12 00 00       	call   8019f4 <sys_cputs>
  800749:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80074c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800753:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800759:	c9                   	leave  
  80075a:	c3                   	ret    

0080075b <cprintf>:

int cprintf(const char *fmt, ...) {
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800761:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800768:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 f4             	pushl  -0xc(%ebp)
  800777:	50                   	push   %eax
  800778:	e8 73 ff ff ff       	call   8006f0 <vcprintf>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800783:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80078e:	e8 0f 14 00 00       	call   801ba2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800793:	8d 45 0c             	lea    0xc(%ebp),%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a2:	50                   	push   %eax
  8007a3:	e8 48 ff ff ff       	call   8006f0 <vcprintf>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007ae:	e8 09 14 00 00       	call   801bbc <sys_enable_interrupt>
	return cnt;
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	53                   	push   %ebx
  8007bc:	83 ec 14             	sub    $0x14,%esp
  8007bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d6:	77 55                	ja     80082d <printnum+0x75>
  8007d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007db:	72 05                	jb     8007e2 <printnum+0x2a>
  8007dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007e0:	77 4b                	ja     80082d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8007eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f0:	52                   	push   %edx
  8007f1:	50                   	push   %eax
  8007f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8007f8:	e8 67 2a 00 00       	call   803264 <__udivdi3>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	ff 75 20             	pushl  0x20(%ebp)
  800806:	53                   	push   %ebx
  800807:	ff 75 18             	pushl  0x18(%ebp)
  80080a:	52                   	push   %edx
  80080b:	50                   	push   %eax
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	ff 75 08             	pushl  0x8(%ebp)
  800812:	e8 a1 ff ff ff       	call   8007b8 <printnum>
  800817:	83 c4 20             	add    $0x20,%esp
  80081a:	eb 1a                	jmp    800836 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	ff 75 20             	pushl  0x20(%ebp)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80082d:	ff 4d 1c             	decl   0x1c(%ebp)
  800830:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800834:	7f e6                	jg     80081c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800836:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800839:	bb 00 00 00 00       	mov    $0x0,%ebx
  80083e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800844:	53                   	push   %ebx
  800845:	51                   	push   %ecx
  800846:	52                   	push   %edx
  800847:	50                   	push   %eax
  800848:	e8 27 2b 00 00       	call   803374 <__umoddi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	05 54 3b 80 00       	add    $0x803b54,%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be c0             	movsbl %al,%eax
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	50                   	push   %eax
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
}
  800869:	90                   	nop
  80086a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086d:	c9                   	leave  
  80086e:	c3                   	ret    

0080086f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800872:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800876:	7e 1c                	jle    800894 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	8d 50 08             	lea    0x8(%eax),%edx
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	89 10                	mov    %edx,(%eax)
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	83 e8 08             	sub    $0x8,%eax
  80088d:	8b 50 04             	mov    0x4(%eax),%edx
  800890:	8b 00                	mov    (%eax),%eax
  800892:	eb 40                	jmp    8008d4 <getuint+0x65>
	else if (lflag)
  800894:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800898:	74 1e                	je     8008b8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b6:	eb 1c                	jmp    8008d4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	8d 50 04             	lea    0x4(%eax),%edx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	89 10                	mov    %edx,(%eax)
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	83 e8 04             	sub    $0x4,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008dd:	7e 1c                	jle    8008fb <getint+0x25>
		return va_arg(*ap, long long);
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	8d 50 08             	lea    0x8(%eax),%edx
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	89 10                	mov    %edx,(%eax)
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	83 e8 08             	sub    $0x8,%eax
  8008f4:	8b 50 04             	mov    0x4(%eax),%edx
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	eb 38                	jmp    800933 <getint+0x5d>
	else if (lflag)
  8008fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ff:	74 1a                	je     80091b <getint+0x45>
		return va_arg(*ap, long);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	8d 50 04             	lea    0x4(%eax),%edx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 10                	mov    %edx,(%eax)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	83 e8 04             	sub    $0x4,%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	99                   	cltd   
  800919:	eb 18                	jmp    800933 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 04             	lea    0x4(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 04             	sub    $0x4,%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	99                   	cltd   
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093d:	eb 17                	jmp    800956 <vprintfmt+0x21>
			if (ch == '\0')
  80093f:	85 db                	test   %ebx,%ebx
  800941:	0f 84 af 03 00 00    	je     800cf6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800956:	8b 45 10             	mov    0x10(%ebp),%eax
  800959:	8d 50 01             	lea    0x1(%eax),%edx
  80095c:	89 55 10             	mov    %edx,0x10(%ebp)
  80095f:	8a 00                	mov    (%eax),%al
  800961:	0f b6 d8             	movzbl %al,%ebx
  800964:	83 fb 25             	cmp    $0x25,%ebx
  800967:	75 d6                	jne    80093f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800969:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80096d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800974:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80097b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800982:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800989:	8b 45 10             	mov    0x10(%ebp),%eax
  80098c:	8d 50 01             	lea    0x1(%eax),%edx
  80098f:	89 55 10             	mov    %edx,0x10(%ebp)
  800992:	8a 00                	mov    (%eax),%al
  800994:	0f b6 d8             	movzbl %al,%ebx
  800997:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80099a:	83 f8 55             	cmp    $0x55,%eax
  80099d:	0f 87 2b 03 00 00    	ja     800cce <vprintfmt+0x399>
  8009a3:	8b 04 85 78 3b 80 00 	mov    0x803b78(,%eax,4),%eax
  8009aa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009b0:	eb d7                	jmp    800989 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009b6:	eb d1                	jmp    800989 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	c1 e0 02             	shl    $0x2,%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	01 c0                	add    %eax,%eax
  8009cb:	01 d8                	add    %ebx,%eax
  8009cd:	83 e8 30             	sub    $0x30,%eax
  8009d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d6:	8a 00                	mov    (%eax),%al
  8009d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009db:	83 fb 2f             	cmp    $0x2f,%ebx
  8009de:	7e 3e                	jle    800a1e <vprintfmt+0xe9>
  8009e0:	83 fb 39             	cmp    $0x39,%ebx
  8009e3:	7f 39                	jg     800a1e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e8:	eb d5                	jmp    8009bf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	83 c0 04             	add    $0x4,%eax
  8009f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	83 e8 04             	sub    $0x4,%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009fe:	eb 1f                	jmp    800a1f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a04:	79 83                	jns    800989 <vprintfmt+0x54>
				width = 0;
  800a06:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a0d:	e9 77 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a12:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a19:	e9 6b ff ff ff       	jmp    800989 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a1e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a23:	0f 89 60 ff ff ff    	jns    800989 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a36:	e9 4e ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a3b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a3e:	e9 46 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 c0 04             	add    $0x4,%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	83 e8 04             	sub    $0x4,%eax
  800a52:	8b 00                	mov    (%eax),%eax
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			break;
  800a63:	e9 89 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a68:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6b:	83 c0 04             	add    $0x4,%eax
  800a6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 e8 04             	sub    $0x4,%eax
  800a77:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a79:	85 db                	test   %ebx,%ebx
  800a7b:	79 02                	jns    800a7f <vprintfmt+0x14a>
				err = -err;
  800a7d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a7f:	83 fb 64             	cmp    $0x64,%ebx
  800a82:	7f 0b                	jg     800a8f <vprintfmt+0x15a>
  800a84:	8b 34 9d c0 39 80 00 	mov    0x8039c0(,%ebx,4),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 19                	jne    800aa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	53                   	push   %ebx
  800a90:	68 65 3b 80 00       	push   $0x803b65
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	ff 75 08             	pushl  0x8(%ebp)
  800a9b:	e8 5e 02 00 00       	call   800cfe <printfmt>
  800aa0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa3:	e9 49 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa8:	56                   	push   %esi
  800aa9:	68 6e 3b 80 00       	push   $0x803b6e
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 45 02 00 00       	call   800cfe <printfmt>
  800ab9:	83 c4 10             	add    $0x10,%esp
			break;
  800abc:	e9 30 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ac1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac4:	83 c0 04             	add    $0x4,%eax
  800ac7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aca:	8b 45 14             	mov    0x14(%ebp),%eax
  800acd:	83 e8 04             	sub    $0x4,%eax
  800ad0:	8b 30                	mov    (%eax),%esi
  800ad2:	85 f6                	test   %esi,%esi
  800ad4:	75 05                	jne    800adb <vprintfmt+0x1a6>
				p = "(null)";
  800ad6:	be 71 3b 80 00       	mov    $0x803b71,%esi
			if (width > 0 && padc != '-')
  800adb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adf:	7e 6d                	jle    800b4e <vprintfmt+0x219>
  800ae1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ae5:	74 67                	je     800b4e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	50                   	push   %eax
  800aee:	56                   	push   %esi
  800aef:	e8 0c 03 00 00       	call   800e00 <strnlen>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800afa:	eb 16                	jmp    800b12 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800afc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	50                   	push   %eax
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b16:	7f e4                	jg     800afc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b18:	eb 34                	jmp    800b4e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b1e:	74 1c                	je     800b3c <vprintfmt+0x207>
  800b20:	83 fb 1f             	cmp    $0x1f,%ebx
  800b23:	7e 05                	jle    800b2a <vprintfmt+0x1f5>
  800b25:	83 fb 7e             	cmp    $0x7e,%ebx
  800b28:	7e 12                	jle    800b3c <vprintfmt+0x207>
					putch('?', putdat);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	6a 3f                	push   $0x3f
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	eb 0f                	jmp    800b4b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4e:	89 f0                	mov    %esi,%eax
  800b50:	8d 70 01             	lea    0x1(%eax),%esi
  800b53:	8a 00                	mov    (%eax),%al
  800b55:	0f be d8             	movsbl %al,%ebx
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	74 24                	je     800b80 <vprintfmt+0x24b>
  800b5c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b60:	78 b8                	js     800b1a <vprintfmt+0x1e5>
  800b62:	ff 4d e0             	decl   -0x20(%ebp)
  800b65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b69:	79 af                	jns    800b1a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6b:	eb 13                	jmp    800b80 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 20                	push   $0x20
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b84:	7f e7                	jg     800b6d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b86:	e9 66 01 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	ff 75 e8             	pushl  -0x18(%ebp)
  800b91:	8d 45 14             	lea    0x14(%ebp),%eax
  800b94:	50                   	push   %eax
  800b95:	e8 3c fd ff ff       	call   8008d6 <getint>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba9:	85 d2                	test   %edx,%edx
  800bab:	79 23                	jns    800bd0 <vprintfmt+0x29b>
				putch('-', putdat);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	6a 2d                	push   $0x2d
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff d0                	call   *%eax
  800bba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	f7 d8                	neg    %eax
  800bc5:	83 d2 00             	adc    $0x0,%edx
  800bc8:	f7 da                	neg    %edx
  800bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bd0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd7:	e9 bc 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 e8             	pushl  -0x18(%ebp)
  800be2:	8d 45 14             	lea    0x14(%ebp),%eax
  800be5:	50                   	push   %eax
  800be6:	e8 84 fc ff ff       	call   80086f <getuint>
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bf4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bfb:	e9 98 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	6a 58                	push   $0x58
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	ff d0                	call   *%eax
  800c0d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 58                	push   $0x58
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 58                	push   $0x58
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			break;
  800c30:	e9 bc 00 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	6a 30                	push   $0x30
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	ff d0                	call   *%eax
  800c42:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	6a 78                	push   $0x78
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	ff d0                	call   *%eax
  800c52:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 e8 04             	sub    $0x4,%eax
  800c64:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c70:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c77:	eb 1f                	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c79:	83 ec 08             	sub    $0x8,%esp
  800c7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c82:	50                   	push   %eax
  800c83:	e8 e7 fb ff ff       	call   80086f <getuint>
  800c88:	83 c4 10             	add    $0x10,%esp
  800c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c91:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c98:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	83 ec 04             	sub    $0x4,%esp
  800ca2:	52                   	push   %edx
  800ca3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ca6:	50                   	push   %eax
  800ca7:	ff 75 f4             	pushl  -0xc(%ebp)
  800caa:	ff 75 f0             	pushl  -0x10(%ebp)
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	ff 75 08             	pushl  0x8(%ebp)
  800cb3:	e8 00 fb ff ff       	call   8007b8 <printnum>
  800cb8:	83 c4 20             	add    $0x20,%esp
			break;
  800cbb:	eb 34                	jmp    800cf1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cbd:	83 ec 08             	sub    $0x8,%esp
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	53                   	push   %ebx
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	ff d0                	call   *%eax
  800cc9:	83 c4 10             	add    $0x10,%esp
			break;
  800ccc:	eb 23                	jmp    800cf1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	6a 25                	push   $0x25
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cde:	ff 4d 10             	decl   0x10(%ebp)
  800ce1:	eb 03                	jmp    800ce6 <vprintfmt+0x3b1>
  800ce3:	ff 4d 10             	decl   0x10(%ebp)
  800ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce9:	48                   	dec    %eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 25                	cmp    $0x25,%al
  800cee:	75 f3                	jne    800ce3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cf0:	90                   	nop
		}
	}
  800cf1:	e9 47 fc ff ff       	jmp    80093d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cf6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 16 fc ff ff       	call   800935 <vprintfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d22:	90                   	nop
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 40 08             	mov    0x8(%eax),%eax
  800d2e:	8d 50 01             	lea    0x1(%eax),%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	8b 10                	mov    (%eax),%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 04             	mov    0x4(%eax),%eax
  800d42:	39 c2                	cmp    %eax,%edx
  800d44:	73 12                	jae    800d58 <sprintputch+0x33>
		*b->buf++ = ch;
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	8d 48 01             	lea    0x1(%eax),%ecx
  800d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d51:	89 0a                	mov    %ecx,(%edx)
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	88 10                	mov    %dl,(%eax)
}
  800d58:	90                   	nop
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	01 d0                	add    %edx,%eax
  800d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d80:	74 06                	je     800d88 <vsnprintf+0x2d>
  800d82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d86:	7f 07                	jg     800d8f <vsnprintf+0x34>
		return -E_INVAL;
  800d88:	b8 03 00 00 00       	mov    $0x3,%eax
  800d8d:	eb 20                	jmp    800daf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d8f:	ff 75 14             	pushl  0x14(%ebp)
  800d92:	ff 75 10             	pushl  0x10(%ebp)
  800d95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d98:	50                   	push   %eax
  800d99:	68 25 0d 80 00       	push   $0x800d25
  800d9e:	e8 92 fb ff ff       	call   800935 <vprintfmt>
  800da3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    

00800db1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800db7:	8d 45 10             	lea    0x10(%ebp),%eax
  800dba:	83 c0 04             	add    $0x4,%eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc6:	50                   	push   %eax
  800dc7:	ff 75 0c             	pushl  0xc(%ebp)
  800dca:	ff 75 08             	pushl  0x8(%ebp)
  800dcd:	e8 89 ff ff ff       	call   800d5b <vsnprintf>
  800dd2:	83 c4 10             	add    $0x10,%esp
  800dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800de3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dea:	eb 06                	jmp    800df2 <strlen+0x15>
		n++;
  800dec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800def:	ff 45 08             	incl   0x8(%ebp)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	84 c0                	test   %al,%al
  800df9:	75 f1                	jne    800dec <strlen+0xf>
		n++;
	return n;
  800dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e0d:	eb 09                	jmp    800e18 <strnlen+0x18>
		n++;
  800e0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 4d 0c             	decl   0xc(%ebp)
  800e18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1c:	74 09                	je     800e27 <strnlen+0x27>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	75 e8                	jne    800e0f <strnlen+0xf>
		n++;
	return n;
  800e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e38:	90                   	nop
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	84 c0                	test   %al,%al
  800e53:	75 e4                	jne    800e39 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6d:	eb 1f                	jmp    800e8e <strncpy+0x34>
		*dst++ = *src;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8d 50 01             	lea    0x1(%eax),%edx
  800e75:	89 55 08             	mov    %edx,0x8(%ebp)
  800e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7b:	8a 12                	mov    (%edx),%dl
  800e7d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	84 c0                	test   %al,%al
  800e86:	74 03                	je     800e8b <strncpy+0x31>
			src++;
  800e88:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e8b:	ff 45 fc             	incl   -0x4(%ebp)
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e91:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e94:	72 d9                	jb     800e6f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	74 30                	je     800edd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ead:	eb 16                	jmp    800ec5 <strlcpy+0x2a>
			*dst++ = *src++;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8d 50 01             	lea    0x1(%eax),%edx
  800eb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ebe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec1:	8a 12                	mov    (%edx),%dl
  800ec3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ec5:	ff 4d 10             	decl   0x10(%ebp)
  800ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecc:	74 09                	je     800ed7 <strlcpy+0x3c>
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 d8                	jne    800eaf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	29 c2                	sub    %eax,%edx
  800ee5:	89 d0                	mov    %edx,%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eec:	eb 06                	jmp    800ef4 <strcmp+0xb>
		p++, q++;
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	84 c0                	test   %al,%al
  800efb:	74 0e                	je     800f0b <strcmp+0x22>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 10                	mov    (%eax),%dl
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	38 c2                	cmp    %al,%dl
  800f09:	74 e3                	je     800eee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	0f b6 d0             	movzbl %al,%edx
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	0f b6 c0             	movzbl %al,%eax
  800f1b:	29 c2                	sub    %eax,%edx
  800f1d:	89 d0                	mov    %edx,%eax
}
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    

00800f21 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f24:	eb 09                	jmp    800f2f <strncmp+0xe>
		n--, p++, q++;
  800f26:	ff 4d 10             	decl   0x10(%ebp)
  800f29:	ff 45 08             	incl   0x8(%ebp)
  800f2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f33:	74 17                	je     800f4c <strncmp+0x2b>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	74 0e                	je     800f4c <strncmp+0x2b>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 10                	mov    (%eax),%dl
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	38 c2                	cmp    %al,%dl
  800f4a:	74 da                	je     800f26 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	75 07                	jne    800f59 <strncmp+0x38>
		return 0;
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
  800f57:	eb 14                	jmp    800f6d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f b6 d0             	movzbl %al,%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 c0             	movzbl %al,%eax
  800f69:	29 c2                	sub    %eax,%edx
  800f6b:	89 d0                	mov    %edx,%eax
}
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 04             	sub    $0x4,%esp
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f7b:	eb 12                	jmp    800f8f <strchr+0x20>
		if (*s == c)
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f85:	75 05                	jne    800f8c <strchr+0x1d>
			return (char *) s;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	eb 11                	jmp    800f9d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f8c:	ff 45 08             	incl   0x8(%ebp)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	84 c0                	test   %al,%al
  800f96:	75 e5                	jne    800f7d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    

00800f9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	83 ec 04             	sub    $0x4,%esp
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fab:	eb 0d                	jmp    800fba <strfind+0x1b>
		if (*s == c)
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb5:	74 0e                	je     800fc5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 ea                	jne    800fad <strfind+0xe>
  800fc3:	eb 01                	jmp    800fc6 <strfind+0x27>
		if (*s == c)
			break;
  800fc5:	90                   	nop
	return (char *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fdd:	eb 0e                	jmp    800fed <memset+0x22>
		*p++ = c;
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	8d 50 01             	lea    0x1(%eax),%edx
  800fe5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800feb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fed:	ff 4d f8             	decl   -0x8(%ebp)
  800ff0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ff4:	79 e9                	jns    800fdf <memset+0x14>
		*p++ = c;

	return v;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80100d:	eb 16                	jmp    801025 <memcpy+0x2a>
		*d++ = *s++;
  80100f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801012:	8d 50 01             	lea    0x1(%eax),%edx
  801015:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801018:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80101e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801021:	8a 12                	mov    (%edx),%dl
  801023:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102b:	89 55 10             	mov    %edx,0x10(%ebp)
  80102e:	85 c0                	test   %eax,%eax
  801030:	75 dd                	jne    80100f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104f:	73 50                	jae    8010a1 <memmove+0x6a>
  801051:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	01 d0                	add    %edx,%eax
  801059:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80105c:	76 43                	jbe    8010a1 <memmove+0x6a>
		s += n;
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80106a:	eb 10                	jmp    80107c <memmove+0x45>
			*--d = *--s;
  80106c:	ff 4d f8             	decl   -0x8(%ebp)
  80106f:	ff 4d fc             	decl   -0x4(%ebp)
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	8a 10                	mov    (%eax),%dl
  801077:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	89 55 10             	mov    %edx,0x10(%ebp)
  801085:	85 c0                	test   %eax,%eax
  801087:	75 e3                	jne    80106c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801089:	eb 23                	jmp    8010ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	8d 50 01             	lea    0x1(%eax),%edx
  801091:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801094:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801097:	8d 4a 01             	lea    0x1(%edx),%ecx
  80109a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80109d:	8a 12                	mov    (%edx),%dl
  80109f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	75 dd                	jne    80108b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010c5:	eb 2a                	jmp    8010f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 10                	mov    (%eax),%dl
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	38 c2                	cmp    %al,%dl
  8010d3:	74 16                	je     8010eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	0f b6 d0             	movzbl %al,%edx
  8010dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	0f b6 c0             	movzbl %al,%eax
  8010e5:	29 c2                	sub    %eax,%edx
  8010e7:	89 d0                	mov    %edx,%eax
  8010e9:	eb 18                	jmp    801103 <memcmp+0x50>
		s1++, s2++;
  8010eb:	ff 45 fc             	incl   -0x4(%ebp)
  8010ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 c9                	jne    8010c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801116:	eb 15                	jmp    80112d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	0f b6 d0             	movzbl %al,%edx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	0f b6 c0             	movzbl %al,%eax
  801126:	39 c2                	cmp    %eax,%edx
  801128:	74 0d                	je     801137 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80112a:	ff 45 08             	incl   0x8(%ebp)
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801133:	72 e3                	jb     801118 <memfind+0x13>
  801135:	eb 01                	jmp    801138 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801137:	90                   	nop
	return (void *) s;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80114a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801151:	eb 03                	jmp    801156 <strtol+0x19>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	3c 20                	cmp    $0x20,%al
  80115d:	74 f4                	je     801153 <strtol+0x16>
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 09                	cmp    $0x9,%al
  801166:	74 eb                	je     801153 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2b                	cmp    $0x2b,%al
  80116f:	75 05                	jne    801176 <strtol+0x39>
		s++;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	eb 13                	jmp    801189 <strtol+0x4c>
	else if (*s == '-')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 2d                	cmp    $0x2d,%al
  80117d:	75 0a                	jne    801189 <strtol+0x4c>
		s++, neg = 1;
  80117f:	ff 45 08             	incl   0x8(%ebp)
  801182:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801189:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118d:	74 06                	je     801195 <strtol+0x58>
  80118f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801193:	75 20                	jne    8011b5 <strtol+0x78>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 30                	cmp    $0x30,%al
  80119c:	75 17                	jne    8011b5 <strtol+0x78>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	40                   	inc    %eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 78                	cmp    $0x78,%al
  8011a6:	75 0d                	jne    8011b5 <strtol+0x78>
		s += 2, base = 16;
  8011a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011b3:	eb 28                	jmp    8011dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b9:	75 15                	jne    8011d0 <strtol+0x93>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	3c 30                	cmp    $0x30,%al
  8011c2:	75 0c                	jne    8011d0 <strtol+0x93>
		s++, base = 8;
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011ce:	eb 0d                	jmp    8011dd <strtol+0xa0>
	else if (base == 0)
  8011d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d4:	75 07                	jne    8011dd <strtol+0xa0>
		base = 10;
  8011d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 2f                	cmp    $0x2f,%al
  8011e4:	7e 19                	jle    8011ff <strtol+0xc2>
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 39                	cmp    $0x39,%al
  8011ed:	7f 10                	jg     8011ff <strtol+0xc2>
			dig = *s - '0';
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	0f be c0             	movsbl %al,%eax
  8011f7:	83 e8 30             	sub    $0x30,%eax
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011fd:	eb 42                	jmp    801241 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 60                	cmp    $0x60,%al
  801206:	7e 19                	jle    801221 <strtol+0xe4>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 7a                	cmp    $0x7a,%al
  80120f:	7f 10                	jg     801221 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	83 e8 57             	sub    $0x57,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121f:	eb 20                	jmp    801241 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 40                	cmp    $0x40,%al
  801228:	7e 39                	jle    801263 <strtol+0x126>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 5a                	cmp    $0x5a,%al
  801231:	7f 30                	jg     801263 <strtol+0x126>
			dig = *s - 'A' + 10;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	83 e8 37             	sub    $0x37,%eax
  80123e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801244:	3b 45 10             	cmp    0x10(%ebp),%eax
  801247:	7d 19                	jge    801262 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801249:	ff 45 08             	incl   0x8(%ebp)
  80124c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80125d:	e9 7b ff ff ff       	jmp    8011dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801262:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801263:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801267:	74 08                	je     801271 <strtol+0x134>
		*endptr = (char *) s;
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	8b 55 08             	mov    0x8(%ebp),%edx
  80126f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801271:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801275:	74 07                	je     80127e <strtol+0x141>
  801277:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127a:	f7 d8                	neg    %eax
  80127c:	eb 03                	jmp    801281 <strtol+0x144>
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <ltostr>:

void
ltostr(long value, char *str)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801290:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80129b:	79 13                	jns    8012b0 <ltostr+0x2d>
	{
		neg = 1;
  80129d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b8:	99                   	cltd   
  8012b9:	f7 f9                	idiv   %ecx
  8012bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c7:	89 c2                	mov    %eax,%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d1:	83 c2 30             	add    $0x30,%edx
  8012d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012de:	f7 e9                	imul   %ecx
  8012e0:	c1 fa 02             	sar    $0x2,%edx
  8012e3:	89 c8                	mov    %ecx,%eax
  8012e5:	c1 f8 1f             	sar    $0x1f,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
  8012ec:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f7:	f7 e9                	imul   %ecx
  8012f9:	c1 fa 02             	sar    $0x2,%edx
  8012fc:	89 c8                	mov    %ecx,%eax
  8012fe:	c1 f8 1f             	sar    $0x1f,%eax
  801301:	29 c2                	sub    %eax,%edx
  801303:	89 d0                	mov    %edx,%eax
  801305:	c1 e0 02             	shl    $0x2,%eax
  801308:	01 d0                	add    %edx,%eax
  80130a:	01 c0                	add    %eax,%eax
  80130c:	29 c1                	sub    %eax,%ecx
  80130e:	89 ca                	mov    %ecx,%edx
  801310:	85 d2                	test   %edx,%edx
  801312:	75 9c                	jne    8012b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131e:	48                   	dec    %eax
  80131f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801322:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801326:	74 3d                	je     801365 <ltostr+0xe2>
		start = 1 ;
  801328:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80132f:	eb 34                	jmp    801365 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80133e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	01 c2                	add    %eax,%edx
  801346:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	01 c8                	add    %ecx,%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80135d:	88 02                	mov    %al,(%edx)
		start++ ;
  80135f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801362:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801368:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136b:	7c c4                	jl     801331 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80136d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 d0                	add    %edx,%eax
  801375:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801378:	90                   	nop
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	e8 54 fa ff ff       	call   800ddd <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	e8 46 fa ff ff       	call   800ddd <strlen>
  801397:	83 c4 04             	add    $0x4,%esp
  80139a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80139d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ab:	eb 17                	jmp    8013c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	01 c2                	add    %eax,%edx
  8013b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	01 c8                	add    %ecx,%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013c1:	ff 45 fc             	incl   -0x4(%ebp)
  8013c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ca:	7c e1                	jl     8013ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013da:	eb 1f                	jmp    8013fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8d 50 01             	lea    0x1(%eax),%edx
  8013e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e5:	89 c2                	mov    %eax,%edx
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	01 c2                	add    %eax,%edx
  8013ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	01 c8                	add    %ecx,%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013f8:	ff 45 f8             	incl   -0x8(%ebp)
  8013fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801401:	7c d9                	jl     8013dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801403:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	01 d0                	add    %edx,%eax
  80140b:	c6 00 00             	movb   $0x0,(%eax)
}
  80140e:	90                   	nop
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80141d:	8b 45 14             	mov    0x14(%ebp),%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801429:	8b 45 10             	mov    0x10(%ebp),%eax
  80142c:	01 d0                	add    %edx,%eax
  80142e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	eb 0c                	jmp    801442 <strsplit+0x31>
			*string++ = 0;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8d 50 01             	lea    0x1(%eax),%edx
  80143c:	89 55 08             	mov    %edx,0x8(%ebp)
  80143f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	84 c0                	test   %al,%al
  801449:	74 18                	je     801463 <strsplit+0x52>
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	50                   	push   %eax
  801454:	ff 75 0c             	pushl  0xc(%ebp)
  801457:	e8 13 fb ff ff       	call   800f6f <strchr>
  80145c:	83 c4 08             	add    $0x8,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	75 d3                	jne    801436 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	84 c0                	test   %al,%al
  80146a:	74 5a                	je     8014c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80146c:	8b 45 14             	mov    0x14(%ebp),%eax
  80146f:	8b 00                	mov    (%eax),%eax
  801471:	83 f8 0f             	cmp    $0xf,%eax
  801474:	75 07                	jne    80147d <strsplit+0x6c>
		{
			return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	eb 66                	jmp    8014e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80147d:	8b 45 14             	mov    0x14(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	8d 48 01             	lea    0x1(%eax),%ecx
  801485:	8b 55 14             	mov    0x14(%ebp),%edx
  801488:	89 0a                	mov    %ecx,(%edx)
  80148a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	01 c2                	add    %eax,%edx
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149b:	eb 03                	jmp    8014a0 <strsplit+0x8f>
			string++;
  80149d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	84 c0                	test   %al,%al
  8014a7:	74 8b                	je     801434 <strsplit+0x23>
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	0f be c0             	movsbl %al,%eax
  8014b1:	50                   	push   %eax
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	e8 b5 fa ff ff       	call   800f6f <strchr>
  8014ba:	83 c4 08             	add    $0x8,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	74 dc                	je     80149d <strsplit+0x8c>
			string++;
	}
  8014c1:	e9 6e ff ff ff       	jmp    801434 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	01 d0                	add    %edx,%eax
  8014d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014eb:	a1 04 40 80 00       	mov    0x804004,%eax
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	74 1f                	je     801513 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014f4:	e8 1d 00 00 00       	call   801516 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014f9:	83 ec 0c             	sub    $0xc,%esp
  8014fc:	68 d0 3c 80 00       	push   $0x803cd0
  801501:	e8 55 f2 ff ff       	call   80075b <cprintf>
  801506:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801509:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801510:	00 00 00 
	}
}
  801513:	90                   	nop
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80151c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801523:	00 00 00 
  801526:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80152d:	00 00 00 
  801530:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801537:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80153a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801541:	00 00 00 
  801544:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80154b:	00 00 00 
  80154e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801555:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801558:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80155f:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801562:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801571:	2d 00 10 00 00       	sub    $0x1000,%eax
  801576:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80157b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801582:	a1 20 41 80 00       	mov    0x804120,%eax
  801587:	c1 e0 04             	shl    $0x4,%eax
  80158a:	89 c2                	mov    %eax,%edx
  80158c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158f:	01 d0                	add    %edx,%eax
  801591:	48                   	dec    %eax
  801592:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801598:	ba 00 00 00 00       	mov    $0x0,%edx
  80159d:	f7 75 f0             	divl   -0x10(%ebp)
  8015a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a3:	29 d0                	sub    %edx,%eax
  8015a5:	89 c2                	mov    %eax,%edx
  8015a7:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8015ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015b6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	6a 06                	push   $0x6
  8015c0:	52                   	push   %edx
  8015c1:	50                   	push   %eax
  8015c2:	e8 71 05 00 00       	call   801b38 <sys_allocate_chunk>
  8015c7:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015ca:	a1 20 41 80 00       	mov    0x804120,%eax
  8015cf:	83 ec 0c             	sub    $0xc,%esp
  8015d2:	50                   	push   %eax
  8015d3:	e8 e6 0b 00 00       	call   8021be <initialize_MemBlocksList>
  8015d8:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8015db:	a1 48 41 80 00       	mov    0x804148,%eax
  8015e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8015e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015e7:	75 14                	jne    8015fd <initialize_dyn_block_system+0xe7>
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	68 f5 3c 80 00       	push   $0x803cf5
  8015f1:	6a 2b                	push   $0x2b
  8015f3:	68 13 3d 80 00       	push   $0x803d13
  8015f8:	e8 aa ee ff ff       	call   8004a7 <_panic>
  8015fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801600:	8b 00                	mov    (%eax),%eax
  801602:	85 c0                	test   %eax,%eax
  801604:	74 10                	je     801616 <initialize_dyn_block_system+0x100>
  801606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801609:	8b 00                	mov    (%eax),%eax
  80160b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80160e:	8b 52 04             	mov    0x4(%edx),%edx
  801611:	89 50 04             	mov    %edx,0x4(%eax)
  801614:	eb 0b                	jmp    801621 <initialize_dyn_block_system+0x10b>
  801616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801619:	8b 40 04             	mov    0x4(%eax),%eax
  80161c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801624:	8b 40 04             	mov    0x4(%eax),%eax
  801627:	85 c0                	test   %eax,%eax
  801629:	74 0f                	je     80163a <initialize_dyn_block_system+0x124>
  80162b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80162e:	8b 40 04             	mov    0x4(%eax),%eax
  801631:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801634:	8b 12                	mov    (%edx),%edx
  801636:	89 10                	mov    %edx,(%eax)
  801638:	eb 0a                	jmp    801644 <initialize_dyn_block_system+0x12e>
  80163a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80163d:	8b 00                	mov    (%eax),%eax
  80163f:	a3 48 41 80 00       	mov    %eax,0x804148
  801644:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801647:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80164d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801650:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801657:	a1 54 41 80 00       	mov    0x804154,%eax
  80165c:	48                   	dec    %eax
  80165d:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801665:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80166c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80166f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801676:	83 ec 0c             	sub    $0xc,%esp
  801679:	ff 75 e4             	pushl  -0x1c(%ebp)
  80167c:	e8 d2 13 00 00       	call   802a53 <insert_sorted_with_merge_freeList>
  801681:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801684:	90                   	nop
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80168d:	e8 53 fe ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801692:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801696:	75 07                	jne    80169f <malloc+0x18>
  801698:	b8 00 00 00 00       	mov    $0x0,%eax
  80169d:	eb 61                	jmp    801700 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  80169f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ac:	01 d0                	add    %edx,%eax
  8016ae:	48                   	dec    %eax
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ba:	f7 75 f4             	divl   -0xc(%ebp)
  8016bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c0:	29 d0                	sub    %edx,%eax
  8016c2:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016c5:	e8 3c 08 00 00       	call   801f06 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	74 2d                	je     8016fb <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8016ce:	83 ec 0c             	sub    $0xc,%esp
  8016d1:	ff 75 08             	pushl  0x8(%ebp)
  8016d4:	e8 3e 0f 00 00       	call   802617 <alloc_block_FF>
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8016df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e3:	74 16                	je     8016fb <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8016e5:	83 ec 0c             	sub    $0xc,%esp
  8016e8:	ff 75 ec             	pushl  -0x14(%ebp)
  8016eb:	e8 48 0c 00 00       	call   802338 <insert_sorted_allocList>
  8016f0:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8016f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f6:	8b 40 08             	mov    0x8(%eax),%eax
  8016f9:	eb 05                	jmp    801700 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80170e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801711:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801716:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	50                   	push   %eax
  801720:	68 40 40 80 00       	push   $0x804040
  801725:	e8 71 0b 00 00       	call   80229b <find_block>
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801733:	8b 50 0c             	mov    0xc(%eax),%edx
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	83 ec 08             	sub    $0x8,%esp
  80173c:	52                   	push   %edx
  80173d:	50                   	push   %eax
  80173e:	e8 bd 03 00 00       	call   801b00 <sys_free_user_mem>
  801743:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801746:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80174a:	75 14                	jne    801760 <free+0x5e>
  80174c:	83 ec 04             	sub    $0x4,%esp
  80174f:	68 f5 3c 80 00       	push   $0x803cf5
  801754:	6a 71                	push   $0x71
  801756:	68 13 3d 80 00       	push   $0x803d13
  80175b:	e8 47 ed ff ff       	call   8004a7 <_panic>
  801760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801763:	8b 00                	mov    (%eax),%eax
  801765:	85 c0                	test   %eax,%eax
  801767:	74 10                	je     801779 <free+0x77>
  801769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176c:	8b 00                	mov    (%eax),%eax
  80176e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801771:	8b 52 04             	mov    0x4(%edx),%edx
  801774:	89 50 04             	mov    %edx,0x4(%eax)
  801777:	eb 0b                	jmp    801784 <free+0x82>
  801779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177c:	8b 40 04             	mov    0x4(%eax),%eax
  80177f:	a3 44 40 80 00       	mov    %eax,0x804044
  801784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801787:	8b 40 04             	mov    0x4(%eax),%eax
  80178a:	85 c0                	test   %eax,%eax
  80178c:	74 0f                	je     80179d <free+0x9b>
  80178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801791:	8b 40 04             	mov    0x4(%eax),%eax
  801794:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801797:	8b 12                	mov    (%edx),%edx
  801799:	89 10                	mov    %edx,(%eax)
  80179b:	eb 0a                	jmp    8017a7 <free+0xa5>
  80179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a0:	8b 00                	mov    (%eax),%eax
  8017a2:	a3 40 40 80 00       	mov    %eax,0x804040
  8017a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017ba:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017bf:	48                   	dec    %eax
  8017c0:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8017c5:	83 ec 0c             	sub    $0xc,%esp
  8017c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8017cb:	e8 83 12 00 00       	call   802a53 <insert_sorted_with_merge_freeList>
  8017d0:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8017d3:	90                   	nop
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 28             	sub    $0x28,%esp
  8017dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017df:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017e2:	e8 fe fc ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017eb:	75 0a                	jne    8017f7 <smalloc+0x21>
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f2:	e9 86 00 00 00       	jmp    80187d <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8017f7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8017fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801804:	01 d0                	add    %edx,%eax
  801806:	48                   	dec    %eax
  801807:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80180a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180d:	ba 00 00 00 00       	mov    $0x0,%edx
  801812:	f7 75 f4             	divl   -0xc(%ebp)
  801815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801818:	29 d0                	sub    %edx,%eax
  80181a:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80181d:	e8 e4 06 00 00       	call   801f06 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801822:	85 c0                	test   %eax,%eax
  801824:	74 52                	je     801878 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801826:	83 ec 0c             	sub    $0xc,%esp
  801829:	ff 75 0c             	pushl  0xc(%ebp)
  80182c:	e8 e6 0d 00 00       	call   802617 <alloc_block_FF>
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801837:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80183b:	75 07                	jne    801844 <smalloc+0x6e>
			return NULL ;
  80183d:	b8 00 00 00 00       	mov    $0x0,%eax
  801842:	eb 39                	jmp    80187d <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801847:	8b 40 08             	mov    0x8(%eax),%eax
  80184a:	89 c2                	mov    %eax,%edx
  80184c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801850:	52                   	push   %edx
  801851:	50                   	push   %eax
  801852:	ff 75 0c             	pushl  0xc(%ebp)
  801855:	ff 75 08             	pushl  0x8(%ebp)
  801858:	e8 2e 04 00 00       	call   801c8b <sys_createSharedObject>
  80185d:	83 c4 10             	add    $0x10,%esp
  801860:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801863:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801867:	79 07                	jns    801870 <smalloc+0x9a>
			return (void*)NULL ;
  801869:	b8 00 00 00 00       	mov    $0x0,%eax
  80186e:	eb 0d                	jmp    80187d <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801870:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801873:	8b 40 08             	mov    0x8(%eax),%eax
  801876:	eb 05                	jmp    80187d <smalloc+0xa7>
		}
		return (void*)NULL ;
  801878:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801885:	e8 5b fc ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80188a:	83 ec 08             	sub    $0x8,%esp
  80188d:	ff 75 0c             	pushl  0xc(%ebp)
  801890:	ff 75 08             	pushl  0x8(%ebp)
  801893:	e8 1d 04 00 00       	call   801cb5 <sys_getSizeOfSharedObject>
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  80189e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018a2:	75 0a                	jne    8018ae <sget+0x2f>
			return NULL ;
  8018a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a9:	e9 83 00 00 00       	jmp    801931 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8018ae:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bb:	01 d0                	add    %edx,%eax
  8018bd:	48                   	dec    %eax
  8018be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c9:	f7 75 f0             	divl   -0x10(%ebp)
  8018cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018cf:	29 d0                	sub    %edx,%eax
  8018d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018d4:	e8 2d 06 00 00       	call   801f06 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	74 4f                	je     80192c <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8018dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e0:	83 ec 0c             	sub    $0xc,%esp
  8018e3:	50                   	push   %eax
  8018e4:	e8 2e 0d 00 00       	call   802617 <alloc_block_FF>
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8018ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018f3:	75 07                	jne    8018fc <sget+0x7d>
					return (void*)NULL ;
  8018f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fa:	eb 35                	jmp    801931 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8018fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ff:	8b 40 08             	mov    0x8(%eax),%eax
  801902:	83 ec 04             	sub    $0x4,%esp
  801905:	50                   	push   %eax
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	ff 75 08             	pushl  0x8(%ebp)
  80190c:	e8 c1 03 00 00       	call   801cd2 <sys_getSharedObject>
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801917:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80191b:	79 07                	jns    801924 <sget+0xa5>
				return (void*)NULL ;
  80191d:	b8 00 00 00 00       	mov    $0x0,%eax
  801922:	eb 0d                	jmp    801931 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801924:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801927:	8b 40 08             	mov    0x8(%eax),%eax
  80192a:	eb 05                	jmp    801931 <sget+0xb2>


		}
	return (void*)NULL ;
  80192c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801939:	e8 a7 fb ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	68 20 3d 80 00       	push   $0x803d20
  801946:	68 f9 00 00 00       	push   $0xf9
  80194b:	68 13 3d 80 00       	push   $0x803d13
  801950:	e8 52 eb ff ff       	call   8004a7 <_panic>

00801955 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80195b:	83 ec 04             	sub    $0x4,%esp
  80195e:	68 48 3d 80 00       	push   $0x803d48
  801963:	68 0d 01 00 00       	push   $0x10d
  801968:	68 13 3d 80 00       	push   $0x803d13
  80196d:	e8 35 eb ff ff       	call   8004a7 <_panic>

00801972 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801978:	83 ec 04             	sub    $0x4,%esp
  80197b:	68 6c 3d 80 00       	push   $0x803d6c
  801980:	68 18 01 00 00       	push   $0x118
  801985:	68 13 3d 80 00       	push   $0x803d13
  80198a:	e8 18 eb ff ff       	call   8004a7 <_panic>

0080198f <shrink>:

}
void shrink(uint32 newSize)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	68 6c 3d 80 00       	push   $0x803d6c
  80199d:	68 1d 01 00 00       	push   $0x11d
  8019a2:	68 13 3d 80 00       	push   $0x803d13
  8019a7:	e8 fb ea ff ff       	call   8004a7 <_panic>

008019ac <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019b2:	83 ec 04             	sub    $0x4,%esp
  8019b5:	68 6c 3d 80 00       	push   $0x803d6c
  8019ba:	68 22 01 00 00       	push   $0x122
  8019bf:	68 13 3d 80 00       	push   $0x803d13
  8019c4:	e8 de ea ff ff       	call   8004a7 <_panic>

008019c9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	57                   	push   %edi
  8019cd:	56                   	push   %esi
  8019ce:	53                   	push   %ebx
  8019cf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019de:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019e1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019e4:	cd 30                	int    $0x30
  8019e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	5b                   	pop    %ebx
  8019f0:	5e                   	pop    %esi
  8019f1:	5f                   	pop    %edi
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    

008019f4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a00:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	52                   	push   %edx
  801a0c:	ff 75 0c             	pushl  0xc(%ebp)
  801a0f:	50                   	push   %eax
  801a10:	6a 00                	push   $0x0
  801a12:	e8 b2 ff ff ff       	call   8019c9 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	90                   	nop
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_cgetc>:

int
sys_cgetc(void)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 01                	push   $0x1
  801a2c:	e8 98 ff ff ff       	call   8019c9 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	52                   	push   %edx
  801a46:	50                   	push   %eax
  801a47:	6a 05                	push   $0x5
  801a49:	e8 7b ff ff ff       	call   8019c9 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	56                   	push   %esi
  801a57:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a58:	8b 75 18             	mov    0x18(%ebp),%esi
  801a5b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	56                   	push   %esi
  801a68:	53                   	push   %ebx
  801a69:	51                   	push   %ecx
  801a6a:	52                   	push   %edx
  801a6b:	50                   	push   %eax
  801a6c:	6a 06                	push   $0x6
  801a6e:	e8 56 ff ff ff       	call   8019c9 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a79:	5b                   	pop    %ebx
  801a7a:	5e                   	pop    %esi
  801a7b:	5d                   	pop    %ebp
  801a7c:	c3                   	ret    

00801a7d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	52                   	push   %edx
  801a8d:	50                   	push   %eax
  801a8e:	6a 07                	push   $0x7
  801a90:	e8 34 ff ff ff       	call   8019c9 <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	ff 75 08             	pushl  0x8(%ebp)
  801aa9:	6a 08                	push   $0x8
  801aab:	e8 19 ff ff ff       	call   8019c9 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 09                	push   $0x9
  801ac4:	e8 00 ff ff ff       	call   8019c9 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 0a                	push   $0xa
  801add:	e8 e7 fe ff ff       	call   8019c9 <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 0b                	push   $0xb
  801af6:	e8 ce fe ff ff       	call   8019c9 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	ff 75 0c             	pushl  0xc(%ebp)
  801b0c:	ff 75 08             	pushl  0x8(%ebp)
  801b0f:	6a 0f                	push   $0xf
  801b11:	e8 b3 fe ff ff       	call   8019c9 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
	return;
  801b19:	90                   	nop
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	ff 75 08             	pushl  0x8(%ebp)
  801b2b:	6a 10                	push   $0x10
  801b2d:	e8 97 fe ff ff       	call   8019c9 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
	return ;
  801b35:	90                   	nop
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	ff 75 10             	pushl  0x10(%ebp)
  801b42:	ff 75 0c             	pushl  0xc(%ebp)
  801b45:	ff 75 08             	pushl  0x8(%ebp)
  801b48:	6a 11                	push   $0x11
  801b4a:	e8 7a fe ff ff       	call   8019c9 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b52:	90                   	nop
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 0c                	push   $0xc
  801b64:	e8 60 fe ff ff       	call   8019c9 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	ff 75 08             	pushl  0x8(%ebp)
  801b7c:	6a 0d                	push   $0xd
  801b7e:	e8 46 fe ff ff       	call   8019c9 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 0e                	push   $0xe
  801b97:	e8 2d fe ff ff       	call   8019c9 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	90                   	nop
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 13                	push   $0x13
  801bb1:	e8 13 fe ff ff       	call   8019c9 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	90                   	nop
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 14                	push   $0x14
  801bcb:	e8 f9 fd ff ff       	call   8019c9 <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	90                   	nop
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_cputc>:


void
sys_cputc(const char c)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801be2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	50                   	push   %eax
  801bef:	6a 15                	push   $0x15
  801bf1:	e8 d3 fd ff ff       	call   8019c9 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 16                	push   $0x16
  801c0b:	e8 b9 fd ff ff       	call   8019c9 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	90                   	nop
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	ff 75 0c             	pushl  0xc(%ebp)
  801c25:	50                   	push   %eax
  801c26:	6a 17                	push   $0x17
  801c28:	e8 9c fd ff ff       	call   8019c9 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	52                   	push   %edx
  801c42:	50                   	push   %eax
  801c43:	6a 1a                	push   $0x1a
  801c45:	e8 7f fd ff ff       	call   8019c9 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	52                   	push   %edx
  801c5f:	50                   	push   %eax
  801c60:	6a 18                	push   $0x18
  801c62:	e8 62 fd ff ff       	call   8019c9 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	90                   	nop
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	52                   	push   %edx
  801c7d:	50                   	push   %eax
  801c7e:	6a 19                	push   $0x19
  801c80:	e8 44 fd ff ff       	call   8019c9 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	90                   	nop
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 04             	sub    $0x4,%esp
  801c91:	8b 45 10             	mov    0x10(%ebp),%eax
  801c94:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c97:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c9a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	6a 00                	push   $0x0
  801ca3:	51                   	push   %ecx
  801ca4:	52                   	push   %edx
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	50                   	push   %eax
  801ca9:	6a 1b                	push   $0x1b
  801cab:	e8 19 fd ff ff       	call   8019c9 <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	52                   	push   %edx
  801cc5:	50                   	push   %eax
  801cc6:	6a 1c                	push   $0x1c
  801cc8:	e8 fc fc ff ff       	call   8019c9 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	51                   	push   %ecx
  801ce3:	52                   	push   %edx
  801ce4:	50                   	push   %eax
  801ce5:	6a 1d                	push   $0x1d
  801ce7:	e8 dd fc ff ff       	call   8019c9 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	6a 1e                	push   $0x1e
  801d04:	e8 c0 fc ff ff       	call   8019c9 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 1f                	push   $0x1f
  801d1d:	e8 a7 fc ff ff       	call   8019c9 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	ff 75 14             	pushl  0x14(%ebp)
  801d32:	ff 75 10             	pushl  0x10(%ebp)
  801d35:	ff 75 0c             	pushl  0xc(%ebp)
  801d38:	50                   	push   %eax
  801d39:	6a 20                	push   $0x20
  801d3b:	e8 89 fc ff ff       	call   8019c9 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	50                   	push   %eax
  801d54:	6a 21                	push   $0x21
  801d56:	e8 6e fc ff ff       	call   8019c9 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
}
  801d5e:	90                   	nop
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	50                   	push   %eax
  801d70:	6a 22                	push   $0x22
  801d72:	e8 52 fc ff ff       	call   8019c9 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 02                	push   $0x2
  801d8b:	e8 39 fc ff ff       	call   8019c9 <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 03                	push   $0x3
  801da4:	e8 20 fc ff ff       	call   8019c9 <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 04                	push   $0x4
  801dbd:	e8 07 fc ff ff       	call   8019c9 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_exit_env>:


void sys_exit_env(void)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 23                	push   $0x23
  801dd6:	e8 ee fb ff ff       	call   8019c9 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	90                   	nop
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801de7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dea:	8d 50 04             	lea    0x4(%eax),%edx
  801ded:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	52                   	push   %edx
  801df7:	50                   	push   %eax
  801df8:	6a 24                	push   $0x24
  801dfa:	e8 ca fb ff ff       	call   8019c9 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
	return result;
  801e02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e08:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e0b:	89 01                	mov    %eax,(%ecx)
  801e0d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	c9                   	leave  
  801e14:	c2 04 00             	ret    $0x4

00801e17 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	ff 75 10             	pushl  0x10(%ebp)
  801e21:	ff 75 0c             	pushl  0xc(%ebp)
  801e24:	ff 75 08             	pushl  0x8(%ebp)
  801e27:	6a 12                	push   $0x12
  801e29:	e8 9b fb ff ff       	call   8019c9 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e31:	90                   	nop
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 25                	push   $0x25
  801e43:	e8 81 fb ff ff       	call   8019c9 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 04             	sub    $0x4,%esp
  801e53:	8b 45 08             	mov    0x8(%ebp),%eax
  801e56:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e59:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	50                   	push   %eax
  801e66:	6a 26                	push   $0x26
  801e68:	e8 5c fb ff ff       	call   8019c9 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e70:	90                   	nop
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <rsttst>:
void rsttst()
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 28                	push   $0x28
  801e82:	e8 42 fb ff ff       	call   8019c9 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8a:	90                   	nop
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	8b 45 14             	mov    0x14(%ebp),%eax
  801e96:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e99:	8b 55 18             	mov    0x18(%ebp),%edx
  801e9c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ea0:	52                   	push   %edx
  801ea1:	50                   	push   %eax
  801ea2:	ff 75 10             	pushl  0x10(%ebp)
  801ea5:	ff 75 0c             	pushl  0xc(%ebp)
  801ea8:	ff 75 08             	pushl  0x8(%ebp)
  801eab:	6a 27                	push   $0x27
  801ead:	e8 17 fb ff ff       	call   8019c9 <syscall>
  801eb2:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb5:	90                   	nop
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <chktst>:
void chktst(uint32 n)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	ff 75 08             	pushl  0x8(%ebp)
  801ec6:	6a 29                	push   $0x29
  801ec8:	e8 fc fa ff ff       	call   8019c9 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed0:	90                   	nop
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <inctst>:

void inctst()
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 2a                	push   $0x2a
  801ee2:	e8 e2 fa ff ff       	call   8019c9 <syscall>
  801ee7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eea:	90                   	nop
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <gettst>:
uint32 gettst()
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 2b                	push   $0x2b
  801efc:	e8 c8 fa ff ff       	call   8019c9 <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 2c                	push   $0x2c
  801f18:	e8 ac fa ff ff       	call   8019c9 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
  801f20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f23:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f27:	75 07                	jne    801f30 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f29:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2e:	eb 05                	jmp    801f35 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 2c                	push   $0x2c
  801f49:	e8 7b fa ff ff       	call   8019c9 <syscall>
  801f4e:	83 c4 18             	add    $0x18,%esp
  801f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f54:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f58:	75 07                	jne    801f61 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5f:	eb 05                	jmp    801f66 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 2c                	push   $0x2c
  801f7a:	e8 4a fa ff ff       	call   8019c9 <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
  801f82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f85:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f89:	75 07                	jne    801f92 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f8b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f90:	eb 05                	jmp    801f97 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 2c                	push   $0x2c
  801fab:	e8 19 fa ff ff       	call   8019c9 <syscall>
  801fb0:	83 c4 18             	add    $0x18,%esp
  801fb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fb6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fba:	75 07                	jne    801fc3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fbc:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc1:	eb 05                	jmp    801fc8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	ff 75 08             	pushl  0x8(%ebp)
  801fd8:	6a 2d                	push   $0x2d
  801fda:	e8 ea f9 ff ff       	call   8019c9 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe2:	90                   	nop
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fe9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	6a 00                	push   $0x0
  801ff7:	53                   	push   %ebx
  801ff8:	51                   	push   %ecx
  801ff9:	52                   	push   %edx
  801ffa:	50                   	push   %eax
  801ffb:	6a 2e                	push   $0x2e
  801ffd:	e8 c7 f9 ff ff       	call   8019c9 <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
}
  802005:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80200d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	52                   	push   %edx
  80201a:	50                   	push   %eax
  80201b:	6a 2f                	push   $0x2f
  80201d:	e8 a7 f9 ff ff       	call   8019c9 <syscall>
  802022:	83 c4 18             	add    $0x18,%esp
}
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80202d:	83 ec 0c             	sub    $0xc,%esp
  802030:	68 7c 3d 80 00       	push   $0x803d7c
  802035:	e8 21 e7 ff ff       	call   80075b <cprintf>
  80203a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80203d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802044:	83 ec 0c             	sub    $0xc,%esp
  802047:	68 a8 3d 80 00       	push   $0x803da8
  80204c:	e8 0a e7 ff ff       	call   80075b <cprintf>
  802051:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802054:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802058:	a1 38 41 80 00       	mov    0x804138,%eax
  80205d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802060:	eb 56                	jmp    8020b8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802062:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802066:	74 1c                	je     802084 <print_mem_block_lists+0x5d>
  802068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206b:	8b 50 08             	mov    0x8(%eax),%edx
  80206e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802071:	8b 48 08             	mov    0x8(%eax),%ecx
  802074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802077:	8b 40 0c             	mov    0xc(%eax),%eax
  80207a:	01 c8                	add    %ecx,%eax
  80207c:	39 c2                	cmp    %eax,%edx
  80207e:	73 04                	jae    802084 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802080:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802087:	8b 50 08             	mov    0x8(%eax),%edx
  80208a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208d:	8b 40 0c             	mov    0xc(%eax),%eax
  802090:	01 c2                	add    %eax,%edx
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	8b 40 08             	mov    0x8(%eax),%eax
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	52                   	push   %edx
  80209c:	50                   	push   %eax
  80209d:	68 bd 3d 80 00       	push   $0x803dbd
  8020a2:	e8 b4 e6 ff ff       	call   80075b <cprintf>
  8020a7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020b0:	a1 40 41 80 00       	mov    0x804140,%eax
  8020b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020bc:	74 07                	je     8020c5 <print_mem_block_lists+0x9e>
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	8b 00                	mov    (%eax),%eax
  8020c3:	eb 05                	jmp    8020ca <print_mem_block_lists+0xa3>
  8020c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ca:	a3 40 41 80 00       	mov    %eax,0x804140
  8020cf:	a1 40 41 80 00       	mov    0x804140,%eax
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	75 8a                	jne    802062 <print_mem_block_lists+0x3b>
  8020d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020dc:	75 84                	jne    802062 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8020de:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020e2:	75 10                	jne    8020f4 <print_mem_block_lists+0xcd>
  8020e4:	83 ec 0c             	sub    $0xc,%esp
  8020e7:	68 cc 3d 80 00       	push   $0x803dcc
  8020ec:	e8 6a e6 ff ff       	call   80075b <cprintf>
  8020f1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020fb:	83 ec 0c             	sub    $0xc,%esp
  8020fe:	68 f0 3d 80 00       	push   $0x803df0
  802103:	e8 53 e6 ff ff       	call   80075b <cprintf>
  802108:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80210b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80210f:	a1 40 40 80 00       	mov    0x804040,%eax
  802114:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802117:	eb 56                	jmp    80216f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802119:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80211d:	74 1c                	je     80213b <print_mem_block_lists+0x114>
  80211f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802122:	8b 50 08             	mov    0x8(%eax),%edx
  802125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802128:	8b 48 08             	mov    0x8(%eax),%ecx
  80212b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212e:	8b 40 0c             	mov    0xc(%eax),%eax
  802131:	01 c8                	add    %ecx,%eax
  802133:	39 c2                	cmp    %eax,%edx
  802135:	73 04                	jae    80213b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802137:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80213b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213e:	8b 50 08             	mov    0x8(%eax),%edx
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	8b 40 0c             	mov    0xc(%eax),%eax
  802147:	01 c2                	add    %eax,%edx
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	8b 40 08             	mov    0x8(%eax),%eax
  80214f:	83 ec 04             	sub    $0x4,%esp
  802152:	52                   	push   %edx
  802153:	50                   	push   %eax
  802154:	68 bd 3d 80 00       	push   $0x803dbd
  802159:	e8 fd e5 ff ff       	call   80075b <cprintf>
  80215e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802164:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802167:	a1 48 40 80 00       	mov    0x804048,%eax
  80216c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802173:	74 07                	je     80217c <print_mem_block_lists+0x155>
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	8b 00                	mov    (%eax),%eax
  80217a:	eb 05                	jmp    802181 <print_mem_block_lists+0x15a>
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
  802181:	a3 48 40 80 00       	mov    %eax,0x804048
  802186:	a1 48 40 80 00       	mov    0x804048,%eax
  80218b:	85 c0                	test   %eax,%eax
  80218d:	75 8a                	jne    802119 <print_mem_block_lists+0xf2>
  80218f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802193:	75 84                	jne    802119 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802195:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802199:	75 10                	jne    8021ab <print_mem_block_lists+0x184>
  80219b:	83 ec 0c             	sub    $0xc,%esp
  80219e:	68 08 3e 80 00       	push   $0x803e08
  8021a3:	e8 b3 e5 ff ff       	call   80075b <cprintf>
  8021a8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021ab:	83 ec 0c             	sub    $0xc,%esp
  8021ae:	68 7c 3d 80 00       	push   $0x803d7c
  8021b3:	e8 a3 e5 ff ff       	call   80075b <cprintf>
  8021b8:	83 c4 10             	add    $0x10,%esp

}
  8021bb:	90                   	nop
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8021c4:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8021cb:	00 00 00 
  8021ce:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8021d5:	00 00 00 
  8021d8:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8021df:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8021e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021e9:	e9 9e 00 00 00       	jmp    80228c <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8021ee:	a1 50 40 80 00       	mov    0x804050,%eax
  8021f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f6:	c1 e2 04             	shl    $0x4,%edx
  8021f9:	01 d0                	add    %edx,%eax
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	75 14                	jne    802213 <initialize_MemBlocksList+0x55>
  8021ff:	83 ec 04             	sub    $0x4,%esp
  802202:	68 30 3e 80 00       	push   $0x803e30
  802207:	6a 43                	push   $0x43
  802209:	68 53 3e 80 00       	push   $0x803e53
  80220e:	e8 94 e2 ff ff       	call   8004a7 <_panic>
  802213:	a1 50 40 80 00       	mov    0x804050,%eax
  802218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221b:	c1 e2 04             	shl    $0x4,%edx
  80221e:	01 d0                	add    %edx,%eax
  802220:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802226:	89 10                	mov    %edx,(%eax)
  802228:	8b 00                	mov    (%eax),%eax
  80222a:	85 c0                	test   %eax,%eax
  80222c:	74 18                	je     802246 <initialize_MemBlocksList+0x88>
  80222e:	a1 48 41 80 00       	mov    0x804148,%eax
  802233:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802239:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80223c:	c1 e1 04             	shl    $0x4,%ecx
  80223f:	01 ca                	add    %ecx,%edx
  802241:	89 50 04             	mov    %edx,0x4(%eax)
  802244:	eb 12                	jmp    802258 <initialize_MemBlocksList+0x9a>
  802246:	a1 50 40 80 00       	mov    0x804050,%eax
  80224b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224e:	c1 e2 04             	shl    $0x4,%edx
  802251:	01 d0                	add    %edx,%eax
  802253:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802258:	a1 50 40 80 00       	mov    0x804050,%eax
  80225d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802260:	c1 e2 04             	shl    $0x4,%edx
  802263:	01 d0                	add    %edx,%eax
  802265:	a3 48 41 80 00       	mov    %eax,0x804148
  80226a:	a1 50 40 80 00       	mov    0x804050,%eax
  80226f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802272:	c1 e2 04             	shl    $0x4,%edx
  802275:	01 d0                	add    %edx,%eax
  802277:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80227e:	a1 54 41 80 00       	mov    0x804154,%eax
  802283:	40                   	inc    %eax
  802284:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802289:	ff 45 f4             	incl   -0xc(%ebp)
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802292:	0f 82 56 ff ff ff    	jb     8021ee <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802298:	90                   	nop
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8022a1:	a1 38 41 80 00       	mov    0x804138,%eax
  8022a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022a9:	eb 18                	jmp    8022c3 <find_block+0x28>
	{
		if (ele->sva==va)
  8022ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ae:	8b 40 08             	mov    0x8(%eax),%eax
  8022b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022b4:	75 05                	jne    8022bb <find_block+0x20>
			return ele;
  8022b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022b9:	eb 7b                	jmp    802336 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8022bb:	a1 40 41 80 00       	mov    0x804140,%eax
  8022c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022c7:	74 07                	je     8022d0 <find_block+0x35>
  8022c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022cc:	8b 00                	mov    (%eax),%eax
  8022ce:	eb 05                	jmp    8022d5 <find_block+0x3a>
  8022d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d5:	a3 40 41 80 00       	mov    %eax,0x804140
  8022da:	a1 40 41 80 00       	mov    0x804140,%eax
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	75 c8                	jne    8022ab <find_block+0x10>
  8022e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022e7:	75 c2                	jne    8022ab <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8022e9:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022f1:	eb 18                	jmp    80230b <find_block+0x70>
	{
		if (ele->sva==va)
  8022f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f6:	8b 40 08             	mov    0x8(%eax),%eax
  8022f9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022fc:	75 05                	jne    802303 <find_block+0x68>
					return ele;
  8022fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802301:	eb 33                	jmp    802336 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802303:	a1 48 40 80 00       	mov    0x804048,%eax
  802308:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80230b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80230f:	74 07                	je     802318 <find_block+0x7d>
  802311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802314:	8b 00                	mov    (%eax),%eax
  802316:	eb 05                	jmp    80231d <find_block+0x82>
  802318:	b8 00 00 00 00       	mov    $0x0,%eax
  80231d:	a3 48 40 80 00       	mov    %eax,0x804048
  802322:	a1 48 40 80 00       	mov    0x804048,%eax
  802327:	85 c0                	test   %eax,%eax
  802329:	75 c8                	jne    8022f3 <find_block+0x58>
  80232b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80232f:	75 c2                	jne    8022f3 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802331:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
  80233b:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80233e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802343:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802346:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80234a:	75 62                	jne    8023ae <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80234c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802350:	75 14                	jne    802366 <insert_sorted_allocList+0x2e>
  802352:	83 ec 04             	sub    $0x4,%esp
  802355:	68 30 3e 80 00       	push   $0x803e30
  80235a:	6a 69                	push   $0x69
  80235c:	68 53 3e 80 00       	push   $0x803e53
  802361:	e8 41 e1 ff ff       	call   8004a7 <_panic>
  802366:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	89 10                	mov    %edx,(%eax)
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	8b 00                	mov    (%eax),%eax
  802376:	85 c0                	test   %eax,%eax
  802378:	74 0d                	je     802387 <insert_sorted_allocList+0x4f>
  80237a:	a1 40 40 80 00       	mov    0x804040,%eax
  80237f:	8b 55 08             	mov    0x8(%ebp),%edx
  802382:	89 50 04             	mov    %edx,0x4(%eax)
  802385:	eb 08                	jmp    80238f <insert_sorted_allocList+0x57>
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	a3 44 40 80 00       	mov    %eax,0x804044
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	a3 40 40 80 00       	mov    %eax,0x804040
  802397:	8b 45 08             	mov    0x8(%ebp),%eax
  80239a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023a6:	40                   	inc    %eax
  8023a7:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023ac:	eb 72                	jmp    802420 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8023ae:	a1 40 40 80 00       	mov    0x804040,%eax
  8023b3:	8b 50 08             	mov    0x8(%eax),%edx
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	8b 40 08             	mov    0x8(%eax),%eax
  8023bc:	39 c2                	cmp    %eax,%edx
  8023be:	76 60                	jbe    802420 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8023c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c4:	75 14                	jne    8023da <insert_sorted_allocList+0xa2>
  8023c6:	83 ec 04             	sub    $0x4,%esp
  8023c9:	68 30 3e 80 00       	push   $0x803e30
  8023ce:	6a 6d                	push   $0x6d
  8023d0:	68 53 3e 80 00       	push   $0x803e53
  8023d5:	e8 cd e0 ff ff       	call   8004a7 <_panic>
  8023da:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	89 10                	mov    %edx,(%eax)
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	74 0d                	je     8023fb <insert_sorted_allocList+0xc3>
  8023ee:	a1 40 40 80 00       	mov    0x804040,%eax
  8023f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f6:	89 50 04             	mov    %edx,0x4(%eax)
  8023f9:	eb 08                	jmp    802403 <insert_sorted_allocList+0xcb>
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	a3 44 40 80 00       	mov    %eax,0x804044
  802403:	8b 45 08             	mov    0x8(%ebp),%eax
  802406:	a3 40 40 80 00       	mov    %eax,0x804040
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802415:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80241a:	40                   	inc    %eax
  80241b:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802420:	a1 40 40 80 00       	mov    0x804040,%eax
  802425:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802428:	e9 b9 01 00 00       	jmp    8025e6 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	8b 50 08             	mov    0x8(%eax),%edx
  802433:	a1 40 40 80 00       	mov    0x804040,%eax
  802438:	8b 40 08             	mov    0x8(%eax),%eax
  80243b:	39 c2                	cmp    %eax,%edx
  80243d:	76 7c                	jbe    8024bb <insert_sorted_allocList+0x183>
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	8b 50 08             	mov    0x8(%eax),%edx
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 40 08             	mov    0x8(%eax),%eax
  80244b:	39 c2                	cmp    %eax,%edx
  80244d:	73 6c                	jae    8024bb <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80244f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802453:	74 06                	je     80245b <insert_sorted_allocList+0x123>
  802455:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802459:	75 14                	jne    80246f <insert_sorted_allocList+0x137>
  80245b:	83 ec 04             	sub    $0x4,%esp
  80245e:	68 6c 3e 80 00       	push   $0x803e6c
  802463:	6a 75                	push   $0x75
  802465:	68 53 3e 80 00       	push   $0x803e53
  80246a:	e8 38 e0 ff ff       	call   8004a7 <_panic>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 50 04             	mov    0x4(%eax),%edx
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	89 50 04             	mov    %edx,0x4(%eax)
  80247b:	8b 45 08             	mov    0x8(%ebp),%eax
  80247e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802481:	89 10                	mov    %edx,(%eax)
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 40 04             	mov    0x4(%eax),%eax
  802489:	85 c0                	test   %eax,%eax
  80248b:	74 0d                	je     80249a <insert_sorted_allocList+0x162>
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 40 04             	mov    0x4(%eax),%eax
  802493:	8b 55 08             	mov    0x8(%ebp),%edx
  802496:	89 10                	mov    %edx,(%eax)
  802498:	eb 08                	jmp    8024a2 <insert_sorted_allocList+0x16a>
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	a3 40 40 80 00       	mov    %eax,0x804040
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a8:	89 50 04             	mov    %edx,0x4(%eax)
  8024ab:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024b0:	40                   	inc    %eax
  8024b1:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8024b6:	e9 59 01 00 00       	jmp    802614 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	8b 50 08             	mov    0x8(%eax),%edx
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 40 08             	mov    0x8(%eax),%eax
  8024c7:	39 c2                	cmp    %eax,%edx
  8024c9:	0f 86 98 00 00 00    	jbe    802567 <insert_sorted_allocList+0x22f>
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	8b 50 08             	mov    0x8(%eax),%edx
  8024d5:	a1 44 40 80 00       	mov    0x804044,%eax
  8024da:	8b 40 08             	mov    0x8(%eax),%eax
  8024dd:	39 c2                	cmp    %eax,%edx
  8024df:	0f 83 82 00 00 00    	jae    802567 <insert_sorted_allocList+0x22f>
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	8b 50 08             	mov    0x8(%eax),%edx
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 00                	mov    (%eax),%eax
  8024f0:	8b 40 08             	mov    0x8(%eax),%eax
  8024f3:	39 c2                	cmp    %eax,%edx
  8024f5:	73 70                	jae    802567 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8024f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fb:	74 06                	je     802503 <insert_sorted_allocList+0x1cb>
  8024fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802501:	75 14                	jne    802517 <insert_sorted_allocList+0x1df>
  802503:	83 ec 04             	sub    $0x4,%esp
  802506:	68 a4 3e 80 00       	push   $0x803ea4
  80250b:	6a 7c                	push   $0x7c
  80250d:	68 53 3e 80 00       	push   $0x803e53
  802512:	e8 90 df ff ff       	call   8004a7 <_panic>
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	8b 10                	mov    (%eax),%edx
  80251c:	8b 45 08             	mov    0x8(%ebp),%eax
  80251f:	89 10                	mov    %edx,(%eax)
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	74 0b                	je     802535 <insert_sorted_allocList+0x1fd>
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 00                	mov    (%eax),%eax
  80252f:	8b 55 08             	mov    0x8(%ebp),%edx
  802532:	89 50 04             	mov    %edx,0x4(%eax)
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	8b 55 08             	mov    0x8(%ebp),%edx
  80253b:	89 10                	mov    %edx,(%eax)
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802543:	89 50 04             	mov    %edx,0x4(%eax)
  802546:	8b 45 08             	mov    0x8(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	75 08                	jne    802557 <insert_sorted_allocList+0x21f>
  80254f:	8b 45 08             	mov    0x8(%ebp),%eax
  802552:	a3 44 40 80 00       	mov    %eax,0x804044
  802557:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80255c:	40                   	inc    %eax
  80255d:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802562:	e9 ad 00 00 00       	jmp    802614 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	8b 50 08             	mov    0x8(%eax),%edx
  80256d:	a1 44 40 80 00       	mov    0x804044,%eax
  802572:	8b 40 08             	mov    0x8(%eax),%eax
  802575:	39 c2                	cmp    %eax,%edx
  802577:	76 65                	jbe    8025de <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802579:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80257d:	75 17                	jne    802596 <insert_sorted_allocList+0x25e>
  80257f:	83 ec 04             	sub    $0x4,%esp
  802582:	68 d8 3e 80 00       	push   $0x803ed8
  802587:	68 80 00 00 00       	push   $0x80
  80258c:	68 53 3e 80 00       	push   $0x803e53
  802591:	e8 11 df ff ff       	call   8004a7 <_panic>
  802596:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	89 50 04             	mov    %edx,0x4(%eax)
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	8b 40 04             	mov    0x4(%eax),%eax
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	74 0c                	je     8025b8 <insert_sorted_allocList+0x280>
  8025ac:	a1 44 40 80 00       	mov    0x804044,%eax
  8025b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b4:	89 10                	mov    %edx,(%eax)
  8025b6:	eb 08                	jmp    8025c0 <insert_sorted_allocList+0x288>
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	a3 40 40 80 00       	mov    %eax,0x804040
  8025c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c3:	a3 44 40 80 00       	mov    %eax,0x804044
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8025d6:	40                   	inc    %eax
  8025d7:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8025dc:	eb 36                	jmp    802614 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8025de:	a1 48 40 80 00       	mov    0x804048,%eax
  8025e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ea:	74 07                	je     8025f3 <insert_sorted_allocList+0x2bb>
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	eb 05                	jmp    8025f8 <insert_sorted_allocList+0x2c0>
  8025f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f8:	a3 48 40 80 00       	mov    %eax,0x804048
  8025fd:	a1 48 40 80 00       	mov    0x804048,%eax
  802602:	85 c0                	test   %eax,%eax
  802604:	0f 85 23 fe ff ff    	jne    80242d <insert_sorted_allocList+0xf5>
  80260a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260e:	0f 85 19 fe ff ff    	jne    80242d <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802614:	90                   	nop
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
  80261a:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80261d:	a1 38 41 80 00       	mov    0x804138,%eax
  802622:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802625:	e9 7c 01 00 00       	jmp    8027a6 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 0c             	mov    0xc(%eax),%eax
  802630:	3b 45 08             	cmp    0x8(%ebp),%eax
  802633:	0f 85 90 00 00 00    	jne    8026c9 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80263f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802643:	75 17                	jne    80265c <alloc_block_FF+0x45>
  802645:	83 ec 04             	sub    $0x4,%esp
  802648:	68 fb 3e 80 00       	push   $0x803efb
  80264d:	68 ba 00 00 00       	push   $0xba
  802652:	68 53 3e 80 00       	push   $0x803e53
  802657:	e8 4b de ff ff       	call   8004a7 <_panic>
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 00                	mov    (%eax),%eax
  802661:	85 c0                	test   %eax,%eax
  802663:	74 10                	je     802675 <alloc_block_FF+0x5e>
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 00                	mov    (%eax),%eax
  80266a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266d:	8b 52 04             	mov    0x4(%edx),%edx
  802670:	89 50 04             	mov    %edx,0x4(%eax)
  802673:	eb 0b                	jmp    802680 <alloc_block_FF+0x69>
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 40 04             	mov    0x4(%eax),%eax
  80267b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 40 04             	mov    0x4(%eax),%eax
  802686:	85 c0                	test   %eax,%eax
  802688:	74 0f                	je     802699 <alloc_block_FF+0x82>
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 40 04             	mov    0x4(%eax),%eax
  802690:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802693:	8b 12                	mov    (%edx),%edx
  802695:	89 10                	mov    %edx,(%eax)
  802697:	eb 0a                	jmp    8026a3 <alloc_block_FF+0x8c>
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 00                	mov    (%eax),%eax
  80269e:	a3 38 41 80 00       	mov    %eax,0x804138
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b6:	a1 44 41 80 00       	mov    0x804144,%eax
  8026bb:	48                   	dec    %eax
  8026bc:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8026c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c4:	e9 10 01 00 00       	jmp    8027d9 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d2:	0f 86 c6 00 00 00    	jbe    80279e <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8026d8:	a1 48 41 80 00       	mov    0x804148,%eax
  8026dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8026e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e4:	75 17                	jne    8026fd <alloc_block_FF+0xe6>
  8026e6:	83 ec 04             	sub    $0x4,%esp
  8026e9:	68 fb 3e 80 00       	push   $0x803efb
  8026ee:	68 c2 00 00 00       	push   $0xc2
  8026f3:	68 53 3e 80 00       	push   $0x803e53
  8026f8:	e8 aa dd ff ff       	call   8004a7 <_panic>
  8026fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802700:	8b 00                	mov    (%eax),%eax
  802702:	85 c0                	test   %eax,%eax
  802704:	74 10                	je     802716 <alloc_block_FF+0xff>
  802706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80270e:	8b 52 04             	mov    0x4(%edx),%edx
  802711:	89 50 04             	mov    %edx,0x4(%eax)
  802714:	eb 0b                	jmp    802721 <alloc_block_FF+0x10a>
  802716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802719:	8b 40 04             	mov    0x4(%eax),%eax
  80271c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802724:	8b 40 04             	mov    0x4(%eax),%eax
  802727:	85 c0                	test   %eax,%eax
  802729:	74 0f                	je     80273a <alloc_block_FF+0x123>
  80272b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272e:	8b 40 04             	mov    0x4(%eax),%eax
  802731:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802734:	8b 12                	mov    (%edx),%edx
  802736:	89 10                	mov    %edx,(%eax)
  802738:	eb 0a                	jmp    802744 <alloc_block_FF+0x12d>
  80273a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273d:	8b 00                	mov    (%eax),%eax
  80273f:	a3 48 41 80 00       	mov    %eax,0x804148
  802744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802747:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802750:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802757:	a1 54 41 80 00       	mov    0x804154,%eax
  80275c:	48                   	dec    %eax
  80275d:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 50 08             	mov    0x8(%eax),%edx
  802768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276b:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  80276e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802771:	8b 55 08             	mov    0x8(%ebp),%edx
  802774:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 40 0c             	mov    0xc(%eax),%eax
  80277d:	2b 45 08             	sub    0x8(%ebp),%eax
  802780:	89 c2                	mov    %eax,%edx
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 50 08             	mov    0x8(%eax),%edx
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
  802791:	01 c2                	add    %eax,%edx
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279c:	eb 3b                	jmp    8027d9 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80279e:	a1 40 41 80 00       	mov    0x804140,%eax
  8027a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027aa:	74 07                	je     8027b3 <alloc_block_FF+0x19c>
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 00                	mov    (%eax),%eax
  8027b1:	eb 05                	jmp    8027b8 <alloc_block_FF+0x1a1>
  8027b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b8:	a3 40 41 80 00       	mov    %eax,0x804140
  8027bd:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	0f 85 60 fe ff ff    	jne    80262a <alloc_block_FF+0x13>
  8027ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ce:	0f 85 56 fe ff ff    	jne    80262a <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d9:	c9                   	leave  
  8027da:	c3                   	ret    

008027db <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8027e1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8027e8:	a1 38 41 80 00       	mov    0x804138,%eax
  8027ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f0:	eb 3a                	jmp    80282c <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027fb:	72 27                	jb     802824 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8027fd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802801:	75 0b                	jne    80280e <alloc_block_BF+0x33>
					best_size= element->size;
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 40 0c             	mov    0xc(%eax),%eax
  802809:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80280c:	eb 16                	jmp    802824 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 50 0c             	mov    0xc(%eax),%edx
  802814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802817:	39 c2                	cmp    %eax,%edx
  802819:	77 09                	ja     802824 <alloc_block_BF+0x49>
					best_size=element->size;
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 40 0c             	mov    0xc(%eax),%eax
  802821:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802824:	a1 40 41 80 00       	mov    0x804140,%eax
  802829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802830:	74 07                	je     802839 <alloc_block_BF+0x5e>
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 00                	mov    (%eax),%eax
  802837:	eb 05                	jmp    80283e <alloc_block_BF+0x63>
  802839:	b8 00 00 00 00       	mov    $0x0,%eax
  80283e:	a3 40 41 80 00       	mov    %eax,0x804140
  802843:	a1 40 41 80 00       	mov    0x804140,%eax
  802848:	85 c0                	test   %eax,%eax
  80284a:	75 a6                	jne    8027f2 <alloc_block_BF+0x17>
  80284c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802850:	75 a0                	jne    8027f2 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802852:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802856:	0f 84 d3 01 00 00    	je     802a2f <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80285c:	a1 38 41 80 00       	mov    0x804138,%eax
  802861:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802864:	e9 98 01 00 00       	jmp    802a01 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286f:	0f 86 da 00 00 00    	jbe    80294f <alloc_block_BF+0x174>
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 50 0c             	mov    0xc(%eax),%edx
  80287b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287e:	39 c2                	cmp    %eax,%edx
  802880:	0f 85 c9 00 00 00    	jne    80294f <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802886:	a1 48 41 80 00       	mov    0x804148,%eax
  80288b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80288e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802892:	75 17                	jne    8028ab <alloc_block_BF+0xd0>
  802894:	83 ec 04             	sub    $0x4,%esp
  802897:	68 fb 3e 80 00       	push   $0x803efb
  80289c:	68 ea 00 00 00       	push   $0xea
  8028a1:	68 53 3e 80 00       	push   $0x803e53
  8028a6:	e8 fc db ff ff       	call   8004a7 <_panic>
  8028ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	74 10                	je     8028c4 <alloc_block_BF+0xe9>
  8028b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028bc:	8b 52 04             	mov    0x4(%edx),%edx
  8028bf:	89 50 04             	mov    %edx,0x4(%eax)
  8028c2:	eb 0b                	jmp    8028cf <alloc_block_BF+0xf4>
  8028c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ca:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d2:	8b 40 04             	mov    0x4(%eax),%eax
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 0f                	je     8028e8 <alloc_block_BF+0x10d>
  8028d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dc:	8b 40 04             	mov    0x4(%eax),%eax
  8028df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028e2:	8b 12                	mov    (%edx),%edx
  8028e4:	89 10                	mov    %edx,(%eax)
  8028e6:	eb 0a                	jmp    8028f2 <alloc_block_BF+0x117>
  8028e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028eb:	8b 00                	mov    (%eax),%eax
  8028ed:	a3 48 41 80 00       	mov    %eax,0x804148
  8028f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802905:	a1 54 41 80 00       	mov    0x804154,%eax
  80290a:	48                   	dec    %eax
  80290b:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	8b 50 08             	mov    0x8(%eax),%edx
  802916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802919:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80291c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291f:	8b 55 08             	mov    0x8(%ebp),%edx
  802922:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 40 0c             	mov    0xc(%eax),%eax
  80292b:	2b 45 08             	sub    0x8(%ebp),%eax
  80292e:	89 c2                	mov    %eax,%edx
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 50 08             	mov    0x8(%eax),%edx
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	01 c2                	add    %eax,%edx
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802947:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294a:	e9 e5 00 00 00       	jmp    802a34 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 50 0c             	mov    0xc(%eax),%edx
  802955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802958:	39 c2                	cmp    %eax,%edx
  80295a:	0f 85 99 00 00 00    	jne    8029f9 <alloc_block_BF+0x21e>
  802960:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802963:	3b 45 08             	cmp    0x8(%ebp),%eax
  802966:	0f 85 8d 00 00 00    	jne    8029f9 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802976:	75 17                	jne    80298f <alloc_block_BF+0x1b4>
  802978:	83 ec 04             	sub    $0x4,%esp
  80297b:	68 fb 3e 80 00       	push   $0x803efb
  802980:	68 f7 00 00 00       	push   $0xf7
  802985:	68 53 3e 80 00       	push   $0x803e53
  80298a:	e8 18 db ff ff       	call   8004a7 <_panic>
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	74 10                	je     8029a8 <alloc_block_BF+0x1cd>
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a0:	8b 52 04             	mov    0x4(%edx),%edx
  8029a3:	89 50 04             	mov    %edx,0x4(%eax)
  8029a6:	eb 0b                	jmp    8029b3 <alloc_block_BF+0x1d8>
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 40 04             	mov    0x4(%eax),%eax
  8029ae:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 40 04             	mov    0x4(%eax),%eax
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	74 0f                	je     8029cc <alloc_block_BF+0x1f1>
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 40 04             	mov    0x4(%eax),%eax
  8029c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c6:	8b 12                	mov    (%edx),%edx
  8029c8:	89 10                	mov    %edx,(%eax)
  8029ca:	eb 0a                	jmp    8029d6 <alloc_block_BF+0x1fb>
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 00                	mov    (%eax),%eax
  8029d1:	a3 38 41 80 00       	mov    %eax,0x804138
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e9:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ee:	48                   	dec    %eax
  8029ef:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8029f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f7:	eb 3b                	jmp    802a34 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8029f9:	a1 40 41 80 00       	mov    0x804140,%eax
  8029fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a05:	74 07                	je     802a0e <alloc_block_BF+0x233>
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 00                	mov    (%eax),%eax
  802a0c:	eb 05                	jmp    802a13 <alloc_block_BF+0x238>
  802a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a13:	a3 40 41 80 00       	mov    %eax,0x804140
  802a18:	a1 40 41 80 00       	mov    0x804140,%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	0f 85 44 fe ff ff    	jne    802869 <alloc_block_BF+0x8e>
  802a25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a29:	0f 85 3a fe ff ff    	jne    802869 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802a2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a34:	c9                   	leave  
  802a35:	c3                   	ret    

00802a36 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a36:	55                   	push   %ebp
  802a37:	89 e5                	mov    %esp,%ebp
  802a39:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 1c 3f 80 00       	push   $0x803f1c
  802a44:	68 04 01 00 00       	push   $0x104
  802a49:	68 53 3e 80 00       	push   $0x803e53
  802a4e:	e8 54 da ff ff       	call   8004a7 <_panic>

00802a53 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802a53:	55                   	push   %ebp
  802a54:	89 e5                	mov    %esp,%ebp
  802a56:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802a59:	a1 38 41 80 00       	mov    0x804138,%eax
  802a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802a61:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a66:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802a69:	a1 38 41 80 00       	mov    0x804138,%eax
  802a6e:	85 c0                	test   %eax,%eax
  802a70:	75 68                	jne    802ada <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802a72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a76:	75 17                	jne    802a8f <insert_sorted_with_merge_freeList+0x3c>
  802a78:	83 ec 04             	sub    $0x4,%esp
  802a7b:	68 30 3e 80 00       	push   $0x803e30
  802a80:	68 14 01 00 00       	push   $0x114
  802a85:	68 53 3e 80 00       	push   $0x803e53
  802a8a:	e8 18 da ff ff       	call   8004a7 <_panic>
  802a8f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	89 10                	mov    %edx,(%eax)
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	8b 00                	mov    (%eax),%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	74 0d                	je     802ab0 <insert_sorted_with_merge_freeList+0x5d>
  802aa3:	a1 38 41 80 00       	mov    0x804138,%eax
  802aa8:	8b 55 08             	mov    0x8(%ebp),%edx
  802aab:	89 50 04             	mov    %edx,0x4(%eax)
  802aae:	eb 08                	jmp    802ab8 <insert_sorted_with_merge_freeList+0x65>
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	a3 38 41 80 00       	mov    %eax,0x804138
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aca:	a1 44 41 80 00       	mov    0x804144,%eax
  802acf:	40                   	inc    %eax
  802ad0:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802ad5:	e9 d2 06 00 00       	jmp    8031ac <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	8b 50 08             	mov    0x8(%eax),%edx
  802ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae3:	8b 40 08             	mov    0x8(%eax),%eax
  802ae6:	39 c2                	cmp    %eax,%edx
  802ae8:	0f 83 22 01 00 00    	jae    802c10 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802aee:	8b 45 08             	mov    0x8(%ebp),%eax
  802af1:	8b 50 08             	mov    0x8(%eax),%edx
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	8b 40 0c             	mov    0xc(%eax),%eax
  802afa:	01 c2                	add    %eax,%edx
  802afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aff:	8b 40 08             	mov    0x8(%eax),%eax
  802b02:	39 c2                	cmp    %eax,%edx
  802b04:	0f 85 9e 00 00 00    	jne    802ba8 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	8b 50 08             	mov    0x8(%eax),%edx
  802b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b13:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b19:	8b 50 0c             	mov    0xc(%eax),%edx
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b22:	01 c2                	add    %eax,%edx
  802b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b27:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	8b 50 08             	mov    0x8(%eax),%edx
  802b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3d:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802b40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b44:	75 17                	jne    802b5d <insert_sorted_with_merge_freeList+0x10a>
  802b46:	83 ec 04             	sub    $0x4,%esp
  802b49:	68 30 3e 80 00       	push   $0x803e30
  802b4e:	68 21 01 00 00       	push   $0x121
  802b53:	68 53 3e 80 00       	push   $0x803e53
  802b58:	e8 4a d9 ff ff       	call   8004a7 <_panic>
  802b5d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	89 10                	mov    %edx,(%eax)
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	85 c0                	test   %eax,%eax
  802b6f:	74 0d                	je     802b7e <insert_sorted_with_merge_freeList+0x12b>
  802b71:	a1 48 41 80 00       	mov    0x804148,%eax
  802b76:	8b 55 08             	mov    0x8(%ebp),%edx
  802b79:	89 50 04             	mov    %edx,0x4(%eax)
  802b7c:	eb 08                	jmp    802b86 <insert_sorted_with_merge_freeList+0x133>
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	a3 48 41 80 00       	mov    %eax,0x804148
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b98:	a1 54 41 80 00       	mov    0x804154,%eax
  802b9d:	40                   	inc    %eax
  802b9e:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802ba3:	e9 04 06 00 00       	jmp    8031ac <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802ba8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bac:	75 17                	jne    802bc5 <insert_sorted_with_merge_freeList+0x172>
  802bae:	83 ec 04             	sub    $0x4,%esp
  802bb1:	68 30 3e 80 00       	push   $0x803e30
  802bb6:	68 26 01 00 00       	push   $0x126
  802bbb:	68 53 3e 80 00       	push   $0x803e53
  802bc0:	e8 e2 d8 ff ff       	call   8004a7 <_panic>
  802bc5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	89 10                	mov    %edx,(%eax)
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	74 0d                	je     802be6 <insert_sorted_with_merge_freeList+0x193>
  802bd9:	a1 38 41 80 00       	mov    0x804138,%eax
  802bde:	8b 55 08             	mov    0x8(%ebp),%edx
  802be1:	89 50 04             	mov    %edx,0x4(%eax)
  802be4:	eb 08                	jmp    802bee <insert_sorted_with_merge_freeList+0x19b>
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	a3 38 41 80 00       	mov    %eax,0x804138
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c00:	a1 44 41 80 00       	mov    0x804144,%eax
  802c05:	40                   	inc    %eax
  802c06:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802c0b:	e9 9c 05 00 00       	jmp    8031ac <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	8b 50 08             	mov    0x8(%eax),%edx
  802c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c19:	8b 40 08             	mov    0x8(%eax),%eax
  802c1c:	39 c2                	cmp    %eax,%edx
  802c1e:	0f 86 16 01 00 00    	jbe    802d3a <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802c24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c27:	8b 50 08             	mov    0x8(%eax),%edx
  802c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c30:	01 c2                	add    %eax,%edx
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	8b 40 08             	mov    0x8(%eax),%eax
  802c38:	39 c2                	cmp    %eax,%edx
  802c3a:	0f 85 92 00 00 00    	jne    802cd2 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c43:	8b 50 0c             	mov    0xc(%eax),%edx
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4c:	01 c2                	add    %eax,%edx
  802c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c51:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	8b 50 08             	mov    0x8(%eax),%edx
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c6e:	75 17                	jne    802c87 <insert_sorted_with_merge_freeList+0x234>
  802c70:	83 ec 04             	sub    $0x4,%esp
  802c73:	68 30 3e 80 00       	push   $0x803e30
  802c78:	68 31 01 00 00       	push   $0x131
  802c7d:	68 53 3e 80 00       	push   $0x803e53
  802c82:	e8 20 d8 ff ff       	call   8004a7 <_panic>
  802c87:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	89 10                	mov    %edx,(%eax)
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	8b 00                	mov    (%eax),%eax
  802c97:	85 c0                	test   %eax,%eax
  802c99:	74 0d                	je     802ca8 <insert_sorted_with_merge_freeList+0x255>
  802c9b:	a1 48 41 80 00       	mov    0x804148,%eax
  802ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca3:	89 50 04             	mov    %edx,0x4(%eax)
  802ca6:	eb 08                	jmp    802cb0 <insert_sorted_with_merge_freeList+0x25d>
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb3:	a3 48 41 80 00       	mov    %eax,0x804148
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc2:	a1 54 41 80 00       	mov    0x804154,%eax
  802cc7:	40                   	inc    %eax
  802cc8:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802ccd:	e9 da 04 00 00       	jmp    8031ac <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802cd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd6:	75 17                	jne    802cef <insert_sorted_with_merge_freeList+0x29c>
  802cd8:	83 ec 04             	sub    $0x4,%esp
  802cdb:	68 d8 3e 80 00       	push   $0x803ed8
  802ce0:	68 37 01 00 00       	push   $0x137
  802ce5:	68 53 3e 80 00       	push   $0x803e53
  802cea:	e8 b8 d7 ff ff       	call   8004a7 <_panic>
  802cef:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	89 50 04             	mov    %edx,0x4(%eax)
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	8b 40 04             	mov    0x4(%eax),%eax
  802d01:	85 c0                	test   %eax,%eax
  802d03:	74 0c                	je     802d11 <insert_sorted_with_merge_freeList+0x2be>
  802d05:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0d:	89 10                	mov    %edx,(%eax)
  802d0f:	eb 08                	jmp    802d19 <insert_sorted_with_merge_freeList+0x2c6>
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	a3 38 41 80 00       	mov    %eax,0x804138
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2a:	a1 44 41 80 00       	mov    0x804144,%eax
  802d2f:	40                   	inc    %eax
  802d30:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802d35:	e9 72 04 00 00       	jmp    8031ac <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802d3a:	a1 38 41 80 00       	mov    0x804138,%eax
  802d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d42:	e9 35 04 00 00       	jmp    80317c <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 00                	mov    (%eax),%eax
  802d4c:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	8b 50 08             	mov    0x8(%eax),%edx
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	8b 40 08             	mov    0x8(%eax),%eax
  802d5b:	39 c2                	cmp    %eax,%edx
  802d5d:	0f 86 11 04 00 00    	jbe    803174 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d66:	8b 50 08             	mov    0x8(%eax),%edx
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6f:	01 c2                	add    %eax,%edx
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	8b 40 08             	mov    0x8(%eax),%eax
  802d77:	39 c2                	cmp    %eax,%edx
  802d79:	0f 83 8b 00 00 00    	jae    802e0a <insert_sorted_with_merge_freeList+0x3b7>
  802d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d82:	8b 50 08             	mov    0x8(%eax),%edx
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8b:	01 c2                	add    %eax,%edx
  802d8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d90:	8b 40 08             	mov    0x8(%eax),%eax
  802d93:	39 c2                	cmp    %eax,%edx
  802d95:	73 73                	jae    802e0a <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802d97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9b:	74 06                	je     802da3 <insert_sorted_with_merge_freeList+0x350>
  802d9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da1:	75 17                	jne    802dba <insert_sorted_with_merge_freeList+0x367>
  802da3:	83 ec 04             	sub    $0x4,%esp
  802da6:	68 a4 3e 80 00       	push   $0x803ea4
  802dab:	68 48 01 00 00       	push   $0x148
  802db0:	68 53 3e 80 00       	push   $0x803e53
  802db5:	e8 ed d6 ff ff       	call   8004a7 <_panic>
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 10                	mov    (%eax),%edx
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	89 10                	mov    %edx,(%eax)
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	8b 00                	mov    (%eax),%eax
  802dc9:	85 c0                	test   %eax,%eax
  802dcb:	74 0b                	je     802dd8 <insert_sorted_with_merge_freeList+0x385>
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	8b 00                	mov    (%eax),%eax
  802dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd5:	89 50 04             	mov    %edx,0x4(%eax)
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dde:	89 10                	mov    %edx,(%eax)
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de6:	89 50 04             	mov    %edx,0x4(%eax)
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	8b 00                	mov    (%eax),%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	75 08                	jne    802dfa <insert_sorted_with_merge_freeList+0x3a7>
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dfa:	a1 44 41 80 00       	mov    0x804144,%eax
  802dff:	40                   	inc    %eax
  802e00:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802e05:	e9 a2 03 00 00       	jmp    8031ac <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	8b 50 08             	mov    0x8(%eax),%edx
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	8b 40 0c             	mov    0xc(%eax),%eax
  802e16:	01 c2                	add    %eax,%edx
  802e18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1b:	8b 40 08             	mov    0x8(%eax),%eax
  802e1e:	39 c2                	cmp    %eax,%edx
  802e20:	0f 83 ae 00 00 00    	jae    802ed4 <insert_sorted_with_merge_freeList+0x481>
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	8b 50 08             	mov    0x8(%eax),%edx
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 48 08             	mov    0x8(%eax),%ecx
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	8b 40 0c             	mov    0xc(%eax),%eax
  802e38:	01 c8                	add    %ecx,%eax
  802e3a:	39 c2                	cmp    %eax,%edx
  802e3c:	0f 85 92 00 00 00    	jne    802ed4 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 50 0c             	mov    0xc(%eax),%edx
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4e:	01 c2                	add    %eax,%edx
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802e56:	8b 45 08             	mov    0x8(%ebp),%eax
  802e59:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	8b 50 08             	mov    0x8(%eax),%edx
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802e6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e70:	75 17                	jne    802e89 <insert_sorted_with_merge_freeList+0x436>
  802e72:	83 ec 04             	sub    $0x4,%esp
  802e75:	68 30 3e 80 00       	push   $0x803e30
  802e7a:	68 51 01 00 00       	push   $0x151
  802e7f:	68 53 3e 80 00       	push   $0x803e53
  802e84:	e8 1e d6 ff ff       	call   8004a7 <_panic>
  802e89:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	89 10                	mov    %edx,(%eax)
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	8b 00                	mov    (%eax),%eax
  802e99:	85 c0                	test   %eax,%eax
  802e9b:	74 0d                	je     802eaa <insert_sorted_with_merge_freeList+0x457>
  802e9d:	a1 48 41 80 00       	mov    0x804148,%eax
  802ea2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea5:	89 50 04             	mov    %edx,0x4(%eax)
  802ea8:	eb 08                	jmp    802eb2 <insert_sorted_with_merge_freeList+0x45f>
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	a3 48 41 80 00       	mov    %eax,0x804148
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec4:	a1 54 41 80 00       	mov    0x804154,%eax
  802ec9:	40                   	inc    %eax
  802eca:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802ecf:	e9 d8 02 00 00       	jmp    8031ac <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	8b 50 08             	mov    0x8(%eax),%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee0:	01 c2                	add    %eax,%edx
  802ee2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee5:	8b 40 08             	mov    0x8(%eax),%eax
  802ee8:	39 c2                	cmp    %eax,%edx
  802eea:	0f 85 ba 00 00 00    	jne    802faa <insert_sorted_with_merge_freeList+0x557>
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	8b 50 08             	mov    0x8(%eax),%edx
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	8b 48 08             	mov    0x8(%eax),%ecx
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 40 0c             	mov    0xc(%eax),%eax
  802f02:	01 c8                	add    %ecx,%eax
  802f04:	39 c2                	cmp    %eax,%edx
  802f06:	0f 86 9e 00 00 00    	jbe    802faa <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802f0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	8b 40 0c             	mov    0xc(%eax),%eax
  802f18:	01 c2                	add    %eax,%edx
  802f1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1d:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	8b 50 08             	mov    0x8(%eax),%edx
  802f26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f29:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	8b 50 08             	mov    0x8(%eax),%edx
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f46:	75 17                	jne    802f5f <insert_sorted_with_merge_freeList+0x50c>
  802f48:	83 ec 04             	sub    $0x4,%esp
  802f4b:	68 30 3e 80 00       	push   $0x803e30
  802f50:	68 5b 01 00 00       	push   $0x15b
  802f55:	68 53 3e 80 00       	push   $0x803e53
  802f5a:	e8 48 d5 ff ff       	call   8004a7 <_panic>
  802f5f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	89 10                	mov    %edx,(%eax)
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	8b 00                	mov    (%eax),%eax
  802f6f:	85 c0                	test   %eax,%eax
  802f71:	74 0d                	je     802f80 <insert_sorted_with_merge_freeList+0x52d>
  802f73:	a1 48 41 80 00       	mov    0x804148,%eax
  802f78:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7b:	89 50 04             	mov    %edx,0x4(%eax)
  802f7e:	eb 08                	jmp    802f88 <insert_sorted_with_merge_freeList+0x535>
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	a3 48 41 80 00       	mov    %eax,0x804148
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9a:	a1 54 41 80 00       	mov    0x804154,%eax
  802f9f:	40                   	inc    %eax
  802fa0:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802fa5:	e9 02 02 00 00       	jmp    8031ac <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	8b 50 08             	mov    0x8(%eax),%edx
  802fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb6:	01 c2                	add    %eax,%edx
  802fb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbb:	8b 40 08             	mov    0x8(%eax),%eax
  802fbe:	39 c2                	cmp    %eax,%edx
  802fc0:	0f 85 ae 01 00 00    	jne    803174 <insert_sorted_with_merge_freeList+0x721>
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	8b 50 08             	mov    0x8(%eax),%edx
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	8b 48 08             	mov    0x8(%eax),%ecx
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd8:	01 c8                	add    %ecx,%eax
  802fda:	39 c2                	cmp    %eax,%edx
  802fdc:	0f 85 92 01 00 00    	jne    803174 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe5:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fee:	01 c2                	add    %eax,%edx
  802ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff6:	01 c2                	add    %eax,%edx
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	8b 50 08             	mov    0x8(%eax),%edx
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803017:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80301e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803021:	8b 50 08             	mov    0x8(%eax),%edx
  803024:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803027:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  80302a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80302e:	75 17                	jne    803047 <insert_sorted_with_merge_freeList+0x5f4>
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	68 fb 3e 80 00       	push   $0x803efb
  803038:	68 63 01 00 00       	push   $0x163
  80303d:	68 53 3e 80 00       	push   $0x803e53
  803042:	e8 60 d4 ff ff       	call   8004a7 <_panic>
  803047:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304a:	8b 00                	mov    (%eax),%eax
  80304c:	85 c0                	test   %eax,%eax
  80304e:	74 10                	je     803060 <insert_sorted_with_merge_freeList+0x60d>
  803050:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803058:	8b 52 04             	mov    0x4(%edx),%edx
  80305b:	89 50 04             	mov    %edx,0x4(%eax)
  80305e:	eb 0b                	jmp    80306b <insert_sorted_with_merge_freeList+0x618>
  803060:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803063:	8b 40 04             	mov    0x4(%eax),%eax
  803066:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80306b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306e:	8b 40 04             	mov    0x4(%eax),%eax
  803071:	85 c0                	test   %eax,%eax
  803073:	74 0f                	je     803084 <insert_sorted_with_merge_freeList+0x631>
  803075:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803078:	8b 40 04             	mov    0x4(%eax),%eax
  80307b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80307e:	8b 12                	mov    (%edx),%edx
  803080:	89 10                	mov    %edx,(%eax)
  803082:	eb 0a                	jmp    80308e <insert_sorted_with_merge_freeList+0x63b>
  803084:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803087:	8b 00                	mov    (%eax),%eax
  803089:	a3 38 41 80 00       	mov    %eax,0x804138
  80308e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803091:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803097:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a1:	a1 44 41 80 00       	mov    0x804144,%eax
  8030a6:	48                   	dec    %eax
  8030a7:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8030ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b0:	75 17                	jne    8030c9 <insert_sorted_with_merge_freeList+0x676>
  8030b2:	83 ec 04             	sub    $0x4,%esp
  8030b5:	68 30 3e 80 00       	push   $0x803e30
  8030ba:	68 64 01 00 00       	push   $0x164
  8030bf:	68 53 3e 80 00       	push   $0x803e53
  8030c4:	e8 de d3 ff ff       	call   8004a7 <_panic>
  8030c9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d2:	89 10                	mov    %edx,(%eax)
  8030d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	85 c0                	test   %eax,%eax
  8030db:	74 0d                	je     8030ea <insert_sorted_with_merge_freeList+0x697>
  8030dd:	a1 48 41 80 00       	mov    0x804148,%eax
  8030e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030e5:	89 50 04             	mov    %edx,0x4(%eax)
  8030e8:	eb 08                	jmp    8030f2 <insert_sorted_with_merge_freeList+0x69f>
  8030ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ed:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f5:	a3 48 41 80 00       	mov    %eax,0x804148
  8030fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803104:	a1 54 41 80 00       	mov    0x804154,%eax
  803109:	40                   	inc    %eax
  80310a:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80310f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803113:	75 17                	jne    80312c <insert_sorted_with_merge_freeList+0x6d9>
  803115:	83 ec 04             	sub    $0x4,%esp
  803118:	68 30 3e 80 00       	push   $0x803e30
  80311d:	68 65 01 00 00       	push   $0x165
  803122:	68 53 3e 80 00       	push   $0x803e53
  803127:	e8 7b d3 ff ff       	call   8004a7 <_panic>
  80312c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	89 10                	mov    %edx,(%eax)
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	8b 00                	mov    (%eax),%eax
  80313c:	85 c0                	test   %eax,%eax
  80313e:	74 0d                	je     80314d <insert_sorted_with_merge_freeList+0x6fa>
  803140:	a1 48 41 80 00       	mov    0x804148,%eax
  803145:	8b 55 08             	mov    0x8(%ebp),%edx
  803148:	89 50 04             	mov    %edx,0x4(%eax)
  80314b:	eb 08                	jmp    803155 <insert_sorted_with_merge_freeList+0x702>
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	a3 48 41 80 00       	mov    %eax,0x804148
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803167:	a1 54 41 80 00       	mov    0x804154,%eax
  80316c:	40                   	inc    %eax
  80316d:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  803172:	eb 38                	jmp    8031ac <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803174:	a1 40 41 80 00       	mov    0x804140,%eax
  803179:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80317c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803180:	74 07                	je     803189 <insert_sorted_with_merge_freeList+0x736>
  803182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803185:	8b 00                	mov    (%eax),%eax
  803187:	eb 05                	jmp    80318e <insert_sorted_with_merge_freeList+0x73b>
  803189:	b8 00 00 00 00       	mov    $0x0,%eax
  80318e:	a3 40 41 80 00       	mov    %eax,0x804140
  803193:	a1 40 41 80 00       	mov    0x804140,%eax
  803198:	85 c0                	test   %eax,%eax
  80319a:	0f 85 a7 fb ff ff    	jne    802d47 <insert_sorted_with_merge_freeList+0x2f4>
  8031a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a4:	0f 85 9d fb ff ff    	jne    802d47 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8031aa:	eb 00                	jmp    8031ac <insert_sorted_with_merge_freeList+0x759>
  8031ac:	90                   	nop
  8031ad:	c9                   	leave  
  8031ae:	c3                   	ret    

008031af <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8031af:	55                   	push   %ebp
  8031b0:	89 e5                	mov    %esp,%ebp
  8031b2:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8031b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b8:	89 d0                	mov    %edx,%eax
  8031ba:	c1 e0 02             	shl    $0x2,%eax
  8031bd:	01 d0                	add    %edx,%eax
  8031bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031c6:	01 d0                	add    %edx,%eax
  8031c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031cf:	01 d0                	add    %edx,%eax
  8031d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031d8:	01 d0                	add    %edx,%eax
  8031da:	c1 e0 04             	shl    $0x4,%eax
  8031dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8031e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8031e7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8031ea:	83 ec 0c             	sub    $0xc,%esp
  8031ed:	50                   	push   %eax
  8031ee:	e8 ee eb ff ff       	call   801de1 <sys_get_virtual_time>
  8031f3:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8031f6:	eb 41                	jmp    803239 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8031f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8031fb:	83 ec 0c             	sub    $0xc,%esp
  8031fe:	50                   	push   %eax
  8031ff:	e8 dd eb ff ff       	call   801de1 <sys_get_virtual_time>
  803204:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803207:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80320a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320d:	29 c2                	sub    %eax,%edx
  80320f:	89 d0                	mov    %edx,%eax
  803211:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803214:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321a:	89 d1                	mov    %edx,%ecx
  80321c:	29 c1                	sub    %eax,%ecx
  80321e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803221:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803224:	39 c2                	cmp    %eax,%edx
  803226:	0f 97 c0             	seta   %al
  803229:	0f b6 c0             	movzbl %al,%eax
  80322c:	29 c1                	sub    %eax,%ecx
  80322e:	89 c8                	mov    %ecx,%eax
  803230:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803236:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80323f:	72 b7                	jb     8031f8 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803241:	90                   	nop
  803242:	c9                   	leave  
  803243:	c3                   	ret    

00803244 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803244:	55                   	push   %ebp
  803245:	89 e5                	mov    %esp,%ebp
  803247:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80324a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803251:	eb 03                	jmp    803256 <busy_wait+0x12>
  803253:	ff 45 fc             	incl   -0x4(%ebp)
  803256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803259:	3b 45 08             	cmp    0x8(%ebp),%eax
  80325c:	72 f5                	jb     803253 <busy_wait+0xf>
	return i;
  80325e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803261:	c9                   	leave  
  803262:	c3                   	ret    
  803263:	90                   	nop

00803264 <__udivdi3>:
  803264:	55                   	push   %ebp
  803265:	57                   	push   %edi
  803266:	56                   	push   %esi
  803267:	53                   	push   %ebx
  803268:	83 ec 1c             	sub    $0x1c,%esp
  80326b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80326f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803273:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803277:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80327b:	89 ca                	mov    %ecx,%edx
  80327d:	89 f8                	mov    %edi,%eax
  80327f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803283:	85 f6                	test   %esi,%esi
  803285:	75 2d                	jne    8032b4 <__udivdi3+0x50>
  803287:	39 cf                	cmp    %ecx,%edi
  803289:	77 65                	ja     8032f0 <__udivdi3+0x8c>
  80328b:	89 fd                	mov    %edi,%ebp
  80328d:	85 ff                	test   %edi,%edi
  80328f:	75 0b                	jne    80329c <__udivdi3+0x38>
  803291:	b8 01 00 00 00       	mov    $0x1,%eax
  803296:	31 d2                	xor    %edx,%edx
  803298:	f7 f7                	div    %edi
  80329a:	89 c5                	mov    %eax,%ebp
  80329c:	31 d2                	xor    %edx,%edx
  80329e:	89 c8                	mov    %ecx,%eax
  8032a0:	f7 f5                	div    %ebp
  8032a2:	89 c1                	mov    %eax,%ecx
  8032a4:	89 d8                	mov    %ebx,%eax
  8032a6:	f7 f5                	div    %ebp
  8032a8:	89 cf                	mov    %ecx,%edi
  8032aa:	89 fa                	mov    %edi,%edx
  8032ac:	83 c4 1c             	add    $0x1c,%esp
  8032af:	5b                   	pop    %ebx
  8032b0:	5e                   	pop    %esi
  8032b1:	5f                   	pop    %edi
  8032b2:	5d                   	pop    %ebp
  8032b3:	c3                   	ret    
  8032b4:	39 ce                	cmp    %ecx,%esi
  8032b6:	77 28                	ja     8032e0 <__udivdi3+0x7c>
  8032b8:	0f bd fe             	bsr    %esi,%edi
  8032bb:	83 f7 1f             	xor    $0x1f,%edi
  8032be:	75 40                	jne    803300 <__udivdi3+0x9c>
  8032c0:	39 ce                	cmp    %ecx,%esi
  8032c2:	72 0a                	jb     8032ce <__udivdi3+0x6a>
  8032c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032c8:	0f 87 9e 00 00 00    	ja     80336c <__udivdi3+0x108>
  8032ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8032d3:	89 fa                	mov    %edi,%edx
  8032d5:	83 c4 1c             	add    $0x1c,%esp
  8032d8:	5b                   	pop    %ebx
  8032d9:	5e                   	pop    %esi
  8032da:	5f                   	pop    %edi
  8032db:	5d                   	pop    %ebp
  8032dc:	c3                   	ret    
  8032dd:	8d 76 00             	lea    0x0(%esi),%esi
  8032e0:	31 ff                	xor    %edi,%edi
  8032e2:	31 c0                	xor    %eax,%eax
  8032e4:	89 fa                	mov    %edi,%edx
  8032e6:	83 c4 1c             	add    $0x1c,%esp
  8032e9:	5b                   	pop    %ebx
  8032ea:	5e                   	pop    %esi
  8032eb:	5f                   	pop    %edi
  8032ec:	5d                   	pop    %ebp
  8032ed:	c3                   	ret    
  8032ee:	66 90                	xchg   %ax,%ax
  8032f0:	89 d8                	mov    %ebx,%eax
  8032f2:	f7 f7                	div    %edi
  8032f4:	31 ff                	xor    %edi,%edi
  8032f6:	89 fa                	mov    %edi,%edx
  8032f8:	83 c4 1c             	add    $0x1c,%esp
  8032fb:	5b                   	pop    %ebx
  8032fc:	5e                   	pop    %esi
  8032fd:	5f                   	pop    %edi
  8032fe:	5d                   	pop    %ebp
  8032ff:	c3                   	ret    
  803300:	bd 20 00 00 00       	mov    $0x20,%ebp
  803305:	89 eb                	mov    %ebp,%ebx
  803307:	29 fb                	sub    %edi,%ebx
  803309:	89 f9                	mov    %edi,%ecx
  80330b:	d3 e6                	shl    %cl,%esi
  80330d:	89 c5                	mov    %eax,%ebp
  80330f:	88 d9                	mov    %bl,%cl
  803311:	d3 ed                	shr    %cl,%ebp
  803313:	89 e9                	mov    %ebp,%ecx
  803315:	09 f1                	or     %esi,%ecx
  803317:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80331b:	89 f9                	mov    %edi,%ecx
  80331d:	d3 e0                	shl    %cl,%eax
  80331f:	89 c5                	mov    %eax,%ebp
  803321:	89 d6                	mov    %edx,%esi
  803323:	88 d9                	mov    %bl,%cl
  803325:	d3 ee                	shr    %cl,%esi
  803327:	89 f9                	mov    %edi,%ecx
  803329:	d3 e2                	shl    %cl,%edx
  80332b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80332f:	88 d9                	mov    %bl,%cl
  803331:	d3 e8                	shr    %cl,%eax
  803333:	09 c2                	or     %eax,%edx
  803335:	89 d0                	mov    %edx,%eax
  803337:	89 f2                	mov    %esi,%edx
  803339:	f7 74 24 0c          	divl   0xc(%esp)
  80333d:	89 d6                	mov    %edx,%esi
  80333f:	89 c3                	mov    %eax,%ebx
  803341:	f7 e5                	mul    %ebp
  803343:	39 d6                	cmp    %edx,%esi
  803345:	72 19                	jb     803360 <__udivdi3+0xfc>
  803347:	74 0b                	je     803354 <__udivdi3+0xf0>
  803349:	89 d8                	mov    %ebx,%eax
  80334b:	31 ff                	xor    %edi,%edi
  80334d:	e9 58 ff ff ff       	jmp    8032aa <__udivdi3+0x46>
  803352:	66 90                	xchg   %ax,%ax
  803354:	8b 54 24 08          	mov    0x8(%esp),%edx
  803358:	89 f9                	mov    %edi,%ecx
  80335a:	d3 e2                	shl    %cl,%edx
  80335c:	39 c2                	cmp    %eax,%edx
  80335e:	73 e9                	jae    803349 <__udivdi3+0xe5>
  803360:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803363:	31 ff                	xor    %edi,%edi
  803365:	e9 40 ff ff ff       	jmp    8032aa <__udivdi3+0x46>
  80336a:	66 90                	xchg   %ax,%ax
  80336c:	31 c0                	xor    %eax,%eax
  80336e:	e9 37 ff ff ff       	jmp    8032aa <__udivdi3+0x46>
  803373:	90                   	nop

00803374 <__umoddi3>:
  803374:	55                   	push   %ebp
  803375:	57                   	push   %edi
  803376:	56                   	push   %esi
  803377:	53                   	push   %ebx
  803378:	83 ec 1c             	sub    $0x1c,%esp
  80337b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80337f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803383:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803387:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80338b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80338f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803393:	89 f3                	mov    %esi,%ebx
  803395:	89 fa                	mov    %edi,%edx
  803397:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80339b:	89 34 24             	mov    %esi,(%esp)
  80339e:	85 c0                	test   %eax,%eax
  8033a0:	75 1a                	jne    8033bc <__umoddi3+0x48>
  8033a2:	39 f7                	cmp    %esi,%edi
  8033a4:	0f 86 a2 00 00 00    	jbe    80344c <__umoddi3+0xd8>
  8033aa:	89 c8                	mov    %ecx,%eax
  8033ac:	89 f2                	mov    %esi,%edx
  8033ae:	f7 f7                	div    %edi
  8033b0:	89 d0                	mov    %edx,%eax
  8033b2:	31 d2                	xor    %edx,%edx
  8033b4:	83 c4 1c             	add    $0x1c,%esp
  8033b7:	5b                   	pop    %ebx
  8033b8:	5e                   	pop    %esi
  8033b9:	5f                   	pop    %edi
  8033ba:	5d                   	pop    %ebp
  8033bb:	c3                   	ret    
  8033bc:	39 f0                	cmp    %esi,%eax
  8033be:	0f 87 ac 00 00 00    	ja     803470 <__umoddi3+0xfc>
  8033c4:	0f bd e8             	bsr    %eax,%ebp
  8033c7:	83 f5 1f             	xor    $0x1f,%ebp
  8033ca:	0f 84 ac 00 00 00    	je     80347c <__umoddi3+0x108>
  8033d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8033d5:	29 ef                	sub    %ebp,%edi
  8033d7:	89 fe                	mov    %edi,%esi
  8033d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033dd:	89 e9                	mov    %ebp,%ecx
  8033df:	d3 e0                	shl    %cl,%eax
  8033e1:	89 d7                	mov    %edx,%edi
  8033e3:	89 f1                	mov    %esi,%ecx
  8033e5:	d3 ef                	shr    %cl,%edi
  8033e7:	09 c7                	or     %eax,%edi
  8033e9:	89 e9                	mov    %ebp,%ecx
  8033eb:	d3 e2                	shl    %cl,%edx
  8033ed:	89 14 24             	mov    %edx,(%esp)
  8033f0:	89 d8                	mov    %ebx,%eax
  8033f2:	d3 e0                	shl    %cl,%eax
  8033f4:	89 c2                	mov    %eax,%edx
  8033f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033fa:	d3 e0                	shl    %cl,%eax
  8033fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803400:	8b 44 24 08          	mov    0x8(%esp),%eax
  803404:	89 f1                	mov    %esi,%ecx
  803406:	d3 e8                	shr    %cl,%eax
  803408:	09 d0                	or     %edx,%eax
  80340a:	d3 eb                	shr    %cl,%ebx
  80340c:	89 da                	mov    %ebx,%edx
  80340e:	f7 f7                	div    %edi
  803410:	89 d3                	mov    %edx,%ebx
  803412:	f7 24 24             	mull   (%esp)
  803415:	89 c6                	mov    %eax,%esi
  803417:	89 d1                	mov    %edx,%ecx
  803419:	39 d3                	cmp    %edx,%ebx
  80341b:	0f 82 87 00 00 00    	jb     8034a8 <__umoddi3+0x134>
  803421:	0f 84 91 00 00 00    	je     8034b8 <__umoddi3+0x144>
  803427:	8b 54 24 04          	mov    0x4(%esp),%edx
  80342b:	29 f2                	sub    %esi,%edx
  80342d:	19 cb                	sbb    %ecx,%ebx
  80342f:	89 d8                	mov    %ebx,%eax
  803431:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803435:	d3 e0                	shl    %cl,%eax
  803437:	89 e9                	mov    %ebp,%ecx
  803439:	d3 ea                	shr    %cl,%edx
  80343b:	09 d0                	or     %edx,%eax
  80343d:	89 e9                	mov    %ebp,%ecx
  80343f:	d3 eb                	shr    %cl,%ebx
  803441:	89 da                	mov    %ebx,%edx
  803443:	83 c4 1c             	add    $0x1c,%esp
  803446:	5b                   	pop    %ebx
  803447:	5e                   	pop    %esi
  803448:	5f                   	pop    %edi
  803449:	5d                   	pop    %ebp
  80344a:	c3                   	ret    
  80344b:	90                   	nop
  80344c:	89 fd                	mov    %edi,%ebp
  80344e:	85 ff                	test   %edi,%edi
  803450:	75 0b                	jne    80345d <__umoddi3+0xe9>
  803452:	b8 01 00 00 00       	mov    $0x1,%eax
  803457:	31 d2                	xor    %edx,%edx
  803459:	f7 f7                	div    %edi
  80345b:	89 c5                	mov    %eax,%ebp
  80345d:	89 f0                	mov    %esi,%eax
  80345f:	31 d2                	xor    %edx,%edx
  803461:	f7 f5                	div    %ebp
  803463:	89 c8                	mov    %ecx,%eax
  803465:	f7 f5                	div    %ebp
  803467:	89 d0                	mov    %edx,%eax
  803469:	e9 44 ff ff ff       	jmp    8033b2 <__umoddi3+0x3e>
  80346e:	66 90                	xchg   %ax,%ax
  803470:	89 c8                	mov    %ecx,%eax
  803472:	89 f2                	mov    %esi,%edx
  803474:	83 c4 1c             	add    $0x1c,%esp
  803477:	5b                   	pop    %ebx
  803478:	5e                   	pop    %esi
  803479:	5f                   	pop    %edi
  80347a:	5d                   	pop    %ebp
  80347b:	c3                   	ret    
  80347c:	3b 04 24             	cmp    (%esp),%eax
  80347f:	72 06                	jb     803487 <__umoddi3+0x113>
  803481:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803485:	77 0f                	ja     803496 <__umoddi3+0x122>
  803487:	89 f2                	mov    %esi,%edx
  803489:	29 f9                	sub    %edi,%ecx
  80348b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80348f:	89 14 24             	mov    %edx,(%esp)
  803492:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803496:	8b 44 24 04          	mov    0x4(%esp),%eax
  80349a:	8b 14 24             	mov    (%esp),%edx
  80349d:	83 c4 1c             	add    $0x1c,%esp
  8034a0:	5b                   	pop    %ebx
  8034a1:	5e                   	pop    %esi
  8034a2:	5f                   	pop    %edi
  8034a3:	5d                   	pop    %ebp
  8034a4:	c3                   	ret    
  8034a5:	8d 76 00             	lea    0x0(%esi),%esi
  8034a8:	2b 04 24             	sub    (%esp),%eax
  8034ab:	19 fa                	sbb    %edi,%edx
  8034ad:	89 d1                	mov    %edx,%ecx
  8034af:	89 c6                	mov    %eax,%esi
  8034b1:	e9 71 ff ff ff       	jmp    803427 <__umoddi3+0xb3>
  8034b6:	66 90                	xchg   %ax,%ax
  8034b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034bc:	72 ea                	jb     8034a8 <__umoddi3+0x134>
  8034be:	89 d9                	mov    %ebx,%ecx
  8034c0:	e9 62 ff ff ff       	jmp    803427 <__umoddi3+0xb3>
