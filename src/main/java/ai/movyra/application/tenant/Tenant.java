package application.tenant;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "tenants", schema = "app")
public class Tenant extends PanacheEntityBase {

    @Id
    @Column(name = "id")
    public UUID id;

    @Column(name = "slug", nullable = false, unique = true)
    public String slug;

    @Column(name = "name", nullable = false)
    public String name;

    @Column(name = "phone")
    public String phone;

    @Column(name = "timezone")
    public String timezone;

    @Column(name = "is_active")
    public Boolean isActive;

    @Column(name = "created_at")
    public OffsetDateTime createdAt;

    public static Tenant findBySlug(String slug) {
        return find("slug", slug).firstResult();
    }
}

