/*
 * dyn_block_management.c
 *
 *  Created on: Sep 21, 2022
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"


//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
	cprintf("\n=========================================\n");

}

//********************************************************************************//
//********************************************************************************//

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
	}

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);

	if((x==0))
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);

		break;}

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
		break;
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}










//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
//		struct MemBlock  *element,*tmp_block;
//		LIST_FOREACH(element, &(FreeMemBlocksList))
//		{
//			// case 2
//			if(element->size==size)
//			{
//				tmp_block=element;
//				LIST_REMOVE(&FreeMemBlocksList,element);
//				return tmp_block;
//				break;
//			}
//
//			// case 3
//			else if(element->size > size)
//			{
//				tmp_block= AvailableMemBlocksList.lh_first;
//				LIST_REMOVE(&(AvailableMemBlocksList),AvailableMemBlocksList.lh_first);
//				tmp_block->sva=element->sva;
//				tmp_block->size=size;
//				element->size=size;
//				element->sva=element->sva+size;
//
//			return tmp_block;
//			break;}
//		}
//		// case 1
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
		{
			// case 2
				if(element->size == size)
				{
					tmp_block=element;
					LIST_REMOVE(&FreeMemBlocksList,element);
					return tmp_block;
				}
				 // case 3
				else if(element->size > size)
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
					tmp_block->sva=element->sva;
					tmp_block->size=size;
					//update block with remaining space
					element->size-=size;
					element->sva = element->sva + size;
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}


//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
		{
			if(element->size >= size)
			{
				if(best_size==-1)
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
			{
			 if((best_size > size) && (best_size == element->size))
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
				tmp_block->sva=element->sva;
				tmp_block->size=size;
				//update block with remaining space
				element->size-=size;
				element->sva = element->sva + size;
				// return back the new block
				return tmp_block ;

			  }
			else if((element->size == best_size)&&(best_size == size))
			  {
				tmp_block=element;
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");

}

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));

if(LIST_EMPTY(&(FreeMemBlocksList)))
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
                {

                	first->sva = blockToInsert->sva;
                	first->size = first->size + blockToInsert->size;
                	blockToInsert->size = blockToInsert->sva = 0;
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
 	{

				if(last->sva + last->size == blockToInsert->sva)
				{

					last->size = last->size + blockToInsert->size;
					blockToInsert->size = blockToInsert->sva = 0;
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
				}


	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
				{
				     next=LIST_NEXT(blk_itr);


					if( (blockToInsert->sva > blk_itr->sva) )
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
								break;

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
								 blockToInsert->size=blockToInsert->sva=0;
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
								 break;

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
							{
								next->size = next->size + blockToInsert->size;
								next->sva = blockToInsert->sva;

								blockToInsert->size = blockToInsert->sva = 0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
								break;
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
								blockToInsert->size = blockToInsert->sva=0;
								next->size = next->sva = 0;
								LIST_REMOVE(&FreeMemBlocksList, next);
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
								break;
							}

						}
				}
        }

}
}

