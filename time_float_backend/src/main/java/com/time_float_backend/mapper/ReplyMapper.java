package com.time_float_backend.mapper;

import com.time_float_backend.entity.Reply;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ReplyMapper {
    
    int insert(Reply reply);
    
    List<Reply> findByBottleId(@Param("bottleId") Long bottleId);
}
