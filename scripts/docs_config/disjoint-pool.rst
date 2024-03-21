.. highlight:: c
    :linenothreshold: 10

==============================================================================
Disjoint pool
==============================================================================

The Disjoint pool is a pool allocator. Slabs represent the allocated
memory blocks. Internally, the memory block are split into chunks. The number of
chunks depends of the size of a Bucket which created the Slab. Bucket contains
a list of the available slabs, that is slabs which have at least 1 available chunk.
Bucket has a constant size, which signifies the size of the memory block supported
by this bucket.

Buckets
------------------------------------------------------------------------------

The `MinBucketSize` parameter means the minimal size of the available buckets.
The largest size which is allocated via the allocator is signified by the
`CutOff` parameter. Allocations with size larger than `CutOff` bypass the
pool and go directly to the provider. Buckets are generated with sizes going
from `MinBucketSize` to `CutOff` as powers of 2 and the values halfway between
the powers of 2 such as `64, 96, 128, 192, ..., CutOff`. The default `MinBucketSize`
is 8. Buckets sized smaller than the bucket default size are not supported.
MinBucketSize parameter must be a power of 2 for bucket sizes to generate correctly.
For allocating memory the smallest sized bucket larger than the size of the allocated
memory is chosen. Buckets can be used in chunked form or as full slabs. 
For buckets used in chunked mode, a counter of slabs in the pool is used while for
allocations that use an entire slab each, the entries in the `Available list` variable
are entries in the pool.Each slab is available for a new allocation.The size of the 
`Available list`` is the size of the pool. For allocations that use slabs in chunked mode,
slabs will be in the `Available list`` if any one or more of their chunks is free.
The entire slab is not necessarily free, just some chunks in the slab are free.

Allocating memory
------------------------------------------------------------------------------
Allocations are a minimum of 4KB/64KB/2MB even when a smaller size is
requested. The implementation distinguishes between allocations of size
`ChunkCutOff = (minimum-alloc-size / 2)` and those that are larger.
Allocation requests smaller than `ChunkCutoff`` use chunks taken from a single
coarse-grain allocation. Thus, for example, for a 64KB minimum allocation
size, and 8-byte allocations, only 1 in ~8000 requests results in a new
coarse-grain allocation. Freeing results only in a chunk of a larger
allocation to be marked as available and no real return to the system. An
allocation is returned to the system only when all chunks in the larger
allocation are freed by the program. Allocations larger than `ChunkCutOff` use
a separate coarse-grain allocation for each request. These are subject to
"pooling". That is, when such an allocation is freed by the program it is
retained in a pool. The pool is available for future allocations, which means
there are fewer actual coarse-grain allocations/deallocations.
Fo allocation, memory provider has to be created first. The we can create
the memory pool, which obtains memory provider as a parameter. Then to allocate
memory we use one of the operations supported by the pool.

Supported operations
------------------------------------------------------------------------------
For allocating memory the Disjoint pool supports `malloc` and `aligned malloc`
operations.

.. _src/pool/pool_disjoint.c: https://github.com/oneapi-src/unified-memory-framework/blob/main/src/pool/pool_disjoint.cpp
