package com.time_float_backend.mapper;

import com.time_float_backend.entity.Bottle;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BottleMapper {
    
    int insert(Bottle bottle);
    
    Bottle findById(@Param("id") Long id);
    
    Bottle pickRandomBottle(@Param("excludeUserId") Long excludeUserId);
    
    List<Bottle> findByUserId(@Param("userId") Long userId);
    
    List<Bottle> findByPickedUserId(@Param("pickedUserId") Long pickedUserId);
    
    int update(Bottle bottle);
    
    int deleteById(@Param("id") Long id);
}
