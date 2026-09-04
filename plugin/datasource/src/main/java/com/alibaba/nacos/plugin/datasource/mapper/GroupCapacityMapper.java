/*
 * Copyright 1999-2022 Alibaba Group Holding Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.alibaba.nacos.plugin.datasource.mapper;

import com.alibaba.nacos.common.utils.CollectionUtils;
import com.alibaba.nacos.common.utils.NamespaceUtil;
import com.alibaba.nacos.plugin.datasource.constants.FieldConstant;
import com.alibaba.nacos.plugin.datasource.constants.TableConstant;
import com.alibaba.nacos.plugin.datasource.model.MapperContext;
import com.alibaba.nacos.plugin.datasource.model.MapperResult;

import java.util.ArrayList;
import java.util.List;

/**
 * The group capacity info mapper.
 *
 * <p>Upstream U1 shape: only {@link #selectGroupInfoBySize(MapperContext)} stays abstract;
 * the rest of the statements are provided as default methods with un-quoted {@code usage}.
 * Dialects that need quoting (XuGu) override the defaults.
 *
 * @author lixiaoshuang
 */
public interface GroupCapacityMapper extends Mapper {

    /**
     * Get GroupCapacity List, only including id and groupId value.
     * The default sql:
     * SELECT id, group_id FROM group_capacity WHERE id > ? LIMIT ?
     *
     * @param context sql paramMap
     * @return The sql of getting GroupCapacity List, only including id and groupId value.
     */
    MapperResult selectGroupInfoBySize(MapperContext context);

    /**
     * Insert into select.
     * The default sql:
     * INSERT INTO group_capacity (group_id, quota, `usage`, max_size, max_aggr_count, max_aggr_size,
     * gmt_create, gmt_modified) SELECT ?, ?, count(*), ?, ?, ?, ?, ? FROM config_info
     *
     * @param context sql paramMap
     * @return The sql of inserting into select.
     */
    default MapperResult insertIntoSelect(MapperContext context) {
        List<Object> paramList = new ArrayList<>();
        paramList.add(context.getUpdateParameter(FieldConstant.GROUP_ID));
        paramList.add(context.getUpdateParameter(FieldConstant.QUOTA));
        paramList.add(context.getUpdateParameter(FieldConstant.MAX_SIZE));
        paramList.add(context.getUpdateParameter(FieldConstant.MAX_AGGR_COUNT));
        paramList.add(context.getUpdateParameter(FieldConstant.MAX_AGGR_SIZE));
        paramList.add(context.getUpdateParameter(FieldConstant.GMT_CREATE));
        paramList.add(context.getUpdateParameter(FieldConstant.GMT_MODIFIED));

        return new MapperResult(
                "INSERT INTO group_capacity (group_id, quota, usage, max_size, max_aggr_count, max_aggr_size,"
                        + " gmt_create, gmt_modified) SELECT ?, ?, count(*), ?, ?, ?, ?, ? FROM config_info",
                paramList);
    }

    /**
     * Insert into select by where.
     * The default sql:
     * INSERT INTO group_capacity (group_id, quota, `usage`, max_size, max_aggr_count, max_aggr_size,
     * gmt_create, gmt_modified) SELECT ?, ?, count(*), ?, ?, ?, ?, ? FROM config_info WHERE group_id=? AND tenant_id
     * = 'a'
     *
     * @param context sql paramMap
     * @return The sql of inserting into select by where.
     */
    default MapperResult insertIntoSelectByWhere(MapperContext context) {
        List<Object> paramList = new ArrayList<>();
        final String sql =
                "INSERT INTO group_capacity (group_id, quota, usage, max_size, max_aggr_count, max_aggr_size, gmt_create,"
                        + " gmt_modified) SELECT ?, ?, count(*), ?, ?, ?, ?, ? FROM config_info WHERE group_id=? AND tenant_id = '"
                        + NamespaceUtil.getNamespaceDefaultId() + "'";
        paramList.add(context.getUpdateParameter(FieldConstant.GROUP_ID));
        paramList.add(context.getUpdateParameter(FieldConstant.QUOTA));
        paramList.add(context.getUpdateParameter(FieldConstant.MAX_SIZE));
        paramList.add(context.getUpdateParameter(FieldConstant.MAX_AGGR_COUNT));
        paramList.add(context.getUpdateParameter(FieldConstant.MAX_AGGR_SIZE));
        paramList.add(context.getUpdateParameter(FieldConstant.GMT_CREATE));
        paramList.add(context.getUpdateParameter(FieldConstant.GMT_MODIFIED));
        paramList.add(context.getWhereParameter(FieldConstant.GROUP_ID));

        return new MapperResult(sql, paramList);
    }

    /**
     * Increment UsageWithDefaultQuotaLimit.
     * The default sql:
     * UPDATE group_capacity SET `usage` = `usage` + 1, gmt_modified = ? WHERE group_id = ? AND `usage` < ? AND quota = 0
     *
     * @param context sql paramMap
     * @return The sql of increment UsageWithDefaultQuotaLimit.
     */
    default MapperResult incrementUsageByWhereQuotaEqualZero(MapperContext context) {
        return new MapperResult(
                "UPDATE group_capacity SET usage = usage + 1, gmt_modified = ? WHERE group_id = ? AND usage < ? AND quota = 0",
                CollectionUtils.list(context.getUpdateParameter(FieldConstant.GMT_MODIFIED),
                        context.getWhereParameter(FieldConstant.GROUP_ID),
                        context.getWhereParameter(FieldConstant.USAGE)));
    }

    /**
     * Increment UsageWithQuotaLimit.
     * The default sql:
     * UPDATE group_capacity SET `usage` = `usage` + 1, gmt_modified = ? WHERE group_id = ? AND `usage` < quota AND
     * quota != 0
     *
     * @param context sql paramMap
     * @return The sql of Increment UsageWithQuotaLimit.
     */
    default MapperResult incrementUsageByWhereQuotaNotEqualZero(MapperContext context) {
        return new MapperResult(
                "UPDATE group_capacity SET usage = usage + 1, gmt_modified = ? WHERE group_id = ? AND usage < quota AND quota != 0",
                CollectionUtils.list(context.getUpdateParameter(FieldConstant.GMT_MODIFIED),
                        context.getWhereParameter(FieldConstant.GROUP_ID)));
    }

    /**
     * Increment Usage.
     * The default sql:
     * UPDATE group_capacity SET `usage` = `usage` + 1, gmt_modified = ? WHERE group_id = ?
     *
     * @param context sql paramMap
     * @return The sql of increment UsageWithQuotaLimit.
     */
    default MapperResult incrementUsageByWhere(MapperContext context) {
        return new MapperResult("UPDATE group_capacity SET usage = usage + 1, gmt_modified = ? WHERE group_id = ?",
                CollectionUtils.list(context.getUpdateParameter(FieldConstant.GMT_MODIFIED),
                        context.getWhereParameter(FieldConstant.GROUP_ID)));
    }

    /**
     * Decrement Usage.
     * The default sql:
     * UPDATE group_capacity SET `usage` = `usage` - 1, gmt_modified = ? WHERE group_id = ? AND `usage` > 0
     *
     * @param context sql paramMap
     * @return The sql of decrement Usage.
     */
    default MapperResult decrementUsageByWhere(MapperContext context) {
        return new MapperResult(
                "UPDATE group_capacity SET usage = usage - 1, gmt_modified = ? WHERE group_id = ? AND usage > 0",
                CollectionUtils.list(context.getUpdateParameter(FieldConstant.GMT_MODIFIED),
                        context.getWhereParameter(FieldConstant.GROUP_ID)));
    }

    /**
     * Update Usage.
     * The default sql:
     * UPDATE group_capacity SET `usage` = (SELECT count(*) FROM config_info), gmt_modified = ? WHERE group_id = ?
     *
     * @param context sql paramMap
     * @return The sql of updating Usage.
     */
    default MapperResult updateUsage(MapperContext context) {
        return new MapperResult(
                "UPDATE group_capacity SET usage = (SELECT count(*) FROM config_info), gmt_modified = ? WHERE group_id = ?",
                CollectionUtils.list(context.getUpdateParameter(FieldConstant.GMT_MODIFIED),
                        context.getWhereParameter(FieldConstant.GROUP_ID)));
    }

    /**
     * Update Usage by where.
     * The default sql:
     * UPDATE group_capacity SET `usage` =  (SELECT count(*) FROM config_info WHERE group_id=? AND tenant_id = 'a'),
     * gmt_modified = ? WHERE group_id= ?
     *
     * @param context sql paramMap
     * @return The sql of updating Usage by where.
     */
    default MapperResult updateUsageByWhere(MapperContext context) {
        return new MapperResult(
                "UPDATE group_capacity SET usage = (SELECT count(*) FROM config_info WHERE group_id=? AND tenant_id = '"
                        + NamespaceUtil.getNamespaceDefaultId() + "')," + " gmt_modified = ? WHERE group_id= ?",
                CollectionUtils.list(context.getWhereParameter(FieldConstant.GROUP_ID),
                        context.getUpdateParameter(FieldConstant.GMT_MODIFIED),
                        context.getWhereParameter(FieldConstant.GROUP_ID)));
    }

    /**
     * Get table name.
     *
     * @return table name
     */
    default String getTableName() {
        return TableConstant.GROUP_CAPACITY;
    }
}
