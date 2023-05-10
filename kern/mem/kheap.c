#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"

//==================================================================//
//==================================================================//
//NOTE: All kernel heap allocations are multiples of PAGE_SIZE (4KB)//
//==================================================================//
//==================================================================//

void initialize_dyn_block_system()
{

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
		LIST_INIT(&FreeMemBlocksList);
		LIST_INIT(&AllocMemBlocksList);
		/*[2] Dynamically allocate the array of MemBlockNodes
		 * 	remember to:
		 * 		1. set MAX_MEM_BLOCK_CNT with the chosen size of the array
		 * 		2. allocation should be aligned on PAGE boundary
		 * 	HINT: can use alloc_chunk(...) function
		 */
	    MAX_MEM_BLOCK_CNT=NUM_OF_KHEAP_PAGES;
	    MemBlockNodes =(struct MemBlock*)KERNEL_HEAP_START ;
		allocate_chunk(ptr_page_directory,KERNEL_HEAP_START,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_WRITEABLE);
		//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);//total num of MBN
		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
		block_node->sva = (KERNEL_HEAP_START + ROUNDUP(sizeof(struct MemBlock)*MAX_MEM_BLOCK_CNT,PAGE_SIZE)) ;
		block_node->size = ((KERNEL_HEAP_MAX - KERNEL_HEAP_START))-(ROUNDUP(sizeof(struct MemBlock)*MAX_MEM_BLOCK_CNT,PAGE_SIZE));
		//[4] Insert a new MemBlock with the remaining heap size into the FreeMemBlocksList
		insert_sorted_with_merge_freeList(block_node);
}
void* kmalloc(unsigned int size)
{
	size= ROUNDUP(size,PAGE_SIZE);
		if(isKHeapPlacementStrategyFIRSTFIT())
		{
			struct MemBlock * ff_block = alloc_block_FF(size);
			if(ff_block!=NULL)
			{
				insert_sorted_allocList(ff_block);
				int var = allocate_chunk(ptr_page_directory,ff_block->sva,size,PERM_WRITEABLE);
				if(var == 0) // allocated well
					return (void*) ff_block->sva ;
				else
						return (void*) NULL ;
			}
		}
		else
		{
			struct MemBlock * bf_block = alloc_block_BF(size);
			if(bf_block!=NULL)
			{
				insert_sorted_allocList(bf_block);

				int var = allocate_chunk(ptr_page_directory,bf_block->sva,size,PERM_WRITEABLE);
				if(var == 0) // allocated well
					return (void*) bf_block->sva ;
				else
					return (void*) NULL ;
			}
		}
		return (void*) NULL ;

		//change this "return" according to your answer

}

void kfree(void* virtual_address)
{struct MemBlock  *element , *tmp_block;
LIST_FOREACH(element, &(AllocMemBlocksList))
{
	if(element->sva == (uint32)virtual_address)
	 {
		 tmp_block=element ;
		  if(tmp_block!=NULL)
		  {
			  LIST_REMOVE(&(AllocMemBlocksList),element);
           for(int va =(int)virtual_address ; va <ROUNDDOWN((int)virtual_address +(int)tmp_block->size,PAGE_SIZE);va+=PAGE_SIZE)
           	   {unmap_frame(ptr_page_directory,(uint32)va);}

			 insert_sorted_with_merge_freeList(tmp_block);
		  }
		 break;
	}
}
}








unsigned int kheap_virtual_address(unsigned int physical_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kheap_virtual_address
	// Write your code here, remove the panic and write your code
	struct FrameInfo * ptr_frame_info ;
			ptr_frame_info = to_frame_info(physical_address);
			uint32 *ptr_page_table = NULL ;
			struct FrameInfo *ptr_Frame_Info = get_frame_info(ptr_page_directory,ptr_frame_info->va, &ptr_page_table) ;
			if (ptr_Frame_Info == NULL)
			{
				return 0;
			}
			else
			{
				return ptr_Frame_Info->va;
			}

	//return the virtual address corresponding to given physical_address
	//refer to the project presentation and documentation for details
	//EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED ==================
}

unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kheap_physical_address
	// Write your code here, remove the panic and write your code
	uint32 *ptr_tabels = NULL;
		get_page_table(ptr_page_directory,virtual_address,&ptr_tabels);
		if (ptr_tabels !=NULL)
		{
		  int physical_addr = virtual_to_physical(ptr_page_directory,virtual_address);
		  return physical_addr ;
		}
	return 0 ;


	//return the physical address corresponding to given virtual_address
	//refer to the project presentation and documentation for details
}


void kfreeall()
{
	panic("Not implemented!");

}

void kshrink(uint32 newSize)
{
	panic("Not implemented!");
}

void kexpand(uint32 newSize)
{
	panic("Not implemented!");
}




//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

void *krealloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT MS2 - BONUS] [KERNEL HEAP] krealloc
	// Write your code here, remove the panic and write your code
	panic("krealloc() is not implemented yet...!!");
}
