
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
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
  80008d:	68 e0 35 80 00       	push   $0x8035e0
  800092:	6a 12                	push   $0x12
  800094:	68 fc 35 80 00       	push   $0x8035fc
  800099:	e8 11 05 00 00       	call   8005af <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 1c 36 80 00       	push   $0x80361c
  8000a6:	e8 b8 07 00 00       	call   800863 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 50 36 80 00       	push   $0x803650
  8000b6:	e8 a8 07 00 00       	call   800863 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 ac 36 80 00       	push   $0x8036ac
  8000c6:	e8 98 07 00 00       	call   800863 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 b1 1d 00 00       	call   801e84 <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 e0 36 80 00       	push   $0x8036e0
  8000de:	e8 80 07 00 00       	call   800863 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000eb:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8000f8:	8b 40 74             	mov    0x74(%eax),%eax
  8000fb:	6a 32                	push   $0x32
  8000fd:	52                   	push   %edx
  8000fe:	50                   	push   %eax
  8000ff:	68 21 37 80 00       	push   $0x803721
  800104:	e8 26 1d 00 00       	call   801e2f <sys_create_env>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80010f:	a1 20 50 80 00       	mov    0x805020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c2                	mov    %eax,%edx
  80011c:	a1 20 50 80 00       	mov    0x805020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	6a 32                	push   $0x32
  800126:	52                   	push   %edx
  800127:	50                   	push   %eax
  800128:	68 21 37 80 00       	push   $0x803721
  80012d:	e8 fd 1c 00 00       	call   801e2f <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 80 1a 00 00       	call   801bbd <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 2f 37 80 00       	push   $0x80372f
  80014f:	e8 8a 17 00 00       	call   8018de <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 34 37 80 00       	push   $0x803734
  800162:	e8 fc 06 00 00       	call   800863 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 54 37 80 00       	push   $0x803754
  80017b:	6a 26                	push   $0x26
  80017d:	68 fc 35 80 00       	push   $0x8035fc
  800182:	e8 28 04 00 00       	call   8005af <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 2e 1a 00 00       	call   801bbd <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 c0 37 80 00       	push   $0x8037c0
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 fc 35 80 00       	push   $0x8035fc
  8001a7:	e8 03 04 00 00       	call   8005af <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 ca 1d 00 00       	call   801f7b <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 91 1c 00 00       	call   801e4d <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 83 1c 00 00       	call   801e4d <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 3e 38 80 00       	push   $0x80383e
  8001d5:	e8 89 06 00 00       	call   800863 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 cd 30 00 00       	call   8032b7 <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 03 1e 00 00       	call   801ff5 <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 55 38 80 00       	push   $0x803855
  8001ff:	6a 33                	push   $0x33
  800201:	68 fc 35 80 00       	push   $0x8035fc
  800206:	e8 a4 03 00 00       	call   8005af <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 47 18 00 00       	call   801a5d <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 64 38 80 00       	push   $0x803864
  800221:	e8 3d 06 00 00       	call   800863 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 8f 19 00 00       	call   801bbd <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 84 38 80 00       	push   $0x803884
  800248:	6a 38                	push   $0x38
  80024a:	68 fc 35 80 00       	push   $0x8035fc
  80024f:	e8 5b 03 00 00       	call   8005af <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 b4 38 80 00       	push   $0x8038b4
  80025c:	e8 02 06 00 00       	call   800863 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 d8 38 80 00       	push   $0x8038d8
  80026c:	e8 f2 05 00 00       	call   800863 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80027f:	89 c2                	mov    %eax,%edx
  800281:	a1 20 50 80 00       	mov    0x805020,%eax
  800286:	8b 40 74             	mov    0x74(%eax),%eax
  800289:	6a 32                	push   $0x32
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 08 39 80 00       	push   $0x803908
  800292:	e8 98 1b 00 00       	call   801e2f <sys_create_env>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  80029d:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002a8:	89 c2                	mov    %eax,%edx
  8002aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8002af:	8b 40 74             	mov    0x74(%eax),%eax
  8002b2:	6a 32                	push   $0x32
  8002b4:	52                   	push   %edx
  8002b5:	50                   	push   %eax
  8002b6:	68 18 39 80 00       	push   $0x803918
  8002bb:	e8 6f 1b 00 00       	call   801e2f <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 28 39 80 00       	push   $0x803928
  8002d5:	e8 04 16 00 00       	call   8018de <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 2c 39 80 00       	push   $0x80392c
  8002e8:	e8 76 05 00 00       	call   800863 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 2f 37 80 00       	push   $0x80372f
  8002ff:	e8 da 15 00 00       	call   8018de <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 34 37 80 00       	push   $0x803734
  800312:	e8 4c 05 00 00       	call   800863 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 5c 1c 00 00       	call   801f7b <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 23 1b 00 00       	call   801e4d <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 15 1b 00 00       	call   801e4d <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 6f 2f 00 00       	call   8032b7 <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 6d 18 00 00       	call   801bbd <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 ff 16 00 00       	call   801a5d <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 4c 39 80 00       	push   $0x80394c
  800369:	e8 f5 04 00 00       	call   800863 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 e1 16 00 00       	call   801a5d <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 62 39 80 00       	push   $0x803962
  800387:	e8 d7 04 00 00       	call   800863 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 29 18 00 00       	call   801bbd <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 78 39 80 00       	push   $0x803978
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 fc 35 80 00       	push   $0x8035fc
  8003b5:	e8 f5 01 00 00       	call   8005af <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 1c 1c 00 00       	call   801fdb <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 1d 3a 80 00       	push   $0x803a1d
  8003cb:	e8 0e 15 00 00       	call   8018de <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 d2 1a 00 00       	call   801eb6 <sys_getparentenvid>
  8003e4:	85 c0                	test   %eax,%eax
  8003e6:	0f 8e 81 00 00 00    	jle    80046d <_main+0x435>
			while(*finish_children != 1);
  8003ec:	90                   	nop
  8003ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	83 f8 01             	cmp    $0x1,%eax
  8003f5:	75 f6                	jne    8003ed <_main+0x3b5>
			cprintf("done\n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 2d 3a 80 00       	push   $0x803a2d
  8003ff:	e8 5f 04 00 00       	call   800863 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 57 1a 00 00       	call   801e69 <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 49 1a 00 00       	call   801e69 <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 3b 1a 00 00       	call   801e69 <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 2d 1a 00 00       	call   801e69 <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 6b 1a 00 00       	call   801eb6 <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 33 3a 80 00       	push   $0x803a33
  800453:	50                   	push   %eax
  800454:	e8 2e 15 00 00       	call   801987 <sget>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	89 45 b8             	mov    %eax,-0x48(%ebp)
			(*finishedCount)++ ;
  80045f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 50 01             	lea    0x1(%eax),%edx
  800467:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80046a:	89 10                	mov    %edx,(%eax)
		}
	}


	return;
  80046c:	90                   	nop
  80046d:	90                   	nop
}
  80046e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 1f 1a 00 00       	call   801e9d <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 c1 17 00 00       	call   801caa <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 5c 3a 80 00       	push   $0x803a5c
  8004f1:	e8 6d 03 00 00       	call   800863 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 50 80 00       	mov    0x805020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 84 3a 80 00       	push   $0x803a84
  800519:	e8 45 03 00 00       	call   800863 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 50 80 00       	mov    0x805020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 50 80 00       	mov    0x805020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 50 80 00       	mov    0x805020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 ac 3a 80 00       	push   $0x803aac
  80054a:	e8 14 03 00 00       	call   800863 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 04 3b 80 00       	push   $0x803b04
  800566:	e8 f8 02 00 00       	call   800863 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 5c 3a 80 00       	push   $0x803a5c
  800576:	e8 e8 02 00 00       	call   800863 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 41 17 00 00       	call   801cc4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 ce 18 00 00       	call   801e69 <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 23 19 00 00       	call   801ecf <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8005b8:	83 c0 04             	add    $0x4,%eax
  8005bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005be:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	74 16                	je     8005dd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005c7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	50                   	push   %eax
  8005d0:	68 18 3b 80 00       	push   $0x803b18
  8005d5:	e8 89 02 00 00       	call   800863 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	68 1d 3b 80 00       	push   $0x803b1d
  8005ee:	e8 70 02 00 00       	call   800863 <cprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ff:	50                   	push   %eax
  800600:	e8 f3 01 00 00       	call   8007f8 <vcprintf>
  800605:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	6a 00                	push   $0x0
  80060d:	68 39 3b 80 00       	push   $0x803b39
  800612:	e8 e1 01 00 00       	call   8007f8 <vcprintf>
  800617:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80061a:	e8 82 ff ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  80061f:	eb fe                	jmp    80061f <_panic+0x70>

00800621 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800621:	55                   	push   %ebp
  800622:	89 e5                	mov    %esp,%ebp
  800624:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800627:	a1 20 50 80 00       	mov    0x805020,%eax
  80062c:	8b 50 74             	mov    0x74(%eax),%edx
  80062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800632:	39 c2                	cmp    %eax,%edx
  800634:	74 14                	je     80064a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800636:	83 ec 04             	sub    $0x4,%esp
  800639:	68 3c 3b 80 00       	push   $0x803b3c
  80063e:	6a 26                	push   $0x26
  800640:	68 88 3b 80 00       	push   $0x803b88
  800645:	e8 65 ff ff ff       	call   8005af <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80064a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800651:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800658:	e9 c2 00 00 00       	jmp    80071f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	01 d0                	add    %edx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	85 c0                	test   %eax,%eax
  800670:	75 08                	jne    80067a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800672:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800675:	e9 a2 00 00 00       	jmp    80071c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80067a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800681:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800688:	eb 69                	jmp    8006f3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80068a:	a1 20 50 80 00       	mov    0x805020,%eax
  80068f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800695:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800698:	89 d0                	mov    %edx,%eax
  80069a:	01 c0                	add    %eax,%eax
  80069c:	01 d0                	add    %edx,%eax
  80069e:	c1 e0 03             	shl    $0x3,%eax
  8006a1:	01 c8                	add    %ecx,%eax
  8006a3:	8a 40 04             	mov    0x4(%eax),%al
  8006a6:	84 c0                	test   %al,%al
  8006a8:	75 46                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8006af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b8:	89 d0                	mov    %edx,%eax
  8006ba:	01 c0                	add    %eax,%eax
  8006bc:	01 d0                	add    %edx,%eax
  8006be:	c1 e0 03             	shl    $0x3,%eax
  8006c1:	01 c8                	add    %ecx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006d0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	01 c8                	add    %ecx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006e3:	39 c2                	cmp    %eax,%edx
  8006e5:	75 09                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8006e7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006ee:	eb 12                	jmp    800702 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f0:	ff 45 e8             	incl   -0x18(%ebp)
  8006f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f8:	8b 50 74             	mov    0x74(%eax),%edx
  8006fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006fe:	39 c2                	cmp    %eax,%edx
  800700:	77 88                	ja     80068a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800702:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800706:	75 14                	jne    80071c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800708:	83 ec 04             	sub    $0x4,%esp
  80070b:	68 94 3b 80 00       	push   $0x803b94
  800710:	6a 3a                	push   $0x3a
  800712:	68 88 3b 80 00       	push   $0x803b88
  800717:	e8 93 fe ff ff       	call   8005af <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80071c:	ff 45 f0             	incl   -0x10(%ebp)
  80071f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800722:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800725:	0f 8c 32 ff ff ff    	jl     80065d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80072b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800732:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800739:	eb 26                	jmp    800761 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80073b:	a1 20 50 80 00       	mov    0x805020,%eax
  800740:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800746:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800749:	89 d0                	mov    %edx,%eax
  80074b:	01 c0                	add    %eax,%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	c1 e0 03             	shl    $0x3,%eax
  800752:	01 c8                	add    %ecx,%eax
  800754:	8a 40 04             	mov    0x4(%eax),%al
  800757:	3c 01                	cmp    $0x1,%al
  800759:	75 03                	jne    80075e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80075b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80075e:	ff 45 e0             	incl   -0x20(%ebp)
  800761:	a1 20 50 80 00       	mov    0x805020,%eax
  800766:	8b 50 74             	mov    0x74(%eax),%edx
  800769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80076c:	39 c2                	cmp    %eax,%edx
  80076e:	77 cb                	ja     80073b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800773:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800776:	74 14                	je     80078c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800778:	83 ec 04             	sub    $0x4,%esp
  80077b:	68 e8 3b 80 00       	push   $0x803be8
  800780:	6a 44                	push   $0x44
  800782:	68 88 3b 80 00       	push   $0x803b88
  800787:	e8 23 fe ff ff       	call   8005af <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80078c:	90                   	nop
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8d 48 01             	lea    0x1(%eax),%ecx
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a0:	89 0a                	mov    %ecx,(%edx)
  8007a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8007a5:	88 d1                	mov    %dl,%cl
  8007a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007aa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007b8:	75 2c                	jne    8007e6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007ba:	a0 24 50 80 00       	mov    0x805024,%al
  8007bf:	0f b6 c0             	movzbl %al,%eax
  8007c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c5:	8b 12                	mov    (%edx),%edx
  8007c7:	89 d1                	mov    %edx,%ecx
  8007c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cc:	83 c2 08             	add    $0x8,%edx
  8007cf:	83 ec 04             	sub    $0x4,%esp
  8007d2:	50                   	push   %eax
  8007d3:	51                   	push   %ecx
  8007d4:	52                   	push   %edx
  8007d5:	e8 22 13 00 00       	call   801afc <sys_cputs>
  8007da:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	8b 40 04             	mov    0x4(%eax),%eax
  8007ec:	8d 50 01             	lea    0x1(%eax),%edx
  8007ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007f5:	90                   	nop
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800801:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800808:	00 00 00 
	b.cnt = 0;
  80080b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800812:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 08             	pushl  0x8(%ebp)
  80081b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800821:	50                   	push   %eax
  800822:	68 8f 07 80 00       	push   $0x80078f
  800827:	e8 11 02 00 00       	call   800a3d <vprintfmt>
  80082c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80082f:	a0 24 50 80 00       	mov    0x805024,%al
  800834:	0f b6 c0             	movzbl %al,%eax
  800837:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80083d:	83 ec 04             	sub    $0x4,%esp
  800840:	50                   	push   %eax
  800841:	52                   	push   %edx
  800842:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800848:	83 c0 08             	add    $0x8,%eax
  80084b:	50                   	push   %eax
  80084c:	e8 ab 12 00 00       	call   801afc <sys_cputs>
  800851:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800854:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80085b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800861:	c9                   	leave  
  800862:	c3                   	ret    

00800863 <cprintf>:

int cprintf(const char *fmt, ...) {
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800869:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800870:	8d 45 0c             	lea    0xc(%ebp),%eax
  800873:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	ff 75 f4             	pushl  -0xc(%ebp)
  80087f:	50                   	push   %eax
  800880:	e8 73 ff ff ff       	call   8007f8 <vcprintf>
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80088b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800896:	e8 0f 14 00 00       	call   801caa <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80089b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80089e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008aa:	50                   	push   %eax
  8008ab:	e8 48 ff ff ff       	call   8007f8 <vcprintf>
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008b6:	e8 09 14 00 00       	call   801cc4 <sys_enable_interrupt>
	return cnt;
  8008bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	53                   	push   %ebx
  8008c4:	83 ec 14             	sub    $0x14,%esp
  8008c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8008d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008de:	77 55                	ja     800935 <printnum+0x75>
  8008e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008e3:	72 05                	jb     8008ea <printnum+0x2a>
  8008e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008e8:	77 4b                	ja     800935 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008ea:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008ed:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	52                   	push   %edx
  8008f9:	50                   	push   %eax
  8008fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8008fd:	ff 75 f0             	pushl  -0x10(%ebp)
  800900:	e8 67 2a 00 00       	call   80336c <__udivdi3>
  800905:	83 c4 10             	add    $0x10,%esp
  800908:	83 ec 04             	sub    $0x4,%esp
  80090b:	ff 75 20             	pushl  0x20(%ebp)
  80090e:	53                   	push   %ebx
  80090f:	ff 75 18             	pushl  0x18(%ebp)
  800912:	52                   	push   %edx
  800913:	50                   	push   %eax
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 a1 ff ff ff       	call   8008c0 <printnum>
  80091f:	83 c4 20             	add    $0x20,%esp
  800922:	eb 1a                	jmp    80093e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	ff 75 20             	pushl  0x20(%ebp)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	ff d0                	call   *%eax
  800932:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800935:	ff 4d 1c             	decl   0x1c(%ebp)
  800938:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80093c:	7f e6                	jg     800924 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80093e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800941:	bb 00 00 00 00       	mov    $0x0,%ebx
  800946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800949:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80094c:	53                   	push   %ebx
  80094d:	51                   	push   %ecx
  80094e:	52                   	push   %edx
  80094f:	50                   	push   %eax
  800950:	e8 27 2b 00 00       	call   80347c <__umoddi3>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	05 54 3e 80 00       	add    $0x803e54,%eax
  80095d:	8a 00                	mov    (%eax),%al
  80095f:	0f be c0             	movsbl %al,%eax
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	50                   	push   %eax
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
}
  800971:	90                   	nop
  800972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80097e:	7e 1c                	jle    80099c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	8d 50 08             	lea    0x8(%eax),%edx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	89 10                	mov    %edx,(%eax)
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	83 e8 08             	sub    $0x8,%eax
  800995:	8b 50 04             	mov    0x4(%eax),%edx
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	eb 40                	jmp    8009dc <getuint+0x65>
	else if (lflag)
  80099c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a0:	74 1e                	je     8009c0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 50 04             	lea    0x4(%eax),%edx
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	89 10                	mov    %edx,(%eax)
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	83 e8 04             	sub    $0x4,%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009be:	eb 1c                	jmp    8009dc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	8d 50 04             	lea    0x4(%eax),%edx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 10                	mov    %edx,(%eax)
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	83 e8 04             	sub    $0x4,%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009e5:	7e 1c                	jle    800a03 <getint+0x25>
		return va_arg(*ap, long long);
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 00                	mov    (%eax),%eax
  8009ec:	8d 50 08             	lea    0x8(%eax),%edx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	89 10                	mov    %edx,(%eax)
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	83 e8 08             	sub    $0x8,%eax
  8009fc:	8b 50 04             	mov    0x4(%eax),%edx
  8009ff:	8b 00                	mov    (%eax),%eax
  800a01:	eb 38                	jmp    800a3b <getint+0x5d>
	else if (lflag)
  800a03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a07:	74 1a                	je     800a23 <getint+0x45>
		return va_arg(*ap, long);
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	8d 50 04             	lea    0x4(%eax),%edx
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	89 10                	mov    %edx,(%eax)
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	83 e8 04             	sub    $0x4,%eax
  800a1e:	8b 00                	mov    (%eax),%eax
  800a20:	99                   	cltd   
  800a21:	eb 18                	jmp    800a3b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	8d 50 04             	lea    0x4(%eax),%edx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	89 10                	mov    %edx,(%eax)
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	83 e8 04             	sub    $0x4,%eax
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	99                   	cltd   
}
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a45:	eb 17                	jmp    800a5e <vprintfmt+0x21>
			if (ch == '\0')
  800a47:	85 db                	test   %ebx,%ebx
  800a49:	0f 84 af 03 00 00    	je     800dfe <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	53                   	push   %ebx
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a61:	8d 50 01             	lea    0x1(%eax),%edx
  800a64:	89 55 10             	mov    %edx,0x10(%ebp)
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	0f b6 d8             	movzbl %al,%ebx
  800a6c:	83 fb 25             	cmp    $0x25,%ebx
  800a6f:	75 d6                	jne    800a47 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a71:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a75:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a7c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a83:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a8a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a91:	8b 45 10             	mov    0x10(%ebp),%eax
  800a94:	8d 50 01             	lea    0x1(%eax),%edx
  800a97:	89 55 10             	mov    %edx,0x10(%ebp)
  800a9a:	8a 00                	mov    (%eax),%al
  800a9c:	0f b6 d8             	movzbl %al,%ebx
  800a9f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800aa2:	83 f8 55             	cmp    $0x55,%eax
  800aa5:	0f 87 2b 03 00 00    	ja     800dd6 <vprintfmt+0x399>
  800aab:	8b 04 85 78 3e 80 00 	mov    0x803e78(,%eax,4),%eax
  800ab2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ab4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ab8:	eb d7                	jmp    800a91 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aba:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800abe:	eb d1                	jmp    800a91 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ac7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aca:	89 d0                	mov    %edx,%eax
  800acc:	c1 e0 02             	shl    $0x2,%eax
  800acf:	01 d0                	add    %edx,%eax
  800ad1:	01 c0                	add    %eax,%eax
  800ad3:	01 d8                	add    %ebx,%eax
  800ad5:	83 e8 30             	sub    $0x30,%eax
  800ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800adb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ade:	8a 00                	mov    (%eax),%al
  800ae0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ae3:	83 fb 2f             	cmp    $0x2f,%ebx
  800ae6:	7e 3e                	jle    800b26 <vprintfmt+0xe9>
  800ae8:	83 fb 39             	cmp    $0x39,%ebx
  800aeb:	7f 39                	jg     800b26 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aed:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800af0:	eb d5                	jmp    800ac7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	83 c0 04             	add    $0x4,%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 e8 04             	sub    $0x4,%eax
  800b01:	8b 00                	mov    (%eax),%eax
  800b03:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b06:	eb 1f                	jmp    800b27 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0c:	79 83                	jns    800a91 <vprintfmt+0x54>
				width = 0;
  800b0e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b15:	e9 77 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b1a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b21:	e9 6b ff ff ff       	jmp    800a91 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b26:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2b:	0f 89 60 ff ff ff    	jns    800a91 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b37:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b3e:	e9 4e ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b43:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b46:	e9 46 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	50                   	push   %eax
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
			break;
  800b6b:	e9 89 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b70:	8b 45 14             	mov    0x14(%ebp),%eax
  800b73:	83 c0 04             	add    $0x4,%eax
  800b76:	89 45 14             	mov    %eax,0x14(%ebp)
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b81:	85 db                	test   %ebx,%ebx
  800b83:	79 02                	jns    800b87 <vprintfmt+0x14a>
				err = -err;
  800b85:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b87:	83 fb 64             	cmp    $0x64,%ebx
  800b8a:	7f 0b                	jg     800b97 <vprintfmt+0x15a>
  800b8c:	8b 34 9d c0 3c 80 00 	mov    0x803cc0(,%ebx,4),%esi
  800b93:	85 f6                	test   %esi,%esi
  800b95:	75 19                	jne    800bb0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b97:	53                   	push   %ebx
  800b98:	68 65 3e 80 00       	push   $0x803e65
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	ff 75 08             	pushl  0x8(%ebp)
  800ba3:	e8 5e 02 00 00       	call   800e06 <printfmt>
  800ba8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bab:	e9 49 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bb0:	56                   	push   %esi
  800bb1:	68 6e 3e 80 00       	push   $0x803e6e
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	ff 75 08             	pushl  0x8(%ebp)
  800bbc:	e8 45 02 00 00       	call   800e06 <printfmt>
  800bc1:	83 c4 10             	add    $0x10,%esp
			break;
  800bc4:	e9 30 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcc:	83 c0 04             	add    $0x4,%eax
  800bcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd5:	83 e8 04             	sub    $0x4,%eax
  800bd8:	8b 30                	mov    (%eax),%esi
  800bda:	85 f6                	test   %esi,%esi
  800bdc:	75 05                	jne    800be3 <vprintfmt+0x1a6>
				p = "(null)";
  800bde:	be 71 3e 80 00       	mov    $0x803e71,%esi
			if (width > 0 && padc != '-')
  800be3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be7:	7e 6d                	jle    800c56 <vprintfmt+0x219>
  800be9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bed:	74 67                	je     800c56 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	56                   	push   %esi
  800bf7:	e8 0c 03 00 00       	call   800f08 <strnlen>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c02:	eb 16                	jmp    800c1a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c04:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	50                   	push   %eax
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c17:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1e:	7f e4                	jg     800c04 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c20:	eb 34                	jmp    800c56 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c26:	74 1c                	je     800c44 <vprintfmt+0x207>
  800c28:	83 fb 1f             	cmp    $0x1f,%ebx
  800c2b:	7e 05                	jle    800c32 <vprintfmt+0x1f5>
  800c2d:	83 fb 7e             	cmp    $0x7e,%ebx
  800c30:	7e 12                	jle    800c44 <vprintfmt+0x207>
					putch('?', putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	6a 3f                	push   $0x3f
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	eb 0f                	jmp    800c53 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	53                   	push   %ebx
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	ff d0                	call   *%eax
  800c50:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c53:	ff 4d e4             	decl   -0x1c(%ebp)
  800c56:	89 f0                	mov    %esi,%eax
  800c58:	8d 70 01             	lea    0x1(%eax),%esi
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f be d8             	movsbl %al,%ebx
  800c60:	85 db                	test   %ebx,%ebx
  800c62:	74 24                	je     800c88 <vprintfmt+0x24b>
  800c64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c68:	78 b8                	js     800c22 <vprintfmt+0x1e5>
  800c6a:	ff 4d e0             	decl   -0x20(%ebp)
  800c6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c71:	79 af                	jns    800c22 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c73:	eb 13                	jmp    800c88 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	6a 20                	push   $0x20
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c85:	ff 4d e4             	decl   -0x1c(%ebp)
  800c88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8c:	7f e7                	jg     800c75 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c8e:	e9 66 01 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 e8             	pushl  -0x18(%ebp)
  800c99:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	e8 3c fd ff ff       	call   8009de <getint>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb1:	85 d2                	test   %edx,%edx
  800cb3:	79 23                	jns    800cd8 <vprintfmt+0x29b>
				putch('-', putdat);
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	6a 2d                	push   $0x2d
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ccb:	f7 d8                	neg    %eax
  800ccd:	83 d2 00             	adc    $0x0,%edx
  800cd0:	f7 da                	neg    %edx
  800cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cd8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cdf:	e9 bc 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cea:	8d 45 14             	lea    0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	e8 84 fc ff ff       	call   800977 <getuint>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cfc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d03:	e9 98 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	6a 58                	push   $0x58
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	ff d0                	call   *%eax
  800d15:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d18:	83 ec 08             	sub    $0x8,%esp
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	6a 58                	push   $0x58
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	6a 58                	push   $0x58
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	ff d0                	call   *%eax
  800d35:	83 c4 10             	add    $0x10,%esp
			break;
  800d38:	e9 bc 00 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	6a 30                	push   $0x30
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d4d:	83 ec 08             	sub    $0x8,%esp
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	6a 78                	push   $0x78
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	ff d0                	call   *%eax
  800d5a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	83 c0 04             	add    $0x4,%eax
  800d63:	89 45 14             	mov    %eax,0x14(%ebp)
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 e8 04             	sub    $0x4,%eax
  800d6c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d78:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d7f:	eb 1f                	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 e8             	pushl  -0x18(%ebp)
  800d87:	8d 45 14             	lea    0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	e8 e7 fb ff ff       	call   800977 <getuint>
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d99:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800da0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da7:	83 ec 04             	sub    $0x4,%esp
  800daa:	52                   	push   %edx
  800dab:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dae:	50                   	push   %eax
  800daf:	ff 75 f4             	pushl  -0xc(%ebp)
  800db2:	ff 75 f0             	pushl  -0x10(%ebp)
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	ff 75 08             	pushl  0x8(%ebp)
  800dbb:	e8 00 fb ff ff       	call   8008c0 <printnum>
  800dc0:	83 c4 20             	add    $0x20,%esp
			break;
  800dc3:	eb 34                	jmp    800df9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 0c             	pushl  0xc(%ebp)
  800dcb:	53                   	push   %ebx
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	ff d0                	call   *%eax
  800dd1:	83 c4 10             	add    $0x10,%esp
			break;
  800dd4:	eb 23                	jmp    800df9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd6:	83 ec 08             	sub    $0x8,%esp
  800dd9:	ff 75 0c             	pushl  0xc(%ebp)
  800ddc:	6a 25                	push   $0x25
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	ff d0                	call   *%eax
  800de3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de6:	ff 4d 10             	decl   0x10(%ebp)
  800de9:	eb 03                	jmp    800dee <vprintfmt+0x3b1>
  800deb:	ff 4d 10             	decl   0x10(%ebp)
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	48                   	dec    %eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3c 25                	cmp    $0x25,%al
  800df6:	75 f3                	jne    800deb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800df8:	90                   	nop
		}
	}
  800df9:	e9 47 fc ff ff       	jmp    800a45 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dfe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0f:	83 c0 04             	add    $0x4,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	ff 75 08             	pushl  0x8(%ebp)
  800e22:	e8 16 fc ff ff       	call   800a3d <vprintfmt>
  800e27:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e2a:	90                   	nop
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8b 40 08             	mov    0x8(%eax),%eax
  800e36:	8d 50 01             	lea    0x1(%eax),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8b 10                	mov    (%eax),%edx
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8b 40 04             	mov    0x4(%eax),%eax
  800e4a:	39 c2                	cmp    %eax,%edx
  800e4c:	73 12                	jae    800e60 <sprintputch+0x33>
		*b->buf++ = ch;
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8b 00                	mov    (%eax),%eax
  800e53:	8d 48 01             	lea    0x1(%eax),%ecx
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	89 0a                	mov    %ecx,(%edx)
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	88 10                	mov    %dl,(%eax)
}
  800e60:	90                   	nop
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	74 06                	je     800e90 <vsnprintf+0x2d>
  800e8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8e:	7f 07                	jg     800e97 <vsnprintf+0x34>
		return -E_INVAL;
  800e90:	b8 03 00 00 00       	mov    $0x3,%eax
  800e95:	eb 20                	jmp    800eb7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e97:	ff 75 14             	pushl  0x14(%ebp)
  800e9a:	ff 75 10             	pushl  0x10(%ebp)
  800e9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ea0:	50                   	push   %eax
  800ea1:	68 2d 0e 80 00       	push   $0x800e2d
  800ea6:	e8 92 fb ff ff       	call   800a3d <vprintfmt>
  800eab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ebf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ec2:	83 c0 04             	add    $0x4,%eax
  800ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	ff 75 08             	pushl  0x8(%ebp)
  800ed5:	e8 89 ff ff ff       	call   800e63 <vsnprintf>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef2:	eb 06                	jmp    800efa <strlen+0x15>
		n++;
  800ef4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 f1                	jne    800ef4 <strlen+0xf>
		n++;
	return n;
  800f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f15:	eb 09                	jmp    800f20 <strnlen+0x18>
		n++;
  800f17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	ff 4d 0c             	decl   0xc(%ebp)
  800f20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f24:	74 09                	je     800f2f <strnlen+0x27>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	84 c0                	test   %al,%al
  800f2d:	75 e8                	jne    800f17 <strnlen+0xf>
		n++;
	return n;
  800f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f40:	90                   	nop
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8d 50 01             	lea    0x1(%eax),%edx
  800f47:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f53:	8a 12                	mov    (%edx),%dl
  800f55:	88 10                	mov    %dl,(%eax)
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	84 c0                	test   %al,%al
  800f5b:	75 e4                	jne    800f41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f75:	eb 1f                	jmp    800f96 <strncpy+0x34>
		*dst++ = *src;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8d 50 01             	lea    0x1(%eax),%edx
  800f7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f83:	8a 12                	mov    (%edx),%dl
  800f85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	84 c0                	test   %al,%al
  800f8e:	74 03                	je     800f93 <strncpy+0x31>
			src++;
  800f90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f93:	ff 45 fc             	incl   -0x4(%ebp)
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f9c:	72 d9                	jb     800f77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	74 30                	je     800fe5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fb5:	eb 16                	jmp    800fcd <strlcpy+0x2a>
			*dst++ = *src++;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8d 50 01             	lea    0x1(%eax),%edx
  800fbd:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fc9:	8a 12                	mov    (%edx),%dl
  800fcb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd4:	74 09                	je     800fdf <strlcpy+0x3c>
  800fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	84 c0                	test   %al,%al
  800fdd:	75 d8                	jne    800fb7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800feb:	29 c2                	sub    %eax,%edx
  800fed:	89 d0                	mov    %edx,%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ff4:	eb 06                	jmp    800ffc <strcmp+0xb>
		p++, q++;
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	84 c0                	test   %al,%al
  801003:	74 0e                	je     801013 <strcmp+0x22>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 10                	mov    (%eax),%dl
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	38 c2                	cmp    %al,%dl
  801011:	74 e3                	je     800ff6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	0f b6 d0             	movzbl %al,%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f b6 c0             	movzbl %al,%eax
  801023:	29 c2                	sub    %eax,%edx
  801025:	89 d0                	mov    %edx,%eax
}
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80102c:	eb 09                	jmp    801037 <strncmp+0xe>
		n--, p++, q++;
  80102e:	ff 4d 10             	decl   0x10(%ebp)
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801037:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103b:	74 17                	je     801054 <strncmp+0x2b>
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	84 c0                	test   %al,%al
  801044:	74 0e                	je     801054 <strncmp+0x2b>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 10                	mov    (%eax),%dl
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	38 c2                	cmp    %al,%dl
  801052:	74 da                	je     80102e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801054:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801058:	75 07                	jne    801061 <strncmp+0x38>
		return 0;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
  80105f:	eb 14                	jmp    801075 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	0f b6 d0             	movzbl %al,%edx
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	0f b6 c0             	movzbl %al,%eax
  801071:	29 c2                	sub    %eax,%edx
  801073:	89 d0                	mov    %edx,%eax
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 04             	sub    $0x4,%esp
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801083:	eb 12                	jmp    801097 <strchr+0x20>
		if (*s == c)
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80108d:	75 05                	jne    801094 <strchr+0x1d>
			return (char *) s;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	eb 11                	jmp    8010a5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	84 c0                	test   %al,%al
  80109e:	75 e5                	jne    801085 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010b3:	eb 0d                	jmp    8010c2 <strfind+0x1b>
		if (*s == c)
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010bd:	74 0e                	je     8010cd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010bf:	ff 45 08             	incl   0x8(%ebp)
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	84 c0                	test   %al,%al
  8010c9:	75 ea                	jne    8010b5 <strfind+0xe>
  8010cb:	eb 01                	jmp    8010ce <strfind+0x27>
		if (*s == c)
			break;
  8010cd:	90                   	nop
	return (char *) s;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010df:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010e5:	eb 0e                	jmp    8010f5 <memset+0x22>
		*p++ = c;
  8010e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ea:	8d 50 01             	lea    0x1(%eax),%edx
  8010ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010f5:	ff 4d f8             	decl   -0x8(%ebp)
  8010f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010fc:	79 e9                	jns    8010e7 <memset+0x14>
		*p++ = c;

	return v;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801115:	eb 16                	jmp    80112d <memcpy+0x2a>
		*d++ = *s++;
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8d 50 01             	lea    0x1(%eax),%edx
  80111d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801120:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801123:	8d 4a 01             	lea    0x1(%edx),%ecx
  801126:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801129:	8a 12                	mov    (%edx),%dl
  80112b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80112d:	8b 45 10             	mov    0x10(%ebp),%eax
  801130:	8d 50 ff             	lea    -0x1(%eax),%edx
  801133:	89 55 10             	mov    %edx,0x10(%ebp)
  801136:	85 c0                	test   %eax,%eax
  801138:	75 dd                	jne    801117 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801151:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801154:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801157:	73 50                	jae    8011a9 <memmove+0x6a>
  801159:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115c:	8b 45 10             	mov    0x10(%ebp),%eax
  80115f:	01 d0                	add    %edx,%eax
  801161:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801164:	76 43                	jbe    8011a9 <memmove+0x6a>
		s += n;
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80116c:	8b 45 10             	mov    0x10(%ebp),%eax
  80116f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801172:	eb 10                	jmp    801184 <memmove+0x45>
			*--d = *--s;
  801174:	ff 4d f8             	decl   -0x8(%ebp)
  801177:	ff 4d fc             	decl   -0x4(%ebp)
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117d:	8a 10                	mov    (%eax),%dl
  80117f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801182:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118a:	89 55 10             	mov    %edx,0x10(%ebp)
  80118d:	85 c0                	test   %eax,%eax
  80118f:	75 e3                	jne    801174 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801191:	eb 23                	jmp    8011b6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801193:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801196:	8d 50 01             	lea    0x1(%eax),%edx
  801199:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a5:	8a 12                	mov    (%edx),%dl
  8011a7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011af:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	75 dd                	jne    801193 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011cd:	eb 2a                	jmp    8011f9 <memcmp+0x3e>
		if (*s1 != *s2)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	8a 10                	mov    (%eax),%dl
  8011d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	38 c2                	cmp    %al,%dl
  8011db:	74 16                	je     8011f3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d0             	movzbl %al,%edx
  8011e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	0f b6 c0             	movzbl %al,%eax
  8011ed:	29 c2                	sub    %eax,%edx
  8011ef:	89 d0                	mov    %edx,%eax
  8011f1:	eb 18                	jmp    80120b <memcmp+0x50>
		s1++, s2++;
  8011f3:	ff 45 fc             	incl   -0x4(%ebp)
  8011f6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801202:	85 c0                	test   %eax,%eax
  801204:	75 c9                	jne    8011cf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801213:	8b 55 08             	mov    0x8(%ebp),%edx
  801216:	8b 45 10             	mov    0x10(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80121e:	eb 15                	jmp    801235 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	0f b6 c0             	movzbl %al,%eax
  80122e:	39 c2                	cmp    %eax,%edx
  801230:	74 0d                	je     80123f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801232:	ff 45 08             	incl   0x8(%ebp)
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123b:	72 e3                	jb     801220 <memfind+0x13>
  80123d:	eb 01                	jmp    801240 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80123f:	90                   	nop
	return (void *) s;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801259:	eb 03                	jmp    80125e <strtol+0x19>
		s++;
  80125b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 20                	cmp    $0x20,%al
  801265:	74 f4                	je     80125b <strtol+0x16>
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 09                	cmp    $0x9,%al
  80126e:	74 eb                	je     80125b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 2b                	cmp    $0x2b,%al
  801277:	75 05                	jne    80127e <strtol+0x39>
		s++;
  801279:	ff 45 08             	incl   0x8(%ebp)
  80127c:	eb 13                	jmp    801291 <strtol+0x4c>
	else if (*s == '-')
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 2d                	cmp    $0x2d,%al
  801285:	75 0a                	jne    801291 <strtol+0x4c>
		s++, neg = 1;
  801287:	ff 45 08             	incl   0x8(%ebp)
  80128a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801291:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801295:	74 06                	je     80129d <strtol+0x58>
  801297:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129b:	75 20                	jne    8012bd <strtol+0x78>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 30                	cmp    $0x30,%al
  8012a4:	75 17                	jne    8012bd <strtol+0x78>
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	40                   	inc    %eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	3c 78                	cmp    $0x78,%al
  8012ae:	75 0d                	jne    8012bd <strtol+0x78>
		s += 2, base = 16;
  8012b0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012bb:	eb 28                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c1:	75 15                	jne    8012d8 <strtol+0x93>
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	3c 30                	cmp    $0x30,%al
  8012ca:	75 0c                	jne    8012d8 <strtol+0x93>
		s++, base = 8;
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d6:	eb 0d                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0)
  8012d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012dc:	75 07                	jne    8012e5 <strtol+0xa0>
		base = 10;
  8012de:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	3c 2f                	cmp    $0x2f,%al
  8012ec:	7e 19                	jle    801307 <strtol+0xc2>
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	3c 39                	cmp    $0x39,%al
  8012f5:	7f 10                	jg     801307 <strtol+0xc2>
			dig = *s - '0';
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	0f be c0             	movsbl %al,%eax
  8012ff:	83 e8 30             	sub    $0x30,%eax
  801302:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801305:	eb 42                	jmp    801349 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	3c 60                	cmp    $0x60,%al
  80130e:	7e 19                	jle    801329 <strtol+0xe4>
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	3c 7a                	cmp    $0x7a,%al
  801317:	7f 10                	jg     801329 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	0f be c0             	movsbl %al,%eax
  801321:	83 e8 57             	sub    $0x57,%eax
  801324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801327:	eb 20                	jmp    801349 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	3c 40                	cmp    $0x40,%al
  801330:	7e 39                	jle    80136b <strtol+0x126>
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	3c 5a                	cmp    $0x5a,%al
  801339:	7f 30                	jg     80136b <strtol+0x126>
			dig = *s - 'A' + 10;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	0f be c0             	movsbl %al,%eax
  801343:	83 e8 37             	sub    $0x37,%eax
  801346:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80134f:	7d 19                	jge    80136a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801351:	ff 45 08             	incl   0x8(%ebp)
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135b:	89 c2                	mov    %eax,%edx
  80135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801360:	01 d0                	add    %edx,%eax
  801362:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801365:	e9 7b ff ff ff       	jmp    8012e5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80136f:	74 08                	je     801379 <strtol+0x134>
		*endptr = (char *) s;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	8b 55 08             	mov    0x8(%ebp),%edx
  801377:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801379:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137d:	74 07                	je     801386 <strtol+0x141>
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	f7 d8                	neg    %eax
  801384:	eb 03                	jmp    801389 <strtol+0x144>
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <ltostr>:

void
ltostr(long value, char *str)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801398:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80139f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a3:	79 13                	jns    8013b8 <ltostr+0x2d>
	{
		neg = 1;
  8013a5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013af:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c0:	99                   	cltd   
  8013c1:	f7 f9                	idiv   %ecx
  8013c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c9:	8d 50 01             	lea    0x1(%eax),%edx
  8013cc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013cf:	89 c2                	mov    %eax,%edx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 d0                	add    %edx,%eax
  8013d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d9:	83 c2 30             	add    $0x30,%edx
  8013dc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e6:	f7 e9                	imul   %ecx
  8013e8:	c1 fa 02             	sar    $0x2,%edx
  8013eb:	89 c8                	mov    %ecx,%eax
  8013ed:	c1 f8 1f             	sar    $0x1f,%eax
  8013f0:	29 c2                	sub    %eax,%edx
  8013f2:	89 d0                	mov    %edx,%eax
  8013f4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013ff:	f7 e9                	imul   %ecx
  801401:	c1 fa 02             	sar    $0x2,%edx
  801404:	89 c8                	mov    %ecx,%eax
  801406:	c1 f8 1f             	sar    $0x1f,%eax
  801409:	29 c2                	sub    %eax,%edx
  80140b:	89 d0                	mov    %edx,%eax
  80140d:	c1 e0 02             	shl    $0x2,%eax
  801410:	01 d0                	add    %edx,%eax
  801412:	01 c0                	add    %eax,%eax
  801414:	29 c1                	sub    %eax,%ecx
  801416:	89 ca                	mov    %ecx,%edx
  801418:	85 d2                	test   %edx,%edx
  80141a:	75 9c                	jne    8013b8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80141c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801423:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801426:	48                   	dec    %eax
  801427:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80142a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80142e:	74 3d                	je     80146d <ltostr+0xe2>
		start = 1 ;
  801430:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801437:	eb 34                	jmp    80146d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	01 d0                	add    %edx,%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	01 c2                	add    %eax,%edx
  80144e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 c8                	add    %ecx,%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80145a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 c2                	add    %eax,%edx
  801462:	8a 45 eb             	mov    -0x15(%ebp),%al
  801465:	88 02                	mov    %al,(%edx)
		start++ ;
  801467:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80146a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801473:	7c c4                	jl     801439 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801475:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801489:	ff 75 08             	pushl  0x8(%ebp)
  80148c:	e8 54 fa ff ff       	call   800ee5 <strlen>
  801491:	83 c4 04             	add    $0x4,%esp
  801494:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	e8 46 fa ff ff       	call   800ee5 <strlen>
  80149f:	83 c4 04             	add    $0x4,%esp
  8014a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b3:	eb 17                	jmp    8014cc <strcconcat+0x49>
		final[s] = str1[s] ;
  8014b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bb:	01 c2                	add    %eax,%edx
  8014bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	01 c8                	add    %ecx,%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014c9:	ff 45 fc             	incl   -0x4(%ebp)
  8014cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014d2:	7c e1                	jl     8014b5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014e2:	eb 1f                	jmp    801503 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014ed:	89 c2                	mov    %eax,%edx
  8014ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f2:	01 c2                	add    %eax,%edx
  8014f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fa:	01 c8                	add    %ecx,%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801500:	ff 45 f8             	incl   -0x8(%ebp)
  801503:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801506:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801509:	7c d9                	jl     8014e4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80150b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150e:	8b 45 10             	mov    0x10(%ebp),%eax
  801511:	01 d0                	add    %edx,%eax
  801513:	c6 00 00             	movb   $0x0,(%eax)
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80151c:	8b 45 14             	mov    0x14(%ebp),%eax
  80151f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801525:	8b 45 14             	mov    0x14(%ebp),%eax
  801528:	8b 00                	mov    (%eax),%eax
  80152a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801531:	8b 45 10             	mov    0x10(%ebp),%eax
  801534:	01 d0                	add    %edx,%eax
  801536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153c:	eb 0c                	jmp    80154a <strsplit+0x31>
			*string++ = 0;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8d 50 01             	lea    0x1(%eax),%edx
  801544:	89 55 08             	mov    %edx,0x8(%ebp)
  801547:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8a 00                	mov    (%eax),%al
  80154f:	84 c0                	test   %al,%al
  801551:	74 18                	je     80156b <strsplit+0x52>
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	8a 00                	mov    (%eax),%al
  801558:	0f be c0             	movsbl %al,%eax
  80155b:	50                   	push   %eax
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	e8 13 fb ff ff       	call   801077 <strchr>
  801564:	83 c4 08             	add    $0x8,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	75 d3                	jne    80153e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 5a                	je     8015ce <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801574:	8b 45 14             	mov    0x14(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	83 f8 0f             	cmp    $0xf,%eax
  80157c:	75 07                	jne    801585 <strsplit+0x6c>
		{
			return 0;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
  801583:	eb 66                	jmp    8015eb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801585:	8b 45 14             	mov    0x14(%ebp),%eax
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	8d 48 01             	lea    0x1(%eax),%ecx
  80158d:	8b 55 14             	mov    0x14(%ebp),%edx
  801590:	89 0a                	mov    %ecx,(%edx)
  801592:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801599:	8b 45 10             	mov    0x10(%ebp),%eax
  80159c:	01 c2                	add    %eax,%edx
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a3:	eb 03                	jmp    8015a8 <strsplit+0x8f>
			string++;
  8015a5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	8a 00                	mov    (%eax),%al
  8015ad:	84 c0                	test   %al,%al
  8015af:	74 8b                	je     80153c <strsplit+0x23>
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	8a 00                	mov    (%eax),%al
  8015b6:	0f be c0             	movsbl %al,%eax
  8015b9:	50                   	push   %eax
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	e8 b5 fa ff ff       	call   801077 <strchr>
  8015c2:	83 c4 08             	add    $0x8,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	74 dc                	je     8015a5 <strsplit+0x8c>
			string++;
	}
  8015c9:	e9 6e ff ff ff       	jmp    80153c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015ce:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d2:	8b 00                	mov    (%eax),%eax
  8015d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015db:	8b 45 10             	mov    0x10(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8015f3:	a1 04 50 80 00       	mov    0x805004,%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 1f                	je     80161b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8015fc:	e8 1d 00 00 00       	call   80161e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	68 d0 3f 80 00       	push   $0x803fd0
  801609:	e8 55 f2 ff ff       	call   800863 <cprintf>
  80160e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801611:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801618:	00 00 00 
	}
}
  80161b:	90                   	nop
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801624:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80162b:	00 00 00 
  80162e:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801635:	00 00 00 
  801638:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80163f:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801642:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801649:	00 00 00 
  80164c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801653:	00 00 00 
  801656:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80165d:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801660:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801667:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80166a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801674:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801679:	2d 00 10 00 00       	sub    $0x1000,%eax
  80167e:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801683:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80168a:	a1 20 51 80 00       	mov    0x805120,%eax
  80168f:	c1 e0 04             	shl    $0x4,%eax
  801692:	89 c2                	mov    %eax,%edx
  801694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801697:	01 d0                	add    %edx,%eax
  801699:	48                   	dec    %eax
  80169a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80169d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a5:	f7 75 f0             	divl   -0x10(%ebp)
  8016a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ab:	29 d0                	sub    %edx,%eax
  8016ad:	89 c2                	mov    %eax,%edx
  8016af:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8016b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016be:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016c3:	83 ec 04             	sub    $0x4,%esp
  8016c6:	6a 06                	push   $0x6
  8016c8:	52                   	push   %edx
  8016c9:	50                   	push   %eax
  8016ca:	e8 71 05 00 00       	call   801c40 <sys_allocate_chunk>
  8016cf:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8016d2:	a1 20 51 80 00       	mov    0x805120,%eax
  8016d7:	83 ec 0c             	sub    $0xc,%esp
  8016da:	50                   	push   %eax
  8016db:	e8 e6 0b 00 00       	call   8022c6 <initialize_MemBlocksList>
  8016e0:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8016e3:	a1 48 51 80 00       	mov    0x805148,%eax
  8016e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8016eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016ef:	75 14                	jne    801705 <initialize_dyn_block_system+0xe7>
  8016f1:	83 ec 04             	sub    $0x4,%esp
  8016f4:	68 f5 3f 80 00       	push   $0x803ff5
  8016f9:	6a 2b                	push   $0x2b
  8016fb:	68 13 40 80 00       	push   $0x804013
  801700:	e8 aa ee ff ff       	call   8005af <_panic>
  801705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801708:	8b 00                	mov    (%eax),%eax
  80170a:	85 c0                	test   %eax,%eax
  80170c:	74 10                	je     80171e <initialize_dyn_block_system+0x100>
  80170e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801711:	8b 00                	mov    (%eax),%eax
  801713:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801716:	8b 52 04             	mov    0x4(%edx),%edx
  801719:	89 50 04             	mov    %edx,0x4(%eax)
  80171c:	eb 0b                	jmp    801729 <initialize_dyn_block_system+0x10b>
  80171e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801721:	8b 40 04             	mov    0x4(%eax),%eax
  801724:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80172c:	8b 40 04             	mov    0x4(%eax),%eax
  80172f:	85 c0                	test   %eax,%eax
  801731:	74 0f                	je     801742 <initialize_dyn_block_system+0x124>
  801733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801736:	8b 40 04             	mov    0x4(%eax),%eax
  801739:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80173c:	8b 12                	mov    (%edx),%edx
  80173e:	89 10                	mov    %edx,(%eax)
  801740:	eb 0a                	jmp    80174c <initialize_dyn_block_system+0x12e>
  801742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801745:	8b 00                	mov    (%eax),%eax
  801747:	a3 48 51 80 00       	mov    %eax,0x805148
  80174c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80174f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801758:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80175f:	a1 54 51 80 00       	mov    0x805154,%eax
  801764:	48                   	dec    %eax
  801765:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  80176a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80176d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801777:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80177e:	83 ec 0c             	sub    $0xc,%esp
  801781:	ff 75 e4             	pushl  -0x1c(%ebp)
  801784:	e8 d2 13 00 00       	call   802b5b <insert_sorted_with_merge_freeList>
  801789:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80178c:	90                   	nop
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801795:	e8 53 fe ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  80179a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80179e:	75 07                	jne    8017a7 <malloc+0x18>
  8017a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a5:	eb 61                	jmp    801808 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8017a7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8017ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	01 d0                	add    %edx,%eax
  8017b6:	48                   	dec    %eax
  8017b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c2:	f7 75 f4             	divl   -0xc(%ebp)
  8017c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c8:	29 d0                	sub    %edx,%eax
  8017ca:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017cd:	e8 3c 08 00 00       	call   80200e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	74 2d                	je     801803 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	ff 75 08             	pushl  0x8(%ebp)
  8017dc:	e8 3e 0f 00 00       	call   80271f <alloc_block_FF>
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8017e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017eb:	74 16                	je     801803 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8017f3:	e8 48 0c 00 00       	call   802440 <insert_sorted_allocList>
  8017f8:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8017fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fe:	8b 40 08             	mov    0x8(%eax),%eax
  801801:	eb 05                	jmp    801808 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801803:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801819:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80181e:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	83 ec 08             	sub    $0x8,%esp
  801827:	50                   	push   %eax
  801828:	68 40 50 80 00       	push   $0x805040
  80182d:	e8 71 0b 00 00       	call   8023a3 <find_block>
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183b:	8b 50 0c             	mov    0xc(%eax),%edx
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	83 ec 08             	sub    $0x8,%esp
  801844:	52                   	push   %edx
  801845:	50                   	push   %eax
  801846:	e8 bd 03 00 00       	call   801c08 <sys_free_user_mem>
  80184b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80184e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801852:	75 14                	jne    801868 <free+0x5e>
  801854:	83 ec 04             	sub    $0x4,%esp
  801857:	68 f5 3f 80 00       	push   $0x803ff5
  80185c:	6a 71                	push   $0x71
  80185e:	68 13 40 80 00       	push   $0x804013
  801863:	e8 47 ed ff ff       	call   8005af <_panic>
  801868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186b:	8b 00                	mov    (%eax),%eax
  80186d:	85 c0                	test   %eax,%eax
  80186f:	74 10                	je     801881 <free+0x77>
  801871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801874:	8b 00                	mov    (%eax),%eax
  801876:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801879:	8b 52 04             	mov    0x4(%edx),%edx
  80187c:	89 50 04             	mov    %edx,0x4(%eax)
  80187f:	eb 0b                	jmp    80188c <free+0x82>
  801881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801884:	8b 40 04             	mov    0x4(%eax),%eax
  801887:	a3 44 50 80 00       	mov    %eax,0x805044
  80188c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188f:	8b 40 04             	mov    0x4(%eax),%eax
  801892:	85 c0                	test   %eax,%eax
  801894:	74 0f                	je     8018a5 <free+0x9b>
  801896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801899:	8b 40 04             	mov    0x4(%eax),%eax
  80189c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80189f:	8b 12                	mov    (%edx),%edx
  8018a1:	89 10                	mov    %edx,(%eax)
  8018a3:	eb 0a                	jmp    8018af <free+0xa5>
  8018a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a8:	8b 00                	mov    (%eax),%eax
  8018aa:	a3 40 50 80 00       	mov    %eax,0x805040
  8018af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018c2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8018c7:	48                   	dec    %eax
  8018c8:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8018d3:	e8 83 12 00 00       	call   802b5b <insert_sorted_with_merge_freeList>
  8018d8:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8018db:	90                   	nop
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 28             	sub    $0x28,%esp
  8018e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e7:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018ea:	e8 fe fc ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  8018ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018f3:	75 0a                	jne    8018ff <smalloc+0x21>
  8018f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fa:	e9 86 00 00 00       	jmp    801985 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8018ff:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801906:	8b 55 0c             	mov    0xc(%ebp),%edx
  801909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190c:	01 d0                	add    %edx,%eax
  80190e:	48                   	dec    %eax
  80190f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801915:	ba 00 00 00 00       	mov    $0x0,%edx
  80191a:	f7 75 f4             	divl   -0xc(%ebp)
  80191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801920:	29 d0                	sub    %edx,%eax
  801922:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801925:	e8 e4 06 00 00       	call   80200e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80192a:	85 c0                	test   %eax,%eax
  80192c:	74 52                	je     801980 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	e8 e6 0d 00 00       	call   80271f <alloc_block_FF>
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  80193f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801943:	75 07                	jne    80194c <smalloc+0x6e>
			return NULL ;
  801945:	b8 00 00 00 00       	mov    $0x0,%eax
  80194a:	eb 39                	jmp    801985 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80194c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194f:	8b 40 08             	mov    0x8(%eax),%eax
  801952:	89 c2                	mov    %eax,%edx
  801954:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801958:	52                   	push   %edx
  801959:	50                   	push   %eax
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	ff 75 08             	pushl  0x8(%ebp)
  801960:	e8 2e 04 00 00       	call   801d93 <sys_createSharedObject>
  801965:	83 c4 10             	add    $0x10,%esp
  801968:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80196b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80196f:	79 07                	jns    801978 <smalloc+0x9a>
			return (void*)NULL ;
  801971:	b8 00 00 00 00       	mov    $0x0,%eax
  801976:	eb 0d                	jmp    801985 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80197b:	8b 40 08             	mov    0x8(%eax),%eax
  80197e:	eb 05                	jmp    801985 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801980:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80198d:	e8 5b fc ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801992:	83 ec 08             	sub    $0x8,%esp
  801995:	ff 75 0c             	pushl  0xc(%ebp)
  801998:	ff 75 08             	pushl  0x8(%ebp)
  80199b:	e8 1d 04 00 00       	call   801dbd <sys_getSizeOfSharedObject>
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8019a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019aa:	75 0a                	jne    8019b6 <sget+0x2f>
			return NULL ;
  8019ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b1:	e9 83 00 00 00       	jmp    801a39 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8019b6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	01 d0                	add    %edx,%eax
  8019c5:	48                   	dec    %eax
  8019c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d1:	f7 75 f0             	divl   -0x10(%ebp)
  8019d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d7:	29 d0                	sub    %edx,%eax
  8019d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8019dc:	e8 2d 06 00 00       	call   80200e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019e1:	85 c0                	test   %eax,%eax
  8019e3:	74 4f                	je     801a34 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8019e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e8:	83 ec 0c             	sub    $0xc,%esp
  8019eb:	50                   	push   %eax
  8019ec:	e8 2e 0d 00 00       	call   80271f <alloc_block_FF>
  8019f1:	83 c4 10             	add    $0x10,%esp
  8019f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8019f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019fb:	75 07                	jne    801a04 <sget+0x7d>
					return (void*)NULL ;
  8019fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801a02:	eb 35                	jmp    801a39 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a07:	8b 40 08             	mov    0x8(%eax),%eax
  801a0a:	83 ec 04             	sub    $0x4,%esp
  801a0d:	50                   	push   %eax
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	e8 c1 03 00 00       	call   801dda <sys_getSharedObject>
  801a19:	83 c4 10             	add    $0x10,%esp
  801a1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801a1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a23:	79 07                	jns    801a2c <sget+0xa5>
				return (void*)NULL ;
  801a25:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2a:	eb 0d                	jmp    801a39 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a2f:	8b 40 08             	mov    0x8(%eax),%eax
  801a32:	eb 05                	jmp    801a39 <sget+0xb2>


		}
	return (void*)NULL ;
  801a34:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a41:	e8 a7 fb ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	68 20 40 80 00       	push   $0x804020
  801a4e:	68 f9 00 00 00       	push   $0xf9
  801a53:	68 13 40 80 00       	push   $0x804013
  801a58:	e8 52 eb ff ff       	call   8005af <_panic>

00801a5d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	68 48 40 80 00       	push   $0x804048
  801a6b:	68 0d 01 00 00       	push   $0x10d
  801a70:	68 13 40 80 00       	push   $0x804013
  801a75:	e8 35 eb ff ff       	call   8005af <_panic>

00801a7a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a80:	83 ec 04             	sub    $0x4,%esp
  801a83:	68 6c 40 80 00       	push   $0x80406c
  801a88:	68 18 01 00 00       	push   $0x118
  801a8d:	68 13 40 80 00       	push   $0x804013
  801a92:	e8 18 eb ff ff       	call   8005af <_panic>

00801a97 <shrink>:

}
void shrink(uint32 newSize)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	68 6c 40 80 00       	push   $0x80406c
  801aa5:	68 1d 01 00 00       	push   $0x11d
  801aaa:	68 13 40 80 00       	push   $0x804013
  801aaf:	e8 fb ea ff ff       	call   8005af <_panic>

00801ab4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aba:	83 ec 04             	sub    $0x4,%esp
  801abd:	68 6c 40 80 00       	push   $0x80406c
  801ac2:	68 22 01 00 00       	push   $0x122
  801ac7:	68 13 40 80 00       	push   $0x804013
  801acc:	e8 de ea ff ff       	call   8005af <_panic>

00801ad1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	57                   	push   %edi
  801ad5:	56                   	push   %esi
  801ad6:	53                   	push   %ebx
  801ad7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae6:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ae9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801aec:	cd 30                	int    $0x30
  801aee:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801af4:	83 c4 10             	add    $0x10,%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5e                   	pop    %esi
  801af9:	5f                   	pop    %edi
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    

00801afc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 04             	sub    $0x4,%esp
  801b02:	8b 45 10             	mov    0x10(%ebp),%eax
  801b05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b08:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	52                   	push   %edx
  801b14:	ff 75 0c             	pushl  0xc(%ebp)
  801b17:	50                   	push   %eax
  801b18:	6a 00                	push   $0x0
  801b1a:	e8 b2 ff ff ff       	call   801ad1 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	90                   	nop
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 01                	push   $0x1
  801b34:	e8 98 ff ff ff       	call   801ad1 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	52                   	push   %edx
  801b4e:	50                   	push   %eax
  801b4f:	6a 05                	push   $0x5
  801b51:	e8 7b ff ff ff       	call   801ad1 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b60:	8b 75 18             	mov    0x18(%ebp),%esi
  801b63:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	56                   	push   %esi
  801b70:	53                   	push   %ebx
  801b71:	51                   	push   %ecx
  801b72:	52                   	push   %edx
  801b73:	50                   	push   %eax
  801b74:	6a 06                	push   $0x6
  801b76:	e8 56 ff ff ff       	call   801ad1 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b81:	5b                   	pop    %ebx
  801b82:	5e                   	pop    %esi
  801b83:	5d                   	pop    %ebp
  801b84:	c3                   	ret    

00801b85 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	52                   	push   %edx
  801b95:	50                   	push   %eax
  801b96:	6a 07                	push   $0x7
  801b98:	e8 34 ff ff ff       	call   801ad1 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	ff 75 0c             	pushl  0xc(%ebp)
  801bae:	ff 75 08             	pushl  0x8(%ebp)
  801bb1:	6a 08                	push   $0x8
  801bb3:	e8 19 ff ff ff       	call   801ad1 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 09                	push   $0x9
  801bcc:	e8 00 ff ff ff       	call   801ad1 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 0a                	push   $0xa
  801be5:	e8 e7 fe ff ff       	call   801ad1 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 0b                	push   $0xb
  801bfe:	e8 ce fe ff ff       	call   801ad1 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	ff 75 0c             	pushl  0xc(%ebp)
  801c14:	ff 75 08             	pushl  0x8(%ebp)
  801c17:	6a 0f                	push   $0xf
  801c19:	e8 b3 fe ff ff       	call   801ad1 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
	return;
  801c21:	90                   	nop
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	ff 75 0c             	pushl  0xc(%ebp)
  801c30:	ff 75 08             	pushl  0x8(%ebp)
  801c33:	6a 10                	push   $0x10
  801c35:	e8 97 fe ff ff       	call   801ad1 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3d:	90                   	nop
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	ff 75 10             	pushl  0x10(%ebp)
  801c4a:	ff 75 0c             	pushl  0xc(%ebp)
  801c4d:	ff 75 08             	pushl  0x8(%ebp)
  801c50:	6a 11                	push   $0x11
  801c52:	e8 7a fe ff ff       	call   801ad1 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5a:	90                   	nop
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 0c                	push   $0xc
  801c6c:	e8 60 fe ff ff       	call   801ad1 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	ff 75 08             	pushl  0x8(%ebp)
  801c84:	6a 0d                	push   $0xd
  801c86:	e8 46 fe ff ff       	call   801ad1 <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 0e                	push   $0xe
  801c9f:	e8 2d fe ff ff       	call   801ad1 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	90                   	nop
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 13                	push   $0x13
  801cb9:	e8 13 fe ff ff       	call   801ad1 <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
}
  801cc1:	90                   	nop
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 14                	push   $0x14
  801cd3:	e8 f9 fd ff ff       	call   801ad1 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	90                   	nop
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_cputc>:


void
sys_cputc(const char c)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 04             	sub    $0x4,%esp
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	50                   	push   %eax
  801cf7:	6a 15                	push   $0x15
  801cf9:	e8 d3 fd ff ff       	call   801ad1 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	90                   	nop
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 16                	push   $0x16
  801d13:	e8 b9 fd ff ff       	call   801ad1 <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
}
  801d1b:	90                   	nop
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	ff 75 0c             	pushl  0xc(%ebp)
  801d2d:	50                   	push   %eax
  801d2e:	6a 17                	push   $0x17
  801d30:	e8 9c fd ff ff       	call   801ad1 <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	52                   	push   %edx
  801d4a:	50                   	push   %eax
  801d4b:	6a 1a                	push   $0x1a
  801d4d:	e8 7f fd ff ff       	call   801ad1 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	52                   	push   %edx
  801d67:	50                   	push   %eax
  801d68:	6a 18                	push   $0x18
  801d6a:	e8 62 fd ff ff       	call   801ad1 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	90                   	nop
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	52                   	push   %edx
  801d85:	50                   	push   %eax
  801d86:	6a 19                	push   $0x19
  801d88:	e8 44 fd ff ff       	call   801ad1 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
}
  801d90:	90                   	nop
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 04             	sub    $0x4,%esp
  801d99:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d9f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801da2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	6a 00                	push   $0x0
  801dab:	51                   	push   %ecx
  801dac:	52                   	push   %edx
  801dad:	ff 75 0c             	pushl  0xc(%ebp)
  801db0:	50                   	push   %eax
  801db1:	6a 1b                	push   $0x1b
  801db3:	e8 19 fd ff ff       	call   801ad1 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	52                   	push   %edx
  801dcd:	50                   	push   %eax
  801dce:	6a 1c                	push   $0x1c
  801dd0:	e8 fc fc ff ff       	call   801ad1 <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ddd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de3:	8b 45 08             	mov    0x8(%ebp),%eax
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	51                   	push   %ecx
  801deb:	52                   	push   %edx
  801dec:	50                   	push   %eax
  801ded:	6a 1d                	push   $0x1d
  801def:	e8 dd fc ff ff       	call   801ad1 <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801dfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	52                   	push   %edx
  801e09:	50                   	push   %eax
  801e0a:	6a 1e                	push   $0x1e
  801e0c:	e8 c0 fc ff ff       	call   801ad1 <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 1f                	push   $0x1f
  801e25:	e8 a7 fc ff ff       	call   801ad1 <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	6a 00                	push   $0x0
  801e37:	ff 75 14             	pushl  0x14(%ebp)
  801e3a:	ff 75 10             	pushl  0x10(%ebp)
  801e3d:	ff 75 0c             	pushl  0xc(%ebp)
  801e40:	50                   	push   %eax
  801e41:	6a 20                	push   $0x20
  801e43:	e8 89 fc ff ff       	call   801ad1 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	50                   	push   %eax
  801e5c:	6a 21                	push   $0x21
  801e5e:	e8 6e fc ff ff       	call   801ad1 <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
}
  801e66:	90                   	nop
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	50                   	push   %eax
  801e78:	6a 22                	push   $0x22
  801e7a:	e8 52 fc ff ff       	call   801ad1 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 02                	push   $0x2
  801e93:	e8 39 fc ff ff       	call   801ad1 <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 03                	push   $0x3
  801eac:	e8 20 fc ff ff       	call   801ad1 <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 04                	push   $0x4
  801ec5:	e8 07 fc ff ff       	call   801ad1 <syscall>
  801eca:	83 c4 18             	add    $0x18,%esp
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_exit_env>:


void sys_exit_env(void)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 23                	push   $0x23
  801ede:	e8 ee fb ff ff       	call   801ad1 <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	90                   	nop
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801eef:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ef2:	8d 50 04             	lea    0x4(%eax),%edx
  801ef5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	52                   	push   %edx
  801eff:	50                   	push   %eax
  801f00:	6a 24                	push   $0x24
  801f02:	e8 ca fb ff ff       	call   801ad1 <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
	return result;
  801f0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f10:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f13:	89 01                	mov    %eax,(%ecx)
  801f15:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	c9                   	leave  
  801f1c:	c2 04 00             	ret    $0x4

00801f1f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	ff 75 10             	pushl  0x10(%ebp)
  801f29:	ff 75 0c             	pushl  0xc(%ebp)
  801f2c:	ff 75 08             	pushl  0x8(%ebp)
  801f2f:	6a 12                	push   $0x12
  801f31:	e8 9b fb ff ff       	call   801ad1 <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
	return ;
  801f39:	90                   	nop
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_rcr2>:
uint32 sys_rcr2()
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 25                	push   $0x25
  801f4b:	e8 81 fb ff ff       	call   801ad1 <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 04             	sub    $0x4,%esp
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f61:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	50                   	push   %eax
  801f6e:	6a 26                	push   $0x26
  801f70:	e8 5c fb ff ff       	call   801ad1 <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
	return ;
  801f78:	90                   	nop
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <rsttst>:
void rsttst()
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 28                	push   $0x28
  801f8a:	e8 42 fb ff ff       	call   801ad1 <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f92:	90                   	nop
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 04             	sub    $0x4,%esp
  801f9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801f9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fa1:	8b 55 18             	mov    0x18(%ebp),%edx
  801fa4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fa8:	52                   	push   %edx
  801fa9:	50                   	push   %eax
  801faa:	ff 75 10             	pushl  0x10(%ebp)
  801fad:	ff 75 0c             	pushl  0xc(%ebp)
  801fb0:	ff 75 08             	pushl  0x8(%ebp)
  801fb3:	6a 27                	push   $0x27
  801fb5:	e8 17 fb ff ff       	call   801ad1 <syscall>
  801fba:	83 c4 18             	add    $0x18,%esp
	return ;
  801fbd:	90                   	nop
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <chktst>:
void chktst(uint32 n)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	ff 75 08             	pushl  0x8(%ebp)
  801fce:	6a 29                	push   $0x29
  801fd0:	e8 fc fa ff ff       	call   801ad1 <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd8:	90                   	nop
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <inctst>:

void inctst()
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 2a                	push   $0x2a
  801fea:	e8 e2 fa ff ff       	call   801ad1 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff2:	90                   	nop
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <gettst>:
uint32 gettst()
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 2b                	push   $0x2b
  802004:	e8 c8 fa ff ff       	call   801ad1 <syscall>
  802009:	83 c4 18             	add    $0x18,%esp
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 2c                	push   $0x2c
  802020:	e8 ac fa ff ff       	call   801ad1 <syscall>
  802025:	83 c4 18             	add    $0x18,%esp
  802028:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80202b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80202f:	75 07                	jne    802038 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802031:	b8 01 00 00 00       	mov    $0x1,%eax
  802036:	eb 05                	jmp    80203d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802038:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 2c                	push   $0x2c
  802051:	e8 7b fa ff ff       	call   801ad1 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
  802059:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80205c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802060:	75 07                	jne    802069 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802062:	b8 01 00 00 00       	mov    $0x1,%eax
  802067:	eb 05                	jmp    80206e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802069:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 2c                	push   $0x2c
  802082:	e8 4a fa ff ff       	call   801ad1 <syscall>
  802087:	83 c4 18             	add    $0x18,%esp
  80208a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80208d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802091:	75 07                	jne    80209a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802093:	b8 01 00 00 00       	mov    $0x1,%eax
  802098:	eb 05                	jmp    80209f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80209a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 2c                	push   $0x2c
  8020b3:	e8 19 fa ff ff       	call   801ad1 <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
  8020bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020be:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020c2:	75 07                	jne    8020cb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c9:	eb 05                	jmp    8020d0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	ff 75 08             	pushl  0x8(%ebp)
  8020e0:	6a 2d                	push   $0x2d
  8020e2:	e8 ea f9 ff ff       	call   801ad1 <syscall>
  8020e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ea:	90                   	nop
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	6a 00                	push   $0x0
  8020ff:	53                   	push   %ebx
  802100:	51                   	push   %ecx
  802101:	52                   	push   %edx
  802102:	50                   	push   %eax
  802103:	6a 2e                	push   $0x2e
  802105:	e8 c7 f9 ff ff       	call   801ad1 <syscall>
  80210a:	83 c4 18             	add    $0x18,%esp
}
  80210d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802115:	8b 55 0c             	mov    0xc(%ebp),%edx
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	52                   	push   %edx
  802122:	50                   	push   %eax
  802123:	6a 2f                	push   $0x2f
  802125:	e8 a7 f9 ff ff       	call   801ad1 <syscall>
  80212a:	83 c4 18             	add    $0x18,%esp
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802135:	83 ec 0c             	sub    $0xc,%esp
  802138:	68 7c 40 80 00       	push   $0x80407c
  80213d:	e8 21 e7 ff ff       	call   800863 <cprintf>
  802142:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802145:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80214c:	83 ec 0c             	sub    $0xc,%esp
  80214f:	68 a8 40 80 00       	push   $0x8040a8
  802154:	e8 0a e7 ff ff       	call   800863 <cprintf>
  802159:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80215c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802160:	a1 38 51 80 00       	mov    0x805138,%eax
  802165:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802168:	eb 56                	jmp    8021c0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80216a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80216e:	74 1c                	je     80218c <print_mem_block_lists+0x5d>
  802170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802173:	8b 50 08             	mov    0x8(%eax),%edx
  802176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802179:	8b 48 08             	mov    0x8(%eax),%ecx
  80217c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217f:	8b 40 0c             	mov    0xc(%eax),%eax
  802182:	01 c8                	add    %ecx,%eax
  802184:	39 c2                	cmp    %eax,%edx
  802186:	73 04                	jae    80218c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802188:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 50 08             	mov    0x8(%eax),%edx
  802192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802195:	8b 40 0c             	mov    0xc(%eax),%eax
  802198:	01 c2                	add    %eax,%edx
  80219a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219d:	8b 40 08             	mov    0x8(%eax),%eax
  8021a0:	83 ec 04             	sub    $0x4,%esp
  8021a3:	52                   	push   %edx
  8021a4:	50                   	push   %eax
  8021a5:	68 bd 40 80 00       	push   $0x8040bd
  8021aa:	e8 b4 e6 ff ff       	call   800863 <cprintf>
  8021af:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021b8:	a1 40 51 80 00       	mov    0x805140,%eax
  8021bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c4:	74 07                	je     8021cd <print_mem_block_lists+0x9e>
  8021c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c9:	8b 00                	mov    (%eax),%eax
  8021cb:	eb 05                	jmp    8021d2 <print_mem_block_lists+0xa3>
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d2:	a3 40 51 80 00       	mov    %eax,0x805140
  8021d7:	a1 40 51 80 00       	mov    0x805140,%eax
  8021dc:	85 c0                	test   %eax,%eax
  8021de:	75 8a                	jne    80216a <print_mem_block_lists+0x3b>
  8021e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e4:	75 84                	jne    80216a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021e6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021ea:	75 10                	jne    8021fc <print_mem_block_lists+0xcd>
  8021ec:	83 ec 0c             	sub    $0xc,%esp
  8021ef:	68 cc 40 80 00       	push   $0x8040cc
  8021f4:	e8 6a e6 ff ff       	call   800863 <cprintf>
  8021f9:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802203:	83 ec 0c             	sub    $0xc,%esp
  802206:	68 f0 40 80 00       	push   $0x8040f0
  80220b:	e8 53 e6 ff ff       	call   800863 <cprintf>
  802210:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802213:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802217:	a1 40 50 80 00       	mov    0x805040,%eax
  80221c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221f:	eb 56                	jmp    802277 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802221:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802225:	74 1c                	je     802243 <print_mem_block_lists+0x114>
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	8b 50 08             	mov    0x8(%eax),%edx
  80222d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802230:	8b 48 08             	mov    0x8(%eax),%ecx
  802233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802236:	8b 40 0c             	mov    0xc(%eax),%eax
  802239:	01 c8                	add    %ecx,%eax
  80223b:	39 c2                	cmp    %eax,%edx
  80223d:	73 04                	jae    802243 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80223f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	8b 50 08             	mov    0x8(%eax),%edx
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	8b 40 0c             	mov    0xc(%eax),%eax
  80224f:	01 c2                	add    %eax,%edx
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	8b 40 08             	mov    0x8(%eax),%eax
  802257:	83 ec 04             	sub    $0x4,%esp
  80225a:	52                   	push   %edx
  80225b:	50                   	push   %eax
  80225c:	68 bd 40 80 00       	push   $0x8040bd
  802261:	e8 fd e5 ff ff       	call   800863 <cprintf>
  802266:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80226f:	a1 48 50 80 00       	mov    0x805048,%eax
  802274:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802277:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227b:	74 07                	je     802284 <print_mem_block_lists+0x155>
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 00                	mov    (%eax),%eax
  802282:	eb 05                	jmp    802289 <print_mem_block_lists+0x15a>
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
  802289:	a3 48 50 80 00       	mov    %eax,0x805048
  80228e:	a1 48 50 80 00       	mov    0x805048,%eax
  802293:	85 c0                	test   %eax,%eax
  802295:	75 8a                	jne    802221 <print_mem_block_lists+0xf2>
  802297:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80229b:	75 84                	jne    802221 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80229d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022a1:	75 10                	jne    8022b3 <print_mem_block_lists+0x184>
  8022a3:	83 ec 0c             	sub    $0xc,%esp
  8022a6:	68 08 41 80 00       	push   $0x804108
  8022ab:	e8 b3 e5 ff ff       	call   800863 <cprintf>
  8022b0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022b3:	83 ec 0c             	sub    $0xc,%esp
  8022b6:	68 7c 40 80 00       	push   $0x80407c
  8022bb:	e8 a3 e5 ff ff       	call   800863 <cprintf>
  8022c0:	83 c4 10             	add    $0x10,%esp

}
  8022c3:	90                   	nop
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8022cc:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022d3:	00 00 00 
  8022d6:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8022dd:	00 00 00 
  8022e0:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022e7:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8022ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022f1:	e9 9e 00 00 00       	jmp    802394 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8022f6:	a1 50 50 80 00       	mov    0x805050,%eax
  8022fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fe:	c1 e2 04             	shl    $0x4,%edx
  802301:	01 d0                	add    %edx,%eax
  802303:	85 c0                	test   %eax,%eax
  802305:	75 14                	jne    80231b <initialize_MemBlocksList+0x55>
  802307:	83 ec 04             	sub    $0x4,%esp
  80230a:	68 30 41 80 00       	push   $0x804130
  80230f:	6a 43                	push   $0x43
  802311:	68 53 41 80 00       	push   $0x804153
  802316:	e8 94 e2 ff ff       	call   8005af <_panic>
  80231b:	a1 50 50 80 00       	mov    0x805050,%eax
  802320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802323:	c1 e2 04             	shl    $0x4,%edx
  802326:	01 d0                	add    %edx,%eax
  802328:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80232e:	89 10                	mov    %edx,(%eax)
  802330:	8b 00                	mov    (%eax),%eax
  802332:	85 c0                	test   %eax,%eax
  802334:	74 18                	je     80234e <initialize_MemBlocksList+0x88>
  802336:	a1 48 51 80 00       	mov    0x805148,%eax
  80233b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802341:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802344:	c1 e1 04             	shl    $0x4,%ecx
  802347:	01 ca                	add    %ecx,%edx
  802349:	89 50 04             	mov    %edx,0x4(%eax)
  80234c:	eb 12                	jmp    802360 <initialize_MemBlocksList+0x9a>
  80234e:	a1 50 50 80 00       	mov    0x805050,%eax
  802353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802356:	c1 e2 04             	shl    $0x4,%edx
  802359:	01 d0                	add    %edx,%eax
  80235b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802360:	a1 50 50 80 00       	mov    0x805050,%eax
  802365:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802368:	c1 e2 04             	shl    $0x4,%edx
  80236b:	01 d0                	add    %edx,%eax
  80236d:	a3 48 51 80 00       	mov    %eax,0x805148
  802372:	a1 50 50 80 00       	mov    0x805050,%eax
  802377:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237a:	c1 e2 04             	shl    $0x4,%edx
  80237d:	01 d0                	add    %edx,%eax
  80237f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802386:	a1 54 51 80 00       	mov    0x805154,%eax
  80238b:	40                   	inc    %eax
  80238c:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802391:	ff 45 f4             	incl   -0xc(%ebp)
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	3b 45 08             	cmp    0x8(%ebp),%eax
  80239a:	0f 82 56 ff ff ff    	jb     8022f6 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8023a0:	90                   	nop
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8023a9:	a1 38 51 80 00       	mov    0x805138,%eax
  8023ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023b1:	eb 18                	jmp    8023cb <find_block+0x28>
	{
		if (ele->sva==va)
  8023b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b6:	8b 40 08             	mov    0x8(%eax),%eax
  8023b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023bc:	75 05                	jne    8023c3 <find_block+0x20>
			return ele;
  8023be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023c1:	eb 7b                	jmp    80243e <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8023c3:	a1 40 51 80 00       	mov    0x805140,%eax
  8023c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023cf:	74 07                	je     8023d8 <find_block+0x35>
  8023d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	eb 05                	jmp    8023dd <find_block+0x3a>
  8023d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dd:	a3 40 51 80 00       	mov    %eax,0x805140
  8023e2:	a1 40 51 80 00       	mov    0x805140,%eax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	75 c8                	jne    8023b3 <find_block+0x10>
  8023eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023ef:	75 c2                	jne    8023b3 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8023f1:	a1 40 50 80 00       	mov    0x805040,%eax
  8023f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023f9:	eb 18                	jmp    802413 <find_block+0x70>
	{
		if (ele->sva==va)
  8023fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023fe:	8b 40 08             	mov    0x8(%eax),%eax
  802401:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802404:	75 05                	jne    80240b <find_block+0x68>
					return ele;
  802406:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802409:	eb 33                	jmp    80243e <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80240b:	a1 48 50 80 00       	mov    0x805048,%eax
  802410:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802413:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802417:	74 07                	je     802420 <find_block+0x7d>
  802419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80241c:	8b 00                	mov    (%eax),%eax
  80241e:	eb 05                	jmp    802425 <find_block+0x82>
  802420:	b8 00 00 00 00       	mov    $0x0,%eax
  802425:	a3 48 50 80 00       	mov    %eax,0x805048
  80242a:	a1 48 50 80 00       	mov    0x805048,%eax
  80242f:	85 c0                	test   %eax,%eax
  802431:	75 c8                	jne    8023fb <find_block+0x58>
  802433:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802437:	75 c2                	jne    8023fb <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802439:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802446:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80244b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80244e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802452:	75 62                	jne    8024b6 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802454:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802458:	75 14                	jne    80246e <insert_sorted_allocList+0x2e>
  80245a:	83 ec 04             	sub    $0x4,%esp
  80245d:	68 30 41 80 00       	push   $0x804130
  802462:	6a 69                	push   $0x69
  802464:	68 53 41 80 00       	push   $0x804153
  802469:	e8 41 e1 ff ff       	call   8005af <_panic>
  80246e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	89 10                	mov    %edx,(%eax)
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	8b 00                	mov    (%eax),%eax
  80247e:	85 c0                	test   %eax,%eax
  802480:	74 0d                	je     80248f <insert_sorted_allocList+0x4f>
  802482:	a1 40 50 80 00       	mov    0x805040,%eax
  802487:	8b 55 08             	mov    0x8(%ebp),%edx
  80248a:	89 50 04             	mov    %edx,0x4(%eax)
  80248d:	eb 08                	jmp    802497 <insert_sorted_allocList+0x57>
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	a3 44 50 80 00       	mov    %eax,0x805044
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	a3 40 50 80 00       	mov    %eax,0x805040
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024ae:	40                   	inc    %eax
  8024af:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8024b4:	eb 72                	jmp    802528 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8024b6:	a1 40 50 80 00       	mov    0x805040,%eax
  8024bb:	8b 50 08             	mov    0x8(%eax),%edx
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	8b 40 08             	mov    0x8(%eax),%eax
  8024c4:	39 c2                	cmp    %eax,%edx
  8024c6:	76 60                	jbe    802528 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8024c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024cc:	75 14                	jne    8024e2 <insert_sorted_allocList+0xa2>
  8024ce:	83 ec 04             	sub    $0x4,%esp
  8024d1:	68 30 41 80 00       	push   $0x804130
  8024d6:	6a 6d                	push   $0x6d
  8024d8:	68 53 41 80 00       	push   $0x804153
  8024dd:	e8 cd e0 ff ff       	call   8005af <_panic>
  8024e2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	89 10                	mov    %edx,(%eax)
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	74 0d                	je     802503 <insert_sorted_allocList+0xc3>
  8024f6:	a1 40 50 80 00       	mov    0x805040,%eax
  8024fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fe:	89 50 04             	mov    %edx,0x4(%eax)
  802501:	eb 08                	jmp    80250b <insert_sorted_allocList+0xcb>
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	a3 44 50 80 00       	mov    %eax,0x805044
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	a3 40 50 80 00       	mov    %eax,0x805040
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80251d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802522:	40                   	inc    %eax
  802523:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802528:	a1 40 50 80 00       	mov    0x805040,%eax
  80252d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802530:	e9 b9 01 00 00       	jmp    8026ee <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802535:	8b 45 08             	mov    0x8(%ebp),%eax
  802538:	8b 50 08             	mov    0x8(%eax),%edx
  80253b:	a1 40 50 80 00       	mov    0x805040,%eax
  802540:	8b 40 08             	mov    0x8(%eax),%eax
  802543:	39 c2                	cmp    %eax,%edx
  802545:	76 7c                	jbe    8025c3 <insert_sorted_allocList+0x183>
  802547:	8b 45 08             	mov    0x8(%ebp),%eax
  80254a:	8b 50 08             	mov    0x8(%eax),%edx
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 40 08             	mov    0x8(%eax),%eax
  802553:	39 c2                	cmp    %eax,%edx
  802555:	73 6c                	jae    8025c3 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	74 06                	je     802563 <insert_sorted_allocList+0x123>
  80255d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802561:	75 14                	jne    802577 <insert_sorted_allocList+0x137>
  802563:	83 ec 04             	sub    $0x4,%esp
  802566:	68 6c 41 80 00       	push   $0x80416c
  80256b:	6a 75                	push   $0x75
  80256d:	68 53 41 80 00       	push   $0x804153
  802572:	e8 38 e0 ff ff       	call   8005af <_panic>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 50 04             	mov    0x4(%eax),%edx
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	89 50 04             	mov    %edx,0x4(%eax)
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802589:	89 10                	mov    %edx,(%eax)
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 40 04             	mov    0x4(%eax),%eax
  802591:	85 c0                	test   %eax,%eax
  802593:	74 0d                	je     8025a2 <insert_sorted_allocList+0x162>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 40 04             	mov    0x4(%eax),%eax
  80259b:	8b 55 08             	mov    0x8(%ebp),%edx
  80259e:	89 10                	mov    %edx,(%eax)
  8025a0:	eb 08                	jmp    8025aa <insert_sorted_allocList+0x16a>
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	a3 40 50 80 00       	mov    %eax,0x805040
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b0:	89 50 04             	mov    %edx,0x4(%eax)
  8025b3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025b8:	40                   	inc    %eax
  8025b9:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  8025be:	e9 59 01 00 00       	jmp    80271c <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8025c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c6:	8b 50 08             	mov    0x8(%eax),%edx
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 40 08             	mov    0x8(%eax),%eax
  8025cf:	39 c2                	cmp    %eax,%edx
  8025d1:	0f 86 98 00 00 00    	jbe    80266f <insert_sorted_allocList+0x22f>
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	8b 50 08             	mov    0x8(%eax),%edx
  8025dd:	a1 44 50 80 00       	mov    0x805044,%eax
  8025e2:	8b 40 08             	mov    0x8(%eax),%eax
  8025e5:	39 c2                	cmp    %eax,%edx
  8025e7:	0f 83 82 00 00 00    	jae    80266f <insert_sorted_allocList+0x22f>
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	8b 50 08             	mov    0x8(%eax),%edx
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	8b 40 08             	mov    0x8(%eax),%eax
  8025fb:	39 c2                	cmp    %eax,%edx
  8025fd:	73 70                	jae    80266f <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8025ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802603:	74 06                	je     80260b <insert_sorted_allocList+0x1cb>
  802605:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802609:	75 14                	jne    80261f <insert_sorted_allocList+0x1df>
  80260b:	83 ec 04             	sub    $0x4,%esp
  80260e:	68 a4 41 80 00       	push   $0x8041a4
  802613:	6a 7c                	push   $0x7c
  802615:	68 53 41 80 00       	push   $0x804153
  80261a:	e8 90 df ff ff       	call   8005af <_panic>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 10                	mov    (%eax),%edx
  802624:	8b 45 08             	mov    0x8(%ebp),%eax
  802627:	89 10                	mov    %edx,(%eax)
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	74 0b                	je     80263d <insert_sorted_allocList+0x1fd>
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 00                	mov    (%eax),%eax
  802637:	8b 55 08             	mov    0x8(%ebp),%edx
  80263a:	89 50 04             	mov    %edx,0x4(%eax)
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 55 08             	mov    0x8(%ebp),%edx
  802643:	89 10                	mov    %edx,(%eax)
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264b:	89 50 04             	mov    %edx,0x4(%eax)
  80264e:	8b 45 08             	mov    0x8(%ebp),%eax
  802651:	8b 00                	mov    (%eax),%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	75 08                	jne    80265f <insert_sorted_allocList+0x21f>
  802657:	8b 45 08             	mov    0x8(%ebp),%eax
  80265a:	a3 44 50 80 00       	mov    %eax,0x805044
  80265f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802664:	40                   	inc    %eax
  802665:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  80266a:	e9 ad 00 00 00       	jmp    80271c <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	8b 50 08             	mov    0x8(%eax),%edx
  802675:	a1 44 50 80 00       	mov    0x805044,%eax
  80267a:	8b 40 08             	mov    0x8(%eax),%eax
  80267d:	39 c2                	cmp    %eax,%edx
  80267f:	76 65                	jbe    8026e6 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802681:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802685:	75 17                	jne    80269e <insert_sorted_allocList+0x25e>
  802687:	83 ec 04             	sub    $0x4,%esp
  80268a:	68 d8 41 80 00       	push   $0x8041d8
  80268f:	68 80 00 00 00       	push   $0x80
  802694:	68 53 41 80 00       	push   $0x804153
  802699:	e8 11 df ff ff       	call   8005af <_panic>
  80269e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	89 50 04             	mov    %edx,0x4(%eax)
  8026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ad:	8b 40 04             	mov    0x4(%eax),%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	74 0c                	je     8026c0 <insert_sorted_allocList+0x280>
  8026b4:	a1 44 50 80 00       	mov    0x805044,%eax
  8026b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bc:	89 10                	mov    %edx,(%eax)
  8026be:	eb 08                	jmp    8026c8 <insert_sorted_allocList+0x288>
  8026c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c3:	a3 40 50 80 00       	mov    %eax,0x805040
  8026c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cb:	a3 44 50 80 00       	mov    %eax,0x805044
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026de:	40                   	inc    %eax
  8026df:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  8026e4:	eb 36                	jmp    80271c <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8026e6:	a1 48 50 80 00       	mov    0x805048,%eax
  8026eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f2:	74 07                	je     8026fb <insert_sorted_allocList+0x2bb>
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 00                	mov    (%eax),%eax
  8026f9:	eb 05                	jmp    802700 <insert_sorted_allocList+0x2c0>
  8026fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802700:	a3 48 50 80 00       	mov    %eax,0x805048
  802705:	a1 48 50 80 00       	mov    0x805048,%eax
  80270a:	85 c0                	test   %eax,%eax
  80270c:	0f 85 23 fe ff ff    	jne    802535 <insert_sorted_allocList+0xf5>
  802712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802716:	0f 85 19 fe ff ff    	jne    802535 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  80271c:	90                   	nop
  80271d:	c9                   	leave  
  80271e:	c3                   	ret    

0080271f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80271f:	55                   	push   %ebp
  802720:	89 e5                	mov    %esp,%ebp
  802722:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802725:	a1 38 51 80 00       	mov    0x805138,%eax
  80272a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272d:	e9 7c 01 00 00       	jmp    8028ae <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 40 0c             	mov    0xc(%eax),%eax
  802738:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273b:	0f 85 90 00 00 00    	jne    8027d1 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274b:	75 17                	jne    802764 <alloc_block_FF+0x45>
  80274d:	83 ec 04             	sub    $0x4,%esp
  802750:	68 fb 41 80 00       	push   $0x8041fb
  802755:	68 ba 00 00 00       	push   $0xba
  80275a:	68 53 41 80 00       	push   $0x804153
  80275f:	e8 4b de ff ff       	call   8005af <_panic>
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 00                	mov    (%eax),%eax
  802769:	85 c0                	test   %eax,%eax
  80276b:	74 10                	je     80277d <alloc_block_FF+0x5e>
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 00                	mov    (%eax),%eax
  802772:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802775:	8b 52 04             	mov    0x4(%edx),%edx
  802778:	89 50 04             	mov    %edx,0x4(%eax)
  80277b:	eb 0b                	jmp    802788 <alloc_block_FF+0x69>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 40 04             	mov    0x4(%eax),%eax
  802783:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 40 04             	mov    0x4(%eax),%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	74 0f                	je     8027a1 <alloc_block_FF+0x82>
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 40 04             	mov    0x4(%eax),%eax
  802798:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279b:	8b 12                	mov    (%edx),%edx
  80279d:	89 10                	mov    %edx,(%eax)
  80279f:	eb 0a                	jmp    8027ab <alloc_block_FF+0x8c>
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027be:	a1 44 51 80 00       	mov    0x805144,%eax
  8027c3:	48                   	dec    %eax
  8027c4:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  8027c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cc:	e9 10 01 00 00       	jmp    8028e1 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027da:	0f 86 c6 00 00 00    	jbe    8028a6 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8027e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8027e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8027e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ec:	75 17                	jne    802805 <alloc_block_FF+0xe6>
  8027ee:	83 ec 04             	sub    $0x4,%esp
  8027f1:	68 fb 41 80 00       	push   $0x8041fb
  8027f6:	68 c2 00 00 00       	push   $0xc2
  8027fb:	68 53 41 80 00       	push   $0x804153
  802800:	e8 aa dd ff ff       	call   8005af <_panic>
  802805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	85 c0                	test   %eax,%eax
  80280c:	74 10                	je     80281e <alloc_block_FF+0xff>
  80280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802816:	8b 52 04             	mov    0x4(%edx),%edx
  802819:	89 50 04             	mov    %edx,0x4(%eax)
  80281c:	eb 0b                	jmp    802829 <alloc_block_FF+0x10a>
  80281e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802821:	8b 40 04             	mov    0x4(%eax),%eax
  802824:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282c:	8b 40 04             	mov    0x4(%eax),%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	74 0f                	je     802842 <alloc_block_FF+0x123>
  802833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80283c:	8b 12                	mov    (%edx),%edx
  80283e:	89 10                	mov    %edx,(%eax)
  802840:	eb 0a                	jmp    80284c <alloc_block_FF+0x12d>
  802842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	a3 48 51 80 00       	mov    %eax,0x805148
  80284c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802858:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285f:	a1 54 51 80 00       	mov    0x805154,%eax
  802864:	48                   	dec    %eax
  802865:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 50 08             	mov    0x8(%eax),%edx
  802870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802873:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	8b 55 08             	mov    0x8(%ebp),%edx
  80287c:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 0c             	mov    0xc(%eax),%eax
  802885:	2b 45 08             	sub    0x8(%ebp),%eax
  802888:	89 c2                	mov    %eax,%edx
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 50 08             	mov    0x8(%eax),%edx
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	01 c2                	add    %eax,%edx
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8028a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a4:	eb 3b                	jmp    8028e1 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8028a6:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b2:	74 07                	je     8028bb <alloc_block_FF+0x19c>
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	eb 05                	jmp    8028c0 <alloc_block_FF+0x1a1>
  8028bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c0:	a3 40 51 80 00       	mov    %eax,0x805140
  8028c5:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	0f 85 60 fe ff ff    	jne    802732 <alloc_block_FF+0x13>
  8028d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d6:	0f 85 56 fe ff ff    	jne    802732 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8028dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8028e9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8028f0:	a1 38 51 80 00       	mov    0x805138,%eax
  8028f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f8:	eb 3a                	jmp    802934 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802900:	3b 45 08             	cmp    0x8(%ebp),%eax
  802903:	72 27                	jb     80292c <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802905:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802909:	75 0b                	jne    802916 <alloc_block_BF+0x33>
					best_size= element->size;
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 40 0c             	mov    0xc(%eax),%eax
  802911:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802914:	eb 16                	jmp    80292c <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 50 0c             	mov    0xc(%eax),%edx
  80291c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291f:	39 c2                	cmp    %eax,%edx
  802921:	77 09                	ja     80292c <alloc_block_BF+0x49>
					best_size=element->size;
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 40 0c             	mov    0xc(%eax),%eax
  802929:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80292c:	a1 40 51 80 00       	mov    0x805140,%eax
  802931:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802934:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802938:	74 07                	je     802941 <alloc_block_BF+0x5e>
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 00                	mov    (%eax),%eax
  80293f:	eb 05                	jmp    802946 <alloc_block_BF+0x63>
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
  802946:	a3 40 51 80 00       	mov    %eax,0x805140
  80294b:	a1 40 51 80 00       	mov    0x805140,%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	75 a6                	jne    8028fa <alloc_block_BF+0x17>
  802954:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802958:	75 a0                	jne    8028fa <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80295a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80295e:	0f 84 d3 01 00 00    	je     802b37 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802964:	a1 38 51 80 00       	mov    0x805138,%eax
  802969:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296c:	e9 98 01 00 00       	jmp    802b09 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802974:	3b 45 08             	cmp    0x8(%ebp),%eax
  802977:	0f 86 da 00 00 00    	jbe    802a57 <alloc_block_BF+0x174>
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 50 0c             	mov    0xc(%eax),%edx
  802983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802986:	39 c2                	cmp    %eax,%edx
  802988:	0f 85 c9 00 00 00    	jne    802a57 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  80298e:	a1 48 51 80 00       	mov    0x805148,%eax
  802993:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802996:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80299a:	75 17                	jne    8029b3 <alloc_block_BF+0xd0>
  80299c:	83 ec 04             	sub    $0x4,%esp
  80299f:	68 fb 41 80 00       	push   $0x8041fb
  8029a4:	68 ea 00 00 00       	push   $0xea
  8029a9:	68 53 41 80 00       	push   $0x804153
  8029ae:	e8 fc db ff ff       	call   8005af <_panic>
  8029b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	74 10                	je     8029cc <alloc_block_BF+0xe9>
  8029bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029c4:	8b 52 04             	mov    0x4(%edx),%edx
  8029c7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ca:	eb 0b                	jmp    8029d7 <alloc_block_BF+0xf4>
  8029cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cf:	8b 40 04             	mov    0x4(%eax),%eax
  8029d2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029da:	8b 40 04             	mov    0x4(%eax),%eax
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	74 0f                	je     8029f0 <alloc_block_BF+0x10d>
  8029e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e4:	8b 40 04             	mov    0x4(%eax),%eax
  8029e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029ea:	8b 12                	mov    (%edx),%edx
  8029ec:	89 10                	mov    %edx,(%eax)
  8029ee:	eb 0a                	jmp    8029fa <alloc_block_BF+0x117>
  8029f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f3:	8b 00                	mov    (%eax),%eax
  8029f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8029fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0d:	a1 54 51 80 00       	mov    0x805154,%eax
  802a12:	48                   	dec    %eax
  802a13:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 50 08             	mov    0x8(%eax),%edx
  802a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a21:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a27:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2a:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	8b 40 0c             	mov    0xc(%eax),%eax
  802a33:	2b 45 08             	sub    0x8(%ebp),%eax
  802a36:	89 c2                	mov    %eax,%edx
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 50 08             	mov    0x8(%eax),%edx
  802a44:	8b 45 08             	mov    0x8(%ebp),%eax
  802a47:	01 c2                	add    %eax,%edx
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a52:	e9 e5 00 00 00       	jmp    802b3c <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 50 0c             	mov    0xc(%eax),%edx
  802a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a60:	39 c2                	cmp    %eax,%edx
  802a62:	0f 85 99 00 00 00    	jne    802b01 <alloc_block_BF+0x21e>
  802a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6e:	0f 85 8d 00 00 00    	jne    802b01 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7e:	75 17                	jne    802a97 <alloc_block_BF+0x1b4>
  802a80:	83 ec 04             	sub    $0x4,%esp
  802a83:	68 fb 41 80 00       	push   $0x8041fb
  802a88:	68 f7 00 00 00       	push   $0xf7
  802a8d:	68 53 41 80 00       	push   $0x804153
  802a92:	e8 18 db ff ff       	call   8005af <_panic>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	85 c0                	test   %eax,%eax
  802a9e:	74 10                	je     802ab0 <alloc_block_BF+0x1cd>
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa8:	8b 52 04             	mov    0x4(%edx),%edx
  802aab:	89 50 04             	mov    %edx,0x4(%eax)
  802aae:	eb 0b                	jmp    802abb <alloc_block_BF+0x1d8>
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 40 04             	mov    0x4(%eax),%eax
  802ab6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 40 04             	mov    0x4(%eax),%eax
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	74 0f                	je     802ad4 <alloc_block_BF+0x1f1>
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 40 04             	mov    0x4(%eax),%eax
  802acb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ace:	8b 12                	mov    (%edx),%edx
  802ad0:	89 10                	mov    %edx,(%eax)
  802ad2:	eb 0a                	jmp    802ade <alloc_block_BF+0x1fb>
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 00                	mov    (%eax),%eax
  802ad9:	a3 38 51 80 00       	mov    %eax,0x805138
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af1:	a1 44 51 80 00       	mov    0x805144,%eax
  802af6:	48                   	dec    %eax
  802af7:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aff:	eb 3b                	jmp    802b3c <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802b01:	a1 40 51 80 00       	mov    0x805140,%eax
  802b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0d:	74 07                	je     802b16 <alloc_block_BF+0x233>
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 00                	mov    (%eax),%eax
  802b14:	eb 05                	jmp    802b1b <alloc_block_BF+0x238>
  802b16:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1b:	a3 40 51 80 00       	mov    %eax,0x805140
  802b20:	a1 40 51 80 00       	mov    0x805140,%eax
  802b25:	85 c0                	test   %eax,%eax
  802b27:	0f 85 44 fe ff ff    	jne    802971 <alloc_block_BF+0x8e>
  802b2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b31:	0f 85 3a fe ff ff    	jne    802971 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802b37:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3c:	c9                   	leave  
  802b3d:	c3                   	ret    

00802b3e <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b3e:	55                   	push   %ebp
  802b3f:	89 e5                	mov    %esp,%ebp
  802b41:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802b44:	83 ec 04             	sub    $0x4,%esp
  802b47:	68 1c 42 80 00       	push   $0x80421c
  802b4c:	68 04 01 00 00       	push   $0x104
  802b51:	68 53 41 80 00       	push   $0x804153
  802b56:	e8 54 da ff ff       	call   8005af <_panic>

00802b5b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802b5b:	55                   	push   %ebp
  802b5c:	89 e5                	mov    %esp,%ebp
  802b5e:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802b61:	a1 38 51 80 00       	mov    0x805138,%eax
  802b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802b69:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b6e:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802b71:	a1 38 51 80 00       	mov    0x805138,%eax
  802b76:	85 c0                	test   %eax,%eax
  802b78:	75 68                	jne    802be2 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802b7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7e:	75 17                	jne    802b97 <insert_sorted_with_merge_freeList+0x3c>
  802b80:	83 ec 04             	sub    $0x4,%esp
  802b83:	68 30 41 80 00       	push   $0x804130
  802b88:	68 14 01 00 00       	push   $0x114
  802b8d:	68 53 41 80 00       	push   $0x804153
  802b92:	e8 18 da ff ff       	call   8005af <_panic>
  802b97:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	89 10                	mov    %edx,(%eax)
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	85 c0                	test   %eax,%eax
  802ba9:	74 0d                	je     802bb8 <insert_sorted_with_merge_freeList+0x5d>
  802bab:	a1 38 51 80 00       	mov    0x805138,%eax
  802bb0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb3:	89 50 04             	mov    %edx,0x4(%eax)
  802bb6:	eb 08                	jmp    802bc0 <insert_sorted_with_merge_freeList+0x65>
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	a3 38 51 80 00       	mov    %eax,0x805138
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd2:	a1 44 51 80 00       	mov    0x805144,%eax
  802bd7:	40                   	inc    %eax
  802bd8:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802bdd:	e9 d2 06 00 00       	jmp    8032b4 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	8b 50 08             	mov    0x8(%eax),%edx
  802be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802beb:	8b 40 08             	mov    0x8(%eax),%eax
  802bee:	39 c2                	cmp    %eax,%edx
  802bf0:	0f 83 22 01 00 00    	jae    802d18 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	8b 50 08             	mov    0x8(%eax),%edx
  802bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bff:	8b 40 0c             	mov    0xc(%eax),%eax
  802c02:	01 c2                	add    %eax,%edx
  802c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c07:	8b 40 08             	mov    0x8(%eax),%eax
  802c0a:	39 c2                	cmp    %eax,%edx
  802c0c:	0f 85 9e 00 00 00    	jne    802cb0 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	8b 50 08             	mov    0x8(%eax),%edx
  802c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1b:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c21:	8b 50 0c             	mov    0xc(%eax),%edx
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2a:	01 c2                	add    %eax,%edx
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	8b 50 08             	mov    0x8(%eax),%edx
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4c:	75 17                	jne    802c65 <insert_sorted_with_merge_freeList+0x10a>
  802c4e:	83 ec 04             	sub    $0x4,%esp
  802c51:	68 30 41 80 00       	push   $0x804130
  802c56:	68 21 01 00 00       	push   $0x121
  802c5b:	68 53 41 80 00       	push   $0x804153
  802c60:	e8 4a d9 ff ff       	call   8005af <_panic>
  802c65:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	89 10                	mov    %edx,(%eax)
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	8b 00                	mov    (%eax),%eax
  802c75:	85 c0                	test   %eax,%eax
  802c77:	74 0d                	je     802c86 <insert_sorted_with_merge_freeList+0x12b>
  802c79:	a1 48 51 80 00       	mov    0x805148,%eax
  802c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c81:	89 50 04             	mov    %edx,0x4(%eax)
  802c84:	eb 08                	jmp    802c8e <insert_sorted_with_merge_freeList+0x133>
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	a3 48 51 80 00       	mov    %eax,0x805148
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ca5:	40                   	inc    %eax
  802ca6:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802cab:	e9 04 06 00 00       	jmp    8032b4 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802cb0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb4:	75 17                	jne    802ccd <insert_sorted_with_merge_freeList+0x172>
  802cb6:	83 ec 04             	sub    $0x4,%esp
  802cb9:	68 30 41 80 00       	push   $0x804130
  802cbe:	68 26 01 00 00       	push   $0x126
  802cc3:	68 53 41 80 00       	push   $0x804153
  802cc8:	e8 e2 d8 ff ff       	call   8005af <_panic>
  802ccd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	89 10                	mov    %edx,(%eax)
  802cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	74 0d                	je     802cee <insert_sorted_with_merge_freeList+0x193>
  802ce1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce9:	89 50 04             	mov    %edx,0x4(%eax)
  802cec:	eb 08                	jmp    802cf6 <insert_sorted_with_merge_freeList+0x19b>
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	a3 38 51 80 00       	mov    %eax,0x805138
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d08:	a1 44 51 80 00       	mov    0x805144,%eax
  802d0d:	40                   	inc    %eax
  802d0e:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802d13:	e9 9c 05 00 00       	jmp    8032b4 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	8b 50 08             	mov    0x8(%eax),%edx
  802d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d21:	8b 40 08             	mov    0x8(%eax),%eax
  802d24:	39 c2                	cmp    %eax,%edx
  802d26:	0f 86 16 01 00 00    	jbe    802e42 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802d2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2f:	8b 50 08             	mov    0x8(%eax),%edx
  802d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d35:	8b 40 0c             	mov    0xc(%eax),%eax
  802d38:	01 c2                	add    %eax,%edx
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	8b 40 08             	mov    0x8(%eax),%eax
  802d40:	39 c2                	cmp    %eax,%edx
  802d42:	0f 85 92 00 00 00    	jne    802dda <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d51:	8b 40 0c             	mov    0xc(%eax),%eax
  802d54:	01 c2                	add    %eax,%edx
  802d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d59:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	8b 50 08             	mov    0x8(%eax),%edx
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d76:	75 17                	jne    802d8f <insert_sorted_with_merge_freeList+0x234>
  802d78:	83 ec 04             	sub    $0x4,%esp
  802d7b:	68 30 41 80 00       	push   $0x804130
  802d80:	68 31 01 00 00       	push   $0x131
  802d85:	68 53 41 80 00       	push   $0x804153
  802d8a:	e8 20 d8 ff ff       	call   8005af <_panic>
  802d8f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	89 10                	mov    %edx,(%eax)
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 00                	mov    (%eax),%eax
  802d9f:	85 c0                	test   %eax,%eax
  802da1:	74 0d                	je     802db0 <insert_sorted_with_merge_freeList+0x255>
  802da3:	a1 48 51 80 00       	mov    0x805148,%eax
  802da8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dab:	89 50 04             	mov    %edx,0x4(%eax)
  802dae:	eb 08                	jmp    802db8 <insert_sorted_with_merge_freeList+0x25d>
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	a3 48 51 80 00       	mov    %eax,0x805148
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dca:	a1 54 51 80 00       	mov    0x805154,%eax
  802dcf:	40                   	inc    %eax
  802dd0:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802dd5:	e9 da 04 00 00       	jmp    8032b4 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802dda:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dde:	75 17                	jne    802df7 <insert_sorted_with_merge_freeList+0x29c>
  802de0:	83 ec 04             	sub    $0x4,%esp
  802de3:	68 d8 41 80 00       	push   $0x8041d8
  802de8:	68 37 01 00 00       	push   $0x137
  802ded:	68 53 41 80 00       	push   $0x804153
  802df2:	e8 b8 d7 ff ff       	call   8005af <_panic>
  802df7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	89 50 04             	mov    %edx,0x4(%eax)
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	8b 40 04             	mov    0x4(%eax),%eax
  802e09:	85 c0                	test   %eax,%eax
  802e0b:	74 0c                	je     802e19 <insert_sorted_with_merge_freeList+0x2be>
  802e0d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e12:	8b 55 08             	mov    0x8(%ebp),%edx
  802e15:	89 10                	mov    %edx,(%eax)
  802e17:	eb 08                	jmp    802e21 <insert_sorted_with_merge_freeList+0x2c6>
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	a3 38 51 80 00       	mov    %eax,0x805138
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e32:	a1 44 51 80 00       	mov    0x805144,%eax
  802e37:	40                   	inc    %eax
  802e38:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802e3d:	e9 72 04 00 00       	jmp    8032b4 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802e42:	a1 38 51 80 00       	mov    0x805138,%eax
  802e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4a:	e9 35 04 00 00       	jmp    803284 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 00                	mov    (%eax),%eax
  802e54:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	8b 50 08             	mov    0x8(%eax),%edx
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 40 08             	mov    0x8(%eax),%eax
  802e63:	39 c2                	cmp    %eax,%edx
  802e65:	0f 86 11 04 00 00    	jbe    80327c <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 50 08             	mov    0x8(%eax),%edx
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 40 0c             	mov    0xc(%eax),%eax
  802e77:	01 c2                	add    %eax,%edx
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	8b 40 08             	mov    0x8(%eax),%eax
  802e7f:	39 c2                	cmp    %eax,%edx
  802e81:	0f 83 8b 00 00 00    	jae    802f12 <insert_sorted_with_merge_freeList+0x3b7>
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 50 08             	mov    0x8(%eax),%edx
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	8b 40 0c             	mov    0xc(%eax),%eax
  802e93:	01 c2                	add    %eax,%edx
  802e95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e98:	8b 40 08             	mov    0x8(%eax),%eax
  802e9b:	39 c2                	cmp    %eax,%edx
  802e9d:	73 73                	jae    802f12 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802e9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea3:	74 06                	je     802eab <insert_sorted_with_merge_freeList+0x350>
  802ea5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea9:	75 17                	jne    802ec2 <insert_sorted_with_merge_freeList+0x367>
  802eab:	83 ec 04             	sub    $0x4,%esp
  802eae:	68 a4 41 80 00       	push   $0x8041a4
  802eb3:	68 48 01 00 00       	push   $0x148
  802eb8:	68 53 41 80 00       	push   $0x804153
  802ebd:	e8 ed d6 ff ff       	call   8005af <_panic>
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 10                	mov    (%eax),%edx
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	89 10                	mov    %edx,(%eax)
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	8b 00                	mov    (%eax),%eax
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	74 0b                	je     802ee0 <insert_sorted_with_merge_freeList+0x385>
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 00                	mov    (%eax),%eax
  802eda:	8b 55 08             	mov    0x8(%ebp),%edx
  802edd:	89 50 04             	mov    %edx,0x4(%eax)
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee6:	89 10                	mov    %edx,(%eax)
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eee:	89 50 04             	mov    %edx,0x4(%eax)
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	85 c0                	test   %eax,%eax
  802ef8:	75 08                	jne    802f02 <insert_sorted_with_merge_freeList+0x3a7>
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f02:	a1 44 51 80 00       	mov    0x805144,%eax
  802f07:	40                   	inc    %eax
  802f08:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  802f0d:	e9 a2 03 00 00       	jmp    8032b4 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	8b 50 08             	mov    0x8(%eax),%edx
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1e:	01 c2                	add    %eax,%edx
  802f20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f23:	8b 40 08             	mov    0x8(%eax),%eax
  802f26:	39 c2                	cmp    %eax,%edx
  802f28:	0f 83 ae 00 00 00    	jae    802fdc <insert_sorted_with_merge_freeList+0x481>
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	8b 50 08             	mov    0x8(%eax),%edx
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 48 08             	mov    0x8(%eax),%ecx
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f40:	01 c8                	add    %ecx,%eax
  802f42:	39 c2                	cmp    %eax,%edx
  802f44:	0f 85 92 00 00 00    	jne    802fdc <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 50 0c             	mov    0xc(%eax),%edx
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	8b 40 0c             	mov    0xc(%eax),%eax
  802f56:	01 c2                	add    %eax,%edx
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	8b 50 08             	mov    0x8(%eax),%edx
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f78:	75 17                	jne    802f91 <insert_sorted_with_merge_freeList+0x436>
  802f7a:	83 ec 04             	sub    $0x4,%esp
  802f7d:	68 30 41 80 00       	push   $0x804130
  802f82:	68 51 01 00 00       	push   $0x151
  802f87:	68 53 41 80 00       	push   $0x804153
  802f8c:	e8 1e d6 ff ff       	call   8005af <_panic>
  802f91:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	89 10                	mov    %edx,(%eax)
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	74 0d                	je     802fb2 <insert_sorted_with_merge_freeList+0x457>
  802fa5:	a1 48 51 80 00       	mov    0x805148,%eax
  802faa:	8b 55 08             	mov    0x8(%ebp),%edx
  802fad:	89 50 04             	mov    %edx,0x4(%eax)
  802fb0:	eb 08                	jmp    802fba <insert_sorted_with_merge_freeList+0x45f>
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcc:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd1:	40                   	inc    %eax
  802fd2:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  802fd7:	e9 d8 02 00 00       	jmp    8032b4 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	8b 50 08             	mov    0x8(%eax),%edx
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe8:	01 c2                	add    %eax,%edx
  802fea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fed:	8b 40 08             	mov    0x8(%eax),%eax
  802ff0:	39 c2                	cmp    %eax,%edx
  802ff2:	0f 85 ba 00 00 00    	jne    8030b2 <insert_sorted_with_merge_freeList+0x557>
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	8b 50 08             	mov    0x8(%eax),%edx
  802ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803001:	8b 48 08             	mov    0x8(%eax),%ecx
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	8b 40 0c             	mov    0xc(%eax),%eax
  80300a:	01 c8                	add    %ecx,%eax
  80300c:	39 c2                	cmp    %eax,%edx
  80300e:	0f 86 9e 00 00 00    	jbe    8030b2 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803017:	8b 50 0c             	mov    0xc(%eax),%edx
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	8b 40 0c             	mov    0xc(%eax),%eax
  803020:	01 c2                	add    %eax,%edx
  803022:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803025:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	8b 50 08             	mov    0x8(%eax),%edx
  80302e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803031:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	8b 50 08             	mov    0x8(%eax),%edx
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80304a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304e:	75 17                	jne    803067 <insert_sorted_with_merge_freeList+0x50c>
  803050:	83 ec 04             	sub    $0x4,%esp
  803053:	68 30 41 80 00       	push   $0x804130
  803058:	68 5b 01 00 00       	push   $0x15b
  80305d:	68 53 41 80 00       	push   $0x804153
  803062:	e8 48 d5 ff ff       	call   8005af <_panic>
  803067:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	89 10                	mov    %edx,(%eax)
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	8b 00                	mov    (%eax),%eax
  803077:	85 c0                	test   %eax,%eax
  803079:	74 0d                	je     803088 <insert_sorted_with_merge_freeList+0x52d>
  80307b:	a1 48 51 80 00       	mov    0x805148,%eax
  803080:	8b 55 08             	mov    0x8(%ebp),%edx
  803083:	89 50 04             	mov    %edx,0x4(%eax)
  803086:	eb 08                	jmp    803090 <insert_sorted_with_merge_freeList+0x535>
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	a3 48 51 80 00       	mov    %eax,0x805148
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a2:	a1 54 51 80 00       	mov    0x805154,%eax
  8030a7:	40                   	inc    %eax
  8030a8:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8030ad:	e9 02 02 00 00       	jmp    8032b4 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	8b 50 08             	mov    0x8(%eax),%edx
  8030b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030be:	01 c2                	add    %eax,%edx
  8030c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c3:	8b 40 08             	mov    0x8(%eax),%eax
  8030c6:	39 c2                	cmp    %eax,%edx
  8030c8:	0f 85 ae 01 00 00    	jne    80327c <insert_sorted_with_merge_freeList+0x721>
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	8b 50 08             	mov    0x8(%eax),%edx
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	8b 48 08             	mov    0x8(%eax),%ecx
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e0:	01 c8                	add    %ecx,%eax
  8030e2:	39 c2                	cmp    %eax,%edx
  8030e4:	0f 85 92 01 00 00    	jne    80327c <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f6:	01 c2                	add    %eax,%edx
  8030f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fe:	01 c2                	add    %eax,%edx
  803100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803103:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	8b 50 08             	mov    0x8(%eax),%edx
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  80311c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803126:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803129:	8b 50 08             	mov    0x8(%eax),%edx
  80312c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312f:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803132:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803136:	75 17                	jne    80314f <insert_sorted_with_merge_freeList+0x5f4>
  803138:	83 ec 04             	sub    $0x4,%esp
  80313b:	68 fb 41 80 00       	push   $0x8041fb
  803140:	68 63 01 00 00       	push   $0x163
  803145:	68 53 41 80 00       	push   $0x804153
  80314a:	e8 60 d4 ff ff       	call   8005af <_panic>
  80314f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803152:	8b 00                	mov    (%eax),%eax
  803154:	85 c0                	test   %eax,%eax
  803156:	74 10                	je     803168 <insert_sorted_with_merge_freeList+0x60d>
  803158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803160:	8b 52 04             	mov    0x4(%edx),%edx
  803163:	89 50 04             	mov    %edx,0x4(%eax)
  803166:	eb 0b                	jmp    803173 <insert_sorted_with_merge_freeList+0x618>
  803168:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316b:	8b 40 04             	mov    0x4(%eax),%eax
  80316e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803173:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803176:	8b 40 04             	mov    0x4(%eax),%eax
  803179:	85 c0                	test   %eax,%eax
  80317b:	74 0f                	je     80318c <insert_sorted_with_merge_freeList+0x631>
  80317d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803180:	8b 40 04             	mov    0x4(%eax),%eax
  803183:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803186:	8b 12                	mov    (%edx),%edx
  803188:	89 10                	mov    %edx,(%eax)
  80318a:	eb 0a                	jmp    803196 <insert_sorted_with_merge_freeList+0x63b>
  80318c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318f:	8b 00                	mov    (%eax),%eax
  803191:	a3 38 51 80 00       	mov    %eax,0x805138
  803196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803199:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80319f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ae:	48                   	dec    %eax
  8031af:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8031b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031b8:	75 17                	jne    8031d1 <insert_sorted_with_merge_freeList+0x676>
  8031ba:	83 ec 04             	sub    $0x4,%esp
  8031bd:	68 30 41 80 00       	push   $0x804130
  8031c2:	68 64 01 00 00       	push   $0x164
  8031c7:	68 53 41 80 00       	push   $0x804153
  8031cc:	e8 de d3 ff ff       	call   8005af <_panic>
  8031d1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031da:	89 10                	mov    %edx,(%eax)
  8031dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031df:	8b 00                	mov    (%eax),%eax
  8031e1:	85 c0                	test   %eax,%eax
  8031e3:	74 0d                	je     8031f2 <insert_sorted_with_merge_freeList+0x697>
  8031e5:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ed:	89 50 04             	mov    %edx,0x4(%eax)
  8031f0:	eb 08                	jmp    8031fa <insert_sorted_with_merge_freeList+0x69f>
  8031f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fd:	a3 48 51 80 00       	mov    %eax,0x805148
  803202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803205:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320c:	a1 54 51 80 00       	mov    0x805154,%eax
  803211:	40                   	inc    %eax
  803212:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803217:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80321b:	75 17                	jne    803234 <insert_sorted_with_merge_freeList+0x6d9>
  80321d:	83 ec 04             	sub    $0x4,%esp
  803220:	68 30 41 80 00       	push   $0x804130
  803225:	68 65 01 00 00       	push   $0x165
  80322a:	68 53 41 80 00       	push   $0x804153
  80322f:	e8 7b d3 ff ff       	call   8005af <_panic>
  803234:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80323a:	8b 45 08             	mov    0x8(%ebp),%eax
  80323d:	89 10                	mov    %edx,(%eax)
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	74 0d                	je     803255 <insert_sorted_with_merge_freeList+0x6fa>
  803248:	a1 48 51 80 00       	mov    0x805148,%eax
  80324d:	8b 55 08             	mov    0x8(%ebp),%edx
  803250:	89 50 04             	mov    %edx,0x4(%eax)
  803253:	eb 08                	jmp    80325d <insert_sorted_with_merge_freeList+0x702>
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80325d:	8b 45 08             	mov    0x8(%ebp),%eax
  803260:	a3 48 51 80 00       	mov    %eax,0x805148
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326f:	a1 54 51 80 00       	mov    0x805154,%eax
  803274:	40                   	inc    %eax
  803275:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  80327a:	eb 38                	jmp    8032b4 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80327c:	a1 40 51 80 00       	mov    0x805140,%eax
  803281:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803284:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803288:	74 07                	je     803291 <insert_sorted_with_merge_freeList+0x736>
  80328a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	eb 05                	jmp    803296 <insert_sorted_with_merge_freeList+0x73b>
  803291:	b8 00 00 00 00       	mov    $0x0,%eax
  803296:	a3 40 51 80 00       	mov    %eax,0x805140
  80329b:	a1 40 51 80 00       	mov    0x805140,%eax
  8032a0:	85 c0                	test   %eax,%eax
  8032a2:	0f 85 a7 fb ff ff    	jne    802e4f <insert_sorted_with_merge_freeList+0x2f4>
  8032a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ac:	0f 85 9d fb ff ff    	jne    802e4f <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8032b2:	eb 00                	jmp    8032b4 <insert_sorted_with_merge_freeList+0x759>
  8032b4:	90                   	nop
  8032b5:	c9                   	leave  
  8032b6:	c3                   	ret    

008032b7 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032b7:	55                   	push   %ebp
  8032b8:	89 e5                	mov    %esp,%ebp
  8032ba:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c0:	89 d0                	mov    %edx,%eax
  8032c2:	c1 e0 02             	shl    $0x2,%eax
  8032c5:	01 d0                	add    %edx,%eax
  8032c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032ce:	01 d0                	add    %edx,%eax
  8032d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032d7:	01 d0                	add    %edx,%eax
  8032d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032e0:	01 d0                	add    %edx,%eax
  8032e2:	c1 e0 04             	shl    $0x4,%eax
  8032e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8032e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8032ef:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8032f2:	83 ec 0c             	sub    $0xc,%esp
  8032f5:	50                   	push   %eax
  8032f6:	e8 ee eb ff ff       	call   801ee9 <sys_get_virtual_time>
  8032fb:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8032fe:	eb 41                	jmp    803341 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803300:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803303:	83 ec 0c             	sub    $0xc,%esp
  803306:	50                   	push   %eax
  803307:	e8 dd eb ff ff       	call   801ee9 <sys_get_virtual_time>
  80330c:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80330f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803315:	29 c2                	sub    %eax,%edx
  803317:	89 d0                	mov    %edx,%eax
  803319:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80331c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80331f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803322:	89 d1                	mov    %edx,%ecx
  803324:	29 c1                	sub    %eax,%ecx
  803326:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803329:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80332c:	39 c2                	cmp    %eax,%edx
  80332e:	0f 97 c0             	seta   %al
  803331:	0f b6 c0             	movzbl %al,%eax
  803334:	29 c1                	sub    %eax,%ecx
  803336:	89 c8                	mov    %ecx,%eax
  803338:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80333b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80333e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803344:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803347:	72 b7                	jb     803300 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803349:	90                   	nop
  80334a:	c9                   	leave  
  80334b:	c3                   	ret    

0080334c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80334c:	55                   	push   %ebp
  80334d:	89 e5                	mov    %esp,%ebp
  80334f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803352:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803359:	eb 03                	jmp    80335e <busy_wait+0x12>
  80335b:	ff 45 fc             	incl   -0x4(%ebp)
  80335e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803361:	3b 45 08             	cmp    0x8(%ebp),%eax
  803364:	72 f5                	jb     80335b <busy_wait+0xf>
	return i;
  803366:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803369:	c9                   	leave  
  80336a:	c3                   	ret    
  80336b:	90                   	nop

0080336c <__udivdi3>:
  80336c:	55                   	push   %ebp
  80336d:	57                   	push   %edi
  80336e:	56                   	push   %esi
  80336f:	53                   	push   %ebx
  803370:	83 ec 1c             	sub    $0x1c,%esp
  803373:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803377:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80337b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80337f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803383:	89 ca                	mov    %ecx,%edx
  803385:	89 f8                	mov    %edi,%eax
  803387:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80338b:	85 f6                	test   %esi,%esi
  80338d:	75 2d                	jne    8033bc <__udivdi3+0x50>
  80338f:	39 cf                	cmp    %ecx,%edi
  803391:	77 65                	ja     8033f8 <__udivdi3+0x8c>
  803393:	89 fd                	mov    %edi,%ebp
  803395:	85 ff                	test   %edi,%edi
  803397:	75 0b                	jne    8033a4 <__udivdi3+0x38>
  803399:	b8 01 00 00 00       	mov    $0x1,%eax
  80339e:	31 d2                	xor    %edx,%edx
  8033a0:	f7 f7                	div    %edi
  8033a2:	89 c5                	mov    %eax,%ebp
  8033a4:	31 d2                	xor    %edx,%edx
  8033a6:	89 c8                	mov    %ecx,%eax
  8033a8:	f7 f5                	div    %ebp
  8033aa:	89 c1                	mov    %eax,%ecx
  8033ac:	89 d8                	mov    %ebx,%eax
  8033ae:	f7 f5                	div    %ebp
  8033b0:	89 cf                	mov    %ecx,%edi
  8033b2:	89 fa                	mov    %edi,%edx
  8033b4:	83 c4 1c             	add    $0x1c,%esp
  8033b7:	5b                   	pop    %ebx
  8033b8:	5e                   	pop    %esi
  8033b9:	5f                   	pop    %edi
  8033ba:	5d                   	pop    %ebp
  8033bb:	c3                   	ret    
  8033bc:	39 ce                	cmp    %ecx,%esi
  8033be:	77 28                	ja     8033e8 <__udivdi3+0x7c>
  8033c0:	0f bd fe             	bsr    %esi,%edi
  8033c3:	83 f7 1f             	xor    $0x1f,%edi
  8033c6:	75 40                	jne    803408 <__udivdi3+0x9c>
  8033c8:	39 ce                	cmp    %ecx,%esi
  8033ca:	72 0a                	jb     8033d6 <__udivdi3+0x6a>
  8033cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033d0:	0f 87 9e 00 00 00    	ja     803474 <__udivdi3+0x108>
  8033d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8033db:	89 fa                	mov    %edi,%edx
  8033dd:	83 c4 1c             	add    $0x1c,%esp
  8033e0:	5b                   	pop    %ebx
  8033e1:	5e                   	pop    %esi
  8033e2:	5f                   	pop    %edi
  8033e3:	5d                   	pop    %ebp
  8033e4:	c3                   	ret    
  8033e5:	8d 76 00             	lea    0x0(%esi),%esi
  8033e8:	31 ff                	xor    %edi,%edi
  8033ea:	31 c0                	xor    %eax,%eax
  8033ec:	89 fa                	mov    %edi,%edx
  8033ee:	83 c4 1c             	add    $0x1c,%esp
  8033f1:	5b                   	pop    %ebx
  8033f2:	5e                   	pop    %esi
  8033f3:	5f                   	pop    %edi
  8033f4:	5d                   	pop    %ebp
  8033f5:	c3                   	ret    
  8033f6:	66 90                	xchg   %ax,%ax
  8033f8:	89 d8                	mov    %ebx,%eax
  8033fa:	f7 f7                	div    %edi
  8033fc:	31 ff                	xor    %edi,%edi
  8033fe:	89 fa                	mov    %edi,%edx
  803400:	83 c4 1c             	add    $0x1c,%esp
  803403:	5b                   	pop    %ebx
  803404:	5e                   	pop    %esi
  803405:	5f                   	pop    %edi
  803406:	5d                   	pop    %ebp
  803407:	c3                   	ret    
  803408:	bd 20 00 00 00       	mov    $0x20,%ebp
  80340d:	89 eb                	mov    %ebp,%ebx
  80340f:	29 fb                	sub    %edi,%ebx
  803411:	89 f9                	mov    %edi,%ecx
  803413:	d3 e6                	shl    %cl,%esi
  803415:	89 c5                	mov    %eax,%ebp
  803417:	88 d9                	mov    %bl,%cl
  803419:	d3 ed                	shr    %cl,%ebp
  80341b:	89 e9                	mov    %ebp,%ecx
  80341d:	09 f1                	or     %esi,%ecx
  80341f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803423:	89 f9                	mov    %edi,%ecx
  803425:	d3 e0                	shl    %cl,%eax
  803427:	89 c5                	mov    %eax,%ebp
  803429:	89 d6                	mov    %edx,%esi
  80342b:	88 d9                	mov    %bl,%cl
  80342d:	d3 ee                	shr    %cl,%esi
  80342f:	89 f9                	mov    %edi,%ecx
  803431:	d3 e2                	shl    %cl,%edx
  803433:	8b 44 24 08          	mov    0x8(%esp),%eax
  803437:	88 d9                	mov    %bl,%cl
  803439:	d3 e8                	shr    %cl,%eax
  80343b:	09 c2                	or     %eax,%edx
  80343d:	89 d0                	mov    %edx,%eax
  80343f:	89 f2                	mov    %esi,%edx
  803441:	f7 74 24 0c          	divl   0xc(%esp)
  803445:	89 d6                	mov    %edx,%esi
  803447:	89 c3                	mov    %eax,%ebx
  803449:	f7 e5                	mul    %ebp
  80344b:	39 d6                	cmp    %edx,%esi
  80344d:	72 19                	jb     803468 <__udivdi3+0xfc>
  80344f:	74 0b                	je     80345c <__udivdi3+0xf0>
  803451:	89 d8                	mov    %ebx,%eax
  803453:	31 ff                	xor    %edi,%edi
  803455:	e9 58 ff ff ff       	jmp    8033b2 <__udivdi3+0x46>
  80345a:	66 90                	xchg   %ax,%ax
  80345c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803460:	89 f9                	mov    %edi,%ecx
  803462:	d3 e2                	shl    %cl,%edx
  803464:	39 c2                	cmp    %eax,%edx
  803466:	73 e9                	jae    803451 <__udivdi3+0xe5>
  803468:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80346b:	31 ff                	xor    %edi,%edi
  80346d:	e9 40 ff ff ff       	jmp    8033b2 <__udivdi3+0x46>
  803472:	66 90                	xchg   %ax,%ax
  803474:	31 c0                	xor    %eax,%eax
  803476:	e9 37 ff ff ff       	jmp    8033b2 <__udivdi3+0x46>
  80347b:	90                   	nop

0080347c <__umoddi3>:
  80347c:	55                   	push   %ebp
  80347d:	57                   	push   %edi
  80347e:	56                   	push   %esi
  80347f:	53                   	push   %ebx
  803480:	83 ec 1c             	sub    $0x1c,%esp
  803483:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803487:	8b 74 24 34          	mov    0x34(%esp),%esi
  80348b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80348f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803493:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803497:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80349b:	89 f3                	mov    %esi,%ebx
  80349d:	89 fa                	mov    %edi,%edx
  80349f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034a3:	89 34 24             	mov    %esi,(%esp)
  8034a6:	85 c0                	test   %eax,%eax
  8034a8:	75 1a                	jne    8034c4 <__umoddi3+0x48>
  8034aa:	39 f7                	cmp    %esi,%edi
  8034ac:	0f 86 a2 00 00 00    	jbe    803554 <__umoddi3+0xd8>
  8034b2:	89 c8                	mov    %ecx,%eax
  8034b4:	89 f2                	mov    %esi,%edx
  8034b6:	f7 f7                	div    %edi
  8034b8:	89 d0                	mov    %edx,%eax
  8034ba:	31 d2                	xor    %edx,%edx
  8034bc:	83 c4 1c             	add    $0x1c,%esp
  8034bf:	5b                   	pop    %ebx
  8034c0:	5e                   	pop    %esi
  8034c1:	5f                   	pop    %edi
  8034c2:	5d                   	pop    %ebp
  8034c3:	c3                   	ret    
  8034c4:	39 f0                	cmp    %esi,%eax
  8034c6:	0f 87 ac 00 00 00    	ja     803578 <__umoddi3+0xfc>
  8034cc:	0f bd e8             	bsr    %eax,%ebp
  8034cf:	83 f5 1f             	xor    $0x1f,%ebp
  8034d2:	0f 84 ac 00 00 00    	je     803584 <__umoddi3+0x108>
  8034d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8034dd:	29 ef                	sub    %ebp,%edi
  8034df:	89 fe                	mov    %edi,%esi
  8034e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034e5:	89 e9                	mov    %ebp,%ecx
  8034e7:	d3 e0                	shl    %cl,%eax
  8034e9:	89 d7                	mov    %edx,%edi
  8034eb:	89 f1                	mov    %esi,%ecx
  8034ed:	d3 ef                	shr    %cl,%edi
  8034ef:	09 c7                	or     %eax,%edi
  8034f1:	89 e9                	mov    %ebp,%ecx
  8034f3:	d3 e2                	shl    %cl,%edx
  8034f5:	89 14 24             	mov    %edx,(%esp)
  8034f8:	89 d8                	mov    %ebx,%eax
  8034fa:	d3 e0                	shl    %cl,%eax
  8034fc:	89 c2                	mov    %eax,%edx
  8034fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803502:	d3 e0                	shl    %cl,%eax
  803504:	89 44 24 04          	mov    %eax,0x4(%esp)
  803508:	8b 44 24 08          	mov    0x8(%esp),%eax
  80350c:	89 f1                	mov    %esi,%ecx
  80350e:	d3 e8                	shr    %cl,%eax
  803510:	09 d0                	or     %edx,%eax
  803512:	d3 eb                	shr    %cl,%ebx
  803514:	89 da                	mov    %ebx,%edx
  803516:	f7 f7                	div    %edi
  803518:	89 d3                	mov    %edx,%ebx
  80351a:	f7 24 24             	mull   (%esp)
  80351d:	89 c6                	mov    %eax,%esi
  80351f:	89 d1                	mov    %edx,%ecx
  803521:	39 d3                	cmp    %edx,%ebx
  803523:	0f 82 87 00 00 00    	jb     8035b0 <__umoddi3+0x134>
  803529:	0f 84 91 00 00 00    	je     8035c0 <__umoddi3+0x144>
  80352f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803533:	29 f2                	sub    %esi,%edx
  803535:	19 cb                	sbb    %ecx,%ebx
  803537:	89 d8                	mov    %ebx,%eax
  803539:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80353d:	d3 e0                	shl    %cl,%eax
  80353f:	89 e9                	mov    %ebp,%ecx
  803541:	d3 ea                	shr    %cl,%edx
  803543:	09 d0                	or     %edx,%eax
  803545:	89 e9                	mov    %ebp,%ecx
  803547:	d3 eb                	shr    %cl,%ebx
  803549:	89 da                	mov    %ebx,%edx
  80354b:	83 c4 1c             	add    $0x1c,%esp
  80354e:	5b                   	pop    %ebx
  80354f:	5e                   	pop    %esi
  803550:	5f                   	pop    %edi
  803551:	5d                   	pop    %ebp
  803552:	c3                   	ret    
  803553:	90                   	nop
  803554:	89 fd                	mov    %edi,%ebp
  803556:	85 ff                	test   %edi,%edi
  803558:	75 0b                	jne    803565 <__umoddi3+0xe9>
  80355a:	b8 01 00 00 00       	mov    $0x1,%eax
  80355f:	31 d2                	xor    %edx,%edx
  803561:	f7 f7                	div    %edi
  803563:	89 c5                	mov    %eax,%ebp
  803565:	89 f0                	mov    %esi,%eax
  803567:	31 d2                	xor    %edx,%edx
  803569:	f7 f5                	div    %ebp
  80356b:	89 c8                	mov    %ecx,%eax
  80356d:	f7 f5                	div    %ebp
  80356f:	89 d0                	mov    %edx,%eax
  803571:	e9 44 ff ff ff       	jmp    8034ba <__umoddi3+0x3e>
  803576:	66 90                	xchg   %ax,%ax
  803578:	89 c8                	mov    %ecx,%eax
  80357a:	89 f2                	mov    %esi,%edx
  80357c:	83 c4 1c             	add    $0x1c,%esp
  80357f:	5b                   	pop    %ebx
  803580:	5e                   	pop    %esi
  803581:	5f                   	pop    %edi
  803582:	5d                   	pop    %ebp
  803583:	c3                   	ret    
  803584:	3b 04 24             	cmp    (%esp),%eax
  803587:	72 06                	jb     80358f <__umoddi3+0x113>
  803589:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80358d:	77 0f                	ja     80359e <__umoddi3+0x122>
  80358f:	89 f2                	mov    %esi,%edx
  803591:	29 f9                	sub    %edi,%ecx
  803593:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803597:	89 14 24             	mov    %edx,(%esp)
  80359a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80359e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035a2:	8b 14 24             	mov    (%esp),%edx
  8035a5:	83 c4 1c             	add    $0x1c,%esp
  8035a8:	5b                   	pop    %ebx
  8035a9:	5e                   	pop    %esi
  8035aa:	5f                   	pop    %edi
  8035ab:	5d                   	pop    %ebp
  8035ac:	c3                   	ret    
  8035ad:	8d 76 00             	lea    0x0(%esi),%esi
  8035b0:	2b 04 24             	sub    (%esp),%eax
  8035b3:	19 fa                	sbb    %edi,%edx
  8035b5:	89 d1                	mov    %edx,%ecx
  8035b7:	89 c6                	mov    %eax,%esi
  8035b9:	e9 71 ff ff ff       	jmp    80352f <__umoddi3+0xb3>
  8035be:	66 90                	xchg   %ax,%ax
  8035c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035c4:	72 ea                	jb     8035b0 <__umoddi3+0x134>
  8035c6:	89 d9                	mov    %ebx,%ecx
  8035c8:	e9 62 ff ff ff       	jmp    80352f <__umoddi3+0xb3>
