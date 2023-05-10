
obj/user/tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 d8 03 00 00       	call   80040e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800075:	a1 20 50 80 00       	mov    0x805020,%eax
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
  80008d:	68 80 35 80 00       	push   $0x803580
  800092:	6a 12                	push   $0x12
  800094:	68 9c 35 80 00       	push   $0x80359c
  800099:	e8 ac 04 00 00       	call   80054a <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 82 16 00 00       	call   80172a <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 b8 35 80 00       	push   $0x8035b8
  8000b3:	e8 46 07 00 00       	call   8007fe <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 ec 35 80 00       	push   $0x8035ec
  8000c3:	e8 36 07 00 00       	call   8007fe <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 48 36 80 00       	push   $0x803648
  8000d3:	e8 26 07 00 00       	call   8007fe <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000db:	e8 3f 1d 00 00       	call   801e1f <sys_getenvid>
  8000e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int expected = 0;
  8000e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 7c 36 80 00       	push   $0x80367c
  8000f2:	e8 07 07 00 00       	call   8007fe <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ff:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800105:	a1 20 50 80 00       	mov    0x805020,%eax
  80010a:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800110:	89 c1                	mov    %eax,%ecx
  800112:	a1 20 50 80 00       	mov    0x805020,%eax
  800117:	8b 40 74             	mov    0x74(%eax),%eax
  80011a:	52                   	push   %edx
  80011b:	51                   	push   %ecx
  80011c:	50                   	push   %eax
  80011d:	68 bd 36 80 00       	push   $0x8036bd
  800122:	e8 a3 1c 00 00       	call   801dca <sys_create_env>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80012d:	a1 20 50 80 00       	mov    0x805020,%eax
  800132:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800138:	a1 20 50 80 00       	mov    0x805020,%eax
  80013d:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	a1 20 50 80 00       	mov    0x805020,%eax
  80014a:	8b 40 74             	mov    0x74(%eax),%eax
  80014d:	52                   	push   %edx
  80014e:	51                   	push   %ecx
  80014f:	50                   	push   %eax
  800150:	68 bd 36 80 00       	push   $0x8036bd
  800155:	e8 70 1c 00 00       	call   801dca <sys_create_env>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800160:	e8 f3 19 00 00       	call   801b58 <sys_calculate_free_frames>
  800165:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	68 00 10 00 00       	push   $0x1000
  800172:	68 c8 36 80 00       	push   $0x8036c8
  800177:	e8 fd 16 00 00       	call   801879 <smalloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		cprintf("Master env created x (1 page) \n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 cc 36 80 00       	push   $0x8036cc
  80018a:	e8 6f 06 00 00       	call   8007fe <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800192:	81 7d d8 00 00 00 80 	cmpl   $0x80000000,-0x28(%ebp)
  800199:	74 14                	je     8001af <_main+0x177>
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	68 ec 36 80 00       	push   $0x8036ec
  8001a3:	6a 27                	push   $0x27
  8001a5:	68 9c 35 80 00       	push   $0x80359c
  8001aa:	e8 9b 03 00 00       	call   80054a <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001af:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001b2:	e8 a1 19 00 00       	call   801b58 <sys_calculate_free_frames>
  8001b7:	29 c3                	sub    %eax,%ebx
  8001b9:	89 d8                	mov    %ebx,%eax
  8001bb:	83 f8 04             	cmp    $0x4,%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 58 37 80 00       	push   $0x803758
  8001c8:	6a 28                	push   $0x28
  8001ca:	68 9c 35 80 00       	push   $0x80359c
  8001cf:	e8 76 03 00 00       	call   80054a <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001d4:	e8 3d 1d 00 00       	call   801f16 <rsttst>

		sys_run_env(envIdSlave1);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001df:	e8 04 1c 00 00       	call   801de8 <sys_run_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	e8 f6 1b 00 00       	call   801de8 <sys_run_env>
  8001f2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 d6 37 80 00       	push   $0x8037d6
  8001fd:	e8 fc 05 00 00       	call   8007fe <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 b8 0b 00 00       	push   $0xbb8
  80020d:	e8 40 30 00 00       	call   803252 <env_sleep>
  800212:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800215:	90                   	nop
  800216:	e8 75 1d 00 00       	call   801f90 <gettst>
  80021b:	83 f8 02             	cmp    $0x2,%eax
  80021e:	75 f6                	jne    800216 <_main+0x1de>

		freeFrames = sys_calculate_free_frames() ;
  800220:	e8 33 19 00 00       	call   801b58 <sys_calculate_free_frames>
  800225:	89 45 dc             	mov    %eax,-0x24(%ebp)
		sfree(x);
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	e8 c5 17 00 00       	call   8019f8 <sfree>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 f0 37 80 00       	push   $0x8037f0
  80023e:	e8 bb 05 00 00       	call   8007fe <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800246:	e8 0d 19 00 00       	call   801b58 <sys_calculate_free_frames>
  80024b:	89 c2                	mov    %eax,%edx
  80024d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800250:	29 c2                	sub    %eax,%edx
  800252:	89 d0                	mov    %edx,%eax
  800254:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expected = (1+1) + (1+1);
  800257:	c7 45 e8 04 00 00 00 	movl   $0x4,-0x18(%ebp)
		if ( diff !=  expected) panic("Wrong free (diff=%d, expected=%d): revise your freeSharedObject logic\n", diff, expected);
  80025e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800261:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800264:	74 1a                	je     800280 <_main+0x248>
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	ff 75 e8             	pushl  -0x18(%ebp)
  80026c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80026f:	68 10 38 80 00       	push   $0x803810
  800274:	6a 3b                	push   $0x3b
  800276:	68 9c 35 80 00       	push   $0x80359c
  80027b:	e8 ca 02 00 00       	call   80054a <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 58 38 80 00       	push   $0x803858
  800288:	e8 71 05 00 00       	call   8007fe <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 7c 38 80 00       	push   $0x80387c
  800298:	e8 61 05 00 00       	call   8007fe <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002b6:	89 c1                	mov    %eax,%ecx
  8002b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bd:	8b 40 74             	mov    0x74(%eax),%eax
  8002c0:	52                   	push   %edx
  8002c1:	51                   	push   %ecx
  8002c2:	50                   	push   %eax
  8002c3:	68 ac 38 80 00       	push   $0x8038ac
  8002c8:	e8 fd 1a 00 00       	call   801dca <sys_create_env>
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d8:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002de:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e3:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002e9:	89 c1                	mov    %eax,%ecx
  8002eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f0:	8b 40 74             	mov    0x74(%eax),%eax
  8002f3:	52                   	push   %edx
  8002f4:	51                   	push   %ecx
  8002f5:	50                   	push   %eax
  8002f6:	68 b9 38 80 00       	push   $0x8038b9
  8002fb:	e8 ca 1a 00 00       	call   801dca <sys_create_env>
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	89 45 cc             	mov    %eax,-0x34(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	6a 01                	push   $0x1
  80030b:	68 00 10 00 00       	push   $0x1000
  800310:	68 c6 38 80 00       	push   $0x8038c6
  800315:	e8 5f 15 00 00       	call   801879 <smalloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created z (1 page) \n");
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 c8 38 80 00       	push   $0x8038c8
  800328:	e8 d1 04 00 00       	call   8007fe <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	6a 01                	push   $0x1
  800335:	68 00 10 00 00       	push   $0x1000
  80033a:	68 c8 36 80 00       	push   $0x8036c8
  80033f:	e8 35 15 00 00       	call   801879 <smalloc>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("Master env created x (1 page) \n");
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	68 cc 36 80 00       	push   $0x8036cc
  800352:	e8 a7 04 00 00       	call   8007fe <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80035a:	e8 b7 1b 00 00       	call   801f16 <rsttst>

		sys_run_env(envIdSlaveB1);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d0             	pushl  -0x30(%ebp)
  800365:	e8 7e 1a 00 00       	call   801de8 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	ff 75 cc             	pushl  -0x34(%ebp)
  800373:	e8 70 1a 00 00       	call   801de8 <sys_run_env>
  800378:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  80037b:	90                   	nop
  80037c:	e8 0f 1c 00 00       	call   801f90 <gettst>
  800381:	83 f8 02             	cmp    $0x2,%eax
  800384:	75 f6                	jne    80037c <_main+0x344>
		}

		rsttst();
  800386:	e8 8b 1b 00 00       	call   801f16 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  80038b:	e8 c8 17 00 00       	call   801b58 <sys_calculate_free_frames>
  800390:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(z);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 c8             	pushl  -0x38(%ebp)
  800399:	e8 5a 16 00 00       	call   8019f8 <sfree>
  80039e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 e8 38 80 00       	push   $0x8038e8
  8003a9:	e8 50 04 00 00       	call   8007fe <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003b7:	e8 3c 16 00 00       	call   8019f8 <sfree>
  8003bc:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 fe 38 80 00       	push   $0x8038fe
  8003c7:	e8 32 04 00 00       	call   8007fe <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003cf:	e8 84 17 00 00       	call   801b58 <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003d9:	29 c2                	sub    %eax,%edx
  8003db:	89 d0                	mov    %edx,%eax
  8003dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
		expected = 1;
  8003e0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
		if (diff !=  expected) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ea:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8003ed:	74 14                	je     800403 <_main+0x3cb>
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	68 14 39 80 00       	push   $0x803914
  8003f7:	6a 62                	push   $0x62
  8003f9:	68 9c 35 80 00       	push   $0x80359c
  8003fe:	e8 47 01 00 00       	call   80054a <_panic>

		//To indicate that it's completed successfully
		inctst();
  800403:	e8 6e 1b 00 00       	call   801f76 <inctst>


	}


	return;
  800408:	90                   	nop
}
  800409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800414:	e8 1f 1a 00 00       	call   801e38 <sys_getenvindex>
  800419:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80041c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	01 c0                	add    %eax,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800431:	01 d0                	add    %edx,%eax
  800433:	c1 e0 04             	shl    $0x4,%eax
  800436:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800440:	a1 20 50 80 00       	mov    0x805020,%eax
  800445:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044b:	84 c0                	test   %al,%al
  80044d:	74 0f                	je     80045e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80044f:	a1 20 50 80 00       	mov    0x805020,%eax
  800454:	05 5c 05 00 00       	add    $0x55c,%eax
  800459:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800462:	7e 0a                	jle    80046e <libmain+0x60>
		binaryname = argv[0];
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	ff 75 0c             	pushl  0xc(%ebp)
  800474:	ff 75 08             	pushl  0x8(%ebp)
  800477:	e8 bc fb ff ff       	call   800038 <_main>
  80047c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80047f:	e8 c1 17 00 00       	call   801c45 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	68 d4 39 80 00       	push   $0x8039d4
  80048c:	e8 6d 03 00 00       	call   8007fe <cprintf>
  800491:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800494:	a1 20 50 80 00       	mov    0x805020,%eax
  800499:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80049f:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	52                   	push   %edx
  8004ae:	50                   	push   %eax
  8004af:	68 fc 39 80 00       	push   $0x8039fc
  8004b4:	e8 45 03 00 00       	call   8007fe <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004cc:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004dd:	51                   	push   %ecx
  8004de:	52                   	push   %edx
  8004df:	50                   	push   %eax
  8004e0:	68 24 3a 80 00       	push   $0x803a24
  8004e5:	e8 14 03 00 00       	call   8007fe <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	50                   	push   %eax
  8004fc:	68 7c 3a 80 00       	push   $0x803a7c
  800501:	e8 f8 02 00 00       	call   8007fe <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	68 d4 39 80 00       	push   $0x8039d4
  800511:	e8 e8 02 00 00       	call   8007fe <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800519:	e8 41 17 00 00       	call   801c5f <sys_enable_interrupt>

	// exit gracefully
	exit();
  80051e:	e8 19 00 00 00       	call   80053c <exit>
}
  800523:	90                   	nop
  800524:	c9                   	leave  
  800525:	c3                   	ret    

00800526 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800526:	55                   	push   %ebp
  800527:	89 e5                	mov    %esp,%ebp
  800529:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80052c:	83 ec 0c             	sub    $0xc,%esp
  80052f:	6a 00                	push   $0x0
  800531:	e8 ce 18 00 00       	call   801e04 <sys_destroy_env>
  800536:	83 c4 10             	add    $0x10,%esp
}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <exit>:

void
exit(void)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800542:	e8 23 19 00 00       	call   801e6a <sys_exit_env>
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800550:	8d 45 10             	lea    0x10(%ebp),%eax
  800553:	83 c0 04             	add    $0x4,%eax
  800556:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800559:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80055e:	85 c0                	test   %eax,%eax
  800560:	74 16                	je     800578 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800562:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	50                   	push   %eax
  80056b:	68 90 3a 80 00       	push   $0x803a90
  800570:	e8 89 02 00 00       	call   8007fe <cprintf>
  800575:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800578:	a1 00 50 80 00       	mov    0x805000,%eax
  80057d:	ff 75 0c             	pushl  0xc(%ebp)
  800580:	ff 75 08             	pushl  0x8(%ebp)
  800583:	50                   	push   %eax
  800584:	68 95 3a 80 00       	push   $0x803a95
  800589:	e8 70 02 00 00       	call   8007fe <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800591:	8b 45 10             	mov    0x10(%ebp),%eax
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	ff 75 f4             	pushl  -0xc(%ebp)
  80059a:	50                   	push   %eax
  80059b:	e8 f3 01 00 00       	call   800793 <vcprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	6a 00                	push   $0x0
  8005a8:	68 b1 3a 80 00       	push   $0x803ab1
  8005ad:	e8 e1 01 00 00       	call   800793 <vcprintf>
  8005b2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005b5:	e8 82 ff ff ff       	call   80053c <exit>

	// should not return here
	while (1) ;
  8005ba:	eb fe                	jmp    8005ba <_panic+0x70>

008005bc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c7:	8b 50 74             	mov    0x74(%eax),%edx
  8005ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	74 14                	je     8005e5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	68 b4 3a 80 00       	push   $0x803ab4
  8005d9:	6a 26                	push   $0x26
  8005db:	68 00 3b 80 00       	push   $0x803b00
  8005e0:	e8 65 ff ff ff       	call   80054a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005f3:	e9 c2 00 00 00       	jmp    8006ba <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	01 d0                	add    %edx,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	85 c0                	test   %eax,%eax
  80060b:	75 08                	jne    800615 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80060d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800610:	e9 a2 00 00 00       	jmp    8006b7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800615:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800623:	eb 69                	jmp    80068e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800630:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	84 c0                	test   %al,%al
  800643:	75 46                	jne    80068b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800645:	a1 20 50 80 00       	mov    0x805020,%eax
  80064a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800650:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800653:	89 d0                	mov    %edx,%eax
  800655:	01 c0                	add    %eax,%eax
  800657:	01 d0                	add    %edx,%eax
  800659:	c1 e0 03             	shl    $0x3,%eax
  80065c:	01 c8                	add    %ecx,%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800663:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800666:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80066b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800670:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	01 c8                	add    %ecx,%eax
  80067c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80067e:	39 c2                	cmp    %eax,%edx
  800680:	75 09                	jne    80068b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800682:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800689:	eb 12                	jmp    80069d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80068b:	ff 45 e8             	incl   -0x18(%ebp)
  80068e:	a1 20 50 80 00       	mov    0x805020,%eax
  800693:	8b 50 74             	mov    0x74(%eax),%edx
  800696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800699:	39 c2                	cmp    %eax,%edx
  80069b:	77 88                	ja     800625 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80069d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006a1:	75 14                	jne    8006b7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	68 0c 3b 80 00       	push   $0x803b0c
  8006ab:	6a 3a                	push   $0x3a
  8006ad:	68 00 3b 80 00       	push   $0x803b00
  8006b2:	e8 93 fe ff ff       	call   80054a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006b7:	ff 45 f0             	incl   -0x10(%ebp)
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006c0:	0f 8c 32 ff ff ff    	jl     8005f8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006d4:	eb 26                	jmp    8006fc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006db:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	01 c0                	add    %eax,%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	c1 e0 03             	shl    $0x3,%eax
  8006ed:	01 c8                	add    %ecx,%eax
  8006ef:	8a 40 04             	mov    0x4(%eax),%al
  8006f2:	3c 01                	cmp    $0x1,%al
  8006f4:	75 03                	jne    8006f9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8006f6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f9:	ff 45 e0             	incl   -0x20(%ebp)
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 50 74             	mov    0x74(%eax),%edx
  800704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800707:	39 c2                	cmp    %eax,%edx
  800709:	77 cb                	ja     8006d6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80070b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800711:	74 14                	je     800727 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800713:	83 ec 04             	sub    $0x4,%esp
  800716:	68 60 3b 80 00       	push   $0x803b60
  80071b:	6a 44                	push   $0x44
  80071d:	68 00 3b 80 00       	push   $0x803b00
  800722:	e8 23 fe ff ff       	call   80054a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800727:	90                   	nop
  800728:	c9                   	leave  
  800729:	c3                   	ret    

0080072a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800730:	8b 45 0c             	mov    0xc(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	8d 48 01             	lea    0x1(%eax),%ecx
  800738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073b:	89 0a                	mov    %ecx,(%edx)
  80073d:	8b 55 08             	mov    0x8(%ebp),%edx
  800740:	88 d1                	mov    %dl,%cl
  800742:	8b 55 0c             	mov    0xc(%ebp),%edx
  800745:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800753:	75 2c                	jne    800781 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800755:	a0 24 50 80 00       	mov    0x805024,%al
  80075a:	0f b6 c0             	movzbl %al,%eax
  80075d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800760:	8b 12                	mov    (%edx),%edx
  800762:	89 d1                	mov    %edx,%ecx
  800764:	8b 55 0c             	mov    0xc(%ebp),%edx
  800767:	83 c2 08             	add    $0x8,%edx
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	50                   	push   %eax
  80076e:	51                   	push   %ecx
  80076f:	52                   	push   %edx
  800770:	e8 22 13 00 00       	call   801a97 <sys_cputs>
  800775:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800781:	8b 45 0c             	mov    0xc(%ebp),%eax
  800784:	8b 40 04             	mov    0x4(%eax),%eax
  800787:	8d 50 01             	lea    0x1(%eax),%edx
  80078a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800790:	90                   	nop
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80079c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a3:	00 00 00 
	b.cnt = 0;
  8007a6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007ad:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	ff 75 08             	pushl  0x8(%ebp)
  8007b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007bc:	50                   	push   %eax
  8007bd:	68 2a 07 80 00       	push   $0x80072a
  8007c2:	e8 11 02 00 00       	call   8009d8 <vprintfmt>
  8007c7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007ca:	a0 24 50 80 00       	mov    0x805024,%al
  8007cf:	0f b6 c0             	movzbl %al,%eax
  8007d2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007d8:	83 ec 04             	sub    $0x4,%esp
  8007db:	50                   	push   %eax
  8007dc:	52                   	push   %edx
  8007dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e3:	83 c0 08             	add    $0x8,%eax
  8007e6:	50                   	push   %eax
  8007e7:	e8 ab 12 00 00       	call   801a97 <sys_cputs>
  8007ec:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007ef:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8007f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007fc:	c9                   	leave  
  8007fd:	c3                   	ret    

008007fe <cprintf>:

int cprintf(const char *fmt, ...) {
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800804:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80080b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80080e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 f4             	pushl  -0xc(%ebp)
  80081a:	50                   	push   %eax
  80081b:	e8 73 ff ff ff       	call   800793 <vcprintf>
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800826:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800831:	e8 0f 14 00 00       	call   801c45 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800836:	8d 45 0c             	lea    0xc(%ebp),%eax
  800839:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 f4             	pushl  -0xc(%ebp)
  800845:	50                   	push   %eax
  800846:	e8 48 ff ff ff       	call   800793 <vcprintf>
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800851:	e8 09 14 00 00       	call   801c5f <sys_enable_interrupt>
	return cnt;
  800856:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	83 ec 14             	sub    $0x14,%esp
  800862:	8b 45 10             	mov    0x10(%ebp),%eax
  800865:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80086e:	8b 45 18             	mov    0x18(%ebp),%eax
  800871:	ba 00 00 00 00       	mov    $0x0,%edx
  800876:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800879:	77 55                	ja     8008d0 <printnum+0x75>
  80087b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80087e:	72 05                	jb     800885 <printnum+0x2a>
  800880:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800883:	77 4b                	ja     8008d0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800885:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800888:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80088b:	8b 45 18             	mov    0x18(%ebp),%eax
  80088e:	ba 00 00 00 00       	mov    $0x0,%edx
  800893:	52                   	push   %edx
  800894:	50                   	push   %eax
  800895:	ff 75 f4             	pushl  -0xc(%ebp)
  800898:	ff 75 f0             	pushl  -0x10(%ebp)
  80089b:	e8 68 2a 00 00       	call   803308 <__udivdi3>
  8008a0:	83 c4 10             	add    $0x10,%esp
  8008a3:	83 ec 04             	sub    $0x4,%esp
  8008a6:	ff 75 20             	pushl  0x20(%ebp)
  8008a9:	53                   	push   %ebx
  8008aa:	ff 75 18             	pushl  0x18(%ebp)
  8008ad:	52                   	push   %edx
  8008ae:	50                   	push   %eax
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	ff 75 08             	pushl  0x8(%ebp)
  8008b5:	e8 a1 ff ff ff       	call   80085b <printnum>
  8008ba:	83 c4 20             	add    $0x20,%esp
  8008bd:	eb 1a                	jmp    8008d9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	ff 75 20             	pushl  0x20(%ebp)
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008d0:	ff 4d 1c             	decl   0x1c(%ebp)
  8008d3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008d7:	7f e6                	jg     8008bf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008d9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e7:	53                   	push   %ebx
  8008e8:	51                   	push   %ecx
  8008e9:	52                   	push   %edx
  8008ea:	50                   	push   %eax
  8008eb:	e8 28 2b 00 00       	call   803418 <__umoddi3>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	05 d4 3d 80 00       	add    $0x803dd4,%eax
  8008f8:	8a 00                	mov    (%eax),%al
  8008fa:	0f be c0             	movsbl %al,%eax
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	50                   	push   %eax
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
}
  80090c:	90                   	nop
  80090d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800915:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800919:	7e 1c                	jle    800937 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 08             	lea    0x8(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 08             	sub    $0x8,%eax
  800930:	8b 50 04             	mov    0x4(%eax),%edx
  800933:	8b 00                	mov    (%eax),%eax
  800935:	eb 40                	jmp    800977 <getuint+0x65>
	else if (lflag)
  800937:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093b:	74 1e                	je     80095b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	8d 50 04             	lea    0x4(%eax),%edx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 10                	mov    %edx,(%eax)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	ba 00 00 00 00       	mov    $0x0,%edx
  800959:	eb 1c                	jmp    800977 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	8d 50 04             	lea    0x4(%eax),%edx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	89 10                	mov    %edx,(%eax)
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800980:	7e 1c                	jle    80099e <getint+0x25>
		return va_arg(*ap, long long);
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	8d 50 08             	lea    0x8(%eax),%edx
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	89 10                	mov    %edx,(%eax)
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	83 e8 08             	sub    $0x8,%eax
  800997:	8b 50 04             	mov    0x4(%eax),%edx
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	eb 38                	jmp    8009d6 <getint+0x5d>
	else if (lflag)
  80099e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a2:	74 1a                	je     8009be <getint+0x45>
		return va_arg(*ap, long);
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	8d 50 04             	lea    0x4(%eax),%edx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	89 10                	mov    %edx,(%eax)
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	99                   	cltd   
  8009bc:	eb 18                	jmp    8009d6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	8d 50 04             	lea    0x4(%eax),%edx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	89 10                	mov    %edx,(%eax)
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	83 e8 04             	sub    $0x4,%eax
  8009d3:	8b 00                	mov    (%eax),%eax
  8009d5:	99                   	cltd   
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e0:	eb 17                	jmp    8009f9 <vprintfmt+0x21>
			if (ch == '\0')
  8009e2:	85 db                	test   %ebx,%ebx
  8009e4:	0f 84 af 03 00 00    	je     800d99 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	53                   	push   %ebx
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	8d 50 01             	lea    0x1(%eax),%edx
  8009ff:	89 55 10             	mov    %edx,0x10(%ebp)
  800a02:	8a 00                	mov    (%eax),%al
  800a04:	0f b6 d8             	movzbl %al,%ebx
  800a07:	83 fb 25             	cmp    $0x25,%ebx
  800a0a:	75 d6                	jne    8009e2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a0c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a10:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a17:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2f:	8d 50 01             	lea    0x1(%eax),%edx
  800a32:	89 55 10             	mov    %edx,0x10(%ebp)
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	0f b6 d8             	movzbl %al,%ebx
  800a3a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a3d:	83 f8 55             	cmp    $0x55,%eax
  800a40:	0f 87 2b 03 00 00    	ja     800d71 <vprintfmt+0x399>
  800a46:	8b 04 85 f8 3d 80 00 	mov    0x803df8(,%eax,4),%eax
  800a4d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a4f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a53:	eb d7                	jmp    800a2c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a55:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a59:	eb d1                	jmp    800a2c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a5b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a65:	89 d0                	mov    %edx,%eax
  800a67:	c1 e0 02             	shl    $0x2,%eax
  800a6a:	01 d0                	add    %edx,%eax
  800a6c:	01 c0                	add    %eax,%eax
  800a6e:	01 d8                	add    %ebx,%eax
  800a70:	83 e8 30             	sub    $0x30,%eax
  800a73:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a76:	8b 45 10             	mov    0x10(%ebp),%eax
  800a79:	8a 00                	mov    (%eax),%al
  800a7b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a7e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a81:	7e 3e                	jle    800ac1 <vprintfmt+0xe9>
  800a83:	83 fb 39             	cmp    $0x39,%ebx
  800a86:	7f 39                	jg     800ac1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a88:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a8b:	eb d5                	jmp    800a62 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 c0 04             	add    $0x4,%eax
  800a93:	89 45 14             	mov    %eax,0x14(%ebp)
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	83 e8 04             	sub    $0x4,%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aa3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa7:	79 83                	jns    800a2c <vprintfmt+0x54>
				width = 0;
  800aa9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ab0:	e9 77 ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ab5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800abc:	e9 6b ff ff ff       	jmp    800a2c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ac1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac6:	0f 89 60 ff ff ff    	jns    800a2c <vprintfmt+0x54>
				width = precision, precision = -1;
  800acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ad9:	e9 4e ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ade:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ae1:	e9 46 ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ae6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae9:	83 c0 04             	add    $0x4,%eax
  800aec:	89 45 14             	mov    %eax,0x14(%ebp)
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	50                   	push   %eax
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			break;
  800b06:	e9 89 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 c0 04             	add    $0x4,%eax
  800b11:	89 45 14             	mov    %eax,0x14(%ebp)
  800b14:	8b 45 14             	mov    0x14(%ebp),%eax
  800b17:	83 e8 04             	sub    $0x4,%eax
  800b1a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b1c:	85 db                	test   %ebx,%ebx
  800b1e:	79 02                	jns    800b22 <vprintfmt+0x14a>
				err = -err;
  800b20:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b22:	83 fb 64             	cmp    $0x64,%ebx
  800b25:	7f 0b                	jg     800b32 <vprintfmt+0x15a>
  800b27:	8b 34 9d 40 3c 80 00 	mov    0x803c40(,%ebx,4),%esi
  800b2e:	85 f6                	test   %esi,%esi
  800b30:	75 19                	jne    800b4b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b32:	53                   	push   %ebx
  800b33:	68 e5 3d 80 00       	push   $0x803de5
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	ff 75 08             	pushl  0x8(%ebp)
  800b3e:	e8 5e 02 00 00       	call   800da1 <printfmt>
  800b43:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b46:	e9 49 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b4b:	56                   	push   %esi
  800b4c:	68 ee 3d 80 00       	push   $0x803dee
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	ff 75 08             	pushl  0x8(%ebp)
  800b57:	e8 45 02 00 00       	call   800da1 <printfmt>
  800b5c:	83 c4 10             	add    $0x10,%esp
			break;
  800b5f:	e9 30 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b64:	8b 45 14             	mov    0x14(%ebp),%eax
  800b67:	83 c0 04             	add    $0x4,%eax
  800b6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b70:	83 e8 04             	sub    $0x4,%eax
  800b73:	8b 30                	mov    (%eax),%esi
  800b75:	85 f6                	test   %esi,%esi
  800b77:	75 05                	jne    800b7e <vprintfmt+0x1a6>
				p = "(null)";
  800b79:	be f1 3d 80 00       	mov    $0x803df1,%esi
			if (width > 0 && padc != '-')
  800b7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b82:	7e 6d                	jle    800bf1 <vprintfmt+0x219>
  800b84:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b88:	74 67                	je     800bf1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	50                   	push   %eax
  800b91:	56                   	push   %esi
  800b92:	e8 0c 03 00 00       	call   800ea3 <strnlen>
  800b97:	83 c4 10             	add    $0x10,%esp
  800b9a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b9d:	eb 16                	jmp    800bb5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b9f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	50                   	push   %eax
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb9:	7f e4                	jg     800b9f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbb:	eb 34                	jmp    800bf1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bc1:	74 1c                	je     800bdf <vprintfmt+0x207>
  800bc3:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc6:	7e 05                	jle    800bcd <vprintfmt+0x1f5>
  800bc8:	83 fb 7e             	cmp    $0x7e,%ebx
  800bcb:	7e 12                	jle    800bdf <vprintfmt+0x207>
					putch('?', putdat);
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	6a 3f                	push   $0x3f
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	ff d0                	call   *%eax
  800bda:	83 c4 10             	add    $0x10,%esp
  800bdd:	eb 0f                	jmp    800bee <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	53                   	push   %ebx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bee:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf1:	89 f0                	mov    %esi,%eax
  800bf3:	8d 70 01             	lea    0x1(%eax),%esi
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	0f be d8             	movsbl %al,%ebx
  800bfb:	85 db                	test   %ebx,%ebx
  800bfd:	74 24                	je     800c23 <vprintfmt+0x24b>
  800bff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c03:	78 b8                	js     800bbd <vprintfmt+0x1e5>
  800c05:	ff 4d e0             	decl   -0x20(%ebp)
  800c08:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c0c:	79 af                	jns    800bbd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0e:	eb 13                	jmp    800c23 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 20                	push   $0x20
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c20:	ff 4d e4             	decl   -0x1c(%ebp)
  800c23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c27:	7f e7                	jg     800c10 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c29:	e9 66 01 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 e8             	pushl  -0x18(%ebp)
  800c34:	8d 45 14             	lea    0x14(%ebp),%eax
  800c37:	50                   	push   %eax
  800c38:	e8 3c fd ff ff       	call   800979 <getint>
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4c:	85 d2                	test   %edx,%edx
  800c4e:	79 23                	jns    800c73 <vprintfmt+0x29b>
				putch('-', putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	6a 2d                	push   $0x2d
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c66:	f7 d8                	neg    %eax
  800c68:	83 d2 00             	adc    $0x0,%edx
  800c6b:	f7 da                	neg    %edx
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c7a:	e9 bc 00 00 00       	jmp    800d3b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 e8             	pushl  -0x18(%ebp)
  800c85:	8d 45 14             	lea    0x14(%ebp),%eax
  800c88:	50                   	push   %eax
  800c89:	e8 84 fc ff ff       	call   800912 <getuint>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c9e:	e9 98 00 00 00       	jmp    800d3b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	6a 58                	push   $0x58
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff d0                	call   *%eax
  800cb0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 0c             	pushl  0xc(%ebp)
  800cb9:	6a 58                	push   $0x58
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	6a 58                	push   $0x58
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	ff d0                	call   *%eax
  800cd0:	83 c4 10             	add    $0x10,%esp
			break;
  800cd3:	e9 bc 00 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cd8:	83 ec 08             	sub    $0x8,%esp
  800cdb:	ff 75 0c             	pushl  0xc(%ebp)
  800cde:	6a 30                	push   $0x30
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	ff d0                	call   *%eax
  800ce5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	6a 78                	push   $0x78
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	ff d0                	call   *%eax
  800cf5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfb:	83 c0 04             	add    $0x4,%eax
  800cfe:	89 45 14             	mov    %eax,0x14(%ebp)
  800d01:	8b 45 14             	mov    0x14(%ebp),%eax
  800d04:	83 e8 04             	sub    $0x4,%eax
  800d07:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d1a:	eb 1f                	jmp    800d3b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 e8             	pushl  -0x18(%ebp)
  800d22:	8d 45 14             	lea    0x14(%ebp),%eax
  800d25:	50                   	push   %eax
  800d26:	e8 e7 fb ff ff       	call   800912 <getuint>
  800d2b:	83 c4 10             	add    $0x10,%esp
  800d2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d31:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d34:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d3b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	52                   	push   %edx
  800d46:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d49:	50                   	push   %eax
  800d4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4d:	ff 75 f0             	pushl  -0x10(%ebp)
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	ff 75 08             	pushl  0x8(%ebp)
  800d56:	e8 00 fb ff ff       	call   80085b <printnum>
  800d5b:	83 c4 20             	add    $0x20,%esp
			break;
  800d5e:	eb 34                	jmp    800d94 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d60:	83 ec 08             	sub    $0x8,%esp
  800d63:	ff 75 0c             	pushl  0xc(%ebp)
  800d66:	53                   	push   %ebx
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	ff d0                	call   *%eax
  800d6c:	83 c4 10             	add    $0x10,%esp
			break;
  800d6f:	eb 23                	jmp    800d94 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d71:	83 ec 08             	sub    $0x8,%esp
  800d74:	ff 75 0c             	pushl  0xc(%ebp)
  800d77:	6a 25                	push   $0x25
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	ff d0                	call   *%eax
  800d7e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d81:	ff 4d 10             	decl   0x10(%ebp)
  800d84:	eb 03                	jmp    800d89 <vprintfmt+0x3b1>
  800d86:	ff 4d 10             	decl   0x10(%ebp)
  800d89:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8c:	48                   	dec    %eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	3c 25                	cmp    $0x25,%al
  800d91:	75 f3                	jne    800d86 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d93:	90                   	nop
		}
	}
  800d94:	e9 47 fc ff ff       	jmp    8009e0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d99:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800da7:	8d 45 10             	lea    0x10(%ebp),%eax
  800daa:	83 c0 04             	add    $0x4,%eax
  800dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	ff 75 f4             	pushl  -0xc(%ebp)
  800db6:	50                   	push   %eax
  800db7:	ff 75 0c             	pushl  0xc(%ebp)
  800dba:	ff 75 08             	pushl  0x8(%ebp)
  800dbd:	e8 16 fc ff ff       	call   8009d8 <vprintfmt>
  800dc2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dc5:	90                   	nop
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	8b 40 08             	mov    0x8(%eax),%eax
  800dd1:	8d 50 01             	lea    0x1(%eax),%edx
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8b 10                	mov    (%eax),%edx
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	8b 40 04             	mov    0x4(%eax),%eax
  800de5:	39 c2                	cmp    %eax,%edx
  800de7:	73 12                	jae    800dfb <sprintputch+0x33>
		*b->buf++ = ch;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	8b 00                	mov    (%eax),%eax
  800dee:	8d 48 01             	lea    0x1(%eax),%ecx
  800df1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df4:	89 0a                	mov    %ecx,(%edx)
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	88 10                	mov    %dl,(%eax)
}
  800dfb:	90                   	nop
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    

00800dfe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e23:	74 06                	je     800e2b <vsnprintf+0x2d>
  800e25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e29:	7f 07                	jg     800e32 <vsnprintf+0x34>
		return -E_INVAL;
  800e2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e30:	eb 20                	jmp    800e52 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e32:	ff 75 14             	pushl  0x14(%ebp)
  800e35:	ff 75 10             	pushl  0x10(%ebp)
  800e38:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e3b:	50                   	push   %eax
  800e3c:	68 c8 0d 80 00       	push   $0x800dc8
  800e41:	e8 92 fb ff ff       	call   8009d8 <vprintfmt>
  800e46:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e4c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e5a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e5d:	83 c0 04             	add    $0x4,%eax
  800e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	ff 75 f4             	pushl  -0xc(%ebp)
  800e69:	50                   	push   %eax
  800e6a:	ff 75 0c             	pushl  0xc(%ebp)
  800e6d:	ff 75 08             	pushl  0x8(%ebp)
  800e70:	e8 89 ff ff ff       	call   800dfe <vsnprintf>
  800e75:	83 c4 10             	add    $0x10,%esp
  800e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8d:	eb 06                	jmp    800e95 <strlen+0x15>
		n++;
  800e8f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e92:	ff 45 08             	incl   0x8(%ebp)
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	84 c0                	test   %al,%al
  800e9c:	75 f1                	jne    800e8f <strlen+0xf>
		n++;
	return n;
  800e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb0:	eb 09                	jmp    800ebb <strnlen+0x18>
		n++;
  800eb2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb5:	ff 45 08             	incl   0x8(%ebp)
  800eb8:	ff 4d 0c             	decl   0xc(%ebp)
  800ebb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebf:	74 09                	je     800eca <strnlen+0x27>
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	84 c0                	test   %al,%al
  800ec8:	75 e8                	jne    800eb2 <strnlen+0xf>
		n++;
	return n;
  800eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800edb:	90                   	nop
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8d 50 01             	lea    0x1(%eax),%edx
  800ee2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eeb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eee:	8a 12                	mov    (%edx),%dl
  800ef0:	88 10                	mov    %dl,(%eax)
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	84 c0                	test   %al,%al
  800ef6:	75 e4                	jne    800edc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f10:	eb 1f                	jmp    800f31 <strncpy+0x34>
		*dst++ = *src;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8d 50 01             	lea    0x1(%eax),%edx
  800f18:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1e:	8a 12                	mov    (%edx),%dl
  800f20:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	84 c0                	test   %al,%al
  800f29:	74 03                	je     800f2e <strncpy+0x31>
			src++;
  800f2b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f2e:	ff 45 fc             	incl   -0x4(%ebp)
  800f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f34:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f37:	72 d9                	jb     800f12 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4e:	74 30                	je     800f80 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f50:	eb 16                	jmp    800f68 <strlcpy+0x2a>
			*dst++ = *src++;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 08             	mov    %edx,0x8(%ebp)
  800f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f68:	ff 4d 10             	decl   0x10(%ebp)
  800f6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6f:	74 09                	je     800f7a <strlcpy+0x3c>
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 d8                	jne    800f52 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f86:	29 c2                	sub    %eax,%edx
  800f88:	89 d0                	mov    %edx,%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f8f:	eb 06                	jmp    800f97 <strcmp+0xb>
		p++, q++;
  800f91:	ff 45 08             	incl   0x8(%ebp)
  800f94:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	84 c0                	test   %al,%al
  800f9e:	74 0e                	je     800fae <strcmp+0x22>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 10                	mov    (%eax),%dl
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	38 c2                	cmp    %al,%dl
  800fac:	74 e3                	je     800f91 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f b6 d0             	movzbl %al,%edx
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f b6 c0             	movzbl %al,%eax
  800fbe:	29 c2                	sub    %eax,%edx
  800fc0:	89 d0                	mov    %edx,%eax
}
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fc7:	eb 09                	jmp    800fd2 <strncmp+0xe>
		n--, p++, q++;
  800fc9:	ff 4d 10             	decl   0x10(%ebp)
  800fcc:	ff 45 08             	incl   0x8(%ebp)
  800fcf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd6:	74 17                	je     800fef <strncmp+0x2b>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	84 c0                	test   %al,%al
  800fdf:	74 0e                	je     800fef <strncmp+0x2b>
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 10                	mov    (%eax),%dl
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	38 c2                	cmp    %al,%dl
  800fed:	74 da                	je     800fc9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff3:	75 07                	jne    800ffc <strncmp+0x38>
		return 0;
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffa:	eb 14                	jmp    801010 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f b6 d0             	movzbl %al,%edx
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	0f b6 c0             	movzbl %al,%eax
  80100c:	29 c2                	sub    %eax,%edx
  80100e:	89 d0                	mov    %edx,%eax
}
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 04             	sub    $0x4,%esp
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101e:	eb 12                	jmp    801032 <strchr+0x20>
		if (*s == c)
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801028:	75 05                	jne    80102f <strchr+0x1d>
			return (char *) s;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	eb 11                	jmp    801040 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	84 c0                	test   %al,%al
  801039:	75 e5                	jne    801020 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80104e:	eb 0d                	jmp    80105d <strfind+0x1b>
		if (*s == c)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801058:	74 0e                	je     801068 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	84 c0                	test   %al,%al
  801064:	75 ea                	jne    801050 <strfind+0xe>
  801066:	eb 01                	jmp    801069 <strfind+0x27>
		if (*s == c)
			break;
  801068:	90                   	nop
	return (char *) s;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80107a:	8b 45 10             	mov    0x10(%ebp),%eax
  80107d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801080:	eb 0e                	jmp    801090 <memset+0x22>
		*p++ = c;
  801082:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80108b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801090:	ff 4d f8             	decl   -0x8(%ebp)
  801093:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801097:	79 e9                	jns    801082 <memset+0x14>
		*p++ = c;

	return v;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010b0:	eb 16                	jmp    8010c8 <memcpy+0x2a>
		*d++ = *s++;
  8010b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b5:	8d 50 01             	lea    0x1(%eax),%edx
  8010b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010c4:	8a 12                	mov    (%edx),%dl
  8010c6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	75 dd                	jne    8010b2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f2:	73 50                	jae    801144 <memmove+0x6a>
  8010f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	01 d0                	add    %edx,%eax
  8010fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ff:	76 43                	jbe    801144 <memmove+0x6a>
		s += n;
  801101:	8b 45 10             	mov    0x10(%ebp),%eax
  801104:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80110d:	eb 10                	jmp    80111f <memmove+0x45>
			*--d = *--s;
  80110f:	ff 4d f8             	decl   -0x8(%ebp)
  801112:	ff 4d fc             	decl   -0x4(%ebp)
  801115:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801118:	8a 10                	mov    (%eax),%dl
  80111a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80111f:	8b 45 10             	mov    0x10(%ebp),%eax
  801122:	8d 50 ff             	lea    -0x1(%eax),%edx
  801125:	89 55 10             	mov    %edx,0x10(%ebp)
  801128:	85 c0                	test   %eax,%eax
  80112a:	75 e3                	jne    80110f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80112c:	eb 23                	jmp    801151 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801131:	8d 50 01             	lea    0x1(%eax),%edx
  801134:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801137:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801140:	8a 12                	mov    (%edx),%dl
  801142:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114a:	89 55 10             	mov    %edx,0x10(%ebp)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	75 dd                	jne    80112e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801168:	eb 2a                	jmp    801194 <memcmp+0x3e>
		if (*s1 != *s2)
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	8a 10                	mov    (%eax),%dl
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	38 c2                	cmp    %al,%dl
  801176:	74 16                	je     80118e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	0f b6 d0             	movzbl %al,%edx
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f b6 c0             	movzbl %al,%eax
  801188:	29 c2                	sub    %eax,%edx
  80118a:	89 d0                	mov    %edx,%eax
  80118c:	eb 18                	jmp    8011a6 <memcmp+0x50>
		s1++, s2++;
  80118e:	ff 45 fc             	incl   -0x4(%ebp)
  801191:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119a:	89 55 10             	mov    %edx,0x10(%ebp)
  80119d:	85 c0                	test   %eax,%eax
  80119f:	75 c9                	jne    80116a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    

008011a8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011b9:	eb 15                	jmp    8011d0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	0f b6 d0             	movzbl %al,%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	0f b6 c0             	movzbl %al,%eax
  8011c9:	39 c2                	cmp    %eax,%edx
  8011cb:	74 0d                	je     8011da <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011cd:	ff 45 08             	incl   0x8(%ebp)
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d6:	72 e3                	jb     8011bb <memfind+0x13>
  8011d8:	eb 01                	jmp    8011db <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011da:	90                   	nop
	return (void *) s;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f4:	eb 03                	jmp    8011f9 <strtol+0x19>
		s++;
  8011f6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 20                	cmp    $0x20,%al
  801200:	74 f4                	je     8011f6 <strtol+0x16>
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 09                	cmp    $0x9,%al
  801209:	74 eb                	je     8011f6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	3c 2b                	cmp    $0x2b,%al
  801212:	75 05                	jne    801219 <strtol+0x39>
		s++;
  801214:	ff 45 08             	incl   0x8(%ebp)
  801217:	eb 13                	jmp    80122c <strtol+0x4c>
	else if (*s == '-')
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 2d                	cmp    $0x2d,%al
  801220:	75 0a                	jne    80122c <strtol+0x4c>
		s++, neg = 1;
  801222:	ff 45 08             	incl   0x8(%ebp)
  801225:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80122c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801230:	74 06                	je     801238 <strtol+0x58>
  801232:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801236:	75 20                	jne    801258 <strtol+0x78>
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	3c 30                	cmp    $0x30,%al
  80123f:	75 17                	jne    801258 <strtol+0x78>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	40                   	inc    %eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3c 78                	cmp    $0x78,%al
  801249:	75 0d                	jne    801258 <strtol+0x78>
		s += 2, base = 16;
  80124b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80124f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801256:	eb 28                	jmp    801280 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801258:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125c:	75 15                	jne    801273 <strtol+0x93>
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 30                	cmp    $0x30,%al
  801265:	75 0c                	jne    801273 <strtol+0x93>
		s++, base = 8;
  801267:	ff 45 08             	incl   0x8(%ebp)
  80126a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801271:	eb 0d                	jmp    801280 <strtol+0xa0>
	else if (base == 0)
  801273:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801277:	75 07                	jne    801280 <strtol+0xa0>
		base = 10;
  801279:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 2f                	cmp    $0x2f,%al
  801287:	7e 19                	jle    8012a2 <strtol+0xc2>
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 39                	cmp    $0x39,%al
  801290:	7f 10                	jg     8012a2 <strtol+0xc2>
			dig = *s - '0';
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	83 e8 30             	sub    $0x30,%eax
  80129d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a0:	eb 42                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 60                	cmp    $0x60,%al
  8012a9:	7e 19                	jle    8012c4 <strtol+0xe4>
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 7a                	cmp    $0x7a,%al
  8012b2:	7f 10                	jg     8012c4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	83 e8 57             	sub    $0x57,%eax
  8012bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c2:	eb 20                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 40                	cmp    $0x40,%al
  8012cb:	7e 39                	jle    801306 <strtol+0x126>
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	3c 5a                	cmp    $0x5a,%al
  8012d4:	7f 30                	jg     801306 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	0f be c0             	movsbl %al,%eax
  8012de:	83 e8 37             	sub    $0x37,%eax
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012ea:	7d 19                	jge    801305 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ec:	ff 45 08             	incl   0x8(%ebp)
  8012ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801300:	e9 7b ff ff ff       	jmp    801280 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801305:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801306:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130a:	74 08                	je     801314 <strtol+0x134>
		*endptr = (char *) s;
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	8b 55 08             	mov    0x8(%ebp),%edx
  801312:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 07                	je     801321 <strtol+0x141>
  80131a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131d:	f7 d8                	neg    %eax
  80131f:	eb 03                	jmp    801324 <strtol+0x144>
  801321:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <ltostr>:

void
ltostr(long value, char *str)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80132c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801333:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80133a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133e:	79 13                	jns    801353 <ltostr+0x2d>
	{
		neg = 1;
  801340:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80134d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801350:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80135b:	99                   	cltd   
  80135c:	f7 f9                	idiv   %ecx
  80135e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	83 c2 30             	add    $0x30,%edx
  801377:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801381:	f7 e9                	imul   %ecx
  801383:	c1 fa 02             	sar    $0x2,%edx
  801386:	89 c8                	mov    %ecx,%eax
  801388:	c1 f8 1f             	sar    $0x1f,%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
  80138f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801392:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801395:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80139a:	f7 e9                	imul   %ecx
  80139c:	c1 fa 02             	sar    $0x2,%edx
  80139f:	89 c8                	mov    %ecx,%eax
  8013a1:	c1 f8 1f             	sar    $0x1f,%eax
  8013a4:	29 c2                	sub    %eax,%edx
  8013a6:	89 d0                	mov    %edx,%eax
  8013a8:	c1 e0 02             	shl    $0x2,%eax
  8013ab:	01 d0                	add    %edx,%eax
  8013ad:	01 c0                	add    %eax,%eax
  8013af:	29 c1                	sub    %eax,%ecx
  8013b1:	89 ca                	mov    %ecx,%edx
  8013b3:	85 d2                	test   %edx,%edx
  8013b5:	75 9c                	jne    801353 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c1:	48                   	dec    %eax
  8013c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013c9:	74 3d                	je     801408 <ltostr+0xe2>
		start = 1 ;
  8013cb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013d2:	eb 34                	jmp    801408 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	01 d0                	add    %edx,%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	01 c2                	add    %eax,%edx
  8013e9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	01 c8                	add    %ecx,%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fb:	01 c2                	add    %eax,%edx
  8013fd:	8a 45 eb             	mov    -0x15(%ebp),%al
  801400:	88 02                	mov    %al,(%edx)
		start++ ;
  801402:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801405:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80140e:	7c c4                	jl     8013d4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801410:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801413:	8b 45 0c             	mov    0xc(%ebp),%eax
  801416:	01 d0                	add    %edx,%eax
  801418:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80141b:	90                   	nop
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	e8 54 fa ff ff       	call   800e80 <strlen>
  80142c:	83 c4 04             	add    $0x4,%esp
  80142f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801432:	ff 75 0c             	pushl  0xc(%ebp)
  801435:	e8 46 fa ff ff       	call   800e80 <strlen>
  80143a:	83 c4 04             	add    $0x4,%esp
  80143d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801447:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144e:	eb 17                	jmp    801467 <strcconcat+0x49>
		final[s] = str1[s] ;
  801450:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801453:	8b 45 10             	mov    0x10(%ebp),%eax
  801456:	01 c2                	add    %eax,%edx
  801458:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	01 c8                	add    %ecx,%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801464:	ff 45 fc             	incl   -0x4(%ebp)
  801467:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80146d:	7c e1                	jl     801450 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80146f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801476:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80147d:	eb 1f                	jmp    80149e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80147f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801482:	8d 50 01             	lea    0x1(%eax),%edx
  801485:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801488:	89 c2                	mov    %eax,%edx
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	01 c2                	add    %eax,%edx
  80148f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801492:	8b 45 0c             	mov    0xc(%ebp),%eax
  801495:	01 c8                	add    %ecx,%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80149b:	ff 45 f8             	incl   -0x8(%ebp)
  80149e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014a4:	7c d9                	jl     80147f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	01 d0                	add    %edx,%eax
  8014ae:	c6 00 00             	movb   $0x0,(%eax)
}
  8014b1:	90                   	nop
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014d7:	eb 0c                	jmp    8014e5 <strsplit+0x31>
			*string++ = 0;
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8d 50 01             	lea    0x1(%eax),%edx
  8014df:	89 55 08             	mov    %edx,0x8(%ebp)
  8014e2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	84 c0                	test   %al,%al
  8014ec:	74 18                	je     801506 <strsplit+0x52>
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	0f be c0             	movsbl %al,%eax
  8014f6:	50                   	push   %eax
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	e8 13 fb ff ff       	call   801012 <strchr>
  8014ff:	83 c4 08             	add    $0x8,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	75 d3                	jne    8014d9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	84 c0                	test   %al,%al
  80150d:	74 5a                	je     801569 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80150f:	8b 45 14             	mov    0x14(%ebp),%eax
  801512:	8b 00                	mov    (%eax),%eax
  801514:	83 f8 0f             	cmp    $0xf,%eax
  801517:	75 07                	jne    801520 <strsplit+0x6c>
		{
			return 0;
  801519:	b8 00 00 00 00       	mov    $0x0,%eax
  80151e:	eb 66                	jmp    801586 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801520:	8b 45 14             	mov    0x14(%ebp),%eax
  801523:	8b 00                	mov    (%eax),%eax
  801525:	8d 48 01             	lea    0x1(%eax),%ecx
  801528:	8b 55 14             	mov    0x14(%ebp),%edx
  80152b:	89 0a                	mov    %ecx,(%edx)
  80152d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801534:	8b 45 10             	mov    0x10(%ebp),%eax
  801537:	01 c2                	add    %eax,%edx
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80153e:	eb 03                	jmp    801543 <strsplit+0x8f>
			string++;
  801540:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 8b                	je     8014d7 <strsplit+0x23>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f be c0             	movsbl %al,%eax
  801554:	50                   	push   %eax
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	e8 b5 fa ff ff       	call   801012 <strchr>
  80155d:	83 c4 08             	add    $0x8,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	74 dc                	je     801540 <strsplit+0x8c>
			string++;
	}
  801564:	e9 6e ff ff ff       	jmp    8014d7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801569:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	01 d0                	add    %edx,%eax
  80157b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801581:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80158e:	a1 04 50 80 00       	mov    0x805004,%eax
  801593:	85 c0                	test   %eax,%eax
  801595:	74 1f                	je     8015b6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801597:	e8 1d 00 00 00       	call   8015b9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	68 50 3f 80 00       	push   $0x803f50
  8015a4:	e8 55 f2 ff ff       	call   8007fe <cprintf>
  8015a9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8015ac:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8015b3:	00 00 00 
	}
}
  8015b6:	90                   	nop
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8015bf:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8015c6:	00 00 00 
  8015c9:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8015d0:	00 00 00 
  8015d3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8015da:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  8015dd:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8015e4:	00 00 00 
  8015e7:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8015ee:	00 00 00 
  8015f1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8015f8:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8015fb:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801602:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801605:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80160c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801614:	2d 00 10 00 00       	sub    $0x1000,%eax
  801619:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80161e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801625:	a1 20 51 80 00       	mov    0x805120,%eax
  80162a:	c1 e0 04             	shl    $0x4,%eax
  80162d:	89 c2                	mov    %eax,%edx
  80162f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801632:	01 d0                	add    %edx,%eax
  801634:	48                   	dec    %eax
  801635:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801638:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163b:	ba 00 00 00 00       	mov    $0x0,%edx
  801640:	f7 75 f0             	divl   -0x10(%ebp)
  801643:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801646:	29 d0                	sub    %edx,%eax
  801648:	89 c2                	mov    %eax,%edx
  80164a:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801651:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801654:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801659:	2d 00 10 00 00       	sub    $0x1000,%eax
  80165e:	83 ec 04             	sub    $0x4,%esp
  801661:	6a 06                	push   $0x6
  801663:	52                   	push   %edx
  801664:	50                   	push   %eax
  801665:	e8 71 05 00 00       	call   801bdb <sys_allocate_chunk>
  80166a:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80166d:	a1 20 51 80 00       	mov    0x805120,%eax
  801672:	83 ec 0c             	sub    $0xc,%esp
  801675:	50                   	push   %eax
  801676:	e8 e6 0b 00 00       	call   802261 <initialize_MemBlocksList>
  80167b:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  80167e:	a1 48 51 80 00       	mov    0x805148,%eax
  801683:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801686:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80168a:	75 14                	jne    8016a0 <initialize_dyn_block_system+0xe7>
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	68 75 3f 80 00       	push   $0x803f75
  801694:	6a 2b                	push   $0x2b
  801696:	68 93 3f 80 00       	push   $0x803f93
  80169b:	e8 aa ee ff ff       	call   80054a <_panic>
  8016a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016a3:	8b 00                	mov    (%eax),%eax
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	74 10                	je     8016b9 <initialize_dyn_block_system+0x100>
  8016a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ac:	8b 00                	mov    (%eax),%eax
  8016ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016b1:	8b 52 04             	mov    0x4(%edx),%edx
  8016b4:	89 50 04             	mov    %edx,0x4(%eax)
  8016b7:	eb 0b                	jmp    8016c4 <initialize_dyn_block_system+0x10b>
  8016b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016bc:	8b 40 04             	mov    0x4(%eax),%eax
  8016bf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8016c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016c7:	8b 40 04             	mov    0x4(%eax),%eax
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	74 0f                	je     8016dd <initialize_dyn_block_system+0x124>
  8016ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016d1:	8b 40 04             	mov    0x4(%eax),%eax
  8016d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016d7:	8b 12                	mov    (%edx),%edx
  8016d9:	89 10                	mov    %edx,(%eax)
  8016db:	eb 0a                	jmp    8016e7 <initialize_dyn_block_system+0x12e>
  8016dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016e0:	8b 00                	mov    (%eax),%eax
  8016e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8016e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8016ff:	48                   	dec    %eax
  801700:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801708:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80170f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801712:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801719:	83 ec 0c             	sub    $0xc,%esp
  80171c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80171f:	e8 d2 13 00 00       	call   802af6 <insert_sorted_with_merge_freeList>
  801724:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801727:	90                   	nop
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801730:	e8 53 fe ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  801735:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801739:	75 07                	jne    801742 <malloc+0x18>
  80173b:	b8 00 00 00 00       	mov    $0x0,%eax
  801740:	eb 61                	jmp    8017a3 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801742:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801749:	8b 55 08             	mov    0x8(%ebp),%edx
  80174c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174f:	01 d0                	add    %edx,%eax
  801751:	48                   	dec    %eax
  801752:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801755:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801758:	ba 00 00 00 00       	mov    $0x0,%edx
  80175d:	f7 75 f4             	divl   -0xc(%ebp)
  801760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801763:	29 d0                	sub    %edx,%eax
  801765:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801768:	e8 3c 08 00 00       	call   801fa9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80176d:	85 c0                	test   %eax,%eax
  80176f:	74 2d                	je     80179e <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801771:	83 ec 0c             	sub    $0xc,%esp
  801774:	ff 75 08             	pushl  0x8(%ebp)
  801777:	e8 3e 0f 00 00       	call   8026ba <alloc_block_FF>
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801782:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801786:	74 16                	je     80179e <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801788:	83 ec 0c             	sub    $0xc,%esp
  80178b:	ff 75 ec             	pushl  -0x14(%ebp)
  80178e:	e8 48 0c 00 00       	call   8023db <insert_sorted_allocList>
  801793:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801796:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801799:	8b 40 08             	mov    0x8(%eax),%eax
  80179c:	eb 05                	jmp    8017a3 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017b9:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	83 ec 08             	sub    $0x8,%esp
  8017c2:	50                   	push   %eax
  8017c3:	68 40 50 80 00       	push   $0x805040
  8017c8:	e8 71 0b 00 00       	call   80233e <find_block>
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  8017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	52                   	push   %edx
  8017e0:	50                   	push   %eax
  8017e1:	e8 bd 03 00 00       	call   801ba3 <sys_free_user_mem>
  8017e6:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  8017e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017ed:	75 14                	jne    801803 <free+0x5e>
  8017ef:	83 ec 04             	sub    $0x4,%esp
  8017f2:	68 75 3f 80 00       	push   $0x803f75
  8017f7:	6a 71                	push   $0x71
  8017f9:	68 93 3f 80 00       	push   $0x803f93
  8017fe:	e8 47 ed ff ff       	call   80054a <_panic>
  801803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801806:	8b 00                	mov    (%eax),%eax
  801808:	85 c0                	test   %eax,%eax
  80180a:	74 10                	je     80181c <free+0x77>
  80180c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180f:	8b 00                	mov    (%eax),%eax
  801811:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801814:	8b 52 04             	mov    0x4(%edx),%edx
  801817:	89 50 04             	mov    %edx,0x4(%eax)
  80181a:	eb 0b                	jmp    801827 <free+0x82>
  80181c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181f:	8b 40 04             	mov    0x4(%eax),%eax
  801822:	a3 44 50 80 00       	mov    %eax,0x805044
  801827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182a:	8b 40 04             	mov    0x4(%eax),%eax
  80182d:	85 c0                	test   %eax,%eax
  80182f:	74 0f                	je     801840 <free+0x9b>
  801831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801834:	8b 40 04             	mov    0x4(%eax),%eax
  801837:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80183a:	8b 12                	mov    (%edx),%edx
  80183c:	89 10                	mov    %edx,(%eax)
  80183e:	eb 0a                	jmp    80184a <free+0xa5>
  801840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801843:	8b 00                	mov    (%eax),%eax
  801845:	a3 40 50 80 00       	mov    %eax,0x805040
  80184a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801856:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80185d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801862:	48                   	dec    %eax
  801863:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	ff 75 f0             	pushl  -0x10(%ebp)
  80186e:	e8 83 12 00 00       	call   802af6 <insert_sorted_with_merge_freeList>
  801873:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801876:	90                   	nop
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 28             	sub    $0x28,%esp
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801885:	e8 fe fc ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  80188a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80188e:	75 0a                	jne    80189a <smalloc+0x21>
  801890:	b8 00 00 00 00       	mov    $0x0,%eax
  801895:	e9 86 00 00 00       	jmp    801920 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  80189a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a7:	01 d0                	add    %edx,%eax
  8018a9:	48                   	dec    %eax
  8018aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b5:	f7 75 f4             	divl   -0xc(%ebp)
  8018b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bb:	29 d0                	sub    %edx,%eax
  8018bd:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018c0:	e8 e4 06 00 00       	call   801fa9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018c5:	85 c0                	test   %eax,%eax
  8018c7:	74 52                	je     80191b <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8018c9:	83 ec 0c             	sub    $0xc,%esp
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	e8 e6 0d 00 00       	call   8026ba <alloc_block_FF>
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  8018da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018de:	75 07                	jne    8018e7 <smalloc+0x6e>
			return NULL ;
  8018e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e5:	eb 39                	jmp    801920 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  8018e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ea:	8b 40 08             	mov    0x8(%eax),%eax
  8018ed:	89 c2                	mov    %eax,%edx
  8018ef:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8018f3:	52                   	push   %edx
  8018f4:	50                   	push   %eax
  8018f5:	ff 75 0c             	pushl  0xc(%ebp)
  8018f8:	ff 75 08             	pushl  0x8(%ebp)
  8018fb:	e8 2e 04 00 00       	call   801d2e <sys_createSharedObject>
  801900:	83 c4 10             	add    $0x10,%esp
  801903:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801906:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80190a:	79 07                	jns    801913 <smalloc+0x9a>
			return (void*)NULL ;
  80190c:	b8 00 00 00 00       	mov    $0x0,%eax
  801911:	eb 0d                	jmp    801920 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801916:	8b 40 08             	mov    0x8(%eax),%eax
  801919:	eb 05                	jmp    801920 <smalloc+0xa7>
		}
		return (void*)NULL ;
  80191b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801928:	e8 5b fc ff ff       	call   801588 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	ff 75 08             	pushl  0x8(%ebp)
  801936:	e8 1d 04 00 00       	call   801d58 <sys_getSizeOfSharedObject>
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801941:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801945:	75 0a                	jne    801951 <sget+0x2f>
			return NULL ;
  801947:	b8 00 00 00 00       	mov    $0x0,%eax
  80194c:	e9 83 00 00 00       	jmp    8019d4 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801951:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801958:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195e:	01 d0                	add    %edx,%eax
  801960:	48                   	dec    %eax
  801961:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801964:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801967:	ba 00 00 00 00       	mov    $0x0,%edx
  80196c:	f7 75 f0             	divl   -0x10(%ebp)
  80196f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801972:	29 d0                	sub    %edx,%eax
  801974:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801977:	e8 2d 06 00 00       	call   801fa9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80197c:	85 c0                	test   %eax,%eax
  80197e:	74 4f                	je     8019cf <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801983:	83 ec 0c             	sub    $0xc,%esp
  801986:	50                   	push   %eax
  801987:	e8 2e 0d 00 00       	call   8026ba <alloc_block_FF>
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801992:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801996:	75 07                	jne    80199f <sget+0x7d>
					return (void*)NULL ;
  801998:	b8 00 00 00 00       	mov    $0x0,%eax
  80199d:	eb 35                	jmp    8019d4 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  80199f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019a2:	8b 40 08             	mov    0x8(%eax),%eax
  8019a5:	83 ec 04             	sub    $0x4,%esp
  8019a8:	50                   	push   %eax
  8019a9:	ff 75 0c             	pushl  0xc(%ebp)
  8019ac:	ff 75 08             	pushl  0x8(%ebp)
  8019af:	e8 c1 03 00 00       	call   801d75 <sys_getSharedObject>
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8019ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019be:	79 07                	jns    8019c7 <sget+0xa5>
				return (void*)NULL ;
  8019c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c5:	eb 0d                	jmp    8019d4 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8019c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019ca:	8b 40 08             	mov    0x8(%eax),%eax
  8019cd:	eb 05                	jmp    8019d4 <sget+0xb2>


		}
	return (void*)NULL ;
  8019cf:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019dc:	e8 a7 fb ff ff       	call   801588 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019e1:	83 ec 04             	sub    $0x4,%esp
  8019e4:	68 a0 3f 80 00       	push   $0x803fa0
  8019e9:	68 f9 00 00 00       	push   $0xf9
  8019ee:	68 93 3f 80 00       	push   $0x803f93
  8019f3:	e8 52 eb ff ff       	call   80054a <_panic>

008019f8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	68 c8 3f 80 00       	push   $0x803fc8
  801a06:	68 0d 01 00 00       	push   $0x10d
  801a0b:	68 93 3f 80 00       	push   $0x803f93
  801a10:	e8 35 eb ff ff       	call   80054a <_panic>

00801a15 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a1b:	83 ec 04             	sub    $0x4,%esp
  801a1e:	68 ec 3f 80 00       	push   $0x803fec
  801a23:	68 18 01 00 00       	push   $0x118
  801a28:	68 93 3f 80 00       	push   $0x803f93
  801a2d:	e8 18 eb ff ff       	call   80054a <_panic>

00801a32 <shrink>:

}
void shrink(uint32 newSize)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a38:	83 ec 04             	sub    $0x4,%esp
  801a3b:	68 ec 3f 80 00       	push   $0x803fec
  801a40:	68 1d 01 00 00       	push   $0x11d
  801a45:	68 93 3f 80 00       	push   $0x803f93
  801a4a:	e8 fb ea ff ff       	call   80054a <_panic>

00801a4f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a55:	83 ec 04             	sub    $0x4,%esp
  801a58:	68 ec 3f 80 00       	push   $0x803fec
  801a5d:	68 22 01 00 00       	push   $0x122
  801a62:	68 93 3f 80 00       	push   $0x803f93
  801a67:	e8 de ea ff ff       	call   80054a <_panic>

00801a6c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	57                   	push   %edi
  801a70:	56                   	push   %esi
  801a71:	53                   	push   %ebx
  801a72:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a81:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a84:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a87:	cd 30                	int    $0x30
  801a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	5b                   	pop    %ebx
  801a93:	5e                   	pop    %esi
  801a94:	5f                   	pop    %edi
  801a95:	5d                   	pop    %ebp
  801a96:	c3                   	ret    

00801a97 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 04             	sub    $0x4,%esp
  801a9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801aa3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	52                   	push   %edx
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	50                   	push   %eax
  801ab3:	6a 00                	push   $0x0
  801ab5:	e8 b2 ff ff ff       	call   801a6c <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	90                   	nop
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 01                	push   $0x1
  801acf:	e8 98 ff ff ff       	call   801a6c <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801adc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	52                   	push   %edx
  801ae9:	50                   	push   %eax
  801aea:	6a 05                	push   $0x5
  801aec:	e8 7b ff ff ff       	call   801a6c <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	56                   	push   %esi
  801afa:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801afb:	8b 75 18             	mov    0x18(%ebp),%esi
  801afe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b01:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	56                   	push   %esi
  801b0b:	53                   	push   %ebx
  801b0c:	51                   	push   %ecx
  801b0d:	52                   	push   %edx
  801b0e:	50                   	push   %eax
  801b0f:	6a 06                	push   $0x6
  801b11:	e8 56 ff ff ff       	call   801a6c <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1c:	5b                   	pop    %ebx
  801b1d:	5e                   	pop    %esi
  801b1e:	5d                   	pop    %ebp
  801b1f:	c3                   	ret    

00801b20 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	6a 07                	push   $0x7
  801b33:	e8 34 ff ff ff       	call   801a6c <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	ff 75 0c             	pushl  0xc(%ebp)
  801b49:	ff 75 08             	pushl  0x8(%ebp)
  801b4c:	6a 08                	push   $0x8
  801b4e:	e8 19 ff ff ff       	call   801a6c <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 09                	push   $0x9
  801b67:	e8 00 ff ff ff       	call   801a6c <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 0a                	push   $0xa
  801b80:	e8 e7 fe ff ff       	call   801a6c <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 0b                	push   $0xb
  801b99:	e8 ce fe ff ff       	call   801a6c <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	ff 75 0c             	pushl  0xc(%ebp)
  801baf:	ff 75 08             	pushl  0x8(%ebp)
  801bb2:	6a 0f                	push   $0xf
  801bb4:	e8 b3 fe ff ff       	call   801a6c <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
	return;
  801bbc:	90                   	nop
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	ff 75 0c             	pushl  0xc(%ebp)
  801bcb:	ff 75 08             	pushl  0x8(%ebp)
  801bce:	6a 10                	push   $0x10
  801bd0:	e8 97 fe ff ff       	call   801a6c <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd8:	90                   	nop
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	ff 75 10             	pushl  0x10(%ebp)
  801be5:	ff 75 0c             	pushl  0xc(%ebp)
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	6a 11                	push   $0x11
  801bed:	e8 7a fe ff ff       	call   801a6c <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf5:	90                   	nop
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 0c                	push   $0xc
  801c07:	e8 60 fe ff ff       	call   801a6c <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	6a 0d                	push   $0xd
  801c21:	e8 46 fe ff ff       	call   801a6c <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 0e                	push   $0xe
  801c3a:	e8 2d fe ff ff       	call   801a6c <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	90                   	nop
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 13                	push   $0x13
  801c54:	e8 13 fe ff ff       	call   801a6c <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	90                   	nop
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 14                	push   $0x14
  801c6e:	e8 f9 fd ff ff       	call   801a6c <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	90                   	nop
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 04             	sub    $0x4,%esp
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c85:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	50                   	push   %eax
  801c92:	6a 15                	push   $0x15
  801c94:	e8 d3 fd ff ff       	call   801a6c <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	90                   	nop
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 16                	push   $0x16
  801cae:	e8 b9 fd ff ff       	call   801a6c <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	90                   	nop
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	ff 75 0c             	pushl  0xc(%ebp)
  801cc8:	50                   	push   %eax
  801cc9:	6a 17                	push   $0x17
  801ccb:	e8 9c fd ff ff       	call   801a6c <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	52                   	push   %edx
  801ce5:	50                   	push   %eax
  801ce6:	6a 1a                	push   $0x1a
  801ce8:	e8 7f fd ff ff       	call   801a6c <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	52                   	push   %edx
  801d02:	50                   	push   %eax
  801d03:	6a 18                	push   $0x18
  801d05:	e8 62 fd ff ff       	call   801a6c <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	90                   	nop
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	52                   	push   %edx
  801d20:	50                   	push   %eax
  801d21:	6a 19                	push   $0x19
  801d23:	e8 44 fd ff ff       	call   801a6c <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	90                   	nop
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 04             	sub    $0x4,%esp
  801d34:	8b 45 10             	mov    0x10(%ebp),%eax
  801d37:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d3a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d3d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	6a 00                	push   $0x0
  801d46:	51                   	push   %ecx
  801d47:	52                   	push   %edx
  801d48:	ff 75 0c             	pushl  0xc(%ebp)
  801d4b:	50                   	push   %eax
  801d4c:	6a 1b                	push   $0x1b
  801d4e:	e8 19 fd ff ff       	call   801a6c <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	52                   	push   %edx
  801d68:	50                   	push   %eax
  801d69:	6a 1c                	push   $0x1c
  801d6b:	e8 fc fc ff ff       	call   801a6c <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	51                   	push   %ecx
  801d86:	52                   	push   %edx
  801d87:	50                   	push   %eax
  801d88:	6a 1d                	push   $0x1d
  801d8a:	e8 dd fc ff ff       	call   801a6c <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	52                   	push   %edx
  801da4:	50                   	push   %eax
  801da5:	6a 1e                	push   $0x1e
  801da7:	e8 c0 fc ff ff       	call   801a6c <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 1f                	push   $0x1f
  801dc0:	e8 a7 fc ff ff       	call   801a6c <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	6a 00                	push   $0x0
  801dd2:	ff 75 14             	pushl  0x14(%ebp)
  801dd5:	ff 75 10             	pushl  0x10(%ebp)
  801dd8:	ff 75 0c             	pushl  0xc(%ebp)
  801ddb:	50                   	push   %eax
  801ddc:	6a 20                	push   $0x20
  801dde:	e8 89 fc ff ff       	call   801a6c <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	50                   	push   %eax
  801df7:	6a 21                	push   $0x21
  801df9:	e8 6e fc ff ff       	call   801a6c <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
}
  801e01:	90                   	nop
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	50                   	push   %eax
  801e13:	6a 22                	push   $0x22
  801e15:	e8 52 fc ff ff       	call   801a6c <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 02                	push   $0x2
  801e2e:	e8 39 fc ff ff       	call   801a6c <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 03                	push   $0x3
  801e47:	e8 20 fc ff ff       	call   801a6c <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 04                	push   $0x4
  801e60:	e8 07 fc ff ff       	call   801a6c <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_exit_env>:


void sys_exit_env(void)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 23                	push   $0x23
  801e79:	e8 ee fb ff ff       	call   801a6c <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	90                   	nop
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e8a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e8d:	8d 50 04             	lea    0x4(%eax),%edx
  801e90:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	52                   	push   %edx
  801e9a:	50                   	push   %eax
  801e9b:	6a 24                	push   $0x24
  801e9d:	e8 ca fb ff ff       	call   801a6c <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
	return result;
  801ea5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801eae:	89 01                	mov    %eax,(%ecx)
  801eb0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb6:	c9                   	leave  
  801eb7:	c2 04 00             	ret    $0x4

00801eba <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	ff 75 10             	pushl  0x10(%ebp)
  801ec4:	ff 75 0c             	pushl  0xc(%ebp)
  801ec7:	ff 75 08             	pushl  0x8(%ebp)
  801eca:	6a 12                	push   $0x12
  801ecc:	e8 9b fb ff ff       	call   801a6c <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed4:	90                   	nop
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 25                	push   $0x25
  801ee6:	e8 81 fb ff ff       	call   801a6c <syscall>
  801eeb:	83 c4 18             	add    $0x18,%esp
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 04             	sub    $0x4,%esp
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801efc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	50                   	push   %eax
  801f09:	6a 26                	push   $0x26
  801f0b:	e8 5c fb ff ff       	call   801a6c <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
	return ;
  801f13:	90                   	nop
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <rsttst>:
void rsttst()
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 28                	push   $0x28
  801f25:	e8 42 fb ff ff       	call   801a6c <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2d:	90                   	nop
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 04             	sub    $0x4,%esp
  801f36:	8b 45 14             	mov    0x14(%ebp),%eax
  801f39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f3c:	8b 55 18             	mov    0x18(%ebp),%edx
  801f3f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f43:	52                   	push   %edx
  801f44:	50                   	push   %eax
  801f45:	ff 75 10             	pushl  0x10(%ebp)
  801f48:	ff 75 0c             	pushl  0xc(%ebp)
  801f4b:	ff 75 08             	pushl  0x8(%ebp)
  801f4e:	6a 27                	push   $0x27
  801f50:	e8 17 fb ff ff       	call   801a6c <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
	return ;
  801f58:	90                   	nop
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <chktst>:
void chktst(uint32 n)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	ff 75 08             	pushl  0x8(%ebp)
  801f69:	6a 29                	push   $0x29
  801f6b:	e8 fc fa ff ff       	call   801a6c <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
	return ;
  801f73:	90                   	nop
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <inctst>:

void inctst()
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 2a                	push   $0x2a
  801f85:	e8 e2 fa ff ff       	call   801a6c <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8d:	90                   	nop
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <gettst>:
uint32 gettst()
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 2b                	push   $0x2b
  801f9f:	e8 c8 fa ff ff       	call   801a6c <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 2c                	push   $0x2c
  801fbb:	e8 ac fa ff ff       	call   801a6c <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
  801fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fc6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fca:	75 07                	jne    801fd3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fcc:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd1:	eb 05                	jmp    801fd8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 2c                	push   $0x2c
  801fec:	e8 7b fa ff ff       	call   801a6c <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
  801ff4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ff7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ffb:	75 07                	jne    802004 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ffd:	b8 01 00 00 00       	mov    $0x1,%eax
  802002:	eb 05                	jmp    802009 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802004:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 2c                	push   $0x2c
  80201d:	e8 4a fa ff ff       	call   801a6c <syscall>
  802022:	83 c4 18             	add    $0x18,%esp
  802025:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802028:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80202c:	75 07                	jne    802035 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80202e:	b8 01 00 00 00       	mov    $0x1,%eax
  802033:	eb 05                	jmp    80203a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802035:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 2c                	push   $0x2c
  80204e:	e8 19 fa ff ff       	call   801a6c <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
  802056:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802059:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80205d:	75 07                	jne    802066 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80205f:	b8 01 00 00 00       	mov    $0x1,%eax
  802064:	eb 05                	jmp    80206b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802066:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	ff 75 08             	pushl  0x8(%ebp)
  80207b:	6a 2d                	push   $0x2d
  80207d:	e8 ea f9 ff ff       	call   801a6c <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
	return ;
  802085:	90                   	nop
}
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80208c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80208f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802092:	8b 55 0c             	mov    0xc(%ebp),%edx
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	6a 00                	push   $0x0
  80209a:	53                   	push   %ebx
  80209b:	51                   	push   %ecx
  80209c:	52                   	push   %edx
  80209d:	50                   	push   %eax
  80209e:	6a 2e                	push   $0x2e
  8020a0:	e8 c7 f9 ff ff       	call   801a6c <syscall>
  8020a5:	83 c4 18             	add    $0x18,%esp
}
  8020a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	52                   	push   %edx
  8020bd:	50                   	push   %eax
  8020be:	6a 2f                	push   $0x2f
  8020c0:	e8 a7 f9 ff ff       	call   801a6c <syscall>
  8020c5:	83 c4 18             	add    $0x18,%esp
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020d0:	83 ec 0c             	sub    $0xc,%esp
  8020d3:	68 fc 3f 80 00       	push   $0x803ffc
  8020d8:	e8 21 e7 ff ff       	call   8007fe <cprintf>
  8020dd:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020e7:	83 ec 0c             	sub    $0xc,%esp
  8020ea:	68 28 40 80 00       	push   $0x804028
  8020ef:	e8 0a e7 ff ff       	call   8007fe <cprintf>
  8020f4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020f7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020fb:	a1 38 51 80 00       	mov    0x805138,%eax
  802100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802103:	eb 56                	jmp    80215b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802105:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802109:	74 1c                	je     802127 <print_mem_block_lists+0x5d>
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	8b 50 08             	mov    0x8(%eax),%edx
  802111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802114:	8b 48 08             	mov    0x8(%eax),%ecx
  802117:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211a:	8b 40 0c             	mov    0xc(%eax),%eax
  80211d:	01 c8                	add    %ecx,%eax
  80211f:	39 c2                	cmp    %eax,%edx
  802121:	73 04                	jae    802127 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802123:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212a:	8b 50 08             	mov    0x8(%eax),%edx
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	8b 40 0c             	mov    0xc(%eax),%eax
  802133:	01 c2                	add    %eax,%edx
  802135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802138:	8b 40 08             	mov    0x8(%eax),%eax
  80213b:	83 ec 04             	sub    $0x4,%esp
  80213e:	52                   	push   %edx
  80213f:	50                   	push   %eax
  802140:	68 3d 40 80 00       	push   $0x80403d
  802145:	e8 b4 e6 ff ff       	call   8007fe <cprintf>
  80214a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80214d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802150:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802153:	a1 40 51 80 00       	mov    0x805140,%eax
  802158:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80215f:	74 07                	je     802168 <print_mem_block_lists+0x9e>
  802161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802164:	8b 00                	mov    (%eax),%eax
  802166:	eb 05                	jmp    80216d <print_mem_block_lists+0xa3>
  802168:	b8 00 00 00 00       	mov    $0x0,%eax
  80216d:	a3 40 51 80 00       	mov    %eax,0x805140
  802172:	a1 40 51 80 00       	mov    0x805140,%eax
  802177:	85 c0                	test   %eax,%eax
  802179:	75 8a                	jne    802105 <print_mem_block_lists+0x3b>
  80217b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217f:	75 84                	jne    802105 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802181:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802185:	75 10                	jne    802197 <print_mem_block_lists+0xcd>
  802187:	83 ec 0c             	sub    $0xc,%esp
  80218a:	68 4c 40 80 00       	push   $0x80404c
  80218f:	e8 6a e6 ff ff       	call   8007fe <cprintf>
  802194:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802197:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80219e:	83 ec 0c             	sub    $0xc,%esp
  8021a1:	68 70 40 80 00       	push   $0x804070
  8021a6:	e8 53 e6 ff ff       	call   8007fe <cprintf>
  8021ab:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021ae:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021b2:	a1 40 50 80 00       	mov    0x805040,%eax
  8021b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ba:	eb 56                	jmp    802212 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021c0:	74 1c                	je     8021de <print_mem_block_lists+0x114>
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	8b 50 08             	mov    0x8(%eax),%edx
  8021c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cb:	8b 48 08             	mov    0x8(%eax),%ecx
  8021ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d4:	01 c8                	add    %ecx,%eax
  8021d6:	39 c2                	cmp    %eax,%edx
  8021d8:	73 04                	jae    8021de <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021da:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e1:	8b 50 08             	mov    0x8(%eax),%edx
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8021ea:	01 c2                	add    %eax,%edx
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	8b 40 08             	mov    0x8(%eax),%eax
  8021f2:	83 ec 04             	sub    $0x4,%esp
  8021f5:	52                   	push   %edx
  8021f6:	50                   	push   %eax
  8021f7:	68 3d 40 80 00       	push   $0x80403d
  8021fc:	e8 fd e5 ff ff       	call   8007fe <cprintf>
  802201:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802207:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80220a:	a1 48 50 80 00       	mov    0x805048,%eax
  80220f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802212:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802216:	74 07                	je     80221f <print_mem_block_lists+0x155>
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 00                	mov    (%eax),%eax
  80221d:	eb 05                	jmp    802224 <print_mem_block_lists+0x15a>
  80221f:	b8 00 00 00 00       	mov    $0x0,%eax
  802224:	a3 48 50 80 00       	mov    %eax,0x805048
  802229:	a1 48 50 80 00       	mov    0x805048,%eax
  80222e:	85 c0                	test   %eax,%eax
  802230:	75 8a                	jne    8021bc <print_mem_block_lists+0xf2>
  802232:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802236:	75 84                	jne    8021bc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802238:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80223c:	75 10                	jne    80224e <print_mem_block_lists+0x184>
  80223e:	83 ec 0c             	sub    $0xc,%esp
  802241:	68 88 40 80 00       	push   $0x804088
  802246:	e8 b3 e5 ff ff       	call   8007fe <cprintf>
  80224b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80224e:	83 ec 0c             	sub    $0xc,%esp
  802251:	68 fc 3f 80 00       	push   $0x803ffc
  802256:	e8 a3 e5 ff ff       	call   8007fe <cprintf>
  80225b:	83 c4 10             	add    $0x10,%esp

}
  80225e:	90                   	nop
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802267:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80226e:	00 00 00 
  802271:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802278:	00 00 00 
  80227b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802282:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802285:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80228c:	e9 9e 00 00 00       	jmp    80232f <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802291:	a1 50 50 80 00       	mov    0x805050,%eax
  802296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802299:	c1 e2 04             	shl    $0x4,%edx
  80229c:	01 d0                	add    %edx,%eax
  80229e:	85 c0                	test   %eax,%eax
  8022a0:	75 14                	jne    8022b6 <initialize_MemBlocksList+0x55>
  8022a2:	83 ec 04             	sub    $0x4,%esp
  8022a5:	68 b0 40 80 00       	push   $0x8040b0
  8022aa:	6a 43                	push   $0x43
  8022ac:	68 d3 40 80 00       	push   $0x8040d3
  8022b1:	e8 94 e2 ff ff       	call   80054a <_panic>
  8022b6:	a1 50 50 80 00       	mov    0x805050,%eax
  8022bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022be:	c1 e2 04             	shl    $0x4,%edx
  8022c1:	01 d0                	add    %edx,%eax
  8022c3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8022c9:	89 10                	mov    %edx,(%eax)
  8022cb:	8b 00                	mov    (%eax),%eax
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	74 18                	je     8022e9 <initialize_MemBlocksList+0x88>
  8022d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8022d6:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8022dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022df:	c1 e1 04             	shl    $0x4,%ecx
  8022e2:	01 ca                	add    %ecx,%edx
  8022e4:	89 50 04             	mov    %edx,0x4(%eax)
  8022e7:	eb 12                	jmp    8022fb <initialize_MemBlocksList+0x9a>
  8022e9:	a1 50 50 80 00       	mov    0x805050,%eax
  8022ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f1:	c1 e2 04             	shl    $0x4,%edx
  8022f4:	01 d0                	add    %edx,%eax
  8022f6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8022fb:	a1 50 50 80 00       	mov    0x805050,%eax
  802300:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802303:	c1 e2 04             	shl    $0x4,%edx
  802306:	01 d0                	add    %edx,%eax
  802308:	a3 48 51 80 00       	mov    %eax,0x805148
  80230d:	a1 50 50 80 00       	mov    0x805050,%eax
  802312:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802315:	c1 e2 04             	shl    $0x4,%edx
  802318:	01 d0                	add    %edx,%eax
  80231a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802321:	a1 54 51 80 00       	mov    0x805154,%eax
  802326:	40                   	inc    %eax
  802327:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80232c:	ff 45 f4             	incl   -0xc(%ebp)
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	3b 45 08             	cmp    0x8(%ebp),%eax
  802335:	0f 82 56 ff ff ff    	jb     802291 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80233b:	90                   	nop
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802344:	a1 38 51 80 00       	mov    0x805138,%eax
  802349:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80234c:	eb 18                	jmp    802366 <find_block+0x28>
	{
		if (ele->sva==va)
  80234e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802351:	8b 40 08             	mov    0x8(%eax),%eax
  802354:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802357:	75 05                	jne    80235e <find_block+0x20>
			return ele;
  802359:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80235c:	eb 7b                	jmp    8023d9 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80235e:	a1 40 51 80 00       	mov    0x805140,%eax
  802363:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802366:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80236a:	74 07                	je     802373 <find_block+0x35>
  80236c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80236f:	8b 00                	mov    (%eax),%eax
  802371:	eb 05                	jmp    802378 <find_block+0x3a>
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
  802378:	a3 40 51 80 00       	mov    %eax,0x805140
  80237d:	a1 40 51 80 00       	mov    0x805140,%eax
  802382:	85 c0                	test   %eax,%eax
  802384:	75 c8                	jne    80234e <find_block+0x10>
  802386:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80238a:	75 c2                	jne    80234e <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80238c:	a1 40 50 80 00       	mov    0x805040,%eax
  802391:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802394:	eb 18                	jmp    8023ae <find_block+0x70>
	{
		if (ele->sva==va)
  802396:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802399:	8b 40 08             	mov    0x8(%eax),%eax
  80239c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80239f:	75 05                	jne    8023a6 <find_block+0x68>
					return ele;
  8023a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a4:	eb 33                	jmp    8023d9 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8023a6:	a1 48 50 80 00       	mov    0x805048,%eax
  8023ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023b2:	74 07                	je     8023bb <find_block+0x7d>
  8023b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b7:	8b 00                	mov    (%eax),%eax
  8023b9:	eb 05                	jmp    8023c0 <find_block+0x82>
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c0:	a3 48 50 80 00       	mov    %eax,0x805048
  8023c5:	a1 48 50 80 00       	mov    0x805048,%eax
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	75 c8                	jne    802396 <find_block+0x58>
  8023ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023d2:	75 c2                	jne    802396 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8023d4:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  8023e1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023e6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8023e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ed:	75 62                	jne    802451 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8023ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f3:	75 14                	jne    802409 <insert_sorted_allocList+0x2e>
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	68 b0 40 80 00       	push   $0x8040b0
  8023fd:	6a 69                	push   $0x69
  8023ff:	68 d3 40 80 00       	push   $0x8040d3
  802404:	e8 41 e1 ff ff       	call   80054a <_panic>
  802409:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	89 10                	mov    %edx,(%eax)
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	8b 00                	mov    (%eax),%eax
  802419:	85 c0                	test   %eax,%eax
  80241b:	74 0d                	je     80242a <insert_sorted_allocList+0x4f>
  80241d:	a1 40 50 80 00       	mov    0x805040,%eax
  802422:	8b 55 08             	mov    0x8(%ebp),%edx
  802425:	89 50 04             	mov    %edx,0x4(%eax)
  802428:	eb 08                	jmp    802432 <insert_sorted_allocList+0x57>
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	a3 44 50 80 00       	mov    %eax,0x805044
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	a3 40 50 80 00       	mov    %eax,0x805040
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802444:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802449:	40                   	inc    %eax
  80244a:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80244f:	eb 72                	jmp    8024c3 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802451:	a1 40 50 80 00       	mov    0x805040,%eax
  802456:	8b 50 08             	mov    0x8(%eax),%edx
  802459:	8b 45 08             	mov    0x8(%ebp),%eax
  80245c:	8b 40 08             	mov    0x8(%eax),%eax
  80245f:	39 c2                	cmp    %eax,%edx
  802461:	76 60                	jbe    8024c3 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802463:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802467:	75 14                	jne    80247d <insert_sorted_allocList+0xa2>
  802469:	83 ec 04             	sub    $0x4,%esp
  80246c:	68 b0 40 80 00       	push   $0x8040b0
  802471:	6a 6d                	push   $0x6d
  802473:	68 d3 40 80 00       	push   $0x8040d3
  802478:	e8 cd e0 ff ff       	call   80054a <_panic>
  80247d:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	89 10                	mov    %edx,(%eax)
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	8b 00                	mov    (%eax),%eax
  80248d:	85 c0                	test   %eax,%eax
  80248f:	74 0d                	je     80249e <insert_sorted_allocList+0xc3>
  802491:	a1 40 50 80 00       	mov    0x805040,%eax
  802496:	8b 55 08             	mov    0x8(%ebp),%edx
  802499:	89 50 04             	mov    %edx,0x4(%eax)
  80249c:	eb 08                	jmp    8024a6 <insert_sorted_allocList+0xcb>
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	a3 44 50 80 00       	mov    %eax,0x805044
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	a3 40 50 80 00       	mov    %eax,0x805040
  8024ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024bd:	40                   	inc    %eax
  8024be:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8024c3:	a1 40 50 80 00       	mov    0x805040,%eax
  8024c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cb:	e9 b9 01 00 00       	jmp    802689 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8024d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d3:	8b 50 08             	mov    0x8(%eax),%edx
  8024d6:	a1 40 50 80 00       	mov    0x805040,%eax
  8024db:	8b 40 08             	mov    0x8(%eax),%eax
  8024de:	39 c2                	cmp    %eax,%edx
  8024e0:	76 7c                	jbe    80255e <insert_sorted_allocList+0x183>
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	8b 50 08             	mov    0x8(%eax),%edx
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 40 08             	mov    0x8(%eax),%eax
  8024ee:	39 c2                	cmp    %eax,%edx
  8024f0:	73 6c                	jae    80255e <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  8024f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f6:	74 06                	je     8024fe <insert_sorted_allocList+0x123>
  8024f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024fc:	75 14                	jne    802512 <insert_sorted_allocList+0x137>
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	68 ec 40 80 00       	push   $0x8040ec
  802506:	6a 75                	push   $0x75
  802508:	68 d3 40 80 00       	push   $0x8040d3
  80250d:	e8 38 e0 ff ff       	call   80054a <_panic>
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 50 04             	mov    0x4(%eax),%edx
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	89 50 04             	mov    %edx,0x4(%eax)
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802524:	89 10                	mov    %edx,(%eax)
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 40 04             	mov    0x4(%eax),%eax
  80252c:	85 c0                	test   %eax,%eax
  80252e:	74 0d                	je     80253d <insert_sorted_allocList+0x162>
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 40 04             	mov    0x4(%eax),%eax
  802536:	8b 55 08             	mov    0x8(%ebp),%edx
  802539:	89 10                	mov    %edx,(%eax)
  80253b:	eb 08                	jmp    802545 <insert_sorted_allocList+0x16a>
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	a3 40 50 80 00       	mov    %eax,0x805040
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 55 08             	mov    0x8(%ebp),%edx
  80254b:	89 50 04             	mov    %edx,0x4(%eax)
  80254e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802553:	40                   	inc    %eax
  802554:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802559:	e9 59 01 00 00       	jmp    8026b7 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	8b 50 08             	mov    0x8(%eax),%edx
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 40 08             	mov    0x8(%eax),%eax
  80256a:	39 c2                	cmp    %eax,%edx
  80256c:	0f 86 98 00 00 00    	jbe    80260a <insert_sorted_allocList+0x22f>
  802572:	8b 45 08             	mov    0x8(%ebp),%eax
  802575:	8b 50 08             	mov    0x8(%eax),%edx
  802578:	a1 44 50 80 00       	mov    0x805044,%eax
  80257d:	8b 40 08             	mov    0x8(%eax),%eax
  802580:	39 c2                	cmp    %eax,%edx
  802582:	0f 83 82 00 00 00    	jae    80260a <insert_sorted_allocList+0x22f>
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	8b 50 08             	mov    0x8(%eax),%edx
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	8b 40 08             	mov    0x8(%eax),%eax
  802596:	39 c2                	cmp    %eax,%edx
  802598:	73 70                	jae    80260a <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80259a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259e:	74 06                	je     8025a6 <insert_sorted_allocList+0x1cb>
  8025a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025a4:	75 14                	jne    8025ba <insert_sorted_allocList+0x1df>
  8025a6:	83 ec 04             	sub    $0x4,%esp
  8025a9:	68 24 41 80 00       	push   $0x804124
  8025ae:	6a 7c                	push   $0x7c
  8025b0:	68 d3 40 80 00       	push   $0x8040d3
  8025b5:	e8 90 df ff ff       	call   80054a <_panic>
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 10                	mov    (%eax),%edx
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	89 10                	mov    %edx,(%eax)
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	74 0b                	je     8025d8 <insert_sorted_allocList+0x1fd>
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 00                	mov    (%eax),%eax
  8025d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d5:	89 50 04             	mov    %edx,0x4(%eax)
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 55 08             	mov    0x8(%ebp),%edx
  8025de:	89 10                	mov    %edx,(%eax)
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e6:	89 50 04             	mov    %edx,0x4(%eax)
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	8b 00                	mov    (%eax),%eax
  8025ee:	85 c0                	test   %eax,%eax
  8025f0:	75 08                	jne    8025fa <insert_sorted_allocList+0x21f>
  8025f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f5:	a3 44 50 80 00       	mov    %eax,0x805044
  8025fa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ff:	40                   	inc    %eax
  802600:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802605:	e9 ad 00 00 00       	jmp    8026b7 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	8b 50 08             	mov    0x8(%eax),%edx
  802610:	a1 44 50 80 00       	mov    0x805044,%eax
  802615:	8b 40 08             	mov    0x8(%eax),%eax
  802618:	39 c2                	cmp    %eax,%edx
  80261a:	76 65                	jbe    802681 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80261c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802620:	75 17                	jne    802639 <insert_sorted_allocList+0x25e>
  802622:	83 ec 04             	sub    $0x4,%esp
  802625:	68 58 41 80 00       	push   $0x804158
  80262a:	68 80 00 00 00       	push   $0x80
  80262f:	68 d3 40 80 00       	push   $0x8040d3
  802634:	e8 11 df ff ff       	call   80054a <_panic>
  802639:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	89 50 04             	mov    %edx,0x4(%eax)
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	8b 40 04             	mov    0x4(%eax),%eax
  80264b:	85 c0                	test   %eax,%eax
  80264d:	74 0c                	je     80265b <insert_sorted_allocList+0x280>
  80264f:	a1 44 50 80 00       	mov    0x805044,%eax
  802654:	8b 55 08             	mov    0x8(%ebp),%edx
  802657:	89 10                	mov    %edx,(%eax)
  802659:	eb 08                	jmp    802663 <insert_sorted_allocList+0x288>
  80265b:	8b 45 08             	mov    0x8(%ebp),%eax
  80265e:	a3 40 50 80 00       	mov    %eax,0x805040
  802663:	8b 45 08             	mov    0x8(%ebp),%eax
  802666:	a3 44 50 80 00       	mov    %eax,0x805044
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802674:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802679:	40                   	inc    %eax
  80267a:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  80267f:	eb 36                	jmp    8026b7 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802681:	a1 48 50 80 00       	mov    0x805048,%eax
  802686:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802689:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268d:	74 07                	je     802696 <insert_sorted_allocList+0x2bb>
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	eb 05                	jmp    80269b <insert_sorted_allocList+0x2c0>
  802696:	b8 00 00 00 00       	mov    $0x0,%eax
  80269b:	a3 48 50 80 00       	mov    %eax,0x805048
  8026a0:	a1 48 50 80 00       	mov    0x805048,%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	0f 85 23 fe ff ff    	jne    8024d0 <insert_sorted_allocList+0xf5>
  8026ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b1:	0f 85 19 fe ff ff    	jne    8024d0 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8026b7:	90                   	nop
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

008026ba <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
  8026bd:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8026c0:	a1 38 51 80 00       	mov    0x805138,%eax
  8026c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c8:	e9 7c 01 00 00       	jmp    802849 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d6:	0f 85 90 00 00 00    	jne    80276c <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  8026e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e6:	75 17                	jne    8026ff <alloc_block_FF+0x45>
  8026e8:	83 ec 04             	sub    $0x4,%esp
  8026eb:	68 7b 41 80 00       	push   $0x80417b
  8026f0:	68 ba 00 00 00       	push   $0xba
  8026f5:	68 d3 40 80 00       	push   $0x8040d3
  8026fa:	e8 4b de ff ff       	call   80054a <_panic>
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 00                	mov    (%eax),%eax
  802704:	85 c0                	test   %eax,%eax
  802706:	74 10                	je     802718 <alloc_block_FF+0x5e>
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	8b 00                	mov    (%eax),%eax
  80270d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802710:	8b 52 04             	mov    0x4(%edx),%edx
  802713:	89 50 04             	mov    %edx,0x4(%eax)
  802716:	eb 0b                	jmp    802723 <alloc_block_FF+0x69>
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 40 04             	mov    0x4(%eax),%eax
  80271e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 40 04             	mov    0x4(%eax),%eax
  802729:	85 c0                	test   %eax,%eax
  80272b:	74 0f                	je     80273c <alloc_block_FF+0x82>
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 40 04             	mov    0x4(%eax),%eax
  802733:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802736:	8b 12                	mov    (%edx),%edx
  802738:	89 10                	mov    %edx,(%eax)
  80273a:	eb 0a                	jmp    802746 <alloc_block_FF+0x8c>
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	8b 00                	mov    (%eax),%eax
  802741:	a3 38 51 80 00       	mov    %eax,0x805138
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802759:	a1 44 51 80 00       	mov    0x805144,%eax
  80275e:	48                   	dec    %eax
  80275f:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802767:	e9 10 01 00 00       	jmp    80287c <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	8b 40 0c             	mov    0xc(%eax),%eax
  802772:	3b 45 08             	cmp    0x8(%ebp),%eax
  802775:	0f 86 c6 00 00 00    	jbe    802841 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  80277b:	a1 48 51 80 00       	mov    0x805148,%eax
  802780:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802783:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802787:	75 17                	jne    8027a0 <alloc_block_FF+0xe6>
  802789:	83 ec 04             	sub    $0x4,%esp
  80278c:	68 7b 41 80 00       	push   $0x80417b
  802791:	68 c2 00 00 00       	push   $0xc2
  802796:	68 d3 40 80 00       	push   $0x8040d3
  80279b:	e8 aa dd ff ff       	call   80054a <_panic>
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	8b 00                	mov    (%eax),%eax
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	74 10                	je     8027b9 <alloc_block_FF+0xff>
  8027a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027b1:	8b 52 04             	mov    0x4(%edx),%edx
  8027b4:	89 50 04             	mov    %edx,0x4(%eax)
  8027b7:	eb 0b                	jmp    8027c4 <alloc_block_FF+0x10a>
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	8b 40 04             	mov    0x4(%eax),%eax
  8027bf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	74 0f                	je     8027dd <alloc_block_FF+0x123>
  8027ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d1:	8b 40 04             	mov    0x4(%eax),%eax
  8027d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d7:	8b 12                	mov    (%edx),%edx
  8027d9:	89 10                	mov    %edx,(%eax)
  8027db:	eb 0a                	jmp    8027e7 <alloc_block_FF+0x12d>
  8027dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e0:	8b 00                	mov    (%eax),%eax
  8027e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8027e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8027ff:	48                   	dec    %eax
  802800:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 50 08             	mov    0x8(%eax),%edx
  80280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280e:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802814:	8b 55 08             	mov    0x8(%ebp),%edx
  802817:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 40 0c             	mov    0xc(%eax),%eax
  802820:	2b 45 08             	sub    0x8(%ebp),%eax
  802823:	89 c2                	mov    %eax,%edx
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 50 08             	mov    0x8(%eax),%edx
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	01 c2                	add    %eax,%edx
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  80283c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283f:	eb 3b                	jmp    80287c <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802841:	a1 40 51 80 00       	mov    0x805140,%eax
  802846:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802849:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284d:	74 07                	je     802856 <alloc_block_FF+0x19c>
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	eb 05                	jmp    80285b <alloc_block_FF+0x1a1>
  802856:	b8 00 00 00 00       	mov    $0x0,%eax
  80285b:	a3 40 51 80 00       	mov    %eax,0x805140
  802860:	a1 40 51 80 00       	mov    0x805140,%eax
  802865:	85 c0                	test   %eax,%eax
  802867:	0f 85 60 fe ff ff    	jne    8026cd <alloc_block_FF+0x13>
  80286d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802871:	0f 85 56 fe ff ff    	jne    8026cd <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802877:	b8 00 00 00 00       	mov    $0x0,%eax
  80287c:	c9                   	leave  
  80287d:	c3                   	ret    

0080287e <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  80287e:	55                   	push   %ebp
  80287f:	89 e5                	mov    %esp,%ebp
  802881:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802884:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80288b:	a1 38 51 80 00       	mov    0x805138,%eax
  802890:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802893:	eb 3a                	jmp    8028cf <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 40 0c             	mov    0xc(%eax),%eax
  80289b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289e:	72 27                	jb     8028c7 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8028a0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8028a4:	75 0b                	jne    8028b1 <alloc_block_BF+0x33>
					best_size= element->size;
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8028af:	eb 16                	jmp    8028c7 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 50 0c             	mov    0xc(%eax),%edx
  8028b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ba:	39 c2                	cmp    %eax,%edx
  8028bc:	77 09                	ja     8028c7 <alloc_block_BF+0x49>
					best_size=element->size;
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c4:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8028c7:	a1 40 51 80 00       	mov    0x805140,%eax
  8028cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d3:	74 07                	je     8028dc <alloc_block_BF+0x5e>
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 00                	mov    (%eax),%eax
  8028da:	eb 05                	jmp    8028e1 <alloc_block_BF+0x63>
  8028dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e1:	a3 40 51 80 00       	mov    %eax,0x805140
  8028e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	75 a6                	jne    802895 <alloc_block_BF+0x17>
  8028ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f3:	75 a0                	jne    802895 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  8028f5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8028f9:	0f 84 d3 01 00 00    	je     802ad2 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8028ff:	a1 38 51 80 00       	mov    0x805138,%eax
  802904:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802907:	e9 98 01 00 00       	jmp    802aa4 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  80290c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802912:	0f 86 da 00 00 00    	jbe    8029f2 <alloc_block_BF+0x174>
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 50 0c             	mov    0xc(%eax),%edx
  80291e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802921:	39 c2                	cmp    %eax,%edx
  802923:	0f 85 c9 00 00 00    	jne    8029f2 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802929:	a1 48 51 80 00       	mov    0x805148,%eax
  80292e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802931:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802935:	75 17                	jne    80294e <alloc_block_BF+0xd0>
  802937:	83 ec 04             	sub    $0x4,%esp
  80293a:	68 7b 41 80 00       	push   $0x80417b
  80293f:	68 ea 00 00 00       	push   $0xea
  802944:	68 d3 40 80 00       	push   $0x8040d3
  802949:	e8 fc db ff ff       	call   80054a <_panic>
  80294e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802951:	8b 00                	mov    (%eax),%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	74 10                	je     802967 <alloc_block_BF+0xe9>
  802957:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80295f:	8b 52 04             	mov    0x4(%edx),%edx
  802962:	89 50 04             	mov    %edx,0x4(%eax)
  802965:	eb 0b                	jmp    802972 <alloc_block_BF+0xf4>
  802967:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296a:	8b 40 04             	mov    0x4(%eax),%eax
  80296d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	74 0f                	je     80298b <alloc_block_BF+0x10d>
  80297c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297f:	8b 40 04             	mov    0x4(%eax),%eax
  802982:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802985:	8b 12                	mov    (%edx),%edx
  802987:	89 10                	mov    %edx,(%eax)
  802989:	eb 0a                	jmp    802995 <alloc_block_BF+0x117>
  80298b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	a3 48 51 80 00       	mov    %eax,0x805148
  802995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802998:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a8:	a1 54 51 80 00       	mov    0x805154,%eax
  8029ad:	48                   	dec    %eax
  8029ae:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 50 08             	mov    0x8(%eax),%edx
  8029b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bc:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8029bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c5:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d1:	89 c2                	mov    %eax,%edx
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 50 08             	mov    0x8(%eax),%edx
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	01 c2                	add    %eax,%edx
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  8029ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ed:	e9 e5 00 00 00       	jmp    802ad7 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 50 0c             	mov    0xc(%eax),%edx
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	39 c2                	cmp    %eax,%edx
  8029fd:	0f 85 99 00 00 00    	jne    802a9c <alloc_block_BF+0x21e>
  802a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a09:	0f 85 8d 00 00 00    	jne    802a9c <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802a15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a19:	75 17                	jne    802a32 <alloc_block_BF+0x1b4>
  802a1b:	83 ec 04             	sub    $0x4,%esp
  802a1e:	68 7b 41 80 00       	push   $0x80417b
  802a23:	68 f7 00 00 00       	push   $0xf7
  802a28:	68 d3 40 80 00       	push   $0x8040d3
  802a2d:	e8 18 db ff ff       	call   80054a <_panic>
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 00                	mov    (%eax),%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	74 10                	je     802a4b <alloc_block_BF+0x1cd>
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a43:	8b 52 04             	mov    0x4(%edx),%edx
  802a46:	89 50 04             	mov    %edx,0x4(%eax)
  802a49:	eb 0b                	jmp    802a56 <alloc_block_BF+0x1d8>
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 40 04             	mov    0x4(%eax),%eax
  802a51:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 40 04             	mov    0x4(%eax),%eax
  802a5c:	85 c0                	test   %eax,%eax
  802a5e:	74 0f                	je     802a6f <alloc_block_BF+0x1f1>
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 40 04             	mov    0x4(%eax),%eax
  802a66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a69:	8b 12                	mov    (%edx),%edx
  802a6b:	89 10                	mov    %edx,(%eax)
  802a6d:	eb 0a                	jmp    802a79 <alloc_block_BF+0x1fb>
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	8b 00                	mov    (%eax),%eax
  802a74:	a3 38 51 80 00       	mov    %eax,0x805138
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8c:	a1 44 51 80 00       	mov    0x805144,%eax
  802a91:	48                   	dec    %eax
  802a92:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9a:	eb 3b                	jmp    802ad7 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802a9c:	a1 40 51 80 00       	mov    0x805140,%eax
  802aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa8:	74 07                	je     802ab1 <alloc_block_BF+0x233>
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	8b 00                	mov    (%eax),%eax
  802aaf:	eb 05                	jmp    802ab6 <alloc_block_BF+0x238>
  802ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab6:	a3 40 51 80 00       	mov    %eax,0x805140
  802abb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac0:	85 c0                	test   %eax,%eax
  802ac2:	0f 85 44 fe ff ff    	jne    80290c <alloc_block_BF+0x8e>
  802ac8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acc:	0f 85 3a fe ff ff    	jne    80290c <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad7:	c9                   	leave  
  802ad8:	c3                   	ret    

00802ad9 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ad9:	55                   	push   %ebp
  802ada:	89 e5                	mov    %esp,%ebp
  802adc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802adf:	83 ec 04             	sub    $0x4,%esp
  802ae2:	68 9c 41 80 00       	push   $0x80419c
  802ae7:	68 04 01 00 00       	push   $0x104
  802aec:	68 d3 40 80 00       	push   $0x8040d3
  802af1:	e8 54 da ff ff       	call   80054a <_panic>

00802af6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802af6:	55                   	push   %ebp
  802af7:	89 e5                	mov    %esp,%ebp
  802af9:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802afc:	a1 38 51 80 00       	mov    0x805138,%eax
  802b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802b04:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b09:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802b0c:	a1 38 51 80 00       	mov    0x805138,%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	75 68                	jne    802b7d <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802b15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b19:	75 17                	jne    802b32 <insert_sorted_with_merge_freeList+0x3c>
  802b1b:	83 ec 04             	sub    $0x4,%esp
  802b1e:	68 b0 40 80 00       	push   $0x8040b0
  802b23:	68 14 01 00 00       	push   $0x114
  802b28:	68 d3 40 80 00       	push   $0x8040d3
  802b2d:	e8 18 da ff ff       	call   80054a <_panic>
  802b32:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	89 10                	mov    %edx,(%eax)
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	74 0d                	je     802b53 <insert_sorted_with_merge_freeList+0x5d>
  802b46:	a1 38 51 80 00       	mov    0x805138,%eax
  802b4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4e:	89 50 04             	mov    %edx,0x4(%eax)
  802b51:	eb 08                	jmp    802b5b <insert_sorted_with_merge_freeList+0x65>
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5e:	a3 38 51 80 00       	mov    %eax,0x805138
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6d:	a1 44 51 80 00       	mov    0x805144,%eax
  802b72:	40                   	inc    %eax
  802b73:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802b78:	e9 d2 06 00 00       	jmp    80324f <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	8b 50 08             	mov    0x8(%eax),%edx
  802b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b86:	8b 40 08             	mov    0x8(%eax),%eax
  802b89:	39 c2                	cmp    %eax,%edx
  802b8b:	0f 83 22 01 00 00    	jae    802cb3 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	8b 50 08             	mov    0x8(%eax),%edx
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9d:	01 c2                	add    %eax,%edx
  802b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba2:	8b 40 08             	mov    0x8(%eax),%eax
  802ba5:	39 c2                	cmp    %eax,%edx
  802ba7:	0f 85 9e 00 00 00    	jne    802c4b <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	8b 50 08             	mov    0x8(%eax),%edx
  802bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb6:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbc:	8b 50 0c             	mov    0xc(%eax),%edx
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc5:	01 c2                	add    %eax,%edx
  802bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bca:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	8b 50 08             	mov    0x8(%eax),%edx
  802bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802be0:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802be3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be7:	75 17                	jne    802c00 <insert_sorted_with_merge_freeList+0x10a>
  802be9:	83 ec 04             	sub    $0x4,%esp
  802bec:	68 b0 40 80 00       	push   $0x8040b0
  802bf1:	68 21 01 00 00       	push   $0x121
  802bf6:	68 d3 40 80 00       	push   $0x8040d3
  802bfb:	e8 4a d9 ff ff       	call   80054a <_panic>
  802c00:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	89 10                	mov    %edx,(%eax)
  802c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	74 0d                	je     802c21 <insert_sorted_with_merge_freeList+0x12b>
  802c14:	a1 48 51 80 00       	mov    0x805148,%eax
  802c19:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1c:	89 50 04             	mov    %edx,0x4(%eax)
  802c1f:	eb 08                	jmp    802c29 <insert_sorted_with_merge_freeList+0x133>
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	a3 48 51 80 00       	mov    %eax,0x805148
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3b:	a1 54 51 80 00       	mov    0x805154,%eax
  802c40:	40                   	inc    %eax
  802c41:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802c46:	e9 04 06 00 00       	jmp    80324f <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802c4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4f:	75 17                	jne    802c68 <insert_sorted_with_merge_freeList+0x172>
  802c51:	83 ec 04             	sub    $0x4,%esp
  802c54:	68 b0 40 80 00       	push   $0x8040b0
  802c59:	68 26 01 00 00       	push   $0x126
  802c5e:	68 d3 40 80 00       	push   $0x8040d3
  802c63:	e8 e2 d8 ff ff       	call   80054a <_panic>
  802c68:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	89 10                	mov    %edx,(%eax)
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	74 0d                	je     802c89 <insert_sorted_with_merge_freeList+0x193>
  802c7c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c81:	8b 55 08             	mov    0x8(%ebp),%edx
  802c84:	89 50 04             	mov    %edx,0x4(%eax)
  802c87:	eb 08                	jmp    802c91 <insert_sorted_with_merge_freeList+0x19b>
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	a3 38 51 80 00       	mov    %eax,0x805138
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ca8:	40                   	inc    %eax
  802ca9:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802cae:	e9 9c 05 00 00       	jmp    80324f <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	8b 50 08             	mov    0x8(%eax),%edx
  802cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbc:	8b 40 08             	mov    0x8(%eax),%eax
  802cbf:	39 c2                	cmp    %eax,%edx
  802cc1:	0f 86 16 01 00 00    	jbe    802ddd <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cca:	8b 50 08             	mov    0x8(%eax),%edx
  802ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd3:	01 c2                	add    %eax,%edx
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	8b 40 08             	mov    0x8(%eax),%eax
  802cdb:	39 c2                	cmp    %eax,%edx
  802cdd:	0f 85 92 00 00 00    	jne    802d75 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 40 0c             	mov    0xc(%eax),%eax
  802cef:	01 c2                	add    %eax,%edx
  802cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf4:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	8b 50 08             	mov    0x8(%eax),%edx
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d11:	75 17                	jne    802d2a <insert_sorted_with_merge_freeList+0x234>
  802d13:	83 ec 04             	sub    $0x4,%esp
  802d16:	68 b0 40 80 00       	push   $0x8040b0
  802d1b:	68 31 01 00 00       	push   $0x131
  802d20:	68 d3 40 80 00       	push   $0x8040d3
  802d25:	e8 20 d8 ff ff       	call   80054a <_panic>
  802d2a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	89 10                	mov    %edx,(%eax)
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 0d                	je     802d4b <insert_sorted_with_merge_freeList+0x255>
  802d3e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d43:	8b 55 08             	mov    0x8(%ebp),%edx
  802d46:	89 50 04             	mov    %edx,0x4(%eax)
  802d49:	eb 08                	jmp    802d53 <insert_sorted_with_merge_freeList+0x25d>
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	a3 48 51 80 00       	mov    %eax,0x805148
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d65:	a1 54 51 80 00       	mov    0x805154,%eax
  802d6a:	40                   	inc    %eax
  802d6b:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802d70:	e9 da 04 00 00       	jmp    80324f <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802d75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d79:	75 17                	jne    802d92 <insert_sorted_with_merge_freeList+0x29c>
  802d7b:	83 ec 04             	sub    $0x4,%esp
  802d7e:	68 58 41 80 00       	push   $0x804158
  802d83:	68 37 01 00 00       	push   $0x137
  802d88:	68 d3 40 80 00       	push   $0x8040d3
  802d8d:	e8 b8 d7 ff ff       	call   80054a <_panic>
  802d92:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	89 50 04             	mov    %edx,0x4(%eax)
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	8b 40 04             	mov    0x4(%eax),%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	74 0c                	je     802db4 <insert_sorted_with_merge_freeList+0x2be>
  802da8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dad:	8b 55 08             	mov    0x8(%ebp),%edx
  802db0:	89 10                	mov    %edx,(%eax)
  802db2:	eb 08                	jmp    802dbc <insert_sorted_with_merge_freeList+0x2c6>
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	a3 38 51 80 00       	mov    %eax,0x805138
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dcd:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd2:	40                   	inc    %eax
  802dd3:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802dd8:	e9 72 04 00 00       	jmp    80324f <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802ddd:	a1 38 51 80 00       	mov    0x805138,%eax
  802de2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de5:	e9 35 04 00 00       	jmp    80321f <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	8b 50 08             	mov    0x8(%eax),%edx
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	8b 40 08             	mov    0x8(%eax),%eax
  802dfe:	39 c2                	cmp    %eax,%edx
  802e00:	0f 86 11 04 00 00    	jbe    803217 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 50 08             	mov    0x8(%eax),%edx
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e12:	01 c2                	add    %eax,%edx
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 40 08             	mov    0x8(%eax),%eax
  802e1a:	39 c2                	cmp    %eax,%edx
  802e1c:	0f 83 8b 00 00 00    	jae    802ead <insert_sorted_with_merge_freeList+0x3b7>
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	8b 50 08             	mov    0x8(%eax),%edx
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2e:	01 c2                	add    %eax,%edx
  802e30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e33:	8b 40 08             	mov    0x8(%eax),%eax
  802e36:	39 c2                	cmp    %eax,%edx
  802e38:	73 73                	jae    802ead <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3e:	74 06                	je     802e46 <insert_sorted_with_merge_freeList+0x350>
  802e40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e44:	75 17                	jne    802e5d <insert_sorted_with_merge_freeList+0x367>
  802e46:	83 ec 04             	sub    $0x4,%esp
  802e49:	68 24 41 80 00       	push   $0x804124
  802e4e:	68 48 01 00 00       	push   $0x148
  802e53:	68 d3 40 80 00       	push   $0x8040d3
  802e58:	e8 ed d6 ff ff       	call   80054a <_panic>
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 10                	mov    (%eax),%edx
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	89 10                	mov    %edx,(%eax)
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	8b 00                	mov    (%eax),%eax
  802e6c:	85 c0                	test   %eax,%eax
  802e6e:	74 0b                	je     802e7b <insert_sorted_with_merge_freeList+0x385>
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	8b 55 08             	mov    0x8(%ebp),%edx
  802e78:	89 50 04             	mov    %edx,0x4(%eax)
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e81:	89 10                	mov    %edx,(%eax)
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e89:	89 50 04             	mov    %edx,0x4(%eax)
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	8b 00                	mov    (%eax),%eax
  802e91:	85 c0                	test   %eax,%eax
  802e93:	75 08                	jne    802e9d <insert_sorted_with_merge_freeList+0x3a7>
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e9d:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea2:	40                   	inc    %eax
  802ea3:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  802ea8:	e9 a2 03 00 00       	jmp    80324f <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	8b 50 08             	mov    0x8(%eax),%edx
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb9:	01 c2                	add    %eax,%edx
  802ebb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebe:	8b 40 08             	mov    0x8(%eax),%eax
  802ec1:	39 c2                	cmp    %eax,%edx
  802ec3:	0f 83 ae 00 00 00    	jae    802f77 <insert_sorted_with_merge_freeList+0x481>
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	8b 50 08             	mov    0x8(%eax),%edx
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	8b 48 08             	mov    0x8(%eax),%ecx
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 40 0c             	mov    0xc(%eax),%eax
  802edb:	01 c8                	add    %ecx,%eax
  802edd:	39 c2                	cmp    %eax,%edx
  802edf:	0f 85 92 00 00 00    	jne    802f77 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	8b 50 0c             	mov    0xc(%eax),%edx
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef1:	01 c2                	add    %eax,%edx
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	8b 50 08             	mov    0x8(%eax),%edx
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f13:	75 17                	jne    802f2c <insert_sorted_with_merge_freeList+0x436>
  802f15:	83 ec 04             	sub    $0x4,%esp
  802f18:	68 b0 40 80 00       	push   $0x8040b0
  802f1d:	68 51 01 00 00       	push   $0x151
  802f22:	68 d3 40 80 00       	push   $0x8040d3
  802f27:	e8 1e d6 ff ff       	call   80054a <_panic>
  802f2c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	89 10                	mov    %edx,(%eax)
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	8b 00                	mov    (%eax),%eax
  802f3c:	85 c0                	test   %eax,%eax
  802f3e:	74 0d                	je     802f4d <insert_sorted_with_merge_freeList+0x457>
  802f40:	a1 48 51 80 00       	mov    0x805148,%eax
  802f45:	8b 55 08             	mov    0x8(%ebp),%edx
  802f48:	89 50 04             	mov    %edx,0x4(%eax)
  802f4b:	eb 08                	jmp    802f55 <insert_sorted_with_merge_freeList+0x45f>
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	a3 48 51 80 00       	mov    %eax,0x805148
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f67:	a1 54 51 80 00       	mov    0x805154,%eax
  802f6c:	40                   	inc    %eax
  802f6d:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  802f72:	e9 d8 02 00 00       	jmp    80324f <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 50 08             	mov    0x8(%eax),%edx
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	8b 40 0c             	mov    0xc(%eax),%eax
  802f83:	01 c2                	add    %eax,%edx
  802f85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f88:	8b 40 08             	mov    0x8(%eax),%eax
  802f8b:	39 c2                	cmp    %eax,%edx
  802f8d:	0f 85 ba 00 00 00    	jne    80304d <insert_sorted_with_merge_freeList+0x557>
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	8b 50 08             	mov    0x8(%eax),%edx
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	8b 48 08             	mov    0x8(%eax),%ecx
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa5:	01 c8                	add    %ecx,%eax
  802fa7:	39 c2                	cmp    %eax,%edx
  802fa9:	0f 86 9e 00 00 00    	jbe    80304d <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802faf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb2:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbb:	01 c2                	add    %eax,%edx
  802fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc0:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8b 50 08             	mov    0x8(%eax),%edx
  802fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcc:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	8b 50 08             	mov    0x8(%eax),%edx
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802fe5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe9:	75 17                	jne    803002 <insert_sorted_with_merge_freeList+0x50c>
  802feb:	83 ec 04             	sub    $0x4,%esp
  802fee:	68 b0 40 80 00       	push   $0x8040b0
  802ff3:	68 5b 01 00 00       	push   $0x15b
  802ff8:	68 d3 40 80 00       	push   $0x8040d3
  802ffd:	e8 48 d5 ff ff       	call   80054a <_panic>
  803002:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	89 10                	mov    %edx,(%eax)
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	8b 00                	mov    (%eax),%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	74 0d                	je     803023 <insert_sorted_with_merge_freeList+0x52d>
  803016:	a1 48 51 80 00       	mov    0x805148,%eax
  80301b:	8b 55 08             	mov    0x8(%ebp),%edx
  80301e:	89 50 04             	mov    %edx,0x4(%eax)
  803021:	eb 08                	jmp    80302b <insert_sorted_with_merge_freeList+0x535>
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	a3 48 51 80 00       	mov    %eax,0x805148
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303d:	a1 54 51 80 00       	mov    0x805154,%eax
  803042:	40                   	inc    %eax
  803043:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803048:	e9 02 02 00 00       	jmp    80324f <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	8b 50 08             	mov    0x8(%eax),%edx
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	8b 40 0c             	mov    0xc(%eax),%eax
  803059:	01 c2                	add    %eax,%edx
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	8b 40 08             	mov    0x8(%eax),%eax
  803061:	39 c2                	cmp    %eax,%edx
  803063:	0f 85 ae 01 00 00    	jne    803217 <insert_sorted_with_merge_freeList+0x721>
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	8b 50 08             	mov    0x8(%eax),%edx
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 48 08             	mov    0x8(%eax),%ecx
  803075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803078:	8b 40 0c             	mov    0xc(%eax),%eax
  80307b:	01 c8                	add    %ecx,%eax
  80307d:	39 c2                	cmp    %eax,%edx
  80307f:	0f 85 92 01 00 00    	jne    803217 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803088:	8b 50 0c             	mov    0xc(%eax),%edx
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	8b 40 0c             	mov    0xc(%eax),%eax
  803091:	01 c2                	add    %eax,%edx
  803093:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803096:	8b 40 0c             	mov    0xc(%eax),%eax
  803099:	01 c2                	add    %eax,%edx
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	8b 50 08             	mov    0x8(%eax),%edx
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  8030b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c4:	8b 50 08             	mov    0x8(%eax),%edx
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  8030cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d1:	75 17                	jne    8030ea <insert_sorted_with_merge_freeList+0x5f4>
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	68 7b 41 80 00       	push   $0x80417b
  8030db:	68 63 01 00 00       	push   $0x163
  8030e0:	68 d3 40 80 00       	push   $0x8040d3
  8030e5:	e8 60 d4 ff ff       	call   80054a <_panic>
  8030ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ed:	8b 00                	mov    (%eax),%eax
  8030ef:	85 c0                	test   %eax,%eax
  8030f1:	74 10                	je     803103 <insert_sorted_with_merge_freeList+0x60d>
  8030f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f6:	8b 00                	mov    (%eax),%eax
  8030f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030fb:	8b 52 04             	mov    0x4(%edx),%edx
  8030fe:	89 50 04             	mov    %edx,0x4(%eax)
  803101:	eb 0b                	jmp    80310e <insert_sorted_with_merge_freeList+0x618>
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	8b 40 04             	mov    0x4(%eax),%eax
  803109:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80310e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803111:	8b 40 04             	mov    0x4(%eax),%eax
  803114:	85 c0                	test   %eax,%eax
  803116:	74 0f                	je     803127 <insert_sorted_with_merge_freeList+0x631>
  803118:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311b:	8b 40 04             	mov    0x4(%eax),%eax
  80311e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803121:	8b 12                	mov    (%edx),%edx
  803123:	89 10                	mov    %edx,(%eax)
  803125:	eb 0a                	jmp    803131 <insert_sorted_with_merge_freeList+0x63b>
  803127:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	a3 38 51 80 00       	mov    %eax,0x805138
  803131:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803134:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803144:	a1 44 51 80 00       	mov    0x805144,%eax
  803149:	48                   	dec    %eax
  80314a:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  80314f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803153:	75 17                	jne    80316c <insert_sorted_with_merge_freeList+0x676>
  803155:	83 ec 04             	sub    $0x4,%esp
  803158:	68 b0 40 80 00       	push   $0x8040b0
  80315d:	68 64 01 00 00       	push   $0x164
  803162:	68 d3 40 80 00       	push   $0x8040d3
  803167:	e8 de d3 ff ff       	call   80054a <_panic>
  80316c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803175:	89 10                	mov    %edx,(%eax)
  803177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	85 c0                	test   %eax,%eax
  80317e:	74 0d                	je     80318d <insert_sorted_with_merge_freeList+0x697>
  803180:	a1 48 51 80 00       	mov    0x805148,%eax
  803185:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803188:	89 50 04             	mov    %edx,0x4(%eax)
  80318b:	eb 08                	jmp    803195 <insert_sorted_with_merge_freeList+0x69f>
  80318d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803190:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803195:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803198:	a3 48 51 80 00       	mov    %eax,0x805148
  80319d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ac:	40                   	inc    %eax
  8031ad:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8031b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b6:	75 17                	jne    8031cf <insert_sorted_with_merge_freeList+0x6d9>
  8031b8:	83 ec 04             	sub    $0x4,%esp
  8031bb:	68 b0 40 80 00       	push   $0x8040b0
  8031c0:	68 65 01 00 00       	push   $0x165
  8031c5:	68 d3 40 80 00       	push   $0x8040d3
  8031ca:	e8 7b d3 ff ff       	call   80054a <_panic>
  8031cf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	89 10                	mov    %edx,(%eax)
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	85 c0                	test   %eax,%eax
  8031e1:	74 0d                	je     8031f0 <insert_sorted_with_merge_freeList+0x6fa>
  8031e3:	a1 48 51 80 00       	mov    0x805148,%eax
  8031e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031eb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ee:	eb 08                	jmp    8031f8 <insert_sorted_with_merge_freeList+0x702>
  8031f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fb:	a3 48 51 80 00       	mov    %eax,0x805148
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320a:	a1 54 51 80 00       	mov    0x805154,%eax
  80320f:	40                   	inc    %eax
  803210:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803215:	eb 38                	jmp    80324f <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803217:	a1 40 51 80 00       	mov    0x805140,%eax
  80321c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80321f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803223:	74 07                	je     80322c <insert_sorted_with_merge_freeList+0x736>
  803225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	eb 05                	jmp    803231 <insert_sorted_with_merge_freeList+0x73b>
  80322c:	b8 00 00 00 00       	mov    $0x0,%eax
  803231:	a3 40 51 80 00       	mov    %eax,0x805140
  803236:	a1 40 51 80 00       	mov    0x805140,%eax
  80323b:	85 c0                	test   %eax,%eax
  80323d:	0f 85 a7 fb ff ff    	jne    802dea <insert_sorted_with_merge_freeList+0x2f4>
  803243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803247:	0f 85 9d fb ff ff    	jne    802dea <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80324d:	eb 00                	jmp    80324f <insert_sorted_with_merge_freeList+0x759>
  80324f:	90                   	nop
  803250:	c9                   	leave  
  803251:	c3                   	ret    

00803252 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803252:	55                   	push   %ebp
  803253:	89 e5                	mov    %esp,%ebp
  803255:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803258:	8b 55 08             	mov    0x8(%ebp),%edx
  80325b:	89 d0                	mov    %edx,%eax
  80325d:	c1 e0 02             	shl    $0x2,%eax
  803260:	01 d0                	add    %edx,%eax
  803262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803269:	01 d0                	add    %edx,%eax
  80326b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803272:	01 d0                	add    %edx,%eax
  803274:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80327b:	01 d0                	add    %edx,%eax
  80327d:	c1 e0 04             	shl    $0x4,%eax
  803280:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803283:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80328a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80328d:	83 ec 0c             	sub    $0xc,%esp
  803290:	50                   	push   %eax
  803291:	e8 ee eb ff ff       	call   801e84 <sys_get_virtual_time>
  803296:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803299:	eb 41                	jmp    8032dc <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80329b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80329e:	83 ec 0c             	sub    $0xc,%esp
  8032a1:	50                   	push   %eax
  8032a2:	e8 dd eb ff ff       	call   801e84 <sys_get_virtual_time>
  8032a7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8032aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b0:	29 c2                	sub    %eax,%edx
  8032b2:	89 d0                	mov    %edx,%eax
  8032b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8032b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032bd:	89 d1                	mov    %edx,%ecx
  8032bf:	29 c1                	sub    %eax,%ecx
  8032c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c7:	39 c2                	cmp    %eax,%edx
  8032c9:	0f 97 c0             	seta   %al
  8032cc:	0f b6 c0             	movzbl %al,%eax
  8032cf:	29 c1                	sub    %eax,%ecx
  8032d1:	89 c8                	mov    %ecx,%eax
  8032d3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8032d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8032e2:	72 b7                	jb     80329b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8032e4:	90                   	nop
  8032e5:	c9                   	leave  
  8032e6:	c3                   	ret    

008032e7 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8032e7:	55                   	push   %ebp
  8032e8:	89 e5                	mov    %esp,%ebp
  8032ea:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8032ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8032f4:	eb 03                	jmp    8032f9 <busy_wait+0x12>
  8032f6:	ff 45 fc             	incl   -0x4(%ebp)
  8032f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ff:	72 f5                	jb     8032f6 <busy_wait+0xf>
	return i;
  803301:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803304:	c9                   	leave  
  803305:	c3                   	ret    
  803306:	66 90                	xchg   %ax,%ax

00803308 <__udivdi3>:
  803308:	55                   	push   %ebp
  803309:	57                   	push   %edi
  80330a:	56                   	push   %esi
  80330b:	53                   	push   %ebx
  80330c:	83 ec 1c             	sub    $0x1c,%esp
  80330f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803313:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803317:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80331b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80331f:	89 ca                	mov    %ecx,%edx
  803321:	89 f8                	mov    %edi,%eax
  803323:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803327:	85 f6                	test   %esi,%esi
  803329:	75 2d                	jne    803358 <__udivdi3+0x50>
  80332b:	39 cf                	cmp    %ecx,%edi
  80332d:	77 65                	ja     803394 <__udivdi3+0x8c>
  80332f:	89 fd                	mov    %edi,%ebp
  803331:	85 ff                	test   %edi,%edi
  803333:	75 0b                	jne    803340 <__udivdi3+0x38>
  803335:	b8 01 00 00 00       	mov    $0x1,%eax
  80333a:	31 d2                	xor    %edx,%edx
  80333c:	f7 f7                	div    %edi
  80333e:	89 c5                	mov    %eax,%ebp
  803340:	31 d2                	xor    %edx,%edx
  803342:	89 c8                	mov    %ecx,%eax
  803344:	f7 f5                	div    %ebp
  803346:	89 c1                	mov    %eax,%ecx
  803348:	89 d8                	mov    %ebx,%eax
  80334a:	f7 f5                	div    %ebp
  80334c:	89 cf                	mov    %ecx,%edi
  80334e:	89 fa                	mov    %edi,%edx
  803350:	83 c4 1c             	add    $0x1c,%esp
  803353:	5b                   	pop    %ebx
  803354:	5e                   	pop    %esi
  803355:	5f                   	pop    %edi
  803356:	5d                   	pop    %ebp
  803357:	c3                   	ret    
  803358:	39 ce                	cmp    %ecx,%esi
  80335a:	77 28                	ja     803384 <__udivdi3+0x7c>
  80335c:	0f bd fe             	bsr    %esi,%edi
  80335f:	83 f7 1f             	xor    $0x1f,%edi
  803362:	75 40                	jne    8033a4 <__udivdi3+0x9c>
  803364:	39 ce                	cmp    %ecx,%esi
  803366:	72 0a                	jb     803372 <__udivdi3+0x6a>
  803368:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80336c:	0f 87 9e 00 00 00    	ja     803410 <__udivdi3+0x108>
  803372:	b8 01 00 00 00       	mov    $0x1,%eax
  803377:	89 fa                	mov    %edi,%edx
  803379:	83 c4 1c             	add    $0x1c,%esp
  80337c:	5b                   	pop    %ebx
  80337d:	5e                   	pop    %esi
  80337e:	5f                   	pop    %edi
  80337f:	5d                   	pop    %ebp
  803380:	c3                   	ret    
  803381:	8d 76 00             	lea    0x0(%esi),%esi
  803384:	31 ff                	xor    %edi,%edi
  803386:	31 c0                	xor    %eax,%eax
  803388:	89 fa                	mov    %edi,%edx
  80338a:	83 c4 1c             	add    $0x1c,%esp
  80338d:	5b                   	pop    %ebx
  80338e:	5e                   	pop    %esi
  80338f:	5f                   	pop    %edi
  803390:	5d                   	pop    %ebp
  803391:	c3                   	ret    
  803392:	66 90                	xchg   %ax,%ax
  803394:	89 d8                	mov    %ebx,%eax
  803396:	f7 f7                	div    %edi
  803398:	31 ff                	xor    %edi,%edi
  80339a:	89 fa                	mov    %edi,%edx
  80339c:	83 c4 1c             	add    $0x1c,%esp
  80339f:	5b                   	pop    %ebx
  8033a0:	5e                   	pop    %esi
  8033a1:	5f                   	pop    %edi
  8033a2:	5d                   	pop    %ebp
  8033a3:	c3                   	ret    
  8033a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033a9:	89 eb                	mov    %ebp,%ebx
  8033ab:	29 fb                	sub    %edi,%ebx
  8033ad:	89 f9                	mov    %edi,%ecx
  8033af:	d3 e6                	shl    %cl,%esi
  8033b1:	89 c5                	mov    %eax,%ebp
  8033b3:	88 d9                	mov    %bl,%cl
  8033b5:	d3 ed                	shr    %cl,%ebp
  8033b7:	89 e9                	mov    %ebp,%ecx
  8033b9:	09 f1                	or     %esi,%ecx
  8033bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033bf:	89 f9                	mov    %edi,%ecx
  8033c1:	d3 e0                	shl    %cl,%eax
  8033c3:	89 c5                	mov    %eax,%ebp
  8033c5:	89 d6                	mov    %edx,%esi
  8033c7:	88 d9                	mov    %bl,%cl
  8033c9:	d3 ee                	shr    %cl,%esi
  8033cb:	89 f9                	mov    %edi,%ecx
  8033cd:	d3 e2                	shl    %cl,%edx
  8033cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033d3:	88 d9                	mov    %bl,%cl
  8033d5:	d3 e8                	shr    %cl,%eax
  8033d7:	09 c2                	or     %eax,%edx
  8033d9:	89 d0                	mov    %edx,%eax
  8033db:	89 f2                	mov    %esi,%edx
  8033dd:	f7 74 24 0c          	divl   0xc(%esp)
  8033e1:	89 d6                	mov    %edx,%esi
  8033e3:	89 c3                	mov    %eax,%ebx
  8033e5:	f7 e5                	mul    %ebp
  8033e7:	39 d6                	cmp    %edx,%esi
  8033e9:	72 19                	jb     803404 <__udivdi3+0xfc>
  8033eb:	74 0b                	je     8033f8 <__udivdi3+0xf0>
  8033ed:	89 d8                	mov    %ebx,%eax
  8033ef:	31 ff                	xor    %edi,%edi
  8033f1:	e9 58 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  8033f6:	66 90                	xchg   %ax,%ax
  8033f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033fc:	89 f9                	mov    %edi,%ecx
  8033fe:	d3 e2                	shl    %cl,%edx
  803400:	39 c2                	cmp    %eax,%edx
  803402:	73 e9                	jae    8033ed <__udivdi3+0xe5>
  803404:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803407:	31 ff                	xor    %edi,%edi
  803409:	e9 40 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  80340e:	66 90                	xchg   %ax,%ax
  803410:	31 c0                	xor    %eax,%eax
  803412:	e9 37 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  803417:	90                   	nop

00803418 <__umoddi3>:
  803418:	55                   	push   %ebp
  803419:	57                   	push   %edi
  80341a:	56                   	push   %esi
  80341b:	53                   	push   %ebx
  80341c:	83 ec 1c             	sub    $0x1c,%esp
  80341f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803423:	8b 74 24 34          	mov    0x34(%esp),%esi
  803427:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80342b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80342f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803433:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803437:	89 f3                	mov    %esi,%ebx
  803439:	89 fa                	mov    %edi,%edx
  80343b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80343f:	89 34 24             	mov    %esi,(%esp)
  803442:	85 c0                	test   %eax,%eax
  803444:	75 1a                	jne    803460 <__umoddi3+0x48>
  803446:	39 f7                	cmp    %esi,%edi
  803448:	0f 86 a2 00 00 00    	jbe    8034f0 <__umoddi3+0xd8>
  80344e:	89 c8                	mov    %ecx,%eax
  803450:	89 f2                	mov    %esi,%edx
  803452:	f7 f7                	div    %edi
  803454:	89 d0                	mov    %edx,%eax
  803456:	31 d2                	xor    %edx,%edx
  803458:	83 c4 1c             	add    $0x1c,%esp
  80345b:	5b                   	pop    %ebx
  80345c:	5e                   	pop    %esi
  80345d:	5f                   	pop    %edi
  80345e:	5d                   	pop    %ebp
  80345f:	c3                   	ret    
  803460:	39 f0                	cmp    %esi,%eax
  803462:	0f 87 ac 00 00 00    	ja     803514 <__umoddi3+0xfc>
  803468:	0f bd e8             	bsr    %eax,%ebp
  80346b:	83 f5 1f             	xor    $0x1f,%ebp
  80346e:	0f 84 ac 00 00 00    	je     803520 <__umoddi3+0x108>
  803474:	bf 20 00 00 00       	mov    $0x20,%edi
  803479:	29 ef                	sub    %ebp,%edi
  80347b:	89 fe                	mov    %edi,%esi
  80347d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803481:	89 e9                	mov    %ebp,%ecx
  803483:	d3 e0                	shl    %cl,%eax
  803485:	89 d7                	mov    %edx,%edi
  803487:	89 f1                	mov    %esi,%ecx
  803489:	d3 ef                	shr    %cl,%edi
  80348b:	09 c7                	or     %eax,%edi
  80348d:	89 e9                	mov    %ebp,%ecx
  80348f:	d3 e2                	shl    %cl,%edx
  803491:	89 14 24             	mov    %edx,(%esp)
  803494:	89 d8                	mov    %ebx,%eax
  803496:	d3 e0                	shl    %cl,%eax
  803498:	89 c2                	mov    %eax,%edx
  80349a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80349e:	d3 e0                	shl    %cl,%eax
  8034a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034a8:	89 f1                	mov    %esi,%ecx
  8034aa:	d3 e8                	shr    %cl,%eax
  8034ac:	09 d0                	or     %edx,%eax
  8034ae:	d3 eb                	shr    %cl,%ebx
  8034b0:	89 da                	mov    %ebx,%edx
  8034b2:	f7 f7                	div    %edi
  8034b4:	89 d3                	mov    %edx,%ebx
  8034b6:	f7 24 24             	mull   (%esp)
  8034b9:	89 c6                	mov    %eax,%esi
  8034bb:	89 d1                	mov    %edx,%ecx
  8034bd:	39 d3                	cmp    %edx,%ebx
  8034bf:	0f 82 87 00 00 00    	jb     80354c <__umoddi3+0x134>
  8034c5:	0f 84 91 00 00 00    	je     80355c <__umoddi3+0x144>
  8034cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034cf:	29 f2                	sub    %esi,%edx
  8034d1:	19 cb                	sbb    %ecx,%ebx
  8034d3:	89 d8                	mov    %ebx,%eax
  8034d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034d9:	d3 e0                	shl    %cl,%eax
  8034db:	89 e9                	mov    %ebp,%ecx
  8034dd:	d3 ea                	shr    %cl,%edx
  8034df:	09 d0                	or     %edx,%eax
  8034e1:	89 e9                	mov    %ebp,%ecx
  8034e3:	d3 eb                	shr    %cl,%ebx
  8034e5:	89 da                	mov    %ebx,%edx
  8034e7:	83 c4 1c             	add    $0x1c,%esp
  8034ea:	5b                   	pop    %ebx
  8034eb:	5e                   	pop    %esi
  8034ec:	5f                   	pop    %edi
  8034ed:	5d                   	pop    %ebp
  8034ee:	c3                   	ret    
  8034ef:	90                   	nop
  8034f0:	89 fd                	mov    %edi,%ebp
  8034f2:	85 ff                	test   %edi,%edi
  8034f4:	75 0b                	jne    803501 <__umoddi3+0xe9>
  8034f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034fb:	31 d2                	xor    %edx,%edx
  8034fd:	f7 f7                	div    %edi
  8034ff:	89 c5                	mov    %eax,%ebp
  803501:	89 f0                	mov    %esi,%eax
  803503:	31 d2                	xor    %edx,%edx
  803505:	f7 f5                	div    %ebp
  803507:	89 c8                	mov    %ecx,%eax
  803509:	f7 f5                	div    %ebp
  80350b:	89 d0                	mov    %edx,%eax
  80350d:	e9 44 ff ff ff       	jmp    803456 <__umoddi3+0x3e>
  803512:	66 90                	xchg   %ax,%ax
  803514:	89 c8                	mov    %ecx,%eax
  803516:	89 f2                	mov    %esi,%edx
  803518:	83 c4 1c             	add    $0x1c,%esp
  80351b:	5b                   	pop    %ebx
  80351c:	5e                   	pop    %esi
  80351d:	5f                   	pop    %edi
  80351e:	5d                   	pop    %ebp
  80351f:	c3                   	ret    
  803520:	3b 04 24             	cmp    (%esp),%eax
  803523:	72 06                	jb     80352b <__umoddi3+0x113>
  803525:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803529:	77 0f                	ja     80353a <__umoddi3+0x122>
  80352b:	89 f2                	mov    %esi,%edx
  80352d:	29 f9                	sub    %edi,%ecx
  80352f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803533:	89 14 24             	mov    %edx,(%esp)
  803536:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80353a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80353e:	8b 14 24             	mov    (%esp),%edx
  803541:	83 c4 1c             	add    $0x1c,%esp
  803544:	5b                   	pop    %ebx
  803545:	5e                   	pop    %esi
  803546:	5f                   	pop    %edi
  803547:	5d                   	pop    %ebp
  803548:	c3                   	ret    
  803549:	8d 76 00             	lea    0x0(%esi),%esi
  80354c:	2b 04 24             	sub    (%esp),%eax
  80354f:	19 fa                	sbb    %edi,%edx
  803551:	89 d1                	mov    %edx,%ecx
  803553:	89 c6                	mov    %eax,%esi
  803555:	e9 71 ff ff ff       	jmp    8034cb <__umoddi3+0xb3>
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803560:	72 ea                	jb     80354c <__umoddi3+0x134>
  803562:	89 d9                	mov    %ebx,%ecx
  803564:	e9 62 ff ff ff       	jmp    8034cb <__umoddi3+0xb3>
