PLATFORM ?= linux_x86_64

CC=gcc


CFLAGS +=-Wall 
CFLAGS +=-Wextra 
CFLAGS += -pedantic 
CFLAGS += -O3
CFLAGS += -fomit-frame-pointer # could speed up functions

LIBS=-lalloc


-include config/$(PLATFORM).mk


TARGET_IO = libactio.a
CACHE=.cache
OUTPUT=$(CACHE)/release


MODULE_IO += json.o


TEST += test.o


OBJ_IO=$(addprefix $(CACHE)/,$(MODULE_IO))
OBJ += $(OBJ_IO) 
T_OBJ=$(addprefix $(CACHE)/,$(TEST))


$(CACHE)/%.o:
	$(CC) $(CFLAGS) -c $< -o $@


all: env $(OBJ)
	ar -crs $(OUTPUT)/$(TARGET_IO) $(OBJ_IO)


-include dep.list


.PHONY: env dep clean install


dep:
	find src test -name "*.c" | xargs $(CC) -MM | sed 's|[a-zA-Z0-9_-]*\.o|$(CACHE)/&|' > dep.list


exec: env $(T_OBJ) $(OBJ)
	$(CC) $(CFLAGS) $(T_OBJ) $(OBJ) $(LIBS) -o $(OUTPUT)/test
	$(OUTPUT)/test


install:
	mkdir -pv $(LIB_PATH) 
	mkdir -pv $(INCLUDE_PATH) 
	cp -v $(OUTPUT)/$(TARGET) $(LIB_PATH)/$(TARGET)
	cp -v pkgconfig/$(PC_FILE) $(PC_PATH)/act.pc
	#cp -v src/json.h $(INCLUDE_PATH)/json.h


env:
	mkdir -pv $(CACHE)
	mkdir -pv $(OUTPUT)


clean: 
	rm -rvf $(CACHE)



